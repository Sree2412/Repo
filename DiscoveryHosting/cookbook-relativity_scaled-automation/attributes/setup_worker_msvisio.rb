#########################################################################################################################
###  MSVISIO ATTRIBUTES
#########################################################################################################################

# Set this attribute to the your Product Key, or keep it nil to activate manually
default['msvisio']['pid_key'] = nil

# Set this attribute to the true if you want to activate MS Office automatically
default['msvisio']['auto_activate'] = false

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['msvisio']['source'] = 'https://packages.consilio.com/hlnas00/tech/Software/MSVisio/'

# MS Office 2013
default['msvisio']['professional']['package_name'] = 'Microsoft Office Visio'
default['msvisio']['professional']['filename'] = 'SW_DVD5_Visio_Premium_2010w_SP1_W32_English_Std_Pro_Prem_MLF_X17-75851.iso'

# Currently you cannot change this, doing so will break the cookbook
default['msvisio']['registrykey']['64bit'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Office\\14.0\\Common\\InstalledPackages\\90140000-0057-0000-0000-0000000FF1CE'
