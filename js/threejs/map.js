var group, groupSurface;
var NUMELEMENTS=20;
var BOXSIZE = new THREE.Vector3(200, 200, 200);
var SURFACEMULTI = 1000;
var ROCKHIGHT=5;

function buildModel() {

	let model;
	model = new THREE.Group();

	
	//textures of cubes and surface
	let texUnderground = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sandstone_512x512px.jpg" );
	let texUndergroundPlain = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sandstone_plain.jpg" );
	let texEdge = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sand_highres_edge_128x128.jpg" );
	let texSurface = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sand_highres_top_512x512_compress.jpg" );
	
	//textures of resources
	let texPotassium = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sandstone_caloricum_512x512px.jpg" );
	let texCaloricum = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sandstone_copper_512x512px.jpg" );
	let texCopper = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/sandstone_pottasium_512x512px.jpg" );


	//geometry of cubes and surface
	let geoUnderground = new THREE.BoxBufferGeometry( BOXSIZE.x , BOXSIZE.y,  BOXSIZE.z);
	let geoUndergroundPlain = new THREE.BoxBufferGeometry( (2*NUMELEMENTS)*BOXSIZE.x, NUMELEMENTS*BOXSIZE.y, BOXSIZE.z);
	let geoEdge = new THREE.BoxBufferGeometry( BOXSIZE.x , BOXSIZE.y/2, BOXSIZE.z );
	let geoSurface = new THREE.BoxBufferGeometry( SURFACEMULTI*BOXSIZE.x , BOXSIZE.y/2, SURFACEMULTI*BOXSIZE.y );

	
	
	//material of cubes and surface
	let matUnderground = new THREE.MeshPhongMaterial( { map: texUnderground, wireframe: false});
	let matUndergroundPlain = new THREE.MeshPhongMaterial( { map: texUndergroundPlain, wireframe: false});
	let matEdge = new THREE.MeshPhongMaterial( { map: texUnderground, wireframe: false});
	let matSurface = new THREE.MeshPhongMaterial( { map: texUnderground, wireframe: false});

	//material of resources
	let matPot = new THREE.MeshPhongMaterial( { map: texPotassium, wireframe: false});
	let matCal = new THREE.MeshPhongMaterial( { map: texCaloricum, wireframe: false});
	let matCop = new THREE.MeshPhongMaterial( { map: texCopper, wireframe: false});

	//creation of the edge	
	groupSurface= new THREE.Group();
	let numberRows =2;
	for(let x=-NUMELEMENTS; x<NUMELEMENTS; x++){
			for(let z=0; z<numberRows; z++){
				let meshEdge = new THREE.Mesh( geoEdge, matEdge );
				let posEdge = new THREE.Vector3(x*BOXSIZE.x, 0.75*BOXSIZE.y, -z*BOXSIZE.x);
				meshEdge.position.copy(posEdge);
				if(z===0) {
					let name = "(" + x + ")";
					meshEdge.name= name;
				}
				
				meshEdge.receiveShadow = true;
				meshEdge.castShadow = true;
				groupSurface.add( meshEdge );
		}
	}
	

	//creation of the plain big surface
	let meshSurface = new THREE.Mesh( geoSurface, matSurface );
	let posSurface = new THREE.Vector3(0, 0.75*BOXSIZE.y, -((SURFACEMULTI*BOXSIZE.y)/2+BOXSIZE.z*3/2));
	meshSurface.position.copy(posSurface);
	meshSurface.receiveShadow = true;
	meshSurface.castShadow = true;
	groupSurface.add( meshSurface );
	
	model.add(groupSurface);

	
	
	//creation of the underground boxes
	group = new THREE.Group();

	
	//set probability of rescourses
	function randMat(){
		let ranNum=Math.random();
		//console.log(returnVal);
		let returnVal;
		if(ranNum<0.8){
			returnVal=0;
			return returnVal;
		}
		if(0.8<=ranNum&&ranNum<0.9){
			returnVal=1;
			return returnVal;
		}
		if(0.9<=ranNum&&ranNum<0.95){
			returnVal=2;
			return returnVal;
		}
		if(0.95<=ranNum&&ranNum<=1){
			returnVal=3;
			return returnVal;
		}
	}
	
	
	for(let x=-NUMELEMENTS; x<NUMELEMENTS; x++){
		for(let y=0; y<NUMELEMENTS; y++){
			let material;
			let materialMapContent=randMat();
			
				if (materialMapContent==0){
					material = matUnderground.clone();
				}
				if (materialMapContent==1){
					material = matCal.clone();
				}
				if (materialMapContent==2){
					material = matCop.clone();
				}
				if (materialMapContent==3){
					material = matPot.clone();
				}
			
			let meshUnderground = new THREE.Mesh( geoUnderground, material );
			let pos = new THREE.Vector3(x*BOXSIZE.x, -y*BOXSIZE.y, 0*BOXSIZE.z);
			meshUnderground.position.copy(pos);
			
			let name = "(" + x + "|" + y + ")"; //set name to get object for drilling function (delete cubes), (scene.getObjectByName)
			meshUnderground.name= name;
			meshUnderground.userData.positionX = x;
			meshUnderground.userData.positionY = y; //used for function to highlight the cubes
			meshUnderground.userData.material = materialMapContent; //used for transferring the material to the gui interface
			
			meshUnderground.receiveShadow = true;
			meshUnderground.castShadow = true;
			group.add( meshUnderground );
		}
	}
	
	
	model.add(group);
	
	
	//creation of the second cube row as one surface
	let meshUndergroundPlain = new THREE.Mesh( geoUndergroundPlain, matUndergroundPlain );
	let posUndergroundPlain = new THREE.Vector3(-0.5*BOXSIZE.x, -((NUMELEMENTS*BOXSIZE.y)/2-BOXSIZE.y/2), -1*BOXSIZE.z);
	meshUndergroundPlain.position.copy(posUndergroundPlain);
	meshUndergroundPlain.receiveShadow = true;
	meshUndergroundPlain.castShadow = true;
	model.add( meshUndergroundPlain );

	
	
	
	


	//Rocket-body:
	let groupRocket =new THREE.Group();
	let texRocketCube = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/mainrocket_texture.jpg" );
	let matRocketCube1 = new THREE.MeshPhongMaterial( { map: texRocketCube, wireframe: false});
	
	let texRocketCube2 = new THREE.TextureLoader().load( "https://raw.githubusercontent.com/d-sacre/empire-space-company/legacy/pictures/textures/rocket_side_texture_small.jpg" );
	let matRocketCube2 = new THREE.MeshPhongMaterial( { map: texRocketCube2, wireframe: false});
	
	let geoRocketCube1 = new THREE.BoxBufferGeometry( BOXSIZE.x*0.3 , BOXSIZE.y,  BOXSIZE.z);
	for(let x=-2;x<=2;x+=4){
		for(let y=1.5; y<5.5*ROCKHIGHT; y++){
			let meshRocketCube1;
			let posRocketCube1 = new THREE.Vector3(x*BOXSIZE.x, y*BOXSIZE.y, BOXSIZE.y*0);
			meshRocketCube1 = new THREE.Mesh( geoRocketCube1, matRocketCube1 );
			meshRocketCube1.position.copy(posRocketCube1);
			meshRocketCube1.receiveShadow = true;
			meshRocketCube1.castShadow = true;
			groupRocket.add( meshRocketCube1 );
		}
	}
	for(let x=-1;x<=1;x+=1){
		for(let y=1.5; y<5.5*ROCKHIGHT; y++){
			let meshRocketCube1;
			let posRocketCube1 = new THREE.Vector3(x*BOXSIZE.x, y*BOXSIZE.y, -1*BOXSIZE.z*1.5);

			meshRocketCube1 = new THREE.Mesh( geoRocketCube1, matRocketCube1 );
			meshRocketCube1.position.copy(posRocketCube1);
			meshRocketCube1.receiveShadow = true;
			meshRocketCube1.castShadow = true;
			meshRocketCube1.rotateY( Math.PI / 2 );
			groupRocket.add( meshRocketCube1 );
		}
	}

	for(let x=-1.75;x<=1.75;x+=3.5){
		for(let y=1.5; y<5.5*ROCKHIGHT; y++){
			let meshRocketCube1;
			meshRocketCube1 = new THREE.Mesh( geoRocketCube1, 	matRocketCube1 );
			meshRocketCube1.rotateY( Math.sign(x)* Math.PI / 5.4 );
			meshRocketCube1.receiveShadow = true;
			meshRocketCube1.castShadow = true;
			let posRocketCube1 = new THREE.Vector3(x*BOXSIZE.x, y*BOXSIZE.y, BOXSIZE.z*(-1.0));
			meshRocketCube1.position.copy(posRocketCube1);
			groupRocket.add( meshRocketCube1 );
		}
	}

	//Rocket fuel tanks:


	var geoRocketTank = new THREE.CylinderBufferGeometry( 1.5*BOXSIZE.x, 1.5*BOXSIZE.x, 7*BOXSIZE.x, 32 );
	for(let x=-3.3;x<=3.3;x+=6.6){
			let meshRocketTank;
			meshRocketTank = new THREE.Mesh( geoRocketTank, 	matRocketCube2 );
			meshRocketTank.receiveShadow = true;
			meshRocketTank.castShadow = true;
			let posRocketCube1 = new THREE.Vector3(x*BOXSIZE.x, 5*BOXSIZE.y, BOXSIZE.z*(-1.0));
			meshRocketTank.position.copy(posRocketCube1);
			groupRocket.add( meshRocketTank );
	}

/*	let meshRocketTank;
	meshRocketTank = new THREE.Mesh( geoRocketTank, 	matMetalSilver );
	meshRocketTank.receiveShadow = true;
	meshRocketTank.castShadow = true;
	let posRocketCube1 = new THREE.Vector3(0*BOXSIZE.x, 4*BOXSIZE.y, BOXSIZE.z*(-3.3));
	meshRocketTank.position.copy(posRocketCube1);
	groupRocket.add( meshRocketTank );
	*/
	
	// Rocket bottom:
	let geoRocketBottom = new THREE.RingBufferGeometry( 1.9*BOXSIZE.x, 5, 32 );
	let matRocketBottom = new THREE.MeshBasicMaterial( { map: texRocketCube, side: THREE.DoubleSide,  } );
	let meshRocketBottom;
	meshRocketBottom = new THREE.Mesh( geoRocketBottom, 	matRocketBottom );
	meshRocketBottom.receiveShadow = true;
	meshRocketBottom.castShadow = true;
	let posRocketBottom = new THREE.Vector3(0*BOXSIZE.x, 5.5*BOXSIZE.y*ROCKHIGHT, BOXSIZE.z*0);
	meshRocketBottom.position.copy(posRocketBottom);
	meshRocketBottom.rotateX( Math.PI / 2 );
	groupRocket.add( meshRocketBottom );

	//Rocket tank
	var geoRocketTank = new THREE.CylinderBufferGeometry( 1.5*BOXSIZE.x, 1.5*BOXSIZE.x, 7*BOXSIZE.x, 32 );
	for(let x=-3.3;x<=3.3;x+=6.6){
			let meshRocketTank;
			meshRocketTank = new THREE.Mesh( geoRocketTank, 	matRocketCube1 );
			meshRocketTank.receiveShadow = true;
			meshRocketTank.castShadow = true;
			let posRocketCube1 = new THREE.Vector3(x*BOXSIZE.x, 5*BOXSIZE.y, BOXSIZE.z*(-1.0));
			meshRocketTank.position.copy(posRocketCube1);
			groupRocket.add( meshRocketTank );
	}
	/*
	let meshRocketTank;
	meshRocketTank = new THREE.Mesh( geoRocketTank, 	matRocketCube1 );
	meshRocketTank.receiveShadow = true;
	meshRocketTank.castShadow = true;
	let posRocketCube1 = new THREE.Vector3(0*BOXSIZE.x, 4*BOXSIZE.y, BOXSIZE.z*(-3.3));
	meshRocketTank.position.copy(posRocketCube1);
	groupRocket.add( meshRocketTank );
	group.add( groupRocket );
	*/

	model.add( groupRocket );

	return model;
}
