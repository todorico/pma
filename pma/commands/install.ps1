param(
    [Parameter(Mandatory=$true)] [string] $command,
    [Parameter(Mandatory=$true)] [string] $adapter,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args
)

. "$PMA_HOME/tools/pma.ps1"

if (-not ($adapter -and (pma_has_adapter $adapter))) {
    pma_print_help
    exit 1
}

pma_run_command_adapter $command $adapter @args
