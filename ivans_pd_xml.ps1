$rootFolder = $PSScriptRoot
Write-Host $rootFolder
function Show-Menu
{
     param (
           [string]$Title = 'IVANS MENU'
     )
     #cls
     Write-Host "================ $Title ================"
     Write-Host $PSScriptRoot
     Write-Host $rootFolder
     Write-Host "Enter the WorkComp PolicyId."
     Write-Host "Q: Press 'Q' to quit."
}

function Get-Data ($Policy)
{
    $StringArray = "POLICY='$Policy'"
    $query = "Select a.Systemassignid, b.TransTypeCd, b.TransProcessDt from CoPolicyPointer a inner join CoTransactionSummary b on a.systemassignid = b.systemassignid where a.PolicyId = `$(POLICY)"
    $result = Invoke-Sqlcmd -Query $query -ServerInstance "Server" -Database "DB" -Variable $StringArray
    Print-Array -result $result
    return $result
}

function Print-Array ($result) {
    
    For ($i = 0; $i -lt $result.Length; $i++){
        $systemAssignedId = $result[$i].Item("Systemassignid")
        $transTypeCd = $result[$i].Item("TransTypeCd")
        $transProcessDt = $result[$i].Item("TransProcessDt")
        #write-host "INTO"
        write-host "$($i) $($systemAssignedId) $($transTypeCd) $($transProcessDt) "
        write-host $(Get-Date -Date $transProcessDt -Format "MM-dd-yyyy")
        #write-host $transTypeCd
    }

}

function Get-Xml ($Policy, $index){
    $dataRow = $Policy[$index]
    Print-Array -result $Policy
    $san = $dataRow.Item("Systemassignid")
    Write-host $dataRow.Item("TransProcessDt")
    $processDate = Get-Date -Date $dataRow.Item("TransProcessDt") -Format "yyyy-MM-dd"
    write-host $processDate
    $url = "\\NAUSP-WAPP0056A.ACEINS.Com\Print\Temp\Pfiles\XML"
    robocopy $url . "$san*.xml"
    pause
}

do
{
    Show-Menu
    $input = Read-Host "Please enter policy id"

    if ($input -eq 'q'){
        return
    } else {
        $result = Get-Data -Policy $input
    }
        
    $input = Read-Host "Which Record you Need?"

    if ($input -eq 'q'){
        return
    } else {
        Get-Xml -Policy $result -index $input
    }

} until ($input -eq 'q')

