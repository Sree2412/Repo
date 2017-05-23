# default['']['']['']

# override this to 1 if installing the primary SQL server
# note, this should be the first install in the process
# of building a new relativity environment
default['Relativity']['SQLPrimary']['Install'] = 0

################### PRIMARY DATABASE PROPERTIES ######################
### The following properties are required only when installing the Primary Database
######################################################################
## These are the required path properties for installing the primary database
# These paths must be a shared folder that both the user running the installer
# and the Relativity Service Account have read/write permissions to.

# Target UNC path for the default file repository.
default['Relativity']['SQLPrimary']['FileRepo'] = ""

# Target UNC path for the EDDS File Share.
default['Relativity']['SQLPrimary']['EDDSFileShare'] = ""

# Target UNC path for the dtSearch Indexes to be stored.
default['Relativity']['SQLPrimary']['DTSearch'] = ""
    
