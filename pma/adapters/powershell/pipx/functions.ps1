$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_packages {
    return @(pipx list --short --quiet 2>$null | ForEach-Object { ($_ -split ' ', 2)[0] })
}

#
# Install
#

function install_adapter {
    # TODO: update PIPX_HOME value

    $PIPX_HOME = Get-Env 'PIPX_HOME'

    if(-not $PIPX_HOME) {
        Write-Env 'PIPX_HOME' "$HOME\.local\pipx"
        $env:PIPX_HOME = "$HOME\.local\pipx"
    }

    $installer = "$PMA_HOME/adapters/powershell/scoop/install.ps1"
    & $installer install scoop -packages pipx
}

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] @(list_packages)
    $missing_packages = [string[]] [Linq.Enumerable]::Except($packages, $installed_packages)

    if ($missing_packages) {
        pipx install @missing_packages
    }
}

#
# Update
#

function update_adapter {
    $updater = "$PMA_HOME/adapters/powershell/scoop/update.ps1"
    & $updater update scoop -packages pipx
}

function update_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    foreach ($package in $packages) {
        pipx upgrade $package
    }
}

#
# Uninstall
#

function uninstall_adapter {
    $uninstaller = "$PMA_HOME/adapters/powershell/scoop/uninstall.ps1"
    & $uninstaller uninstall scoop -packages pipx
}

function uninstall_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] @(list_packages)
    $removable_packages = [string[]] [Linq.Enumerable]::Intersect($packages, $installed_packages)

    foreach ($package in $removable_packages) {
        pipx uninstall $package
    }
}

#
# Utils
#

function is_adapter_installed {
    return Try-Command { Get-Command pipx }
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
