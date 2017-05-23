# default['']['']['']

################### WORKER PROPERTIES #################################
### The following properties are only required only when installing Agents
###
### Before you can successfully install the worker you need to be sure that
### that the SQL Service account has a registered SPN
######################################################################

# Invariant Installer


# set these to choose what is being installed
default['Relativity']['InvariantDatabase']['Install'] = 0
default['Relativity']['InvariantQueueManager']['Install'] = 0
default['Relativity']['InvariantWorker']['Install'] = 0

default['Relativity']['Invariant']['ConversionOnly'] = 0

# Invariant SQL Instance
default['Relativity']['Invariant']['SQLInstance'] = ""

# QueueManager Install Path
default['Relativity']['Invariant']['QueueManagerInstallPath'] = "C:\\Program Files\\kCura Corporation\\Invariant\\QueueManager\\"

# Worker Install Path
default['Relativity']['Invariant']['WorkerInstallPath'] = "C:\\Program Files\\kCura Corporation\\Invariant\\Worker\\"
