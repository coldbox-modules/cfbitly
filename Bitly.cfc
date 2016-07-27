/**
* An interface to bit.ly URL shortner
*/
component accessors="true" singleton{

	property name="APILogin";
	property name="APIKey";
	property name="APIURL";

	/**
	 * Constructor
	 * @APILogin The API login to use
	 * @APIKey The API key to connect with
	 */
	function init( required APILogin, required APIKey ){
  		// Credentials
  		variables.APILogin 	= arguments.APILogin;
  		variables.APIKey 	= arguments.APIKey;
  		variables.APIURL 	= "https://api-ssl.bitly.com/v3";
  		
  		//Return instance
  		return this;
	}

	/**
	 * Shorten the URL
	 * @inURL The target URL to shorten
	 *
	 * @result Struct: { long_url, url, hash, global_hash, new_hash }
	 */
	struct function shorten( required inURL ){
		var params 	= {};
		
		params[ "longUrl" ] = arguments.inURL;
		
		// Invoke call
		var results = makeRequest( resource="shorten", parameters=params );
		
		// error 
		if( results.response.status_code eq "ERROR" ){
			throw( message="Error making REST Call", detail=results.response.errorMessage );
		}
		
		return results.response.data;
	}

	/**
	 * Expand the URL
	 * @inURL The target URL to shorten
	 * @inUserHash The URL user hash
	 *
	 * @result a struct { expand: array }
	 */
	struct function expand( required inURL, required inUserHash ){
		var params = {};
		
		params[ "shortUrl" ] 	= arguments.inURL;
		params[ "hash" ] 		= arguments.inUserHash;
		
		// Invoke call
		var results = makeRequest( resource="expand", parameters=params );
		
		// error 
		if( results.response.status_code eq "ERROR" ){
			throw( message="Error making REST Call", detail=results.response.errorMessage );
		}
		
		return results.response.data;
	}

	/**
	*  Send an akismet request and returns the http result object.
	*/
	private function makeRequest(
		method 				= "GET",
		resource 			= "",
		body 				= "",
		struct headers 		= {}, 
		struct parameters 	= {},
		numeric timeout 	= 20
	){
		var results = {
			error 			= false,
			response 		= {},
			message 		= "",
			responseheader 	= {},
			rawResponse 	= ""
		};
		var HTTPResults = "";
		var jsonRegex 	= "^(\{|\[)(.)*(\}|\])$";
		var endPoint 	= "#variables.apiURL#/#arguments.resource#?login=#variables.apilogin#&apiKey=#variables.apiKey#&format=json";
		
		// Default Content Type
		if( NOT structKeyExists( arguments.headers, "content-type" ) ){
			arguments.headers[ "content-type" ] = "";
		}
		
		// parameters
		for( var param in arguments.parameters ){
			endpoint = endpoint & "&#param#=#urlEncodedFormat( arguments.parameters[ param ] )#";
		}

		// create http service
		var oHTTP = new http( 
			method="#arguments.method#",
			url="#endpoint#",
			charset="utf-8",
			timeout="#arguments.timeout#"
		);

		// add headers
		if( !structIsEmpty( arguments.headers ) ){
			for( var thisHeader in arguments.headers ){
				oHTTP.addParam( name=thisHeader,  type="header", value=arguments.headers[ thisHeader ] );
			}
		}

		// add body
		if( len( arguments.body ) ){
			oHTTP.addParam( type="body", value=arguments.body );
		}

		// execute call
		var HTTPResults = oHTTP.send().getPrefix();

		// Set Results
		results.responseHeader 	= HTTPResults.responseHeader;
		results.rawResponse 	= HTTPResults.fileContent.toString();
		
		// Error Details found?
		results.message = HTTPResults.errorDetail;
		if( len( HTTPResults.errorDetail ) ){ results.error = true; }
		
		// Try to inflate JSON
		results.response = deserializeJSON( results.rawResponse );
		
		return results;
	}
			
}