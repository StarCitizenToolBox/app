# Project-level configuration.
cmake_minimum_required(VERSION 3.14)
project(starcitizen_doctor LANGUAGES CXX)

# The name of the executable created for the application. Change this to change
# the on-disk name of your application.
set(BINARY_NAME "starcitizen_doctor")

# Explicitly opt in to modern CMake behaviors to avoid warnings with recent
# versions of CMake.
cmake_policy(SET CMP0063 NEW)
if(POLICY CMP0175)
  # Compatibility for flutter_inappwebview_windows:
  # it still uses add_custom_command(TARGET ... DEPENDS ...).
  cmake_policy(SET CMP0175 OLD)
endif()
# Equivalent to CMake -Wno-dev for third-party plugin scripts.
set(CMAKE_SUPPRESS_DEVELOPER_WARNINGS 1 CACHE INTERNAL "No dev warnings")

# Define build configuration option.
get_property(IS_MULTICONFIG GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
if(IS_MULTICONFIG)
  set(CMAKE_CONFIGURATION_TYPES "Debug;Profile;Release"
    CACHE STRING "" FORCE)
else()
  if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    set(CMAKE_BUILD_TYPE "Debug" CACHE
      STRING "Flutter build mode" FORCE)
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
      "Debug" "Profile" "Release")
  endif()
endif()
# Define settings for the Profile build mode.
set(CMAKE_EXE_LINKER_FLAGS_PROFILE "${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
set(CMAKE_SHARED_LINKER_FLAGS_PROFILE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELEASE}")
set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELEASE}")


# Use Unicode for all projects.
add_definitions(-DUNICODE -D_UNICODE)

# Compilation settings that should be applied to most targets.
#
# Be cautious about adding new options here, as plugins use this function by
# default. In most cases, you should add new options to specific targets instead
# of modifying this function.
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

# Flutter library and tool build rules.
set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
add_subdirectory(${FLUTTER_MANAGED_DIR})

# Application build; see runner/CMakeLists.txt.
add_subdirectory("runner")

# Generated plugin build rules, which manage building the plugins and adding
# them to the application.
include(flutter/generated_plugins.cmake)
# === Installation ===
# Support files are copied into place next to the executable, so that it can
# run in place. This is done instead of making a separate bundle (as on Linux)
# so that building and running from within Visual Studio will work.
set(BUILD_BUNDLE_DIR "$<TARGET_FILE_DIR:${BINARY_NAME}>")
# Make the "install" step default, as it's required to run.
set(CMAKE_VS_INCLUDE_INSTALL_TO_DEFAULT_BUILD 1)
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${BUILD_BUNDLE_DIR}" CACHE PATH "..." FORCE)
endif()

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

install(TARGETS ${BINARY_NAME} RUNTIME DESTINATION "${CMAKE_INSTALL_PREFIX}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_ICU_DATA_FILE}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  COMPONENT Runtime)

install(FILES "${FLUTTER_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

if(PLUGIN_BUNDLED_LIBRARIES)
  install(FILES "${PLUGIN_BUNDLED_LIBRARIES}"
    DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
    COMPONENT Runtime)
endif()

# Fully re-copy the assets directory on each build to avoid having stale files
# from a previous install.
set(FLUTTER_ASSET_DIR_NAME "flutter_assets")
install(CODE "
  file(REMOVE_RECURSE \"${INSTALL_BUNDLE_DATA_DIR}/${FLUTTER_ASSET_DIR_NAME}\")
  " COMPONENT Runtime)
install(DIRECTORY "${PROJECT_BUILD_DIR}/${FLUTTER_ASSET_DIR_NAME}"
  DESTINATION "${INSTALL_BUNDLE_DATA_DIR}" COMPONENT Runtime)

# Install the AOT library on non-Debug builds only.
install(FILES "${AOT_LIBRARY}" DESTINATION "${INSTALL_BUNDLE_DATA_DIR}"
  CONFIGURATIONS Profile;Release
  COMPONENT Runtime)

# === Bundled runtime DLLs ===
# Ship the MSVC runtime next to the executable, so it starts on systems that
# lack (or have a broken) Visual C++ Redistributable. Copied from the system's
# own copies at configure time; a missing file fails the build.
file(TO_CMAKE_PATH "$ENV{SystemRoot}/System32" SCTOOLBOX_SYSTEM_RUNTIME_DIR)
set(SCTOOLBOX_RUNTIME_DLLS)
foreach(dll msvcp140.dll msvcp140_1.dll vcruntime140.dll vcruntime140_1.dll)
  set(dll_path "${SCTOOLBOX_SYSTEM_RUNTIME_DIR}/${dll}")
  if(NOT EXISTS "${dll_path}")
    message(FATAL_ERROR "Runtime DLL not found: ${dll_path}")
  endif()
  list(APPEND SCTOOLBOX_RUNTIME_DLLS "${dll_path}")
endforeach()

# msvcp140_app.dll is not part of the desktop redistributable; it ships in the
# Microsoft.VCLibs.140.00 framework package, together with the two
# vcruntime*_app.dll it imports. SCTOOLBOX_VCLIBS_DIR (environment) can point
# at a folder holding them, e.g. extracted from the VS UWP extension SDK appx
# on CI. Otherwise ask Appx for the newest installed x64 package, since
# WindowsApps cannot be listed.
if(DEFINED ENV{SCTOOLBOX_VCLIBS_DIR} AND NOT "$ENV{SCTOOLBOX_VCLIBS_DIR}" STREQUAL "")
  set(SCTOOLBOX_VCLIBS_DIR "$ENV{SCTOOLBOX_VCLIBS_DIR}")
else()
  execute_process(
    COMMAND powershell -NoProfile -NonInteractive -Command
      "(Get-AppxPackage -Name 'Microsoft.VCLibs.140.00' | Where-Object Architecture -eq 'X64' | Sort-Object Version -Descending | Select-Object -First 1).InstallLocation"
    OUTPUT_VARIABLE SCTOOLBOX_VCLIBS_DIR
    OUTPUT_STRIP_TRAILING_WHITESPACE
    RESULT_VARIABLE vclibs_result)
  if(NOT vclibs_result EQUAL 0 OR SCTOOLBOX_VCLIBS_DIR STREQUAL "")
    message(FATAL_ERROR
      "The Microsoft.VCLibs.140.00 (x64) framework package is not installed; "
      "it provides msvcp140_app.dll. Install it or set SCTOOLBOX_VCLIBS_DIR.")
  endif()
endif()
file(TO_CMAKE_PATH "${SCTOOLBOX_VCLIBS_DIR}" SCTOOLBOX_VCLIBS_DIR)
message(STATUS "VCLibs app runtime from: ${SCTOOLBOX_VCLIBS_DIR}")
foreach(dll msvcp140_app.dll vcruntime140_app.dll vcruntime140_1_app.dll)
  set(dll_path "${SCTOOLBOX_VCLIBS_DIR}/${dll}")
  if(NOT EXISTS "${dll_path}")
    message(FATAL_ERROR "Runtime DLL not found: ${dll_path}")
  endif()
  list(APPEND SCTOOLBOX_RUNTIME_DLLS "${dll_path}")
endforeach()

install(FILES ${SCTOOLBOX_RUNTIME_DLLS}
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)

# Empty DirectML.dll placeholder for the prebuilt ONNX Runtime. Downloaded once
# into the build tree and pinned by hash; a failed download is retried from the
# same URL and then fails the build.
set(SCTOOLBOX_DIRECTML_URL
  "https://github.com/StarCitizenToolBox/Empty_DirectMLdll/releases/download/Empty_v1/DirectML.dll")
set(SCTOOLBOX_DIRECTML_SHA256
  "07766ef81f0057764dcfe9a0eb8f383bfe0420ea3bd35248ac5e1a1ffe3ebe0c")
set(SCTOOLBOX_DIRECTML_DLL "${CMAKE_BINARY_DIR}/third_party/DirectML.dll")
set(directml_hash "")
if(EXISTS "${SCTOOLBOX_DIRECTML_DLL}")
  file(SHA256 "${SCTOOLBOX_DIRECTML_DLL}" directml_hash)
endif()
if(NOT directml_hash STREQUAL SCTOOLBOX_DIRECTML_SHA256)
  set(directml_error "")
  foreach(attempt RANGE 1 3)
    file(DOWNLOAD "${SCTOOLBOX_DIRECTML_URL}" "${SCTOOLBOX_DIRECTML_DLL}"
      EXPECTED_HASH SHA256=${SCTOOLBOX_DIRECTML_SHA256}
      TLS_VERIFY ON
      TIMEOUT 120
      STATUS directml_status)
    list(GET directml_status 0 directml_code)
    if(directml_code EQUAL 0)
      set(directml_error "")
      break()
    endif()
    list(GET directml_status 1 directml_error)
    message(WARNING
      "DirectML.dll download attempt ${attempt}/3 failed: ${directml_error}")
  endforeach()
  if(NOT directml_error STREQUAL "")
    file(REMOVE "${SCTOOLBOX_DIRECTML_DLL}")
    message(FATAL_ERROR
      "Could not download DirectML.dll from ${SCTOOLBOX_DIRECTML_URL}: "
      "${directml_error}")
  endif()
endif()
install(FILES "${SCTOOLBOX_DIRECTML_DLL}"
  DESTINATION "${INSTALL_BUNDLE_LIB_DIR}"
  COMPONENT Runtime)
