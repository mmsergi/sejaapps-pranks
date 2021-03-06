local group

local scene = composer.newScene()

local t = loadTable( "settings.json" )

local function goBack()
	composer.removeScene( "menu" )
	composer.removeScene( "tienda" )
	composer.gotoScene( "menu" )
end

local function goMinigames()
	composer.removeScene( "menu2" )
	composer.removeScene( "tienda" )
	analytics.logEvent( "MiniGamesFromShop" )
	composer.gotoScene( "menu2" )
end

local function installAd()
	analytics.logEvent( "InstallAdClick" )
	system.openURL( "https://play.google.com/store/apps/details?id=com.masah.adventuresinside" )
  	t.coins = t.coins + 30
  	t.install = false
    saveTable(t, "settings.json")
    coinsText.text = t.coins
    installBtn:setEnabled( false )
    timer.performWithDelay( 1500,function () installBtn:removeSelf( ) end)
    checkLocks(t)
end

local function freeGame()
    analytics.logEvent( "ShopFreeGameClick" )
    AdBuddiz.showAd()
end

local function likeFb()
	analytics.logEvent( "likeFacebookClick" )
	system.openURL( "https://www.facebook.com/sejaapps" )
	t.coins = t.coins + 5
	t.facebook = false
    saveTable(t, "settings.json")
    coinsText.text = t.coins
    checkLocks(t)
	likeBtn:removeSelf( )
	likeBtn:setEnabled( false )
    timer.performWithDelay( 1500,function () likeBtn:removeSelf( ) end)
end

function scene:create( event )
	group = self.view

	checkLocks(t)

	background = display.newImage( group, "assets/shopbckg.png", cx, cy )
	background.alpha = 0.9

	miniBtn = widget.newButton{

	    defaultFile = "assets/minis.png",
	    onRelease = goMinigames,

	}
	miniBtn.width, miniBtn.height = 282, 96
	miniBtn.x = display.contentWidth/2 
	miniBtn.y = 250

	if t.install then

		installBtn = widget.newButton{

		    defaultFile = "assets/installBtn.png",
		    onRelease = installAd
		}
		installBtn.x = display.contentWidth/2 
		installBtn.y = 500

		group:insert(installBtn)

	end

	gameBtn = widget.newButton{

	    defaultFile = "assets/freegame.png",
	    onRelease = freeGame
	}
	gameBtn.x = display.contentWidth/2 
	gameBtn.y = 360

	if t.facebook then

		likeBtn = widget.newButton{

		    defaultFile = "assets/like.png",
		    onRelease = likeFb
		}
		likeBtn.x = display.contentWidth/2 + 100
		likeBtn.y = 730

		group:insert(likeBtn)
	end

	backBtn = widget.newButton
	{
	    defaultFile="assets/home.png",
	    overFile="assets/home_2.png",
	    onRelease = goBack,
	    height = 70,
		width = 70,
	}

	backBtn.x = leftMarg+50
	backBtn.y = bottomMarg-50

	local hud = require( "hud" )

    group:insert(hudCoins)
    group:insert(coins)
    group:insert(coinsText)
	showNumCoins(coinsText, numCoins, 1)

	group:insert(miniBtn)
	
	group:insert(gameBtn)
	
	group:insert(backBtn)

end

function scene:show( event )
	group = self.view

end

function scene:hide( event )
	group = self.view
	
end

function scene:destroy( event )
	group = self.view
	ads:setCurrentProvider("admob")
	destroyHUD()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene