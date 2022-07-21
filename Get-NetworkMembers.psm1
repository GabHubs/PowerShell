function Get-NetworkMembers(){
<#
.SYNOPSIS
    Lance une analyse des adresses IP d'une passerelle donnée
.NOTES
    Name: Get-NetworkMembers
    Author: Gabriel Hubert-St-Onge
    Version: 1.0
    DateCreated: 2022-07-21
 
 .DESCRIPTION
    Ce module test si chacune des adresses IP possibles extraites à partir d'une passerelle fournie par l'utilisateur est accessible. Si c'est le cas, le nom DNS est fourni. 
.LINK
    https://github.com/gabhubs/PowerShell
.EXAMPLE
    Get-NetworkMembers -Gateway 10.10.5.1
#>

param (
        [Parameter(Mandatory=$true)][string] $Gateway, 
        [int] $From   = 2, 
        [int] $To  = 253
      )
    # Vérification de l'input utilisateur
    if ($gateway -like "*.1")
    {
        $test_gateway = Test-Connection -ComputerName $gateway -ErrorAction SilentlyContinue -Quiet -Count 2
        if ($test_gateway -eq $true)
        {
            # Exctraction de la base des adresses IP à vérifier (ex.: 10.10.5.x)
            $count = ($gateway.length)-1
            $adresse_de_base = $gateway.Substring(0,$count)

            # Ping de chacune des adresse possibles
            $resultat = @()
            Write-Host "`nAnalyse en cours`n"
            for ($x = $From;$x -le $To;$x++)      #($x = 2;$x -lt 253;$x++)
            {
                $adress = ($adresse_de_base + $x)
                $test = Test-Connection -ComputerName $adress -ErrorAction SilentlyContinue -Quiet -Count 1
                if ($test -eq $true)
                {
                    $info =  Resolve-DnsName $adress -ErrorAction SilentlyContinue
                    $myObject = [PSCustomObject]@{
                    Adress     = $adress
                    Reponse = $true
                    NameHost = $info.NameHost}
                    $resultat += $myObject
                    Write-Host $adress " - " $info.NameHost -ForegroundColor Green
                }
                else
                {
                    $myObject = [PSCustomObject]@{
                    Adress     = $adress
                    Reponse = $false}
                    $resultat += $myObject
                    Write-Host $adress " -  Aucune reponse" -ForegroundColor Red
                }
            }
            return $resultat
        }
        else
        {
            return "Impossible d'accéder à la passerelle $gateway"
        }
    }
    else
    {
        return "La passerelle $gateway n'est pas valide"
    }
}
