$PMA_HOME = $PMA_HOME, $env:PMA_HOME, ([System.IO.DirectoryInfo] $PSScriptRoot).Parent.Parent.Parent | Select-Object -First 1

. "$PMA_HOME/tools/utilities.ps1"

#
# List
#

function list_buckets {
    return scoop bucket list 6>$null | ForEach-Object { $_.Name } | Sort-Object
}

function list_packages {
    return scoop list 6>$null | ForEach-Object { "$($_.Source)/$($_.Name)" } | Sort-Object
}

#
# Install
#

function install_adapter {
    With-TemporaryFile {
        param($tempFile)
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        Invoke-RestMethod -Uri https://get.scoop.sh -OutFile $tempFile.FullName
        & $tempFile.FullName -ScoopDir "C:\ProgramData\Scoop\Local" -ScoopGlobalDir "C:\ProgramData\Scoop\Global"
    }
}

function install_buckets {
    param([Parameter(Mandatory=$false)] [string[]] $buckets = @())

    $installed_buckets = [string[]] $(list_buckets)
    $missing_buckets = [string[]] [Linq.Enumerable]::Except($buckets, $installed_buckets)

    if($missing_buckets){
        foreach ($bucket in $missing_buckets) {
            scoop bucket add $bucket
        }
    }
}

function install_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    if ($packages) {
        scoop install @packages
    }
}

#
# Update
#

function update_adapter {
    scoop update
}

function update_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    if ($packages) {
        scoop update @packages
    }
}

#
# Uninstall
#

function uninstall_adapter {
    scoop uninstall scoop
}

function uninstall_buckets {
    param([Parameter(Mandatory=$false)] [string[]] $buckets = @())

    $installed_buckets = [string[]] $(list_buckets)
    $removable_buckets = [string[]] [Linq.Enumerable]::Intersect($buckets, $installed_buckets)

    if($removable_buckets){
        foreach ($bucket in $removable_buckets) {
            scoop bucket rm $bucket
        }
    }
}

function uninstall_packages {
    param([Parameter(Mandatory=$false)] [string[]] $packages = @())

    $installed_packages = [string[]] $(list_packages)
    $removable_packages = [string[]] [Linq.Enumerable]::Intersect($packages, $installed_packages)

    if ($removable_packages) {
        scoop uninstall @removable_packages
    }
}

#
# Utils
#

function is_adapter_installed {
    return Try-Command { Get-Command scoop }
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

function get_buckets_from_packages {
    param ([string[]] $packages)

    $buckets = @()

    foreach ($package in $packages) {
        $parts = $package -split '/', 2

        if ($parts.Count -eq 2) {
            $buckets += $parts[0]
        }
    }

    return $buckets | Sort-Object -Unique
}
