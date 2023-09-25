script_version('1.7.4')

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
                print('Ñêà÷èâàþ '..decodeJson(response.text)['url']..' â '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('Ñêðèïò îáíîâëåí, ïåðåçàãðóçêà...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('Îøèáêà, íåâîçìîæíî óñòàíîâèòü îáíîâëåíèå, êîä: '..response.status_code, -1)
        end
    end
    return f
end

require 'lib.moonloader'
local imgui = require 'imgui'
local inicfg = require 'inicfg'
local font = renderCreateFont("Brittanica", 8, 5)
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local selected = 1
local colors = {u8"Êðàñíûé", u8"Îðàíæåâûé", u8"Æåëòûé"}
local width = {u8"1.0", u8"2.0", u8"3.0", u8"4.0"}
local colorsobj = {u8"Áåëûé", u8"Êðàñíûé", u8"Îðàíæåâûé", u8"Æåëòûé"}

local mainIni = inicfg.load({
	render = {
	    rklad = false,
	    rzakladka = false,
	    rolen = false,
	    rlen = false,
	    rhlopok = false,
	    rsem = false,
	    rryda = false,
	    rderevo = false,
		rrom = false,
		rdyblon = false,
		rporox = false,
		rdrevecina = false,
		svoiobj1 = false,
		svoiobj2 = false,
	    nazvanie1 = u8'Òåñòèðóåì1',
		nazvanie2 = u8'Òåñòèðóåì2'
    },
    ghetto = {
	rgrove = false,
	rballas = false,
	rrifa = false,
	raztec = false,
	rnw = false,
	rvagos = false,
	},
	settings = {
	combo = 0,
	combo1 = 2,
	combo2 = 0,
	nazvanie3 = u8'mrender'
	}
}, 'MRender')

local rklad = imgui.ImBool(mainIni.render.rklad)
local rzakladka = imgui.ImBool(mainIni.render.rzakladka)
local rolen = imgui.ImBool(mainIni.render.rolen)
local rlen = imgui.ImBool(mainIni.render.rlen)
local rhlopok = imgui.ImBool(mainIni.render.rhlopok)
local rsem = imgui.ImBool(mainIni.render.rsem)
local rryda = imgui.ImBool(mainIni.render.rryda)
local rderevo = imgui.ImBool(mainIni.render.rderevo)
local rdrevecina = imgui.ImBool(mainIni.render.rdrevecina)
local svoiobj1 = imgui.ImBool(mainIni.render.svoiobj1)
local svoiobj2 = imgui.ImBool(mainIni.render.svoiobj2)
local nazvanie1 = imgui.ImBuffer(mainIni.render.nazvanie1, 256)
local nazvanie2 = imgui.ImBuffer(mainIni.render.nazvanie2, 256)
local nazvanie3 = imgui.ImBuffer(mainIni.settings.nazvanie3, 256)

---------------------èâåíò-----------------------------
local rrom = imgui.ImBool(mainIni.render.rrom)
local rdyblon = imgui.ImBool(mainIni.render.rdyblon)
local rporox = imgui.ImBool(mainIni.render.rporox)
------------------------------------------------------
local rgrove = imgui.ImBool(mainIni.ghetto.rgrove)
local rballas = imgui.ImBool(mainIni.ghetto.rballas)
local rrifa = imgui.ImBool(mainIni.ghetto.rrifa)
local raztec = imgui.ImBool(mainIni.ghetto.raztec)
local rnw = imgui.ImBool(mainIni.ghetto.rnw)
local rvagos = imgui.ImBool(mainIni.ghetto.rvagos)
local combo = imgui.ImInt(mainIni.settings.combo)
local combo1 = imgui.ImInt(mainIni.settings.combo1)
local combo2 = imgui.ImInt(mainIni.settings.combo2)


local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()

if not doesFileExist('moonloader/config/MRender.ini') then inicfg.save(mainIni, 'MRender.ini') end

function main()
if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(100) end
    
	local lastver = update():getLastVersion()
    sampAddChatMessage('[MRender - PRO] {D5DEDD}Ñêðèïò çàãðóæåí, âåðñèÿ: '..lastver, 0xFF0000)
	sampAddChatMessage('[MRender - PRO] {D5DEDD}Êîìàíäà: '..mainIni.settings.nazvanie3, 0xFF0000)
    if thisScript().version ~= lastver then
        sampAddChatMessage('Âûøëî îáíîâëåíèå ñêðèïòà ('..thisScript().version..' -> '..lastver..'), ñêà÷àéòå îáíîâëåíèå â IMGUI-îêíå', 0xFF0000)
    end
	sampRegisterChatCommand('/ '..mainIni.settings.nazvanie3, function()
        main_window_state.v = not main_window_state.v

        imgui.Process = main_window_state.v
    end)

    imgui.Process = false
	
	while true do
        wait(0)
		if combo.v == 0 then
			test = '0xFFFF0000' -- red
		    elseif combo.v == 1 then
			    test = '0xFFFFA500' -- orange
		    elseif combo.v == 2 then
			    test = '0xFFFFFF00' -- yellow
		end
		if combo1.v == 0 then
			test1 = '1.0'
		    elseif combo1.v == 1 then
			    test1 = '2.0'
		    elseif combo1.v == 2 then
			    test1 = '3.0' --
			elseif combo1.v == 3 then
				test1 = '4.0'
		end
		if combo2.v == 0 then
			test2 = '0xFFFFFFFF'
		    elseif combo2.v == 1 then
			    test2 = '0xFFFF0000' -- red
		    elseif combo2.v == 2 then
			    test2 = '0xFFFFA500' -- orange
		    elseif combo2.v == 3 then
			    test2 = '0xFFFFFF00' -- yellow
		end
		for k, v in pairs(getAllObjects()) do
			local num = getObjectModel(v)
			if isObjectOnScreen(v) and rklad.v then
				if num == 1271 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					renderFontDrawText(font, ' Ñóíäóê', wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
			if isObjectOnScreen(v) and rsem.v then
				if num == 859 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					renderFontDrawText(font, ' Ñåìåíà', wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
            if isObjectOnScreen(v) and rryda.v then
				if num == 854 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					renderFontDrawText(font, ' Ðóäà', wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
            if isObjectOnScreen(v) and rolen.v then
				if num == 19315 then
					local res, px, py, pz = getObjectCoordinates(v)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(getCharCoordinates(PLAYER_PED))
					renderFontDrawText(font, ' Îëåíü', wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
		end
		for id = 0, 2048 do
            local result = sampIs3dTextDefined( id )
            if result then
                local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById( id )
				
                if rzakladka.v and text:find("Çàêëàäêà") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,' Çàêëàäêà', wposX, wposY,test2)
                    end
                end
				if rzakladka.v and text:find("Çàêëàäêà") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rlen.v and text:find("Ë¸í") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
                    end
                end
				if rlen.v and text:find("Ë¸í") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rhlopok.v and text:find("Õëîïîê") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
                    end
                end
				if rhlopok.v and text:find("Õëîïîê") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				--äåðåâüÿ
				if rderevo.v and text:find("Íàæìèòå ALT, ÷òîáû ñîáðàòü ïëîäû") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
                    end
                end
				if rderevo.v and text:find("Íàæìèòå ALT, ÷òîáû ñîáðàòü ïëîäû") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rrom.v and text:find("Áóòûëêà ðîìà") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,'Áóòûëêà ðîìà', wposX, wposY,test2)
                    end
                end
				if rrom.v and text:find("Áóòûëêà ðîìà") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rdyblon.v and text:find("Ïèðàòñêèé äóáëîí") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,'Ïèðàòñêèé äóáëîí', wposX, wposY,test2)
                    end
                end
				if rdyblon.v and text:find("Ïèðàòñêèé äóáëîí") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rdyblon.v and text:find("ßùèê ñ ïîðîõîì") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,'ßùèê ñ ïîðîõîì', wposX, wposY,test2)
                    end
                end
				if rdyblon.v and text:find("ßùèê ñ ïîðîõîì") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rdrevecina.v and text:find("Äåðåâî âûñøåãî êà÷åñòâà") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,'Äåðåâî âûñ.êà÷åñòâà', wposX, wposY,test2)
                    end
                end
				if rdrevecina.v and text:find("Äåðåâî âûñøåãî êà÷åñòâà") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end

				--áàíäû
				if rgrove.v and text:find("Grove Street") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
                    end
                end
				if rgrove.v and text:find("Grove Street") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rballas.v and text:find("East Side Ballas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rballas.v and text:find("East Side Ballas") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
			    if rrifa.v and text:find("The Rifa") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rrifa.v and text:find("The Rifa") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				 if raztec.v and text:find("Varrios Los Aztecas") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if raztec.v and text:find("Varrios Los Aztecas") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rnw.v and text:find("Night Wolves") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rnw.v and text:find("Night Wolves") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if rvagos.v and text:find("Los Santos Vagos") then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rvagos.v and text:find("Los Santos Vagos") then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				-------------------------------Ñâîè obj-----------------------------------
				if svoiobj1.v and text:find(u8:decode(nazvanie1.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if svoiobj1.v and text:find(u8:decode(nazvanie1.v)) then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
                    end
                end
				if svoiobj2.v and text:find(u8:decode(nazvanie2.v)) then 
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if svoiobj2.v and text:find(u8:decode(nazvanie2.v)) then 
                    if isPointOnScreen (posX,posY,posZ,1) then
                        wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                        x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                        x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test) 
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
	imgui.SetNextWindowSize(imgui.ImVec2(550, 370), imgui.Cond.FirstUseEver)
	imgui.Begin(u8'MRender v1.7.4(Òåñòîâàÿ âåðñèÿ, ñ êàñòîìèçàöèåé)', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild('##menu', imgui.ImVec2(150, 340), true)
	imgui.CenterText(u8'Ìåíþ')
	if imgui.Button(u8'Ðåíäåð', imgui.ImVec2(135, 58)) then selected = 1 end
	imgui.Separator()
	if imgui.Button(u8'Ðåíäåð ãðàôôèòè', imgui.ImVec2(135, 58)) then selected = 2 end
	imgui.Separator()
	if imgui.Button(u8'Èíôîðìàöèÿ', imgui.ImVec2(135, 58)) then selected = 3 end
	imgui.Separator()
    if imgui.Button(u8'Êàñòîìèçàöèÿ', imgui.ImVec2(135, 58)) then selected = 4 end
	imgui.Separator()
	if imgui.Button(u8'Àâòî-îáíîâëåíèå', imgui.ImVec2(135, 35)) then selected = 5 end
	imgui.EndChild()
	imgui.SameLine()
	if selected == 1 then
		imgui.BeginChild('##render', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'Îñíîâíîå')
		imgui.Separator()
		imgui.Checkbox(u8"Ëåí", rlen)
		imgui.Checkbox(u8"Õëîïîê", rhlopok)
		imgui.Checkbox(u8"Êëàäû", rklad)
		imgui.Checkbox(u8"Çàêëàäêè", rzakladka)
		imgui.Checkbox(u8"Ñåìåíà", rsem)
		imgui.Checkbox(u8"Îëåíè", rolen)
		imgui.Checkbox(u8"Ðóäà", rryda)
		imgui.Checkbox(u8"Äåðåâüÿ(ïëîäû)", rderevo)
		imgui.Checkbox(u8"Äåðåâüÿ âûñøåãî êà÷åñòâà", rdrevecina)
		imgui.Separator()
		imgui.CenterText(u8'Ñâîè îáúåêòû')
		imgui.Checkbox(u8"Ñâîé îáúåêò ¹1", svoiobj1)
		imgui.Text(u8'Íàçâàíèå äëÿ obj ¹1')
		imgui.SameLine()
		imgui.InputText(u8'##Íàçâàíèå îáúåêòà äëÿ ðåíäåðà ¹1', nazvanie1)
		imgui.Checkbox(u8"Ñâîé îáúåêò ¹2", svoiobj2)
		imgui.Text(u8'Íàçâàíèå äëÿ obj ¹2')
		imgui.SameLine()
		imgui.InputText(u8'##Íàçâàíèå îáúåêòà äëÿ ðåíäåðà ¹2', nazvanie2)
		save1()
		imgui.Separator()
		imgui.CenterText(u8'Èâåíòû(Äåíü Òðóäà 2023)')
		imgui.Separator()
		imgui.Checkbox(u8"Áóòûëêà ðîìà", rrom)
		imgui.Checkbox(u8"Ïèðàòñêèé äóáëîí", rdyblon)
		imgui.Checkbox(u8"ßùèê ñ ïîðîõîì", rporox)
		save1()
		imgui.EndChild()
	end
	if selected == 2 then
		imgui.BeginChild('##getto', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'Ðåíäåð ãðàôôèòè')
		imgui.Separator()
		imgui.Checkbox(u8"Ãðóâ", rgrove)
	    imgui.Checkbox(u8"Áàëëàñ", rballas)
	    imgui.Checkbox(u8"Ðèôà", rrifa)
	    imgui.Checkbox(u8"Àöòåê", raztec)
	    imgui.Checkbox(u8"Íî÷íûå âîëêè", rnw)
	    imgui.Checkbox(u8"Âàãîñ", rvagos)
		save1()
		imgui.EndChild()
	end
	if selected == 3 then
		imgui.BeginChild('##information', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'Èíôîðìàöèÿ')
		imgui.Separator()
		imgui.Text(u8'Àâòîð: Tomato')
		imgui.Text(u8'Çàïóñòèòü ñêðèïò: /mrender')
		imgui.Separator()
        imgui.Text(u8'ÂÍÈÌÀÍÈÅ!!!')
		imgui.Text(u8'Ïðè èñïîëüçîâàíèè â ðåäêèõ ñëó÷àÿõ')
		imgui.Text(u8'Âîçìîæíû ïîòåðè fps äî 10%')
		imgui.Text(u8'Ýòî ñâÿçàíî ñ îáíîâëåíèåì êàñòîìèçàöèè')
		imgui.Text(u8'Òàêæå ïðè îòêðûòèè ñêðèïòà âîçìîæíû ïîòåðè fps äî 3%')
		imgui.EndChild()
	end
    if selected == 4 then
		imgui.BeginChild('##settings', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'Êàñòîìèçàöèÿ')
        imgui.Separator()
		if imgui.Combo(u8'Öâåò ëèíèè', combo, colors) then
		    mainIni.settings.combo = combo.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.Combo(u8'Øèðèíà ëèíèè', combo1, width) then
		    mainIni.settings.combo1 = combo1.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.Combo(u8'Öâåò íàçâàíèÿ(obj)', combo2, colorsobj) then
		    mainIni.settings.combo2 = combo2.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.InputText(u8'##Íàçâàíèå ñêðèïòà', nazvanie3) then
			mainIni.settings.nazvanie3 = nazvanie3.v
			inicfg.save(mainIni, "MRender.ini")
		end
		imgui.Text(u8'Óêàçûâàéòå êîìàíäó àêòèâàöèè áåç / (!!!)')
		imgui.Text(u8'Ïîñëå ââîäà íîâîé êîìàíäû,ïåðåçàãðóçèòå ñêðèïòû èëè ïåðåçàéäèòå â èãðó')
		imgui.EndChild()
	end
	if selected == 5 then
		imgui.BeginChild('##update', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'Àâòî-îáíîâëåíèå')
        imgui.Separator()
		if imgui.Button(u8'Çàãðóçèòü îáíîâëåíèå', imgui.ImVec2(150,50)) then
			local lastver = update():getLastVersion()
            if thisScript().version ~= lastver then
			sampAddChatMessage('[AUTOUPDATE] {D5DEDD}Äîñòóïíî îáíîâëåíèå! Ñêà÷èâàþ...',0xFF0000)
            update():download()
            end
			if thisScript().version == lastver then
                sampAddChatMessage('[AUTOUPDATE] {D5DEDD}Ó âàñ óæå àêòóàëüíàÿ âåðñèÿ!',0xFF0000)
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


function save1()
    mainIni.render.rklad = rklad.v
	mainIni.render.rzakladka = rzakladka.v
	mainIni.render.rolen = rolen.v
	mainIni.render.rlen = rlen.v
	mainIni.render.rhlopok = rhlopok.v
	mainIni.render.rsem = rsem.v
	mainIni.render.rryda = rryda.v
    mainIni.render.rderevo = rderevo.v
	mainIni.ghetto.rgrove = rgrove.v
	mainIni.ghetto.rballas =  rballas.v
	mainIni.ghetto.rrifa = rrifa.v
	mainIni.ghetto.raztec =  raztec.v
	mainIni.ghetto.rnw = rnw.v
	mainIni.ghetto.rvagos =  rvagos.v
	mainIni.render.rrom =  rrom.v
	mainIni.render.rdyblon =  rdyblon.v
	mainIni.render.rporox =  rporox.v
	mainIni.render.rdrevecina =  rdrevecina.v
	mainIni.render.svoiobj1 =  svoiobj1.v
	mainIni.render.svoiobj2 =  svoiobj2.v
	mainIni.render.nazvanie1 = nazvanie1.v
	mainIni.render.nazvanie2 = nazvanie2.v
    inicfg.save(mainIni, "MRender.ini")
end

function imgui.CenterText(text)
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(text)
	imgui.SetCursorPosX(width/2-size.x/2)
	imgui.Text(text)
end

function imgui.Link(label, description)
	local width = imgui.GetWindowWidth()
	local size = imgui.CalcTextSize(label)
	local p = imgui.GetCursorScreenPos()
	local p2 = imgui.GetCursorPos()
	local result = imgui.InvisibleButton(label, imgui.ImVec2(width-16, size.y))
	imgui.SetCursorPos(p2)
	imgui.SetCursorPosX(width/2-size.x/2)
	if imgui.IsItemHovered() then
		if description then
			imgui.BeginTooltip()
			imgui.PushTextWrapPos(500)
			imgui.TextUnformatted(description)
			imgui.PopTextWrapPos()
			imgui.EndTooltip()
		end
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
		imgui.GetWindowDrawList():AddLine(imgui.ImVec2(width/2-size.x/2+p.x-8, p.y + size.y), imgui.ImVec2(width/2-size.x/2+p.x-8 + size.x, p.y + size.y), imgui.GetColorU32(imgui.GetStyle().Colors[imgui.Col.CheckMark]))
	else
		imgui.TextColored(imgui.GetStyle().Colors[imgui.Col.CheckMark], label)
	end
	return result
end
