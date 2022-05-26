function Disable-ExpiredAccount{

<#
.SYNOPSIS
    Désactivation des comptes expirés de l'active directory.
 
.NOTES
    Name: Disable-ExpiredAccount
    Author: Gabriel Hubert-St-Onge
    Version: 1.0
    Date: 2022-05-11
 
 .DESCRIPTION
   Ce script a été conçu dans une organisation où la date d'expiration d'un compte AD est utilisée et où il existe une syncronisation entre Active Directory "local" et AzureAD. Comme ce champ n'existe pas dans AzureAD, il était nécessaire de s'assurer que les comptes expirés soient désactivés.

.LINK
    https://github.com/GabHubs/PowerShell

.EXAMPLE
    Disable-ExpiredAccount -logs "C:\test.txt"
  
.PARAMETER logs
    Préciser l'emplacement où les logs seront placés
#>

param ([string]$logs = "C:\users\$env:USERNAME\desktop\comptes_desactives_derniere_execution.txt")

try
    {
        #Emplacement du logs
        Remove-Item -Path $log -Force -ErrorAction SilentlyContinue #Suppression de l'ancien log

        #Obtenir la date d'aujourd'hui
        $now = Get-Date 

        #Faire un tableau qui contient tout les comptes AD où la date d'expiration n'est pas vide, où la date d'expiration est plus ancienne que maintenant et que le compte est activé.
        $tableau = Get-ADuser -Filter * -Properties SamAccountName, AccountExpirationDate, Enabled, EmployeeID | Where-Object {($_.AccountExpirationDate -ne $null) -and ($_.AccountExpirationDate -lt $now) -and ($_.Enabled -eq $true)}

        #Pour chacun de ces comptes, désactiver le compte
        foreach ($compte in $tableau)
        {
            Disable-ADAccount -Identity $compte.SamAccountName

        }

        #Exporter en logs
        $tableau = $tableau | Sort-Object -Property Name  # Trier par nom
        ($tableau | Format-Table -Property Name,SamAccountName,EmployeeID,AccountExpirationDate) | Out-File -FilePath $log
    }

catch
    {
        # En cas d'erreur, envoyer un email afin d'aviser qu'il y a un problème. 
        Send-MailMessage -From Script@contoso.com -Subject "Erreur - Script desactivant les comptes AD expires" -To monitoring@contoso.com -Body "Un erreur a ete detecte dans le script qui desactive les comptes AD expires. Ce script a ete mis en place afin que le les comptes expires dans notre AD local soit desactive dans Azure AD. Voir $log" -SmtpServer smtp.@contoso.com
    }
}
