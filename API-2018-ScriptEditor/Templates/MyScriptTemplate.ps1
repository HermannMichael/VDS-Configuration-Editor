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
	$MySolutionPath = 'C:\Users\marku\Documents\Visual Studio 2018\Projects\xyz' 
	# -------------- set the Vault Edition/Version Name used -------------
	$VaultVersion = 'Vault Professional 2018'
#endregion project settings

#region ConnectToVault
	
	#region ExecuteInVault

		# query data, create files, folders, items... etc. here

	#endregion ExecuteInVault

	#don't forget to release the connection

#endregion ConnectToVault
