component extends="testbox.system.BaseSpec"{
/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
	}

	function afterAll(){
	}

/*********************************** BDD SUITES ***********************************/

	function run(){

		// Akismet model
		describe( "Bitly Model", function(){

			beforeEach(function(){
				var apiKey 	= deserializeJSON( fileRead( getDirectoryFromPath( getMetadata( this ).path ) & "apikey.json" ) );
				bitly 	= new root.Bitly( apikey.login, apikey.key );
			});

			it( "can shorten a URL", function(){
				var results = bitly.shorten( "https://github.com/coldbox-modules/cfbitly" );
				expect(	results ).toBeStruct();
				expect(	results.url ).toInclude( "bit.ly/" );
			});

			it( "can expand a URL", function(){
				var shortResults = bitly.shorten( "https://github.com/coldbox-modules/cfbitly" );
				var results = bitly.expand( shortResults.url, shortResults.hash );
				expect(	results ).toBeStruct();
				expect(	results.expand ).toBeArray();
			
			});

		});

	}

}