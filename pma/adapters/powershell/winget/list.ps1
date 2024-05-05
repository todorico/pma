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
    check_adapter_installed $ADAPTER

    if ($args -eq @("-packages") ) {
        list_packages
    }
    else {
        usage
        exit 1
    }
}

main @args
