#Requerements AD library
import-module activedirectory
Get-ADUser  -filter * -Properties "LastLogonDate"  | 

sort-object -property lastlogondate -descending | 

Format-Table -property name, LastLogonDate -AutoSize | Out-File D:\Off.txt