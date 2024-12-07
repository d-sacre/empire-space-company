
//function for deleting the cubes and transferring the material to the gui interface
function deleteCubeUnderground(x, y){
	let cube = scene.getObjectByName( "(" + x + "|" + y + ")");
	
	if (cube != null){
		let material = cube.userData.material;
		storeMinedResources(material); //./threejs_gui_interface.js
	}
	
	group.remove(cube);
}



//function for deleting the cubes at the edge
function deleteCubeEdge(x){
	let cube = scene.getObjectByName( "(" + x + ")");
	groupSurface.remove(cube);
}



//function for the tunnel of the drill
function drill(stage) {
	let cubeEdge = scene.getObjectByName( "(" + 0 + ")");
	if (cubeEdge != null){
		deleteCubeEdge(0);
	}
	
	deleteCubeUnderground(0, stage);
}






