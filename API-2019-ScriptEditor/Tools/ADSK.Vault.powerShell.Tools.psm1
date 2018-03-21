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
	$MySolutionPath = 'C:\Users\marku\Documents\Visual Studio 2017\Projects\SD124422' 
	# -------------- set the Vault Edition/Version Name used -------------
	$VaultVersion = 'Vault Professional 2018'
#endregion project settings

[System.Reflection.Assembly]::LoadFrom('C:\Program Files\Autodesk\' + $VaultVersion +'\Explorer\Autodesk.Connectivity.WebServices.dll')

function mPw([SecureString] $mSecStr)
{
	$Ptr = [System.Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($mSecStr)
	$result = [System.Runtime.InteropServices.Marshal]::PtrToStringUni($Ptr)
	[System.Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($Ptr) 
	$result
}

function mPwFile()
{
	$pw = Get-Credential
	$bytes = ConvertFrom-SecureString $pw
	$bytes | out-file .\securepassword.txt
}

function mGetCategoryDef([Autodesk.Connectivity.WebServicesTools.WebServiceManager]$mVault, [String] $mEntType, [String] $mDispName)
{
	$mEntityCategories = $mVault.CategoryService.GetCategoriesByEntityClassId($mEntType, $true)
	$mEntCatId = ($mEntityCategories | Where-Object {$_.Name -eq $mDispName }).ID
	return $mEntCatId
}