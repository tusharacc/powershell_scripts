$execution = 'RUN03' #Change this

$now = Get-Date
$maxAge = $now.ToString('yyyyMMdd')
$minAge = $now.AddDays(1).ToString('yyyyMMdd')

$p = Join-Path -Path $now.ToString('yyyy-MM-dd') -childPath $execution

$check = Test-Path $p

if ($check.Equals($true)){
    Write-Host "Path Exists, Check $execution"
    throw "This is Error"
} else {
    mkdir $p
    $policies = Get-Content -Path .\policies.txt
    Foreach ($pol in $policies){
        ROBOCOPY \\Nausd-wapp0055a\C4\Output\Print\Temp\Pfiles\Acord $p $pol* /MAXAGE:$maxAge /MINAGE:$minAge
    }
}

#$folder = $now.ToString('yyyy-MM-dd')

#Compress-Archive -Path $folder -DestinationPath "$folder.zip"

#Copy-Item -Path "$folder.zip" -Destination "\\ussbyintvd2036\PythonApps\IEV Recoveries"