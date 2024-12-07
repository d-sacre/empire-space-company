/* buttons game-intro */

/* Yes Sir = show task*/
document.querySelector('#yes-sir-button').addEventListener("click", function(){
    document.querySelector('.page').style.display="none"; // hide the message of Captain Errol
	
	//hide the buttons
    document.querySelector('#no-sir-button').style.display="none";
    document.querySelector('#yes-sir-button').style.display="none";
	
	// show the task popup
    document.querySelector('#task').style.display="block";
});

/* No Sir = go back to mainmenu */
document.querySelector('#no-sir-button').addEventListener("click", function(){
  window.location='../mission-calypso.html';
});

/* accept task = relocate to game.html*/
document.querySelector('#accept-task-button').addEventListener("click", function(){
  window.location='./game.html';
});
