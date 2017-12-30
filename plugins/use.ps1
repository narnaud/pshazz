Import-Module "$plugindir\use"
Set-Alias use Use-Tool -opt allscope -scope global

function global:pshazz:use:init {
    $global:pshazz.completions.use = resolve-path "$psscriptroot\..\libexec\use-complete.ps1"
    
    $global:pshazz.use = @{
        toolName       = "";
    }

    if ($global:pshazz.theme.use.config) {
        Initialize-Tool
    }
}

function global:pshazz:use:prompt {
    $vars = $global:pshazz.prompt_vars

    $toolName = $global:pshazz.use.toolName

    if ($toolName) {
        $vars.use_tool = $true;
        $vars.yes_use = ([char]0xe0b0)
        $vars.use_toolName = "$toolName"
    } else {
        $vars.no_use = ([char]0xe0b0)
    }
}
