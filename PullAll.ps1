[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [string]$TargetBranch = ""
)
$useTargetBranch = -Not ($TargetBranch -Eq "")
# Save our pwd
$current = pwd
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
    # Enter the repo directory
	cd $_
    # Fetch branch info
    git fetch
    # Grab the current branch
    $currentBranch = git status |% {
        If ($_ -Match "^On branch (.*)$") {
            $matches[1]
        }
    }
    If ($useTargetBranch) {
        $branch = $TargetBranch
    } Else {
        $branch = $currentBranch
    }
    # Switch branches if needed
    If (-Not $branch -Eq $currentBranch) {
        git checkout $branch
    }
	Write-Host "Pulling branch '$branch' from $_..." -ForegroundColor "Green"
	git pull
    # Checkout the current branch again
    If (-Not $branch -Eq $currentBranch) {
        git checkout $currentBranch
    }
}
# Go back to the starting pwd
cd $current
