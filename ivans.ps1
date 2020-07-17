#Script 1 - copy file from IVANS to local Q1-100012_Z01680_20171106092221.xml
$srcUrl = "\\Archive"
$dest = "Output"

Get-Date
#$table = Get-ChildItem -Path $srcUrl | Where-Object {$_.Name.IndexOf("Q2") -ge 0} | Where-Object {$_.Length -gt 0} | Select Name
$table = Get-ChildItem -Path $srcUrl | Where-Object {$_.Name.IndexOf("Q2") -ge 0} |  Where-Object {$_.Length -gt 0} | Select Name
Get-Date

ForEach ($file in $table){
    $name = $file.Name
    #Write-Host Reading file $name -ForegroundColor Green -BackgroundColor Black
    Write-Output "$(Get-Date) - Reading file $name" | Out-file ivansLogProcessing.txt -append
    $len = Get-ChildItem -Path "$srcUrl\$name" | Select Length
    if ($len -eq 0)
    {
        Write-Output "$(Get-Date) - Zero Length File $name" | Out-file ivansLogError.txt -append
    } #elseif ($name.IndexOf("Q1") -ge 0) {
    #    Write-Host "The file is Q1 - $name" -ForegroundColor Red -BackgroundColor Black
    #} else {
    else {
        Write-Output "$(Get-Date) - Copying File $name" | Out-file ivansLogProcessing.txt -append
        $node = Select-Xml -Path "$srcUrl\$name" -XPath "/TempSession/session/data/policy/PolicyNumber"
        
        $policyNumber = $node.node.InnerXML

        if (!(Test-Path -Path "$dest\$policyNumber")){
            #mkdir "$dest\$policyNumber"
            New-Item -Path "$dest\$policyNumber" -ItemType "directory"
        }

        if (Test-Path -Path "$dest\$policyNumber\$name"){continue}
        else { 
            Copy-Item -Path "$srcUrl\$name" -Destination "$dest\$policyNumber"
        }


    }
    
}