param($fragment) # everything after ^use\s*

$inputKeys = $fragment.Split(' ')
$matchingKey = $inputKeys[$inputKeys.length - 1]

$tools = Get-Member -InputObject $Global:pshazz.use.config -MemberType NoteProperty |
        ForEach-Object -MemberName 'Name'

$tools | ForEach-Object {
    if($_.StartsWith($matchingKey))
    {
        #this will output the auto filled key to the screen.
        $_ | sort
    }
}
