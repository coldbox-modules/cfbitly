This SDK allows you to add Bit.ly URL shortening and expanding to your ColdFusion (CFML) applications. You will need an Bit.ly API key in order to use this model. For more information visit: https://dev.bitly.com/

## Installation 
This SDK can be installed as standalone or as a ColdBox Module.  Either approach requires a simple CommandBox command:

```
box install cfbitly
```

Then follow either the standalone or module instructions below.

### Standalone

This SDK will be installed into a directory called `cfbitly` and then the SDK can be instantiated via ` new cfbitly.Bitly()` with the following constructor arguments:

```
/**
* Constructor
* @APIVersion The API version to use. Defaults to 2.0.1
* @APILogin The API login to use
* @APIKey The API key to connect with
*/
function init( APIVersion="2.0.1", required APILogin, required APIKey ){
```

### ColdBox Module

This package also is a ColdBox module as well.  The module can be configured by creating an `bitly` configuration structure in your application configuration file: `config/Coldbox.cfc` with the following settings:

```
// Bitly Settings
bitly = {
	// The version of the api to use, defaults to 2.0.1
	APIVersion = "2.0.1",  
	// The login to use
	APILogin = "",
	// The API Key to use
	APIKey = ""
};
```

Then you can leverage the SDK CFC via the injection DSL: `bitly@bitly`

## Usage

Here are the functions you can use with this SDK

```
function shorten( required inURL )
function expand( required inURL, required inUserHash )
```