/*##################################################################################################################*/
/*######################################## Ingame-popupmenu-buttons ################################################*/
/*##################################################################################################################*/

/* return to menu*/
document.querySelector('#back-to-mainmenu-popup-button').addEventListener("click", function(){
    window.location='../mission-calypso.html';
});

/* start drill */
document.querySelector('#start-main-drill-button').addEventListener("click", function(){
    document.querySelector('#drill-start-confirmed').value=1;
    document.querySelector('#drill-storey-slider').min=document.querySelector('#drill-storey-slider').value;

    let wisv=parseFloat(document.querySelector('#worker-idle-slidervalue').value);
    let wmsv=parseFloat(document.querySelector('#worker-mining-slidervalue').value);
    let wrsv=parseFloat(document.querySelector('#worker-refinery-slidervalue').value);

    console.log("wisv: "+wisv);

    if (wisv!==0) {
        document.querySelector('#worker-idle-slidervalue').value=parseFloat(wisv)-1;
        document.querySelector('#worker-mining-slidervalue').value=parseFloat(wmsv)+1;
    } else {
        console.log("else-case: ");
        document.querySelector('#worker-idle-slidervalue').value=parseFloat(wisv)+1;
        document.querySelector('#worker-refinery-slidervalue').value=parseFloat(wrsv)-1;

        document.querySelector('#worker-mining-slidervalue').value=parseFloat(wmsv)+1;
    }
    system.refreshSliderDisplay();
});

/* button for carbonizer useage */
document.querySelector('#use-carbonizer-button').addEventListener("click", function() {
    document.querySelector('.carbondioxide-value').value=parseFloat(document.querySelector('.carbondioxide-afteruseitem-value').value);// reduce C02 to calculated value
    document.querySelector('#decarbonizer-storage-value').value=parseFloat(document.querySelector('#decarbonizer-storage-value').value).toFixed(2)-parseFloat(document.querySelector('#use-decarbonizer-slider').value).toFixed(2); // substract number of used decarbonizers from storage
    document.querySelector('#decarbonizer-storage-value').innerHTML=document.querySelector('#decarbonizer-storage-value').value+' kg'; // display changes
    document.querySelector('#use-decarbonizer-slider').value=0; // reset desired number of decarbonizers to 0
    document.querySelector('#use-decarbonizer-slider').max=parseFloat(document.querySelector('#decarbonizer-storage-value').value).toFixed(2); // set maximum slider value to available decarbonizers in storage
    document.querySelector('#use-decarbonizer-slidervalue').innerHTML=document.querySelector('#use-decarbonizer-slider').value+'/'+document.querySelector('#decarbonizer-storage-value').value; // write actual value of slider and max into gui
    document.querySelector('#carbondioxide-afteruseitem-value').value=0.04; // reset value for possible reduction
});

/*##################################################################################################################*/
/*############################# buttons/clickboxes for slide up/down of menu #######################################*/
/*##################################################################################################################*/

/* function for buttons*/
function gameGUIPopupMenuAnimation(){
    document.removeEventListener('mousemove', onDocumentMouseMove, false); // every time when gameGUIPopup should appear, unbind three.js mouse-event listeners
    document.removeEventListener('click', onMouseClick, false); // event listeners defined in js/threejs/scene.js
    document.querySelector('.transform').classList.toggle('transform-active'); // start css-animation for slide-up of menu
    if (document.querySelector('#game-gui-popup').classList[2]!='transform-active') { //if menu not sliding up or visible
        document.addEventListener('mousemove', onDocumentMouseMove, false);  // recreate three.js mouse-event listeners
      	document.addEventListener('click', onMouseClick, false);
    }
}

/* attach event listeners to slide up/down buttons/clickboxes for menu*/
document.querySelector('#to-rocket-menu-clickbox').addEventListener("click",gameGUIPopupMenuAnimation);
document.querySelector('#return-to-game-popup-button').addEventListener("click", gameGUIPopupMenuAnimation);

/* attach addEventListener to headup-gameGUIPopup*/
document.querySelector('#headup-gui-container-clickbox').addEventListener("click", gameGUIPopupMenuAnimation);

/*##################################################################################################################*/
/*############################### Button run-out-of-suplies-game-over-button #######################################*/
/*##################################################################################################################*/
document.querySelector('#game-over-back-to-mainmenu-popup-button').addEventListener("click", function(){
    window.location='../mission-calypso.html';
});

/*##################################################################################################################*/
/*##################### Buttons in conjunction with game FSM #######################################################*/
/*##################################################################################################################*/

/* Button for returning to mining operation, altough copper limit is reached*/
document.querySelector("#continue-mining-popup-button").addEventListener("click",function(){
    document.querySelector("#enough-copper-popup").style.display="none"; // hide popup, so user can interact with main game popup again
    document.querySelector('#copper-max').value=1500; // enlarge copper limit so that FSM-state "enough" can not be reached again
    system.CopperStatemachine="enough-but-continue-mining"; // jump to FSM-State "enough-but-continue-mining" for further changes
});

/* Button for directly preparing take-off when copper limit is reached*/
document.querySelector("#order-to-takeoff-popup-button").addEventListener("click",function(){
    document.querySelector("#enough-copper-popup").style.display="none";
    stopAudioById('warning');
    system.CopperStatemachine="enough-prepare-takeoff";
});

/* Button for preparing take-off after continuing mining */
document.querySelector("#back-to-prepare-takeoff-button").addEventListener("click", function(){
    stopAudioById('warning');
    system.CopperStatemachine="enough-prepare-takeoff";
});

/* Button for take-off */
document.querySelector('#takeoff-button').addEventListener("click", function(){
    let ranNum=Math.random(); // generate random number
    let successfulTakeoffProbability=document.querySelector('#successful-takeoff-probability').value; // get calculated probability for successful take-off
    if(ranNum<=successfulTakeoffProbability){ // if ranNum is smaller/equal than calculated probaility -> player wins
        window.location='./game_outro-sucess.html';
    } else { //player fails
        window.location='./game_outro-fail.html';
    }

});

/* Button for getting to weight-relief */
document.querySelector('#relief-weight-button').addEventListener("click", function(){
    document.querySelector("#weight-relief-popup").style.display="block";
});

/* Button for discarding changes of weight-relief and direct redirection back to prepare take-off*/
document.querySelector('#no-relief-weight-button').addEventListener("click", function(){
    document.querySelector("#weight-relief-popup").style.display="none";
});
