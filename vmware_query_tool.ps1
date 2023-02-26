#vCenter VM query Tool v0.1, authored by Joshua Williams, jwilliamstech.com

$psFolder = Test-Path -Path 'C:\Users\ExampleUser\Documents\PS_Scripts\'

if ( -not $psFolder ){

    New-Item 'C:\Power Shell' -ItemType Directory

}

$listcontoso = Test-Path -Path 'C:\Users\ExampleUser\Documents\PS_Scripts\contoso_vcenter_list.txt'

if ( -not $listcontoso ){

    New-Item 'C:\Users\ExampleUser\Documents\PS_Scripts\contoso_vcenter_list.txt'

    Set-Content 'C:\Users\ExampleUser\Documents\PS_Scripts\contoso_vcenter_list.txt' 
'examplehost_01.contoso.com
examplehost_02.contoso.com
examplehost_03.contoso.com
examplehost_04.contoso.com
examplehost_05.contoso.com
examplehost_06.contoso.com
examplehost_07.contoso.com
examplehost_08.contoso.com'

}

$listwingdingsel = Test-Path -Path 'C:\Users\ExampleUser\Documents\PS_Scripts\wingdings_vcenter_list.txt'

if ( -not $listwingdingsel ){

    New-Item 'C:\Users\ExampleUser\Documents\PS_Scripts\wingdings_vcenter_list.txt'

    Set-Content 'C:\Users\ExampleUser\Documents\PS_Scripts\wingdings_vcenter_list.txt' 
'examplehost_01.wingdings.com
examplehost_02.wingdings.com
examplehost_03.wingdings.com
examplehost_04.wingdings.com
examplehost_05.wingdings.com
examplehost_06.wingdings.com
examplehost_07.wingdings.com
examplehost_08.wingdings.com'

}

Set-ExecutionPolicy remotesigned

Write-Host 'Clearing active vCenter connections.'

Disconnect-VIServer -Server * -Force  -confirm:$false

$credential = Get-Credential -Message "Please use your contoso email credentials."

$startLocation = "C:\Users\ExampleUser\Documents\PS_Scripts\"

$condition = Test-Path -Path "C:\Program Files\WindowsPowerShell\Modules\VMware.PowerCLI"

if ( -not $condition ){

    Install-Module VMware.PowerCLI

}

Set-PowerCLIConfiguration -Scope AllUsers -ParticipateInCeip $false -InvalidCertificateAction Ignore

$contoso = New-Object System.Management.Automation.Host.ChoiceDescription '&Contoso', 'vCenter: Contoso'

$wingdings = New-Object System.Management.Automation.Host.ChoiceDescription '&Wingdings', 'vCenter: Wingdings'

$exit = New-Object System.Management.Automation.Host.ChoiceDescription '&Exit', 'Exit'

$options = [System.Management.Automation.Host.ChoiceDescription[]]($contoso, $wingdings, $Exit)

$title = 'vCenter Sign-in'

$message = 'Which Organizational vCenter would you like to access? Remember, you must be connected to the corresponding VPN in order to access the organizational vCenter instance.'

$result = $host.ui.PromptForChoice($title, $message, $options, 0)

if ($result -eq 0) {

    $servers = Get-Content $startlocation'contoso_vcenter_list.txt'

}

elseif ($result -eq 1) {

    $servers = Get-Content $startlocation'wingdings_vcenter_list.txt'

}

elseif ($result -eq 2) {

    exit

}

foreach ($server in $servers) {

    Write-Output "Connecting to " $server

    Connect-VIServer $server -Credential $credential

}

Write-Output "Connecting to vCenters is done."

Write-Output "Listing all connected vCenters..."

$global:DefaultVIServers

$virtualMachine = Read-Host 'Please enter the VM hostname that you are looking for'

Get-VM -Name $virtualMachine | Format-Table -AutoSize Name, VM, {$_.Guest.Nics.IPAddress}, PowerState, Uid