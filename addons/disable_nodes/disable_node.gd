@tool
extends EditorPlugin

const DisableNodesInspectorPlugin = preload("res://addons/disable_nodes/disable_nodes_inspector.gd")

var inspector_plugin

func _enter_tree():
	# Add the custom inspector
	inspector_plugin = DisableNodesInspectorPlugin.new()
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	# Remove the inspector when the plugin is disabled
	remove_inspector_plugin(inspector_plugin)
	inspector_plugin = null
