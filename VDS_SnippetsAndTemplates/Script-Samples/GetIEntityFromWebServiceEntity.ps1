#region disclaimer
#=============================================================================
# PowerShell script sample for Vault Data Standard                            
#                                                                             
# Copyright (c) Autodesk - All rights reserved.                               
#                                                                             
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER   
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.  
#=============================================================================
#endregion

#region convert webservice entity to IEntity (Vault Extension Class)

$VaultVersion = 'Vault Professional 2019'
[System.Reflection.Assembly]::LoadFrom('C:\Program Files\Autodesk\' + $VaultVersion + '\Explorer\Autodesk.DataManagement.Client.Framework.Vault.dll')
[System.Enum]$AuthFlag = [Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.AuthenticationFlags]::Standard
$UsrID = $vault.AuthService.CurrentlySetSecurityHeader.UserId				
$vaultConnection = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Connections.Connection($vault, $VaultName, $UsrID, $serverID, $AuthFlag )

#for files
$mFile = $vault.DocumentService.GetLatestFileByMasterId(24) #replace by existing file master id
$mIEnt = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.FileIteration($vaultConnection, $mFile)

#for folders
$mFolder = $vault.DocumentService.GetFolderByPath("$/Designs/") #replace by existing folder path
$mIEnt = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.Folder($vaultConnection, $mFolder)

#for items
$item = $vault.ItemService.GetLatestItemByItemNumber("OTX-WG1-500162") #replace by existing item number
$mIEnt = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.ItemRevision($vaultConnection, $item)

#for change orders
$mCO = $vault.ChangeOrderService.GetChangeOrderByNumber("ECO-000115")
$mIEnt = New-Object Autodesk.DataManagement.Client.Framework.Vault.Currency.Entities.ChangeOrder($vaultConnection, $mCO)