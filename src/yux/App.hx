package yux;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import haxe.Timer;
import om.api.youtube.YouTube;

typedef PlaylistItem = {
	@:optional var title : String;
	var id : String;
	@:optional var volume : Int;
	@:optional var delay : Int;
	@:optional var start : Int;
	//@:optional var display : Bool;
}

typedef Playlist = Array<PlaylistItem>;

//@:less("../../res/style/yux.less")
class App {

	static var info : Element;
	static var overlay : Element;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
	}

	static function loadPlaylistData( i : Int ) {
		return window.fetch( 'playlist/$i.json' ).then( function(res){
			return res.json();
		});
	}

	//static function loadPlaylist( index : Int, callback : Array<VideoPlayer>->Void ) {
	static function loadPlaylist( index : Int, callback : Void->Void ) {
		loadPlaylistData( index ).then( function( playlist : Playlist ){
			var i = 1;
			var players = new Array<VideoPlayer>();
			var container = document.getElementById( 'videoplayers' );
			for( item in playlist ) {
				var player = new VideoPlayer( i );
				container.appendChild( player.element );
				player.load( item.id, function() {

					trace( "Player $index ready" );

					players.push( player );

					player.seekTo( (item.start != null) ? item.start : 0 );

					if( item.volume != null ) player.volume = item.volume;
					if( item.title != null ) document.getElementById('info').textContent = item.title;

					if( players.length == playlist.length ) {

						trace("Playlist ready");
						//trace(player.player.getVolume());
						//callback( players );

						for( player in players ) {
							if( item.delay != null ) {
								Timer.delay( function() player.play(), item.delay * 1000 );
							} else {
								player.play();
							}
						}

						callback();
					}
				});
				i++;
			}
		});
	}

	static function main() {

		window.onload = function() {

			info = document.getElementById( 'info' );
			overlay = document.getElementById( 'overlay' );

			if( om.System.isMobile() ) {
				overlay.style.opacity = '0';
				info.textContent = 'Desktop only';
				return;
			}

			YouTube.init( function() {

				trace( 'Youtube ready' );


				var params = window.location.search.substr(1);
				var index = 1;
				loadPlaylist( index, function(){
					overlay.style.opacity = '0';
				});

				/*
				loadPlaylist( index, function(players:Array<VideoPlayer>){
					for( player in players ) {
						player.play();
					}
				});
				*/

				/*
				loadPlaylist( index ).then( function( playlist : Playlist ){

					var i = 1;
					var loaded = 0;

					for( item in playlist ) {

						var player = new VideoPlayer( i );
						document.body.appendChild( player.element );
						player.load( item.id, function() {
							trace( "Player $index ready" );
							if( ++loaded == playlist.length ) {
								trace("Playlist ready");
							}
							//player.cue( item.id );
						});

						i++;

					}
				});
				*/
			});
		}
	}
}
