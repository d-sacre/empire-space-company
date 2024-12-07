
class ResourcesSystem{

	constructor (Energy, Weight,WorkerTotal,CaloricumStart,CopperOreStart,PottasiumOreStart,DecarbStart){
		/* write the initial values into html-value for storage*/
		document.querySelector('.energy-value').value=Energy;
		document.querySelector('.weight-value').value=Weight;
		document.querySelector('.oxygen-value').value=21.0;
		document.querySelector('.carbondioxide-value').value=0.04;
		document.querySelector('.time-value').value=0;
		document.querySelector('.wear-value').value=0;
		document.querySelector('.productivity-value').value=0;
		document.querySelector('#raw-caloricum-storage-value').value=CaloricumStart;
		document.querySelector('#copper-ore-value').value=CopperOreStart;
		document.querySelector('#pottasium-ore-value').value=PottasiumOreStart;
		document.querySelector('#decarbonizer-storage-value').value=DecarbStart;
		document.querySelector('#use-decarbonizer-slider').max=document.querySelector('#decarbonizer-storage-value').value;
		document.querySelector('#copper-ingot-value').value=0;
		document.querySelector('#copper-max').value=7.5;
		document.querySelector('.wear-value').value=0;

		document.querySelector('#worker-idle-slidervalue').value=3;
		document.querySelector('#worker-mining-slidervalue').value=0;

		/* write initial storage values in innerHTML */
		document.querySelector('.energy-value').innerHTML=Energy+' HU';
		document.querySelector('#raw-caloricum-storage-value').innerHTML=CaloricumStart + ' t';
		document.querySelector('#copper-ore-value').innerHTML=CopperOreStart + ' t';
		document.querySelector('#pottasium-ore-value').innerHTML=PottasiumOreStart + ' kg';
		document.querySelector('#decarbonizer-storage-value').innerHTML=DecarbStart + ' kg';


		document.querySelector('#use-decarbonizer-slidervalue').innerHTML= '0/' + document.querySelector('#decarbonizer-storage-value').value;

		/* read - where appropriate - from html-value and use it as starting point for calculations,
		so that e.g. graphics can write values without overwriting consumptions inproperly */
		this.oxygen = parseFloat(document.querySelector('.oxygen-value').value);
		this.carbondioxid = parseFloat(document.querySelector('.carbondioxide-value').value);
		this.energy = parseFloat(document.querySelector('.energy-value').value);
		this.time = parseFloat(document.querySelector('.time-value').value);
		this.caloricum=parseFloat(document.querySelector('#raw-caloricum-storage-value').value);
		this.caloricumProcessing=parseFloat(document.querySelector('#caloricum-processing-slider').value);
		this.pottasiumProcessing=parseFloat(document.querySelector('#pottasium-processing-slider').value);
		this.copperOre=parseFloat(document.querySelector('#copper-ore-value').value);
		this.copperIngot=parseFloat(document.querySelector('#copper-ingot-value').value);
		this.pottasiumOre=parseFloat(document.querySelector('#pottasium-ore-value').value);
		this.decarbonizer=parseFloat(document.querySelector('#decarbonizer-storage-value').value);
		this.EnergyStartValue=Energy;
		this.WeightStartValue=Weight;

		this.CopperStatemachine="not-enough";//"enough-prepare-takeoff";//has to be set to default "not-enough";

		this.N = WorkerTotal;
		this.nIdle=this.N;
		this.nWork=0;
		this.v = 1;
		this.userselectNCarbonizer=0;
		this.w = parseFloat(document.querySelector('.wear-value').value);
		this.productivity = parseFloat(document.querySelector('.productivity-value').value);
		this.energyConsumption = 0;
		this.weight = parseFloat(document.querySelector('.weight-value').value);

		this.workingConsumptionO = 0.02;
		this.idleConsumptionO = 0.01;
		this.workingProductionCO = 0.03;
		this.idleProductionCO = 0.02;
		this.workerEnergyConsumption=0.35;

		this.paused=false;
	}


	getSliderValue(){
		document.querySelector('#drill-storey-slider-target-value').value=document.querySelector('#drill-storey-slider').value;

		let machineSpeed=document.querySelector('#machine-speed-slider').value;
		let workerIdle=document.querySelector('#worker-idle-slidervalue').value;
		let workerMining=document.querySelector('#worker-mining-slidervalue').value;
		let workerRefinery=document.querySelector('#worker-refinery-slider').value;

		let userselectNCarbonizer=document.querySelector('#use-decarbonizer-slider').value;

		let caloricumProcessing=document.querySelector('#caloricum-processing-slider').value;
		let pottasiumProcessing=document.querySelector('#pottasium-processing-slider').value;


		return {
			machineSpeed,
			workerIdle,
			workerMining,
			workerRefinery,
			userselectNCarbonizer,
			caloricumProcessing,
			pottasiumProcessing
		}

	}

	refreshSliderDisplay(){

		let SliderValues=this.getSliderValue();


		let workerIdleValue=parseFloat(3-SliderValues.workerMining-SliderValues.workerRefinery);
		let workerRefineryMax=parseFloat(3-SliderValues.workerMining);
		document.querySelector('#worker-idle-slidervalue').value=workerIdleValue;
		
		document.querySelector('#worker-refinery-slider').max=workerRefineryMax;

		document.querySelector('#drill-storey-slider-target-value').innerHTML='/'+document.querySelector('#drill-storey-slider-target-value').value+' floors';


		document.querySelector('#machine-speed-slidervalue').innerHTML=SliderValues.machineSpeed+'&times;';
		document.querySelector('#worker-idle-slidervalue').innerHTML=workerIdleValue;//SliderValues.workerIdle;
		document.querySelector('#worker-mining-slidervalue').innerHTML=SliderValues.workerMining;
		document.querySelector('#worker-refinery-slidervalue').innerHTML=SliderValues.workerRefinery;

		document.querySelector('#caloricum-processing-slidervalue').innerHTML=SliderValues.caloricumProcessing+'&times;';
		document.querySelector('#pottasium-processing-slidervalue').innerHTML=SliderValues.pottasiumProcessing+'&times;';

		document.querySelector('#use-decarbonizer-slidervalue').innerHTML=SliderValues.userselectNCarbonizer + '/' + document.querySelector('#decarbonizer-storage-value').value;
		document.querySelector('#use-decarbonizer-slider').max=parseFloat(document.querySelector('#decarbonizer-storage-value').value);

		this.testSliderValues(SliderValues);

	}

	testSliderValues(SliderValues){
		this.N = SliderValues.workerIdle+SliderValues.workerMining;
		this.nIdle=SliderValues.workerIdle;
		this.nWork=SliderValues.workerMining+SliderValues.workerRefinery;
		this.v = SliderValues.machineSpeed;
		this.workingConsumptionO = 0.0025; // 0.02; 0.005
		this.idleConsumptionO = 0.00125; // 0.01; 0.0025;
		this.idleProductionCO = 0.0025; // 0.01; 0.05;
		this.workingProductionCO = 0.00375; // 0.03; 0.0075
		this.userselectNCarbonizer=SliderValues.userselectNCarbonizer;
	}

	refineryEnergyConsumptionCalculation(){
			this.caloricumProcessing=parseFloat(document.querySelector('#caloricum-processing-slider').value);
			//this.copperProcessing=parseFloat(document.querySelector('#copper-processing-slider').value);
			this.pottasiumProcessing=parseFloat(document.querySelector('#pottasium-processing-slider').value);
			this.workerRefinery=parseFloat(document.querySelector('#worker-refinery-slider').value);
			this.productivity=parseFloat(document.querySelector('.productivity-value').value);
			//let productivity=parseFloat(document.querySelector('.productivity-value').value);
			//console.log('pottasium slider: '+this.pottasiumProcessing);
			let processEnergy=this.productivity*this.caloricumProcessing*0.2+//this.productivity*this.copperProcessing*0.4+
			this.productivity*this.pottasiumProcessing*0.3;
			let refineryEnergyConsumption = (processEnergy*this.workerRefinery).toFixed(2);
			//console.log('refineryEnergyConsumption: '+  refineryEnergyConsumption);
			return refineryEnergyConsumption;
	}

	refineryProductionCalculation(){
		// get the actual values
		this.caloricumProcessing=parseFloat(document.querySelector('#caloricum-processing-slider').value).toFixed(2);
		this.pottasiumProcessing=parseFloat(document.querySelector('#pottasium-processing-slider').value).toFixed(2);
		this.workerRefinery=parseFloat(document.querySelector('#worker-refinery-slider').value).toFixed(2);
		this.productivity=parseFloat(document.querySelector('.productivity-value').value).toFixed(2);
		this.energy=parseFloat(document.querySelector('.energy-value').value).toFixed(2);
		this.caloricum=parseFloat(document.querySelector('#raw-caloricum-storage-value').value).toFixed(2);
		this.copperOre=parseFloat(document.querySelector('#copper-ore-value').value).toFixed(2);
		this.copperIngot=parseFloat(document.querySelector('#copper-ingot-value').value).toFixed(2);

		// calculate the energy consumption of the refinery
		let caloricumProcessingEnergyConsumption=this.productivity*this.caloricumProcessing*this.workerRefinery*0.2;
		let pottasiumProcessingEnergyConsumption=this.productivity*this.pottasiumProcessing*this.workerRefinery*0.3;

		// calculate the resource consumption of refinery
		let caloricumProcessingOreConsumption=this.productivity*this.caloricumProcessing*this.workerRefinery*2;
		let pottasiumProcessingOreConsumption=this.productivity*this.pottasiumProcessing*this.workerRefinery*3;

		// calculate the output of the refinery
		let caloricumProcessingOutput=this.productivity*this.caloricumProcessing*this.workerRefinery*40;
		let pottasiumProcessingOutput=this.productivity*this.pottasiumProcessing*this.workerRefinery*1;

		// prevent that energy or caloricum storage drops below 0
		if ((this.caloricum-caloricumProcessingOreConsumption>=0) && (this.energy-caloricumProcessingEnergyConsumption>=0)){
				document.querySelector('#raw-caloricum-storage-value').value=(this.caloricum-caloricumProcessingOreConsumption).toFixed(2);  //save the calculated value in html 
				document.querySelector('#caloricum-rate-equation').innerHTML=caloricumProcessingEnergyConsumption.toFixed(2)+' t caloricum + ' + caloricumProcessingOreConsumption.toFixed(2) +' HU → '+ caloricumProcessingOutput.toFixed(2) +' HU';
		}

		// prevent that energy or potassium storage drops below 0
		if ((document.querySelector('#pottasium-ore-value').value-pottasiumProcessingOreConsumption>=0) && (this.energy-pottasiumProcessingEnergyConsumption>=0)){
				let newPottasium=parseFloat(document.querySelector('#pottasium-ore-value').value)-pottasiumProcessingOreConsumption;
				let newDecarbonizer=parseFloat(document.querySelector('#decarbonizer-storage-value').value)+pottasiumProcessingOutput;

				// save the calculated values in html 
				document.querySelector('#pottasium-ore-value').value=newPottasium.toFixed(2);
				document.querySelector('#decarbonizer-storage-value').value=newDecarbonizer.toFixed(2);
				
				document.querySelector('#use-decarbonizer-slider').max=newDecarbonizer.toFixed(2); // update Decarbonizer SliderMax
				this.refreshSliderDisplay();// update the slider display values
				// update the refinery equation
				document.querySelector('#pottasium-rate-equation').innerHTML=pottasiumProcessingEnergyConsumption.toFixed(2)+' kg pottasium + ' + pottasiumProcessingOreConsumption.toFixed(2) +' HU → '+ pottasiumProcessingOutput.toFixed(2) +' kg decarbonizer';
		} 


	}

	// calculate the refinery energy output due to caloricum processing
	refineryEnergyOutput(){
			this.caloricumProcessing=parseFloat(document.querySelector('#caloricum-processing-slider').value).toFixed(2);
			this.workerRefinery=parseFloat(document.querySelector('#worker-refinery-slider').value).toFixed(2);
			this.productivity=parseFloat(document.querySelector('.productivity-value').value).toFixed(2);
			this.energy=parseFloat(document.querySelector('.energy-value').value).toFixed(2);
			this.caloricum=parseFloat(document.querySelector('#raw-caloricum-storage-value').value).toFixed(2);

			let caloricumProcessingEnergyConsumption=this.productivity*this.caloricumProcessing*this.workerRefinery*0.2;
			let caloricumProcessingOreConsumption=this.productivity*this.caloricumProcessing*this.workerRefinery*2;

			let caloricumProcessingOutput;

			if ((this.caloricum-caloricumProcessingOreConsumption>=0) && (this.energy-caloricumProcessingEnergyConsumption>=0)){
						caloricumProcessingOutput=this.productivity*this.caloricumProcessing*this.workerRefinery*40;
			} else {
						caloricumProcessingOutput=0;
			}
			return caloricumProcessingOutput;
	}

	//
	calculateDrillEnergyConsumption(){
		let drillEnergyConsumption = 0.1* (this.v)*(this.v);
		return drillEnergyConsumption;
	}

	calculateRefreshMainDrillAndMinerSpeed(){
		let mainDrillSpeed, minerSpeed;
		mainDrillSpeed=0.5*this.v;
		minerSpeed=0.5*this.v;

		document.querySelector('#main-drill-speed').value=mainDrillSpeed;
		document.querySelector('#miner-speed').value=minerSpeed;

		document.querySelector('#main-drill-speed').innerHTML=mainDrillSpeed+' blocks/s';
		document.querySelector('#miner-speed').innerHTML=minerSpeed+' blocks/s';
	}

	carbondioxidFactorCalculation(){
		this.carbondioxid = parseFloat(document.querySelector('.carbondioxide-value').value);
		let carbondioxid=this.carbondioxid;
		  if(0.04<=carbondioxid<=0.08){
		    return (1-2.5*(carbondioxid-0.04));
		  }
		  if(carbondioxid<=1.5){
		      return (0.9-(20/141)*(carbondioxid-0.09));
		  }
		  if(carbondioxid<=5){
		    return (0.7-(40/349)*(carbondioxid-1.51));
		  } else {
		      return (0.3-(3/29)*(carbondioxid-5.01));
		  }
	}

	oxygenFactorCalculation(){
		this.oxygen = parseFloat(document.querySelector('.oxygen-value').value);
		return this.oxygen*(4.76/100);
	}

	calculateProductivity(v,oxygenFactor, carbondioxidFactor){
		return v*carbondioxidFactor*oxygenFactor;
	}

	carbonizerReductionCalculation(){
		this.carbondioxid = parseFloat(document.querySelector('.carbondioxide-value').value);
		if (this.carbondioxid-2*this.userselectNCarbonizer>=0.04) {
			return this.carbondioxid-2*this.userselectNCarbonizer;
		} else {
			return 0.04;
		}

	}

	carbonizerReduction(){
		this.carbondioxid = parseFloat(document.querySelector('.carbondioxide-value').value);
		if (this.carbondioxid-2*this.userselectNCarbonizer>=0.04) {
			return this.carbondioxid-2*this.userselectNCarbonizer;
		} else {
			return 0.04;
		}
	}

	/* ############################################################################################## */
	/*#################### Begin of defining refreshing value routines ##############################*/
	/*###############################################################################################*/
	
	refreshOxygenValue(){
		this.oxygen = parseFloat(document.querySelector('.oxygen-value').value);
		return this.oxygen -(this.nWork*this.workingConsumptionO+this.nIdle*this.idleConsumptionO);
	}

	refreshCarbondioxidValue(){
		this.carbondioxid = parseFloat(document.querySelector('.carbondioxide-value').value);
		return this.carbondioxid+(this.nWork*this.workingProductionCO+this.nIdle*this.idleProductionCO);
	}


	refreshEnergyValue(){
		this.energy = parseFloat(document.querySelector('.energy-value').value);
		/* energy contains: worker consumption, drill, refinery consumption plus refinery output*/
		let energyValue=this.energy-this.workerEnergyConsumption*this.nWork-this.calculateDrillEnergyConsumption()-this.refineryEnergyConsumptionCalculation()+this.refineryEnergyOutput();
		return energyValue;

	}

	refreshProductivityValue(){
		let productivityValue=this.productivity;
		document.querySelector('.productivity-value').value=productivityValue;
		return productivityValue;
	}


	// define the mining state of FSM
	myMiningTime() {
		// Faktoraktualisierung
		let carbondioxidFactor = this.carbondioxidFactorCalculation();
		let oxygenFactor= this.oxygenFactorCalculation();
		let carbonizerReductionCalculationValue= this.carbonizerReductionCalculation();
		let v= this.v;

		//Wertänderungen
		let productivity = this.calculateProductivity(v,oxygenFactor, carbondioxidFactor);


		this.calculateRefreshMainDrillAndMinerSpeed();

		this.oxygen = this.refreshOxygenValue();

		this.carbondioxid = this.refreshCarbondioxidValue();
		this.energy = this.refreshEnergyValue();


		updateStorageDisplay();//function defined in js/resourcesystem/resource_system_storage-and-refinery.js

		this.time += 1;

		//Rückgabewerte
		return {
				time: this.time,
				energy: this.energy,
				carbondioxid: this.carbondioxid,
				oxygen: this.oxygen,
				productivity,
				carbonizerReductionCalculationValue,
				CopperStatemachine: this.CopperStatemachine,
				weight: this.Weight,
				wear: this.w,
				speed: v
		};

	}
}
