cd C:\Users\t9sau2\Documents\PowerShell
$table = Get-Content -Path .\acordxmlsneeded.txt
$dest = "AcordXml"
$source = "\\Acord"
$table | ForEach-Object {
    $arr = $_.Split()
    Write-Host "$arr"
    $policy = $arr[1].Trim()
    $number = $arr[0].Trim()
    $transactionN = "{0:000}" -f  [int]$number
    #Write-Host "$transactionN === $policy"
    Copy-Item -Path "$source\$policy.$transactionN*" -Destination $dest
}