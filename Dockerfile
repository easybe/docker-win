FROM mcr.microsoft.com/windows/servercore:ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
ENV SPINNER_VERSION=1.0.8 \
    USER=user

COPY sshd_config C:/ProgramData/ssh/sshd_config
COPY add_user.ps1 C:/Windows/Temp/add_user.ps1
COPY spinner.1.0.8.nupkg C:/Windows/Temp/spinner.1.0.8.nupkg

RUN Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')); \
    choco install -y git; \
    choco install -y C:/Windows/Temp/spinner.1.0.8.nupkg; \
    choco install -y openssh -params '"/SSHServerFeature /PathSpecsToProbeForShellEXEString:C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"'; \
    C:/Windows/Temp/add_user.ps1 $Env:USER Addsafasdfasdf!; \
    Add-LocalGroupMember -Group "Administrators" -Member $Env:USER
COPY authorized_keys C:/Users/$USER/.ssh/authorized_keys

CMD Start-Sleep 5; spinner.exe service sshd -t C:/ProgramData/ssh/logs/sshd.log
