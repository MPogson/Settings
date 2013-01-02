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


set-alias op open-project

Write-Host "Starting to load profile"
write-host "Loading PSCX"
Import-Module C:\svn\repos-devtest\Powershell\trunk\Modules\ThirdParty\PSCX

write-host "Loading PPA"
Import-Module C:\svn\repos-devtest\Powershell\trunk\Modules\PPA


#### Output
#### ------------------------------------------------------------------------------------------------------------------------------------
	Write-Host("Welcome Mr. Pogson")
	
#### ------------------------------------------------------------------------------------------------------------------------------------

#### Create Aliases
#### ------------------------------------------------------------------------------------------------------------------------------------
    write-host("-------------------------------------------------------------------------------------------------------------------------")
    Write-host("Custom aliases set to:")
    $before = Get-Alias 

    set-alias np "C:\Program Files (x86)\Notepad++\notepad++.exe"
    set-alias sql "C:\Program Files (x86)\Microsoft SQL Server\90\Tools\Binn\VSShell\Common7\IDE\SqlWb.exe"
    set-alias vs10 "C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\devenv.exe"
    set-alias chrome "C:\Users\MichaelP\AppData\Local\Google\Chrome\Application\chrome.exe"

    set-alias db Invoke-BuildDatabase
    set-alias manager Invoke-ComputerManager
    set-alias deploy Publish-Application
    set-alias op Open-Project
    set-alias of Open-File
    set-alias om Open-Module
    set-alias merge Merge-SVN
    set-alias branch Create-SVNBranch
    set-alias tag Create-SVNReleaseTag
    set-alias pro Open-Profile
    set-alias x explorer
    set-alias ?? Invoke-NullCoalescing
    set-alias repos Open-Repos
	Set-Alias msbuild "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe"
	
    $after = Get-Alias

    $after | Where-Object {$before -notcontains $_} | select Name,Definition | ft -autosize

    
    write-host("-------------------------------------------------------------------------------------------------------------------------")
#### ------------------------------------------------------------------------------------------------------------------------------------

