param (
    [string]
    $name,
    [string]
    $password
)

$pw = ConvertTo-SecureString $password -AsPlainText -Force
New-LocalUser $name -Password $pw

# Create home directory
$startInfo = New-Object System.Diagnostics.ProcessStartInfo
$startInfo.UserName = $name
$startInfo.Password = $pw
$startInfo.FileName = "cmd"
$startInfo.LoadUserProfile = $true
$startInfo.UseShellExecute = $false
$startInfo.RedirectStandardOutput = $false
[System.Diagnostics.Process]::Start($startInfo)
