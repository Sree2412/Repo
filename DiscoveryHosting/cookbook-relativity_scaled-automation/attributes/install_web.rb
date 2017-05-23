# default['']['']['']

################### WEB PROPERTIES #################################
### The following properties are only required only when installing Web
######################################################################

default['Relativity']['Web']['Install'] = 0
default['Relativity']['Web']['EnableWinAuth'] = 0

default['Consilio']['SSL']['WildCard'] = 'http://packages.consilio.com/hlnas00/tech/Software/WildCard/wildcard_consilio_com.pfx'
default['Consilio']['SSL']['WildCardFileName'] = 'wildcard_consilio_com.pfx'

default['Consilio']['SSL']['PFXPassword'] = Chef::EncryptedDataBagItem.load('wildcardcreds', 'wildcard-password', 'consiliopass123')['password']
