Vous trouverez dans ce répertoire de nombreux scripts PowerShell que j'ai personnellement développés au courant des dernières années. Afin de pouvoir rendre ces 
scripts publics, il a été nécessaire "d'aseptiser" plusieurs éléments par rapport aux scripts d'origine. De plus, dans un objectif de garder une constance lors 
de la consultation de ceux-ci, tous les scripts ont été convertis sous forme de module (.psm1) simplifié.


VMWare - PowerCLI
-------------
Travaillant au quotidien avec une infrastructure VMware, la nécessité d'exploiter PowerCLI fut rapidement une évidence. La majorité des scripts ci-dessous ont été 
écrits dans l'optique d'être utilisé avec vRealize Orchestrator ou simplement une tâche planifiée.

- Clear-Snapshot : Ce script a été conçu dans le but de supprimer systématiquement les snapshots plus vieux qu'un nombre de jour donné.

AD DS 
-------------
- Disable-ExpiredAccount : Ce script a été conçu dans une organisation où la date d'expiration d'un compte AD est utilisée et où il existe une synchronisation entre Active Directory "local" et AzureAD. Comme ce champ n'existe pas dans AzureAD, il était nécessaire de s'assurer que les comptes expirés soient désactivés.

Windows OS
-------------
- Clean-Disk-Remote : Ce script liste l'ensemble des dossiers utilisateurs et efface la cache de différents éléments dans ceux-ci. Ce script a été conçu dans un environnement où le protocole WinRM est bloqué.

- Scan-RemoteComputer : Ce script télécharge une version portable de Microsoft Safety Scan, le copie sur le système à distance, procède à l'analyse et génère un rapport. À noter que script a été conçu dans un environnement où le protocole WinRM est bloqué. 
