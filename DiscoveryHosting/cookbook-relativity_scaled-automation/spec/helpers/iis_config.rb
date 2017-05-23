# matcher for iis_config because the included one is broken
# documentation says to use :set action over the deprecated
# :config action, but the matcher only understands the old
# :config action.

def set_iis_config(command)
  ChefSpec::Matchers::ResourceMatcher.new(:iis_config, :set, command)
end
