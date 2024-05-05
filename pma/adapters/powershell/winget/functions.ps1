$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_packages {
    return Get-WinGetPackage | Where-Object { $_.Source -eq "winget" } | Select-Object -ExpandProperty Id
}

#
# Install
#

function install_adapter {
    $installer = "$PMA_HOME/adapters/powershell/powershell/install.ps1"
    & $installer install powershell -packages Microsoft.WinGet.Client
}

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] (list_packages)
    $missing_packages = [string[]] [Linq.Enumerable]::Except($packages, $installed_packages)

    foreach ($package in $missing_packages) {
        winget install --exact --id $package
    }
}

#
# Update
#

function update_adapter {
    throw "not implemented yet"
}

function update_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    foreach ($package in $packages) {
        winget update --exact --id $package
    }
}

#
# Uninstall
#

function uninstall_adapter {
    throw "not implemented yet"
}

function uninstall_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] $(list_packages)
    $removable_packages = [string[]] [Linq.Enumerable]::Intersect($packages, $installed_packages)

    foreach ($package in $removable_packages) {
        winget uninstall --exact --id $package
    }
}

#
# Utils
#

function is_adapter_installed {
    return Try-Command { Get-Module Microsoft.WinGet.Client }
}


function check_adapter_installed {
    param ([Parameter(Mandatory=$true)] [string] $adapter)

    if (is_adapter_installed) {
        return
    }

    Write-Output @"
Error: Adapter '$adapter' is not installed. Use the following command to install it. [-packages | -buckets]

  pma install $adapter
"@

    exit 1
}
