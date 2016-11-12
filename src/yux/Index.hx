package yux;

import php.Web;
import haxe.Json;
import sys.io.File;
import haxe.Resource;
import haxe.Template;
import haxe.web.Dispatch;

using StringTools;

private class API {

    public function new() {}

    public function doDefault( ?index : Int ) {

        if( index == null ) index = 1;

        var str = File.getContent( 'data/$index.json' ).trim();
        var json = Json.parse( str );
        var ctx = {
            index: index,
            title : json.title,
            json : str
        };
        Sys.print( new Template( Resource.getString( 'index' ) ).execute( ctx ) );
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
