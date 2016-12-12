package yux;

import js.Browser.console;
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

	static var isMobile : Bool;
	static var item : PlaylistItem;
	static var players : Array<VideoPlayer>;
	static var infoElement : Element;
	static var overlayElement : Element;

	static function update( time : Float ) {
		window.requestAnimationFrame( update );
	}

	static function play() {
		for( i in 0...players.length ) {
			var video = item.videos[i];
			var player = players[i];
			if( video.delay != null && video.delay > 0 ) {
				Timer.delay( function() player.play(), video.delay * 1000 );
			} else {
				player.play();
			}
		}
	}

	static function main() {

		console.log( '|||Y|U|X|||' );

		window.onload = function() {

			item = untyped ITEM;
			isMobile = om.System.isMobile();
			players = new Array<VideoPlayer>();

			infoElement = document.getElementById( 'info' );
			overlayElement = document.getElementById( 'overlay' );

			var initButton = document.getElementById( 'init' );
			if( isMobile ) {
				infoElement.style.display = 'none';
				initButton.style.display = 'inline-block';
			}

			YouTube.init( function() {

				trace( 'Youtube ready' );

				infoElement.textContent = item.title;

				var container = document.getElementById( 'videoplayers' );
				var i = 0;
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

							if( isMobile ) {
								initButton.onclick = function() {
									trace( "click" );
									infoElement.style.display = 'inline-block';
									initButton.remove();
									//player.play();
									play();
								}
							} else {
								play();
							}
						}
					});

					i++;
				}
			});
		}
	}
}
