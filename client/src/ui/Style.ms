Style = {}
Style._name = "Style"
Style.spacing = 2
Style.buttonHeight = 32
Style.buttonWidth = 120
Style.topBarHeight = function; return self.buttonHeight; end function
Style.bottomBarHeight = function; return self.topBarHeight; end function
Style.leftBarWidth = 120
Style.rightBarWidth = function; return self.leftBarWidth; end function
Style.swoopExtra = [64,48]

// colors reference: https://www.thelcars.com/colors.php
Style.color = "#FFEBDE"			// fallback color
Style.blockColor = function; return self.color; end function
Style.infoBlockColor = function; return self.blockColor; end function
Style.buttonColor = "#FFAA00"
Style.swoopColor = function; return self.infoBlockColor; end function
Style.textColor = function; return self.infoBlockColor; end function

return Style
