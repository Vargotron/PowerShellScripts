<#
    UpdateAll.ps1
    ------------

    Discovers all svn repositories at or below the current directory and issues an update
    command to each.
#>
# Save our pwd
$currentPwd = pwd
Write-Host "Discovering svn repositories..." -ForegroundColor "Green"
# RoboCopy is used to generate the repo list in order to get around the path size limitation
RoboCopy . . /L /S /NJH /NJS |% {
    If ($_ -Match "(\w:\\.*)\\.svn") {
        $matches[1]
    }
} |
# Required for Get-Unique
Sort-Object |
# Only need the unique paths
Get-Unique |
ForEach {
    Write-Host "Updating '$_'..." -ForegroundColor "Green"
    # Enter the repo directory
    cd $_
    # Fetch
    svn update
}
# Go back to the starting pwd
cd $currentPwd
