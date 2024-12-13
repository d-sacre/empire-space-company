extends Node

################################################################################
#### AUTOLOAD REMARKS ##########################################################
################################################################################
# This script is autoloaded as "DictionaryParsing".

func _init():
	print("\t-> Load Dictionary Parsing Utility...")

################################################################################
#### PUBLIC MEMBER FUNCTIONS ###################################################
################################################################################
func get_dict_element_via_keychain(dict, keyChain):
	var _dict_element = dict

	for key in keyChain:
		_dict_element = _dict_element[key]

	return _dict_element

func set_dict_element_via_keychain(dict, keyChain, value) -> void:
	var _tmp_lenKeyChain : int = len(keyChain)

	match _tmp_lenKeyChain:
		1:
			dict[keyChain[0]] = value
		2:
			dict[keyChain[0]][keyChain[1]] = value
		3:
			dict[keyChain[0]][keyChain[1]][keyChain[2]] = value
		4:
			dict[keyChain[0]][keyChain[1]][keyChain[2]][keyChain[3]] = value
		5:
			dict[keyChain[0]][keyChain[1]][keyChain[2]][keyChain[3]][keyChain[4]] = value

		_:
			assert(false, "ERROR: Operation is not defined")

func add_to_dict_element_via_keychain(dict, keyChain, value) -> void:
	var _tmp_lenKeyChain : int = len(keyChain)

	match _tmp_lenKeyChain:
		1:
			dict[keyChain[0]] += value
		2:
			dict[keyChain[0]][keyChain[1]] += value
		3:
			dict[keyChain[0]][keyChain[1]][keyChain[2]] += value
		4:
			dict[keyChain[0]][keyChain[1]][keyChain[2]][keyChain[3]] += value
		5:
			dict[keyChain[0]][keyChain[1]][keyChain[2]][keyChain[3]][keyChain[4]] += value

		_:
			assert(false, "ERROR: Operation is not defined")
