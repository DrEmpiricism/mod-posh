$NonMigCSV = Get-ChildItem -Path '\\node2.soecs.ku.edu\c$\scripts\LogFiles\*NonMigrated.csv'
$HitList = @()
foreach($NonMig in $NonMigCSV)
{
    $ThisList = $null
    $ThisList = Import-Csv -Path $NonMig.FullName |Sort-Object -Property UserName
    $HitList += $ThisList |Get-Unique -AsString
    }
$HitList = $HitList |Sort-Object -Property UserName -Unique