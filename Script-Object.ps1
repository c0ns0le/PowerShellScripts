param(
    [Parameter(Mandatory=$true, HelpMessage='The name of the database object we wish to script')]
    [string] $ObjectName,
    [string] $Path = "$($ObjectName).sql",
    [string] $ConnectionString = 'Data Source=.\sqlexpress2k8R2;Initial Catalog=master;Integrated Security=SSPI;',
    [string] $AtlantisSchemaEngineBaseDir = 'F:\src\Atlantis.SchemaEngine\' # Adjust for your environment
);

Add-Type -Path "$($AtlantisSchemaEngineBaseDir)\Atlantis.SchemaEngine\bin\Debug\Atlantis.SchemaEngine.dll"
$schemaReader = [Atlantis.SchemaEngine.Container.SQLServer.SQLServerSchemaReaderFactory]::GetSpecificSQLServerSchemaReader($ConnectionString, [Atlantis.SchemaEngine.Enumerations.ContainerMode]::Navigation)
$dbObjects = $schemaReader.ReadObjects() | Where-Object { $_.ObjectName,$_.ObjectDesriptiveName,$_.ObjectQualifiedName -contains $ObjectName };
if ($dbObjects -eq $null) {
    Throw New-Object System.ArgumentException "Object `"$($ObjectName)`" not found.",'-ObjectName';
}
$dbObjects.Script([Atlantis.SchemaEngine.Enumerations.ScriptGenerationType]::Create, (New-Object Atlantis.SchemaEngine.Configuration.GenerationOptions)).Scripts