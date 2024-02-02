// Load a module into a local variable, allowing it to be reassigned at will.
// e.g. player = import("playerBehaviors")
globals.require = function(moduleName)
	import moduleName
	return locals[moduleName]
end function

// Modifier keys that affect various clicks.
// (This is a utility function currently only in use by the file manager.)
globals.modKey = {}
modKey.doAll = function
	return key.pressed("left alt") or key.pressed("right alt")
end function
