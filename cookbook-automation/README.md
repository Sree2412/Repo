# automation

TODO: Enter the cookbook description here.

## Supported Platforms

### Tested And Validated On
- Centos 7
- Windows Server 2012 R2

## Usage

TODO: Include usage patterns of any providers or recipes.

### automation::default

Include `automation` in your run_list.

```json
{
  "run_list": [
    "recipe[automation::default]"
  ]
}
```

## Setup

To setup this cookbook for development work or for testing:

1. Install ChefDK.
2. Clone this cookbook from its repository (if not already done).
3. Run `chef exec bundle install`
4. Run `chef exec rake setup:all`

## Testing

How to execute the tests included with this cookbook.

### Style guides
Two linters are configured via rake:
* Foodcritic - Run `chef exec rake style:foodcritic`
* Rubocop - Run `chef exec rake style:rubocop`

### Unit tests
Unit tests are provided by chefspec via rake:
* Chefspec - Run `chef exec rake unit:chefspec`

### Integration tests
The test-kitchen harness is configured to run tests after automatically building a test environment and executing the automation on the environment.  A rake task is provided to run end to end testing.
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
