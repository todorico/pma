param(
    [Parameter(Mandatory=$true)] [string] $COMMAND,
    [Parameter(Mandatory=$true)] [string] $ADAPTER,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args = @()
)

function usage {
    Write-Output @"
Usage: pma $COMMAND $ADAPTER -packages <package>...

Options:
  -packages <package>...    Uninstall the provided packages.
"@
}

. "$PSScriptRoot/functions.ps1"

function main {
    $options = parse-list-options $args
    $supported_options = [string[]] @("packages")
    $unsupported_options = [string[]] [Linq.Enumerable]::Except([string[]] $options.keys, $supported_options)

    if ($unsupported_options -or -not $options) {
        usage
        exit 1
    }

    uninstall_packages -packages (@() + $options.packages)
}

main @args
