#region disclaimer
	#===============================================================================#
	# PowerShell script sample														#
	# Author: Markus Koechl															#
	# Copyright (c) Autodesk 2018													#
	#																				#
	# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER     #
	# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   #
	# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.    #
	#===============================================================================#
#endregion

#region ConnectToVault
		[System.Reflection.Assembly]::LoadFrom('C:\Program Files (x86)\Autodesk\Autodesk Vault 2019 SDK\bin\x64\Autodesk.Connectivity.WebServices.dll')
		$serverID = New-Object Autodesk.Connectivity.WebServices.ServerIdentities
			$serverID.DataServer = "WIN-99HIBFVG5L3"
			$serverID.FileServer = "WIN-99HIBFVG5L3"
		$VaultName = "OTX-2019-ConfigSamples"
		$UserName = "CAD Admin"
		$password = ""
		#new in 2019 API: licensing agent enum "Client" "Server" or "None" (=readonly access). 2017 and 2018 required local client installed and licensed
		$licenseAgent = [Autodesk.Connectivity.WebServices.LicensingAgent]::Server
		
		$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials($serverID, $VaultName, $UserName, $password, $licenseAgent)
		$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($cred)

		#region ExecuteInVault
		
			#query data, create folder(s)...
			$mGroupInfo = New-Object Autodesk.Connectivity.WebServices.GroupInfo
			$mGroup = $vault.AdminService.GetGroupByName("Configuration Administrators")
			$mGroupInfo = $vault.AdminService.GetGroupInfoByGroupId($mGroup.Id)
			foreach ($user in $mGroupInfo.Users)
			{
				if($vault.AdminService.SecurityHeader.UserId -eq $user.Id)
				{				
					echo "Current user is allowed to proceed"
				}
			}

		#endregion ExecuteInVault

		$vault.Dispose() #don't forget to release the connection


#endregion ConnectToVault