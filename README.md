# Find_stale_profile_folders
Discovers redirected folders home folders and profiles without a matching Active Directory account
Searches through the specified root folder for the Redirected Folders and Roaming Profiles and matches the list of directories against users in Active Directory. Logs if a user is disabled or deleted but still have a redirected folder or a profile folder, or both.

Usage: Update the specified variables in the script to match the paths in your environment. Must be run on a server that can load the ActiveDirectory PowerShell module.
