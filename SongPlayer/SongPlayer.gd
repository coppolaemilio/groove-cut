extends Node

var Note = load("res://Other/Placeholder.tscn")

var current_song = []

func _on_Timer_timeout():
	var new_note = Note.instance()
	get_parent().get_node('Notes').add_child(new_note)
