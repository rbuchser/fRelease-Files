Function fRelease-Files {
	<#
		.NOTES
			Author: Buchser Roger
			
		.SYNOPSIS
			Reset the modified Time Stamp of a File back to midnight 00:00.
			
		.DESCRIPTION
			If a Script or a File is released, reset the File Time to 00:00. With this manipulation, other Users can see, that this File or Script was checked and released.
			Also you have a fast View over Files where are modified. Wildcards are supported.
			
		.PARAMETER Files
			Enter the Files to be released.
			
		.PARAMETER Date
			Enter the Date. Default ist Today.
			
		.EXAMPLE
			fRelease-Files -Files $PROFILE.AllUsersCurrentHost
			Will set the modified Date/Time of this Powershell Profile back of Today's Midnight.
			
		.EXAMPLE 
			fRelease-Files -Files *.ps1
			Will set the modified Date/Time of all *.ps1 Files in the current Directory back of Today's Midnight.
			
		.EXAMPLE 
			fRelease-Files -Files C:\Temp\Test.txt -Date 2020-01-01
			Will set the modified Date/Time of the File 'C:\Temp\Test.txt' with the Date of 2020-01-01 at 00:00.
			
		.LINK
			https://superuser.com/questions/924365/changing-last-modified-date-or-time-via-powershell
			https://www.ghacks.net/2017/10/09/how-to-edit-timestamps-with-windows-powershell/
	#>
	
	PARAM (
		[Parameter(Mandatory=$True,Position=0)][String[]]$Files,
		[Parameter(Mandatory=$False)][DateTime]$Date = (Get-Date).Date
	)
	
	$FilesToRelease = Get-ChildItem -Path $Files -ErrorAction SilentlyContinue
	If ($FilesToRelease) {
		$FilesToRelease  | Select Name,@{E={$_.LastWriteTime};N="LastWriteTime (Before)"} | ft -AutoSize
		Write-Host "Do you want rewrite the LastAccessTime of these $(($FilesToRelease | Measure).Count) Files to `'$($Date.DateTime)`'? (Y/N) " -f Yellow -NoNewLine
		$Continue = Read-Host 
		If ($Continue -notmatch "[yYjJ]") {
			Write-Host "`nRewrite process will abord... `n" -f Yellow
			Break
		}
		$FilesToRelease | ForEach {
			$_.LastWriteTime = $Date 
		}
		Get-ChildItem -Path $Files | Select Name,@{E={$_.LastWriteTime};N="LastWriteTime (After)"} | ft -AutoSize
	} Else {
		Write-Host "`nDid not find any File to release... `n" -f Red
		Write-Host "$($Error[0].Exception)"
	}
}
