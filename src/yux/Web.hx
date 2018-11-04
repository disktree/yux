package yux;

import om.Json;
import om.Resource;
import om.Template;
import om.web.Dispatch;
import sys.FileSystem;
import sys.io.File;
import yux.data.Item;
import yux.data.Video;

typedef PlaylistItem = {
	var title : String;
	var videos : String;
};

class Web {

	static var playlist : Array<Item>;

	function new() {}

	function doDefault( ?id : Int ) {

		var site : Dynamic = {
			title: '|||Y|U|X|||',
			description: 'ʍӋϟŁξЯӋ ʘӺ ʍɅҊӃіƝÐ',
			keywords: ['wisdom','mysticism','philosophy','ambient'],
			twitter: {
				title: '|||Y|U|X|||',
				description: 'ʍӋϟŁξЯӋ ʘӺ ʍɅҊӃіƝÐ'
			}
		};
		var page : Dynamic = {
			title: '|||Y|U|X|||'
		};

		switch id {
		case null:
			page.content = executeTemplate( 'home', { playlist: playlist } );
		default:
			var item = playlist[id-1];
			if( item == null ) {
				//TODO
				Sys.print('NOT FOUND');
				return;
			} else {
				site.title = site.title + ' – ' + item.title;
				site.description = item.title;
				site.twitter.description = item.title;
				page.title = item.title+'.';
				page.content = executeTemplate( 'wisdom', { item: item, data: Json.stringify( item ) } );
			}
		}

		Sys.print( executeTemplate( 'index', {
			site: site,
			page: page
		} ) );

	}

	static function executeTemplate( id : String, ?ctx : Dynamic ) {
		if( ctx == null ) ctx = {};
		return new Template( File.getContent( 'htm/$id.html' ) ).execute( ctx );
	}

	static function run( host : String, path : String, params : Map<String,String> ) {

		if( host == 'localhost' )
			path = path.substr( '/pro/disktree/yux/bin/'.length );

		playlist = Json.parse( File.getContent( 'playlist.json' ) );
		for( i in 0...playlist.length ) playlist[i].n = i+1;

		var api = new yux.Web();
		var router = new Dispatch( path, params );
		try router.dispatch( api ) catch( e : DispatchError ) {
			om.Web.setReturnCode( 500 );
			Sys.print('<pre>$e</pre>');
		}
	}

	static function main() {
		try {
			run( om.Web.getHostName(), om.Web.getURI(), om.Web.getParams() );
		} catch( e : Dynamic ) {
			om.Web.setReturnCode( 500 );
			Sys.print('<pre>$e</pre>');
			return;
		}
	}

}
