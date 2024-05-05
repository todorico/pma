param(
    [Parameter(Mandatory=$true)] [string] $COMMAND,
    [Parameter(Mandatory=$true)] [string] $ADAPTER,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args = @("-packages")
)

function usage {
    Write-Output @"
Usage: pma $COMMAND $ADAPTER [-packages]

Options:
  -packages                 List installed packages.
"@
}

. "$PSScriptRoot/functions.ps1"

function main {
    if (-not ($args -eq @("-packages"))) {
        usage
        exit 1
    }

    list_packages
}

main @args
