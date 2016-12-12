package yux;

import js.Browser.document;
import js.Browser.window;
import js.html.Element;
import haxe.Timer;
import om.api.youtube.YouTube;

typedef PlaylistVideoItem = {
	var id : String;
	@:optional var title : String;
	@:optional var volume : Int;
	@:optional var delay : Int;
	@:optional var start : Int;
}

typedef PlaylistItem = {
	var title : String;
	var videos : Array<PlaylistVideoItem>;
}

class App {

	static var item : PlaylistItem;

	static var infoElement : Element;
	static var overlayElement : Element;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
	}

	/*
	static function loadPlaylistData( i : Int ) {
		return window.fetch( 'playlist/$i.json' ).then( function(res){
			return res.json();
		});
	}
	*/

	static function init() {

		YouTube.init( function() {

			trace( 'Youtube ready' );

			infoElement.textContent = item.title;

			var container = document.getElementById( 'videoplayers' );
			var i = 0;
			var players = new Array<VideoPlayer>();
			for( video in item.videos ) {

				var player = new VideoPlayer( i );
				players.push( player );
				container.appendChild( player.element );

				player.load( video.id, function() {

					if( video.title != null ) infoElement.textContent = video.title;
					if( video.volume != null ) player.volume = video.volume;
					player.seekTo( (video.start != null) ? video.start : 0 );

					trace( 'Player ${player.index} ready' );

					if( players.length == item.videos.length ) {

						trace( "Playlist ready" );

						/*
						var btn = document.getElementById( 'start' );
						btn.onclick = function() {
							trace( "click" );
							btn.remove();
							player.play();
						}
						*/

						overlayElement.style.opacity = '0';

						for( player in players ) {
							if( video.delay != null && video.delay > 0 ) {
								//Timer.delay( function() player.play(), video.delay * 1000 );
							} else {
								//player.play();
							}
						}
					}
				});

				i++;
			}
		});
	}

	static function main() {

		window.onload = function() {

			var isMobile = om.System.isMobile();

			item = untyped ITEM;

			if( item != null ) {

				infoElement = document.getElementById( 'info' );
				overlayElement = document.getElementById( 'overlay' );


				/*
				var btn = document.getElementById( 'start' );
				btn.onclick = function() {
					trace( "click" );
					btn.remove();
					init();
				}
				*/

				if( isMobile ) {
					/*
					var btn = document.getElementById( 'start' );
					btn.onclick = function() {
						trace( "click" );
						btn.remove();
						init();
					}
					*/
					overlayElement.style.opacity = '0';
					infoElement.textContent = 'Desktop only';
					return;

				} else  {
					init();
				}
			}

		}
	}
}
