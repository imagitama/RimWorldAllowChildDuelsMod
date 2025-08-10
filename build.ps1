# usage: .\build.ps1 path\to\rimworld\mods\folder

param (
    [Parameter(Mandatory = $true)]
    [string]$pathToMods
)

$modName = "RimWorldAllowChildDuelsMod"
$outputPath = "$pathToMods\$modName"

echo "Outputting to: outputPath"

Push-Location

Set-Location "Source"

dotnet build

Pop-Location

echo "Copying..."

cp "Source\bin\Debug\net472\$modName.dll" "Assemblies"

cp -r -Force "About" "$outputPath\About"
cp -r -Force "Assemblies" "$outputPath\Assemblies"
cp "README.md" "$outputPath"
cp "LICENSE.md" "$outputPath"

echo "Done"

$normalizedPath = (Resolve-Path $outputPath).Path.ToLower()

# get list of currently open Explorer windows
$openFolders = (New-Object -ComObject Shell.Application).Windows() |
    Where-Object { $_.Name -eq "File Explorer" -and $_.LocationURL -like "file:///*" } |
    ForEach-Object { ([uri]$_.LocationURL).LocalPath.ToLower() }

if ($openFolders -notcontains $normalizedPath) {
    Start-Process explorer.exe $outputPath
}
