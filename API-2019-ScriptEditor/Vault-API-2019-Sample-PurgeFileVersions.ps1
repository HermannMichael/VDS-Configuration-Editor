#region disclaimer
	#===================================================================
	# PowerShell script sample													
	# Author: Markus Koechl															
	# Copyright (c) Autodesk 2017													
	#																				
	# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER     
	# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   
	# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.    
	#===================================================================
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
			#sample to purge lfc controlled file:
			$mCadFiles = $vault.DocumentService.FindLatestFilesByPaths(@("$/Designs/FileToPurge.ipt"))
			$mCadFile = $mCadFiles[0]
			$mPurgeResult = $vault.DocumentService.DeleteFileVersionsByMasterIds(@($mCadFile.MasterId), $false, $null, $null, $null)			
			
			#sample to purge un-controlled file
			$mBaseFiles = $vault.DocumentService.FindLatestFilesByPaths(@("$/Designs/FileToPurge.txt"))
			$mBaseFile = $mBaseFiles[0]
			$mPurgeResult = $vault.DocumentService.DeleteFileVersionsByMasterIds(@($mBaseFile.MasterId), $true, 1, 1, "exclude comment")
			
		#endregion ExecuteInVault

		$vault.Dispose() #don't forget to release the connection
#endregion ConnectToVault