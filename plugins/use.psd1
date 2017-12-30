@{
	ModuleVersion = '1.0'
	Author = 'Kierr Dugan'
	Description = 'A simple PowerShell module that allows specific tools to be added to the current environment by updating environment variables from a JSON file'
	Copyright  =  'MIT'

	ModuleToProcess = 'use.psm1'
	FunctionsToExport = @('Initialize-Tool', 'Use-Tool')
}
