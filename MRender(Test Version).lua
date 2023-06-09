script_version('1.7.3')

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
                print('�������� '..decodeJson(response.text)['url']..' � '..thisScript().path)
                if status == dlstatus.STATUSEX_ENDDOWNLOAD then
                    sampAddChatMessage('������ ��������, ������������...', -1)
                    thisScript():reload()
                end
            end)
        else
            sampAddChatMessage('������, ���������� ���������� ����������, ���: '..response.status_code, -1)
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
local colors = {u8"�������", u8"���������", u8"������"}
local width = {u8"1.0", u8"2.0", u8"3.0", u8"4.0"}
local colorsobj = {u8"�����", u8"�������", u8"���������", u8"������"}

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
		rdrevecina = false,
		svoiobj1 = false,
		svoiobj2 = false,
	    nazvanie1 = u8'���������1',
		nazvanie2 = u8'���������2'
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
	combo2 = 0
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
    sampAddChatMessage('[MRender] {D5DEDD}������ ��������, ������: '..lastver, 0xFF0000)
	sampAddChatMessage('[MRender] {D5DEDD}�������: /mrender ', 0xFF0000)
    if thisScript().version ~= lastver then
        sampAddChatMessage('����� ���������� ������� ('..thisScript().version..' -> '..lastver..'), �������� ���������� � IMGUI-����', 0xFF0000)
    end
	sampRegisterChatCommand("mrender", function()
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
				if num == 1271 then --1271
					local res, px, py, pz = getObjectCoordinates(v)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(xp,yp,zp)
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, '�������\n���������: '..distance, wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
			if isObjectOnScreen(v) and rsem.v then
				if num == 859 then
					local res, px, py, pz = getObjectCoordinates(v)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(xp,yp,zp)
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, '�������\n���������: '..distance, wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
            if isObjectOnScreen(v) and rryda.v then
				if num == 854 then
					local res, px, py, pz = getObjectCoordinates(v)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local wX, wY = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(xp,yp,zp)
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, '�����\n���������: '..distance, wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
            if isObjectOnScreen(v) and rolen.v then
				if num == 19315 then
					local res, px, py, pz = getObjectCoordinates(v)
					local xp,yp,zp = getCharCoordinates(PLAYER_PED)
					local wX, wY, wZ = convert3DCoordsToScreen(px, py, pz)
					local myPosX, myPosY = convert3DCoordsToScreen(xp,yp,zp)
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(px,py,pz,xp,yp,zp))
					renderFontDrawText(font, '������\n���������: '..distance, wX, wY , test2)
					renderDrawLine(myPosX, myPosY, wX, wY, test1, test)
				end
			end
		end
		for id = 0, 2048 do
            local result = sampIs3dTextDefined( id )
            if result then
                local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(id)
                if rzakladka.v and text:find("��������") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(posX, posY, posZ,x2,y2,z2))
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,' ��������\n���������: '..distance, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rlen.v and text:find("˸�") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rhlopok.v and text:find("������") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				--�������
				if rderevo.v and text:find("�����������: '��������', ����� ������� �����") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rdrevecina.v and text:find("������ ������� ��������") then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
					distance = string.format("%.0f�", getDistanceBetweenCoords3d(posX, posY, posZ,x2,y2,z2))
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,'������ ���.��������\n���������: '..distance, wposX, wposY,test2)
                        renderDrawLine(x10, y10, wposX, wposY, test1, test)
					end
                end

				--�����
				if rgrove.v and text:find("Grove Street") and text:find('��������') then
                    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rballas.v and text:find("East Side Ballas") and text:find('��������') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
			    if rrifa.v and text:find("The Rifa") and text:find('��������') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				 if raztec.v and text:find("Varrios Los Aztecas") and text:find('��������') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rnw.v and text:find("Night Wolves") and text:find('��������') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
                        renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				if rvagos.v and text:find("Los Santos Vagos") and text:find('��������') then
				    local wposX, wposY = convert3DCoordsToScreen(posX,posY,posZ)
                    x2,y2,z2 = getCharCoordinates(PLAYER_PED)
                    x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
                    local resX, resY = getScreenResolution()
                    if wposX < resX and wposY < resY and isPointOnScreen (posX,posY,posZ,1) then
						renderFontDrawText(font,text, wposX, wposY,test2)
						renderDrawLine(x10, y10, wposX, wposY, test1, test)
                    end
                end
				-------------------------------���� obj-----------------------------------
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
	imgui.Begin(u8'MRender v1.7.3(�������� ������, � ���������������)', main_window_state, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)
	imgui.BeginChild('##menu', imgui.ImVec2(150, 340), true)
	imgui.CenterText(u8'����')
	if imgui.Button(u8'������', imgui.ImVec2(135, 58)) then selected = 1 end
	imgui.Separator()
	if imgui.Button(u8'������ ��������', imgui.ImVec2(135, 58)) then selected = 2 end
	imgui.Separator()
	if imgui.Button(u8'����������', imgui.ImVec2(135, 58)) then selected = 3 end
	imgui.Separator()
    if imgui.Button(u8'������������', imgui.ImVec2(135, 58)) then selected = 4 end
	imgui.Separator()
	if imgui.Button(u8'����-����������', imgui.ImVec2(135, 35)) then selected = 5 end
	imgui.EndChild()
	imgui.SameLine()
	if selected == 1 then
		imgui.BeginChild('##render', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'��������')
		imgui.Separator()
		imgui.Checkbox(u8"���", rlen)
		imgui.Checkbox(u8"������", rhlopok)
		imgui.Checkbox(u8"�����", rklad)
		imgui.Checkbox(u8"��������", rzakladka)
		imgui.Checkbox(u8"������", rsem)
		imgui.Checkbox(u8"�����", rolen)
		imgui.Checkbox(u8"����", rryda)
		imgui.Checkbox(u8"�������(�����)", rderevo)
		imgui.Checkbox(u8"������� ������� ��������", rdrevecina)
		imgui.Separator()
		imgui.CenterText(u8'���� �������')
		imgui.Checkbox(u8"���� ������ �1", svoiobj1)
		imgui.Text(u8'�������� ��� obj �1')
		imgui.SameLine()
		imgui.InputText(u8'##�������� ������� ��� ������� �1', nazvanie1)
		imgui.Checkbox(u8"���� ������ �2", svoiobj2)
		imgui.Text(u8'�������� ��� obj �2')
		imgui.SameLine()
		imgui.InputText(u8'##�������� ������� ��� ������� �2', nazvanie2)
		save1()
		imgui.Separator()
		imgui.CenterText(u8'������(nil invent)')
		imgui.Separator()
		save1()
		imgui.EndChild()
	end
	if selected == 2 then
		imgui.BeginChild('##getto', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'������ ��������')
		imgui.Separator()
		imgui.Checkbox(u8"����", rgrove)
	    imgui.Checkbox(u8"������", rballas)
	    imgui.Checkbox(u8"����", rrifa)
	    imgui.Checkbox(u8"�����", raztec)
	    imgui.Checkbox(u8"������ �����", rnw)
	    imgui.Checkbox(u8"�����", rvagos)
		save1()
		imgui.EndChild()
	end
	if selected == 3 then
		imgui.BeginChild('##information', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'����������')
		imgui.Separator()
		imgui.Text(u8'�����: Tomato')
		imgui.Text(u8'��������� ������: /mrender')
		imgui.Separator()
        imgui.Text(u8'��������!!!')
		imgui.Text(u8'��� ������������� � ������ �������')
		imgui.Text(u8'�������� ������ fps �� 10%')
		imgui.Text(u8'��� ������� � ����������� ������������')
		imgui.Text(u8'����� ��� �������� ������� �������� ������ fps �� 3%')
		imgui.EndChild()
	end
    if selected == 4 then
		imgui.BeginChild('##settings', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'������������')
        imgui.Separator()
		if imgui.Combo(u8'���� �����', combo, colors) then
		    mainIni.settings.combo = combo.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.Combo(u8'������ �����', combo1, width) then
		    mainIni.settings.combo1 = combo1.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		if imgui.Combo(u8'���� ��������(obj)', combo2, colorsobj) then
		    mainIni.settings.combo2 = combo2.v
			inicfg.save(mainIni, "MRender.ini")
	    end
		imgui.EndChild()
	end
	if selected == 5 then
		imgui.BeginChild('##update', imgui.ImVec2(380, 340), true)
		imgui.CenterText(u8'����-����������')
        imgui.Separator()
		if imgui.Button(u8'��������� ����������', imgui.ImVec2(150,50)) then
			local lastver = update():getLastVersion()
            if thisScript().version ~= lastver then
			sampAddChatMessage('[AUTOUPDATE] {D5DEDD}�������� ����������! ��������...',0xFF0000)
            update():download()
            end
			if thisScript().version == lastver then
                sampAddChatMessage('[AUTOUPDATE] {D5DEDD}� ��� ��� ���������� ������!',0xFF0000)
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