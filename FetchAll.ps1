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
    Write-Host "Fetching refs for '$_'..." -ForegroundColor "Green"
    # Enter the repo directory
    cd $_
    # Fetch
    git fetch
}
# Go back to the starting pwd
cd $currentPwd
