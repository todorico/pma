param(
    [Parameter(Mandatory=$true)] [string] $COMMAND,
    [Parameter(Mandatory=$true)] [string] $ADAPTER,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args = @("-packages")
)

function usage {
    Write-Output @"
Usage: pma $COMMAND $ADAPTER [-packages | -buckets]

Options:
  -packages                 List installed packages.
  -buckets                  List installed buckets.
"@
}


. "$PSScriptRoot/functions.ps1"

function main {
    check_adapter_installed $ADAPTER

    if ($args -eq @("-packages") ) {
        list_packages
    }
    elseif ($args -eq @("-buckets")) {
        list_buckets
    }
    else {
        usage
        exit 1
    }
}

main @args
