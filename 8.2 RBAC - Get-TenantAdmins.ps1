
 Install-Module MSOnline

 Connect-MsolService

#.List Admin accounts by Role
  function Get-TenandAdmins
  {
    #lister tous les Admins sur o365 :
     $MsolAdminRoles = Get-MsolRole | select * | where Name -like "*Admin*" 
      #$MsolAdminRoles | ft -AutoSize
     
     foreach($msolrole in $MsolAdminRoles)
     {  "----------------------------------------------------------------------"
       $msolrole.Name + " : " + $msolrole.Description 
       Get-MsolRoleMember  -RoleObjectId ($msolrole.ObjectId  )  | select @{Expression={($msolrole.Name)};Label="Role"}  ,  DisplayName, EmailAddress, IsLicensed, LastDirSyncTime | ft -AutoSize
     } 
  }
   
   
  Get-TenandAdmins