package yux;

import om.Json;
import om.Resource;
import om.Template;
import om.web.Dispatch;
import sys.FileSystem;
import sys.io.File;

typedef PlaylistItem = Dynamic;

class Web {

	static var playlist : Array<Dynamic>;

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
			} else {
				site.title += ' – '+item.title;
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

	static function main() {

		playlist = Json.parse( File.getContent( 'playlist.json' ) );
		for( i in 0...playlist.length ) playlist[i].id = i+1;

		var path = om.Web.getURI();
		var host = om.Web.getHostName();
		if( host == 'localhost' ) path = path.substr( '/pro/disktree/yux/bin/'.length );

		var api = new yux.Web();
        var router = new Dispatch( path, om.Web.getParams() );
		try router.dispatch( api ) catch( e : DispatchError ) {
			Sys.print(e);
		}
	}

}
