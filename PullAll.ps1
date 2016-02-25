RoboCopy . . /L /S /NJH /NJS |% {
	If ($_ -match "(\w:\\.*)\\.git") {
		$matches[1]
	}
} |
Sort-Object |
Get-Unique |
ForEach {
	cd $_;
	$branch = git status |% { if ($_ -match "^On branch (.*)$") { $matches[1] } }
	Write-Host "Pulling branch '$branch' from $_..." -ForegroundColor "Red";
	git pull;
	cd ..
}