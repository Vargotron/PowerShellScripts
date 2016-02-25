<#
	FindRepos.ps1
	-------------

	Discovers all git repositories at or below the current directory.
#>
Write-Host "Discovering git repositories:" -ForegroundColor "Green"
# RoboCopy is used to generate the repo list in order to get around the path size limitation
RoboCopy . . /L /S /NJH /NJS |% {
    If ($_ -Match "(\w:\\.*)\\.git") {
        $matches[1]
    }
} |
# Required for Get-Unique
Sort-Object |
# Only need the unique paths
Get-Unique
Write-Host "End" -ForegroundColor "Green"