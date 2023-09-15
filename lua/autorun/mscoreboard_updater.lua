---------------------- Metrostroi Score Board ----------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard_pro
--------------------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ClientInfo")
	util.AddNetworkString("MScoreBoard.EqualRoutes")
	
	local function FixedRoute(class,route)
		local result = "-"
		if (class ~= "-" and route ~= "-") then
			local rnum = tonumber(route)
			if table.HasValue({"gmod_subway_em508","gmod_subway_81-702","gmod_subway_81-703","gmod_subway_81-705_old","gmod_subway_ezh","gmod_subway_ezh3","gmod_subway_ezh3ru1","gmod_subway_81-717_mvm","gmod_subway_81-718","gmod_subway_81-720","gmod_subway_81-720_1","gmod_subway_81-720a","gmod_subway_81-717_freight","gmod_subway_81-717_5a"},class) then rnum = rnum / 10 end
			result = rnum
		end
		return result
	end

	local TrainList = {}
	timer.Simple(1.5,function()
		for _,class in pairs(Metrostroi.TrainClasses) do
			local ENT = scripted_ents.Get(class)
			if not ENT.Spawner or not ENT.SubwayTrain then continue end
			table.insert(TrainList,class)
		end
		if not MetrostroiAdvanced then CenteringStationPositions() end
	end)
	
	-- by Agent Smith
	local function CenteringStationPositions()
		if not Metrostroi.StationConfigurations then return end
		local centre
		for k1, v1 in pairs(ents.FindByClass("gmod_track_platform")) do
			if not Metrostroi.StationConfigurations[v1.StationIndex] then continue end
			for k2, v2 in pairs(ents.FindByClass("gmod_track_platform")) do
				if v1.StationIndex == v2.StationIndex and v1.PlatformIndex == 1 and v2.PlatformIndex == 2 then
					local pos1 = LerpVector(0.5, v1.PlatformStart, v2.PlatformStart)
					local pos2 = LerpVector(0.5, v1.PlatformEnd, v2.PlatformEnd)
					if isvector(pos1) and isvector(pos2) then 
						centre = LerpVector(0.5, pos1, pos2) 
					end
					if isvector(centre) and istable(Metrostroi.StationConfigurations[v1.StationIndex].positions) then
						table.insert(Metrostroi.StationConfigurations[v1.StationIndex].positions, 2, {centre, Angle(0, 0, 33)})
					end
				end
			end
		end
	end
	
	-- Получение местоположения by Agent Smith
	local function GetTrainLoc(pos,name_num)
		local ent_station = "N/A"
		local map_pos
		local radius = 4000 -- Радиус по умолчанию для станций на всех картах
		local cur_map = game.GetMap()
		local Sz
		local S
		local train_pos = pos
		
		radius = radius*radius

		if Metrostroi.StationConfigurations then
			for k, v in pairs(Metrostroi.StationConfigurations) do
				if isnumber(k) and v.positions[2] then 
					map_pos = v.positions and v.positions[2] 
				else 
					map_pos = v.positions and v.positions[1] 
				end
				if cur_map:find("gm_metro_jar_imagine_line") then
					if v.names[1] == "ДДЭ" or v.names[1] == "Диспетчерская" then continue end
				end
				if map_pos then
					S = train_pos:DistToSqr(map_pos[1])
					if (train_pos.z > 0 and map_pos[1].z < 0) or (train_pos.z < 0 and map_pos[1].z > 0) then
						Sz = math.abs(train_pos.z) + math.abs(map_pos[1].z)
					end
					if (train_pos.z > 0 and map_pos[1].z > 0) or (train_pos.z < 0 and map_pos[1].z < 0) then
						Sz = math.abs(train_pos.z - map_pos[1].z)
					end
					if S < radius and Sz < 200 then 
						if v.names[name_num] then
							ent_station = v.names[name_num]
						else
							ent_station = v.names[1]
						end
						radius = S
					end
				end
			end
		else
			ent_station = "N/A"
		end
		return ent_station
	end

	local function GetStationName(st_id,name_num)
		if not Metrostroi.StationConfigurations then return "" end
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
				station_str = GetTrainLoc(train:GetPos(),name_num)
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
	
	timer.Create("MScoreBoard.RouteNumbersChecker",60,0,function()
		local tbl = {}
		for k, v in pairs(player.GetAll()) do
			local rnumber = tonumber(v:GetNW2String("MSRoute","1000")) or 1000
			table.insert(tbl, {v, rnumber})
		end	
		for k, v in pairs(tbl) do
			for k2, v2 in pairs(tbl) do
				if k2 > k and v[1] != v2[1] and v[2] == v2[2] and (v[2] != 1000 and v2[2] != 1000) then 
					if not v[1]:GetNW2Bool("MSGuestDriving") and not v2[1]:GetNW2Bool("MSGuestDriving") then
						net.Start("MScoreBoard.EqualRoutes")
							net.WriteString(v[1]:Nick())
							net.WriteString(v2[1]:Nick())
						net.Broadcast()
					end
				end
			end
		end
	end)
	
	timer.Create("MScoreBoard.ServerUpdate",3,0,function()
		local route
		local class
		local owner
		local driver
		for train in pairs(Metrostroi.SpawnedTrains) do
			if not IsValid(train) then continue end
			class = train:GetClass()
			if not table.HasValue(TrainList,class) then continue end
			owner = train.Owner
			if not IsValid(owner) then continue end
			route = 0
			
			if class == "gmod_subway_81-722" or class == "gmod_subway_81-722_3" or class == "gmod_subway_81-722_new" or class == "gmod_subway_81-7175p" then
				route = train.RouteNumberSys.CurrentRouteNumber
			elseif class == "gmod_subway_81-717_6" or class == "gmod_subway_81-740_4" then
				route = train.ASNP.RouteNumber
			else
				if train.RouteNumber then
					route = train.RouteNumber.RouteNumber
				end
			end
			route = FixedRoute(class,route)
			
			-- owner:SetNW2String("MSTrainClass",train:GetClass())
			-- костыль для грузового, т.к. у него сзади спавнится номерной мвм
			if(owner:GetNW2String("MSTrainClass") ~= "gmod_subway_81-717_freight") then owner:SetNW2String("MSTrainClass",class) end
			owner:SetNW2String("MSStation",BuildStationInfo(train,owner:GetNWString("MSLanguage")))
			owner:SetNW2String("MSRoute",tostring(route))
			owner:SetNW2String("MSWagons",#train.WagonList)			
			driver = train.DriverSeat:GetPassenger(0) 	-- по-другому не работает, вообще, совсем !
			if not IsValid(driver) then continue end
			if driver != owner then
				driver:SetNW2Bool("MSGuestDriving",true)
				driver:SetNW2String("MSHostDriver", owner:Nick())
				if driver:GetNW2String("MSTrainClass") != "gmod_subway_81-717_freight" then driver:SetNW2String("MSTrainClass",class) end
				driver:SetNW2String("MSStation",BuildStationInfo(train,owner:GetNWString("MSLanguage")))
				driver:SetNW2String("MSRoute",tostring(route))
			end
		end
		for k, v in pairs(player.GetAll()) do
			if v.Star then
				v:SetNW2Bool("MSPlayerStar", true)
			end
			local train = v:GetTrain()
			if IsValid(train) and train.DriverSeat == v:GetVehicle() then
				v:SetNW2Bool("MSPlayerDriving",true)
			else
				v:SetNW2Bool("MSPlayerDriving",false)
				if v:GetNW2Bool("MSGuestDriving") then
					v:SetNW2String("MSRoute","-")
					v:SetNW2String("MSTrainClass","-")
					v:SetNW2String("MSStation","-")
					v:SetNW2Bool("MSGuestDriving", false)
				end
			end
		end
	end)

	hook.Add("EntityRemoved","MScoreBoard.DeleteInfo",function(ent)
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
				net.WriteString(GetConVar("metrostroi_language"):GetString())
			net.SendToServer()
		end
	end)
end
