<# 
.SYNOPSIS 
    This script sets an ISE Theme to similar to the old VIM editor. 
.DESCRIPTION 
    This script sets the key values in $PsIse.Options to values consistent 
    with the VIM editor, beloved by many, particularly on the Powershell 
    product team. This script is based on Davis Mohundro's blog post
    (http://bit.ly/iib5IM), updated for RTM of PowerShell V2.0. See also  
.NOTES 
    File Name  : Set-ISEThemeVIM.ps1 
    Author     : Thomas Lee - tfl@psp.co.uk 
    Requires   : PowerShell Version 2.0 (ISE only) 
.LINK 
    This script posted to: 
        http://pshscriptsbog.blogspot.com  
        http://bit.ly/iaA2iX
.EXAMPLE 
    This script when run resets colours on key panes, including 
    colourising tokens in the script pane. Try it and see it... 
#> 
 
 
# PowerShell ISE version of the VIM blackboard theme at  
# http://www.vim.org/scripts/script.php?script_id=2280 
 
# Set font name and size 
$psISE.Options.FontName = 'Courier New' 
$psISE.Options.FontSize = 12
 
# Set colours for output pane 
$psISE.Options.OutputPaneBackgroundColor     = '#FF000000' 
$psISE.Options.OutputPaneTextBackgroundColor = '#FF000000' 
$psISE.Options.OutputPaneForegroundColor     = '#FFFFFFFF' 
 
# Set colours for command pane 
$psISE.Options.CommandPaneBackgroundColor    = '#FF000000' 
 
# Set colours for script pane 
 
$psise.options.ScriptPaneBackgroundColor    ='#FF000000' 
 
# Set colours for tokens in Script Pane 
$psISE.Options.TokenColors['Command'] = '#FFFFFF60' 
$psISE.Options.TokenColors['Unknown'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['Member'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['Position'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['GroupEnd'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['GroupStart'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['LineContinuation'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['NewLine'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['StatementSeparator'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['Comment'] = '#FFAEAEAE' 
$psISE.Options.TokenColors['String'] = '#FF00D42D' 
$psISE.Options.TokenColors['Keyword'] = '#FFFFDE00' 
$psISE.Options.TokenColors['Attribute'] = '#FF84A7C1' 
$psISE.Options.TokenColors['Type'] = '#FF84A7C1' 
$psISE.Options.TokenColors['Variable'] = '#FF00D42D' 
$psISE.Options.TokenColors['CommandParameter'] = '#FFFFDE00' 
$psISE.Options.TokenColors['CommandArgument'] = '#FFFFFFFF' 
$psISE.Options.TokenColors['Number'] = '#FF98FE1E' 

###-----------------------------------------------------------------------------------------------------------------------------------------

function Install-VSCommandPrompt($version = "2012")
{
    switch ($version)
    {
        2012 { $toolsVersion = "110" }
        2010 { $toolsVersion = "100" }
        2008 { $toolsVersion = "90"  }
        2005 { $toolsVersion = "80"  }
 
        default {
            write-host "'$version' is not a recognized version."
            return
        }
    }
 
	#Set environment variables for Visual Studio Command Prompt
    $variableName = "VS" + $toolsVersion + "COMNTOOLS"
    write-host $variableName
	$vspath = (get-childitem "env:$variableName").Value
	$vsbatchfile = "vsvars32.bat";
	$vsfullpath = [System.IO.Path]::Combine($vspath, $vsbatchfile);
 
	#$_ shortcut represents arguments
	pushd $vspath
	cmd /c $vsfullpath + "&set" |
	foreach {
	  if ($_ -match “=”) {
		$v = $_.split(“=”);
		set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
	  }
	}
	popd
    msbuild /version
	write-host "Visual Studio $version Command Prompt variables set." -ForegroundColor Red
}

#### Output
#### ------------------------------------------------------------------------------------------------------------------------------------
    $currentUserName = [Environment]::UserName
	Write-Host("Welcome {0}" -f $currentUserName)



####  Modules
#### ------------------------------------------------------------------------------------------------------------------------------------
    $moduleDirectory = "C:\Users\{0}\Documents\WindowsPowerShell\Modules\" -f $currentUserName
    
    $modules = @{}
	$modules+= @{"PSCX"="svn://gary.paraport.com/repos-devtest/Powershell/trunk/Modules/ThirdParty/PSCX"}
    $modules+= @{"Minerva"="svn://gary.paraport.com/repos-devtest/Powershell/trunk/Modules/Minerva"}
    $modules+= @{"Psake"="svn://gary.paraport.com/repos-devtest/Powershell/trunk/Modules/ThirdParty/PSake"}
    

    Write-host("-------------------------------------------------------------------------------------------------------------------------")
    Write-Host("Bootstrapping modules")
    if((Test-Path $moduleDirectory) -eq $false)
    {
        New-Item $moduleDirectory -type directory
    }
     $modules.Keys | ForEach-Object { 
        $localModulePath = $moduleDirectory + $_
        $svnModulePath = $modules[$_]
        
        if((Test-Path $localModulePath) -eq $false)
        {
            Write-Host("Checking out {0} to {1}" -f $_,$localModulePath)
            $checkoutExpression = "svn co {0} {1} --depth infinity" -f  $svnModulePath, $localModulePath
            $a = Invoke-Expression $checkoutExpression
        }
        else
        {
            Write-Host("Module {0} already exists at {1}" -f $_,$localModulePath)
        }
     }
    
    
    write-host("-------------------------------------------------------------------------------------------------------------------------")
    Write-Host("Updating all known modules from SVN")
    $modulesToUpdate = Get-Module -ListAvailable
    $modulesToUpdate | ForEach-Object {
        if((Test-Path $_.Path -PathType Leaf)){
            $modulePath = Split-Path $_.Path
        }
        else {
            $modulePath =  $_.Path
        }
        if([System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name -eq "paraport.com"){
            Write-Host("... {0}" -f $_.Name)
            $updateExpression = "svn update {0} --depth infinity --accept launch" -f  $modulePath
            $a = Invoke-Expression $updateExpression
        }
    }
    
    #------------------------------------------------------------------------------------------------------------------------------------
    write-host("-------------------------------------------------------------------------------------------------------------------------")
    Write-Host("Importing Modules")
    $modules.Keys | ForEach-Object { 
        Write-Host("... {0}" -f $_) 
        Import-Module $_
    }
	Write-Host("Attempting to load PPA.")
	Import-Module PPA
	Import-Module PpaDeploy
	Write-Host("Attempting to load custom scripts.")
	Install-VSCommandPrompt -version 2012 
    
#### ------------------------------------------------------------------------------------------------------------------------------------

#### Create Aliases
#### ------------------------------------------------------------------------------------------------------------------------------------
    write-host("-------------------------------------------------------------------------------------------------------------------------")
    Write-host("Custom aliases set to:")
    $before = Get-Alias 

    set-alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
    set-alias sql "C:\Program Files (x86)\Microsoft SQL Server\90\Tools\Binn\VSShell\Common7\IDE\SqlWb.exe"
    set-alias vs10 "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
    set-alias chrome ("C:\Users\{0}\AppData\Local\Google\Chrome\Application\chrome.exe" -f $currentUserName)

    set-alias db Invoke-BuildDatabase
    set-alias op Open-Project
    set-alias of Open-File
    set-alias om Open-Module
    set-alias merge Merge-SVN
    set-alias branch Create-SVNBranch
    set-alias tag Create-SVNReleaseTag
    set-alias pro Open-Profile
    set-alias x explorer
    set-alias repos Open-Repos
    
    $after = Get-Alias

    $after | Where-Object {$before -notcontains $_} | select Name,Definition | ft -autosize

    
    write-host("-------------------------------------------------------------------------------------------------------------------------")
#### ------------------------------------------------------------------------------------------------------------------------------------


#### Global Variables
#### ------------------------------------------------------------------------------------------------------------------------------------
    write-host("Preferences set to:")

    # used by app deploy
    $deploymentConfigFolder = "C:\Git\Config"
    $environmentFile = "$deploymentConfigFolder\Default.Environment.xml"
    $versionFile = "$deploymentConfigFolder\Default.version.xml"

    
    $Ppa.Preferences.EmailAddress = "mpogson@paraport.com"
    $Ppa.Preferences.Profile = "C:\Users\{0}\Documents\WindowsPowerShell\profile.ps1" -f $currentUserName
    
	$Ppa.Preferences.PersonalWebServerName = "SEA-2500-18"
    $Ppa.Preferences.TeamName = "Team B"
    $Ppa.Preferences.DefaultEnvironmentFile = $environmentFile
    $Ppa.Preferences.DefaultVersionFile = $versionFile
    $Ppa.Preferences.LocalRepositoryRoot = "C:\Git"
    $Ppa.Preferences

#### ------------------------------------------------------------------------------------------------------------------------------------

# watch for changes to the Files collection of the current Tab
	if($psise -ne $null)
	{
		$temp=register-objectevent $psise.CurrentPowerShellTab.Files collectionchanged -action {
			# iterate ISEFile objects
			$event.sender | % {
				 # set private field which holds default encoding to ASCII
				 $a = $_.gettype().getfield("encoding","nonpublic,instance").setvalue($_, [text.encoding]::UTF8)
			}
		}
	}
##---------------------------------------------------------------------------------------------------------------------------------------
