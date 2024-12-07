
function getHemiLight(){
	let hemiLight = new THREE.HemisphereLight( 0xffffff, 0x080820, 1);
	hemiLight.position.set(0,100,000);
	return hemiLight;
}

function getDirectLight(){
	let directLight = new THREE.DirectionalLight( 0xffffff, 1 );
	directLight.position.set( 0, 100, 100 );
	directLight.castShadow = true;
	return directLight;
}

function getPointLight(){
	let pointLight = new THREE.PointLight( 0xffffff, 1, BOXSIZE.y*10);
	pointLight.decay=2;
	return pointLight;
}


function getRectLight(){
	let width = 0.2*BOXSIZE.x;
	let height = 4*BOXSIZE.y;
	let intensity = 6;
	let rectLight = new THREE.RectAreaLight( 0xffffff, intensity,  width, height );
	rectLight.position.set( 0 * BOXSIZE.x, 5 * BOXSIZE.y, -1.34 * BOXSIZE.z );
	rectLight.lookAt( 0 * BOXSIZE.x, 5 * BOXSIZE.y, 2 * BOXSIZE.z );
	return rectLight;
}

function getSpotLight(){
	let spotLight = new THREE.SpotLight( 0xffffff );
	spotLight.position.set( 0 * BOXSIZE.x, 13 * BOXSIZE.y, 0 * BOXSIZE.z );
	spotLight.intensity=3;
	spotLight.castShadow = true;
	spotLight.angle = Math.PI/2 * 0.3;

	spotLight.penumbra=0.5;
	
	spotLight.shadow.mapSize.width = 1024;
	spotLight.shadow.mapSize.height = 1024;

	spotLight.shadow.camera.near = 500;
	spotLight.shadow.camera.far = 4000;
	spotLight.shadow.camera.fov = 30;

	return spotLight;
	
}