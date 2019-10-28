----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------
include("player_row.lua")

surface.CreateFont("mscoreboardtitle",{
	font = "verdana",
	size = 16,
	weight = 600
})
surface.CreateFont("mscoreboardmain",{
	font = "verdana",
	size = 16,
	weight = 100
})
local gradient = surface.GetTextureID("gui/center_gradient")

-- поправки на разрешение экрана
local scrw = 1280 -- для мониторов шириной меньше 1600px
local scrh = ScrH() * 0.65

if ScrW() >= 1600 then
	scrw = ScrW() * 0.85
end
	
-- ОСНОВНАЯ ПАНЕЛЬ --
local Board = {}

function Board:Init()
	
	self.Server = vgui.Create("DLabel",self)
	self.CLTime = vgui.Create("DLabel",self)
	self.SVTime = vgui.Create("DLabel",self)
	self.Info = vgui.Create("DLabel",self)
	
	self.Nick = vgui.Create("DLabel",self)
	self.Group = vgui.Create("DLabel",self)
	self.Route = vgui.Create("DLabel",self)
	self.Wagons = vgui.Create("DLabel",self)
	self.Train = vgui.Create("DLabel",self)
	self.Station = vgui.Create("DLabel",self)

	if ScrW() >= 1600 then
		self.Hours = vgui.Create("DLabel",self)
		self.Ping = vgui.Create("DLabel",self)
	end
	
	self.Pass = vgui.Create("DLabel",self)
	
	self.PlayerRows = {}
	self.Frame = vgui.Create("mplayersframe",self)
end

function Board:Paint(w,h)
	-- блок для названия сервера
	draw.RoundedBox(10,10,10,self:GetWide() - 20, 50 ,Color(0,0,0,180))
	
	-- блок для информации шапки
	draw.RoundedBox(5,10,65,self:GetWide() - 20, 30,Color(0,0,0,180))
	
	-- блок для игроков
	draw.RoundedBox(5,10,100,self:GetWide() - 20, self:GetTall() - 135,Color(0,0,0,180))
	
	self.Server:SetText(GetHostName())
	self.CLTime:SetText("Ваше время: "..os.date("%H:%M:%S",os.time()))
	self.SVTime:SetText("Время сервера: "..os.date("%H:%M:%S",Metrostroi.GetSyncTime(false))) -- нужно true вроде
	self.Info:SetText("Игроков: 0 | Вагонов: 0") -- перенести в Update
	
	self.Nick:SetText("Ник")
	self.Group:SetText("Должность")
	self.Route:SetText("Маршрут")
	self.Wagons:SetText("Вагоны")
	self.Train:SetText("Состав")
	self.Station:SetText("Станция/перегон")
	if ScrW() >= 1600 then
		self.Hours:SetText("Часы")
		self.Ping:SetText("Пинг")
	end
	
	self.Pass:SetText("Вы перевезли: 0 пассажиров")

	-- блок для информации подвала
	draw.RoundedBox(5,10,self:GetTall()-30,self:GetWide() - 20, 30,Color(0,0,0,180))
end

function Board:PerformLayout()


	self:SetSize(scrw,scrh)
	self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
	
	-- лейблы шапки
	self.Server:SizeToContents()
	self.Server:SetPos((self:GetWide() / 2) - (self.Server:GetWide() / 2), 20)
	
	self.CLTime:SizeToContents()
	self.CLTime:SetPos(20, 68)
	
	self.SVTime:SizeToContents()
	self.SVTime:SetPos(self:GetWide() - self.SVTime:GetWide() - 20, 68)
	
	self.Info:SizeToContents()
	self.Info:SetPos((self:GetWide() / 2) - (self.Info:GetWide() / 2), 68)
	
	-- лейблы заголовка
	self.Nick:SizeToContents()
	self.Group:SizeToContents()
	self.Route:SizeToContents()
	self.Wagons:SizeToContents()
	self.Train:SizeToContents()
	self.Station:SizeToContents()

	self.Frame:SetPos(17,120)
	self.Frame:SetSize(self:GetWide() - 34, self:GetTall() - 163)
	
	if ScrW() >= 1600 then
		self.Hours:SizeToContents()
		self.Ping:SizeToContents()
	end

	self.Nick:SetPos(63, 102)

	if ScrW() >= 1600 then
		self.Ping:SetPos(self.Frame:GetWide()-55, 102)
		self.Hours:SetPos(self.Frame:GetWide()-100, 102)
		self.Station:SetPos(self.Frame:GetWide()-500, 102)
		self.Train:SetPos(self.Frame:GetWide()-670, 102)
		self.Wagons:SetPos(self.Frame:GetWide()-730, 102)
		self.Route:SetPos(self.Frame:GetWide()-800, 102)
		self.Group:SetPos(self.Frame:GetWide()-1050, 102)
	else
		self.Station:SetPos(self.Frame:GetWide()-350, 102)
		self.Train:SetPos(self.Frame:GetWide()-520, 102)
		self.Wagons:SetPos(self.Frame:GetWide()-580, 102)
		self.Route:SetPos(self.Frame:GetWide()-650, 102)
		self.Group:SetPos(self.Frame:GetWide()-900, 102)
	end

	-- лейблы подвала
	self.Pass:SizeToContents()
	self.Pass:SetPos(20, self:GetTall()-27)
end

function Board:ApplySchemeSettings()
	-- шрифты
	self.Server:SetFont("ScoreboardDefaultTitle")
	self.CLTime:SetFont("ScoreboardDefault")
	self.SVTime:SetFont("ScoreboardDefault")
	self.Info:SetFont("ScoreboardDefault")
	
	self.Nick:SetFont("mscoreboardtitle")
	self.Group:SetFont("mscoreboardtitle")
	self.Route:SetFont("mscoreboardtitle")
	self.Wagons:SetFont("mscoreboardtitle")
	self.Train:SetFont("mscoreboardtitle")
	self.Station:SetFont("mscoreboardtitle")
	if ScrW() >= 1600 then
		self.Hours:SetFont("mscoreboardtitle")
		self.Ping:SetFont("mscoreboardtitle")
	end
	self.Pass:SetFont("ScoreboardDefault")
end

function Board:AddPlayerRow(ply)
	local row = vgui.Create("mplayerrow",self.Frame)
	row:SetPlayer(ply)
	row:SetCursor("user")
	
	self.Frame.ScrollPanel:AddItem(row)
	row:Dock(TOP)
	row:DockMargin(3,3,3,0)
	row:SetSize(self.Frame:GetWide(),38)
	self.PlayerRows[ply] = row
end

function Board:GetPlayerRow(ply)
	return self.PlayerRows[ply]
end

function Board:Update(force)
	if not self or (not force and not self:IsVisible()) then return end
	local PlayerList = player.GetAll()	
	for _,ply in pairs(PlayerList) do
		if not self:GetPlayerRow(ply) then
			self:AddPlayerRow(ply)
		end
	end
	self:InvalidateLayout()
end
vgui.Register("MetrostroiScoreBoard",Board,"Panel")

-- ФРЕЙМ ИГРОКОВ --
local Frame = {}

function Frame:Init()
	self.ScrollPanel = vgui.Create("DScrollPanel",self)
end

function Frame:Paint(w,h)
	-- светлый блок
	draw.RoundedBox(5,0,0,w,h,Color(204,204,204,100))
	
	-- градиент поверх
	surface.SetTexture(gradient)
	surface.SetDrawColor(255,255,255,100)
	surface.DrawTexturedRect(0,0,w,h)
end

function Frame:PerformLayout()
	self:SetSize(self:GetParent():GetWide()-35,self:GetParent():GetTall()-163)
	self.ScrollPanel:Dock(FILL)
	local ScrollBar = self.ScrollPanel:GetVBar()
	ScrollBar:SetSize(0,0)
end
vgui.Register("mplayersframe",Frame,"Panel")

-- Глобальные функции
function MScoreBoard:Show()
	if MScoreBoard.Panel then
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
	end
	MScoreBoard.Panel = vgui.Create("MetrostroiScoreBoard")
	MScoreBoard.Panel:Update(true)
	gui.EnableScreenClicker(true)
	
	function MScoreBoard:Hide()
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
		gui.EnableScreenClicker(false)
	end
end
