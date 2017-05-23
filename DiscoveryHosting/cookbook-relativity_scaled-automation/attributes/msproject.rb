#########################################################################################################################
###  MSPROJECT ATTRIBUTES
#########################################################################################################################

# Set this attribute to the your Product Key, or keep it nil to activate manually
default['msproject']['pid_key'] = nil

# Set this attribute to the true if you want to activate MS Office automatically
default['msproject']['auto_activate'] = false

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['msproject']['source'] = 'https://hk1-packages.consilio.com/hk1nas00/tech/Software/MSProject/'

# MS Office 2013
default['msproject']['professional']['package_name'] = 'Microsoft Office Project Professional'
default['msproject']['professional']['filename'] = 'SW_DVD5_Project_Pro_2010w_SP1_W32_English_MLF_X17-76660.ISO'

# Currently you cannot change this, doing so will break the cookbook
default['msproject']['registrykey']['64bit'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Office\\14.0\\Common\\InstalledPackages\\90140000-003B-0000-0000-0000000FF1CE'
