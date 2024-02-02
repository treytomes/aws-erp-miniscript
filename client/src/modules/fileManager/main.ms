// File Manager panel
FileRow = new Button
FileRow.selected = false
FileRow.file = null  // a file.info map
FileRow.make = function(parent, left, bottom, width, height)
	p = super.make("", parent, left, bottom, width, height)
	p.__isa = self
	return p
end function
FileRow.setPath = function(path)
	if path.startsWith("//") then path = path[1:]
	self.file = file.info(path)
	if self.sprite then self.sprite.stop
	self.sprite = null
	if self.children then
		self.children[0].dismiss; self.children[0].destroy
		self.children = []
	end if
	self.selected = false
end function
FileRow.drawToScratch = function
	f = self.file
	gap = self.style.spacing
	y = 6
	globals.gfx = scratch
	gfx.fillRect 0, 0, self.width, self.height, color.black
	if self.selected then gfx.fillEllipse 0, 6, 16, 12, color.white
	x0 = 20
	leftCap24.draw gfx, x0, 0, 16, 24
	x0 += 16 + gap
	x1 = self.width
	if self.selected then gfx.fillEllipse x1-16, 6, 16, 12, color.white
	x1 -= 20
	rightCap24.draw gfx, x1-16, 0, 16, 24; x1 -= 16 + gap

	w = 48
	gfx.fillRect x1-w, 0, w, 24, color.white
	if f == null then
		smallFont.printCentered self.file, (x0+x1)/2, y, 1, color.red
		return
	end if
	
	smallFont.printCentered f.date[-8:-3], x1-w/2, y, 1, color.black; x1 -= w + gap

	w = 88
	gfx.fillRect x1-w, 0, w, 24, color.white
	smallFont.printCentered f.date[:10], x1-w/2, y, 1, color.black; x1 -= w + gap

	name = file.name(f.path)
	if f.isDirectory then
		w = 72 + 72
		if not self.children then
			b = RoundButton.make(downInChar + " Directory", self, self.left + x1 - w, self.bottom, w, 24)
			b.captionFont = smallFont
			b.action = function
				sounds.blip.play 0.5, 0, noteFreq(69)/440
				wait 0.05; sounds.blip.play 0.5, 0, noteFreq(65)/440
				fb = self.parent.parent
				fb.load self.parent.file.path
				fb.present
			end function
			self.children = [b]
		end if
		x1 -= w + gap
	else
		w = 72
		smallFont.printCentered f.size, x1-w/2, y, 1, color.white; x1 -= w + gap

		extLen = name.reverse.indexOf(".")
		if extLen == null or extLen >= name.len - 1 then
			ext = ""
		else
			ext = name[-extLen-1:]
			name = name[:-extLen-1]
		end if
		w = 72
		gfx.fillRect x1-w, 0, w, 24, color.white
		smallFont.print ext, x1-w+2, y, 1, color.black; x1 -= w + gap
	end if
	
	w = x1 - x0
	gfx.fillRect x0, 0, w, 24, color.white
	smallFont.print name, x0+4, y, 1, color.black; x1 -= w + gap
	
	globals.gfx = display(5)
end function
FileRow.select = function(selectIt)
	if self.selected == selectIt then return
	self.selected = selectIt
	sounds.blip.play 1, 0, noteFreq(60 + 7*selectIt)/440
	self.redrawSprite
end function

fileManager = Panel.make(root, 168, 0, 960-168, 640)
fileManager.title = "File Manager"
fileManager.style.color = "#7788ff"
fileManager.style.buttonColor = "#88CCFF"
fileManager.header = Frame.make(fileManager, null, fileManager.top - 108)
fileManager.header.configure false, true, true, false
Block.make fileManager.header.leftPanel
Block.make fileManager.header.bottomPanel
title = InfoBlock.make("FILE MANAGER", fileManager.header,
	fileManager.header.right - 200, fileManager.top - 30, 200, 30)
title.font = largeFont
title.inverted = true
fileManager.infoPanel = Panel.make(fileManager.header, 
	fileManager.header.bottomPanel.left,
	fileManager.header.bottomPanel.top + 8)
fileManager.infoPanel.setTop 632, false
fileManager.infoPanel.setRight title.left - 8, false
fileManager.infoPanel.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black
	sel = fileManager.fileBox.selection
	y = self.top - 20
	smallFont.print "Files selected: " + sel.len, self.left, y, 1, self.style.textColor
	if sel.len == 0 then return
	y -= 16
	totalSize = 0
	for f in sel; totalSize += f.file.size; end for
	smallFont.print "Total bytes: " + totalSize, self.left, y, 1, self.style.textColor
end function

fileManager.fileBox = Frame.make(fileManager, null, 0, null, fileManager.height - 118)
fileManager.fileBox.configure true, true, true, false
fileManager.fileBox.fileRows = []
fileManager.fileBox.setup = function
	w = 60
	f = function
		sounds.ok.play
		fb = self.parent.parent
		fb.load self.caption
		fb.present
	end function
	Button.make("/usr", self.topPanel, null, null, w).action = @f
	Button.make("/usr2", self.topPanel, null, null, w).action = @f
	Button.make("/sys", self.topPanel, null, null, w).action = @f
	b = Button.make(upOutChar + " UP", self.topPanel, null, null, w)
	b.action = function
		fb = self.parent.parent
		if fb.path == "/" then return
		sounds.blip.play 0.5, 0, noteFreq(69)/440
		wait 0.05; sounds.blip.play 0.5, 0, noteFreq(72)/440
		fb.load file.parent(fb.path)
		fb.present
	end function
	self.pathInfo = InfoBlock.make("/usr", self.topPanel, null, null, self.topPanel.width - self.style.buttonWidth)
	self.topPanel.layout
	
	Button.make "Name", self.leftPanel, null, null, null, self.style.buttonHeight
	Button.make "Size", self.leftPanel, null, null, null, self.style.buttonHeight
	Button.make "Date", self.leftPanel, null, null, null, self.style.buttonHeight
	Button.make "Selected", self.leftPanel, null, null, null, self.style.buttonHeight
	Gap.make self.leftPanel
	Button.make("Select All", self.leftPanel, null, null, null, self.style.buttonHeight).action = function
		self.parent.parent.selectAll true
	end function
	Button.make("Select None", self.leftPanel, null, null, null, self.style.buttonHeight).action = function
		self.parent.parent.selectAll false
	end function
	Gap.make self.leftPanel
	Button.make "Move/Copy", self.leftPanel, null, null, null, self.style.buttonHeight
	self.leftPanel.layout
	
//	Button.make "Rename", self.bottomPanel, null, null, self.style.buttonWidth
//	delBtn = Button.make("Delete", self.bottomPanel, null, null, self.style.buttonWidth)
//	delBtn.color = "#DD4444"
	Gap.make self.bottomPanel
//	Button.make "Preview", self.bottomPanel, null, null, self.style.buttonWidth
	launchBtn = Button.make("Launch", self.bottomPanel, null, null, self.style.buttonWidth)
	launchBtn.color = "#33CC99"
	launchBtn.action = function
		sel = fileManager.fileBox.selection
		if sel.len != 1 or not sel[0].file.path.endsWith(".ms") then
			sounds.err.play
		else
			sounds.ok.play; wait 1
			if not env.shell then env.shell = _sourceFile
			env.autorun = false
			clear; reset; run sel[0].file.path; exit
		end if
	end function
	self.bottomPanel.layout
	
	y0 = self.bottomPanel.top + 2
	y4 = self.topPanel.bottom - 1
	bh = floor((y4 - y0) / 4)
	y1 = y0 + bh
	y2 = y0 + bh*2
	y3 = y0 + bh*3
	b = Button.make(pageDownChar, self, self.right - 24, y0, 24, y1-y0-1)
	b.key = char(4)	 // (ctrl-D)
	b.action = function
		fb = self.parent; fb.scroll 1, true
	end function
	b = Button.make(lineDownChar, self, self.right - 24, y1, 24, y2-y1-1)
	b.key = char(20)  // down-arrow
	b.action = function
		fb = self.parent; fb.scroll 1, false
	end function
	b = Button.make(lineUpChar, self, self.right - 24, y2, 24, y3-y2-1)
	b.key = char(19)  // up-arrow
	b.action = function
		fb = self.parent; fb.scroll -1, false
	end function
	b = Button.make(pageUpChar, self, self.right - 24, y3, 24, y4-y3-1)
	b.key = char(21)  // ctrl-U
	b.action = function
		fb = self.parent; fb.scroll -1, true
	end function
end function

fileManager.fileBox.scroll = function(direction, byPage=false)
	self.topRow += (1 + 13*byPage) * direction	
	self.topRow = mathUtil.clamp(self.topRow, 0, file.children(self.path).len-13)
	if self.topRow < 0 then self.topRow = 0
	self.load self.path, false
	self.present
end function

fileManager.fileBox.load = function(path, resetScroll=true)
	self.path = path
	children = file.children(path)
	if resetScroll then self.topRow = 0
	for i in range(0,13)
		if i+self.topRow >= children.len then; i -= 1; break; end if
		if i >= self.fileRows.len then
			fr = FileRow.make(self, 
			  self.topPanel.left-20, self.topPanel.bottom - 36 - 32*i, 
			  self.right - self.topPanel.left - 10, 24)
			fr.action = function
				if modKey.doAll then
					self.parent.selectAll not self.selected
				else
					self.select not self.selected
					fileManager.infoPanel.present
				end if
			end function
			self.fileRows.push fr
		end if
		self.fileRows[i].setPath file.child(self.path, children[i+self.topRow])
	end for	
	while self.fileRows.len-1 > i
		self.fileRows[-1].dismiss; self.fileRows[-1].destroy
		self.fileRows.remove -1
	end while
	self.pathInfo.text = path
	fileManager.infoPanel.present
end function

fileManager.fileBox.selectAll = function(selectEm=true)
	for fr in self.fileRows
		fr.select selectEm
	end for
	fileManager.infoPanel.present
end function

fileManager.fileBox.selection = function
	return self.fileRows.filtered("selected")
end function

fileManager.fileBox.setup
fileManager.fileBox.load "/usr/"

return fileManager
