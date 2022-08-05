Vous trouverez dans ce répertoire de nombreux scripts PowerShell que j'ai personnellement développés au courant des dernières années. Afin de pouvoir rendre ces 
scripts publics, il a été nécessaire "d'aseptiser" plusieurs éléments par rapport aux scripts d'origine. De plus, dans un objectif de garder une constance lors 
de la consultation de ceux-ci, tous les scripts ont été convertis sous forme de module (.psm1) simplifié.


VMWare - PowerCLI
-------------
Travaillant au quotidien avec une infrastructure VMware, la nécessité d'exploiter PowerCLI fut rapidement une évidence. La majorité des scripts ci-dessous ont été 
écrits dans l'optique d'être utilisé avec vRealize Orchestrator ou simplement avec une tâche planifiée.

- Clear-Snapshot : Ce script a été conçu dans le but de supprimer systématiquement les snapshots plus vieux qu'un nombre de jour donné.

AD DS 
-------------
- Disable-ExpiredAccount : Comme la date d'expiration d'un compte AD n'est pas un champ synchronisé dans AzureAD au moment d'écrire ce script, il est nécessaire de désactiver les comptes expirés de l'active directory afin de s'assurer que ces comptes ne soient pas accessible par AzureAD. 

- Get-NetworkMembers : Ce script test si chacune des adresses IP possibles extraites à partir d'une passerelle fournie par l'utilisateur est accessible. Si c'est le cas, le nom DNS est fourni. 

Windows OS
-------------
- Clean-Disk-Remote : Ce script liste l'ensemble des dossiers utilisateurs et efface la cache de différents éléments dans ceux-ci.

- Scan-RemoteComputer : Ce script télécharge une version portable de Microsoft Safety Scan, le copie sur le système à distance, procède à l'analyse et génère un rapport.

Autres
-------------
- Set-SimpleCryptolocker : (POC) - Ce script va encrypter les fichiers le plus volumineux accessibles dans les partages SMB du profil exécutant la présente fonction
