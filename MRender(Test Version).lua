script_version('1.9.3')

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
local vkey = require'vkeys'
samp = require 'samp.events'
local inicfg = require 'inicfg'
local fa = require 'fAwesome5'
local ffi = require("ffi")
local font = renderCreateFont("Tahoma", 9, 5) --[[Шрифт]]
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local selected = 1
imgui.Spinner = require('imgui_addons').Spinner
local colors = {u8"Красный", u8"Оранжевый", u8"Желтый", u8"Белый(Standart)",u8"Аква"}
local width = {u8"1.0", u8"2.0", u8"3.0(Standart)", u8"4.0", u8"5.0"}
--local colorObj = '0xFFFFFFFF' --[[Укажите формат цвета , например 0xFFFFFFFF - белый цвет]]
--local linewidth = '3.5' --[[Рекомендованные значения от 3.0 до 5.0]]
local razdel = nil

local mainIni = inicfg.load({
	render = {
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
		myObjectThree = false,
		myObjectFour = false,
		myObjectFive = false,
		rclothes = false,
		rmushroom = false,
		rgift = false,
		rore_underground = false,
	    nameObjectOne = u8'Object name',
		nameObjectTwo = u8'Object name',
		nameObjectThree = u8'Object name',
		nameObjectFour = u8"Object name",
		nameObjectFive = u8"Object name",
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
		clue = false,
		distanceoff = false,
		create_object_text = 0,
		selected_item = 0,
		combo = 3,
	    combo1 = 2,
	}
}, 'MRender')

local rbookmark = imgui.ImBool(mainIni.render.rbookmark)
local rdeer = imgui.ImBool(mainIni.render.rdeer)
local rflax = imgui.ImBool(mainIni.render.rflax)
local rcotton = imgui.ImBool(mainIni.render.rcotton)
local rseeds = imgui.ImBool(mainIni.render.rseeds)
local rore = imgui.ImBool(mainIni.render.rore)
local rore_underground = imgui.ImBool(mainIni.render.rore_underground)
local rtree = imgui.ImBool(mainIni.render.rtree)
local rwood = imgui.ImBool(mainIni.render.rwood)
local myObjectOne = imgui.ImBool(mainIni.render.myObjectOne)
local myObjectTwo = imgui.ImBool(mainIni.render.myObjectTwo)
local myObjectThree = imgui.ImBool(mainIni.render.myObjectThree)
local myObjectFour = imgui.ImBool(mainIni.render.myObjectFour)
local myObjectFive = imgui.ImBool(mainIni.render.myObjectFive)
local rclothes = imgui.ImBool(mainIni.render.rclothes)
local rmushroom = imgui.ImBool(mainIni.render.rmushroom)
local rgift= imgui.ImBool(mainIni.render.rgift)
local nameObjectOne = imgui.ImBuffer(mainIni.render.nameObjectOne, 256)
local nameObjectTwo = imgui.ImBuffer(mainIni.render.nameObjectTwo, 256)
local nameObjectThree = imgui.ImBuffer(mainIni.render.nameObjectThree, 256)
local nameObjectFour = imgui.ImBuffer(mainIni.render.nameObjectFour, 256)
local nameObjectFive = imgui.ImBuffer(mainIni.render.nameObjectFive, 256)
local scriptName = imgui.ImBuffer(mainIni.settings.scriptName, 256)
local clue = imgui.ImBool(mainIni.settings.clue)
local distanceoff = imgui.ImBool(mainIni.settings.distanceoff)
local selected_item = imgui.ImInt(mainIni.settings.selected_item)
local create_object_text = imgui.ImInt(mainIni.settings.create_object_text)
local combo = imgui.ImInt(mainIni.settings.combo)
local combo1 = imgui.ImInt(mainIni.settings.combo1)

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
local fa_font = nil
--event_one = true
local fa_glyph_ranges = imgui.ImGlyphRanges({ fa.min_range, fa.max_range })

if not doesFileExist('moonloader/config/MRender.ini') then inicfg.save(mainIni, 'MRender.ini') end

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
	local lastver = update():getLastVersion()
    sampAddChatMessage('[MRender] {D5DEDD}Скрипт загружен, версия: '..lastver, 0xFF0000)
	sampAddChatMessage('[MRender] {D5DEDD}Команда: /'..mainIni.settings.scriptName, 0xFF0000)
	sampAddChatMessage('[MRender] {D5DEDD}Команда для удаления/cброса конфига: /removeconfig', 0xFF0000)
    if thisScript().version ~= lastver then
		update_popup = 1
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
		if combo.v == 0 then
			colorObj = '0xFFFF0000' -- Red color
		    elseif combo.v == 1 then
			    colorObj = '0xFFFFA500' -- Orange color
		    elseif combo.v == 2 then
			    colorObj = '0xFFFFFF00' -- Yellow color
			elseif combo.v == 3 then
			    colorObj = '0xFFFFFFFF' -- White color
			elseif combo.v == 4 then
			    colorObj = '0xFF00FFFF' -- Blue color
		end
		if combo1.v == 0 then
			linewidth = '1.0'
		    elseif combo1.v == 1 then
			    linewidth = '2.0'
		    elseif combo1.v == 2 then
			    linewidth = '3.0'
			elseif combo1.v == 3 then
				linewidth = '4.0'
			elseif combo1.v == 4 then
				linewidth = '5.0'
		end
		if selected_item.v == 0 then
			if isKeyJustPressed(vkey.VK_F12) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if selected_item.v == 1 then
			if isKeyJustPressed(vkey.VK_F2) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if selected_item.v == 2 then
			if isKeyJustPressed(vkey.VK_F3) then
				main_window_state.v = not main_window_state.v
				imgui.Process = main_window_state.v
			end
		end
		if rdeer.v then
		    for k,v in ipairs(getAllChars()) do
			    if select(2, sampGetPlayerIdByCharHandle(v)) == -1 and v ~= PLAYER_PED and getCharModel(v) == 3150 then
			        local xp, yp, zp = getCharCoordinates(PLAYER_PED)
				    local px, py, pz = getCharCoordinates(v)
				    local wX, wY = convert3DCoordsToScreen(px, py, pz)
				    local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
				    distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
				    if isPointOnScreen(px, py, pz, 0) then
					    if distanceoff.v then
							renderFontDrawText(font, ' Олень', wX, wY , colorObj)
						elseif distanceoff.v == false then
				            renderFontDrawText(font, ' Олень\n Дистанция: '..distance, wX, wY , colorObj)
						end
				        renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				    end
			    end
		    end
	    end
		if rseeds.v or rore.v or rclothes.v or rgift.v then -- new test functions optimization
		    for k, v in pairs(getAllObjects()) do
			    local num = getObjectModel(v)
			if isObjectOnScreen(v) and rseeds.v then
				if num == 859 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					distance = string.format("%.0fм", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					if distanceoff.v then
						renderFontDrawText(font, ' Семена', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, ' Семена\n Дистанция: '..distance, wX, wY , colorObj)
					end
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
					if distanceoff.v then
						renderFontDrawText(font, ' Руда', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, ' Руда\n Дистанция: '..distance, wX, wY , colorObj)
					end
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
					if distanceoff.v then
						renderFontDrawText(font, ' Рваная одежда', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, ' Рваная одежда\n Дистанция: '..distance, wX, wY , colorObj)
					end
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
					if distanceoff.v then
						renderFontDrawText(font, ' Подарок', wX, wY , colorObj)
					elseif distanceoff.v == false then
						renderFontDrawText(font, ' Подарок\n Дистанция: '..distance, wX, wY , colorObj)
					end
					renderDrawLine(myPosX, myPosY, wX, wY, linewidth, colorObj)
				end
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
						if distanceoff.v == false then
							renderFontDrawText(font, texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font, text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
						    renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
						if distanceoff.v == false then
                            renderFontDrawText(font,' Дерево выс.качества\n Дистанция: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' Дерево выс.качества', wposX, wposY, colorObj)
						end
					end
                end
				if rore_underground.v and text:find("Место добычи ресурсов") then
					local resX, resY = getScreenResolution()
					local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
					if isPointOnScreen (posX,posY,posZ,1) then
					    renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj)
					end
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						if distanceoff.v == false then
                            renderFontDrawText(font,' Руда(Подземная)\n Дистанция: '..distance, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,' Руда(Подземная)', wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
			    if rrifa.v and text:find("Банда: {ff6666}{6666FF}The Rifa") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rvagos.v and text:find("Банда: {ff6666}{D1DB1C}Los Santos Vagos") and text:find('Повторно закрасить можно через:') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,textograffiti, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if rpaint.v and text:find("Банда: {ff6666}{00FFE2}Varrios Los Aztecas") and not text:find('Повторно закрасить можно через:') or rpaint.v and text:find("Банда: {ff6666}{D1DB1C}Los Santos Vagos") and not text:find('Повторно закрасить можно через:') or rpaint.v and text:find("Банда: {ff6666}{A87878}Night Wolves") and not text:find('Повторно закрасить можно через:') or  rpaint.v and text:find("Банда: {ff6666}{6666FF}The Rifa") and not text:find('Повторно закрасить можно через:') or  rpaint.v and text:find("Банда: {ff6666}{CC00CC}East Side Ballas") and not text:find('Повторно закрасить можно через:') or rpaint.v and text:find("Банда: {ff6666}{009327}Grove Street") and not text:find('Повторно закрасить можно через:') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
						if distanceoff.v == false then
                            renderFontDrawText(font,' Гриб\n Дистанция: '..distance, wposX, wposY, colorObj)
                        elseif distanceoff.v then
							renderFontDrawText(font,' Гриб', wposX, wposY, colorObj)
						end
					end
                end
				-------------------------------свои obj-----------------------------------
				if myObjectOne.v and text:find(u8:decode(nameObjectOne.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
						renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
					end
					if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
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
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if myObjectThree.v and text:find(u8:decode(nameObjectThree.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if myObjectFour.v and text:find(u8:decode(nameObjectFour.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
				if myObjectFive.v and text:find(u8:decode(nameObjectFive.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					if isPointOnScreen (posX,posY,posZ,1) then
                        renderDrawLine(x10, y10, wposX, wposY, linewidth, colorObj) 
                    end
                    if wposX < resX and wposY < resY and isPointOnScreen(posX,posY,posZ,1) then
                        if distanceoff.v == false then
							renderFontDrawText(font,texto, wposX, wposY, colorObj)
						elseif distanceoff.v then
							renderFontDrawText(font,text, wposX, wposY, colorObj)
						end
                    end
                end
			end
		end
        if main_window_state.v == false then
            imgui.Process = false
        end
	end
end

function key_selection()
	if selected_item.v == 0 then
	    imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F12")
	elseif selected_item.v == 1 then
		imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F2")
    elseif selected_item.v == 2 then
		imgui.Text(u8"Настройки применены.Для активации скрипта вы выбрали клавишу F3")
	end
	imgui.SameLine()
	imgui.Spinner("##spinner", 7, 3, imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.ButtonHovered]))
end

function imgui.OnDrawFrame()
	if not main_window_state.v then imgui.Process = false end
	if main_window_state.v then
	imgui.SetNextWindowPos(imgui.ImVec2(sw/2, sh/2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
	imgui.SetNextWindowSize(imgui.ImVec2(650, 470), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'MRender v1.9.3(Autumm Update, с автообновлением)', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild('##menu', imgui.ImVec2(150, 440), true)
	imgui.CenterText(u8'Меню')
	if imgui.Button(fa.ICON_FA_BOOK_READER .. u8' Рендер', imgui.ImVec2(135, 78)) then selected = 1 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_SPRAY_CAN .. u8' Рендер граффити', imgui.ImVec2(135, 78)) then selected = 2 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_INFO_CIRCLE .. u8' Информация', imgui.ImVec2(135, 78)) then selected = 3 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_USER_COG .. u8' Кастомизация', imgui.ImVec2(135, 78)) then selected = 4 end
	imgui.Separator()
	if imgui.Button(fa.ICON_FA_WRENCH .. u8' Авто-обновление', imgui.ImVec2(135, 55)) then selected = 5 end
	imgui.EndChild()
	imgui.SameLine()
	if selected == 1 then
		imgui.BeginChild('##render', imgui.ImVec2(480, 440), true)
		imgui.CenterText(u8'Основное')
		imgui.Separator()
		imgui.Checkbox(u8"Лен", rflax)
		if clue.v == false then
			imgui.Hint(u8"Активирует рендер на ресурс лен\nПримечание: Рендер срабатывает на грядки льна у домов",0) 
		end
		imgui.Checkbox(u8"Хлопок", rcotton)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на ресурс хлопок\nПримечание: Рендер срабатывает на грядки хлопка у домов",0)
		end
		imgui.Checkbox(u8"Закладки", rbookmark)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на закладки",0)
	    end
		imgui.Checkbox(u8"Семена*", rseeds)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на семена наркотиков",0)
	    end
		imgui.Checkbox(u8"Олени", rdeer)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на оленей\nПримечание: Возможны баги из за новых кастомных оленей",0)
	    end
		imgui.Checkbox(u8"Руда*", rore)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на руду\nПримечание: Рендер не показывает название руд",0)
	    end
		imgui.Checkbox(u8"Деревья с плодами", rtree)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на деревья",0)
	    end
		imgui.Checkbox(u8"Деревья высшего качества", rwood)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на деревья высшего качества",0)
	    end
		imgui.Checkbox(u8"Рваная одежда*", rclothes)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на рваную одежду",0)
	    end
		imgui.Checkbox(u8"Грибы", rmushroom)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на грибы",0)
	    end
		imgui.Checkbox(u8"Подарки(По карте)*", rgift)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на подарки, которые спавнятся по карте",0)
	    end
		imgui.Checkbox(u8"Руда(Подземная шахта)", rore_underground)
		if clue.v == false then
		    imgui.Hint(u8"Активирует рендер на руду, которая находится в подземной шахте",0)
	    end
		imgui.Text(u8'Все функции с пометкой * действуют на производительность(Потеря FPS)\nРешение в разработке.')
		imgui.Separator()
		imgui.CenterText(u8'Свои объекты(триггеры)')
		imgui.Text(u8"Выбери ниже кнопки по которым будет выбираться триггер")
		if imgui.Button(u8"По тексту") then 
			razdel = 1
		end
		imgui.SameLine()
		if imgui.Button(u8"по ID(временно недоступно!)") then
			razdel = 2
		end
		if razdel == 1 then
		    imgui.Checkbox(u8"Свой объект №1", myObjectOne)
		    if clue.v == false then
		    imgui.Hint(u8"Данный чекбокс позволяет добавить свой кастомный триггер на надпись\nПримечание: Учитывайте регистр надписи",0)
	        end
		    imgui.Text(u8'Название для obj №1')
		    imgui.SameLine()
		    imgui.InputText(u8'##Название объекта для рендера №1', nameObjectOne)
		    if clue.v == false then
				imgui.Hint(u8"Напишите сюда текст, на который хотите сделать триггер\nПримечание: Если надпись ALT- то так и пишите ALT",0)
			end
		    imgui.Checkbox(u8"Свой объект №2", myObjectTwo)
		    if clue.v == false then
		        imgui.Hint(u8"Данный чекбокс позволяет добавить свой кастомный триггер на надпись\nПримечание: Учитывайте регистр надписи",0)
	        end
			if create_object_text.v == 0 then
				imgui.SameLine()
			    if imgui.Button(fa.ICON_FA_PLUS .."", imgui.ImVec2(20, 18)) then
			        create_object_text.v = 1
			    end
		    end
			imgui.Text(u8'Название для obj №2')
		    imgui.SameLine()
		    imgui.InputText(u8'##Название объекта для рендера №2', nameObjectTwo)
			if create_object_text.v == 1 then
				imgui.Checkbox(u8"Свой объект №3", myObjectThree)
		        if clue.v == false then
		            imgui.Hint(u8"Данный чекбокс позволяет добавить свой кастомный триггер на надпись\nПримечание: Учитывайте регистр надписи",0)
	            end
				imgui.Text(u8'Название для obj №3')
		        imgui.SameLine()
		        imgui.InputText(u8'##Название объекта для рендера №3', nameObjectThree)
				imgui.Checkbox(u8"Свой объект №4", myObjectFour)
		        if clue.v == false then
		            imgui.Hint(u8"Данный чекбокс позволяет добавить свой кастомный триггер на надпись\nПримечание: Учитывайте регистр надписи",0)
	            end
				imgui.Text(u8'Название для obj №4')
		        imgui.SameLine()
		        imgui.InputText(u8'##Название объекта для рендера №4', nameObjectFour)
				imgui.Checkbox(u8"Свой объект №5", myObjectFive)
		        if clue.v == false then
		            imgui.Hint(u8"Данный чекбокс позволяет добавить свой кастомный триггер на надпись\nПримечание: Учитывайте регистр надписи",0)
	            end
				if create_object_text.v == 1 then
					imgui.SameLine()
					if imgui.Button(u8"Скрыть до №2") then
						create_object_text.v = 0
					end
				end
				imgui.Text(u8'Название для obj №5')
		        imgui.SameLine()
		        imgui.InputText(u8'##Название объекта для рендера №5', nameObjectFive)
			end
	    end
		saving()
		imgui.EndChild()
	elseif selected == 2 then
		imgui.BeginChild('##getto', imgui.ImVec2(480, 440), true)
		imgui.CenterText(u8'Рендер граффити')
		imgui.Separator()
		if imgui.Checkbox(u8"Грув", rgrove) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"Баллас", rballas) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"Рифа", rrifa) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"Ацтек", raztec) then
		    if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"Ночные волки", rNightWolves) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
	    if imgui.Checkbox(u8"Вагос", rvagos) then
			if rpaint.v then
			    rpaint.v = false
			end
		end
		if imgui.Checkbox(u8"Показать только те граффити, которые доступны для закраски", rpaint) then
			rgrove.v = false
			rballas.v = false
			raztec.v = false
			rNightWolves.v = false
			rvagos.v = false
			rrifa.v = false--[[Система блокировки лишних граффити]]
		end
		saving()
		imgui.EndChild()
    elseif selected == 3 then
		imgui.BeginChild('##information', imgui.ImVec2(480, 440), true)
		imgui.CenterText(u8'Информация')
		imgui.Separator()
		imgui.Link(u8'https://www.blast.hk/members/449591/', u8'Профиль автора на BlastHack')
		imgui.Link('https://t.me/rendersamp', u8'Telegram-канал скрипта')
		imgui.Link('https://t.me/tomatoBH', u8'Telegram автора скрипта')
		imgui.Text(u8'Запустить скрипт: /'..scriptName.v)
		imgui.Text(u8'--[] Если скрипт начал неправильно работать - сбросите конфиг')
		imgui.Text(u8'--[] Для сброса конфига - используйте команду: /removeconfig')
		imgui.Text(u8'--[] или кнопку в разделе Кастомизация')
		imgui.Separator()
        imgui.Text(u8'ВНИМАНИЕ!!!')
		imgui.Text(u8'При использовании некоторый функций возможны потери FPS до 15%.')
		imgui.Text(u8'Также при открытии скрипта возможны потери fps до 7%')
		imgui.Text(u8'-- При нестабильности работы скрипта обратитесь к автору')
		imgui.EndChild()
	elseif selected == 4 then
		imgui.BeginChild('##settings', imgui.ImVec2(480, 440), true)
		imgui.CenterText(u8'Кастомизация')
        imgui.Separator()
		if imgui.Combo(u8'Цвет текстов рендера', combo, colors) then
		    mainIni.settings.combo = combo.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.Combo(u8'Ширина линии трейсера', combo1, width) then
		    mainIni.settings.combo1 = combo1.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		imgui.PushItemWidth(150)
		if imgui.InputText(u8'##Название скрипта', scriptName) then
			mainIni.settings.scriptName = scriptName.v
			inicfg.save(mainIni, "MRender.ini")
		end
		imgui.PopItemWidth()
		imgui.SameLine()
		imgui.Text(u8'Команда активации скрипта')
		imgui.Text(u8'Указывайте команду активации без / (!!!)')
		imgui.Text(u8'После ввода новой команды - перезагрузите скрипты')
		imgui.Text(u8'или перезайдите в игру')
		imgui.Separator()
		if imgui.Button(u8'Выгрузить скрипт', imgui.ImVec2(115,36)) then
			thisScript():unload()
		end
		if clue.v == false then
		    imgui.Hint(u8"Данная кнопка выгружает скрипт из игры, вы не сможете им пользоваться.\nПримечание: Чтобы скрипт вернулся, перезагрузите скрипты или перезайдите в игру.",0)
	    end
		imgui.SameLine()
		if imgui.Button(u8'Сбросить конфиг', imgui.ImVec2(115,36)) then
			os.remove('moonloader\\config\\MRender.ini')
		    thisScript():reload()
		    sampAddChatMessage('[MRender] {D5DEDD}Конфиг скрипта сброшен!', 0xFF0000)
		end
		if clue.v == false then
		    imgui.Hint(u8"Данная кнопка очищает все ваши настройки(ini file)\nПримечание: При нажатии на данную кнопку вы потеряете все свои настройки!",0)
	    end
		imgui.Separator()
		if imgui.Checkbox(u8"Скрыть подсказки", clue) then
			mainIni.settings.clue = clue.v
			inicfg.save(mainIni, "MRender.ini")
		end
		if imgui.Checkbox(u8"Скрыть отображение дистанции", distanceoff) then
			mainIni.settings.distanceoff = distanceoff.v
			inicfg.save(mainIni, "MRender.ini")
		end
		imgui.PushItemWidth(120)
		if imgui.Combo(u8'Активация скрипта(клавиша)', selected_item, {'F12', 'F2', 'F3'}, 4) then
			if selected_item.v == 0 or selected_item.v == 1 or selected_item.v == 2 then
				lua_thread.create(function()
					key = true
					wait(6000)
					key = false
			    end)
			end
			mainIni.settings.selected_item = selected_item.v
			inicfg.save(mainIni, "MRender.ini")
		end
		if key then
			key_selection()
		end
        imgui.PopItemWidth()
		imgui.CenterText(u8'SOON...NEW FUNCTIONS...')
		imgui.EndChild()
	elseif selected == 5 then
		if update_popup == 1 then
		    imgui.OpenPopup(u8'Доступно обновление')
		    if imgui.BeginPopupModal(u8'Доступно обновление', imgui.WindowFlags.NoResize) then
			    imgui.SetWindowSize(imgui.ImVec2(250, 130))
			    if imgui.Button(u8'Обновить', imgui.ImVec2(234,50)) then
					local lastver = update():getLastVersion()
					if thisScript().version ~= lastver then
						update():download()
						update_popup = 2
					end
				end
			    if imgui.Button(u8'Обновить позже!', imgui.ImVec2(234, 24)) then
				    imgui.CloseCurrentPopup()
					selected = 1
			    end
				imgui.Link('https://t.me/rendersamp', u8'Telegram-канал скрипта')
		    end
		    imgui.EndPopup()
	    end
		imgui.BeginChild('##update', imgui.ImVec2(480, 440), true)
		imgui.CenterText(u8'Авто-обновление')
        imgui.Separator()
		imgui.CenterText(u8'Изменения версии: (v1.9.3)')
		imgui.Text(u8'- Удалены рендеры на клады и пиксельный кристалл, в связи с неактуально\nстью.')
		imgui.EndChild()
    end
	imgui.End()
    end
end

function apply_custom_style()

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
 
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end
apply_custom_style()

function saving()
	mainIni.render.rbookmark = rbookmark.v
	mainIni.render.rgift = rgift.v
	mainIni.render.rdeer = rdeer.v
	mainIni.render.rflax = rflax.v
	mainIni.render.rcotton = rcotton.v
	mainIni.render.rseeds = rseeds.v
	mainIni.render.rore = rore.v
	mainIni.render.rore_underground = rore_underground.v
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
	mainIni.render.myObjectThree =  myObjectThree.v
	mainIni.render.myObjectFour =  myObjectFour.v
	mainIni.render.myObjectFive =  myObjectFive.v
	mainIni.render.nameObjectOne = nameObjectOne.v
	mainIni.render.nameObjectTwo = nameObjectTwo.v
	mainIni.render.nameObjectThree = nameObjectThree.v
	mainIni.render.nameObjectFour = nameObjectFour.v
	mainIni.render.nameObjectFive = nameObjectFive.v
	mainIni.settings.selected_item = selected_item.v
	mainIni.settings.create_object_text_3 = create_object_text.v
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

function imgui.BeforeDrawFrame()
    if fa_font == nil then
        local font_config = imgui.ImFontConfig() -- to use 'imgui.ImFontConfig.new()' on error
        font_config.MergeMode = true

        fa_font = imgui.GetIO().Fonts:AddFontFromFileTTF('moonloader/resource/fonts/fa-solid-900.ttf', 13.0, font_config, fa_glyph_ranges)
    end
end

function imgui.Hint(text, delay, action)
    if imgui.IsItemHovered() then
        if go_hint == nil then go_hint = os.clock() + (delay and delay or 0.0) end
        local alpha = (os.clock() - go_hint) * 5
        if os.clock() >= go_hint then
            imgui.PushStyleVar(imgui.StyleVar.WindowPadding, imgui.ImVec2(10, 10))
            imgui.PushStyleVar(imgui.StyleVar.Alpha, (alpha <= 1.0 and alpha or 1.0))
                imgui.PushStyleColor(imgui.Col.PopupBg, imgui.ImVec4(0.11, 0.11, 0.11, 1.00))
                    imgui.BeginTooltip()
                    imgui.PushTextWrapPos(450)
                    imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.ButtonHovered], u8'Подсказка:')
                    imgui.TextUnformatted(text)
                    if action ~= nil then
                        imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.TextDisabled], '\n '..action)
                    end
                    if not imgui.IsItemVisible() and imgui.GetStyle().Alpha == 1.0 then go_hint = nil end
                    imgui.PopTextWrapPos()
                    imgui.EndTooltip()
                imgui.PopStyleColor()
            imgui.PopStyleVar(2)
        end
    end
end --[[Система плавных подсказок by HarlyCloud]]

function samp.onCreate3DText(id, color, position, distance, testLOS, attachedPlayerId, attachedVehicleId, text)
    sampCreate3dTextEx(id, text, color, position.x, position.y, position.z, distance, testLOS, attachedPlayerId, attachedVehicleId)
end
function samp.onRemove3DTextLabel(textLabelId)
    sampDestroy3dText(textLabelId)
end --[Fix by XRLM (https://www.blast.hk/members/449015/)]]