@{
	ModuleVersion = '1.0'
	Author = 'Nicolas Arnaud-Cormos'
	Description = 'Improve Set-Location to add history'
	Copyright  =  'WTFPL'

	ModuleToProcess = 'cd.psm1'
	FunctionsToExport = @('Set-LocationWithHistory', 'Update-LocationWithHistory', 'Start-NewWindow')
}