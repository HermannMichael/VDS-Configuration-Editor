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
		$UserName = "Administrator"
		$password = ""
		#new in 2019 API: licensing agent enum "Client" "Server" or "None" (=readonly access). 2017 and 2018 required local client installed and licensed
		$licenseAgent = [Autodesk.Connectivity.WebServices.LicensingAgent]::Server
		
		$cred = New-Object Autodesk.Connectivity.WebServicesTools.UserPasswordCredentials($serverID, $VaultName, $UserName, $password, $licenseAgent)
		$vault = New-Object Autodesk.Connectivity.WebServicesTools.WebServiceManager($cred)

		#region ExecuteInVault

		#build the search conditions first
		$mSearchString = "Organisation"
		$srchCond = New-Object autodesk.Connectivity.WebServices.SrchCond
		$propDefs = $vault.PropertyService.GetPropertyDefinitionsByEntityClassId("CUSTENT")
		$propDef = $propDefs | Where-Object { $_.DispName -eq "Category Name" }
		$srchCond.PropDefId = $propDef.Id
		$srchCond.SrchOper = 3
		$srchCond.SrchTxt = $mSearchString
		$srchCond.PropTyp = [Autodesk.Connectivity.WebServices.PropertySearchType]::SingleProperty
		$srchCond.SrchRule = [Autodesk.Connectivity.WebServices.SearchRuleType]::Must
		$srchSort = New-Object autodesk.Connectivity.WebServices.SrchSort
		$searchStatus = New-Object autodesk.Connectivity.WebServices.SrchStatus
		$bookmark = ""     
		$mResultAll = New-Object 'System.Collections.Generic.List[Autodesk.Connectivity.WebServices.CustEnt]'
	
		while(($searchStatus.TotalHits -eq 0) -or ($mResultAll.Count -lt $searchStatus.TotalHits))
		{
			 $mResultPage = $vault.CustomEntityService.FindCustomEntitiesBySearchConditions(@($srchCond),@($srchSort),[ref]$bookmark,[ref]$searchStatus)
			
			If ($searchStatus.IndxStatus -ne "IndexingComplete" -or $searchStatus -eq "IndexingContent")
			{
				#check the indexing status; you might return a warning that the result bases on an incomplete index, or even return with a stop/error message, that we need to have a complete index first
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