#region disclaimer
	#===============================================================================
	# PowerShell script sample														
	# Author: Markus Koechl															
	# Copyright (c) Autodesk 2017													
	#																				
	# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER     
	# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES   
	# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.    
	#===============================================================================
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
			# Referenc to Document Service
			$DocSvc = $vault.DocumentService
			$mFiles =  $DocSvc.FindLatestFilesByPaths(@("$/Change Requests/ECR-000000.docx"))

			#Reference Item Service
			$ItemSvc = $vault.ItemService

			#Create new item and commit
			$updatedItems = @()
			[Autodesk.Connectivity.WebServices.ItemsAndFiles]$mPromoteResult = $null
			$mPromoteFailed = $false
			$mAssignAll = [Autodesk.Connectivity.WebServices.ItemAssignAll]::No
			try {
					$ItemSvc.AddFilesToPromote(@($mFiles[0].Id), $mAssignAll, $true)
					[datetime]$mTimeStamp = Get-Date

					[Autodesk.Connectivity.WebServices.GetPromoteOrderResults]$mPromoteOrder = $ItemSvc.GetPromoteComponentOrder([ref]$mTimeStamp)
					if($mPromoteOrder.PrimaryArray -ne $null -and $mPromoteOrder.PrimaryArray.Length -ne $null)
					{
						try {
							$ItemSvc.PromoteComponents($mTimeStamp, $mPromoteOrder.PrimaryArray)
						}
						catch {
							$mPromoteFailed = $true
						}
					}
					if($mPromoteOrder.NonPrimaryArray -ne $null -and $mPromoteOrder.NonPrimaryArray.Length -ne $null)
					{
						try {
							$ItemSvc.PromoteComponents($mTimeStamp, $mPromoteOrder.NonPrimaryArray)
						}
						catch {
							$mPromoteFailed = $true
						}
					}
					try {
						if($mPromoteFailed -ne $true)
						{
							$mPromoteResult = $ItemSvc.GetPromoteComponentsResults($mTimeStamp)
							if ($mPromoteResult.ItemRevArray[0].Locked -ne $true)
							{
								$updatedItems = $mPromoteResult.ItemRevArray
								$mCurrentItem = $mPromoteResult.ItemRevArray[0]
								$mItemToUpdateCommit = @()
								$mItemToUpdateCommit += $mCurrentItem;
								#commit the changes for the root element only; the reason is as stated before for ItemAssignAll = No
								$ItemSvc.UpdateAndCommitItems($mItemToUpdateCommit);
							}
							else {
								# feedback that the current item assignable already exists and is locked by another process
							}
						}
					}
					catch {
						# is something unhandled left?
					}
				}
			catch {
				if ($updatedItems -ne $null -and $updatedItems.Length > 0)
				{
					$itemIds = @()
					for ($i = 0; $i -lt $updatedItems.Length; $i++)
					{
						$itemIds += $updatedItems[$i].Id
					}
					$ItemSvc.UndoEditItems($itemIds)
				}
			}
			finally
                {
                    if ($mPromoteResult -eq $null -and $mPromoteFailed -ne $true)
                    {
                        # clear out the promoted item
                        $ItemSvc.DeleteUnusedItemNumbers(@($mPromoteResult.ItemRevArray[0].MasterId))
                        $ItemSvc.UndoEditItems(@($mPromoteResult.ItemRevArray[0].MasterId))
					}
					if ($mPromoteFailed -eq $true) {
						# feedback that current item might be in edit by another process/user
					}
			}
			

		#endregion ExecuteInVault

		$vault.Dispose() #don't forget to release the connection
#endregion ConnectToVault