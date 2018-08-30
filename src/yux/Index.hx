package yux;

import om.Json;
import om.Resource;
import om.Template;
import om.web.Dispatch;
import sys.FileSystem;
import sys.io.File;

class Index {

	static var playlist : Array<Dynamic>;

	function new() {}

	function doDefault( ?id : Int ) {

		var ctx : Dynamic = {
			title: '',
			content: 'NOT FOUND',
			twitter: {
				title: '|||Y|U|X||| – ʍӋϟŁξЯӋ ʘӺ ʍɅҊӃіƝÐ',
				description: '',
				content: ''
			}
		};

		if( id == null ) {
			ctx.title = '|||Y|U|X|||';
			ctx.content = executeTemplate( 'home', { playlist : playlist } );
		} else {
			var item = playlist[id-1];
			if( item == null ) {
				ctx.title = 'NOT FOUND';
				ctx.content = '';
				php.Web.setReturnCode(404);
			} else {
				ctx.title = item.title;
				ctx.twitter.description = '#$id – '+item.title;
				ctx.content = executeTemplate( 'wisdom', { item: item, data: Json.stringify( item ) } );
			}
		}

		Sys.print( executeTemplate( 'site', ctx ) );
	}

	static function executeTemplate( id : String, ?ctx : Dynamic ) {
		if( ctx == null ) ctx = {};
		return new Template( Resource.getString( id ) ).execute( ctx );
	}

	static function main() {

		playlist = Json.parse( File.getContent( 'playlist.json' ) );
		for( i in 0...playlist.length ) playlist[i].id = i+1;

		var path = php.Web.getURI();
		var host = php.Web.getHostName();
		if( host == 'localhost' ) path = path.substr( '/pro/disktree/yux/bin/'.length );

        var dispatcher = new Dispatch( path, php.Web.getParams() );
		try dispatcher.dispatch( new Index() ) catch( e : DispatchError ) {
			Sys.print(e);
		}
	}

}
