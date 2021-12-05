-------------------- Metrostroi Score Board --------------------
-- Developer: Alexell
-- License: MIT
-- Website: https://alexell.ru/
-- Steam: https://steamcommunity.com/profiles/76561198210303223
-- Source code: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------------

MScoreBoard = MScoreBoard or {}
if SERVER then
	CreateConVar("mscoreboard_website", "https://metrostroi.net/profile/", {FCVAR_ARCHIVE})
	AddCSLuaFile("metrostroi_scoreboard/mscoreboard.lua")
	AddCSLuaFile("metrostroi_scoreboard/player_row.lua")
	AddCSLuaFile("metrostroi_scoreboard/player_panel.lua")
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
