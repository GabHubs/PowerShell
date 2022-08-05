function Scan-RemoteComputer {
<#
.SYNOPSIS
    Lance un analyse anti-virus sur une machine à distance

.NOTES
    Name: Scan-RemoteComputer
    Author: Gabriel Hubert-St-Onge
    Version: 1.0
    DateCreated: 2020-Nov-09
 
 .DESCRIPTION
    Ce script télécharge la version portable de Microsoft Safety Scan, le copie sur le système à distance, 
    procede au à l'analyse et génère un rapport. À noter que les droits d'administration de la machine local 
    et distante sont nécessaire au bon fonctionnement. 

.LINK
    https://github.com/gabhubs/PowerShell

.EXAMPLE
    Scan-RemoteComputer -Computer NomDeLaMachine
  
.PARAMETER Computer
    Préciser le nom ou l'adresse IP de la machine où l'analyse doit s'effectuer
#>

param (
        [Parameter(Mandatory=$true)]
        [string]$Computer
      )

    # Vérification de l'accessibilité de l'ordinateur ciblé
    $test = Test-Path -path "\\$Computer\c$"

    If ($test -eq $true) 
    {
            $Dossier = "\\$Computer\c$\clean"
            mkdir -Path $Dossier
            cls

            # Vérification de la présence de PsExec et installation si nécessaire
            
            $test_psexec = Test-Path -Path "C:\Windows\PsTools\PsExec.exe"   # Vérification si l'utilitaire est déjà présent sur la machine local

            if($test_psexec -eq $false)
            {
                try 
                {
                    $lienPSexec = "https://download.sysinternals.com/files/PSTools.zip"   # Lien pour obtenir de la dernière version de PsExec
                    $path_psexec_zip = "C:\PSTools.zip"    # Emplacement temporaire du .zip téléchargé
                
                    Invoke-WebRequest -Uri $lienPSexec -OutFile $path_psexec_zip
                    Expand-Archive -Path $path_psexec_zip -DestinationPath C:\windows\PsTools
                    Remove-Item -Path $path_psexec_zip -Force
                }
                Catch
                {
                    Write-Warning -Message "Problème lors du téléchargement de PsExec :  $($_.Exception.Message)"
                    Pause
                    Exit  
                }
            }

            # Télécharger la dernière version de MS Safety Scanner
            $fichiers_path = "\\$Computer\c$\clean\msert.exe"
            $lienWeb = "http://definitionupdates.microsoft.com/download/definitionupdates/safetyscanner/amd64/msert.exe"
            try 
            {          
                Write-Host "`nTéléchargement de la derniere version de Microsoft Safety Scanner... `n`n"
                Invoke-WebRequest -Uri "$lienWeb" -ErrorAction Stop -Outfile $fichiers_path      
            } 
            catch 
            {            
                Write-Warning -Message "Problème lors du téléchargement de Microsoft Safety Scanner :  $($_.Exception.Message)"
                Pause
                Exit            
            }            

            # Exécution de l'analyse
            try 
            { 
                # MS Safety Scanner
               cls
               Write-Host "`nVeuillez attendre que PsExec complete l'analyse sur l'ordinateur $Computer. Ceci peut prendre un certain temps ... " -ForegroundColor Yellow         
               PsExec \\$Computer c:\clean\msert.exe /quiet      
               Write-Host "`n`nMicrosoft Safety Scanner a complete l'analyse. Un fichier log a ete copie directement sur votre bureau.`n`n" -ForegroundColor Yellow
               Copy-Item -Path "\\$Computer\c$\Windows\Debug\msert.log" -Destination "C:\users\$env:USERNAME\desktop\scan-antivius-$Computer.log"
               Get-Content -Path "C:\users\$env:USERNAME\desktop\scan-antivius-$Computer.log"
               Remove-Item -Path $dossier -Recurse -Force
            
            } 
            catch 
            {            
                Write-Warning -Message "Problème lors de l'exécution du scan :  $($_.Exception.Message)"            
            } 
         }           

    else
    {
        cls
        Write-Host "L'ordinateur $Computer n'est pas accessible. Veuillez vérifier si l'ordinateur est ouvert" -ForegroundColor Red
    }

}
