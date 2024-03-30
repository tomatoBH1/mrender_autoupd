script_version('1.8.4')

function update()
    local raw = 'https://raw.githubusercontent.com/tomatoBH1/mrender_autoupd/main/update.json'
    local dlstatus = require('moonloader').download_status
    local requests = require('requests')
    local f = {}
    function f:getLastVersion()
        local response = requests.get(raw)
        if response.status_code == 200 then
            return decodeJson(response.text)['last']
        else
            return 'UNKNOWN'
        end
    end
    function f:download()
        local response = requests.get(raw)
        if response.status_code == 200 then
            downloadUrlToFile(decodeJson(response.text)['url'], thisScript().path, function (id, status, p1, p2)
                print('Скачиваю '..decodeJson(response.text)['url']..' в '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('Скрипт обновлен, перезагрузка...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('Ошибка, невозможно установить обновление, код: '..response.status_code, -1)
        end
    end
    return f
end

require 'lib.moonloader'
local imgui = require 'imgui'
samp = require 'samp.events'
local inicfg = require 'inicfg'
local font = renderCreateFont("Tahoma", 9, 5) --[[Шрифт]]
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local selected = 1
--[[settings colors and lines]]
local colorObj = '0xFFFFFFFF' --[[Укажите формат цвета , например 0xFFFFFFFF - белый цвет]]
local linewidth = '3.5' --[[Рекомендованные значения от 3.0 до 5.0]]
--[[settings colors and lines]]

local mainIni = inicfg.load({
	render = {
	    rtreasure = false,
	    rbookmark = false,
	    rdeer = false,
	    rflax = false,
	    rcotton = false,
	    rseeds = false,
	    rore = false,
	    rtree = false,
		rwood = false,
		myObjectOne = false,
		myObjectTwo = false,
		rclothes = false,
		rmushroom = false,
		rgift = false,
	    nameObjectOne = u8'Object name',
		nameObjectTwo = u8'Object name'
    },
    ghetto = {
	    rgrove = false,
	    rballas = false,
	    rrifa = false,
	    raztec = false,
	    rNightWolves = false,
	    rvagos = false,
		rpaint = false
	},
	settings = {
	    scriptName = u8'mrender',
	}
}, 'MRender')

local rtreasure = imgui.ImBool(mainIni.render.rtreasure)
local rbookmark = imgui.ImBool(mainIni.render.rbookmark)
local rdeer = imgui.ImBool(mainIni.render.rdeer)
local rflax = imgui.ImBool(mainIni.render.rflax)
local rcotton = imgui.ImBool(mainIni.render.rcotton)
local rseeds = imgui.ImBool(mainIni.render.rseeds)
local rore = imgui.ImBool(mainIni.render.rore)
local rtree = imgui.ImBool(mainIni.render.rtree)
local rwood = imgui.ImBool(mainIni.render.rwood)
local myObjectOne = imgui.ImBool(mainIni.render.myObjectOne)
local myObjectTwo = imgui.ImBool(mainIni.render.myObjectTwo)
local rclothes = imgui.ImBool(mainIni.render.rclothes)
local rmushroom = imgui.ImBool(mainIni.render.rmushroom)
local rgift= imgui.ImBool(mainIni.render.rgift)
local nameObjectOne = imgui.ImBuffer(mainIni.render.nameObjectOne, 256)
local nameObjectTwo = imgui.ImBuffer(mainIni.render.nameObjectTwo, 256)
local scriptName = imgui.ImBuffer(mainIni.settings.scriptName, 256)

------------------------------------------------------
local rgrove = imgui.ImBool(mainIni.ghetto.rgrove)
local rballas = imgui.ImBool(mainIni.ghetto.rballas)
local rrifa = imgui.ImBool(mainIni.ghetto.rrifa)
local raztec = imgui.ImBool(mainIni.ghetto.raztec)
local rNightWolves = imgui.ImBool(mainIni.ghetto.rNightWolves)
local rvagos = imgui.ImBool(mainIni.ghetto.rvagos)
local rpaint = imgui.ImBool(mainIni.ghetto.rpaint)


local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()

if not doesFileExist('moonloader/config/MRender.ini') then inicfg.save(mainIni, 'MRender.ini') end

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
	local lastver = update():getLastVersion()
    sampAddChatMessage('[MRender] {D5DEDD}Скрипт загружен, версия: '..lastver, 0xFF0000)
	sampAddChatMessage('[MRender] {D5DEDD}Команда: /'..mainIni.settings.scriptName, 0xFF0000)
	sampAddChatMessage('[MRender] {D5DEDD}Команда для удаления/cброса конфига: /removeconfig', 0xFF0000)
    if thisScript().version ~= lastver then
        sampAddChatMessage('Вышло обновление скрипта ('..thisScript().version..' -> '..lastver..'), скачайте обновление в IMGUI-окне', 0xFF0000)
    end
	sampRegisterChatCommand('removeconfig', function()
        os.remove('moonloader\\config\\MRender.ini')
		thisScript():reload()
		sampAddChatMessage('[MRender] {D5DEDD}Конфиг скрипта сброшен!', 0xFF0000)
    end)
	sampRegisterChatCommand(mainIni.settings.scriptName, function()
        main_window_state.v = not main_window_state.v

        imgui.Process = main_window_state.v
    end)

    imgui.Process = false
	
	while true do
        wait(0)

		if rdeer.v then
		    for k,v in ipairs(getAllChars()) do
			    if select(2, sampGetPlayerIdByCharHandle(v)) == -1 and v ~= PLAYER_PED and getCharModel(v) == 3150 then
			        local xp, yp, zp = getCharCoordinates(PLAYER_PED)
				    local px, py, pz = getCharCoordinates(v)
				    local wX, wY = convert3DCoordsToScreen(px, py, pz)
				    local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
				    distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
				    if isPointOnScreen(px, py, pz, 0) then
				        renderFontDrawText(font, ' Олень\n Дистанция: '..distance, wX, wY , colorObj)
				        renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				    end
			    end
		    end
	    end
		for k, v in pairs(getAllObjects()) do
			local num = getObjectModel(v)
			if isObjectOnScreen(v) and rtreasure.v then
				if num == 2680 then
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					if getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp) > 32 then
					    renderFontDrawText(font, ' Клад(Возможно фейк)\n Дистанция: '..distance, wX, wY , colorObj)
				    elseif getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp) < 32 then
						renderFontDrawText(font, ' Клад\n Дистанция: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
			if isObjectOnScreen(v) and rseeds.v then
				if num == 859 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, ' Семена\n Дистанция: '..distance, wX, wY , colorObj)
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
            if isObjectOnScreen(v) and rore.v then
				if num == 854 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, ' Руда\n Дистанция: '..distance, wX, wY , colorObj)
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
			if isObjectOnScreen(v) and rclothes.v then
				if num == 18893 or num == 2844 or num == 2819 or num == 18919 or num == 18974 or num == 18946 or num == 2705 or num == 2706 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, ' Рваная одежда\n Дистанция: '..distance, wX, wY , colorObj)
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
			if isObjectOnScreen(v) and rgift.v then
				if num == 19054 or num == 19055 or num == 19056 or num == 19057 or num == 19058 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, ' Подарок\n Дистанция: '..distance, wX, wY , colorObj)
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
			end
		end
		for id = 0, 2048 do
            local result = sampIs3dTextDefined( id )
            if result then
                local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById( id )
				distance = string.format("%.0fм", getDistanceBetweenCoords3d(posX, posY, posZ,x2,y2,z2))
				local textograffiti = text..'\n\n         - (Дистанция: ' ..distance..') -'
				local texto = text..'\n - (Дистанция: ' ..distance..') -'
                if rbookmark.v and text:find("Закладка") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        renderFontDrawText(font,' Закладка\n Дистанция: '..distance, wposX, wposY, colorObj)
                    end
                end
				if rflax.v and text:find("Лён") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        renderFontDrawText(font,texto, wposX, wposY, colorObj) 
                    end
                end
				if rcotton.v and text:find("Хлопок") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        renderFontDrawText(font,texto, wposX, wposY, colorObj)
                    end
                end
				--деревья
				if rtree.v and text:find("Кокосовое дерево") or rtree.v and text:find("Сливовое дерево") or rtree.v and text:find("Яблочное дерево") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,texto, wposX, wposY, colorObj)
                    end
                end
				if rwood.v and text:find("Дерево высшего качества") then
					local resX, resY = getScreenResolution()
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					if isPointOnScreen (posX,posY,posZ,1) then
					    renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,' Дерево выс.качества\n Дистанция: '..distance, wposX, wposY, colorObj)
                    end
                end
				--банды
				if rgrove.v and text:find("Банда: {ff6666}{009327}Grove Street") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
				if rballas.v and text:find("Банда: {ff6666}{CC00CC}East Side Ballas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
						renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
			    if rrifa.v and text:find("Банда: {ff6666}{6666FF}The Rifa")  then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
				if raztec.v and text:find("Банда: {ff6666}{00FFE2}Varrios Los Aztecas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
				if rNightWolves.v and text:find("Банда: {ff6666}{A87878}Night Wolves") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
				if rvagos.v and text:find("Банда: {ff6666}{D1DB1C}Los Santos Vagos") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
                    end
                end
				if rpaint.v and text:find("Можно закрасить!") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,texto, wposX, wposY, colorObj)
                    end
                end
				if rmushroom.v and text:find("Срезать гриб") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        renderFontDrawText(font,' Гриб\n Дистанция: '..distance, wposX, wposY, colorObj)
                    end
                end
				-------------------------------Свои obj-----------------------------------
				if myObjectOne.v and text:find(u8:decode(nameObjectOne.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
						renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,texto, wposX, wposY, colorObj)
                    end
                end
				if myObjectTwo.v and text:find(u8:decode(nameObjectTwo.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,texto, wposX, wposY, colorObj)
                    end
                end
			end
		end
        if main_window_state.v == false then
            imgui.Process = false
        end
	end
end

function imgui.OnDrawFrame()
	if not main_window_state.v then imgui.Process = false end
	if main_window_state.v then
	imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(610, 435), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'MRender v1.8.4(Тестовая версия, с автообновлением)', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild('##menu', imgui.ImVec2(150, 405), true)
	imgui.CenterText(u8'Меню')
	if imgui.Button(u8'Рендер', imgui.ImVec2(135, 72)) then selected = 1 end
	imgui.Separator()
	if imgui.Button(u8'Рендер граффити', imgui.ImVec2(135, 72)) then selected = 2 end
	imgui.Separator()
	if imgui.Button(u8'Информация', imgui.ImVec2(135, 72)) then selected = 3 end
	imgui.Separator()
	if imgui.Button(u8'Кастомизация', imgui.ImVec2(135, 72)) then selected = 4 end
	imgui.Separator()
	if imgui.Button(u8'Авто-обновление', imgui.ImVec2(135, 45)) then selected = 5 end
	imgui.EndChild()
	imgui.SameLine()
	if selected == 1 then
		imgui.BeginChild('##render', imgui.ImVec2(440, 405), true)
		imgui.CenterText(u8'Основное')
		imgui.Separator()
		imgui.Checkbox(u8"Лен", rflax)
		imgui.Checkbox(u8"Хлопок", rcotton)
		imgui.Checkbox(u8"Клады", rtreasure)
		imgui.Checkbox(u8"Закладки", rbookmark)
		imgui.Checkbox(u8"Семена", rseeds)
		imgui.Checkbox(u8"[NEW!] Олени", rdeer)
		imgui.Checkbox(u8"Руда", rore)
		imgui.Checkbox(u8"Деревья с плодами", rtree)
		imgui.Checkbox(u8"Деревья высшего качества", rwood)
		imgui.Checkbox(u8"Рваная одежда", rclothes)
		imgui.Checkbox(u8"Грибы", rmushroom)
		imgui.Checkbox(u8"[NEW!] Подарки", rgift)
		imgui.Separator()
		imgui.CenterText(u8'Свои объекты')
		imgui.Checkbox(u8"Свой объект №1", myObjectOne)
		imgui.Text(u8'Название для obj №1')
		imgui.SameLine()
		imgui.InputText(u8'##Название объекта для рендера №1', nameObjectOne)
		imgui.Checkbox(u8"Свой объект №2", myObjectTwo)
		imgui.Text(u8'Название для obj №2')
		imgui.SameLine()
		imgui.InputText(u8'##Название объекта для рендера №2', nameObjectTwo)
		saving()
		imgui.EndChild()
    elseif selected == 2 then
		imgui.BeginChild('##getto', imgui.ImVec2(440, 405), true)
		imgui.CenterText(u8'Рендер граффити')
		imgui.Separator()
		imgui.Checkbox(u8"Грув", rgrove)
	    imgui.Checkbox(u8"Баллас", rballas)
	    imgui.Checkbox(u8"Рифа", rrifa)
	    imgui.Checkbox(u8"Ацтек", raztec)
	    imgui.Checkbox(u8"Ночные волки", rNightWolves)
	    imgui.Checkbox(u8"Вагос", rvagos)
		imgui.Checkbox(u8"[Временно не работает] Показать только граффити которые можно закрасить", rpaint)
		saving()
		imgui.EndChild()
    elseif selected == 3 then
		imgui.BeginChild('##information', imgui.ImVec2(440, 405), true)
		imgui.CenterText(u8'Информация')
		imgui.Separator()
		imgui.Link(u8'https://www.blast.hk/members/449591/', u8'Профиль автора на BlastHack')
		imgui.Link('https://t.me/rendersamp', u8'Telegram-канал скрипта')
		imgui.Text(u8'Запустить скрипт: /'..scriptName.v)
		imgui.Text(u8'--[] Если скрипт начал неправильно работать - сбросите конфиг')
		imgui.Text(u8'--[] Для сброса конфига - используйте команду: /removeconfig')
		imgui.Separator()
        imgui.Text(u8'ВНИМАНИЕ!!!')
		imgui.Text(u8'При использовании возможны потери fps до 18%')
		imgui.Text(u8'Это связано с обновлением кастомизации')
		imgui.Text(u8'Также при открытии скрипта возможны потери fps до 7%')
		imgui.EndChild()
	elseif selected == 4 then
		imgui.BeginChild('##settings', imgui.ImVec2(440, 405), true)
		imgui.CenterText(u8'Кастомизация')
        imgui.Separator()
		if imgui.InputText(u8'##Название скрипта', scriptName) then
			mainIni.settings.scriptName = scriptName.v
			inicfg.save(mainIni, "MRender.ini")
		end
		imgui.Text(u8'Указывайте команду активации без / (!!!)')
		imgui.Text(u8'После ввода новой команды,перезагрузите скрипты')
		imgui.Text(u8'или перезайдите в игру')
		imgui.Separator()
		if imgui.Button(u8'Выгрузить скрипт', imgui.ImVec2(120,40)) then
			thisScript():unload()
		end
		imgui.Text(u8'[]-- Чтобы скрипт вернулся в игру, перезагрузите скрипты')
		imgui.Text(u8'[]-- Или перезайдите в игру')
		imgui.Separator()
		imgui.EndChild()
	elseif selected == 5 then
		imgui.BeginChild('##update', imgui.ImVec2(440, 405), true)
		imgui.CenterText(u8'Авто-обновление')
        imgui.Separator()
		if imgui.Button(u8'Загрузить обновление', imgui.ImVec2(140,50)) then
			local lastver = update():getLastVersion()
            if thisScript().version ~= lastver then
			sampAddChatMessage('[AUTOUPDATE] {D5DEDD}Доступно обновление! Скачиваю...',0xFF0000)
            update():download()
            end
			if thisScript().version == lastver then
                sampAddChatMessage('[AUTOUPDATE] {D5DEDD}У вас уже актуальная версия!',0xFF0000)
			end
		end
		imgui.EndChild()
	end
	imgui.End()
	end
end

function theme()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2

	style.WindowPadding = ImVec2(8, 8)
	style.WindowRounding = 5.0
	style.ChildWindowRounding = 5.0
	style.FramePadding = ImVec2(2, 2)
	style.FrameRounding = 5.0
	style.ItemSpacing = ImVec2(5, 5)
	style.ItemInnerSpacing = ImVec2(5, 5)
	style.TouchExtraPadding = ImVec2(0, 0)
	style.IndentSpacing = 5.0
	style.ScrollbarSize = 13.0
	style.ScrollbarRounding = 5.0
	style.GrabMinSize = 20.0
	style.GrabRounding = 5.0
	style.WindowTitleAlign = ImVec2(0.5, 0.5)
	style.ButtonTextAlign = ImVec2(0.5, 0.5)

	colors[clr.Text]                    = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.TextDisabled]            = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.WindowBg]                = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ChildWindowBg]           = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.PopupBg]                 = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.Border]                  = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.BorderShadow]            = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.FrameBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.FrameBgHovered]          = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.FrameBgActive]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBgCollapsed]        = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.TitleBgActive]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.MenuBarBg]               = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ScrollbarBg]             = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ScrollbarGrab]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ScrollbarGrabHovered]    = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ScrollbarGrabActive]     = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ComboBg]                 = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.CheckMark]               = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrab]              = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.SliderGrabActive]        = ImVec4(1.00, 1.00, 1.00, 1.00)
	colors[clr.Button]                  = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ButtonHovered]           = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ButtonActive]            = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.Header]                  = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.HeaderHovered]           = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.HeaderActive]            = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ResizeGrip]              = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.ResizeGripHovered]       = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.ResizeGripActive]        = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.CloseButton]             = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.CloseButtonHovered]      = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.CloseButtonActive]       = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.PlotLines]               = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.PlotLinesHovered]        = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.PlotHistogram]           = ImVec4(0.13, 0.13, 0.13, 1.00)
	colors[clr.PlotHistogramHovered]    = ImVec4(0.20, 0.20, 0.20, 1.00)
	colors[clr.TextSelectedBg]          = ImVec4(0.05, 0.05, 0.05, 1.00)
	colors[clr.ModalWindowDarkening]    = ImVec4(1.00, 1.00, 1.00, 1.00)
end
theme()


function saving()
    mainIni.render.rtreasure = rtreasure.v
	mainIni.render.rbookmark = rbookmark.v
	mainIni.render.rgift = rgift.v
	mainIni.render.rdeer = rdeer.v
	mainIni.render.rflax = rflax.v
	mainIni.render.rcotton = rcotton.v
	mainIni.render.rseeds = rseeds.v
	mainIni.render.rore = rore.v
    mainIni.render.rtree = rtree.v
	mainIni.render.rclothes = rclothes.v
	mainIni.render.rmushroom = rmushroom.v
	mainIni.ghetto.rgrove = rgrove.v
	mainIni.ghetto.rballas =  rballas.v
	mainIni.ghetto.rrifa = rrifa.v
	mainIni.ghetto.raztec =  raztec.v
	mainIni.ghetto.rNightWolves = rNightWolves.v
	mainIni.ghetto.rvagos =  rvagos.v
	mainIni.ghetto.rpaint =  rpaint.v
	mainIni.render.rwood =  rwood.v
	mainIni.render.myObjectOne =  myObjectOne.v
	mainIni.render.myObjectTwo =  myObjectTwo.v
	mainIni.render.nameObjectOne = nameObjectOne.v
	mainIni.render.nameObjectTwo = nameObjectTwo.v
    inicfg.save(mainIni, "MRender.ini")
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width/2-size.x/2)
	imgui.Text(text)
end

function imgui.Link(link,name,myfunc)
    myfunc = type(name) == 'boolean' and name or myfunc or false
    name = type(name) == 'string' and name or type(name) == 'boolean' and link or link
    local size = imgui.CalcTextSize(name)
    local p = imgui.GetCursorScreenPos()
    local p2 = imgui.GetCursorPos()
    local resultBtn = imgui.InvisibleButton('##'..link..name, size)
    if resultBtn then
        if not myfunc then
            os.execute('explorer '..link)
        end
    end
    imgui.SetCursorPos(p2)
    if imgui.IsItemHovered() then
        imgui.TextColored(imgui.ImVec4(0, 0.5, 1, 1), name)
        imgui.GetWindowDrawList():AddLine(imgui.ImVec2(p.x, p.y + size.y), imgui.ImVec2(p.x + size.x, p.y + size.y), imgui.GetColorU32(imgui.ImVec4(0, 0.5, 1, 1)))
    else
        imgui.TextColored(imgui.ImVec4(0, 0.3, 0.8, 1), name)
    end
    return resultBtn
end

function imgui.CustomButton(gg, color, colorHovered, colorActive, size)
    local clr = imgui.Col
    imgui.PushStyleColor(clr.Button, color)
    imgui.PushStyleColor(clr.ButtonHovered, colorHovered)
    imgui.PushStyleColor(clr.ButtonActive, colorActive)
    if not size then size = imgui.ImVec2(0, 0) end
    local result = imgui.Button(gg, size)
    imgui.PopStyleColor(3)
    return result
end

--[[function graffiti() -- дорабатывается
	if rpaint.v then
		rvagos.v = false
		rgrove.v = false
        rballas.v = false
        rrifa.v = false
        raztec.v = false
        rNightWolves.v = false
	end
end--]]