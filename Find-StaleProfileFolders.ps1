# HungryRussian
# 10/2023
# Compare disabled users to current profile folders and return list of matches
# Update specified variables to match your environemnt

Import-Module ActiveDirectory

# UPDATE THESE VARIABLES TO MATCH YOUR ENVIRONMENT ================================
$UsersFolders = Get-ChildItem -Path "\\FILESERVER\rdsfolders$" -Directory
$UsersFoldersPath = "\\FILESERVER\rdsfolders$\"
$UsersProfiles = Get-ChildItem -Path "\\FILESERVER\rdsprofiles$" -Directory
$UsersProfilesPath = "\\FILESERVER\rdsprofiles$"


$saveToFileBool = $False
$saveToFile = Read-Host -Prompt "Do you wish to save results to a file? (Y/N): "
while(!($saveToFile -match "(\b^[YyNn]$){1}")) {
    $saveToFile = Read-Host -Prompt "*Error: Please enter Y or N: "
}

if($saveToFile.ToUpper() -eq 'Y') {
    $saveToFileBool = $True
    $exportedFile = Read-Host -Prompt "Enter the filename and path to save to: "
}

foreach($folder in $UsersFolders) {
    $FolderPath = $UsersFoldersPath + $folder.BaseName
    
    try {
        $user = Get-ADUser -Identity $folder.BaseName
        $userProfile = $folder.BaseName + ".V2"
        
        # check for disabled users redirected folder
        if($user.Enabled -eq $false) {
            if($saveToFile.ToUpper() -eq 'Y') {
                Add-Content -Path $exportedFile -Value ("Disabled user " + $user.Name + " still has a home folder: " + $FolderPath)
            }
            Write-Host "Disabled user" $user.Name "still has a home folder:" $FolderPath

            # check if that user has a profile folder
            foreach($folderProfile in $UsersProfiles) {
                if($folderProfile.BaseName -eq $userProfile) {
                    $userProfile = $UsersProfilesPath + $userProfile
                    if($saveToFile.ToUpper() -eq 'Y') {
                        Add-Content -Path $exportedFile -Value ("------------- " + $user.Name + " still has a profile folder: " + $userProfile)
                    }
                    Write-Host "-------------" $user.Name "still has a profile folder:" $userProfile
                }
            }
        }
    }

    # if the folder exists but there's no matching user, the account has been deleted
    catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
        if($saveToFile.ToUpper() -eq 'Y') {
            Add-Content -Path $exportedFile -Value ("Deleted user " + $folder + " still has a home folder: " + $FolderPath)
        }
        Write-Host "Deleted user " $folder "still has a home folder:" $FolderPath
    }
}
