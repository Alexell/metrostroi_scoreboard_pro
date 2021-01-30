----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexellpro
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

MScoreBoard = MScoreBoard or {}
if SERVER then
	AddCSLuaFile("metrostroi_scoreboard/mscoreboard.lua")
	AddCSLuaFile("metrostroi_scoreboard/player_row.lua")
else
	include("metrostroi_scoreboard/mscoreboard.lua")
end

timer.Create("MScoreBoard.Init",2,1,function()
	function GAMEMODE:ScoreboardShow()
		MScoreBoard:Show()
	end

	function GAMEMODE:ScoreboardHide()
		MScoreBoard:Hide()
	end
end)
