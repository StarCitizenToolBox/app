param(
    [switch]$SkipPubGet,
    [switch]$SkipCodegen,
    [switch]$SkipIntl,
    [switch]$SkipWindowsBuild,
    [switch]$SkipMsix,
    [switch]$NoMsixStore,
    [switch]$UpdateCargo,
    [string]$CargoProfile = "dist",
    [string[]]$WindowsBuildArgs = @("--dart-define=MSE=true"),
    [string]$MsixOutputPath = "",
    [string]$MsixOutputName = ""
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
    param(
        [string]$Name,
        [scriptblock]$Command
    )

    Write-Host ""
    Write-Host "==> $Name" -ForegroundColor Cyan
    & $Command
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$previousCargoProfile = $env:CARGOKIT_CARGO_PROFILE
$env:CARGOKIT_CARGO_PROFILE = $CargoProfile

try {
    Write-Host "Release build root: $repoRoot"
    Write-Host "Rust Cargo profile: $env:CARGOKIT_CARGO_PROFILE"

    if (-not $SkipPubGet) {
        Invoke-Step "Flutter pub get" {
            flutter pub get
        }
    }

    if (-not $SkipCodegen) {
        Invoke-Step "Dart code generation" {
            dart run build_runner build --delete-conflicting-outputs
        }
    }

    Invoke-Step "Flutter Rust Bridge generation" {
        flutter_rust_bridge_codegen generate
    }

    if ($UpdateCargo) {
        Invoke-Step "Cargo update" {
            Push-Location (Join-Path $repoRoot "rust")
            try {
                cargo update
            } finally {
                Pop-Location
            }
        }
    }

    if (-not $SkipIntl) {
        Invoke-Step "Flutter intl generation" {
            flutter pub global activate intl_utils
            flutter pub global run intl_utils:generate
        }
    }

    if (-not $SkipWindowsBuild) {
        Invoke-Step "Flutter Windows release build" {
            flutter build windows -v @WindowsBuildArgs
        }
    }

    if (-not $SkipMsix) {
        Invoke-Step "MSIX package" {
            $msixArgs = @("run", "msix:create", "--build-windows", "false")

            if (-not $NoMsixStore) {
                $msixArgs += "--store"
            }

            if ($MsixOutputPath.Trim().Length -gt 0) {
                $msixArgs += @("--output-path", $MsixOutputPath)
            }

            if ($MsixOutputName.Trim().Length -gt 0) {
                $msixArgs += @("--output-name", $MsixOutputName)
            }

            dart @msixArgs
        }
    }

    Write-Host ""
    Write-Host "Release build finished." -ForegroundColor Green
} finally {
    if ($null -eq $previousCargoProfile) {
        Remove-Item Env:CARGOKIT_CARGO_PROFILE -ErrorAction SilentlyContinue
    } else {
        $env:CARGOKIT_CARGO_PROFILE = $previousCargoProfile
    }
}
