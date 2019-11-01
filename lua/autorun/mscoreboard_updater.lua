----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

if SERVER then
	util.AddNetworkString("MScoreBoard.ServerInfo")
	timer.Create("MScoreBoard.ServerUpdate",5,0,function()
		local TrainCount = Metrostroi.TrainCount()
		if TrainCount >= 0 then
			net.Start("MScoreBoard.ServerInfo")
				net.WriteInt(TrainCount,6)
			net.Broadcast()
		end
	end)
end