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

$MySolutionPath = 'C:\Users\koechlm\source\repos\VDS-Configuration-Editor'

Import-Module ($MySolutionPath + '\SD124422-Sample-01\Tools\ADSK.Vault.powerShell.Tools.psm1')

$pw = Get-Credential
$bytes = ConvertFrom-SecureString $pw.Password
$bytes | out-file .\securepassword.txt
