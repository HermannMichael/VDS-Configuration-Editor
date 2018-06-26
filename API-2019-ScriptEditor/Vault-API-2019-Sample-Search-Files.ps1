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
		$VaultName = "INV-Samples"
		$UserName = "CAD Admin"
		$password = ""
		#new in 2019 API: licensing agent enum "Client" "Server" or "None" (=readonly access). 2017 and 2018 required local client installed and licensed
		$licenseAgent = [Autodesk.Connectivity.WebServices.LicensingAgent]::Server
		
		$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials($serverID, $VaultName, $UserName, $password, $licenseAgent)
		$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($cred)

		#region ExecuteInVault

		#build the search conditions first
		$mSearchString = "*"
		$srchCond = New-Object autodesk.Connectivity.WebServices.SrchCond
		$propDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("FILE")
		$propDef = $propDefs | Where-Object { $_.SysName -eq "Name" }
		$srchCond.PropDefId = $propDef.Id
		$srchCond.SrchOper = 3
		$srchCond.SrchTxt = $mSearchString
		$srchCond.PropTyp = [Autodesk.Connectivity.WebServices.PropertySearchType]::SingleProperty
		$srchCond.SrchRule = [Autodesk.Connectivity.WebServices.SearchRuleType]::Must

		$mSearchStatus = New-Object autodesk.Connectivity.WebServices.SrchStatus
		$srchSort = New-Object Autodesk.Connectivity.WebServices.SrchSort
		#$srchSort
		$mBookmark = ""     
		$mResultAll = New-Object 'System.Collections.Generic.List[Autodesk.Connectivity.WebServices.File]'
	
		while(($mSearchStatus.TotalHits -eq 0) -or ($mResultAll.Count -lt $mSearchStatus.TotalHits))
		{
			$mResultPage = $vault.DocumentService.FindFilesBySearchConditions(@($srchCond),@($srchSort),@(($vault.DocumentService.GetFolderRoot()).Id),$true,$true,[ref]$mBookmark,[ref]$mSearchStatus)
			#check the indexing status; you might return a warning that the result bases on an incomplete index, or even return with a stop/error message, that we need to have a complete index first
			If ($mSearchStatus.IndxStatus -eq "IndexingComplete" -or $mSearchStatus -eq "IndexingContent")
			{

			}
			if($mResultPage.Count -ne 0)
			{
				$mResultAll.AddRange($mResultPage)
			}
			else { break;}
				
			break; #limit the search result to the first result page; page scrolling not implemented in this snippet release
		}
		
		

		#endregion ExecuteInVault

		$vault.Dispose() #don't forget to release the connection


#endregion ConnectToVault