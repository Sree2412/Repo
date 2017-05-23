# REST-gen
A REST service generator to test REST services with auto-generated data

## Why another REST library?
The purpose of this library is to automate REST services.  Why another REST library?  It can take quite some time and manual effort to setup hundreds of REST calls with corresponding data.  As calls change, it can be tedious and error-prone to keep everything up-to-date.  With REST testing, there is no reason to have a control data set when our main goal is to verify the service works.

## What can this library do?
The power of this library lies in a map file.  The map file allows the following:
- Special sequencing of URL's (i.e. http://localhost:8080/odata/Apps(5))
- Generated data to be used for service calls
- Dependency chaining allows calls such as put to have the post called first in order for the call to succeed
- Data strucutre pre-defined for each entity

## Usage
instance = Restgen.new('base-url')

// url based
instance.get(url: 'full-url')

// configuration based
instance.load_configuration('file-path')
instance.get(entityName: 'entity-name')

Note: if authentication is needed then the following call to 'set_auth' will need to be made
instance.set_auth('username', 'password')

## Configuration Map File
calling the 'load_configuration' will load a json file which contains your configuration.  Below is an example based on Claims Auth

```json
{
    "entities": [{
        "name": "app",
        "schema": [{
            "propertyName": "Id",
            "propertyType": "number",
            "primaryKey": true
        },
        {
            "propertyName": "Name",
            "propertyType": "string",
            "minlength": 3,
            "maxlength": 30
        }],        
        "get": "Apps",
        "post": "Apps",
        "patch": "Apps(@Id)",
        "put": "Apps(@Id)",
        "delete": "Apps(@Id)"
    },
    {
        "name": "propertyClaim",
        "schema": [{
            "propertyName": "Id",
            "propertyType": "number",
            "primaryKey": true
        },
        {
            "propertyName": "AppId",
            "propertyType": "number",
            "foreignKey": "app"
        },
        {
            "propertyName": "Name",
            "propertyType": "string",
            "minlength": 3,
            "maxlength": 30
        },
        {
            "propertyName": "Type",
            "propertyType": "string",
            "minlength": 3,
            "maxlength": 30
        },
        {
            "propertyName": "ValueType",
            "propertyType": "string",
            "minlength": 3,
            "maxlength": 30
        }],        
        "get": "Apps(@AppId)/Claims",
        "post": "PropertyClaims",
        "patch": "PropertyClaims(@Id)",
        "put": "PropertyClaims(@Id)",
        "delete": "PropertyClaims(@Id)"
    }]
}
```

## Dependencies
This library supports the conecpt of dependency chaining.  Notice in the above example that "propertyClaim/AppId" has a foreign key relationship to the entity "app" which has a primary key of "app/Id".  What this means is that when a user tries to test the entity "propertyClaim", because of this constraint, the "app" entity will be created first and the "Id" of that entity will be substituted in place for the "AppId" in propertyClaim.

In order to use a foreign key from an already generated object.  Use the key "dependentProperty" and specify the property as the value.

## Logging
The library also supports log file generation.  By default, logging outputs to the console.  To specify a file use the following command

set_log_filepath(filename)

each time the library is loaded, it will overwrite any existing log files with the same name.