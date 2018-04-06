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
	Try
	{
		[System.Reflection.Assembly]::LoadFrom('C:\Program Files (x86)\Autodesk\Autodesk Vault 2019 SDK\bin\x64\Autodesk.Connectivity.WebServices.dll')
		$serverID = New-Object Autodesk.Connectivity.WebServices.ServerIdentities
			$serverID.DataServer = "WIN-99HIBFVG5L3"
			$serverID.FileServer = "WIN-99HIBFVG5L3"
		$VaultName = "OTX-2019-ConfigSamples"
		$UserName = "Mike Manager"
		$password = ""
		#new in 2019 API: licensing agent enum "Client" "Server" or "None" (=readonly access). 2017 and 2018 required local client installed and licensed
		$licenseAgent = [Autodesk.Connectivity.WebServices.LicensingAgent]::Server
		
		$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials($serverID, $VaultName, $UserName, $password, $licenseAgent)
		$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($cred)

		#region ExecuteInVault
			Try
			{
				[System.Reflection.Assembly]::LoadFrom('C:\Program Files\Autodesk\' + $VaultVersion + '\Explorer\Autodesk.DataManagement.Client.Framework.Vault.dll')
				[System.Enum]$AuthFlag = [Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.AuthenticationFlags]::Standard
				$UsrID = $vault.AuthService.CurrentlySetSecurityHeader.UserId				
				$vaultConnection = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.Connection($vault, $VaultName, $UsrID, $serverID, $AuthFlag )
				$mSchedJobs = $vaultConnection.WebServiceManager.JobService.GetScheduledJobs()
				#Filter Scheduled Jobs according current Vault
				$mVaultId = ($vault.FileStoreVaultService.GetKnowledgeVaultByName($VaultName)).Id
				$mSchedJobs = $mSchedJobs | Where-Object {$_.VaultId -eq $mVaultId} 
				
				$mSchedJobSelected = $mSchedJobs[0]

				$mJobMaxCount = 100
				$mJobStartDate = Get-Date -Day 01 -Month 01 -Year 2010
				$mJobList = $vaultConnection.WebServiceManager.JobService.GetJobsByDate($mJobMaxCount, $mJobStartDate)
				
				$mSchedJobParam1 =  New-Object Autodesk.Connectivity.WebServices.JobParam
				$mSchedJobParams = @()
				$mSchedJobParam1.Name = $mSchedJobSelected.ParamArray[0].Name
				$mSchedJobParam1.Val = $mSchedJobSelected.ParamArray[0].Val
				$mSchedJobParams += $mSchedJobParam1
				$mSchedJobParam2 =  New-Object Autodesk.Connectivity.WebServices.JobParam
				$mSchedJobParam2.Name = $mSchedJobSelected.ParamArray[1].Name
				$mSchedJobParam2.Val = $mSchedJobSelected.ParamArray[1].Val
				$mSchedJobParams += $mSchedJobParam2
				$mSchedJobId = $mSchedJobSelected.Id

				$mJobParams = @()
				$mJobParamSyncJob1 = New-Object Autodesk.Connectivity.WebServices.JobParam
				$mJobParamSyncJob1.Name = $mSchedJobParams[0].Name
				$mJobParamSyncJob1.Val = $mSchedJobParams[0].Val
				#add Param[0]
				$mJobParams += $mJobParamSyncJob1
				
				$mJobParamSyncJob2 = New-Object Autodesk.Connectivity.WebServices.JobParam
				$mJobParamSyncJob2.Name = $mSchedJobParams[1].Name
				$mJobParamSyncJob2.Val = $mSchedJobParams[1].Val
				#add Param[1]
				$mJobParams += $mJobParamSyncJob2

				$mJobParamSyncJob3 = New-Object Autodesk.Connectivity.WebServices.JobParam
				$mJobParamSyncJob3.Name = "ScheduledJobID"
				$mJobParamSyncJob3.Val = $mSchedJobId
				#add Param[2]
				$mJobParams += $mJobParamSyncJob3

				$vaultConnection.WebServiceManager.JobService.AddJob("Autodesk.Vault.Sync.ScheduledUpload", "Autodesk.Vault.Sync.ScheduledUpload", $mJobParams, 1)
				echo "Job successfully added to Queue"
			}
			Catch
			{
				$ErrorMessage = $_.Exception.Message
				echo $ErrorMessage
			}
		#endregion ExecuteInVault
	}
	Catch
	{
		$ErrorMessage = $_.Exception.Message
		echo $ErrorMessage
	}
#endregion ConnectToVault

#region DisconnectVault - don't forget ;)
	Finally
	{
		$vaultConnection = $null
		$vault.Dispose()
	}
#endregion DisconnectVault