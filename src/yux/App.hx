package yux;

import haxe.Timer;
import js.Browser.console;
import js.Browser.document;
import js.Browser.navigator;
import js.Browser.window;
import js.html.Element;
import om.api.youtube.YouTube;
import om.api.youtube.YouTubePlayer;

typedef PlaylistItem = {
	var title : String;
	var videos : Array<VideoItem>;
}
typedef VideoItem = {
	var id : String;
	var title : String;
	@:optional var volume : Int;
	@:optional var delay : Int;
	@:optional var start : Int;
}

class App {

	static var isMobile : Bool;
	static var players : Array<YouTubePlayer>;

	static function main() {

		console.log( '|||Y|U|X|||' );

		window.onload = function() {

			isMobile = om.System.isMobile();
			players = [];

			var item : PlaylistItem = untyped ITEMDATA;
			trace(item);

			YouTube.init( function() {

				trace( 'Youtube ready' );

				var videoplayers = document.getElementById( 'videoplayers' );

				for( i in 0...item.videos.length ) {

					//var video = item.videos[i];
					var elementId = 'videoplayer-$i';

					var element = document.createDivElement();
					element.classList.add( 'videoplayer' );
					element.id = elementId;
					videoplayers.appendChild( element );

					var player : YouTubePlayer;
					player = new YouTubePlayer( elementId, {
						width: "320",
						height: "240",
						playerVars: {
							controls: no,
							color: white,
							autoplay: 0,
							disablekb: 1,
							fs: 0,
							iv_load_policy: 3,
							enablejsapi: 1,
							modestbranding: 0,
							showinfo: 0,
							loop: 1
						},
						events: {
							'onReady': function(e){
								trace( 'Videoplayer $i ready' );
								var video = item.videos[i];
								var p : YouTubePlayer = e.target;
								var volume = (video.volume == null) ? 100 : video.volume;
								var start = (video.start == null) ? 1 : video.start;
								p.setVolume( volume );
								//p.loadVideoById( video.id, start );
								p.cueVideoById( video.id, start );
							},
							'onStateChange': function(e){
								trace(e);
								var p : YouTubePlayer = e.target;
								switch e.data {
								case 5:
									p.playVideo();
								}
							},
							'onError': function(e){
								trace(e);
							}
						}
					});
					//player.loadVideoById( item.videos[i].id );
				}
			});
		}
	}
}
