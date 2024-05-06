param(
    [Parameter(Mandatory=$false)]
    [string] $command,
    [Parameter(ValueFromRemainingArguments=$true)]
    [string[]] $args
)


$PMA_HOME = $PMA_HOME, $env:PMA_HOME, (Split-Path -Parent "$PSScriptRoot") | Select-Object -First 1
# $PMA_SHELL_EXT = "ps1"

. "$PMA_HOME/tools/pma.ps1"

if (-not ($command -and (pma_has_command $command))) {
    pma_print_help
    exit 1
}

# $forwarded_args = parse-list-options $args
# $forwarded_args

pma_run_command $command $args
