package yux;

import js.Browser.document;
import js.Browser.window;
import js.html.DivElement;
import om.api.youtube.YouTubePlayer;

class VideoPlayer {

	public var element(default,null) : DivElement;

	public var volume(get,set) : Int;
	inline function get_volume() return player.getVolume();
	inline function set_volume(v:Int) {
		player.setVolume( v );
		return player.getVolume();
	}

	var index : Int;
	public var player : YouTubePlayer;
	var callback : YouTubePlayer;

	public function new( index : Int ) {

		this.index = index;

		element = document.createDivElement();
		element.classList.add( 'videoplayer' );
		element.id = 'videoplayer-$index';
	}

	public function load( id : String, callback : Void->Void ) {
		player = new YouTubePlayer( 'videoplayer-$index', {
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
					trace( 'Videoplayer $index ready' );
					//callback();
					player.setPlaybackQuality( small );
					player.cueVideoById( id );
				},
				'onStateChange': function(e){
					//trace(e.data);
					switch e.data {
					case video_cued:
						callback();
					default:
					}
				},
				'onError': function(e){
					trace(e);
				},
				//'onPlaybackQualityChange': handlePlaybackQualityChange,
				//'onPlaybackRateChange': handlePlaybackRateChange,
				//'onError': handlePlayerError,
				//'onApiChange': handlePlayerAPIChange
			}
		});
	}

	public inline function play() {
		player.playVideo();
	}

	public inline function seekTo( seconds : Float ) {
		player.seekTo( seconds, false );
	}

	/*
	public function load( id : String ) {
		player.loadVideoById( id );
	}

	public function cue( id : String ) {
		player.cueVideoById( id );
	}
	*/

	function handlePlayerStateChange(e) {
		trace( index+": "+e.data );
	}

	function handlePlaybackQualityChange(e) {
		trace(e);
	}

	function handlePlaybackRateChange(e) {
		trace(e);
	}

	function handlePlayerError(e) {
		trace(e);
	}
}
