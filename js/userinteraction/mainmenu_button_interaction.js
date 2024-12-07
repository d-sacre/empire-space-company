/* mainmenu buttons */

/* Play game = redirect to game intro */
document.querySelector('#playgame-mainmenu-button').addEventListener("click", function(){
  window.location='./additionalhtml/game_intro.html';
});

/* Credits = redircet to credits.html */
document.querySelector('#credits-mainmenu-button').addEventListener("click", function(){
  window.location='./additionalhtml/credits.html';
});

/* Credits = redircet to help.html */
document.querySelector('#help-mainmenu-button').addEventListener("click", function(){
  window.location='./additionalhtml/help.html';
});
