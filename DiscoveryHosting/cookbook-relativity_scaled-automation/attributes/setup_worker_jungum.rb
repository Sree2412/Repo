#########################################################################################################################
###  JUNGUM ATTRIBUTES
#########################################################################################################################

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['jungum']['source'] = 'https://packages.consilio.com/hlnas00/tech/Software/Jungum/'

default['jungum']['package_name'] = 'JungUmGW_Viewer_20140220_v913_780'
default['jungum']['filename'] = 'JungUmGW_Viewer_20140220_v913_780.zip'

# Currently you cannot change this, doing so will break the cookbook
default['jungum']['registrykey'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Samsung\\JungUm Global Viewer'
