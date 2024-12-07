
var video = document.getElementsByTagName('video')[0]; // get the video 

video.onended = function(e) {// when rocket explode video is ended
	
    playAudioById("fail-music"); // play fail music

    document.querySelector('#rocket-explode-popup').style.display="block"; // show popup
    document.querySelector('#rocket-explode-video').style.display="none"; // hide video
}
