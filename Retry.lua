local scene = composer.newScene()
local t = loadTable( "settings.json" )

local background
local Gameover
local notas


local moregamesSheet = graphics.newImageSheet( "assets4/moregames.png", { width=206, height=91, numFrames=2} )    
local moregamesSequence = {
            { name = "inicial", start=1, count=2, time=1500, }}



 

-- -------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    

FondoMusica2= audio.loadSound( "assets4/rithm.ogg")

fondoRetry=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY, display.actualContentWidth, 800 )
fondoRetry:setFillColor( 0.533, 0.933, 0.996 )

retryStarburst=display.newImage( sceneGroup, "assets4/retryStarburst.png", display.contentCenterX,topMarg+150) 
retryStarburst:scale(2,2)
retryStarburst.rotation = -45
local reverse = 1

local function retryStarburstRot()
    if ( reverse == 0 ) then
        reverse = 1
        transition.to( retryStarburst, { rotation=-90, time=1000, transition=easing.inOutCubic } )
    else
        reverse = 0
        transition.to( retryStarburst, { rotation=90, time=1000, transition=easing.inOutCubic } )
    end
end
timer.performWithDelay( 600, retryStarburstRot, 1 )
timer.performWithDelay( 1700, retryStarburstRot, 1 )

--fondoRetryInferior=display.newRect( sceneGroup, display.contentCenterX, display.contentCenterY+display.actualContentHeight/4, display.actualContentWidth, 20 )
--fondoRetryInferior:setFillColor( 0.533, 0.933, 0.996 )

if highScoreFlag  then --si la flag situada en guardaPuntos() de Endless.lua esta activada ponemos new highscore
      scoreImage=display.newImage( sceneGroup, "assets4/highScore.png", display.contentCenterX,topMarg+70)   
else

scoreImage=display.newImage( sceneGroup, "assets4/Score.png", display.contentCenterX,topMarg+60) 
end

--highscoreImage=display.newImage( sceneGroup, "highScore.png", display.contentCenterX,topMarg+60) 
--Retry

    minusButtonPressed = false
    


  
--Moregames

moregames=display.newSprite(sceneGroup,moregamesSheet,moregamesSequence)
moregames:play()

moregames.x= cx
moregames.y=cy+195
moregames:scale(1,1)

function moregames:tap()
showMoreGamesAd()
end
moregames:addEventListener("tap",moregames)


end

-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

if ( phase == "will" ) then 

retryNube=display.newImage(sceneGroup,"assets4/retryNube.png", display.contentCenterX, bottomMarg-33)
retryNube:scale(1.65,1.65)

retryNubeD=display.newImage(sceneGroup,"assets4/retryNube.png", cx, cy-70)
retryNubeD:scale(0.75,1.2)

local ActualScore = display.newText(sceneGroup,user.actualScore, display.contentCenterX, topMarg+180, "telo", 207)
ActualScore:setFillColor(.992, .31, .02)

local HighScore = display.newEmbossedText(sceneGroup,user.highScore,cx+60, display.contentCenterY-75, "telo", 50)
HighScore:setFillColor(1,0,0)

local best=display.newImage(sceneGroup,"assets4/best.png", cx-50, display.contentCenterY-75)
best:scale(0.83,0.83)

function reducirnube()

transition.moveTo( HighScore, {x=cx+70, time=2000} )
transition.moveTo( best, {x=cx-40,time=2000} )

transition.scaleTo( retryNubeD, { xScale=0.95, yScale=0.95, time=2000 } )
transition.moveTo( retryNubeD, {x=cx+10,time=2000} )

Nubetimer1=timer.performWithDelay( 2000, aumentarnube)
end
function aumentarnube()

transition.moveTo( HighScore, {x=cx+50, time=2000} )
transition.moveTo( best, {x=cx-60, time=2000} )

transition.scaleTo( retryNubeD, { xScale=1, yScale=1, time=2000 } )
transition.moveTo( retryNubeD, {x=cx-10, time=2000} )

Nubetimer2=timer.performWithDelay( 2000, reducirnube)
end
reducirnube()


function soundBtnlistener(event)
    local phase = event.phase 
    
    if "ended" == phase then   

      display.remove(soundBtn) 
      soundBtn = nil
      
      if t.music == true then
        t.music = false
        audio.setVolume(0)
        soundBtn = widget.newButton{
            defaultFile="assets/sound_off.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
      else
        t.music = true
        audio.setVolume(1)
        soundBtn = widget.newButton{
            defaultFile="assets/sound_on.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
      end
      
    saveTable(t, "settings.json")
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
    soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25

    end
end

if t.music==true then
        soundBtn = widget.newButton{
            defaultFile="assets/sound_on.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
    else 
        soundBtn = widget.newButton{
            defaultFile="assets/sound_off.png",
            height = 50,
            width = 50,
            onEvent = soundBtnlistener
        }
    end

     
    soundBtn.anchorX , soundBtn.anchorY = 1, 1 
    soundBtn.x , soundBtn.y = display.contentWidth - 25, display.contentHeight - 25


sceneGroup:insert(soundBtn)

local function goHome()
       
   composer.removeScene( "EndlessH")
   composer.removeScene( "Retry")
       composer.gotoScene( "menu2" )
      destroyHUD()
end

local homeBtn = widget.newButton
        {
            defaultFile="assets/back.png",
            overFile="assets/back_2.png",
            onRelease = goHome,
            parent = group,
        }

        homeBtn.x = leftMarg+50
        homeBtn.y = bottomMarg-50
        
        
        sceneGroup:insert( homeBtn )







     elseif ( phase == "did" ) then  
    mayShowAd()
    checkLocks(t)
    if unlockedFlag==false then
FondoMusica2Channel= audio.play(FondoMusica2, {loops=(-1)})
    end

    local function handleRetryEvent( event )

        if ( "ended" == event.phase )and (minusButtonPressed == false)  then
                    
                   destroyHUD()
                    composer.removeScene("EndlessH")
                    audio.stop(FondoMusica2Channel)
                   audio.rewind(FondoMusicaChannel)
                    composer.removeScene("Retry")
                    local options = {
                        effect = "slideUp",
                        time = 800,}
                        analytics.logEvent( "RetryGameSession" , { game="DoorsSession" } )
                        composer.gotoScene( "EndlessH",options)
                        
                    
                    minusButtonPressed = true
                     audio.play( CheersAudio )
                     nubeFlag=true
                      --transition.to( retryNube, {alpha=0,y=-60,time=100 })
        end

    end

     
    -- Image sheet options and declaration
    local options = {
        width = 206,
        height = 91,
        numFrames = 2,
    }
    local RetrySheet = graphics.newImageSheet("assets4/botonRetry.png", options )

    -- Create the widget
    local Retry = widget.newButton

    {
        sheet = RetrySheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = handleRetryEvent
    }


sceneGroup:insert(Retry)
Retry.x = display.contentCenterX
Retry.y = cy+80
Retry:scale(1.38,1.38)      
    local hud = require( "hud" )
    sceneGroup:insert( hudCoins)
    sceneGroup:insert( coins)
    sceneGroup:insert( coinsText)
    showNumCoins(coinsText, numCoins, duration) 
end
end
-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
      
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    display.remove( soundBtn )
    audio.stop( FondoMusica2Channel )
    destroyHUD()
    
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene