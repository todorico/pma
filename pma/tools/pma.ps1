. "$PMA_HOME/tools/utilities.ps1"

function pma_list_commands {
    $commandsDir = "$PMA_HOME/commands"
    return Get-ChildItem -Path "$commandsDir/*.ps1" | ForEach-Object { $_.BaseName }
}

function pma_has_command {
    param([Parameter(Mandatory=$true)] [string] $command)

    $commandScript = "$PMA_HOME/commands/$command.ps1"
    return Test-Path -Path $commandScript
}

function pma_run_command {
    param(
        [Parameter(Mandatory=$true)]
        [string] $command,
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$args
    )

    $commandScript = "$PMA_HOME/commands/$command.ps1"

    # . $commandScript

    return & $commandScript $command @args
}

function pma_has_adapter {
    param(
        [Parameter(Mandatory=$true)] [string] $adapter
    )

    $adapterScript = "$PMA_HOME/adapters/$adapter.ps1"
    return Test-Path -Path $adapterScript
}

function pma_has_command_adapter {
    param(
        [Parameter(Mandatory=$true)] [string] $command,
        [Parameter(Mandatory=$true)] [string] $adapter
    )

    return Get-Command "pma_adapter_${adapter}_${command}" -ErrorAction SilentlyContinue
}

function pma_run_command_adapter {
    param(
        [Parameter(Mandatory=$true)] [string] $command,
        [Parameter(Mandatory=$true)] [string] $adapter,
        [Parameter(ValueFromRemainingArguments=$true)] [string[]] $args
    )

    $adapterScript = "$PMA_HOME/adapters/powershell/$adapter/$command.ps1"

    if (-not (Test-Path -Path $adapterScript)) {
        Write-Error "Missing adapter: $adapter"
        exit 1
    }

    & $adapterScript $command $adapter @args

    # if (-not (pma_has_command_adapter $command $adapter)) {
    #     Write-Error "Adapter $adapter does not implement command: $command"
    #     exit 1
    # }

    # $forwarded_args = parse-list-options $args

    # & "pma_adapter_${adapter}_${command}" @forwarded_args
}

function pma_print_help {
    Write-Output @"
Usage: hpm <command> [<options>...]

Available commands:
    help             Print this help message.
    install          Install packages.
    list             List packages.
"@
}