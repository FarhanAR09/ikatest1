extends Node

@export var _classSelector : OptionButton
@export var _nameLabel : Label
@export var _descriptionLabel : Label
@export var _skillListDisplay : ItemList

var _data : Array[Dictionary]

func _ready():
	
	if _classSelector != null :
		_classSelector.connect("item_selected", _UpdateClassDisplay)
	
	_data = ClassCsvParser.parse("res://resource/classes.csv")
	if _data != null && !_data.is_empty() && _classSelector != null:
		for job in _data:
			_classSelector.add_item(job["JOBNAME"])
		_UpdateClassDisplay(0)
	
func _exit_tree():
	
	if _classSelector != null :
		_classSelector.disconnect("item_selected", _UpdateClassDisplay)

func _UpdateClassDisplay(id : int):
	
	if _data == null || _data.is_empty(): 
		return
	
	if _nameLabel != null && _data[id].has("ID") && _data[id].has("JOBNAME"):
		_nameLabel.text = "JOB NAME:\n" + str(_data[id]["ID"]) + ". " + _data[id]["JOBNAME"]
	
	if _descriptionLabel != null && _data[id].has("DESCRIPTION"):
		_descriptionLabel.text = "DESCRIPTION:\n" + _data[id]["DESCRIPTION"]
	
	if _skillListDisplay != null && _data[id].has("SKILLS"):
		_skillListDisplay.clear()
		var skills = _data[id]["SKILLS"]
		for skill in skills:
			_skillListDisplay.add_item(skill)
