// Sample panel
news = Panel.make(root, 168, 0, 960-168, 640)
news.title = "Sample"
news.style.color = "#ff44aa"
news.style.buttonColor = "#ff7700"
news.style.textColor = "#ffeecc"
news.header = Frame.make(news, null, news.top - 108)
news.header.configure false, true, true, false
news.clearOnInput = false
Block.make news.header.leftPanel
Block.make news.header.bottomPanel
title = InfoBlock.make("SAMPLE", news.header,
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

Gap.make news.main.leftPanel
news.main.leftPanel.layout

news.content = Panel.make(news.main, news.main.topPanel.left, 0, 940 - news.main.topPanel.left, news.main.topPanel.bottom - 16)
news.presenting = false	// or a map of context data
news.content.present = function
	gfx.fillRect self.left, self.bottom, self.width, self.height, color.black

	printer = new styledText.BmfPrinter
	printer.x = self.left
	printer.wrapTo = self.left
	printer.wrapAt = self.right
	printer.y = self.top - 20
	printer.font = mediumFont
	gfx.color = color.yellow
	printer.printHTML "This is my title.", self.left
	gfx.color = self.style.textColor; printer.y -= 20
	printer.printHTML "This is my story.", self.left; printer.y -= 20
end function

return news
