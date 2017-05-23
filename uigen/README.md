# UI-gen
A UI automation framework that uses workflow principals to orchestrate UI composition.

## Usage
instance = UIgen.new('base-url')

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
