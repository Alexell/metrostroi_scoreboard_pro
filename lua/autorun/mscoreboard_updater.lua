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
		prev_st = GetStationName(train:ReadCell(49162),name_num)
		next_st = GetStationName(train:ReadCell(49161),name_num)
		if cur_st == "" then
			line = train:ReadCell(49167)
			station_str = " "..prev_st.." => "..next_st
		else
			line = train:ReadCell(49168)
			station_str = " "..cur_st
		end
		if lang == "ru" then
			line_str = "["..line.." %s]"
		else
			line_str = "[%s "..line.."]"
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
					route = train.RouteNumber.RouteNumber
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
