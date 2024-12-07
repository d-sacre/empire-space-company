// functions for getting user input values stored in html
// downward movement speed of main drill
function getActualMainDrillSpeed(){
    let ActualMainDrillSpeed=document.querySelector('#main-drill-speed').value;
    return ActualMainDrillSpeed;
}

// movement and mining speed of mining worker
function getActualMinerSpeed(){
    let ActualMinerSpeed=document.querySelector('#miner-speed').value;
    return ActualMinerSpeed;
}

// destination of main drill
function getMainDrillDestination(){
    let MainDrillDestination=0;
    let MainDrillClearanceForStart=document.querySelector('#drill-start-confirmed').value; // says it is not a number????
    if(MainDrillClearanceForStart==1){
      MainDrillDestination=document.querySelector('#drill-storey-slider-target-value').value;
    } else {
      MainDrillDestination=document.querySelector('#drill-storey-slider-current-value').value;
    }

    if (document.querySelector('#drill-storey-slider-current-value').value==MainDrillDestination) {
        document.querySelector('#drill-start-confirmed').value=0;
    }

    return {
      destination: MainDrillDestination,
      clearanceForStart: MainDrillClearanceForStart
    }
}

//write actual position of the drill into gameGUIPopupMenu
function writeCurrentMainDrillPosition(position){
    document.querySelector('#drill-storey-slider-current-value').value=position;
    document.querySelector('#drill-storey-slider-current-value').innerHTML=document.querySelector('#drill-storey-slider-current-value').value;
    if (position!==parseFloat(document.querySelector('#drill-storey-slider-target-value').value)) {
        if (position==0) {
            document.querySelector('#current-main-drill-state').innerHTML='idle @ start – floor '+position;
        } else {
            document.querySelector('#current-main-drill-state').innerHTML='drilling – floor '+position;
        }

    } else {
        document.querySelector('#current-main-drill-state').innerHTML='idle @ target – floor '+position;
    }

}

// transfer mined resources to gui storage in html
function storeMinedResources(resource){//resource=elementID (still to be defined); each resource block only contains 1 unit of material
    if (resource==3){
        document.querySelector('#raw-caloricum-storage-value').value=parseFloat(document.querySelector('#raw-caloricum-storage-value').value)+1;
    }

    if (resource==1){
        document.querySelector('#copper-ore-value').value=parseFloat(document.querySelector('#copper-ore-value').value)+1;
    }

    if (resource==2){
        document.querySelector('#pottasium-ore-value').value=parseFloat(document.querySelector('#pottasium-ore-value').value)+1;
    }
}
