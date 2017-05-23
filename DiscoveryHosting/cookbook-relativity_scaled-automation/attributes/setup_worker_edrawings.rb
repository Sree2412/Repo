#########################################################################################################################
###  ADOBE READER ATTRIBUTES
#########################################################################################################################

# Set this attribute yourself to the FQDN of the folder which contains the ISO
default['edrawings']['source'] = 'https://packages.consilio.com/hlnas00/tech/Software/eDrawingsViewer/'

default['edrawings']['package_name'] = 'eDrawingsFullAll'
default['edrawings']['filename'] = 'eDrawingsFullAll.7z'

# Currently you cannot change this, doing so will break the cookbook
default['edrawings']['registrykey'] = 'HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\eDrawings'
