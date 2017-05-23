#########################################################################################################################
###  MSOFFICE ATTRIBUTES
#########################################################################################################################

default['msoffice']['edition'] = 'professional' # other editions are not supported yet
default['msoffice']['version'] = '64bit' # or '32bit'

# Set this attribute to the your Product Key, or keep it nil to activate manually
default['msoffice']['pid_key'] = nil

# Set this attribute to the true if you want to activate MS Office automatically
default['msoffice']['auto_activate'] = false

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['msoffice']['source'] = 'https://packages.consilio.com/hlnas00/tech/Software/MSOffice/'

# MS Office 2013
default['msoffice']['professional']['package_name'] = 'Microsoft Office Professional Plus 2010'
default['msoffice']['professional']['filename'] = 'SW_DVD5_Office_Professional_Plus_2010w_SP1_W32_English_CORE_MLF_X17-76748.iso'

# Currently you cannot change this, doing so will break the cookbook
default['msoffice']['registrykey']['64bit'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Microsoft\\Office\\14.0\\Common\\InstalledPackages\\90140000-0011-0000-0000-0000000FF1CE'
