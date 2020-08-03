Param(
    $azdo_server_url,
    $azdo_agent_pool,
    $azdo_agent_name,
    $azdo_pat
)

#Install Azure DevOps Build Agent
$downloadDirectory = Join-Path $env:SystemDrive 'temp';
$azdoAgentDirectory = Join-Path $env:SystemDrive 'agent';
New-Item -Path $downloadDirectory -ItemType Directory -force | Out-Null;
New-Item -Path $azdoAgentDirectory -ItemType Directory -force | Out-Null;
Set-Location $azdoAgentDirectory;

$url = "https://vstsagentpackage.azureedge.net/agent/2.172.2/vsts-agent-win-x64-2.172.2.zip";
$file = Join-Path $downloadDirectory ([System.IO.Path]::GetFileName($url));
(New-Object System.Net.WebClient).DownloadFile($url,$file)
Expand-Archive -Path $file -DestinationPath $azdoAgentDirectory;

.\config.cmd --unattended --url $azdo_server_url --auth pat --token $azdo_pat --pool $azdo_agent_pool --agent $azdo_agent_name --work "_work" --runAsService --runAsAutoLogon --windowsLogonAccount "NT AUTHORITY\NETWORK SERVICE" --noRestart
 
#Install Chocolatey
#Set-ExecutionPolicy Bypass -Scope Process -Force
#Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Assign Packages to Install
#$Packages = 'googlechrome',`
#            'visualstudiocode',`
#            'git',`
#            'visualstudio2017community',`
#            'visualstudio2017-workload-azure',`
#            'visualstudio2017-workload-netweb'

#Install Packages
#ForEach ($PackageName in $Packages) {
#    choco install $PackageName -y
#}

#Reboot
#Restart-Computer