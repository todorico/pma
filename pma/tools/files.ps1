function With-TemporaryFile {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [ScriptBlock] $scriptBlock
    )

    Try {
        $tempFile = New-TemporaryFile
        & $scriptBlock $tempFile
    }
    Catch {
        throw
    }
    Finally {
        if(Test-Path -Path $tempFile.FullName){
            Remove-Item -Path $tempFile.FullName -Force
        }
    }
}


function list_commands {
    param([Parameter(Mandatory=$true)] [string] $presetPattern)

    $presetDir = "$PSScriptRoot\..\..\..\hpm\preset"
    $presetFilePattern = "^($presetPattern)[.]sh$"
    return Get-ChildItem -Path $presetDir -File |
            Where-Object { $_.Name -match $presetFilePattern }
}