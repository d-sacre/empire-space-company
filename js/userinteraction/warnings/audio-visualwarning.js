// Function to play background audio by Id
function playAudioById(Id) {
	var a = document.getElementById(Id);

	if(a.paused) {
		if(a.ended)
			a.currentTime = 0;

		a.play();
	}
}

// Function to stop background audio by Id
function stopAudioById(Id) {
	var a = document.getElementById(Id);

  a.pause();

	a.currentTime = 0;

}
