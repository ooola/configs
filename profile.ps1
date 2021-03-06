set-alias vi vim
set-alias np 'C:\Program Files (x86)\Notepad++\notepad++.exe'

#######################################################################################
## fixup the PATHEXT to prevent python from opening in a new window
$tmp = $env:PATHEXT
$tmp = "$tmp;.PY"
Set-Item -path env:PATHEXT -value $tmp

## fixup terminal for GIT
Set-Item -path env:LESS -value FRSX
Set-Item -path env:TERM -value cygwin

## Setup GOPATH
Set-Item -path env:GOPATH -value c:\Users\olan\Documents\snipplets\go


#######################################################################################
## customized prompt

function prompt { (whoami) + "@" + (hostname) + "|" + (get-date -uFormat "%H:%M:%S") + "|" + (get-location).Path + "|`n> " }


#######################################################################################
## Administrator title bar 

$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$p = New-Object System.Security.Principal.WindowsPrincipal($id)

if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $Host.UI.RawUI.WindowTitle = "Administrator: " + $Host.UI.RawUI.WindowTitle
}

function settitle($title = "Help! I need a name")
{ 
    $Host.UI.RawUI.WindowTitle = "$title "
}


#######################################################################################
## from http://www.tavaresstudios.com/Blog/post/The-last-vsvars32ps1-Ill-ever-need.aspx
## 'vsvars32 9.0' is to run VS 2008, 8.0 is 2005

function Get-Batchfile ($file) {
    $cmd = "`"$file`" & set"
    cmd /c $cmd | Foreach-Object {
        $p, $v = $_.split('=')
        Set-Item -path env:$p -value $v
    }
}

function VsVars32($version = "9.0")
{
    $key = "HKLM:SOFTWARE\Microsoft\VisualStudio\" + $version
    $VsKey = get-ItemProperty $key
    $VsInstallPath = [System.IO.Path]::GetDirectoryName($VsKey.InstallDir)
    $VsToolsDir = [System.IO.Path]::GetDirectoryName($VsInstallPath)
    $VsToolsDir = [System.IO.Path]::Combine($VsToolsDir, "Tools")
    $BatchFile = [System.IO.Path]::Combine($VsToolsDir, "vsvars32.bat")
    Get-Batchfile $BatchFile
    [System.Console]::Title = "Visual Studio " + $version + " Windows Powershell"
    # add WiX 3.0
    if (test-path 'C:\Program Files\Windows Installer XML v3\bin')
    {
        $env:path += ';C:\Program Files\Windows Installer XML v3\bin'
    }   
}

function vs2012vars()
{
	pushd 'c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC'
	cmd /c "vcvarsall.bat&set" |
	foreach {
	  if ($_ -match "=") {
	    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
	  }
	}
	popd
}

function JdkVars()
{
    $env:path += ';C:\Program Files\Java\jdk1.6.0_18\bin'
}

#######################################################################################
#
# From http://thepowershellguy.com/blogs/posh/archive/2007/01/23/powershell-converting-accountname-to-sid-and-vice-versa.aspx
#

function ConvertTo-NtAccount ($sid)
{
    (new-object system.security.principal.securityidentifier($sid)).translate([system.security.principal.ntaccount])
}

function ConvertTo-Sid ($NtAccount)
{
    (new-object system.security.principal.NtAccount($NTaccount)).translate([system.security.principal.securityidentifier])
}


#######################################################################################
#
# http://dmitrysotnikov.wordpress.com/2007/10/31/counting-lines-of-source-code-with-powershell/
#

function CountLines($directory)
{
    $num = 0
    dir $directory -include *.c,*.cpp,*.h,*.cxx,*.cs -Recurse | ForEach-Object {
        $file=[array](Get-Content $_ )
        $num += $file.length
    }
    $num   	
}

#######################################################################################
#
# http://msdn.microsoft.com/en-us/library/ms586901.aspx
#
function speak {
    param ( $phrase = "give me something to say" )
    
    [System.Reflection.Assembly]::LoadWithPartialName("System.Speech") | out-null 
    $spk = New-Object system.Speech.Synthesis.SpeechSynthesizer 
    $spk.Speak($phrase)
}


#######################################################################################
#
# http://blogs.microsoft.co.il/blogs/scriptfanatic/archive/2008/09/06/keep-in-sync-with-sysinternals-tools.aspx
#

function Get-SysInternals {
	
   param ( $sysIntDir="c:\sysint\" )
   
   if( !$sysIntDir.endsWith("\")) { $sysIntDir+="\" }
   $log = join-path $sysIntDir "changes.log"
   add-content -force $log -value "`n`n[$(get-date)]SysInternals sync has started"

      dir \\live.sysinternals.com\tools -recurse | foreach { 
	
         $fileName = $_.name
         $localFile = join-path $sysIntDir $_.name                  
         $exist = test-path $localFile
         
         $msgNew = "new utility found: $fileName , downloading..."
         $msgUpdate = "file : $fileName  is newer, updating..."
         $msgNoChange = "nothing changed for: $fileName"
         
	
         if($exist){

            if($_.lastWriteTime -gt (get-item $localFile).lastWriteTime){
               copy-item $_.fullname $sysIntDir -force
               write-host $msgUpdate -fore yellow
               add-content -force $log -value $msgUpdate
            } else {
               add-content $log -force -value $msgNoChange
               write-host $msgNoChange
            }

          } else {

               if($_.extension -eq ".exe") {
                  write-host $msgNew -fore green
                  add-content -force $log -value $msgNew
               } 

               copy-item $_.fullname $sysIntDir -force 
         }
   }
}

#################################
#
# http://mow001.blogspot.com/2006/10/powershell-calendar-function-gui.html
# Function Get-Calendar
# Shows a calendar with WeekNumbers in a Form
# /\/\o\/\/ 2006
# www.ThePowerShellGuy.com

Function get-Calendar { 

  $form = new-object Windows.Forms.Form 
  $form.text = "Calendar" 
  $form.Size = new-object Drawing.Size @(656,639) 

  # Make "Hidden" SelectButton to handle Enter Key

  $btnSelect = new-object System.Windows.Forms.Button
  $btnSelect.Size = "1,1"
  $btnSelect.add_Click({ 
    $form.close() 
  }) 
  $form.Controls.Add($btnSelect ) 
  $form.AcceptButton =  $btnSelect

  # Add Calendar 

  $cal = new-object System.Windows.Forms.MonthCalendar 
  $cal.ShowWeekNumbers = $true 
  $cal.MaxSelectionCount = 356
  $cal.Dock = 'Fill' 
  $form.Controls.Add($cal) 

  # Show Form

  $Form.Add_Shown({$form.Activate()})  
  [void]$form.showdialog() 

  # Return Start and end date 

  return $cal.SelectionRange
} 

set-alias cal get-Calendar


#######################################################################################
#
# http://blogs.msdn.com/powershell/archive/2008/09/02/speeding-up-powershell-startup-updating-update-gac-ps1.aspx
#
#
#Set-Alias ngen (Join-Path ([System.Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()) ngen.exe)
#[AppDomain]::CurrentDomain.GetAssemblies() |
#    sort {Split-path $_.location -leaf} |
#    %{
#        $Name = (Split-Path $_.location -leaf)
#        if ([System.Runtime.InteropServices.RuntimeEnvironment]::FromGlobalAccessCache($_))
#        {
#            Write-Host "Already GACed: $Name"
#        }else
#        {
#            Write-Host -ForegroundColor Yellow "NGENing      : $Name"
#            ngen $_.location | %{"`t$_"}
#         }
#      }
#
#
# how to use static members:
#   see: http://blogs.msdn.com/powershell/archive/2008/12/13/explore-your-environment.aspx
#
#   Get-Date | Get-Member -Static 
#   [DateTime] | gm -s 
#   [Datetime]::Today
#   [Environment]::OSVersion 
#

##############################################################################################################
## Wget
## http://huddledmasses.org/wget-2-for-powershell/
function wget {
   param(
      $url = (Read-Host "The URL to download"),
      $fileName = $null,
      [switch]$Passthru,
      [switch]$quiet
   )
   
   $req = [System.Net.HttpWebRequest]::Create($url);
   $res = $req.GetResponse();
 
   if($fileName -and !(Split-Path $fileName)) {
      $fileName = Join-Path (Get-Location -PSProvider "FileSystem") $fileName
   }
   elseif((!$Passthru -and ($fileName -eq $null)) -or (($fileName -ne $null) -and (Test-Path -PathType "Container" $fileName)))
   {
      [string]$fileName = ([regex]'(?i)filename=(.*)$').Match( $res.Headers["Content-Disposition"] ).Groups[1].Value
      $fileName = $fileName.trim("\/""'")
      if(!$fileName) {
         $fileName = $res.ResponseUri.Segments[-1]
         $fileName = $fileName.trim("\/")
         if(!$fileName) {
            $fileName = Read-Host "Please provide a file name"
         }
         $fileName = $fileName.trim("\/")
         if(!([IO.FileInfo]$fileName).Extension) {
            $fileName = $fileName + "." + $res.ContentType.Split(";")[0].Split("/")[1]
         }
      }
      $fileName = Join-Path (Get-Location -PSProvider "FileSystem") $fileName
   }
   if($Passthru) {
      $encoding = [System.Text.Encoding]::GetEncoding( $res.CharacterSet )
      [string]$output = ""
   }
 
   if($res.StatusCode -eq 200) {
      [int]$goal = $res.ContentLength
      $reader = $res.GetResponseStream()
      if($fileName) {
         $writer = new-object System.IO.FileStream $fileName, "Create"
      }
      [byte[]]$buffer = new-object byte[] 4096
      [int]$total = [int]$count = 0
      do
      {
         $count = $reader.Read($buffer, 0, $buffer.Length);
         if($fileName) {
            $writer.Write($buffer, 0, $count);
         }
         if($Passthru){
            $output += $encoding.GetString($buffer,0,$count)
         } elseif(!$quiet) {
            $total += $count
            if($goal -gt 0) {
               Write-Progress "Downloading $url" "Saving $total of $goal" -id 0 -percentComplete (($total/$goal)*100)
            } else {
               Write-Progress "Downloading $url" "Saving $total bytes..." -id 0
            }
         }
      } while ($count -gt 0)
     
      $reader.Close()
      if($fileName) {
         $writer.Flush()
         $writer.Close()
      }
      if($Passthru){
         $output
      }
   }
   $res.Close();
   if($fileName) {
      ls $fileName
   }
}

