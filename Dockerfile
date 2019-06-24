FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV SPINNER_VERSION=1.0.8 \
    USER=user

COPY sshd_config C:/ProgramData/ssh/sshd_config
COPY add_user.ps1 C:/Windows/Temp/add_user.ps1

RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y git; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest $('https://github.com/ticketmaster/spinner/releases/download/v{0}/spinner_windows_amd64-v{0}.zip' -f $Env:SPINNER_VERSION) -OutFile spinner.zip -UseBasicParsing; \
    Expand-Archive spinner.zip; \
    Remove-Item spinner.zip; \
    Move-Item spinner\spinner_v$Env:SPINNER_VERSION.exe spinner.exe; \
    Remove-Item spinner; \
    choco install -y openssh -params '"/SSHServerFeature /PathSpecsToProbeForShellEXEString:C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"'; \
    C:/Windows/Temp/add_user.ps1 $Env:USER Addsafasdfasdf!; \
    Add-LocalGroupMember -Group "Administrators" -Member $Env:USER
COPY authorized_keys C:/Users/$USER/.ssh/authorized_keys

CMD Start-Sleep 5; ./spinner.exe service sshd -t C:/ProgramData/ssh/logs/sshd.log
