# returns current environment settings
function _getEnvironmentState {
    [CmdletBinding()]
    param()

    Write-Verbose 'getting the current environment state...'
    
    $ErrorActionPreference = 'silentlycontinue'

    # check if the node is registered to chef
    $_knifeResults = & knife node show $NodeName

    if ($_knifeResults) { 
        Write-Verbose 'chef server returned something!'
        $_chefNode = ($_knifeResults | Where-Object { $_ -match "Node Name:" }).Replace('Node Name:','').Trim()
        $_chefFQDN_listed = ($_knifeResults | Where-Object { $_ -match "FQDN" }).Replace('FQDN:','').Replace('.consilio.com','').Trim()

        # Get the status of the chefFQDN to see if it's a valid node still in vRA
        $_chef_server_status = Get-MachineStatus $_chefFQDN_listed

        if ($_chef_server_status.Status -eq 'Active') {
            Write-Verbose "using machine $_chefFQDN_listed as it appears to be valid!"
            $_chefFQDN = $_chefFQDN_listed
        }
    }

    # check to see if there's a machine file from _getVM
    $_machine_file_path = ".cider\provision_artifact\$NodeName.txt"
    
    if (Test-Path $_machine_file_path) {
        # make sure the machine is still up!
        $_oldmachine = Get-Content $_machine_file_path        
        $_serverStatus = Get-MachineStatus $_oldmachine

        if ($_serverStatus.Status -eq 'ACTIVE') {
            $_webserver = $_oldmachine
        }
        else {
            Write-Verbose "Appears this is a lingering file... deleting $_machine_file_path"
            # Delete the file! 
            Remove-Item $_machine_file_path
        }
    }

    # now there COULD be the case where the chefFQDN IS valid, but no machine file was found
    # in this case, we should write out the machine file
    if ($_chefFQDN -and ($_webserver -eq $null)) {
        
        Write-Verbose "writing out the machine file $_machine_file_path for consistency"
        $_webserver = $_chefFQDN

        $_parent_dir = Split-Path $_machine_file_path -Parent
        if (-not (Test-Path $_parent_dir)) {New-Item -ItemType Container -Path $_parent_dir | Out-Null }
        $_webserver | Out-File -FilePath $_machine_file_path -Encoding ascii -NoNewline
    }

    $_props = [Ordered]@{
        ChefNode = $_chefNode
        ChefFQDN = $_chefFQDN
        vRAFQDN = $_webserver
    }

    return New-Object -TypeName PSobject -Property $_props
}