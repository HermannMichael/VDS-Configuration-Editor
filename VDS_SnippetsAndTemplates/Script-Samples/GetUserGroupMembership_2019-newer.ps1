#region disclaimer
#=============================================================================#
# PowerShell script sample for Vault Data Standard                            #
#                                                                             #
# Copyright (c) Autodesk - All rights reserved.                               #
#                                                                             #
# THIS SCRIPT/CODE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER   #
# EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES #
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.  #
#=============================================================================#
#endregion

#region check GroupMembership of current user
#	Strategy: 
#		1) any user should be member of a group "User Group Readers" having the custom role "User Group Reader" (="AdminUserRead") assigned
#		2) read GroupInfo object

# Note - Quickstart Extension 2019.0.0 and newer contains a function consuming this code ready to use


# replace "myGroup" by the name of your group to be queried
$mGroupInfo = New-Object Autodesk.Connectivity.WebServices.GroupInfo
	$mGroup = $vault.AdminService.GetGroupByName("MyGroup")
	$mGroupInfo = $vault.AdminService.GetGroupInfoByGroupId($mGroup.Id)
	foreach ($user in $mGroupInfo.Users)
	{
		if($vault.AdminService.SecurityHeader.UserId -eq $user.Id)
		{				
			#the current user is allowed to proceed
		}
	}