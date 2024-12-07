/*##############################################################################################################################################*/
/*##################### centralized routines for updating the gui-dispaly values ###############################################################*/
/*##############################################################################################################################################*/

// function to update the storage display
function updateStorageDisplay(){
    document.querySelector('.energy-storage-value').innerHTML=document.querySelector('.energy-value').value+' HU';
    document.querySelector('#raw-caloricum-storage-value').innerHTML=document.querySelector('#raw-caloricum-storage-value').value+' t';
    document.querySelector('#copper-ore-value').innerHTML=document.querySelector('#copper-ore-value').value+' t';
    document.querySelector('#pottasium-ore-value').innerHTML=document.querySelector('#pottasium-ore-value').value+' kg';
    document.querySelector('#copper-ingot-value').innerHTML=document.querySelector('#copper-ingot-value').value+' t';
    document.querySelector('#decarbonizer-storage-value').innerHTML=document.querySelector('#decarbonizer-storage-value').value+' kg';
    document.querySelector('.energy-value').innerHTML=document.querySelector('.energy-value').value+'/'+system.EnergyStartValue+' HU';
    document.querySelector('.energy-storage-value').innerHTML=document.querySelector('.energy-value').value+' HU';
    document.querySelector('.carbondioxide-value').innerHTML= document.querySelector('.carbondioxide-value').value + '/8.00 %';
    document.querySelector('.carbondioxide-beforeuseitem-value').innerHTML=document.querySelector('.carbondioxide-value').value + '/8.00 %';
    document.querySelector('#weight-storage-value').innerHTML=parseFloat(document.querySelector('#weight-storage-value').value).toFixed(2)+' t';
}

// function to update the head-up gui
function udpateHeadupDisplay(){
    document.querySelector('.weight-value').innerHTML=document.querySelector('.weight-value').value+'/'+ system.WeightStartValue +' t';
    document.querySelector('.wear-value').innerHTML=document.querySelector('.wear-value').value +'/100 %';
    document.querySelector('.energy-value').innerHTML=document.querySelector('.energy-value').value+'/'+system.EnergyStartValue+' HU';
    document.querySelector('.energy-storage-value').innerHTML=document.querySelector('.energy-value').value+' HU';
    document.querySelector('.time-value').innerHTML= document.querySelector('.time-value').value + 's';
    document.querySelector('.carbondioxide-value').innerHTML= document.querySelector('.carbondioxide-value').value + '/8.00 %';
    document.querySelector('.carbondioxide-beforeuseitem-value').innerHTML=document.querySelector('.carbondioxide-value').value + '/8.00 %';
    document.querySelector('.oxygen-value').innerHTML= document.querySelector('.oxygen-value').value + '/21.00 %';
}
