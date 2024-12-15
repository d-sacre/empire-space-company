extends Node

################################################################################
#### AUTOLOAD REMARKS ##########################################################
################################################################################
# This script is autoloaded as "JsonFio".

################################################################################
#### PUBLIC MEMBER FUNCTIONS ###################################################
################################################################################
# json loading
# REMARK: json file can be either dictionary or array
func load_json(fp):
	#var file = File.new()
	#var _tmp_error : int = file.open(fp, File.READ)
	#var data = parse_json(file.get_as_text())
	#file.close()
	
	var json_as_text = FileAccess.get_file_as_string(fp)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	return json_as_dict
