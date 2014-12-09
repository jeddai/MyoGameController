scriptId = 'com.jeddai.outlastController'

--Games it works with:
--Slender
--Outlast
--Surgeon Simulator 2013
--Star Wars: Empire at War

-- Effects

rclick = false
mouse = false

--Regular functions
function leftClick()
  myo.mouse("left","click")
end

function rightClick()
  rclick = true
  myo.mouse("right", "click")
end

function toggleMouse()
  if mouse == true then
    mouse = false
  elseif mouse == false then
    mouse = true
  end
end

--Slender/Outlast functions
function nightVision()
  myo.keyboard("f", "press")
end

--Surgeon Simulator functions
hand = false
function toggleHand()
  if hand == false then
    myo.keyboard("a", "down")
    myo.keyboard("w", "down")
    myo.keyboard("e", "down")
    myo.keyboard("r", "down")
    myo.keyboard("space", "down")
    hand = true
  elseif hand == true then
    myo.keyboard("a", "up")
    myo.keyboard("w", "up")
    myo.keyboard("e", "up")
    myo.keyboard("r", "up")
    myo.keyboard("space", "up")
    hand = false
  end
end

function openHand()
  myo.keyboard("a", "up")
  myo.keyboard("w", "up")
  myo.keyboard("e", "up")
  myo.keyboard("r", "up")
  myo.keyboard("space", "up")
end

function allowRotate()
  if rclick == false then
    myo.mouse("right", "down")
    rclick = true
  elseif rclick == true then
    myo.mouse("right", "up")
    rclick = false
  end
end

function lowerHand()
  myo.mouse("left","down")
end

function raiseHand()
  myo.mouse("left","up")
end

--Empire at War functions
function selectAll()
  myo.keyboard("left_control", "down")
  myo.keyboard("a", "press")
  myo.keyboard("left_control", "up")
end

--normal thingies
function unlock()
  unlocked = true
  extendUnlock()
end

function extendUnlock()
  unlockedSince = myo.getTimeMilliseconds()
end

function onPoseEdge(pose, edge)
  --Slender: The Eight Pages poses
  if activeAppName() == "slender" then
    if pose == "fingersSpread" then
      if edge == "on" then
        nightVision()
      end
    end
    if pose == "waveIn" then
      if edge == "on" then
        leftClick()
      end
    end
    if pose == "fist" then
      if edge == "on" then
        mouse = true
      elseif edge == "off" then
        mouse = false
      end
    end
  end

  --Surgeon Simulator 2013 poses
  if activeAppName() == "surgeonSimulator" then
    if pose == "fist" then
      if edge == "on" then
        toggleHand()
      end
    end
    if pose == "fingersSpread" then
      if edge == "on" then
        allowRotate()
      end
    end
    if pose == "thumbToPinky" then
      if edge == "on" then
        lowerHand()
      elseif edge == "off" then
        raiseHand()
      end
    end
    if pose == "waveOut" then
      if edge == "on" then
        toggleMouse()
      end
    end
  end

  --Empire at War poses
  if activeAppName() == "eaw" then
    if pose == "fist" then
      if edge == "on" then
        myo.mouse("left","down")
      elseif edge == "off" then
        myo.mouse("left","up")
      end
    end
    if pose == "fingersSpread" then
      if edge == "on" then
        myo.mouse("right","down")
      elseif edge == "off" then
        myo.mouse("right","up")
      end
    end
    if pose == "thumbToPinky" then
      if edge == "on" then
        selectAll()
      end
    end
  end

  --Portal 2 poses
  if activeAppName() == "Portal 2" then
    if pose == "fist" then
      if edge == "on" then
        mouse = true
      else
        mouse = false
      end
    end
    if pose == "waveIn" then
      if edge == "on" then
        leftClick()
      end
    end
    if pose == "waveOut" then
      if edge == "on" then
        rightClick()
      end
    end
  end

  --Outlast poses
  if activeAppName() == "outlast" then
    if pose == "fist" then
      if edge == "on" then
        if mouse == true then
          mouse = false
        else
          mouse = true
        end
      end
    end
    if pose == "waveIn" then
      if edge == "on" then
        if myo.getPitch() > (60 * (3.14/180)) then
          myo.debug("pressed f")
          nightVision()
        end
      end
    end
  end
end

function onForegroundWindowChange(app, title)
  -- Here we decide if we want to control the new active app.
  local wantActive = false
  activeApp = ""

  if platform == "MacOS" then
    if app == "unity.Parsec Productions.Slender" then
      wantActive = true
      activeApp = "slender"
      --myo.debug("Slender: The Eight Pages")
    end
    if app == "unity.Bossa Studios.Surgeon Simulator 2013" then
      wantActive = true
      activeApp = "surgeonSimulator"
      --myo.debug("Surgeon Simulator 2013")
    end
    if app == "com.Mojang Specifications.Minecraft.Minecraft" then
      wantActive = true
      activeApp = "minecraft"
      --myo.debug("Minecraft")
    end
    if app == "com.aspyr.empireatwar" then
      wantActive = true
      activeApp = "eaw"
      --myo.debug("Empire At War")
    end
    if app == "portal2_osx" then
      wantActive = true
      activeApp = "Portal 2"
      myo.debug("Portal 2")
    end
  elseif platform == "Windows" then
    -- Powerpoint on Windows
    wantActive = string.match(title, " %- Outlast$")
    activeApp = "outlast"
  end
  return wantActive
end

function onPeriodic()
  myo.controlMouse(mouse)
  if activeAppName() == "outlast" then
    --pulling up the camera
    if myo.getPitch() > (70 * (3.14/180)) and rclick == false then
      myo.debug("right clicked on")
      rightClick()
    elseif myo.getPitch() < (70 * (3.14/180)) and rclick == true and mouse == false then
      myo.debug("right clicked off")
      rightClick()
      rclick = false
    end
  end

  if activeAppName() == "eaw" then
    mouse = true
  end

  if activeAppName() == "Portal 2" then
  end
end

-- Time since last activity before we lock
UNLOCKED_TIMEOUT = 2200

function activeAppName()
  return activeApp
end

function onActiveChange(isActive)
  if not isActive then
    unlocked = false
    myo.controlMouse(false)
  end
end
