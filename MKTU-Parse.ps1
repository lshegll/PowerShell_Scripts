for ( $NumClass = 35 ; $NumClass -le 45; $NumClass++) {
$URI = "http://nice102016.uipv.org/class/good/" + $NumClass + "?per=%D0%B2%D1%81%D1%96"
$URIPOSLYGI ="http://nice102016.uipv.org/class/service/" + $NumClass + "?per=%D0%B2%D1%81%D1%96"
$HTML = Invoke-WebRequest -Uri $URIPOSLYGI
$ParsedHead = ($HTML.ParsedHtml.getElementsByTagName("div") | where{ $_.className -eq 'class-header'}).innerText
$ParsedHTML = ($HTML.ParsedHtml.getElementsByTagName("td") | where{ $_.className -eq 'main-product'}).innerText
# Пустой массив для списка
$Arr = @()
foreach ( $Teg in $ParsedHTML) {
$Teg = $Teg + "; "
$Arr += "$Teg" 
}
$Arr[-1] =  $Arr[-1] -replace ';', '.'
#[System.IO.File]::AppendAllText("$env:USERPROFILE\Desktop\Клас "+$NumClass+" "+$Arr.Length+".txt", $ParsedHead + "; ")
#[System.IO.File]::AppendAllText("$env:USERPROFILE\Desktop\Клас "+$NumClass+" "+$Arr.Length+".txt", $Arr)
# Создаем объект ворд 
$Word = New-Object -ComObject Word.Application
$Document = $Word.Documents.Add()
$Selection = $Word.Selection
$Selection.TypeText("$ParsedHead;")
$Selection.TypeText("$Arr")
$Report = "$env:USERPROFILE\Desktop\Клас "+$NumClass+" "+$Arr.Length+".docx"
$Document.SaveAs([ref]$Report,[ref]$SaveFormat::wdFormatDocument)
$word.Quit()
} 
$null = [System.Runtime.InteropServices.Marshal]::ReleaseComObject([System.__ComObject]$word)
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
Remove-Variable word 