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
	static var item : PlaylistItem;
	static var container : Element;
	static var players : Array<YouTubePlayer>;

	static function initPlayer( i : Int, loop : Bool ) {

		var elementId = 'videoplayer-$i';
		var element = document.createDivElement();
		element.classList.add( 'videoplayer' );
		element.id = elementId;
		container.appendChild( element );

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
				loop: loop ? 1 : 0
			},
			events: {
				'onReady': function(e){
					trace(">>>");
					console.debug( 'Videoplayer $i ready' );
					var video = item.videos[i];
					var p : YouTubePlayer = e.target;
					var volume = (video.volume == null) ? 100 : video.volume;
					var start = (video.start == null) ? 1 : video.start;
					var delay = (video.delay == null) ? 0 : video.delay;
					p.setVolume( volume );
					if( delay > 0 ) {
						Timer.delay( function(){
							p.cueVideoById( video.id, start );
						}, delay*1000 );
					} else {
						p.cueVideoById( video.id, start );
					}
				},
				'onStateChange': function(e){
					trace(e.data);
					var p : YouTubePlayer = e.target;
					switch e.data {
					case video_cued:
						p.playVideo();
					case playing:
						var title = document.querySelector( 'header h1' );
						title.classList.remove( 'preload' );
					case ended:
						if( i == 0 ) {
							Timer.delay( function() {
								window.location.href = 'http://yux.disktree.net/';
							}, 1000 );
						}
					default:
					}
				},
				'onError': function(e){
					trace(e);
				}
			}
		});
	}

	static function main() {

		console.info( '|||Y|U|X|||' );

		window.onload = function() {

			isMobile = om.System.isMobile();
			players = [];

			container = document.getElementById( 'videoplayers' );

			item = untyped ITEMDATA;
			console.info(item);

			YouTube.init( function() {

				trace( 'Youtube ready' );

				initPlayer( 0, false );
				initPlayer( 1, true );
			});
		}
	}
}
