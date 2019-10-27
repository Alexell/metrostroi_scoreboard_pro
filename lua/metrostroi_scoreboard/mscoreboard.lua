----------------- Metrostroi Score Board -----------------
-- Автор: Alexell
-- Лицензия: MIT
-- Сайт: https://alexell.ru/
-- Steam: https://steamcommunity.com/id/alexell
-- Repo: https://github.com/Alexell/metrostroi_scoreboard
----------------------------------------------------------

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

-- Дизайн
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
	self.Hours = vgui.Create("DLabel",self)
	self.Ping = vgui.Create("DLabel",self)
	
	self.Pass = vgui.Create("DLabel",self)
end

function Board:Paint(w,h)
	-- прозрачный слой для относительных позиций элементов
	draw.RoundedBox(10,0,0, self:GetWide(), self:GetTall(), Color(0,0,0,0))
	
	-- блок для названия сервера
	draw.RoundedBox(10,10,10,self:GetWide() - 20, 50 ,Color(0,0,0,180))
	
	-- блок для информации шапки
	draw.RoundedBox(5,10,65,self:GetWide() - 20, 30,Color(0,0,0,180))
	
	-- блок для игроков
	draw.RoundedBox(5,10,100,self:GetWide() - 20, self:GetTall() - 135,Color(0,0,0,180))
	draw.RoundedBox(5,17,120,self:GetWide() - 34, self:GetTall() - 163,Color(204,204,204,100))
	
	-- градиент поверх
	surface.SetTexture(gradient)
	surface.SetDrawColor(255,255,255,100)
	surface.DrawTexturedRect(17,120,self:GetWide() - 34, self:GetTall() - 163)
	
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
	self.Hours:SetText("Часы")
	self.Ping:SetText("Пинг")
	
	self.Pass:SetText("Вы перевезли: 0 пассажиров")
	
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
	self.Hours:SetFont("mscoreboardtitle")
	self.Ping:SetFont("mscoreboardtitle")
	
	self.Pass:SetFont("ScoreboardDefault")
	
	-- блок для информации подвала
	draw.RoundedBox(5,10,self:GetTall()-30,self:GetWide() - 20, 30,Color(0,0,0,180))
end

function Board:PerformLayout()
	local w = 1200 -- для мониторов шириной меньше 1600px
	local h = ScrH() * 0.65
	
	if ScrW() >= 1600 then
		w = ScrW() * 0.85
	end
	
	-- прозрачный слой
	self:SetSize(w,h)
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
	self.Hours:SizeToContents()
	self.Ping:SizeToContents()
	
	self.Nick:SetPos(37, 102)
	self.Group:SetPos(137, 102)
	self.Route:SetPos(190, 102)
	self.Wagons:SetPos(250, 102)
	self.Train:SetPos(320, 102)
	self.Station:SetPos(410, 102)
	self.Hours:SetPos(480, 102)
	self.Ping:SetPos(700, 102)
	
	if ScrW() >= 1600 then
		
	else
	
	end
	
	-- лейблы подвала
	self.Pass:SizeToContents()
	self.Pass:SetPos(20, self:GetTall()-27)
end
vgui.Register("MetrostroiScoreBoard",Board,"Panel")

-- Остальные функции
function MScoreBoard:Show()
	if MScoreBoard.Panel then
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
	end
	MScoreBoard.Panel = vgui.Create("MetrostroiScoreBoard")
	--MScoreBoard:Update(true)
	--gui.EnableScreenClicker(true)
	
	function MScoreBoard:Hide()
		MScoreBoard.Panel:Remove()
		MScoreBoard.Panel = nil
		--gui.EnableScreenClicker(false)
	end
end
