#Requires -RunAsAdministrator
# Initial release of automation install software package

function LocOrRem { 
    <# This function ask user question how user want run script
    and run defined function. If incorret input print error. Returt int param of choise 
    #>
    Write-Host "Choise how you wanna run script:
    1 - Local Run
    2 - Remotely Run" -ForegroundColor Green
    [int]$Choise = Read-Host "Enter your choise: "
    if ($Choise -eq 1) {
        CheckChoco
        }
    elseif ($Choise -eq 2) {
        Start-RemoteSession
        }
    else { Write-Host "Input not correct" -ForegroundColor red }
} 

function Main {
    function CheckChoco {
        <# Function test default instalation path of chocolatey
        and install chocolatey if path not presend #>
        if ((Test-Path $env:ProgramData\chocolatey) -eq $True) {
            #Call the Function
            ChocoInstall
            }
        Else {
           # Install the choclotey 
           iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
           CheckChoco
           }
    }

    function ChocoInstall {
        Write-Host "
        1 - for C# developers, Q&As
        2 - for HRs, accoutants
        3 - list installed software" -ForegroundColor Green
        [int]$Choise = Read-Host "Enter your choise: "

        if ($Choise -eq 1) {
            try {
                & CINST 7zip -y
                & CINST googlechrome -y
                & CINST skype -y
                & CINST slack -y
                & CINST notepadplusplus -y
                & CINST pstools -y 
                & CINST visualstudio2015enterprise  -packageParameters "--AdminFile http://dfsserver.betlab.private/config/AdminDeployment.xml" -y
                & CINST mssqlserver2014express
                & CINST resharper
                & CINST tortoisehg -y
                }
            catch {
                Write-Host "Error occured: $error" -ForegroundColor Red
                }
        }
        elseif ($Choise -eq 2) {
            try {
                & CINST 7zip -y
                & CINST googlechrome -y
                & CINST skype -y
                & CINST slack -y
                & CINST adobereader -y
                & CINST windjview  -y
                }
            catch {
                Write-Host "Error occured: $error" -ForegroundColor Red
                }
        }
        elseif ($Choise -eq 3) {
            try {
            & $env:ProgramData\chocolatey\choco.exe list -l
            }
        catch {
             Write-Host "Error occured: $error" -ForegroundColor Red
             } 
        
        }
        else { Write-Host "Input not correct" -ForegroundColor red }    
    }
# Check if chocolatey installed
    CheckChoco
}

function Start-RemoteSession {
<# Function connect to remote host with user credential and run Main function #>
$Cred = Get-Credential -Message "Enter your credentials for connect to remote host" -UserName "betlab\"
if ($Cred -eq $null) {
    Write-Host "Credentials is not input" -ForegroundColor red
    exit }
else { $RemHost = Read-Host "Enter remote FQDN or NetBIOS name:" }
try {
    $SesVar = New-PSSession -Credential $global:Credentials -ComputerName $RemHost
    $ConAllow = Invoke-Command -Session $SesVar -ScriptBlock {Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force} -ArgumentList $null
    $ConInst = Invoke-Command -Session $SesVar -ScriptBlock ${function:Main} -ArgumentList $null
    return $ConInst
    Get-PSSession -ComputerName $RemHost | Remove-PSSession
    }
catch {
    Write-Host "Error occured: $error" -ForegroundColor Red
    }
}

# Call mail function
LocOrRem

