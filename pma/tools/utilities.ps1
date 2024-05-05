Function Try-Command {
    Param ([Parameter(Mandatory = $true)] [ScriptBlock] $scriptBlock)

    $OldPreference = $ErrorActionPreference
    $ErrorActionPreference = 'stop'

    try { RETURN & $scriptBlock }
    Catch { RETURN }
    Finally { $ErrorActionPreference = $OldPreference }
}

function parse-list-options {
    param (
        [string[]] $arguments
    )

    # Initialize an empty hashtable to store the arguments
    $params = @{}
    $key = $null

    # Iterate over the arguments array
    foreach ($arg in $arguments) {
        if ($arg.StartsWith('-')) {
            # The current argument is a key, so trim the "-" and save it
            $key = $arg.TrimStart('-')
            $params[$key] = @()  # Initialize an empty array for this key
        }
        else {
            if ($null -eq $key) {
                continue
            }
            # The current argument is a value; add it to the last key's array

            $params[$key] += $arg
        }
    }

    # Return the constructed hashtable
    return $params
}

function parse-keyword-options {
    param ([string[]] $arguments)

    # Initialize hashtable
    $result = @{}

    foreach ($argument in $arguments) {
        if (-not $argument.Contains(':')) {
            # Throw an error if ':' is missing
            throw "Error: All arguments must be in the format '<key>:<value>'. The argument '$argument' does not contain ':'."
        }

        # Split on the first occurrence of ':'
        $key, $value = $argument -split ':', 2

        # Add to hashtable
        $hashtable[$key] = $value
    }

    return $hashtable
}
