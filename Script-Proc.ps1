param(
    [Parameter(Mandatory=$true, HelpMessage='The name of the stored procedure or user defined function to script')]
    [string] $ProcedureName,
    [string] $Path = "$($ProcedureName).sql",
    [string] $ConnectionString = 'Data Source=.\sqlexpress2k8R2;Initial Catalog=master;Integrated Security=SSPI;'
);

try {
    [System.Data.SqlClient.SqlConnection] $cn = New-Object System.Data.SqlClient.SqlConnection (,$ConnectionString);
    $cn.Open() > $null;
    $cmd = $cn.CreateCommand();
    $cmd.CommandType = [System.Data.CommandType]::StoredProcedure;
    $cmd.CommandText = 'sp_helptext';
    $cmd.Parameters.AddWithValue('@objname', $ProcedureName) > $null;
    [System.Data.IDataReader] $rdr = $cmd.ExecuteReader();
    [string] $sproc_text = '';
    while ($rdr.Read()) {
        $sproc_text += $rdr[0];
    }
    $rdr.Close();
    $sproc_text | Out-File -FilePath $Path;
}
finally {
    if ($cmd -ne $null) { $cmd.Dispose(); }
    if ($cn -ne $null) { $cn.Dispose(); }
}