Function Get-SherpaDeskAPIKey {
    [cmdletbinding(
        DefaultParameterSetName = 'EmailOnly'
    )]
    Param(
        [Parameter(
            ParameterSetName = 'EmailOnly'
        )]
        [string]$Email,
        [Parameter(
            ParameterSetName = 'Credential'
        )]
        [pscredential]$Credential
    )

    If($PSCmdlet.ParameterSetName -eq 'EmailOnly'){
        $credential = Get-Credential -UserName $Email -Message 'Retrieving API key from Sherpa Desk'
    }

    $up = "$($credential.GetNetworkCredential().UserName)`:$($credential.GetNetworkCredential().Password)"
    $encodedUP = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("$up"))

    $header = @{
        Authorization = "Basic $encodedUP"
        #'Content-Type' = 'application/json'
        'Accept' = 'application/json'
    }
    Invoke-RestMethod -Method Get -Uri 'https://api.sherpadesk.com/login' -Headers $header
}