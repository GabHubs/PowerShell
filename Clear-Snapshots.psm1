function Clear-Snapshots{
<#
.SYNOPSIS
    Suppression des snapshots plus vieux qu'un nombre de jour donné.
 
.NOTES
    Name: Clear-Snapshots
    Author: Gabriel Hubert-St-Onge
    Version: 1.0
    Date: 2022-04-05
 
 .DESCRIPTION
   Ce script a été conçu afin d'être combiné avec une tâche planifiée dans le but de supprimer systématiquement les snapshots plus vieux qu'un nombre de jour donné. À noter que PowerCLI doit être installé sur votre système et que la tâche planifiée doit appelé ce programme et non PowerShell.exe.

.LINK
    https://github.com/GabHubs/PowerShell

.EXAMPLE
    Clear-Snapshots -VIServer SRV-vCenter -Days 7
  
.PARAMETER Days
    Préciser l'âge des snapshot à supprimer en nombre de jour
#>

param (
        [Parameter(Mandatory=$true)][string]$VIServer,
        [int]$Days = 14,
        [string]$Path_logs = "C:\users\$env:USERNAME\desktop\logs.txt",
        [string]$Path_Trans = "C:\users\$env:USERNAME\desktop\transcript.txt"
      )


# Préparation et déclaration de différentes variables à utiliser
Connect-VIServer -Server $VIServer   # Connexion à vCenter
Start-Transcript -Path $Path_Trans   #Transcription de l'exécution pour analyse au besoi
$tableau = Get-VM | Get-Snapshot   #Extraction des snapshots 
$deleted = @((Get-Date),"=============")   # Créations d'un tableau pour stocker les snapshots supprimées

# Exécution
foreach ($snapshot in $tableau)
{
    $date = $snapshot.Created
    $expiration = (get-date).AddDays(-($days))
    $snapshot.Name
    if ($date -le $expiration)
    {
        $deleted += ("Suppresion de " +$snapshot.Name + " sur le serveur nommé " + $snapshot.VM.Name)
        Remove-Snapshot $snapshot -Confirm:$false
    }
}

# Production du logs et de la transcription
Remove-Item -Path $Path_logs -Force -ErrorAction SilentlyContinue    # Supression des anciens logs
$deleted | Out-File -FilePath $Path_logs
Stop-Transcript
}
