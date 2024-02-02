// This demo makes a GUI interface based on the famous LCARS UI,
// complete with a working file manager and other tools.
//
// It's mostly a matter of laying out panels with buttons and other
// widgets.

//======================================================================
// LCARS Application

// Root: the base of our entire display
root = Panel.make(null, 0, 0, 960, 640)

//----------------------------------------------------------------------
// Load in our individual "apps".

// TODO: Iterator over the "modules" folder to dynamically read in the apps.

//----------------------------------------------------------------------
// Main Menu: a simple panel of buttons (and gaps) on the left side of the screen.
// Color of each button corresponds to the primary color of the UI it shows.
mainMenu = Panel.make(root, 0, 0, 144, 640)
mainMenu.style = new root.style
mainMenu.style.buttonHeight = 36
mainMenu.style.buttonColor = "#ffaa90"
mainMenu.style.infoBlockColor = "#D0B0A0"
mainMenu.curMode = null

mainMenu.switchTo = function(modePanel)
	if self.curMode == modePanel then return
	if self.curMode then self.curMode.dismiss
	sounds.alert.play
	self.curMode = modePanel
	self.curMode.present
end function

// Mini-clock at the top
miniClock = InfoBlock.make(dateTime.now[-8:-3], mainMenu, null, null, null, 40)
// Settings button
Button.make("Settings", mainMenu, null, null, null, mainMenu.style.buttonHeight).action = function
	// We don't have any settings yet.
	// Maybe someday!
	sounds.err.play
end function
// ...gap...
Gap.make mainMenu

// Main buttons, one for each mode


// fileManager = require("modules/fileManager/main")
// b = Button.make("File Manager", mainMenu, null, null, null, mainMenu.style.buttonHeight)
// b.style.buttonColor = fileManager.style.color
// b.action = function
// 	mainMenu.switchTo fileManager
// end function

// clock = require("modules/clock/main")
// b = Button.make("Clock", mainMenu, null, null, null, mainMenu.style.buttonHeight)
// b.style.buttonColor = clock.style.color
// b.action = function
// 	mainMenu.switchTo clock
// end function

// calc = require("modules/calc/main")
// b = Button.make("Calculator", mainMenu, null, null, null, mainMenu.style.buttonHeight)
// b.style.buttonColor = calc.style.color
// b.action = function
// 	mainMenu.switchTo calc
// end function

// news = require("modules/news/main")
// b = Button.make("News", mainMenu, null, null, null, mainMenu.style.buttonHeight)
// b.style.buttonColor = news.style.color
// b.action = function
// 	mainMenu.switchTo news
// end function

moduleNames = [ "fileManager", "clock", "calc", "news", "sample" ]
modules = []
for moduleName in moduleNames
	module = require("modules/{0}/main".fill([ moduleName ]))
	modules.push module

	b = Button.make(module.title, mainMenu, null, null, null, mainMenu.style.buttonHeight)
	b.module = module
	b.style.buttonColor = module.style.color
	b.action = function
		mainMenu.switchTo self.module
	end function
end for

// ...gap...
Gap.make mainMenu
// Exit button at bottom
exitBtn = Button.make("Exit", mainMenu, null, null, null, mainMenu.style.buttonHeight)
exitBtn.action = function
	root.dismiss; root.destroy
	exit
end function
exitBtn.key = char(27)

events.eventLoop.onGotKey = function(k)
	Button.checkKey k
end function
events.eventLoop.onUpdate = function
	mainMenu.curMode.onUpdate
	if key.pressed("page down") then
		Button.checkKey char(4)  // ctrl-D
		while key.pressed("page down"); yield; end while
	else if	key.pressed("page up") then
		Button.checkKey char(21)  // ctrl-U
		while key.pressed("page up"); yield; end while
	end if
	time = dateTime.now[-8:-3]
	if time != miniClock.text then
		miniClock.text = time
		miniClock.present
	end if
end function

mainMenu.layout
mainMenu.present
mainMenu.switchTo modules[0]

events.eventLoop.run


run "cleanup"
