Param(
    $azdo_server_url,
    $azdo_agent_pool,
    $azdo_agent_name,
    $azdo_pat
)

Set-ExecutionPolicy Bypass -Scope Process -Force; 
#Install dotnet core, nodejs and npm with chocolatey
iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));
choco feature enable -n allowGlobalConfirmation;
choco install dotnetcore-sdk -y;
choco install nodejs -y;
choco install webdeploy -y;

$downloadDirectory = Join-Path $env:SystemDrive 'agent';
New-Item -Path $downloadDirectory -ItemType Directory -force | Out-Null;

$clnt = new-object System.Net.WebClient;
$url = "https://vstsagentpackage.azureedge.net/agent/2.129.1/vsts-agent-win-x64-2.129.1.zip";
$file = Join-Path $downloadDirectory ([System.IO.Path]::GetFileName($url));
$clnt.DownloadFile($url,$file);

Expand-Archive -Path $file -DestinationPath $downloadDirectory;

C:/agent/bin/Agent.Listener.exe configure --unattended --url $azdo_server_url --agent $azdo_agent_name --pool $azdo_agent_pool --auth PAT --token $azdo_pat --work "_work" --windowsLogonAccount "NT AUTHORITY\SYSTEM" --replace --runAsService --runAsAutoLogon;