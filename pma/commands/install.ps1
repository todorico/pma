param(
    [Parameter(Mandatory=$true)] [string] $command,
    [Parameter(Mandatory=$true)] [string] $adapter,
    [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args
)

. "$PMA_HOME/tools/pma.ps1"

pma_run_command_adapter $command $adapter @args
