|Master Build CI Status|Develop Build CI Status|
|----------------------|-----------------------|
|[![Build Status](http://jenkins.consilio.com/job/Cookbooks/job/relativity/job/hl-relativity-ci-master/badge/icon)](http://jenkins.consilio.com/job/Cookbooks/job/relativity/job/hl-relativity-ci-master/)|[![Build Status](http://jenkins.consilio.com/job/Cookbooks/job/relativity/job/hl-relativity-ci-develop/badge/icon)](http://jenkins.consilio.com/job/Cookbooks/job/relativity/job/hl-relativity-ci-develop/)|

# relativity

Creates a relativity environment from the ground up.

## Supported Platforms

### Tested And Validated On
- Windows Server 2012 R2

## Usage

Add `relativity::default` to your run_list.  Include any attributes you'd like
set for that cluster node.  Be sure to include at least one install directive.

EX. .kitchen.yml to install a Primary SQL server with *ALL* default settings.
```yaml
suites:
  - name: primarysql
    run_list:
      - recipe[relativity]
    attributes:
      Relativity:
        SQLPrimary:
          Install: 1
```

### Chef Provisioning
Knife must be configured to be able to talk to the
chef server being used.   Generally this can be done
by downloading the starter kit from the server in
question, which should supply a knife.rb file and
the needed ssl certificates for the server trust to
be established.

The following gems are required for provisioning to
a vRA environment:
* `vmware-vra`
* `chef-provisioning-vra`

See the Setup section in this document for instructions on installing them.

The following must be added to your default knife.rb
file.  This file is generally found in
`$user/.chef/knife.rb`.
```ruby
driver_options           username: 'user@consilio.com',
                         password: 'password',
                         tenant: 'Engineering',
                         verify_ssl: false,
                         max_wait_time: 1800
```

To run a provision via a provisioning recipe `recipe.rb`:
```bash
chef-client -c path/to/knife.rb path/to/recipe.rb
```

## Setup

To setup this cookbook for development work or for testing:

1. Install ChefDK.
2. Clone this cookbook from its repository (if not already done).
3. Run `chef exec rake setup:all`

## Testing

How to execute the tests included with this cookbook.

### Style guides
Run all style guides:
```bash
chef exec rake style
```
Two linters are configured via rake:
* Foodcritic - Run `chef exec rake style:foodcritic`
* Rubocop - Run `chef exec rake style:rubocop`

### Unit tests
Run all unit tests:
```bash
chef exec rake unit
```
Unit tests are provided by chefspec via rake:
* Chefspec - Run `chef exec rake unit:chefspec`

### Integration tests
The test-kitchen harness is configured to run tests after automatically building a test environment and executing the relativity on the environment.  A rake task is provided to run end to end testing.
Create/Converge/Verify/Destroy in one go:
`chef exec rake integration:kitchen` or `kitchen test`
Integration tests are configured to run against Consilio's vRA cloud infrastructure.

## Packaging and Deployment
Versioning for these tasks is taken directly from the `metadata.rb` file.

### Packaging
An automated rake task has been provided to create a tarball of the deployable cookbook items.
`chef exec rake build:package`

### Deployment
Automated deployment scripting is available from the Jenkins CI server and enabled via a rake task.
`chef exec rake build:deploy`

## Utility
Clean and Clobber tasks have been provided in rake, as well as a list task.  They are accessible as:
* `chef exec rake list` - lists all available rake tasks
* `chef exec rake clean` - removes build/test by products
* `chef exec rake clobber` - removes final packages

## CI/D
Continuous Integration and Deployment functions are provided through Jenkins and the associated `Jenkinsfile` in the repository.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like add_component_x)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
