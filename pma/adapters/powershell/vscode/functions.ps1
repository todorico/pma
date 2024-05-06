$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_packages {
    return code --list-extensions
}

#
# Install
#

function install_adapter {
    $installer = "$PMA_HOME/adapters/powershell/winget/install.ps1"
    & $installer install winget -packages Microsoft.VisualStudioCode
}

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] (list_packages)
    $missing_packages = [string[]] [Linq.Enumerable]::Except($packages, $installed_packages)

    foreach ($package in $missing_packages) {
        code --force --install-extension $package
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

    code --force --update-extensions
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
        code --force --uninstall-extensions $package
    }
}

#
# Utils
#

function is_adapter_installed {
    return Try-Command { Get-Command code }
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
