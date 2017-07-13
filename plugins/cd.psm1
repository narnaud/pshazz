function Set-LocationWithHistory(
    [String]$Path,
    [switch]$List
)
{
    <#
    .SYNOPSIS
        Keep history while changing directories.
    .DESCRIPTION
        The Set-LocationWithHistory stores all path the user is navigating too, and allow to go back to a previous one easily.
    .EXAMPLE
        Set-LocationWithHistory C:\Test
        Change current directory to Test and save the previous directory. If the directory does not exist, propose to create it.
    .EXAMPLE
        Set-LocationWithHistory
        Go to the home directory (by default $Env:USERPROFILE)
    .EXAMPLE
        Set-LocationWithHistory -
        Go to the previous directory
    .EXAMPLE
        Set-LocationWithHistory -List
        List the latest history
    .EXAMPLE
        Set-LocationWithHistory ##
        When used with a number, and if the number is not an existing folder, go to the ## directory in the history.
    #>

    #------------------------------------Show latest history------------------------------------
    if($List) {
        Write-Host
        Write-Host "Key  Path"
        Write-Host "---  ------------------" -ForegroundColor Yellow

        $history_count = $global:pshazz_history_count;
        $index = 0;
        foreach ($location in $global:pshazz_history_list){
            Write-Host ("{0,3}  {1}" -f $index, $location)
            $index++
            if($index -gt $history_count) {
                break;
            }
        }
        return
    }

    switch($Path) {
    ""  {
        Push-Location "~"
        break
    }

    "-" {
        if($global:pshazz_history_list.Count -ge 1) {
            Push-Location $global:pshazz_history_list[0]
        }
        break
    }

    default {
        $newLocation = $Path;

        # check to see if we're using a number command and get the correct Location-With-History.
        [int]$cdIndex = 0;

        if([system.int32]::TryParse($Path, [ref]$cdIndex)) {
            # Don't pull from the History if the index value is the same as a folder name
            if( !(test-path $cdIndex) ) {
                $results = $global:pshazz_history_list;
                if( ($results | measure).Count -eq 1 ){
                    $newLocation = $results
                }
                else {
                    $newLocation = $results[$cdIndex]
                }
            }
        }

        #If we are actually changing the dir.
        if($pwd.Path -ne $newLocation){

            # if the path exists
            if( test-path $newLocation ){

                # if it's a file - get the file's Location-With-History.
                if( !(Get-Item $newLocation -Force).PSIsContainer ) {
                    $newLocation = (split-path $newLocation)
                }

                Push-Location $newLocation
            }
            else {
                if($force) {
                    $prompt = 'y'
                }
                else {
                    $prompt = Read-Host "Folder not found. Create it? [y/n]"
                }

                if($prompt -eq 'y' -or $prompt -eq 'yes') {
                    New-Item $newLocation
                    Push-Location $newLocation
                }
            }
        }
    }
    }
}

function Update-LocationWithHistory(
        [parameter(Mandatory=$true)]
        [String] $Path
)
{
    if ($path -eq $global:pshazz_history_last) {
        return
    }
    if ($global:pshazz_history_last.length -ne 0) {
        $global:pshazz_history_list.Insert(0, $global:pshazz_history_last)
    }
    $global:pshazz_history_last = Get-Item -force $Path
}

function Start-NewWindow([String]$Path)
{
    <#
    .SYNOPSIS
        Start a new powershell window in a sepecif directory
    .DESCRIPTION
        The Start-NewWindow creates a new powershell window, starting in the directory pass as parameter.
    #>
    $cline = "`"/c start powershell.exe -noexit -c `"Set-Location '{0}'" -f $Path
    cmd $cline
}

