<#
	FindRepos.ps1
	-------------

	Discovers all git and/or svn repositories at or below the current directory. Use the flags,
    -Git and -Svn to enable/disable checking for those repository types.
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [switch]$Git = $True,
    [Parameter(Mandatory=$False)]
    [switch]$Svn = $True
)

IF ($Git) {
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
}

IF ($Svn) {
    Write-Host "Discovering svn repositories:" -ForegroundColor "Green"

    # RoboCopy is used to generate the repo list in order to get around the path size limitation
    RoboCopy . . /L /S /NJH /NJS |% {
        If ($_ -Match "(\w:\\.*)\\.svn") {
            $matches[1]
        }
    } |
    # Required for Get-Unique
    Sort-Object |
    # Only need the unique paths
    Get-Unique

    Write-Host "End" -ForegroundColor "Green"   
}