# Paths to add
[string[][]] $newPaths = @{};
$newPaths+= (
    ("7-zip", "hklm:software\7-zip", "Path"),
    ("FarManager 2.0", "hklm:software\Far2", "InstallPath")
);

$pathArray = $ENV:Path.Split(';');

foreach ($pathInfo in $newPaths) {
"pathInfi::::::"
$pathInfo
#TODO: encapsulate to a function
    if (Test-Path $pathInfo[1]) {
        $pathInfo[0] + " found"
        $path = (Get-ItemProperty $pathInfo[1] | Where-Object {  $_.Name -eq $pathInfo[2])
        if (! $pathArray -contains $path ) {
            "   Appending to path"
            $pathArray += $path
        }
        else {
            "    Already in path"
        }
    }
}
#"Sorted: "
#$pathArray | sort-object
[string]::Join(';', $pathArray);
