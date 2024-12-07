var container;
var camera, controls, scene, renderer;
var sky, sunSphere;
var verticalMode = true;

var raycaster = new THREE.Raycaster();
var mouse = new THREE.Vector2(), intersected;
var figure, drillObj, innerDrillObj, pointLight;
var targetPosition;
var SPEED=10; //Constant multiplied by the speed setting
var currentStage; //That shows the stages, where the figure can drill. The drill is one stage lower. Maximum is 8, because 9 rows are visible and the slider goes to 8.


init();
animate();


function init() {

	scene = new THREE.Scene();
	camera = new THREE.PerspectiveCamera( 10, window.innerWidth / window.innerHeight, 30, 2000000 );
	renderer = new THREE.WebGLRenderer({antialias: true});

	//PerspectiveCamera( fov : Number, aspect : Number, near : Number, far : Number )
	camera.position.set( 0, 3*BOXSIZE.x, 100*BOXSIZE.x );
	camera.lookAt( 0, 0, 0 );

	renderer.setPixelRatio( window.devicePixelRatio );
	renderer.setSize( window.innerWidth, window.innerHeight );
	document.body.appendChild( renderer.domElement );
	/*controls = new THREE.OrbitControls( camera, renderer.domElement );
	controls.addEventListener( 'change', render );
	controls.maxPolarAngle = Math.PI / 2;
	controls.enableZoom = false;
	controls.enablePan = false;*/
	initSky();

	
	//Adding the model with cubes, surface and rocket to the scene	
	let model = buildModel();
	scene.add(model);
	
	
	//Adding figure and the two objects for the drill to the scene
	figure = buildFigure();
	scene.add(figure);
	targetPosition = getPlayerPosition();

	drillObj = buildDrill();
	scene.add(drillObj);
	let start = drillObj.position.clone();
	
	innerDrillObj = buildInnerDrill();
	scene.add(innerDrillObj);
	let start1 = innerDrillObj.position.clone();
	
	
	//Adding lights to the scene
	let directLight1 = getDirectLight();
	scene.add( directLight1 );
	
	let directLight2 = getDirectLight();
	directLight1.position.set( 0, -BOXSIZE.y*8, BOXSIZE.z * (8));
	directLight1.intensity=0.3;
	scene.add( directLight2 );
	
	pointLight = getPointLight(); //is attached to the figure (global variable)
	scene.add( pointLight );
	pointLight.position.set(targetPosition.x, (targetPosition.y + 1*BOXSIZE.x), targetPosition.z);
	
	let spotLight = getSpotLight();
	scene.add( spotLight );
	
	let rectLight = getRectLight();
	scene.add( rectLight );
	
	let rectLightMesh = new THREE.Mesh( new THREE.PlaneBufferGeometry(), new THREE.MeshBasicMaterial() );
	rectLightMesh.scale.x = rectLight.width;
	rectLightMesh.scale.y = rectLight.height;
	rectLight.add( rectLightMesh );

	//EventListener for highlighting the cubes and for clicking the cubes
	document.addEventListener( 'mousemove', onDocumentMouseMove, false );
	document.addEventListener( 'click', onMouseClick, false);

	window.addEventListener( 'resize', onWindowResize, false );
}


function initSky() {
	// Add Sky
	sky = new Sky();
	sky.scale.setScalar( 450000 );
	scene.add( sky );
	// Add Sun Helper
	sunSphere = new THREE.Mesh(
		new THREE.SphereBufferGeometry( 20000, 16, 8 ),
		new THREE.MeshBasicMaterial( { color: 0xffffff } )
	);
	sunSphere.position.y = - 700000;
	sunSphere.visible = false;
	scene.add( sunSphere );
	/// GUI
	var effectController  = {
		turbidity: 10,
		rayleigh: 1.5,
		mieCoefficient: 0.005,
		mieDirectionalG: 0.78,
		luminance: 1,
		inclination: 0.49,
		azimuth: 0.265,
		sun: ! true
	};
	var distance = 40000000000;
	function guiChanged() {
		var uniforms = sky.material.uniforms;
		uniforms.turbidity.value = effectController.turbidity;
		uniforms.rayleigh.value = effectController.rayleigh;
		uniforms.luminance.value = effectController.luminance;
		uniforms.mieCoefficient.value = effectController.mieCoefficient;
		uniforms.mieDirectionalG.value = effectController.mieDirectionalG;
		var theta = Math.PI * ( effectController.inclination - 0.5 );
		var phi = 2 * Math.PI * ( effectController.azimuth - 0.5 );
		sunSphere.position.x = distance * Math.cos( phi );
		sunSphere.position.y = distance * Math.sin( phi ) * Math.sin( theta );
		sunSphere.position.z = distance * Math.sin( phi ) * Math.cos( theta );
		sunSphere.visible = effectController.sun;
		uniforms.sunPosition.value.copy( sunSphere.position );
		renderer.render( scene, camera );
	}
	guiChanged();
}

//for clicking the cubes
function onMouseClick(event){
	targetPosition = getTargetPosition(event);
}

//for highlighting the cubes
function onDocumentMouseMove( event ) {
	event.preventDefault();
	mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
	mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;
}

function onWindowResize() {
	camera.aspect = window.innerWidth / window.innerHeight;
	camera.updateProjectionMatrix();
	renderer.setSize( window.innerWidth, window.innerHeight );
	render();
}

//get the position of the clicked cube, this is the target for the figure where to move
function getTargetPosition(event){
	event.preventDefault();
	mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
	mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;

	//only the front of cubes are clickable and only cubes over the current stage of the drill are clickable
	let targetBlocks = scene.children[2].children[1];
	let intersections = raycaster.intersectObjects( targetBlocks.children );

	if(intersections.length > 0 && intersections[0].object.userData.positionY < currentStage) {
		let pos = intersections[0].object.position.clone();
		return pos;
	}
	return targetPosition;
}

//get the current position of the figure
function getPlayerPosition(){
	let currentPlayerPos = figure.position.clone();
	return currentPlayerPos;
}


//function for the movement of the figure
//figur moves only on the x coordinate plane for the mining of the blocks
//in order to get deeper, the figure has to go back to the tunnel and moves on the y coordinate plane
function updateFigPostitions(posPlayer,posTarget) {
	if(posPlayer.equals(posTarget)) {
		return;}

	let isInCorrectRow = (posPlayer.y === posTarget.y);
	let isCentered = (posPlayer.x === 0);
	let nullPositionX = new THREE.Vector3(0,posPlayer.y,0);
	//let isInCorrectColumn = (posPlayer.x === posTarget.y);
	
	let speedFig = SPEED * getActualMinerSpeed(); //./threejs_gui_interface.js;


	if(!isCentered && !isInCorrectRow) {
		playerGotoX(posPlayer, nullPositionX, speedFig);
	}
	if(!isInCorrectRow && isCentered) {
		playerGotoY(posPlayer, posTarget, speedFig);
	}
	if(isInCorrectRow) {
		playerGotoX(posPlayer, posTarget, speedFig);
	}

}



function playerGotoX(currentPlayerPos, targetPlayerPos, speedFig) {
	let dX = targetPlayerPos.x - currentPlayerPos.x;
		
	if(dX < speedFig) {
		deleteCubeUnderground((Math.round(currentPlayerPos.x / BOXSIZE.x)), (Math.round(currentPlayerPos.y / -BOXSIZE.y))); //round to get the name of the cubes which are our given coordinates
		currentPlayerPos.x -= speedFig;
		figure.position.copy(currentPlayerPos);
	}
	if(dX > speedFig) {
		deleteCubeUnderground((Math.round(currentPlayerPos.x / BOXSIZE.x)), (Math.round(currentPlayerPos.y / -BOXSIZE.y))); //round to get the name of the cubes which are our given coordinates
		currentPlayerPos.x += speedFig;
		figure.position.copy(currentPlayerPos);
		//console.log("delete");
	}
	if(dX <= speedFig && dX >= -speedFig) {
		currentPlayerPos.x = targetPlayerPos.x;
		figure.position.copy(currentPlayerPos);
		//console.log("end");
	}
}

function playerGotoY(currentPlayerPos, targetPlayerPos, speedFig) {
	let dY = targetPlayerPos.y - currentPlayerPos.y;

	if(dY < speedFig) {
		currentPlayerPos.y -= speedFig;
		figure.position.copy(currentPlayerPos);
	}

	if(dY > speedFig) {
		currentPlayerPos.y += speedFig;
		figure.position.copy(currentPlayerPos);
	}
	if(dY <= speedFig && dY >= -speedFig) {
		currentPlayerPos.y = targetPlayerPos.y;
		figure.position.copy(currentPlayerPos);
	}
}



//function for the movement of the drill
function updateDrillPosition(){
	let speedDrill = SPEED * getActualMainDrillSpeed(); //./threejs_gui_interface.js
	let currentDrillPos = drillObj.position.clone();
	currentStage = getCurrentStage(currentDrillPos); //global variable, important for the function of highlighting the cubes
	writeCurrentMainDrillPosition(currentStage); //./threejs_gui_interface.js
	let stages = getMainDrillDestination().destination; //./threejs_gui_interface.js
	let targetDrillPos = getTargetDrillPos(stages);
	
	
	if(currentDrillPos.equals(targetDrillPos)) {
		return;}
	
	
	let dY = targetDrillPos.y - currentDrillPos.y;

	if(dY < speedDrill) {
		currentDrillPos.y -= speedDrill;
		drillObj.position.copy(currentDrillPos);
		innerDrillObj.position.copy(currentDrillPos);
		drillObj.rotation.y += speedDrill*100;
		drill((Math.round(currentDrillPos.y / -BOXSIZE.y)));
	}

	if(dY > speedDrill) {
		currentDrillPos.y += speedDrill;
		drillObj.position.copy(currentDrillPos);
		innerDrillObj.position.copy(currentDrillPos);
	}
	
	if(dY <= speedDrill && dY >= -speedDrill) {
		currentDrillPos.y = targetDrillPos.y;
		drillObj.position.copy(currentDrillPos);
		innerDrillObj.position.copy(currentDrillPos);
	}
}


//calculating the target position of the drill
//y-coordinate: entered stage multiplied by boxsize
function getTargetDrillPos(stages){	
	let targetPosDrill = new THREE.Vector3(drillObj.position.clone().x, (-stages * BOXSIZE.y), drillObj.position.clone().z);
	return targetPosDrill;	
}


//intervals for the declaration of the current stage of the drill
//Return value shows the stages, where the figure can drill. The drill is one stage lower. Maximum is 8, because 9 rows are visible and the slider goes to 8.
//case 0 to 9 (one case more than necessary)
function getCurrentStage(currentDrillPos){
	switch (true){

    case currentDrillPos.y <= BOXSIZE.y * (0.5) && currentDrillPos.y >= BOXSIZE.y * (-0.5): // from 100 to -100
        return 0;
        break; 
		
    case currentDrillPos.y < BOXSIZE.y * (-0.5) && currentDrillPos.y >= BOXSIZE.y * (-1.5): // from -100 to -300
        return 1;
        break;

    case currentDrillPos.y < BOXSIZE.y * (-1.5) && currentDrillPos.y >= BOXSIZE.y * (-2.5): // from -300 to -500
        return 2;
        break;

    case currentDrillPos.y < BOXSIZE.y * (-2.5) && currentDrillPos.y >= BOXSIZE.y * (-3.5): // from -500 to -700
        return 3;
        break;
	case currentDrillPos.y < BOXSIZE.y * (-3.5) && currentDrillPos.y >= BOXSIZE.y * (-4.5): // from -700 to -900
        return 4;
        break;

    case currentDrillPos.y < BOXSIZE.y * (-4.5) && currentDrillPos.y >= BOXSIZE.y * (-5.5): // from -900 to -1100
        return 5;
        break;

    case currentDrillPos.y < BOXSIZE.y * (-5.5) && currentDrillPos.y >= BOXSIZE.y * (-6.5): // from -1100 to -1300
        return 6;
        break;
		
	case currentDrillPos.y < BOXSIZE.y * (-6.5) && currentDrillPos.y >= BOXSIZE.y * (-7.5): // from -1300 to -1500
        return 7;
        break;
		
	case currentDrillPos.y < BOXSIZE.y * (-7.5) && currentDrillPos.y >= BOXSIZE.y * (-8.5): // from -1500 to -1700
        return 8;
        break;
		
	case currentDrillPos.y < BOXSIZE.y * (-8.5) && currentDrillPos.y >= BOXSIZE.y * (-9.5): // from -1700 to -1900
        return 9;
        break;
		
    default:
        return "Error";
	}
}




function render() {
	// update the picking ray with the camera and mouse position
	raycaster.setFromCamera( mouse, camera );

	// calculate objects intersecting the picking ray
	//only the front of cubes are clickable and only cubes over the current stage of the drill are clickable
	let targetBlocks = scene.children[2].children[1]
	let intersections = raycaster.intersectObjects( targetBlocks.children );

	if ( intersections.length > 0 && intersections[0].object.userData.positionY < currentStage) {
		if ( intersected != intersections[ 0 ].object ) {
			if ( intersected ) intersected.material.color.setHex( 0xffffff );
			intersected = intersections[ 0 ].object;
			intersected.material.color.setHex( 0xff0000 );
		}
	}
	else if ( intersected ) {
		intersected.material.color.setHex( 0xffffff );
		intersected = null;
	}


	renderer.render( scene, camera );
}


function animate() {
	requestAnimationFrame( animate );
	updateDrillPosition();
	updateFigPostitions(getPlayerPosition(),targetPosition);
	pointLight.position.set(getPlayerPosition().x, (getPlayerPosition().y + 0.41*BOXSIZE.y), getPlayerPosition().z+ 0.0*BOXSIZE.z);
	render();
	//controls.update();
}
