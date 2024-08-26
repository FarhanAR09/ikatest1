extends Node

func parse (filePath : String) -> Array[Dictionary] :
	#Open file
	if FileAccess.file_exists(filePath) :
		var file = FileAccess.open(filePath, 1)
		var data = []
		while not file.eof_reached():
			var line = file.get_line()
			var values = line.split(",")
			var processedValues : Array[String]
			for value in values :
				processedValues.append(value.substr(1, value.length() - 2))
			data.append(processedValues) 
		file.close()
		
		#Get keys from first row
		var keys : Array[String]
		for col in data[0] :
			keys.append(col)
		data.remove_at(0)
		
		var classes : Array[Dictionary]
		
		#Get values from each row
		var index : int = 0
		for row in data:
			var gameClass : Dictionary = {}
			index = 0
			for col in row:
				var keyName : String
				match index :
					0: keyName = "ID"
					1: keyName = "JOBNAME"
					2: keyName = "DESCRIPTION"
					3: keyName = "SKILLS"
					_: keyName = ""
				if index == 0 :
					var parsedId : int = col.to_int()
					if parsedId == null :
						parsedId = -1
					gameClass[keyName] = parsedId
				elif index == 3 :
					var packeds : PackedStringArray = col.split(";")
					var skills : Array[String]
					for packed : String in packeds :
						if packed.begins_with(" ") :
							packed = packed.substr(1, packed.length() - 1)
						skills.append(packed)
					skills.pop_back()
					gameClass[keyName] = skills
				else :
					gameClass[keyName] = col
				index += 1
			classes.append(gameClass)
		return classes
	else :
		print("File not found ", filePath)
	return []
