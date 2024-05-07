$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_preset_files {
    param([Parameter(Mandatory=$false)] [string] $filter = "*.ps1")

    $presetsDir = "$PMA_HOME/presets"
    if (-not (Test-Path $presetsDir)) {
        return @()
    }

    return Get-ChildItem -Path $presetsDir -Filter $filter
}

function list_packages {
    return list_preset_files -filter "*.ps1" | Select-Object -ExpandProperty BaseName
}

#
# Install
#

function install_adapter {

}

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages)

    if ($packages -contains "all") {
        $packages = list_packages
    }

    Set-Alias -Name pma -Value invoke_pma -Option AllScope

    foreach ($package in $packages) {
        $presetScript = list_preset_files "$package.ps1"

        if(-not $presetScript) {
            Write-Host "Error: No preset package named: $package" -ForegroundColor Red
            exit 1
        }

        & $presetScript.FullName

        # try { RETURN & $scriptBlock }
        # Catch { RETURN }
        # Finally { $ErrorActionPreference = $OldPreference }
        # invoke-expression -Command "$($presetScript.FullName)"
        # & $presetScript.FullName

        # $LastExitCode
        # Get-Content  | Invoke-Expression
    }
}

#
# Update
#

function update_adapter {

}

function update_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())
}

#
# Uninstall
#

function uninstall_adapter {

}

function uninstall_packages {

}

#
# Utils
#

function invoke_pma {
    $script = "$PMA_HOME/scripts/pma.ps1"
    & $script @args
}

function is_adapter_installed {
    return $true
}

function check_adapter_installed {
    param ([Parameter(Mandatory=$true)] [string] $adapter)

    if (is_adapter_installed) {
        return
    }

    Write-Output @"
Error: Adapter '$adapter' is not installed. Use the following command to install it.

  pma install $adapter
"@

    exit 1
}
