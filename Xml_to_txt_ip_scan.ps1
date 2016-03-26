$xpath = Read-Host "Путь к файлу xml"
$xdoc = [xml](Get-Content -Path $xpath)
$ts = $xdoc.Advanced_IP_scanner.ChildNodes | Where-Object -FilterScript {($_.status -eq 'alive') -and ($_.mac -ne '00:00:00:00:00:00')} | sort-object -property ip 
$ts | Format-Table -Property name,ip | Out-File $env:USERPROFILE\Documents\Advanced_IP_scanner.txt
$env:USERPROFILE