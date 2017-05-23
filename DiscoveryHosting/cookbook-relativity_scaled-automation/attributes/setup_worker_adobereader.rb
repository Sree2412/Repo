#########################################################################################################################
###  ADOBE READER ATTRIBUTES
#########################################################################################################################

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['adobe']['source'] = 'https://packages.consilio.com/hlnas00/tech/Software/AdobeReader/'

default['adobe']['package_name'] = 'AdbeRdr11000_mui_Std'
default['adobe']['filename'] = 'AdbeRdr11000_mui_Std.zip'

# Currently you cannot change this, doing so will break the cookbook
default['adobe']['registrykey'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Adobe\\Acrobat Reader'
