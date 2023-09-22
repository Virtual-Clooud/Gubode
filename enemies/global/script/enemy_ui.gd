extends Control

onready var holder = get_node("../")

func _ready():
	$ProgressBar.max_value = holder.get("maxlife")
	$ProgressBar.value = holder.get("life")
func _physics_process(_delta):
	$ProgressBar.value = holder.get("life")
