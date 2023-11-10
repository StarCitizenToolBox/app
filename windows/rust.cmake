# We include Corrosion inline here, but ideally in a project with
# many dependencies we would need to install Corrosion on the system.
# See instructions on https://github.com/AndrewGaspar/corrosion#cmake-install
# Once done, uncomment this line:
# find_package(Corrosion REQUIRED)

add_subdirectory(./corrosion)

corrosion_import_crate(MANIFEST_PATH ../rust/Cargo.toml IMPORTED_CRATES imported_crates)
target_link_libraries(${BINARY_NAME} PRIVATE ${imported_crates})
foreach(imported_crate ${imported_crates})
  list(APPEND PLUGIN_BUNDLED_LIBRARIES $<TARGET_FILE:${imported_crate}-shared>)
endforeach()