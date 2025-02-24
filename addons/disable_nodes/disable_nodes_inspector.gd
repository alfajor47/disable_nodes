# res://addons/disable_nodes/disable_nodes_inspector.gd
@tool
extends EditorInspectorPlugin

func _can_handle(object):
	return object is Node  # Applies to any node

func _parse_begin(object):
	add_property_editor("disable_node", DisableNodesProperty.new(object))


# Custom class for the "Disable Node" property
class DisableNodesProperty:
	extends EditorProperty
	var node: Node
	var disable_only: CheckBox
	var disable_with_name: CheckBox
	var warning_label: Label
	var container: VBoxContainer
	
	# In this array, we define the "actions" to apply.
	# Each entry is a dictionary with:
	#   "method": name of the setter method to call.
	#   "getter": (optional) name of the method or property to get the original value.
	#   "disabled_value": value to assign when disabling.
	#   "enabled_value": "normal" value (to restore).
	const ACTIONS = [
		{ "method": "set_process", "getter": "is_processing", "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_process", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_process_input", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_process_unhandled_input", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_process_unhandled_key_input", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_visible", "getter": "visible", "disabled_value": false, "enabled_value": true },
		{ "method": "set_disabled", "getter": "disabled", "disabled_value": true, "enabled_value": false },
		{ "method": "set_enabled", "getter": "enabled", "disabled_value": false, "enabled_value": true },
		{ "method": "set_freeze", "getter": "freeze", "disabled_value": true, "enabled_value": false },
		{ "method": "set_stream_paused", "getter": "stream_paused", "disabled_value": true, "enabled_value": false },
		{ "method": "set_emitting", "getter": "emitting", "disabled_value": false, "enabled_value": true },
		{ "method": "set_monitoring", "getter": "monitoring", "disabled_value": false, "enabled_value": true },
		{ "method": "set_monitorable", "getter": "monitorable", "disabled_value": false, "enabled_value": true },
		{ "method": "set_avoidance_enabled", "getter": "avoidance_enabled", "disabled_value": false, "enabled_value": true },
		{ "method": "set_paused", "getter": "paused", "disabled_value": true, "enabled_value": false },
		{ "method": "set_editable", "getter": "editable", "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_active", "getter": "physics_active", "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_process_internal", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_process_input", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_process_unhandled", "getter": null, "disabled_value": false, "enabled_value": true },
		{ "method": "set_physics_process_unhandled_key_input", "getter": null, "disabled_value": false, "enabled_value": true }
	]
	
	func _init(n):
		node = n
		
		# Create container for controls
		container = VBoxContainer.new()
		
		# Checkbox: disable functionality only
		disable_only = CheckBox.new()
		disable_only.text = "Disable Node (functionality only)"
		disable_only.toggled.connect(_on_disable_only_toggle)
		
		# Checkbox: disable and change name
		disable_with_name = CheckBox.new()
		disable_with_name.text = "Disable Node (with name change)"
		disable_with_name.toggled.connect(_on_disable_with_name_toggle)
		
		# Warning label
		warning_label = Label.new()
		warning_label.text = "⚠️ Warning: Using name change option might cause errors if you're finding nodes by name (e.g. get_node())."
		warning_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		warning_label.add_theme_color_override("font_color", Color(1, 0.7, 0, 1))
		
		# Add elements to the container in order
		container.add_child(disable_only)
		container.add_child(disable_with_name)
		container.add_child(warning_label)
		
		add_child(container)
		refresh()

	func _on_disable_with_name_toggle(checked):
		node.set_meta("disabled_with_name", checked)
		node.set_meta("disabled_only", false)
		disable_only.button_pressed = false
		_update_node_state(node, checked, true)

	func _on_disable_only_toggle(checked):
		node.set_meta("disabled_only", checked)
		node.set_meta("disabled_with_name", false)
		disable_with_name.button_pressed = false
		_update_node_state(node, checked, false)

	func refresh():
		if node.has_meta("disabled_with_name"):
			disable_with_name.button_pressed = node.get_meta("disabled_with_name")
		if node.has_meta("disabled_only"):
			disable_only.button_pressed = node.get_meta("disabled_only")

	# Function to disable (or restore) the node and its children reversibly.
	func _update_node_state(node: Node, disabled: bool, update_name: bool) -> void:
		# If disabling and the original state hasn't been saved yet, store it in a dictionary.
		if disabled and not node.has_meta("original_state"):
			var orig = {}
			for action in ACTIONS:
				var meth = action.method
				if node.has_method(meth):
					# If a getter exists and is callable, use it to get the original state.
					if action.has("getter") and action.getter != null:
						# First try to access it as a property; if it fails, try as a method.
						if node.has_meta(action.getter):
							orig[meth] = node.get(action.getter)
						elif node.has_method(action.getter):
							orig[meth] = node.call(action.getter)
						else:
							orig[meth] = action.enabled_value
					else:
						orig[meth] = action.enabled_value
			node.set_meta("original_state", orig)
		
		# Apply the known actions for this node.
		for action in ACTIONS:
			var meth = action.method
			if node.has_method(meth):
				# If we're disabling, use the value defined in disabled_value;
				# otherwise, if restoring, use the saved value or the enabled_value.
				var val = action.disabled_value if disabled else (node.get_meta("original_state").get(meth, action.enabled_value) if node.has_meta("original_state") else action.enabled_value)
				# Invoke the function directly (to avoid issues with call)
				match meth:
					"set_process":
						node.set_process(val)
					"set_physics_process":
						node.set_physics_process(val)
					"set_process_input":
						node.set_process_input(val)
					"set_process_unhandled_input":
						node.set_process_unhandled_input(val)
					"set_process_unhandled_key_input":
						node.set_process_unhandled_key_input(val)
					"set_visible":
						# Many nodes have the visible property
						if "visible" in node:
							node.visible = val
						else:
							node.call(meth, val)
					"set_disabled":
						node.set_disabled(val)
					"set_enabled":
						node.set_enabled(val)
					"set_freeze":
						node.set_freeze(val)
					"set_stream_paused":
						node.set_stream_paused(val)
					"set_emitting":
						node.set_emitting(val)
					"set_monitoring":
						node.set_monitoring(val)
					"set_monitorable":
						node.set_monitorable(val)
					"set_avoidance_enabled":
						node.set_avoidance_enabled(val)
					"set_paused":
						node.set_paused(val)
					"set_editable":
						node.set_editable(val)
					"set_physics_active":
						node.set_physics_active(val)
					"set_physics_process_internal":
						node.set_physics_process_internal(val)
					"set_physics_process_input":
						node.set_physics_process_input(val)
					"set_physics_process_unhandled":
						node.set_physics_process_unhandled(val)
					"set_physics_process_unhandled_key_input":
						node.set_physics_process_unhandled_key_input(val)
					_:
						node.call(meth, val)
		
		# Special handling for set_process_mode (to avoid errors in some nodes)
		if node.has_method("set_process_mode"):
			node.set_process_mode(Node.PROCESS_MODE_DISABLED if disabled else Node.PROCESS_MODE_INHERIT)
		
		# Special call to stop processes if the stop() method exists
		if disabled and node.has_method("stop"):
			node.call("stop")
		
		# If restoring, return the original values (and remove the metadata)
		if not disabled and node.has_meta("original_state"):
			var orig = node.get_meta("original_state")
			for action in ACTIONS:
				var meth = action.method
				if node.has_method(meth) and orig.has(meth):
					match meth:
						"set_process":
							node.set_process(orig[meth])
						"set_physics_process":
							node.set_physics_process(orig[meth])
						"set_process_input":
							node.set_process_input(orig[meth])
						"set_process_unhandled_input":
							node.set_process_unhandled_input(orig[meth])
						"set_process_unhandled_key_input":
							node.set_process_unhandled_key_input(orig[meth])
						"set_visible":
							if "visible" in node:
								node.visible = orig[meth]
							else:
								node.call(meth, orig[meth])
						"set_disabled":
							node.set_disabled(orig[meth])
						"set_enabled":
							node.set_enabled(orig[meth])
						"set_freeze":
							node.set_freeze(orig[meth])
						"set_stream_paused":
							node.set_stream_paused(orig[meth])
						"set_emitting":
							node.set_emitting(orig[meth])
						"set_monitoring":
							node.set_monitoring(orig[meth])
						"set_monitorable":
							node.set_monitorable(orig[meth])
						"set_avoidance_enabled":
							node.set_avoidance_enabled(orig[meth])
						"set_paused":
							node.set_paused(orig[meth])
						"set_editable":
							node.set_editable(orig[meth])
						"set_physics_active":
							node.set_physics_active(orig[meth])
						"set_physics_process_internal":
							node.set_physics_process_internal(orig[meth])
						"set_physics_process_input":
							node.set_physics_process_input(orig[meth])
						"set_physics_process_unhandled":
							node.set_physics_process_unhandled(orig[meth])
						"set_physics_process_unhandled_key_input":
							node.set_physics_process_unhandled_key_input(orig[meth])
						_:
							node.call(meth, orig[meth])
			node.remove_meta("original_state")
		
		# Update the node name if requested
		if update_name:
			_update_node_name_in_scene_tree(node, disabled)
		else:
			_update_node_name_in_scene_tree(node, false)
		
		# Apply recursively to all children
		for child in node.get_children():
			_update_node_state(child, disabled, update_name)

	func _update_node_name_in_scene_tree(node: Node, disabled: bool) -> void:
		var current_name = node.name
		if disabled:
			if "(Disabled🔴)" not in current_name:
				node.name = current_name + " (Disabled🔴)"
		else:
			node.name = current_name.replace(" (Disabled🔴)", "")
