$table = Get-ChildItem -Path Output 

$count = 1

ForEach ($file in $table){
    $folderName = $file.Name
    $latestFileName = Get-ChildItem "Output\$folderName" | Sort-Object -Property LastWriteTime -Descending | Select -First 1
    $name = $latestFileName.FullName
    New-Item -Path "Updated\$folderName" -ItemType "directory"

    Copy-Item -Path $name -Destination "Updated\$folderName"

    $fileName = $latestFileName.Name
    $ScriptPath = (Get-Location).Path
    #Write-Host $PSScriptRoot.Name
    $filepath = "$ScriptPath\\Updated\\$folderName\\$fileName"
    
    #Write-Host $filepath
    
    $xml = New-Object XML
    $xml.Load($filepath)
    try {
        $element =  $xml.SelectSingleNode("/TempSession/session/policy/CurrentTransaction")
        $element.InnerText = "SYN"
    } catch {
        Write-Host "Current Transaction is missing /TempSession/session/policy/CurrentTransaction $folderName"
    }
    
    try {
        $element =  $xml.SelectSingleNode("/TempSession/session/data/policy/CurrentTransaction")
        $element.InnerText = "SYN"
    } catch {
        Write-Host "Current Transaction is missing /TempSession/session/data/policy/CurrentTransaction $folderName"
    }
    
    $xml.Save($filepath)

    $count++

    #if ( $count -eq 2) {
    #    Break
    #}

}

#/TempSession/session/policy/CurrentTransaction
#/TempSession/session/data/policy/CurrentTransaction