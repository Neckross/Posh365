function Get-MemDevice {
    [CmdletBinding(DefaultParameterSetName = 'PlaceHolder')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'SerialNumber')]
        $SerialNumber,

        [Parameter(Mandatory, ParameterSetName = 'imei')]
        $imei,

        [Parameter(Mandatory, ParameterSetName = 'ManagementState')]
        [ValidateSet('retirePending', 'managed')]
        $managementState
    )
    if ($imei) {
        Get-MemDeviceData -imei $imei | Select-Object @(
            'userDisplayName'
            'deviceName'
            @{
                Name       = 'LastSyncLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.lastSyncDateTime)).ToLocalTime() }
            }
            @{
                Name       = 'enrolledLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.enrolledDateTime)).ToLocalTime() }
            }
            'lastSyncDateTime'
            'enrolledDateTime'
            'complianceState'
            'deviceType'
            'operatingSystem'
            'osVersion'
            'phoneNumber'
            'model'
            'manufacturer'
            'imei'
            'id'
            'userId'
            'ownerType'
            'managedDeviceOwnerType'
            'managementState'
            'chassisType'
            'jailBroken'
            'managementAgent'
            'easActivated'
            'easDeviceId'
            'easActivationDateTime'
            'aadRegistered'
            'azureADRegistered'
            'deviceEnrollmentType'
            'lostModeState'
            'activationLockBypassCode'
            'emailAddress'
            'azureActiveDirectoryDeviceId'
            'azureADDeviceId'
            'deviceRegistrationState'
            'deviceCategoryDisplayName'
            'isSupervised'
            'exchangeLastSuccessfulSyncDateTime'
            'exchangeAccessState'
            'exchangeAccessStateReason'
            'remoteAssistanceSessionUrl'
            'remoteAssistanceSessionErrorDetails'
            'isEncrypted'
            'userPrincipalName'
            'complianceGracePeriodExpirationDateTime'
            'serialNumber'
            'androidSecurityPatchLevel'
            'configurationManagerClientEnabledFeatures'
            'wiFiMacAddress'
            'deviceHealthAttestationState'
            'subscriberCarrier'
            'meid'
            'totalStorageSpaceInBytes'
            'freeStorageSpaceInBytes'
            'managedDeviceName'
            'partnerReportedThreatState'
            'retireAfterDateTime'
            'preferMdmOverGroupPolicyAppliedDateTime'
            'autopilotEnrolled'
            'requireUserEnrollmentApproval'
            'managementCertificateExpirationDate'
            'iccid'
            'udid'
            'roleScopeTagIds'
            'windowsActiveMalwareCount'
            'windowsRemediatedMalwareCount'
            'notes'
            'configurationManagerClientHealthState'
            'configurationManagerClientInformation'
            'ethernetMacAddress'
            'physicalMemoryInBytes'
            'processorArchitecture'
            'specificationVersion'
            'joinType'
            'skuFamily'
            'skuNumber'
            'managementFeatures'
            @{
                name       = 'ipAddressV4'
                expression = { $_.hardwareInformation.ipAddressV4 }
            }
            'deviceActionResults'
            'usersLoggedOn'
        )
    }
    elseif ($SerialNumber) {
        Get-MemDeviceData -SerialNumber $SerialNumber | Select-Object @(
            'userDisplayName'
            'deviceName'
            @{
                Name       = 'LastSyncLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.lastSyncDateTime)).ToLocalTime() }
            }
            @{
                Name       = 'enrolledLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.enrolledDateTime)).ToLocalTime() }
            }
            'lastSyncDateTime'
            'enrolledDateTime'
            'complianceState'
            'deviceType'
            'operatingSystem'
            'osVersion'
            'phoneNumber'
            'model'
            'manufacturer'
            'imei'
            'id'
            'userId'
            'ownerType'
            'managedDeviceOwnerType'
            'managementState'
            'chassisType'
            'jailBroken'
            'managementAgent'
            'easActivated'
            'easDeviceId'
            'easActivationDateTime'
            'aadRegistered'
            'azureADRegistered'
            'deviceEnrollmentType'
            'lostModeState'
            'activationLockBypassCode'
            'emailAddress'
            'azureActiveDirectoryDeviceId'
            'azureADDeviceId'
            'deviceRegistrationState'
            'deviceCategoryDisplayName'
            'isSupervised'
            'exchangeLastSuccessfulSyncDateTime'
            'exchangeAccessState'
            'exchangeAccessStateReason'
            'remoteAssistanceSessionUrl'
            'remoteAssistanceSessionErrorDetails'
            'isEncrypted'
            'userPrincipalName'
            'complianceGracePeriodExpirationDateTime'
            'serialNumber'
            'androidSecurityPatchLevel'
            'configurationManagerClientEnabledFeatures'
            'wiFiMacAddress'
            'deviceHealthAttestationState'
            'subscriberCarrier'
            'meid'
            'totalStorageSpaceInBytes'
            'freeStorageSpaceInBytes'
            'managedDeviceName'
            'partnerReportedThreatState'
            'retireAfterDateTime'
            'preferMdmOverGroupPolicyAppliedDateTime'
            'autopilotEnrolled'
            'requireUserEnrollmentApproval'
            'managementCertificateExpirationDate'
            'iccid'
            'udid'
            'roleScopeTagIds'
            'windowsActiveMalwareCount'
            'windowsRemediatedMalwareCount'
            'notes'
            'configurationManagerClientHealthState'
            'configurationManagerClientInformation'
            'ethernetMacAddress'
            'physicalMemoryInBytes'
            'processorArchitecture'
            'specificationVersion'
            'joinType'
            'skuFamily'
            'skuNumber'
            'managementFeatures'
            @{
                name       = 'ipAddressV4'
                expression = { $_.hardwareInformation.ipAddressV4 }
            }
            'deviceActionResults'
            'usersLoggedOn'
        )
    }
    elseif ($managementState) {
        Get-MemDeviceData -ManagementState $managementState | Select-Object @(
            'userDisplayName'
            'deviceName'
            @{
                Name       = 'LastSyncLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.lastSyncDateTime)).ToLocalTime() }
            }
            @{
                Name       = 'enrolledLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.enrolledDateTime)).ToLocalTime() }
            }
            'lastSyncDateTime'
            'enrolledDateTime'
            'complianceState'
            'deviceType'
            'operatingSystem'
            'osVersion'
            'phoneNumber'
            'model'
            'manufacturer'
            'imei'
            'id'
            'userId'
            'ownerType'
            'managedDeviceOwnerType'
            'managementState'
            'chassisType'
            'jailBroken'
            'managementAgent'
            'easActivated'
            'easDeviceId'
            'easActivationDateTime'
            'aadRegistered'
            'azureADRegistered'
            'deviceEnrollmentType'
            'lostModeState'
            'activationLockBypassCode'
            'emailAddress'
            'azureActiveDirectoryDeviceId'
            'azureADDeviceId'
            'deviceRegistrationState'
            'deviceCategoryDisplayName'
            'isSupervised'
            'exchangeLastSuccessfulSyncDateTime'
            'exchangeAccessState'
            'exchangeAccessStateReason'
            'remoteAssistanceSessionUrl'
            'remoteAssistanceSessionErrorDetails'
            'isEncrypted'
            'userPrincipalName'
            'complianceGracePeriodExpirationDateTime'
            'serialNumber'
            'androidSecurityPatchLevel'
            'configurationManagerClientEnabledFeatures'
            'wiFiMacAddress'
            'deviceHealthAttestationState'
            'subscriberCarrier'
            'meid'
            'totalStorageSpaceInBytes'
            'freeStorageSpaceInBytes'
            'managedDeviceName'
            'partnerReportedThreatState'
            'retireAfterDateTime'
            'preferMdmOverGroupPolicyAppliedDateTime'
            'autopilotEnrolled'
            'requireUserEnrollmentApproval'
            'managementCertificateExpirationDate'
            'iccid'
            'udid'
            'roleScopeTagIds'
            'windowsActiveMalwareCount'
            'windowsRemediatedMalwareCount'
            'notes'
            'configurationManagerClientHealthState'
            'configurationManagerClientInformation'
            'ethernetMacAddress'
            'physicalMemoryInBytes'
            'processorArchitecture'
            'specificationVersion'
            'joinType'
            'skuFamily'
            'skuNumber'
            'managementFeatures'
            @{
                name       = 'ipAddressV4'
                expression = { $_.hardwareInformation.ipAddressV4 }
            }
            'deviceActionResults'
            'usersLoggedOn'
        )
    }
    else {
        Get-MemMobileDeviceListData | Select-Object @(
            'userDisplayName'
            'deviceName'
            @{
                Name       = 'LastSyncLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.lastSyncDateTime)).ToLocalTime() }
            }
            @{
                Name       = 'enrolledLocal'
                Expression = { '{0:yyyy}-{0:MM}-{0:dd} {0:HH}:{0:mm}' -f ([DateTime]($_.enrolledDateTime)).ToLocalTime() }
            }
            'lastSyncDateTime'
            'enrolledDateTime'
            'complianceState'
            'deviceType'
            'operatingSystem'
            'osVersion'
            'phoneNumber'
            'model'
            'manufacturer'
            'imei'
            'id'
            'userid'
            'ownerType'
            'managedDeviceOwnerType'
            'managementState'
            'chassisType'
            'jailBroken'
            'managementAgent'
            'easActivated'
            'easDeviceId'
            'easActivationDateTime'
            'aadRegistered'
            'azureADRegistered'
            'deviceEnrollmentType'
            'lostModeState'
            'activationLockBypassCode'
            'emailAddress'
            'azureActiveDirectoryDeviceId'
            'azureADDeviceId'
            'deviceRegistrationState'
            'deviceCategoryDisplayName'
            'isSupervised'
            'exchangeLastSuccessfulSyncDateTime'
            'exchangeAccessState'
            'exchangeAccessStateReason'
            'remoteAssistanceSessionUrl'
            'remoteAssistanceSessionErrorDetails'
            'isEncrypted'
            'userPrincipalName'
            'complianceGracePeriodExpirationDateTime'
            'serialNumber'
            'androidSecurityPatchLevel'
            'configurationManagerClientEnabledFeatures'
            'wiFiMacAddress'
            'deviceHealthAttestationState'
            'subscriberCarrier'
            'meid'
            'totalStorageSpaceInBytes'
            'freeStorageSpaceInBytes'
            'managedDeviceName'
            'partnerReportedThreatState'
            'retireAfterDateTime'
            'preferMdmOverGroupPolicyAppliedDateTime'
            'autopilotEnrolled'
            'requireUserEnrollmentApproval'
            'managementCertificateExpirationDate'
            'iccid'
            'udid'
            'roleScopeTagIds'
            'windowsActiveMalwareCount'
            'windowsRemediatedMalwareCount'
            'notes'
            'configurationManagerClientHealthState'
            'configurationManagerClientInformation'
            'ethernetMacAddress'
            'physicalMemoryInBytes'
            'processorArchitecture'
            'specificationVersion'
            'joinType'
            'skuFamily'
            'skuNumber'
            'managementFeatures'
            'hardwareInformation'
            @{
                name       = 'ipAddressV4'
                expression = { $_.hardwareInformation.ipAddressV4 }
            }
            'deviceActionResults'
            'usersLoggedOn'
        )
    }
}
