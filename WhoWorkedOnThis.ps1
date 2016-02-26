<#
    WhoWorkedOnThis.ps1
    -------------------

    Scans the current git repository (recursively to a depth of 2 or the value given for the -Depth parameter) and
    returns a list of all commit author email addresses, excluding merge commits. Use -DomainFilter to only return
    author email addresses from a particular domain (include the @).
#>
[CmdletBinding()]
Param (
    [Parameter(Mandatory=$False)]
    [int]$Depth = 2,
    [Parameter(Mandatory=$False)]
    [switch]$Git = $False,
    [Parameter(Mandatory=$False)]
    [switch]$Svn = $False
)

If ($Git -And $Svn) {
    $(throw "The -Git and -Svn switches are mutually exclusive.")
}

If (-Not $Git -And -Not $Svn) {
    $Git = -Not $(git status 2>$null) -Eq ""

    IF (-Not $Git) {
        $Svn = -Not $(svn info 2>$null) -Eq ""
    }
}

If (-Not $Git -And -Not $Svn) {
    $(throw "Unable to determine repository type.")
}

If ($Git) {
    # Make sure we're in the cannonical version of the pwd so git log searching works properly
    $currentPath = pwd | Resolve-Path
    $parentNode = $currentPath | Split-Path

    If ($parentNode) {
        $leaf = $currentPath | Split-Path -Leaf
        $cannonicalPath = (Get-ChildItem $parentNode | Where { $_.Name -Eq $leaf }).FullName
    } Else {
        $cannonicalPath = (Get-PSDrive ($currentPath -Split ':')[0]).Root
    }

    # Ok, now we're good
    cd $cannonicalPath

    RoboCopy . NULL /L /S /NDL /XX /NC /NS /NJH /NJS /FP /XA:H /XD .git /Lev:$Depth |% {
        If ($_ -Match "^\W+(\w:\\(\w+\\)+)") {
            $matches[1]
        }
    } |
    ForEach {
    	git --no-pager log --no-merges -- $_
    } |% {
        If ($_ -Match "^Author: (\w+)[\.\W]?(\w*)\W<(.*)>$") {
            (Get-Culture).TextInfo.ToTitleCase($matches[1] + " " + $matches[2])
        }
    } |
    Sort-Object |
    Get-Unique
}

If ($Svn) {
    RoboCopy . . /L /S /NJH /NJS /XA:H /XD .svn packages logs /Lev:$Depth |% {
        If ($_ -Match "^\W+\d+\W+(\w:\\(\w+\\)+)") {
            $matches[1]
        }
    } |
    ForEach {
        svn log --non-interactive -q -l 20 $_
    } |% {
        If ($_ -Match "^r\d+\W+\|\W+(.*)\W+\|.*$") {
            $matches[1]
        }
    } |
    Sort-Object |
    Get-Unique
}