function Send-Deployment(){
<#
.SYNOPSIS
    LEGACY - Copie et exécution silencieuse d'un fichier .exe sur une plusieurs machines à distanceé
 
.NOTES
    Name: Send-Deployment
    Author: Gabriel Hubert-St-Onge
    Version: 2.0
    DateCreated: 2019-Sept-17
 
 .DESCRIPTION
    Legacy - Ce script a été utilisé pour effectuer des déploiements en urgence sur certains postes à l'aide de l'utilitaire PsExec. L'idée était
    d'éviter de faire un déploiement complet dans une technologie comme SCCM. À noter qu'il existe aujourd'hui des alternatives beaucoup
    plus efficace.   
   
.LINK
    https://github.com/GabHubs/PowerShell
#>

    $tableau_pc = @("PC-FIN-001","PC-FIN-005","PC-FIN-009","PC-DIR-024","PC-DIR-002") # Nom d'ordinateur fictif
    $App_exe = "C:\Temp\npp8.exe"

    foreach ($pc in $tableau_pc)
    {
        Write-Host "Déploiement sur l'ordinateur $pc ..." -ForegroundColor Yellow
	    Copy-Item -Path $App_exe -Destination "\\$pc\c$\temp\nnp8.exe" -Force
        PsExec.exe \\$pc "C:\temp\nnp8.exe" /S
        Remove-Item -Path "\\$pc\c$\temp\nnp8.exe" -Force

    }

}