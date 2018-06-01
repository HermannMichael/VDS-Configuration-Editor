#region disclaimer
	#===============================================================================#
	# PowerShell script sample														#
	# Author: Markus Koechl															#
	# Copyright (c) Autodesk 2017													#
	#																				#
	# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER     #
	# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   #
	# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.    #
	#===============================================================================#
#endregion

#region project settings
	# -------------- set the location of your powershell project accordingly -------------
	$MySolutionPath = 'C:\Users\koechlm\source\repos\VDS-Configuration-Editor' 
	# -------------- set the Vault Edition/Version Name used -------------
	$VaultVersion = 'Vault Professional 2019'
#endregion project settings

#region ConnectToVault

		[System.Reflection.Assembly]::LoadFrom('C:\Program Files\Autodesk\' + $VaultVersion +'\Explorer\Autodesk.Connectivity.WebServices.dll')
		$serverID = New-Object Autodesk.Connectivity.WebServices.ServerIdentities
			$serverID.DataServer = "WIN-99HIBFVG5L3"
			$serverID.FileServer = "WIN-99HIBFVG5L3"
		$VaultName = "INV-Samples"
		$UserName = "Administrator"
		$password = ""
		#new in 2019 API: licensing agent enum "Client" "Server" or "None" (=readonly access). 2017 and 2018 required local client installed and licensed
		$licenseAgent = [Autodesk.Connectivity.WebServices.LicensingAgent]::Client
		
		$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials($serverID, $VaultName, $UserName, $password, $licenseAgent)
		$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($cred)

		#region ExecuteInVault

				[Autodesk.Connectivity.WebServices.JobParam[]] $params = @()
				$mJobMaxCount = 100
				$mJobStartDate = Get-Date -Day 01 -Month 01 -Year 2010
				$mJobList = $vault.JobService.GetJobsByDate($mJobMaxCount, $mJobStartDate)

				foreach($mJob in $mJobList)
				{
					$params = $mJob.ParamArray
				}
				
			
		#endregion ExecuteInVault
	
#endregion ConnectToVault

#region DisconnectVault - don't forget ;)
	
		$vaultConnection = $null
		$vault.Dispose()
	
#endregion DisconnectVault