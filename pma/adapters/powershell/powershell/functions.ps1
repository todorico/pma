$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_packages {
    return Get-Module -ListAvailable | Select-Object -ExpandProperty Name
}

#
# Install
#

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] $(list_packages)
    $missing_packages = [string[]] [Linq.Enumerable]::Except($packages, $installed_packages)

    foreach ($package in $missing_packages) {
        Install-Module -Name $package -Scope CurrentUser -AllowClobber -AcceptLicense -Force
    }
}

#
# Update
#

function update_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    foreach ($package in $packages) {
        Update-Module -Name $package -Force
    }
}

#
# Uninstall
#

function uninstall_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] $(list_packages)
    $removable_packages = [string[]] [Linq.Enumerable]::Intersect($packages, $installed_packages)

    foreach ($package in $removable_packages) {
        Uninstall-Module -Name $package -Force
    }
}
