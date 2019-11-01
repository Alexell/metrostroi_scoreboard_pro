----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

local gradient = surface.GetTextureID("gui/center_gradient")
local offset = 14 -- смещение от заголовка
local PlayerRow = {}

function PlayerRow:Init()
	self.AvatarBTN = vgui.Create("DButton",self)
	self.AvatarBTN.DoClick = function() self.Player:ShowProfile() end
	self.AvatarIMG = vgui.Create("AvatarImage",self.AvatarBTN)
	self.AvatarIMG:SetMouseInputEnabled(false)
	
	self.Nick = vgui.Create("DLabel",self)
	self.Team = vgui.Create("DLabel",self)
	self.Route = vgui.Create("DLabel",self)
	self.Wags = vgui.Create("DLabel",self)
	self.Train = vgui.Create("DLabel",self)
	self.Station = vgui.Create("DLabel",self)
	if ScrW() >= 1600 then
		self.Hours = vgui.Create("DLabel",self)
		self.Ping = vgui.Create("DLabel",self)
	end
	self.MuteIcon = vgui.Create("DImageButton",self)
end

function PlayerRow:Paint(w,h)
	if not IsValid(self.Player) then
		self:Remove()
		MScoreBoard.Panel:InvalidateLayout()
		return
	end
	local color = Color(100,100,100,255)
	if self.Player:Team() == TEAM_CONNECTING then
		color = Color(100,100,100,155)
	elseif IsValid(self.Player) then
		color = team.GetColor(self.Player:Team())
	end
	
	if self.Player == LocalPlayer() then
		color = team.GetColor(self.Player:Team())
	end
	
	draw.RoundedBox(4,0,0,self:GetWide(),38,color)
	surface.SetTexture(gradient)
	surface.SetDrawColor(255,255,255,150)
	surface.DrawTexturedRect(0,0,self:GetWide(),38)
end

function PlayerRow:PerformLayout()
	self.MuteIcon:SetSize(32,32)
	self.MuteIcon:SetPos(self:GetWide()-self.MuteIcon:GetWide(),3)

	self.AvatarBTN:SetPos(3,3)
	self.AvatarBTN:SetSize(32,32)
 	self.AvatarIMG:SetSize(32,32)
	
	self.Nick:SetPos(40,11)
	self.Nick:SizeToContents()

	if ScrW() >= 1600 then
		self.Ping:SetPos(self:GetWide()-offset-55,11)
		self.Ping:SizeToContents()
		self.Hours:SetPos(self:GetWide()-offset-100,11)
		self.Hours:SizeToContents()
		
		self.Station:SetPos(self:GetWide()-offset-500,11)
		self.Train:SetPos(self:GetWide()-offset-670,11)
		self.Wags:SetPos(self:GetWide()-offset-730,11)
		self.Route:SetPos(self:GetWide()-offset-800,11)
		self.Team:SetPos(self:GetWide()-offset-1050,11)
	else
		self.Station:SetPos(self:GetWide()-offset-350,11)
		self.Train:SetPos(self:GetWide()-offset-520,11)
		self.Wags:SetPos(self:GetWide()-offset-580,11)
		self.Route:SetPos(self:GetWide()-offset-650,11)
		self.Team:SetPos(self:GetWide()-offset-900,11)
	end
	self.Station:SizeToContents()
	self.Train:SizeToContents()
	self.Wags:SizeToContents()
	self.Route:SizeToContents()
	self.Team:SizeToContents()
end

function PlayerRow:ApplySchemeSettings()
	-- шрифты
	self.Nick:SetFont("mscoreboardmain")
	self.Team:SetFont("mscoreboardmain")
	self.Route:SetFont("mscoreboardmain")
	self.Wags:SetFont("mscoreboardmain")
	self.Train:SetFont("mscoreboardmain")
	self.Station:SetFont("mscoreboardmain")
	
	if ScrW() >= 1600 then
		self.Hours:SetFont("mscoreboardmain")
		self.Ping:SetFont("mscoreboardmain")
	end
	
	-- цвета
	self.Nick:SetTextColor(Color(0,0,0,255))
	self.Team:SetTextColor(Color(0,0,0,255))

	self.Route:SetTextColor(Color(0,0,0,255))
	self.Wags:SetTextColor(Color(0,0,0,255))
	self.Train:SetTextColor(Color(0,0,0,255))
	self.Station:SetTextColor(Color(0,0,0,255))
	
	if ScrW() >= 1600 then
		self.Hours:SetTextColor(Color(0,0,0,255))
		self.Ping:SetTextColor(Color(0,0,0,255))
	end
end

function PlayerRow:UpdatePlayerData()
	local ply = self.Player
	if not IsValid(ply) then return end
	self.Nick:SetText(ply:Nick())
	self.Team:SetText(team.GetName(ply:Team()))
	
	if self.Muted == nil or self.Muted ~= self.Player:IsMuted() then
		self.Muted = self.Player:IsMuted()
		if self.Muted then
			self.MuteIcon:SetImage("icon32/muted.png")
		else
			self.MuteIcon:SetImage("icon32/unmuted.png")
		end
		self.MuteIcon.DoClick = function() self.Player:SetMuted(not self.Muted) end
	end
end

function PlayerRow:SetPlayer(ply)
	self.Player = ply
	self:UpdatePlayerData()
	self.AvatarIMG:SetPlayer(ply)
end

function PlayerRow:Think()
	if not self.PlayerUpdate or self.PlayerUpdate < CurTime() then
		self.PlayerUpdate = CurTime() + 0.5
		self:UpdatePlayerData()
	end
end
vgui.Register("mplayerrow",PlayerRow,"DPanel")
