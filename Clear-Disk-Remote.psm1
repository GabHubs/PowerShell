function Clear-Disk-Remote {
<#
.SYNOPSIS
    Ce script va nettoyer différents cache de tous les profils des utilisateurs d'une machine à distance.
 
.NOTES
    Name: Clear-Disk-Remote
    Author: Gabriel Hubert-St-Onge
    Version: 1.0
    DateCreated: 2020-Aug-5
 
 .DESCRIPTION
   Ce script liste l'ensemble des dossiers utilisateurs et efface la cache de différents éléments dans ceux-ci.

.LINK
    https://github.com/GabHubs/PowerShell

.EXAMPLE
    Clear-Disk-Remote -Computer NomDeLaMachine
  
.PARAMETER Computer
    Preciser le nom de la machine ou le nettoyage doit s'effectuer
#>

param (
        [Parameter(Mandatory=$true)]
        [string]$Computer
      )

$test = Test-Path -path "\\$Computer\c$"

If($test -eq $true)
{

    # On liste les utilisateurs qui ont ouvert une session sur la machine
    $tableau_user = dir \\$Computer\c$\Users

    # Si la liste existe, on peut continuer
    if ($tableau_user.count -gt 0) {

       Start-Transcript -Path "c:\users\$env:USERNAME\desktop\cleanlog-$Computer.txt" #Logs
       foreach ($user in $tableau_user){
            
                #Firefox
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\* -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache\*.* -Recurse -Force -EA SilentlyContinue -Verbose  
	            Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cache2\entries\*.* -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\thumbnails\* -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\cookies.sqlite -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\webappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path \\$Computer\c$\Users\$($_.Name)\AppData\Local\Mozilla\Firefox\Profiles\*.default\chromeappsstore.sqlite -Recurse -Force -EA SilentlyContinue -Verbose  
                #Chrome
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose  
                #Edge
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe\*" -Recurse -Force -EA SilentlyContinue -Verbose  
                #IE
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -EA SilentlyContinue -Verbose  
	            Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -EA SilentlyContinue -Verbose  
	            Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
                Remove-Item -Path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Microsoft\Windows\INetCache\IE\*" -Recurse -Force -Verbose -EA SilentlyContinue
                Remove-Item -Path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Microsoft\Windows\INetCache\IE\*" -Recurse -Force -Verbose -EA SilentlyContinue # Il semble resté des fichiers après la première suppression  
	            #Windows
                Remove-Item -path "\\$Computer\c$\Windows\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose  
	            Remove-Item -path "\\$Computer\c$\`$recycle.bin\" -Recurse -Force -EA SilentlyContinue -Verbose  
                #Cache local de l'utilisateur
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\AppData\Local\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose  
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\downloads\*" -Recurse -Force -EA SilentlyContinue -Verbose  
                #.jmap
                Remove-Item -path "\\$Computer\c$\Users\$($_.Name)\.jmap" -Recurse -Force -EA SilentlyContinue -Verbose  
                $count = $count + 1
            
                }

                Write-Host "`n$count profils ont été nettoyés `n" -ForegroundColor Yellow

                #Vidage du cache de SCCM
                Remove-Item -path "\\$Computer\c$\windows\ccmcache\*" -Recurse -Force -EA SilentlyContinue -Verbose  
            
                #MemoryDump
                Remove-Item -path "\\$Computer\c$\Windows\System32\memory.dmp" -Recurse -Force -EA SilentlyContinue -Verbose  
            

                #Résultat
                $nb_user = $tableau_user.Count
                Write-Host "`nNettoyage réussi sur $nb_user utilisateurs de l'ordinateur $Computer. Un fichier log a été créé sur votre bureau`n"-ForegroundColor Yellow
                Pause
                cls
                Stop-Transcript
            } 
    
    else 
        {
	        Write-Host -ForegroundColor red "Une erreur inattendue est survenu. Visiter www.perdu.com"	
            pause
	        Exit
	    }
}

#Si l'ordinateur n'est pas accessible, afficher une erreur
else
{
    Write-Host "Impossible de rejoindre l'ordinateur. Pour plus d'informations, visitez www.perdu.com" -ForegroundColor Red
}}
