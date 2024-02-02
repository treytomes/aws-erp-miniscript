// Calculator panel
calc = Panel.make(root, 168, 0, 960-168, 640)
calc.title = "Calculator"
calc.style.color = "#33cc99"
calc.style.buttonColor = "#99dd66"
calc.style.displayColor = "#88CCFF"
calc.header = Frame.make(calc, null, calc.top - 108)
calc.header.configure false, true, true, false
calc.displayStr = "0"
calc.clearOnInput = false
Block.make calc.header.leftPanel
Block.make calc.header.bottomPanel
title = InfoBlock.make("CALCULATOR", calc.header,
	calc.header.right - 200, calc.top - 30, 200, 30)
title.font = largeFont
title.inverted = true

calc.display = Panel.make(calc, calc.left+160, calc.top-64, 420, 48)
calc.display.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, "#666688"
	largeFont.printRight calc.displayStr, self.right - 4, self.bottom + 8, 2, self.style.displayColor
end function

calc.doAction = function(s)
	if s >= "0" and s <= "9" then
		if self.displayStr == "0" or self.clearOnInput then self.displayStr = ""
		self.displayStr += s
		self.clearOnInput = false
		sounds.blip.play 0.5, 0, noteFreq(67)/440
	else if s == "Backspace" and self.displayStr then
		self.displayStr = calc.displayStr[:-1]
		if not self.displayStr then self.displayStr = "0"
		sounds.blip.play 0.5, 0, noteFreq(71)/440
		wait 0.05; sounds.blip.play 0.5, 0, noteFreq(72)/440
	else if s == "Clear" then
		self.displayStr = "0"
		self.opA.text = ""
		self.operator.text = ""
		self.opA.present
		self.operator.present
		sounds.blip.play 0.5, 0, noteFreq(64)/440
		wait 0.1; sounds.blip.play 0.5, 0, noteFreq(67)/440
		wait 0.1; sounds.blip.play 0.5, 0, noteFreq(72)/440
	else if s == "=" then
		op = self.operator.text
		if not op then return
		valA = val(self.opA.text)
		valB = val(self.displayStr)
		result = valB
		if op == "+" then result = valA + valB
		if op == "-" then result = valA - valB
		if op == "*" then result = valA * valB
		if op == "/" then result = valA / valB
		if op == "^" then result = valA ^ valB
		if op == "%" then result = valA % valB
		if op == "and" then result = valA and valB
		if op == "or" then result = valA or valB
		if op == "not" then result = valA not valB
		self.displayStr = str(result)
		sounds.blip.play 0.5, 0, noteFreq(60)/440
		self.main.log.add valA + " " + op + " " + valB, self.displayStr
		self.opA.text = ""; self.opA.present
		self.operator.text = ""; self.operator.present
		self.clearOnInput = true
		wait 0.1
	else
		if self.operator and not self.clearOnInput then self.doAction "="
		self.opA.text = self.displayStr; self.opA.present
		self.operator.text = s; self.operator.present
		self.clearOnInput = true
		sounds.blip.play 0.5, 0, noteFreq(64)/440
	end if
	self.display.present
end function

calc.main = Frame.make(calc, null, 0, null, calc.height - 118)
calc.main.configure true, false, true, false

Gap.make calc.main.topPanel
calc.main.logHeader = InfoBlock.make("Calculation Log", calc.main.topPanel, null, null, 320)
calc.main.topPanel.layout

b = Button.make("Backspace", calc.main.leftPanel, null, null, null, calc.style.buttonHeight)
b.action = function; calc.doAction self.caption; end function
b.key = char(8)

b = Button.make("Clear", calc.main.leftPanel, null, null, null, calc.style.buttonHeight)
b.action = function; calc.doAction self.caption; end function
b.key = char(1)	// (Home button, at least on Macs)

InfoBlock.make "", calc.main.leftPanel, null, null, null, calc.style.buttonHeight*2

b = Button.make("=", calc.main.leftPanel, null, null, null, calc.style.buttonHeight*3)
b.action = function; calc.doAction self.caption; end function
b.key = ["=", char(10), char(13), char(3)]

Gap.make calc.main.leftPanel

calc.opA = InfoBlock.make("", calc.main.leftPanel, null, null, null, calc.style.buttonHeight)
calc.operator = InfoBlock.make("", calc.main.leftPanel, null, null, null, calc.style.buttonHeight)
Gap.make calc.main.leftPanel
calc.main.leftPanel.layout

calc.main.setup = function
	y = self.topPanel.bottom - 72
	btns = ["789", "456", "123", " 0.", "+-*", "/^%", ["and","or","not"]]
	for row in btns.indexes
		for col in btns[row].indexes
			x = self.topPanel.left + 96*col
			if btns[row][col] == " " then continue
			if btns[row][col] == "0" then
				x = self.topPanel.left
				b = RoundButton.make(btns[row][col], calc, x, y, 84+96, 48)
			else
				b = RoundButton.make(btns[row][col], calc, x, y, 84, 48)
			end if
			b.action = function; calc.doAction self.caption; end function
		end for
		y = y - 60 - 24 * (row == 3)
	end for
end function
calc.main.setup

calc.main.log = Panel.make(calc.main, calc.main.logHeader.left, 16, calc.main.logHeader.width, calc.main.topPanel.bottom - 40)
calc.main.log.add = function(expression, result)
	h = self.style.topBarHeight
	gap = 8
	y = self.top - h - self.children.len * (h+gap)
	while y < self.bottom
		self.children[0].dismiss; self.children[0].destroy
		for b in self.children; b.move 0, h+gap; end for
		y += h+gap
	end while
	b = Button.make(expression + " = " + result, self, self.left, y, self.width, h)
	b.action = function
		calc.displayStr = result
		calc.display.present
		sounds.blip.play 0.5, 0, noteFreq(65)/440
		wait 0.05; sounds.blip.play 0.5, 0, noteFreq(67)/440
	end function
	b.present
end function

return calc
