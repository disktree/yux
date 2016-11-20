package yux;

import php.Web;
import haxe.Json;
import sys.FileSystem;
import sys.io.File;
import haxe.Resource;
import haxe.Template;
import haxe.web.Dispatch;

using StringTools;
using haxe.io.Path;

private class API {

    public function new() {}

    public function doDefault( ?index : Int ) {

        //var tpl  = 'index';

        if( index == null ) {
            //index = 1;
            //TODO print index site
            var items = new Array<Dynamic>();
            var files = FileSystem.readDirectory( 'data' );
            files.sort( function(a,b) {
                var ia = Std.parseInt( a.withoutExtension() );
                var ib = Std.parseInt( b.withoutExtension() );
                return if( ia > ib ) 1 else if ( ia < ib ) -1 else 0;
            });
            var i = 0;
            for( f in files ) {
                var str = File.getContent( 'data/$f' ).trim();
                var json = Json.parse( str );
                items.push({
                    index: Std.parseInt( f.withoutExtension() ),
                    title : json.title
                });
            }
            var ctx = {
                items: items
            };
            Sys.print( new Template( Resource.getString( 'index' ) ).execute( ctx ) );
            //Sys.print(items );


        } else {

            var str = File.getContent( 'data/$index.json' ).trim();
            var json = Json.parse( str );
            var ctx = {
                index: index,
                title : json.title,
                json : str
            };

            Sys.print( new Template( Resource.getString( 'track' ) ).execute( ctx ) );
        }

    }

    /*
    public function doPlaylist() {
        Sys.print("PLAYLIST HERE");
    }
    */
}

class Index {

    static inline var ROOT = #if debug '/project/yux/bin/' #else '' #end;

    static function main()  {
        var path = Web.getURI().substr( ROOT.length );
        var params = Web.getParams();
        var dispatcher = new Dispatch( path, params );
        var root = new API();
        try dispatcher.dispatch( root ) catch( e : DispatchError ) {
			Sys.print(e);
		}
		Web.flush();
    }

}
