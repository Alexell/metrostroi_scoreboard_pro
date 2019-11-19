----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ServerInfo")
	util.AddNetworkString("MScoreBoard.ClientInfo")
	
	local TrainList = {
		"gmod_subway_81-502",
		"gmod_subway_81-540",
		"gmod_subway_81-702",
		"gmod_subway_81-703",
		"gmod_subway_ezh",
		"gmod_subway_ezh3",
		"gmod_subway_ezh3ru1",
		"gmod_subway_81-717_mvm",
		"gmod_subway_81-717_lvz",
		"gmod_subway_81-717_6",
		"gmod_subway_81-718",
		"gmod_subway_81-720",
		"gmod_subway_81-722",
		"gmod_subway_81-760",
		"gmod_subway_81-760a"
	}
	
	-- старый вариант получения местоположения by Agent Smith
	local function GetTrainLoc(train,name_num)
		local train_station = ""
		local map_pos
		local station_pos
		local station_posx
		local station_posy
		local station_posz
		local train_pos
		local train_posx
		local train_posy
		local train_posz
		local get_pos1
		local get_pos2
		local radius = 4000 -- Радиус по умолчанию для станций на всех картах
		local cur_map = game.GetMap()
		local Sz
		local S
		
		train_pos = tostring(train:GetPos())
		get_pos1 = string.find(train_pos, " ")
		train_posx = string.sub(train_pos,1,get_pos1)
		train_posx = tonumber(train_posx)	
		
		get_pos2 = string.find(train_pos, " ", get_pos1 + 1)
		train_posy = string.sub(train_pos,get_pos1,get_pos2)
		train_posy = tonumber(train_posy)
		
		train_posz = string.sub(train_pos,get_pos2 + 1)
		train_posz = tonumber(train_posz)	

		for k, v in pairs(Metrostroi.StationConfigurations) do
			map_pos = v.positions and v.positions[1]
			if map_pos and map_pos[1] then
				station_pos = tostring(map_pos[1])
				get_pos1 = string.find(station_pos, " ")
				station_posx = string.sub(station_pos,1,get_pos1)
				station_posx = tonumber(station_posx)
				
				get_pos2 = string.find(station_pos, " ", get_pos1 + 1)
				station_posy = string.sub(station_pos,get_pos1,get_pos2)
				station_posy = tonumber(station_posy)
				
				station_posz = string.sub(station_pos,get_pos2 + 1)
				station_posz = tonumber(station_posz)
				
				if (cur_map:find("gm_metro_jar_imagine_line"))  then
					if (v.names[1] == "ДДЭ" or v.names[1] == "Диспетчерская") then continue end
				end

				if ((station_posz > 0 and train_posz > 0) or (station_posz < 0 and train_posz < 0)) then -- оба Z больше нуля или меньше нуля
					Sz = math.max(math.abs(station_posz),math.abs(train_posz)) - math.min(math.abs(station_posz),math.abs(train_posz))
				end
				if ((station_posz < 0 and train_posz > 0) or (station_posz > 0 and train_posz < 0)) then -- один Z больше нуля или меньше нуля
					Sz = math.abs(train_posz) + math.abs(station_posz)
				end
				S = math.sqrt(math.pow((station_posx - train_posx), 2) + math.pow((station_posy - train_posy), 2))
			
				-- Поиск ближайшей точки в StationConfigurations с уменьшением радиуса:
				if (S < radius and Sz < 200) then 
					if v.names[name_num] then
						train_station = v.names[name_num]
					else
						train_station = v.names[1]
					end
					radius = S
				end
			end
		end
		if (train_station == "") then train_station = "N/A" end
		return train_station
	end

	local function GetStationName(st_id,name_num)
		if Metrostroi.StationConfigurations[st_id] then
			if Metrostroi.StationConfigurations[st_id].names[name_num] then
				return Metrostroi.StationConfigurations[st_id].names[name_num]
			else
				return Metrostroi.StationConfigurations[st_id].names[1]
			end
		else
			return ""
		end
	end
	
	local function BuildStationInfo(train,lang)
		local prev_st = ""
		local cur_st = ""
		local next_st = ""
		local line = 0
		local line_str = ""
		local station_str = ""
		local name_num = 1
		if lang ~= "ru" then name_num = 2 end
		cur_st = GetStationName(train:ReadCell(49160),name_num)
		if cur_st ~= "" then
			line = train:ReadCell(49168)
			station_str = cur_st
		else
			prev_st = GetStationName(train:ReadCell(49162),name_num)
			next_st = GetStationName(train:ReadCell(49161),name_num)
			if (prev_st ~= "" and next_st ~= "") then
				line = train:ReadCell(49167)
				station_str = prev_st.." - "..next_st
			else
				station_str = GetTrainLoc(train,name_num)
			end
		end
		if line ~= 0 then
			if lang == "ru" then
				line_str = "["..line.." %s] "
			else
				line_str = "[%s "..line.."] "
			end
		end
		return line_str..station_str
	end
	
	timer.Create("MScoreBoard.ServerUpdate",3,0,function()
		local TrainCount = Metrostroi.TrainCount()
		if TrainCount >= 0 then
			net.Start("MScoreBoard.ServerInfo")
				net.WriteInt(TrainCount,6)
			net.Broadcast()
		end
		for k, v in pairs(TrainList) do
			for _,train in pairs(ents.FindByClass(v)) do
				local ply = train.Owner
				if not IsValid(ply) then continue end
				local route = "0"
				if train:GetClass() == "gmod_subway_81-722" then
					route = tostring(train.RouteNumberSys.CurrentRouteNumber)
				elseif train:GetClass() == "gmod_subway_81-717_6" then
					route = tostring(train.ASNP.RouteNumber)
				else
					if train.RouteNumber then
						route = train.RouteNumber.RouteNumber
					end
				end
				ply:SetNW2String("MSRoute",route)
				ply:SetNW2String("MSWagons",#train.WagonList)
				ply:SetNW2String("MSTrainClass",train:GetClass())
				ply:SetNW2String("MSStation",BuildStationInfo(train,ply:GetNWString("MSLanguage")))
			end
		end
		for k, v in pairs(player.GetAll()) do
			local train = v:GetTrain()
			if (IsValid(train) and train.DriverSeat == v:GetVehicle() and train.Owner == v) then
				v:SetNW2Bool("MSPlayerDriving",true)
			else
				v:SetNW2Bool("MSPlayerDriving",false)
			end
		end
	end)

	hook.Add("EntityRemoved","MScoreBoard.DeleteInfo",function (ent)
		local ply = ent.Owner
		if not IsValid(ply) then return end
		if ent:GetClass() == ply:GetNW2String("MSTrainClass") then
			ply:SetNW2String("MSRoute","-")
			ply:SetNW2String("MSWagons","-")
			ply:SetNW2String("MSTrainClass","-")
			ply:SetNW2String("MSStation","-")
		end
	end)

	net.Receive("MScoreBoard.ClientInfo",function(ln,ply)
		if not IsValid(ply) then return end
		ply:SetNWString("MSLanguage",net.ReadString())
	end)
else
	hook.Add("OnEntityCreated","MScoreBoard.GetPlayerLang",function()
		if not IsValid(LocalPlayer()) then return end
		if LocalPlayer():GetNW2String("MSLanguage") == "" then
			net.Start("MScoreBoard.ClientInfo")
				net.WriteString(GetConVarString("metrostroi_language"))
			net.SendToServer()
		end
	end)
end
