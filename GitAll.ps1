<#
    GitAll.ps1
    ----------

    Discovers all git repositories at or below the current directory and issues the specified
    git command to each. If no command is specified, a status command will be issued.
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$Command = "status"
)
# Save our pwd
$currentPwd = pwd
Write-Host "Discovering git repositories..." -ForegroundColor "Green"
# RoboCopy is used to generate the repo list in order to get around the path size limitation
RoboCopy . . /L /S /NJH /NJS |% {
    If ($_ -Match "(\w:\\.*)\\.git") {
        $matches[1]
    }
} |
# Required for Get-Unique
Sort-Object |
# Only need the unique paths
Get-Unique |
ForEach {
    Write-Host "Issuing '$Command' command to '$_'..." -ForegroundColor "Green"
    # Enter the repo directory
    cd $_
    # Issue command
    $gitCommand = "git $Command"
    Invoke-Expression $gitCommand
}
# Go back to the starting pwd
cd $currentPwd
