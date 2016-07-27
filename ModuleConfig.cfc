/**
* Copyright Ortus Solutions, Corp
* www.ortussolutions.com
* ---
* This module connects your application to Bitly
**/
component {

	// Module Properties
	this.title 				= "Bitly SDK";
	this.author 			= "Ortus Solutions, Corp";
	this.webURL 			= "https://www.ortussolutions.com";
	this.description 		= "SDK Connection to Bitly";
	this.version			= "1.0.0";
	// If true, looks for views in the parent first, if not found, then in the module. Else vice-versa
	this.viewParentLookup 	= true;
	// If true, looks for layouts in the parent first, if not found, then in module. Else vice-versa
	this.layoutParentLookup = true;
	// Module Entry Point
	this.entryPoint			= "cfbitly";
	this.autoMapModels 		= false;

	function configure(){

		// Settings
		settings = {
			// The login to use
			APILogin = "",
			// The API Key to use
			APIKey = ""
		};
	}

	/**
	* Fired when the module is registered and activated.
	*/
	function onLoad(){
		parseParentSettings();
		var bitlySettings = controller.getConfigSettings().bitly;
		
		// Map Bitly Library
		binder.map( "Bitly@Bitly" )
			.to( "#moduleMapping#.Bitly" )
			.initArg( name="APILogin", 			value=bitlySettings.APILogin )
			.initArg( name="APIKey", 			value=bitlySettings.APIKey );
	}

	/**
	* Fired when the module is unregistered and unloaded
	*/
	function onUnload(){
	}

	/**
	* parse parent settings
	*/
	private function parseParentSettings(){
		var oConfig 		= controller.getSetting( "ColdBoxConfig" );
		var configStruct 	= controller.getConfigSettings();
		var bitlyDSL 		= oConfig.getPropertyMixin( "bitly", "variables", structnew() );

		//defaults
		configStruct.bitly = variables.settings;

		// incorporate settings
		structAppend( configStruct.bitly, bitlyDSL, true );
	}

}