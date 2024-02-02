// News panel
news = Panel.make(root, 168, 0, 960-168, 640)
news.title = "News"
news.style.color = "#ffaa44"
news.style.buttonColor = "#ff7700"
news.style.textColor = "#ffeecc"
news.header = Frame.make(news, null, news.top - 108)
news.header.configure false, true, true, false
news.clearOnInput = false
Block.make news.header.leftPanel
Block.make news.header.bottomPanel
title = InfoBlock.make("NEWS", news.header,
	news.header.right - 200, news.top - 30, 200, 30)
title.font = largeFont
title.inverted = true

news.main = Frame.make(news, null, 0, null, news.height - 118)
news.main.configure true, false, true, false

Gap.make news.main.topPanel
news.date = InfoBlock.make("2000-01-01", news.main.topPanel, null, null, 160)
news.posCount = InfoBlock.make("0 / 0", news.main.topPanel, null, null, 160)
news.main.topPanel.layout

Gap.make news.main.leftPanel

b = Button.make("Previous", news.main.leftPanel, null, null, null, news.style.buttonHeight)
b.action = function; news.nextStory -1; end function
b.key = char(17)

b = Button.make("Next", news.main.leftPanel, null, null, null, news.style.buttonHeight)
b.action = function; news.nextStory 1; end function
b.key = char(18)

Gap.make news.main.leftPanel
news.main.leftPanel.layout

news.data = null; news.curItemIdx = 0
news.nextStory = function(delta=1)
	if not self.data then return
	self.curItemIdx = (self.curItemIdx + self.data.len + delta) % self.data.len
	self.content.present
end function

news.content = Panel.make(news.main, news.main.topPanel.left, 0, 
			940 - news.main.topPanel.left, news.main.topPanel.bottom - 16)
news.presenting = false	// or a map of context data
news.content.present = function
	if news.data == null then
		lines = http.get("https://miniscript.org/news/news.dat").splitLines
		news.data = []
		curItem = {}
		for line in lines
			if line == "" then
				if curItem then news.data.push curItem
				curItem = {}
				continue
			end if
			parts = line.split(": ", 2)
			if parts.len < 2 then continue
			curItem[parts[0]] = parts[1]
		end for
		if curItem then news.data.push curItem
	end if
	story = news.data[news.curItemIdx]
	news.date.text = story.date; news.date.present
	news.posCount.text = news.curItemIdx + " / " + news.data.len; news.posCount.present

	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black

	printer = new styledText.BmfPrinter
	printer.x = self.left
	printer.wrapTo = self.left
	printer.wrapAt = self.right
	printer.y = self.top - 20
	printer.font = mediumFont
	gfx.color = color.yellow
	printer.printHTML story.title, self.left
	gfx.color = self.style.textColor; printer.y -= 20
	printer.printHTML story.shortText, self.left; printer.y -= 20
	if story.hasIndex("moreText") then
		printer.printHTML story.moreText, self.left
	end if
end function

return news
