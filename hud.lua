local composer = require( "composer" )
local t = loadTable( "settings.json" )
local optionsCoinsText = {
    text= '',
    x= rightMarg-85, 
    y= topMarg+36,
    font= "BebasNeue",
    fontSize=34,
    width= 100,
    align= "center"
}
coinsAnimationFlag = false
function coinsSpriteListener( event )
  if coinsAnimationFlag==false then
    coins:setSequence( "dinamica" )  
    coins:play()
    coinsAnimationFlag=true
    tmrCoins1=timer.performWithDelay( 2500, coinsSpriteListener )
        if tmrCoins2 then
            timer.cancel(tmrCoins2)
        end
  elseif coinsAnimationFlag==true then
     if tmrCoins1 then
            timer.cancel(tmrCoins1)
        end
    coins:setSequence( "estatica" )  
    coins:play()
    coinsAnimationFlag=false
    tmrCoins2=timer.performWithDelay( 10000, coinsSpriteListener )
  end
  return true
end

local function hudCoinsTouch(event)
    if ( event.phase == "ended") then
        if composer.getSceneName("current")~="tienda" then

            local currScene = composer.getSceneName( "current" )
            composer.removeScene( "juegoTOA")
            composer.removeScene( "EndlessH")
            composer.removeScene( "game")
            composer.removeScene( "gamein")
                composer.removeScene( currScene )
                composer.gotoScene( "tienda" )

        end
    end
    return true
end
     hudCoins = widget.newButton{
                defaultFile="assets/hudCoins.png",
                onEvent = hudCoinsTouch,
            }
    hudCoins.x, hudCoins.y = rightMarg-85, topMarg+36
    hudCoins:scale(0.8,0.8)

    coins = display.newSprite( coinsSheet, coinsSequence )
    coins.x, coins.y = rightMarg-37, topMarg+31
    coins:scale( 0.8,0.8)
    timer.performWithDelay( 10000, coinsSpriteListener )
    
    
   -- Animación cuenta monedas totales
    coinsText=display.newText(optionsCoinsText)
    numCoins = t.coins
    duration=t.coins*5+500
    function limitDuration()
        if duration>4000 then
            duration=4000
        end
    end
    limitDuration()

 function showNumCoins(target, value, duration)  
    local mt = {}
    function mt.__index(t, k)
        if k == 'numCoins' then return t._numCoins end
    end
    function mt.__newindex(t, k, value)
        if k == 'numCoins' then
            t._numCoins = value
            target.text = string.format('%0d', value)
        end
    end

    local coinsTable = {_numCoins = 0}
    setmetatable(coinsTable, mt)

    transition.to(coinsTable, {numCoins = value, time = duration, transition = easing.outExpo})
end
------------------------------Poner para animar el marcador de monedas. Si se quiere estatico, cambiar el duration por un valor de 1

--showNumCoins(coinsText, numCoins, duration) 


------------------------------Poner en el scene:destroy()

--package.loaded["hud"] = nil