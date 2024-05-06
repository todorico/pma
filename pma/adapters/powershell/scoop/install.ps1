param(
    [Parameter(Mandatory=$true)] [string] $COMMAND,
    [Parameter(Mandatory=$true)] [string] $ADAPTER,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args
)

function usage {
    Write-Output @"
Usage: pma $COMMAND $ADAPTER [-packages <package>... | -buckets <bucket>...]

Options:
  -packages <package>...    Install the provided packages.
  -buckets <buckets>...     Install the provided buckets.
"@
}

. "$PSScriptRoot/functions.ps1"

function main {
    $options = parse-list-options $args
    $supported_options = [string[]] @("packages", "buckets")
    $unsupported_options = [string[]] [Linq.Enumerable]::Except([string[]] $options.keys, $supported_options)

    if ($unsupported_options) {
        usage
        exit 1
    }

    if (-not (is_adapter_installed)) {
        install_adapter
    }

    if ($options) {
        install_buckets -buckets (@() + $options.buckets + $buckets)
        install_packages -packages (@() + $options.packages)
    }
}

main @args
