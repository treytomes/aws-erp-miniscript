import "importUtil"
ensureImport "listUtil"

env.addImportPath = function(path)
    if not self.importPaths.contains(path) then
        self.importPaths.push path
    end if
end function

env.addImportPath "./src"

// Import all the things!
ensureImport "utils"
ensureImport "mathUtil"
ensureImport "stringUtil"
ensureImport "events"
ensureImport "bmfFonts"
ensureImport "dateTime"
ensureImport "gui"
ensureImport "styledText"

file.loadSound("/sys/sounds/blip-thinking.wav").play

clear
spriteDisp = display(4)
display(7).mode = displayMode.pixel
scratch = display(7)
gfx.clear color.black

smallFont = bmfFonts.Font.load("/sys/fonts/minimicro-pro-12.bmf")
mediumFont = bmfFonts.Font.load("/sys/fonts/minimicro-pro-16.bmf")
largeFont = bmfFonts.Font.load("/sys/fonts/minimicro-pro-20.bmf")

resourcePic = file.loadImage("/sys/data/desktop/desktopGfx.png")
swoopImages = []
w = 163; h = 73
for i in range(0,3)
	swoopImages.push resourcePic.getImage(512-w*2+(i%2)*w, 512-h-h*floor(i/2), w, h)
end for
oval48 = gui.Image9Slice.make(resourcePic.getImage(464, 0, 48, 48), 24,24,24,24)
oval32 = gui.Image9Slice.make(resourcePic.getImage(424, 0, 32, 32), 16,16,16,16)
oval24 = gui.Image9Slice.make(resourcePic.getImage(392, 0, 24, 24), 12,12,12,12)
leftCap24 = gui.Image9Slice.make(resourcePic.getImage(392, 0, 12, 24), 11,12,1,12)
rightCap24 = gui.Image9Slice.make(resourcePic.getImage(404, 0, 12, 24), 1,12,11,12)

// Let's add a couple special characters to our fonts.
downInChar = char(8627)
upOutChar = char(11025)
smallFont.addChar downInChar, resourcePic.getImage(0,458,13,10), 0, 1, null
smallFont.addChar upOutChar, resourcePic.getImage(0,468,13,13), 0, -1, null
mediumFont.addChar downInChar, resourcePic.getImage(16,454,15,12), 0, 2, null
mediumFont.addChar upOutChar, resourcePic.getImage(16,466,15,14), 0, 0, null
pageUpChar = char(8670)
pageDownChar = char(8671)
lineUpChar = char(8613)
lineDownChar = char(8615)
mediumFont.addChar lineUpChar, resourcePic.getImage(16, 439, 15, 14), 0, 0, null
mediumFont.addChar pageUpChar, resourcePic.getImage(16, 424, 15, 14), 0, 0, null
mediumFont.addChar pageDownChar, resourcePic.getImage(16, 409, 15, 14), 0, 0, null
mediumFont.addChar lineDownChar, resourcePic.getImage(16, 394, 15, 14), 0, 0, null

// And prepare some sounds
sounds = {}
sounds.blip = file.loadSound("/sys/sounds/blipA4.wav")
sounds.alert = file.loadSound("/sys/sounds/blip-alert.wav")
sounds.ok = file.loadSound("/sys/sounds/blip-ok.wav")
sounds.err = file.loadSound("/sys/sounds/blip-what.wav")

Style = require("ui/Style")
Panel = require("ui/Panel")
Block = require("ui/Block")
Gap = require("ui/Gap")
Button = require("ui/Button")
RoundButton = require("ui/RoundButton")
InfoBlock = require("ui/InfoBlock")
Swoop = require("ui/Swoop")
Frame = require("ui/Frame")

run "main"
