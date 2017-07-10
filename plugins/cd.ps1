Import-Module "$plugindir\cd"
Set-Alias cd Set-LocationWithHistory -opt allscope -scope global

function global:pshazz:cd:init {

    $global:pshazz_history_list = New-Object 'System.Collections.Generic.List[string]'
    $global:pshazz_history_last = ""

    if ($global:pshazz.theme.cd.home) {
        (Get-PsProvider 'FileSystem').home = $global:pshazz.theme.cd.home
    }

    $count = 10
    if (!$global:pshazz.theme.cd.count) { $count = $global:pshazz.theme.cd.count }
    $global:pshazz_history_count = $count
}

function global:pshazz:cd:prompt {
    Update-LocationWithHistory $pwd.Path
}