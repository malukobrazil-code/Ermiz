-- EMZ Panel Pro VIP (Interfaz MTH TEAM V22)
-- VERSIÓN COMPLETA CON PESTAÑAS DESPLAZABLES, IDIOMAS Y PANEL UNIFICADO
-- MODIFICADO: Pestañas con scroll, tamaño ajusta ancho+alto, selector idiomas, panel integrado con barra

local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- ================== VARIABLES ==================
local flySpeed = 20
local walkSpeed = 20
local flying = false
local speedEnabled = false
local noclipEnabled = false
local espBodyEnabled = false
local espEnemyEnabled = false
local espBoxEnabled = false
local espLineEnabled = false
local espNameEnabled = false
local espSkeletonEnabled = false
local espHealthBarEnabled = false
local aimbotEnabled = false
local aimbotVisible = false
local aimbotFOV = 50
local aimbotTarget = "cabeza"
local aimbotSmooth = 1
local aimbotTeamCheck = false
local drawFOVCircle = true
local infiniteJumpEnabled = false
local fullbrightEnabled = false
local removeFogEnabled = false
local antiLagEnabled = false
local hitboxEnabled = false
local hitboxSize = 5
local hitboxTransparency = 0.4

-- Variables para la pestaña Tema
local temaColor = Color3.fromRGB(255, 50, 50)  -- Rojo por defecto
local panelSize = 300  -- Tamaño por defecto del panel (ancho y alto base)
local idiomaActual = "español"  -- Idioma por defecto
local temaOpciones = {}

-- Textos según idioma
local textos = {
	español = {
		by = "By L-RASTA",
		aimbot = "Aimbot",
		player = "Player",
		esp = "ESP",
		mundo = "Mundo",
		tema = "Tema",
		selector = "Selector ▼",
		suavizado = "Suavizado",
		visible = "Visible",
		normal = "Normal",
		aimFov = "Aim FOV",
		teamCheck = "Team Check",
		drawFov = "Draw FOV Circle",
		fly = "Fly",
		flySpeed = "Fly Speed",
		speed = "Speed",
		walkSpeed = "Walk Speed",
		noclip = "Noclip",
		infiniteJump = "Infinite Jump",
		espCuerpo = "ESP Cuerpo",
		espEnemigos = "ESP Enemigos",
		espNombre = "ESP Nombre",
		espSkeleton = "ESP Skeleton",
		espBox = "ESP Box",
		espLinea = "ESP Línea",
		espHealth = "ESP Health Bar",
		fullbright = "Fullbright",
		removeFog = "Remove Fog",
		antiLag = "Anti-Lag / FPS Boost",
		hitbox = "Hitbox Extender",
		tamano = "Tamaño",
		transparencia = "Transparencia",
		resetAll = "Reset All",
		colorTema = "Color del Tema",
		tamanoPanel = "Tamaño Panel",
		idioma = "Idioma",
		ingles = "Inglés",
		espanol = "Español",
		portugues = "Português",
	},
	ingles = {
		by = "By L-RASTA",
		aimbot = "Aimbot",
		player = "Player",
		esp = "ESP",
		mundo = "World",
		tema = "Theme",
		selector = "Selector ▼",
		suavizado = "Smooth",
		visible = "Visible",
		normal = "Normal",
		aimFov = "Aim FOV",
		teamCheck = "Team Check",
		drawFov = "Draw FOV Circle",
		fly = "Fly",
		flySpeed = "Fly Speed",
		speed = "Speed",
		walkSpeed = "Walk Speed",
		noclip = "Noclip",
		infiniteJump = "Infinite Jump",
		espCuerpo = "ESP Body",
		espEnemigos = "ESP Enemies",
		espNombre = "ESP Name",
		espSkeleton = "ESP Skeleton",
		espBox = "ESP Box",
		espLinea = "ESP Line",
		espHealth = "ESP Health Bar",
		fullbright = "Fullbright",
		removeFog = "Remove Fog",
		antiLag = "Anti-Lag / FPS Boost",
		hitbox = "Hitbox Extender",
		tamano = "Size",
		transparencia = "Transparency",
		resetAll = "Reset All",
		colorTema = "Theme Color",
		tamanoPanel = "Panel Size",
		idioma = "Language",
		ingles = "English",
		espanol = "Spanish",
		portugues = "Portuguese",
	},
	portugues = {
		by = "By L-RASTA",
		aimbot = "Aimbot",
		player = "Player",
		esp = "ESP",
		mundo = "Mundo",
		tema = "Tema",
		selector = "Seletor ▼",
		suavizado = "Suavizado",
		visible = "Visível",
		normal = "Normal",
		aimFov = "Aim FOV",
		teamCheck = "Team Check",
		drawFov = "Desenhar FOV",
		fly = "Voar",
		flySpeed = "Velocidade Voo",
		speed = "Velocidade",
		walkSpeed = "Velocidade Andar",
		noclip = "Noclip",
		infiniteJump = "Pulo Infinito",
		espCuerpo = "ESP Corpo",
		espEnemigos = "ESP Inimigos",
		espNombre = "ESP Nome",
		espSkeleton = "ESP Esqueleto",
		espBox = "ESP Caixa",
		espLinea = "ESP Linha",
		espHealth = "ESP Barra Vida",
		fullbright = "Fullbright",
		removeFog = "Remover Névoa",
		antiLag = "Anti-Lag / FPS Boost",
		hitbox = "Hitbox Extender",
		tamano = "Tamanho",
		transparencia = "Transparência",
		resetAll = "Resetar Tudo",
		colorTema = "Cor do Tema",
		tamanoPanel = "Tamanho Painel",
		idioma = "Idioma",
		ingles = "Inglês",
		espanol = "Espanhol",
		portugues = "Português",
	}
}

local function T(texto)
	return textos[idiomaActual][texto] or texto
end

local minValue = 20
local maxValue = 1000
local minFOV = 20
local maxFOV = 100
local originalFog = nil
local originalBrightness = nil
local originalAmbient = nil

-- Anti-Kick (activado por defecto)
local antiKickEnabled = true
local antiKickConnection = nil

local espBoxes = {}
local espLines = {}
local espNameLabels = {}
local espSkeletonLines = {}
local espHealthBars = {}
local hitboxRespawnConnections = {}

-- Colores rotativos
local coloresRotativos = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 255, 0),
	Color3.fromRGB(0, 255, 0),
	Color3.fromRGB(0, 255, 255),
	Color3.fromRGB(0, 100, 255),
	Color3.fromRGB(255, 0, 255),
	Color3.fromRGB(255, 165, 0),
	Color3.fromRGB(255, 105, 180)
}
local colorIndex = 1
local colorActual = coloresRotativos[1]
local colorObjetivo = coloresRotativos[2]
local transicionProgreso = 0
local VELOCIDAD_TRANSICION = 0.05

task.spawn(function()
	while true do
		task.wait(0.03)
		transicionProgreso = transicionProgreso + VELOCIDAD_TRANSICION
		if transicionProgreso >= 1 then
			transicionProgreso = 0
			colorIndex = colorIndex % #coloresRotativos + 1
			colorActual = colorObjetivo
			colorObjetivo = coloresRotativos[(colorIndex % #coloresRotativos) + 1]
		end
		local r = colorActual.R + (colorObjetivo.R - colorActual.R) * transicionProgreso
		local g = colorActual.G + (colorObjetivo.G - colorActual.G) * transicionProgreso
		local b = colorActual.B + (colorObjetivo.B - colorActual.B) * transicionProgreso
		colorActual = Color3.new(r, g, b)
	end
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "DRIP_CLIENT_MOBILE"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function notifyToggle(optionName, enabled)
	pcall(function()
		local verb = enabled and "activada" or "desactivada"
		if idiomaActual == "ingles" then
			verb = enabled and "activated" or "deactivated"
		elseif idiomaActual == "portugues" then
			verb = enabled and "ativada" or "desativada"
		end
		StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = optionName .. " " .. verb,
			Color = temaColor,
			Font = Enum.Font.SourceSansBold,
			FontSize = Enum.FontSize.Size14
		})
	end)
end

-- CONTADOR DE ENEMIGOS
local enemyCountDisplay = Instance.new("TextLabel", gui)
enemyCountDisplay.Name = "EnemyCountDisplay"
enemyCountDisplay.Size = UDim2.new(0, 200, 0, 40)
enemyCountDisplay.Position = UDim2.new(0.5, -100, 0, 20)
enemyCountDisplay.BackgroundTransparency = 1
enemyCountDisplay.Text = "Enemigos: 0"
enemyCountDisplay.TextColor3 = Color3.fromRGB(255, 0, 0)
enemyCountDisplay.Font = Enum.Font.GothamBold
enemyCountDisplay.TextSize = 25
enemyCountDisplay.TextXAlignment = Enum.TextXAlignment.Center
enemyCountDisplay.Visible = false
enemyCountDisplay.ZIndex = 10

-- ================== INTERFAZ UNIFICADA ==================
local BARRA_ALTO = 25
local PANEL_ALTO_BASE = 200

-- CONTENEDOR PRINCIPAL (barra + panel unificados visualmente)
local mainContainer = Instance.new("Frame", gui)
mainContainer.Name = "MainContainer"
mainContainer.Size = UDim2.new(0, panelSize, 0, BARRA_ALTO + PANEL_ALTO_BASE)
mainContainer.Position = UDim2.new(0.5, -panelSize/2, 0.5, -(BARRA_ALTO + PANEL_ALTO_BASE)/2)
mainContainer.BackgroundTransparency = 1
mainContainer.ZIndex = 1

-- BARRA SUPERIOR ROJA (parte de arriba del contenedor)
local barraSuperior = Instance.new("Frame", mainContainer)
barraSuperior.Name = "BarraSuperior"
barraSuperior.Size = UDim2.new(1, 0, 0, BARRA_ALTO)
barraSuperior.Position = UDim2.new(0, 0, 0, 0)
barraSuperior.BackgroundColor3 = temaColor
barraSuperior.BorderSizePixel = 0
barraSuperior.ZIndex = 10

-- PANEL (parte de abajo del contenedor)
local panel = Instance.new("Frame", mainContainer)
panel.Name = "EMZ_Panel_VIP"
panel.Size = UDim2.new(1, 0, 1, -BARRA_ALTO)
panel.Position = UDim2.new(0, 0, 0, BARRA_ALTO)
panel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
panel.BorderSizePixel = 0
panel.ZIndex = 5
panel.ClipsDescendants = true

-- BORDE REDONDEADO PARA TODO EL CONTENEDOR (unifica visualmente)
local mainCorner = Instance.new("UICorner", mainContainer)
mainCorner.CornerRadius = UDim.new(0, 10)

-- También redondeamos las partes internas para que coincidan
local barraCorner = Instance.new("UICorner", barraSuperior)
barraCorner.CornerRadius = UDim.new(0, 10)

local panelCorner = Instance.new("UICorner", panel)
panelCorner.CornerRadius = UDim.new(0, 10)

-- Texto "By L-RASTA" en la barra
local barraTexto = Instance.new("TextLabel", barraSuperior)
barraTexto.Name = "BarraTexto"
barraTexto.Size = UDim2.new(1, -40, 1, 0)
barraTexto.Position = UDim2.new(0, 25, 0, 0)
barraTexto.BackgroundTransparency = 1
barraTexto.Text = T("by")
barraTexto.TextColor3 = Color3.fromRGB(0, 0, 0)
barraTexto.Font = Enum.Font.GothamBlack
barraTexto.TextSize = 14
barraTexto.TextXAlignment = Enum.TextXAlignment.Center
barraTexto.TextYAlignment = Enum.TextYAlignment.Center
barraTexto.ZIndex = 11

-- Botón ▶ negro
local toggleButton = Instance.new("TextButton", barraSuperior)
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, BARRA_ALTO, 0, BARRA_ALTO)
toggleButton.Position = UDim2.new(0, 0, 0, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleButton.Text = "▶"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.BorderSizePixel = 0
toggleButton.AutoButtonColor = false
toggleButton.ZIndex = 12

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(0, 6)

-- Arrastrar el contenedor completo
local dragging = false
local dragStart = Vector2.new(0, 0)
local startPos = UDim2.new()
local moveConnection

barraSuperior.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainContainer.Position
		if not moveConnection then
			moveConnection = UIS.InputChanged:Connect(function(move)
				if not dragging then return end
				if move.UserInputType ~= Enum.UserInputType.MouseMovement and move.UserInputType ~= Enum.UserInputType.Touch then return end
				local delta = move.Position - dragStart
				mainContainer.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			end)
		end
	end
end)

barraSuperior.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
		if moveConnection then
			moveConnection:Disconnect()
			moveConnection = nil
		end
	end
end)

-- ====== CONTENEDOR DE PESTAÑAS (VERTICAL CON SCROLL) ======
local tabContainer = Instance.new("ScrollingFrame", panel)
tabContainer.Name = "TabContainer"
tabContainer.Size = UDim2.new(0, 60, 1, 0)
tabContainer.Position = UDim2.new(0, 0, 0, 0)
tabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabContainer.BorderSizePixel = 0
tabContainer.ZIndex = 6
tabContainer.ScrollBarThickness = 4
tabContainer.ScrollBarImageColor3 = temaColor
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.ScrollingDirection = Enum.ScrollingDirection.Y

local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.Padding = UDim.new(0, 5)
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.FillDirection = Enum.FillDirection.Vertical

local tabPadding = Instance.new("UIPadding", tabContainer)
tabPadding.PaddingTop = UDim.new(0, 10)
tabPadding.PaddingBottom = UDim.new(0, 10)

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 20)
end)

-- ====== CONTENEDOR DE CONTENIDO ======
local contentContainer = Instance.new("Frame", panel)
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -60, 1, 0)
contentContainer.Position = UDim2.new(0, 60, 0, 0)
contentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
contentContainer.BorderSizePixel = 0
contentContainer.ZIndex = 6

local contentPadding = Instance.new("UIPadding", contentContainer)
contentPadding.PaddingLeft = UDim.new(0, 8)
contentPadding.PaddingRight = UDim.new(0, 8)
contentPadding.PaddingTop = UDim.new(0, 8)
contentPadding.PaddingBottom = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame", contentContainer)
scroll.Name = "Scroll"
scroll.Size = UDim2.new(1, 0, 1, 0)
scroll.Position = UDim2.new(0, 0, 0, 0)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = temaColor
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ZIndex = 7

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

-- ====== CREAR PESTAÑA ======
local function createTab(name, emoji)
	local tab = Instance.new("Frame")
	tab.Name = name .. "Tab"
	tab.Size = UDim2.new(0, 50, 0, 40)
	tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tab.BorderSizePixel = 0
	tab.Parent = tabContainer
	tab.ZIndex = 7

	local tabCorner = Instance.new("UICorner", tab)
	tabCorner.CornerRadius = UDim.new(0, 6)

	local tabButton = Instance.new("TextButton", tab)
	tabButton.Size = UDim2.new(1, 0, 1, 0)
	tabButton.BackgroundTransparency = 1
	tabButton.Text = emoji .. "\n" .. T(name)
	tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.Font = Enum.Font.GothamBold
	tabButton.TextSize = 10
	tabButton.TextWrapped = true
	tabButton.AutoButtonColor = false
	tabButton.ZIndex = 8

	local underline = Instance.new("Frame", tab)
	underline.Name = "Underline"
	underline.Size = UDim2.new(0, 4, 1, -10)
	underline.Position = UDim2.new(1, -4, 0, 5)
	underline.BackgroundColor3 = temaColor
	underline.BorderSizePixel = 0
	underline.Visible = false
	underline.ZIndex = 8

	local underlineCorner = Instance.new("UICorner", underline)
	underlineCorner.CornerRadius = UDim.new(0, 2)

	return tab, tabButton, underline
end

-- ====== CREAR TOGGLE BUTTON ======
local function createToggleButton(text, getState, callback)
	local btn = Instance.new("Frame")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BorderSizePixel = 0
	btn.Parent = scroll
	btn.ZIndex = 8

	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 5)

	local clickButton = Instance.new("TextButton", btn)
	clickButton.Size = UDim2.new(1, 0, 1, 0)
	clickButton.BackgroundTransparency = 1
	clickButton.Text = ""
	clickButton.AutoButtonColor = false
	clickButton.ZIndex = 9

	local stateBox = Instance.new("Frame", btn)
	stateBox.Name = "StateBox"
	stateBox.Size = UDim2.new(0, 16, 0, 16)
	stateBox.Position = UDim2.new(0, 8, 0.5, -8)
	stateBox.BackgroundColor3 = getState() and temaColor or Color3.fromRGB(80, 80, 80)
	stateBox.BorderSizePixel = 0
	stateBox.ZIndex = 9

	local boxCorner = Instance.new("UICorner", stateBox)
	boxCorner.CornerRadius = UDim.new(0, 3)

	local optionText = Instance.new("TextLabel", btn)
	optionText.Size = UDim2.new(1, -30, 1, 0)
	optionText.Position = UDim2.new(0, 28, 0, 0)
	optionText.BackgroundTransparency = 1
	optionText.Text = text
	optionText.TextColor3 = Color3.fromRGB(255, 255, 255)
	optionText.Font = Enum.Font.Gotham
	optionText.TextSize = 12
	optionText.TextXAlignment = Enum.TextXAlignment.Left
	optionText.TextYAlignment = Enum.TextYAlignment.Center
	optionText.ZIndex = 9

	clickButton.MouseButton1Click:Connect(function()
		if callback then callback() end
	end)

	return btn, stateBox, optionText
end

local function updateToggleState(stateBox, enabled)
	stateBox.BackgroundColor3 = enabled and temaColor or Color3.fromRGB(80, 80, 80)
end

-- ====== CREAR BOTÓN NORMAL ======
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 32)
	btn.BackgroundColor3 = temaColor
	btn.BorderSizePixel = 0
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	btn.AutoButtonColor = false
	btn.Parent = scroll
	btn.ZIndex = 8

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 5)
	return btn
end

-- ====== CREAR SLIDER ======
local function createSlider(title, value, minVal, maxVal, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = scroll
	frame.ZIndex = 8

	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 5)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -12, 0, 16)
	label.Position = UDim2.new(0, 6, 0, 6)
	label.Text = title .. " : " .. value
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9

	local sliderBar = Instance.new("Frame", frame)
	sliderBar.Name = "SliderBar"
	sliderBar.Size = UDim2.new(1, -16, 0, 5)
	sliderBar.Position = UDim2.new(0, 8, 0, 30)
	sliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	sliderBar.BorderSizePixel = 0
	sliderBar.ZIndex = 9

	local sbCorner = Instance.new("UICorner", sliderBar)
	sbCorner.CornerRadius = UDim.new(0, 2)

	local fill = Instance.new("Frame", sliderBar)
	fill.Name = "Fill"
	fill.Size = UDim2.new((value - minVal) / math.max(1, (maxVal - minVal)), 0, 1, 0)
	fill.BackgroundColor3 = temaColor
	fill.BorderSizePixel = 0
	fill.ZIndex = 10

	local fillCorner = Instance.new("UICorner", fill)
	fillCorner.CornerRadius = UDim.new(0, 2)

	local handle = Instance.new("Frame", sliderBar)
	handle.Name = "Handle"
	handle.Size = UDim2.new(0, 10, 0, 10)
	handle.AnchorPoint = Vector2.new(0.5, 0.5)
	handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
	handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	handle.BorderSizePixel = 0
	handle.ZIndex = 11

	local handleCorner = Instance.new("UICorner", handle)
	handleCorner.CornerRadius = UDim.new(0, 5)

	local valueDisplay = Instance.new("TextLabel", sliderBar)
	valueDisplay.Name = "ValueDisplay"
	valueDisplay.Size = UDim2.new(0, 30, 0, 12)
	valueDisplay.AnchorPoint = Vector2.new(0.5, 0.5)
	valueDisplay.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
	valueDisplay.BackgroundTransparency = 1
	valueDisplay.Text = tostring(value)
	valueDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
	valueDisplay.Font = Enum.Font.GothamBold
	valueDisplay.TextSize = 9
	valueDisplay.TextXAlignment = Enum.TextXAlignment.Center
	valueDisplay.ZIndex = 11

	local draggingSlider = false
	local sliderConnection
	local currentValue = value

	local function updateSliderValue(inputPos)
		local relativePos = inputPos.X - sliderBar.AbsolutePosition.X
		local barWidth = sliderBar.AbsoluteSize.X
		local percentage = math.clamp(relativePos / barWidth, 0, 1)
		return math.floor(minVal + percentage * (maxVal - minVal))
	end

	local function applyValue(newValue)
		currentValue = newValue
		label.Text = title .. " : " .. newValue
		valueDisplay.Text = tostring(newValue)
		fill.Size = UDim2.new((newValue - minVal) / math.max(1, (maxVal - minVal)), 0, 1, 0)
		handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
		valueDisplay.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
		if callback then callback(newValue) end
	end

	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = true
			if not sliderConnection then
				sliderConnection = UIS.InputChanged:Connect(function(move)
					if not draggingSlider then return end
					if move.UserInputType ~= Enum.UserInputType.MouseMovement and move.UserInputType ~= Enum.UserInputType.Touch then return end
					applyValue(updateSliderValue(move.Position))
				end)
			end
		end
	end)

	sliderBar.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSlider = false
			if sliderConnection then
				sliderConnection:Disconnect()
				sliderConnection = nil
			end
		end
	end)

	return frame, function(val) applyValue(val) end, function() return currentValue end
end

-- ====== CREAR SELECTOR DE COLOR ======
local function createColorPicker(title, defaultColor, callback)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = scroll
	frame.ZIndex = 8

	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 5)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.Text = title
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9

	local colorBox = Instance.new("Frame", frame)
	colorBox.Name = "ColorBox"
	colorBox.Size = UDim2.new(0, 25, 0, 25)
	colorBox.Position = UDim2.new(1, -33, 0.5, -12.5)
	colorBox.BackgroundColor3 = defaultColor
	colorBox.BorderSizePixel = 0
	colorBox.ZIndex = 9

	local boxCorner = Instance.new("UICorner", colorBox)
	boxCorner.CornerRadius = UDim.new(0, 4)

	local colorButton = Instance.new("TextButton", frame)
	colorButton.Size = UDim2.new(1, 0, 1, 0)
	colorButton.BackgroundTransparency = 1
	colorButton.Text = ""
	colorButton.ZIndex = 10

	colorButton.MouseButton1Click:Connect(function()
		local colores = {
			Color3.fromRGB(255, 50, 50),
			Color3.fromRGB(50, 150, 255),
			Color3.fromRGB(50, 255, 50),
			Color3.fromRGB(255, 255, 50),
			Color3.fromRGB(255, 50, 255),
			Color3.fromRGB(255, 150, 50),
			Color3.fromRGB(150, 50, 255),
		}
		local currentIndex = 1
		for i, color in ipairs(colores) do
			if color == temaColor then
				currentIndex = i
				break
			end
		end
		local nextIndex = currentIndex % #colores + 1
		local newColor = colores[nextIndex]
		colorBox.BackgroundColor3 = newColor
		if callback then callback(newColor) end
	end)

	return frame, colorBox
end

-- ====== CREAR SELECTOR DE IDIOMA ======
local function createLanguageSelector()
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	frame.Parent = scroll
	frame.ZIndex = 8

	local frameCorner = Instance.new("UICorner", frame)
	frameCorner.CornerRadius = UDim.new(0, 5)

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, -80, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.Text = T("idioma") .. ":"
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 9

	local currentLang = Instance.new("TextLabel", frame)
	currentLang.Size = UDim2.new(0, 60, 0, 25)
	currentLang.Position = UDim2.new(1, -68, 0.5, -12.5)
	currentLang.BackgroundColor3 = temaColor
	currentLang.Text = T(idiomaActual)
	currentLang.TextColor3 = Color3.fromRGB(255, 255, 255)
	currentLang.Font = Enum.Font.GothamBold
	currentLang.TextSize = 11
	currentLang.ZIndex = 9

	local langCorner = Instance.new("UICorner", currentLang)
	langCorner.CornerRadius = UDim.new(0, 4)

	local langButton = Instance.new("TextButton", frame)
	langButton.Size = UDim2.new(0, 60, 0, 25)
	langButton.Position = UDim2.new(1, -68, 0.5, -12.5)
	langButton.BackgroundTransparency = 1
	langButton.Text = ""
	langButton.ZIndex = 10

	langButton.MouseButton1Click:Connect(function()
		local idiomas = {"español", "ingles", "portugues"}
		local currentIndex = 1
		for i, lang in ipairs(idiomas) do
			if lang == idiomaActual then
				currentIndex = i
				break
			end
		end
		local nextIndex = currentIndex % #idiomas + 1
		idiomaActual = idiomas[nextIndex]
		
		currentLang.Text = T(idiomaActual)
		barraTexto.Text = T("by")
		
		local tabs = {
			{btn = aimbotTabButton, name = "aimbot", emoji = "🎯"},
			{btn = playerTabButton, name = "player", emoji = "👤"},
			{btn = visualesTabButton, name = "esp", emoji = "👁"},
			{btn = mundoTabButton, name = "mundo", emoji = "🌍"},
			{btn = temaTabButton, name = "tema", emoji = "🎨"},
		}
		for _, tab in ipairs(tabs) do
			if tab.btn and tab.btn.Parent then
				tab.btn.Text = tab.emoji .. "\n" .. T(tab.name)
			end
		end
		
		switchTab(lastTab)
		notifyToggle("Idioma cambiado a " .. T(idiomaActual), true)
	end)

	return frame
end

-- ====== CREAR PESTAÑAS ======
local aimbotTab, aimbotTabButton, aimbotUnderline = createTab("aimbot", "🎯")
local playerTab, playerTabButton, playerUnderline = createTab("player", "👤")
local visualesTab, visualesTabButton, visualesUnderline = createTab("esp", "👁")
local mundoTab, mundoTabButton, mundoUnderline = createTab("mundo", "🌍")
local temaTab, temaTabButton, temaUnderline = createTab("tema", "🎨")

local activeTab = "aimbot"
local lastTab = "aimbot"

local buttonReferences = {
	aimbot = {},
	player = {},
	visuales = {},
	mundo = {},
	tema = {}
}

local aimbotSelectorOpen = false

-- ====== PANEL FLOTANTE SELECTOR AIMBOT ======
local aimbotSelectorPanel = Instance.new("Frame", gui)
aimbotSelectorPanel.Name = "AimbotSelectorPanel"
aimbotSelectorPanel.Size = UDim2.new(0, 140, 0, 90)
aimbotSelectorPanel.Position = UDim2.new(0, 400, 0, 200)
aimbotSelectorPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
aimbotSelectorPanel.BorderSizePixel = 0
aimbotSelectorPanel.Visible = false
aimbotSelectorPanel.ZIndex = 20

local selectorCorner = Instance.new("UICorner", aimbotSelectorPanel)
selectorCorner.CornerRadius = UDim.new(0, 6)

local selectorLayout = Instance.new("UIListLayout", aimbotSelectorPanel)
selectorLayout.Padding = UDim.new(0, 3)
selectorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
selectorLayout.VerticalAlignment = Enum.VerticalAlignment.Top
selectorLayout.SortOrder = Enum.SortOrder.LayoutOrder
selectorLayout.FillDirection = Enum.FillDirection.Vertical

local selectorPadding = Instance.new("UIPadding", aimbotSelectorPanel)
selectorPadding.PaddingLeft = UDim.new(0, 4)
selectorPadding.PaddingRight = UDim.new(0, 4)
selectorPadding.PaddingTop = UDim.new(0, 4)
selectorPadding.PaddingBottom = UDim.new(0, 4)

local opciones = {
	{nombre = "Cabeza", valor = "cabeza"},
	{nombre = "Cuello", valor = "cuello"},
	{nombre = "Pecho", valor = "pecho"}
}

for _, opt in pairs(opciones) do
	local optBtn = Instance.new("TextButton", aimbotSelectorPanel)
	optBtn.Size = UDim2.new(1, -8, 0, 24)
	optBtn.BackgroundColor3 = aimbotTarget == opt.valor and temaColor or Color3.fromRGB(60, 60, 60)
	optBtn.BorderSizePixel = 0
	optBtn.Text = opt.nombre
	optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	optBtn.Font = Enum.Font.GothamBold
	optBtn.TextSize = 10
	optBtn.AutoButtonColor = false
	optBtn.ZIndex = 21

	local optCorner = Instance.new("UICorner", optBtn)
	optCorner.CornerRadius = UDim.new(0, 12)

	optBtn.MouseButton1Click:Connect(function()
		aimbotTarget = opt.valor
		for _, child in pairs(aimbotSelectorPanel:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			end
		end
		optBtn.BackgroundColor3 = temaColor
		notifyToggle("Aimbot Target: " .. opt.nombre, true)
	end)
end

-- ====== FUNCIONES DE CARGA DE PESTAÑAS ======

-- CARGA PESTAÑA AIMBOT
local function loadAimbotTab()
	local aimbotFrame, aimbotStateBox, _ = createToggleButton(T("aimbot"), function() return aimbotEnabled end)
	buttonReferences.aimbot.aimbotButton = aimbotFrame
	buttonReferences.aimbot.aimbotStateBox = aimbotStateBox

	aimbotFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		aimbotEnabled = not aimbotEnabled
		updateToggleState(aimbotStateBox, aimbotEnabled)
		notifyToggle(T("aimbot"), aimbotEnabled)
	end)

	local selectorBtn = Instance.new("TextButton", scroll)
	selectorBtn.Size = UDim2.new(1, 0, 0, 32)
	selectorBtn.BackgroundColor3 = temaColor
	selectorBtn.BorderSizePixel = 0
	selectorBtn.Text = T("selector")
	selectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	selectorBtn.Font = Enum.Font.GothamBold
	selectorBtn.TextSize = 12
	selectorBtn.AutoButtonColor = false
	selectorBtn.ZIndex = 8
	Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 5)

	selectorBtn.MouseButton1Click:Connect(function()
		aimbotSelectorOpen = not aimbotSelectorOpen
		aimbotSelectorPanel.Visible = aimbotSelectorOpen
		selectorBtn.Text = aimbotSelectorOpen and "Selector ▲" or T("selector")
		local absPos = panel.AbsolutePosition
		local absSize = panel.AbsoluteSize
		aimbotSelectorPanel.Position = UDim2.new(0, absPos.X + absSize.X + 5, 0, absPos.Y + 100)
	end)

	createSlider(T("suavizado"), aimbotSmooth, 1, 20, function(val)
		aimbotSmooth = val
	end)

	local aimbotTypeFrame = Instance.new("Frame")
	aimbotTypeFrame.Size = UDim2.new(1, 0, 0, 35)
	aimbotTypeFrame.BackgroundTransparency = 1
	aimbotTypeFrame.Parent = scroll
	aimbotTypeFrame.ZIndex = 8

	local aimbotVisibleBtn = Instance.new("TextButton", aimbotTypeFrame)
	aimbotVisibleBtn.Size = UDim2.new(0.45, 0, 0, 25)
	aimbotVisibleBtn.Position = UDim2.new(0, 0, 0, 0)
	aimbotVisibleBtn.BackgroundColor3 = aimbotVisible and temaColor or Color3.fromRGB(60, 60, 60)
	aimbotVisibleBtn.Text = T("visible")
	aimbotVisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	aimbotVisibleBtn.BorderSizePixel = 0
	aimbotVisibleBtn.Font = Enum.Font.GothamBold
	aimbotVisibleBtn.TextSize = 11
	aimbotVisibleBtn.AutoButtonColor = false
	aimbotVisibleBtn.ZIndex = 9
	Instance.new("UICorner", aimbotVisibleBtn).CornerRadius = UDim.new(0, 5)

	local aimbotNormalBtn = Instance.new("TextButton", aimbotTypeFrame)
	aimbotNormalBtn.Size = UDim2.new(0.45, 0, 0, 25)
	aimbotNormalBtn.Position = UDim2.new(0.55, 0, 0, 0)
	aimbotNormalBtn.BackgroundColor3 = not aimbotVisible and temaColor or Color3.fromRGB(60, 60, 60)
	aimbotNormalBtn.Text = T("normal")
	aimbotNormalBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	aimbotNormalBtn.BorderSizePixel = 0
	aimbotNormalBtn.Font = Enum.Font.GothamBold
	aimbotNormalBtn.TextSize = 11
	aimbotNormalBtn.AutoButtonColor = false
	aimbotNormalBtn.ZIndex = 9
	Instance.new("UICorner", aimbotNormalBtn).CornerRadius = UDim.new(0, 5)

	aimbotVisibleBtn.MouseButton1Click:Connect(function()
		aimbotVisible = true
		aimbotVisibleBtn.BackgroundColor3 = temaColor
		aimbotNormalBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)

	aimbotNormalBtn.MouseButton1Click:Connect(function()
		aimbotVisible = false
		aimbotNormalBtn.BackgroundColor3 = temaColor
		aimbotVisibleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)

	createSlider(T("aimFov"), aimbotFOV, minFOV, maxFOV, function(val)
		aimbotFOV = val
	end)

	local teamCheckFrame, teamCheckStateBox, _ = createToggleButton(T("teamCheck"), function() return aimbotTeamCheck end)
	buttonReferences.aimbot.teamCheckButton = teamCheckFrame
	buttonReferences.aimbot.teamCheckStateBox = teamCheckStateBox

	teamCheckFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		aimbotTeamCheck = not aimbotTeamCheck
		updateToggleState(teamCheckStateBox, aimbotTeamCheck)
		notifyToggle(T("teamCheck"), aimbotTeamCheck)
	end)

	local fovCircleFrame, fovCircleStateBox, _ = createToggleButton(T("drawFov"), function() return drawFOVCircle end)
	buttonReferences.aimbot.fovCircleButton = fovCircleFrame
	buttonReferences.aimbot.fovCircleStateBox = fovCircleStateBox

	fovCircleFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		drawFOVCircle = not drawFOVCircle
		updateToggleState(fovCircleStateBox, drawFOVCircle)
		notifyToggle(T("drawFov"), drawFOVCircle)
	end)
end

-- CARGA PESTAÑA PLAYER
local function loadPlayerTab()
	local flyToggleFrame, flyStateBox, _ = createToggleButton(T("fly"), function() return flying end)
	buttonReferences.player.flyButton = flyToggleFrame
	buttonReferences.player.flyStateBox = flyStateBox

	flyToggleFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		flying = not flying
		updateToggleState(flyStateBox, flying)
		notifyToggle(T("fly"), flying)
		if not flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			player.Character.HumanoidRootPart.Velocity = Vector3.zero
		end
	end)

	createSlider(T("flySpeed"), flySpeed, minValue, maxValue, function(val) flySpeed = val end)

	local speedToggleFrame, speedStateBox, _ = createToggleButton(T("speed"), function() return speedEnabled end)
	buttonReferences.player.speedButton = speedToggleFrame
	buttonReferences.player.speedStateBox = speedStateBox

	speedToggleFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		speedEnabled = not speedEnabled
		updateToggleState(speedStateBox, speedEnabled)
		notifyToggle(T("speed"), speedEnabled)
		if not speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = 16
		end
	end)

	createSlider(T("walkSpeed"), walkSpeed, minValue, maxValue, function(val) walkSpeed = val end)

	local noclipFrame, noclipStateBox, _ = createToggleButton(T("noclip"), function() return noclipEnabled end)
	buttonReferences.player.noclipButton = noclipFrame
	buttonReferences.player.noclipStateBox = noclipStateBox

	noclipFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		noclipEnabled = not noclipEnabled
		updateToggleState(noclipStateBox, noclipEnabled)
		notifyToggle(T("noclip"), noclipEnabled)
		if not noclipEnabled and player.Character then
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end)

	local jumpFrame, jumpStateBox, _ = createToggleButton(T("infiniteJump"), function() return infiniteJumpEnabled end)
	buttonReferences.player.jumpButton = jumpFrame
	buttonReferences.player.jumpStateBox = jumpStateBox

	jumpFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		infiniteJumpEnabled = not infiniteJumpEnabled
		updateToggleState(jumpStateBox, infiniteJumpEnabled)
		notifyToggle(T("infiniteJump"), infiniteJumpEnabled)
	end)
end

-- FUNCIONES DE DIBUJO ESP
local function drawESPBox(plr)
	if not plr.Character then return end
	local root = plr.Character:FindFirstChild("HumanoidRootPart")
	local head = plr.Character:FindFirstChild("Head")
	if not root or not head then return end

	local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
	local headPos, _ = camera:WorldToViewportPoint(head.Position)

	if not onScreen then
		if espBoxes[plr] then
			for _, line in pairs(espBoxes[plr]) do line.Visible = false end
		end
		return
	end

	local height = math.abs(headPos.Y - rootPos.Y) * 2.8
	local width = height * 0.75

	if not espBoxes[plr] then
		local box = {}
		for i = 1, 4 do
			local line = Drawing.new("Line")
			line.Thickness = 1
			line.Color = colorActual
			line.Visible = espBoxEnabled
			table.insert(box, line)
		end
		espBoxes[plr] = box
	end

	local box = espBoxes[plr]
	local centerX = rootPos.X
	local centerY = rootPos.Y - height / 2

	box[1].From = Vector2.new(centerX - width/2, centerY)
	box[1].To   = Vector2.new(centerX + width/2, centerY)
	box[2].From = Vector2.new(centerX + width/2, centerY)
	box[2].To   = Vector2.new(centerX + width/2, centerY + height)
	box[3].From = Vector2.new(centerX + width/2, centerY + height)
	box[3].To   = Vector2.new(centerX - width/2, centerY + height)
	box[4].From = Vector2.new(centerX - width/2, centerY + height)
	box[4].To   = Vector2.new(centerX - width/2, centerY)

	for _, line in pairs(box) do
		line.Color = colorActual
		line.Visible = espBoxEnabled
	end
end

local function drawESPLine(plr)
	if not plr.Character then return end
	local root = plr.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)

	if not espLines[plr] then
		local line = Drawing.new("Line")
		line.Thickness = 1
		line.Color = colorActual
		line.Visible = espLineEnabled and onScreen
		espLines[plr] = line
	end

	local line = espLines[plr]
	line.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
	line.To = Vector2.new(rootPos.X, rootPos.Y)
	line.Color = colorActual
	line.Visible = espLineEnabled and onScreen
end

-- ESP NOMBRE
local function drawESPName(plr)
	if not plr.Character then return end
	local head = plr.Character:FindFirstChild("Head")
	if not head then return end

	local headPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))

	if not espNameLabels[plr] then
		local lbl = Drawing.new("Text")
		lbl.Size = 14
		lbl.Font = Drawing.Fonts.UI
		lbl.Color = Color3.fromRGB(255, 255, 255)
		lbl.Outline = true
		lbl.OutlineColor = Color3.fromRGB(0, 0, 0)
		lbl.Center = true
		lbl.Visible = false
		espNameLabels[plr] = lbl
	end

	local lbl = espNameLabels[plr]
	lbl.Text = plr.Name
	lbl.Position = Vector2.new(headPos.X, headPos.Y - 18)
	lbl.Color = colorActual
	lbl.Visible = espNameEnabled and onScreen
end

-- ESP Health Bar
local function drawESPHealthBar(plr)
	if not plr.Character then return end
	local root = plr.Character:FindFirstChild("HumanoidRootPart")
	local head = plr.Character:FindFirstChild("Head")
	local humanoid = plr.Character:FindFirstChild("Humanoid")
	if not root or not head or not humanoid then return end

	local rootPos, onScreen = camera:WorldToViewportPoint(root.Position)
	local headPos, _ = camera:WorldToViewportPoint(head.Position)

	if not onScreen then
		if espHealthBars[plr] then
			for _, line in pairs(espHealthBars[plr]) do line.Visible = false end
		end
		return
	end

	local height = math.abs(headPos.Y - rootPos.Y) * 2.8
	local width = height * 0.75
	local healthPercent = humanoid.Health / humanoid.MaxHealth
	local healthColor = Color3.fromRGB(255 - (255 * healthPercent), 255 * healthPercent, 0)

	if not espHealthBars[plr] then
		local bar = {}
		local bgLine = Drawing.new("Line")
		bgLine.Thickness = 3
		bgLine.Color = Color3.fromRGB(30, 30, 30)
		bgLine.Visible = false
		table.insert(bar, bgLine)
		
		local healthLine = Drawing.new("Line")
		healthLine.Thickness = 3
		healthLine.Color = healthColor
		healthLine.Visible = false
		table.insert(bar, healthLine)
		
		espHealthBars[plr] = bar
	end

	local bar = espHealthBars[plr]
	local centerX = rootPos.X
	local centerY = rootPos.Y - height / 2
	
	local barX = centerX - width/2
	local barY = centerY - 10
	
	bar[1].From = Vector2.new(barX, barY)
	bar[1].To = Vector2.new(barX + width, barY)
	bar[1].Visible = espHealthBarEnabled
	
	bar[2].From = Vector2.new(barX, barY)
	bar[2].To = Vector2.new(barX + (width * healthPercent), barY)
	bar[2].Color = healthColor
	bar[2].Visible = espHealthBarEnabled
end

-- ESP SKELETON
local skeletonR15 = {
	{"Head",       "UpperTorso"},
	{"UpperTorso", "LowerTorso"},
	{"UpperTorso",    "LeftUpperArm"},
	{"LeftUpperArm",  "LeftLowerArm"},
	{"LeftLowerArm",  "LeftHand"},
	{"UpperTorso",     "RightUpperArm"},
	{"RightUpperArm",  "RightLowerArm"},
	{"RightLowerArm",  "RightHand"},
	{"LowerTorso",    "LeftUpperLeg"},
	{"LeftUpperLeg",  "LeftLowerLeg"},
	{"LeftLowerLeg",  "LeftFoot"},
	{"LowerTorso",     "RightUpperLeg"},
	{"RightUpperLeg",  "RightLowerLeg"},
	{"RightLowerLeg",  "RightFoot"},
}

local skeletonR6 = {
	{"Head",    "Torso"},
	{"Torso",   "Left Arm"},
	{"Torso",   "Right Arm"},
	{"Torso",   "Left Leg"},
	{"Torso",   "Right Leg"},
}

local function getSkeletonConnections(character)
	if character:FindFirstChild("UpperTorso") then
		return skeletonR15
	else
		return skeletonR6
	end
end

local function drawESPSkeleton(plr)
	if not plr.Character then return end
	if not espSkeletonLines[plr] then espSkeletonLines[plr] = {} end

	local connections = getSkeletonConnections(plr.Character)
	local lineIndex = 1

	for _, pair in ipairs(connections) do
		local partA = plr.Character:FindFirstChild(pair[1])
		local partB = plr.Character:FindFirstChild(pair[2])

		if partA and partB then
			local posA, onA = camera:WorldToViewportPoint(partA.Position)
			local posB, onB = camera:WorldToViewportPoint(partB.Position)
			local visible = espSkeletonEnabled and onA and onB and posA.Z > 0 and posB.Z > 0

			if not espSkeletonLines[plr][lineIndex] then
				local line = Drawing.new("Line")
				line.Thickness = 2
				line.Transparency = 1
				line.Visible = false
				espSkeletonLines[plr][lineIndex] = line
			end

			local line = espSkeletonLines[plr][lineIndex]
			line.From  = Vector2.new(posA.X, posA.Y)
			line.To    = Vector2.new(posB.X, posB.Y)
			line.Color = colorActual
			line.Visible = visible
			lineIndex = lineIndex + 1
		end
	end

	for i = lineIndex, #espSkeletonLines[plr] do
		if espSkeletonLines[plr][i] then
			espSkeletonLines[plr][i].Visible = false
		end
	end
end

-- HITBOX
local function aplicarHitboxACharacter(character)
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if not hrp:FindFirstChild("EMZ_HitboxRestore") then
		local tag = Instance.new("Configuration")
		tag.Name = "EMZ_HitboxRestore"
		tag:SetAttribute("X", hrp.Size.X)
		tag:SetAttribute("Y", hrp.Size.Y)
		tag:SetAttribute("Z", hrp.Size.Z)
		tag.Parent = hrp
	end

	hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
	hrp.Color = Color3.fromRGB(0, 0, 0)
	hrp.Material = Enum.Material.Neon
	hrp.Transparency = hitboxTransparency
	hrp.CastShadow = false
	hrp.CanCollide = false
end

local function restaurarHitboxDeCharacter(character)
	if not character then return end
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local orig = hrp:FindFirstChild("EMZ_HitboxRestore")
	if orig then
		hrp.Size = Vector3.new(orig:GetAttribute("X"), orig:GetAttribute("Y"), orig:GetAttribute("Z"))
		orig:Destroy()
	end
	hrp.Transparency = 1
	hrp.Material = Enum.Material.Plastic
	hrp.CanCollide = false
end

-- HITBOX: conectar respawn
local function conectarRespawnHitbox(plr)
	if hitboxRespawnConnections[plr] then
		hitboxRespawnConnections[plr]:Disconnect()
		hitboxRespawnConnections[plr] = nil
	end

	hitboxRespawnConnections[plr] = plr.CharacterAdded:Connect(function(newCharacter)
		if not hitboxEnabled then return end
		newCharacter:WaitForChild("HumanoidRootPart", 5)
		task.wait(0.2)
		aplicarHitboxACharacter(newCharacter)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	if plr ~= player then
		conectarRespawnHitbox(plr)
	end
end)

Players.PlayerRemoving:Connect(function(plr)
	if hitboxRespawnConnections[plr] then
		hitboxRespawnConnections[plr]:Disconnect()
		hitboxRespawnConnections[plr] = nil
	end
end)

for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= player then
		conectarRespawnHitbox(plr)
	end
end

local function limpiarESPObsoleto()
	local jugadoresValidos = {}
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			jugadoresValidos[plr] = true
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and not jugadoresValidos[plr] then
			if plr.Character:FindFirstChild("EMZ_ESP") then plr.Character.EMZ_ESP:Destroy() end
			if plr.Character:FindFirstChild("EMZ_ESP_ENEMY") then plr.Character.EMZ_ESP_ENEMY:Destroy() end
		end
	end

	for plr, box in pairs(espBoxes) do
		if not jugadoresValidos[plr] then
			for _, line in pairs(box) do line:Remove() end
			espBoxes[plr] = nil
		end
	end
	for plr, line in pairs(espLines) do
		if not jugadoresValidos[plr] then line:Remove(); espLines[plr] = nil end
	end
	for plr, lbl in pairs(espNameLabels) do
		if not jugadoresValidos[plr] then lbl:Remove(); espNameLabels[plr] = nil end
	end
	for plr, lines in pairs(espSkeletonLines) do
		if not jugadoresValidos[plr] then
			for _, line in pairs(lines) do line:Remove() end
			espSkeletonLines[plr] = nil
		end
	end
	for plr, bar in pairs(espHealthBars) do
		if not jugadoresValidos[plr] then
			for _, line in pairs(bar) do line:Remove() end
			espHealthBars[plr] = nil
		end
	end
end

-- CARGA PESTAÑA ESP
local function loadVisualesTab()
	local espBodyFrame, espBodyStateBox, _ = createToggleButton(T("espCuerpo"), function() return espBodyEnabled end)
	buttonReferences.visuales.espBodyButton = espBodyFrame
	buttonReferences.visuales.espBodyStateBox = espBodyStateBox
	espBodyFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espBodyEnabled = not espBodyEnabled
		updateToggleState(espBodyStateBox, espBodyEnabled)
		notifyToggle(T("espCuerpo"), espBodyEnabled)
		if not espBodyEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("EMZ_ESP") then
					plr.Character.EMZ_ESP:Destroy()
				end
			end
		end
	end)

	local espEnemyFrame, espEnemyStateBox, _ = createToggleButton(T("espEnemigos"), function() return espEnemyEnabled end)
	buttonReferences.visuales.espEnemyButton = espEnemyFrame
	buttonReferences.visuales.espEnemyStateBox = espEnemyStateBox
	espEnemyFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espEnemyEnabled = not espEnemyEnabled
		updateToggleState(espEnemyStateBox, espEnemyEnabled)
		notifyToggle(T("espEnemigos"), espEnemyEnabled)
		enemyCountDisplay.Visible = espEnemyEnabled
		if not espEnemyEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character and plr.Character:FindFirstChild("EMZ_ESP_ENEMY") then
					plr.Character.EMZ_ESP_ENEMY:Destroy()
				end
			end
			enemyCountDisplay.Visible = false
		end
	end)

	local espNameFrame, espNameStateBox, _ = createToggleButton(T("espNombre"), function() return espNameEnabled end)
	buttonReferences.visuales.espNameStateBox = espNameStateBox
	espNameFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espNameEnabled = not espNameEnabled
		updateToggleState(espNameStateBox, espNameEnabled)
		notifyToggle(T("espNombre"), espNameEnabled)
		if not espNameEnabled then
			for _, lbl in pairs(espNameLabels) do lbl.Visible = false end
		end
	end)

	local espSkelFrame, espSkelStateBox, _ = createToggleButton(T("espSkeleton"), function() return espSkeletonEnabled end)
	buttonReferences.visuales.espSkelStateBox = espSkelStateBox
	espSkelFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espSkeletonEnabled = not espSkeletonEnabled
		updateToggleState(espSkelStateBox, espSkeletonEnabled)
		notifyToggle(T("espSkeleton"), espSkeletonEnabled)
		if not espSkeletonEnabled then
			for _, lines in pairs(espSkeletonLines) do
				for _, line in pairs(lines) do line.Visible = false end
			end
		end
	end)

	local espBoxFrame, espBoxStateBox, _ = createToggleButton(T("espBox"), function() return espBoxEnabled end)
	buttonReferences.visuales.espBoxButton = espBoxFrame
	buttonReferences.visuales.espBoxStateBox = espBoxStateBox
	espBoxFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espBoxEnabled = not espBoxEnabled
		updateToggleState(espBoxStateBox, espBoxEnabled)
		notifyToggle(T("espBox"), espBoxEnabled)
		if not espBoxEnabled then
			for _, box in pairs(espBoxes) do
				for _, line in pairs(box) do line.Visible = false; line:Remove() end
			end
			espBoxes = {}
		end
	end)

	local espLineFrame, espLineStateBox, _ = createToggleButton(T("espLinea"), function() return espLineEnabled end)
	buttonReferences.visuales.espLineButton = espLineFrame
	buttonReferences.visuales.espLineStateBox = espLineStateBox
	espLineFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espLineEnabled = not espLineEnabled
		updateToggleState(espLineStateBox, espLineEnabled)
		notifyToggle(T("espLinea"), espLineEnabled)
		if not espLineEnabled then
			for _, line in pairs(espLines) do line.Visible = false; line:Remove() end
			espLines = {}
		end
	end)

	local espHealthFrame, espHealthStateBox, _ = createToggleButton(T("espHealth"), function() return espHealthBarEnabled end)
	buttonReferences.visuales.espHealthButton = espHealthFrame
	buttonReferences.visuales.espHealthStateBox = espHealthStateBox
	espHealthFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		espHealthBarEnabled = not espHealthBarEnabled
		updateToggleState(espHealthStateBox, espHealthBarEnabled)
		notifyToggle(T("espHealth"), espHealthBarEnabled)
		if not espHealthBarEnabled then
			for _, bar in pairs(espHealthBars) do
				for _, line in pairs(bar) do line.Visible = false end
			end
		end
	end)
end

-- CARGA PESTAÑA MUNDO
local function loadMundoTab()
	local fbFrame, fbStateBox, _ = createToggleButton(T("fullbright"), function() return fullbrightEnabled end)
	buttonReferences.mundo.fbStateBox = fbStateBox
	fbFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		fullbrightEnabled = not fullbrightEnabled
		updateToggleState(fbStateBox, fullbrightEnabled)
		notifyToggle(T("fullbright"), fullbrightEnabled)
		if fullbrightEnabled then
			originalBrightness = Lighting.Brightness
			originalAmbient = Lighting.Ambient
			Lighting.Brightness = 10
			Lighting.Ambient = Color3.fromRGB(178, 178, 178)
			Lighting.OutdoorAmbient = Color3.fromRGB(178, 178, 178)
			Lighting.FogEnd = 100000
			Lighting.FogStart = 99999
		else
			if originalBrightness then Lighting.Brightness = originalBrightness end
			if originalAmbient then
				Lighting.Ambient = originalAmbient
				Lighting.OutdoorAmbient = originalAmbient
			end
		end
	end)

	local fogFrame, fogStateBox, _ = createToggleButton(T("removeFog"), function() return removeFogEnabled end)
	buttonReferences.mundo.fogStateBox = fogStateBox
	fogFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		removeFogEnabled = not removeFogEnabled
		updateToggleState(fogStateBox, removeFogEnabled)
		notifyToggle(T("removeFog"), removeFogEnabled)
		if removeFogEnabled then
			originalFog = {Lighting.FogEnd, Lighting.FogStart}
			Lighting.FogEnd = 100000
			Lighting.FogStart = 99999
		else
			if originalFog then
				Lighting.FogEnd = originalFog[1]
				Lighting.FogStart = originalFog[2]
			end
		end
	end)

	local lagFrame, lagStateBox, _ = createToggleButton(T("antiLag"), function() return antiLagEnabled end)
	buttonReferences.mundo.lagStateBox = lagStateBox
	lagFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		antiLagEnabled = not antiLagEnabled
		updateToggleState(lagStateBox, antiLagEnabled)
		notifyToggle(T("antiLag"), antiLagEnabled)
		if antiLagEnabled then
			for _, obj in pairs(workspace:GetDescendants()) do
				pcall(function()
					if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
						obj.Enabled = false
					end
					if obj:IsA("BasePart") then obj.CastShadow = false end
				end)
			end
			pcall(function()
				for _, effect in pairs(Lighting:GetChildren()) do
					if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
						effect.Enabled = false
					end
				end
			end)
		else
			for _, obj in pairs(workspace:GetDescendants()) do
				pcall(function()
					if obj:IsA("ParticleEmitter") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
						obj.Enabled = true
					end
					if obj:IsA("BasePart") then obj.CastShadow = true end
				end)
			end
			pcall(function()
				for _, effect in pairs(Lighting:GetChildren()) do
					if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
						effect.Enabled = true
					end
				end
			end)
		end
	end)

	local hitboxFrame, hitboxStateBox, _ = createToggleButton(T("hitbox"), function() return hitboxEnabled end)
	buttonReferences.mundo.hitboxStateBox = hitboxStateBox
	hitboxFrame:FindFirstChildOfClass("TextButton").MouseButton1Click:Connect(function()
		hitboxEnabled = not hitboxEnabled
		updateToggleState(hitboxStateBox, hitboxEnabled)
		notifyToggle(T("hitbox"), hitboxEnabled)
		if hitboxEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					aplicarHitboxACharacter(plr.Character)
				end
			end
		else
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					restaurarHitboxDeCharacter(plr.Character)
				end
			end
		end
	end)

	createSlider(T("tamano"), hitboxSize, 1, 50, function(val)
		hitboxSize = val
		if hitboxEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
					if hrp then hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize) end
				end
			end
		end
	end)

	createSlider(T("transparencia"), hitboxTransparency * 100, 0, 100, function(val)
		hitboxTransparency = val / 100
		if hitboxEnabled then
			for _, plr in pairs(Players:GetPlayers()) do
				if plr ~= player and plr.Character then
					local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
					if hrp then hrp.Transparency = hitboxTransparency end
				end
			end
		end
	end)
end

-- CARGA PESTAÑA TEMA
local function loadTemaTab()
	local colorFrame, colorBox = createColorPicker(T("colorTema"), temaColor, function(newColor)
		temaColor = newColor
		barraSuperior.BackgroundColor3 = temaColor
		tabContainer.ScrollBarImageColor3 = temaColor
		scroll.ScrollBarImageColor3 = temaColor
		aimbotUnderline.BackgroundColor3 = temaColor
		playerUnderline.BackgroundColor3 = temaColor
		visualesUnderline.BackgroundColor3 = temaColor
		mundoUnderline.BackgroundColor3 = temaColor
		temaUnderline.BackgroundColor3 = temaColor
		
		for _, ref in pairs(buttonReferences) do
			if ref.aimbotStateBox then updateToggleState(ref.aimbotStateBox, aimbotEnabled) end
			if ref.flyStateBox then updateToggleState(ref.flyStateBox, flying) end
			if ref.speedStateBox then updateToggleState(ref.speedStateBox, speedEnabled) end
			if ref.noclipStateBox then updateToggleState(ref.noclipStateBox, noclipEnabled) end
			if ref.jumpStateBox then updateToggleState(ref.jumpStateBox, infiniteJumpEnabled) end
			if ref.espBodyStateBox then updateToggleState(ref.espBodyStateBox, espBodyEnabled) end
			if ref.espEnemyStateBox then updateToggleState(ref.espEnemyStateBox, espEnemyEnabled) end
			if ref.espNameStateBox then updateToggleState(ref.espNameStateBox, espNameEnabled) end
			if ref.espSkelStateBox then updateToggleState(ref.espSkelStateBox, espSkeletonEnabled) end
			if ref.espBoxStateBox then updateToggleState(ref.espBoxStateBox, espBoxEnabled) end
			if ref.espLineStateBox then updateToggleState(ref.espLineStateBox, espLineEnabled) end
			if ref.espHealthStateBox then updateToggleState(ref.espHealthStateBox, espHealthBarEnabled) end
			if ref.fbStateBox then updateToggleState(ref.fbStateBox, fullbrightEnabled) end
			if ref.fogStateBox then updateToggleState(ref.fogStateBox, removeFogEnabled) end
			if ref.lagStateBox then updateToggleState(ref.lagStateBox, antiLagEnabled) end
			if ref.hitboxStateBox then updateToggleState(ref.hitboxStateBox, hitboxEnabled) end
			if ref.teamCheckStateBox then updateToggleState(ref.teamCheckStateBox, aimbotTeamCheck) end
			if ref.fovCircleStateBox then updateToggleState(ref.fovCircleStateBox, drawFOVCircle) end
		end
		
		for _, child in pairs(aimbotSelectorPanel:GetChildren()) do
			if child:IsA("TextButton") and child.Text == "Cabeza" and aimbotTarget == "cabeza" then
				child.BackgroundColor3 = temaColor
			elseif child:IsA("TextButton") and child.Text == "Cuello" and aimbotTarget == "cuello" then
				child.BackgroundColor3 = temaColor
			elseif child:IsA("TextButton") and child.Text == "Pecho" and aimbotTarget == "pecho" then
				child.BackgroundColor3 = temaColor
			end
		end
		
		notifyToggle("Tema cambiado", true)
	end)
	
	local sizeSlider, setSize, getSize = createSlider(T("tamanoPanel"), panelSize, 250, 400, function(val)
		panelSize = val
		local nuevoAlto = BARRA_ALTO + PANEL_ALTO_BASE * (val / 300)
		mainContainer.Size = UDim2.new(0, panelSize, 0, nuevoAlto)
	end)
	
	local langSelector = createLanguageSelector()
end

-- switchTab
local function switchTab(tabName)
	activeTab = tabName
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("GuiObject") then child:Destroy() end
	end

	aimbotUnderline.Visible = false
	playerUnderline.Visible = false
	visualesUnderline.Visible = false
	mundoUnderline.Visible = false
	temaUnderline.Visible = false

	if tabName == "aimbot" then
		loadAimbotTab()
		aimbotUnderline.Visible = true
	elseif tabName == "player" then
		loadPlayerTab()
		playerUnderline.Visible = true
	elseif tabName == "visuales" then
		loadVisualesTab()
		visualesUnderline.Visible = true
	elseif tabName == "mundo" then
		loadMundoTab()
		mundoUnderline.Visible = true
	elseif tabName == "tema" then
		loadTemaTab()
		temaUnderline.Visible = true
	end

	local spacer = Instance.new("Frame")
	spacer.Size = UDim2.new(1, 0, 0, 6)
	spacer.BackgroundTransparency = 1
	spacer.Parent = scroll
	spacer.ZIndex = 8

	local resetButton = createButton(T("resetAll"))
	resetButton.BackgroundColor3 = temaColor
	resetButton.MouseButton1Click:Connect(function()
		flying = false; speedEnabled = false; noclipEnabled = false
		infiniteJumpEnabled = false; espBodyEnabled = false; espEnemyEnabled = false
		espBoxEnabled = false; espLineEnabled = false; espNameEnabled = false
		espSkeletonEnabled = false; espHealthBarEnabled = false
		aimbotEnabled = false; aimbotVisible = false; aimbotTeamCheck = false
		aimbotFOV = 50; aimbotTarget = "cabeza"
		aimbotSmooth = 1; aimbotSelectorOpen = false; drawFOVCircle = true
		aimbotSelectorPanel.Visible = false
		fullbrightEnabled = false; removeFogEnabled = false
		antiLagEnabled = false; hitboxEnabled = false
		hitboxSize = 5; hitboxTransparency = 0.4
		panelSize = 300; temaColor = Color3.fromRGB(255, 50, 50)
		idiomaActual = "español"
		enemyCountDisplay.Visible = false

		notifyToggle("Reset All", false)

		if player.Character then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then hum.WalkSpeed = 16 end
			for _, part in pairs(player.Character:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end

		pcall(function()
			if originalBrightness then Lighting.Brightness = originalBrightness end
			if originalAmbient then Lighting.Ambient = originalAmbient; Lighting.OutdoorAmbient = originalAmbient end
			if originalFog then Lighting.FogEnd = originalFog[1]; Lighting.FogStart = originalFog[2] end
			for _, effect in pairs(Lighting:GetChildren()) do
				if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect") or effect:IsA("DepthOfFieldEffect") then
					effect.Enabled = true
				end
			end
		end)

		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character then
				if plr.Character:FindFirstChild("EMZ_ESP") then plr.Character.EMZ_ESP:Destroy() end
				if plr.Character:FindFirstChild("EMZ_ESP_ENEMY") then plr.Character.EMZ_ESP_ENEMY:Destroy() end
				restaurarHitboxDeCharacter(plr.Character)
			end
		end

		for _, box in pairs(espBoxes) do
			for _, line in pairs(box) do line:Remove() end
		end
		espBoxes = {}
		for _, line in pairs(espLines) do line:Remove() end
		espLines = {}
		for _, lbl in pairs(espNameLabels) do lbl:Remove() end
		espNameLabels = {}
		for _, lines in pairs(espSkeletonLines) do
			for _, line in pairs(lines) do line:Remove() end
		end
		espSkeletonLines = {}
		for _, bar in pairs(espHealthBars) do
			for _, line in pairs(bar) do line:Remove() end
		end
		espHealthBars = {}

		mainContainer.Size = UDim2.new(0, panelSize, 0, BARRA_ALTO + PANEL_ALTO_BASE)
		barraSuperior.BackgroundColor3 = temaColor
		tabContainer.ScrollBarImageColor3 = temaColor
		scroll.ScrollBarImageColor3 = temaColor

		switchTab(lastTab)
	end)
end

-- CONEXIONES DE PESTAÑAS
aimbotTabButton.MouseButton1Click:Connect(function()
	lastTab = "aimbot"; switchTab("aimbot")
end)
playerTabButton.MouseButton1Click:Connect(function()
	lastTab = "player"; switchTab("player")
end)
visualesTabButton.MouseButton1Click:Connect(function()
	lastTab = "visuales"; switchTab("visuales")
end)
mundoTabButton.MouseButton1Click:Connect(function()
	lastTab = "mundo"; switchTab("mundo")
end)
temaTabButton.MouseButton1Click:Connect(function()
	lastTab = "tema"; switchTab("tema")
end)

-- FUNCIONES AIMBOT
local function isTargetVisible(cameraPosition, targetPosition)
	local direction = targetPosition - cameraPosition
	local distance = direction.Magnitude
	if distance == 0 then return false end
	local ray = Ray.new(cameraPosition, direction.Unit * distance)
	local hitPart, _ = workspace:FindPartOnRay(ray, player.Character)
	if hitPart == nil then return true end
	if hitPart:IsDescendantOf(player.Character) then return true end
	if hitPart.Parent and hitPart.Parent:FindFirstChild("Humanoid") then return true end
	return false
end

local function isInFOV(playerPos, targetPos, fovAngle)
	local cameraDirection = camera.CFrame.LookVector
	local toTarget = (targetPos - playerPos).Unit
	local dotProduct = cameraDirection:Dot(toTarget)
	local fovCosine = math.cos(math.rad(fovAngle / 2))
	return dotProduct >= fovCosine
end

local function getAimbotTargetPart(character)
	if aimbotTarget == "cabeza" then
		return character:FindFirstChild("Head")
	elseif aimbotTarget == "cuello" then
		local head = character:FindFirstChild("Head")
		local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
		if head and torso then
			local neckPart = Instance.new("Part")
			neckPart.Transparency = 1
			neckPart.CanCollide = false
			neckPart.Position = (head.Position + torso.Position) / 2
			return neckPart
		end
		return head
	elseif aimbotTarget == "pecho" then
		return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	end
	return character:FindFirstChild("Head")
end

local function updateESPBody()
	if not espBodyEnabled then return end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			local highlight = plr.Character:FindFirstChild("EMZ_ESP")
			if highlight then
				highlight.FillColor = colorActual
				highlight.OutlineColor = colorActual
			else
				local h = Instance.new("Highlight")
				h.Name = "EMZ_ESP"
				h.FillColor = colorActual
				h.OutlineColor = colorActual
				h.FillTransparency = 0.3
				h.OutlineTransparency = 0
				h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				h.Parent = plr.Character
			end
		end
	end
end

local fovCircle = nil
local function updateFOVCircle()
	if aimbotEnabled and drawFOVCircle then
		if not fovCircle then
			fovCircle = Drawing.new("Circle")
			fovCircle.Thickness = 2
			fovCircle.NumSides = 60
			fovCircle.Radius = aimbotFOV * 2
			fovCircle.Filled = false
			fovCircle.Color = temaColor
			fovCircle.Visible = true
			fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
		else
			fovCircle.Radius = aimbotFOV * 2
			fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
			fovCircle.Color = temaColor
			fovCircle.Visible = true
		end
	else
		if fovCircle then
			fovCircle.Visible = false
			fovCircle:Remove()
			fovCircle = nil
		end
	end
end

-- AIMBOT LOOP
local function getClosestAimbotTarget()
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
	local closestPlayer = nil
	local closestDistance = math.huge
	
	local myTeam = player.Team
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
			
			if aimbotTeamCheck and myTeam and plr.Team == myTeam then
				continue
			end
			
			local targetPart = getAimbotTargetPart(plr.Character)
			if targetPart then
				local targetPos = targetPart.Position
				local distance = (targetPos - player.Character.HumanoidRootPart.Position).Magnitude
				if isInFOV(camera.CFrame.Position, targetPos, aimbotFOV) then
					if aimbotVisible then
						if isTargetVisible(camera.CFrame.Position, targetPos) then
							if distance < closestDistance then
								closestDistance = distance
								closestPlayer = plr
							end
						end
					else
						if distance < closestDistance then
							closestDistance = distance
							closestPlayer = plr
						end
					end
				end
			end
		end
	end
	return closestPlayer
end

RunService.RenderStepped:Connect(function()
	if not aimbotEnabled then return end
	local closestPlayer = getClosestAimbotTarget()
	if closestPlayer and closestPlayer.Character then
		local targetPart = getAimbotTargetPart(closestPlayer.Character)
		if targetPart then
			local cameraPos = camera.CFrame.Position
			local targetPos = targetPart.Position
			if aimbotSmooth <= 1 then
				camera.CFrame = CFrame.new(cameraPos, targetPos)
			else
				local currentLook = camera.CFrame.LookVector
				local targetLook = (targetPos - cameraPos).Unit
				local t = 1 / aimbotSmooth
				local smoothedLook = currentLook:Lerp(targetLook, t).Unit
				camera.CFrame = CFrame.new(cameraPos, cameraPos + smoothedLook)
			end
		end
	end
end)

-- HITBOX LOOP
RunService.Heartbeat:Connect(function()
	if not hitboxEnabled then return end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				hrp.Color = Color3.fromRGB(0, 0, 0)
				hrp.Material = Enum.Material.Neon
				hrp.Transparency = hitboxTransparency
				hrp.CanCollide = false
			end
		end
	end
end)

-- AUTO UPDATE ESP
RunService.Heartbeat:Connect(function()
	limpiarESPObsoleto()

	if espEnemyEnabled then
		local enemyCount = 0
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				enemyCount = enemyCount + 1
			end
		end
		enemyCountDisplay.Text = "Enemigos: " .. enemyCount
		enemyCountDisplay.Visible = true
	else
		enemyCountDisplay.Visible = false
	end

	if espBodyEnabled then
		updateESPBody()
	else
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("EMZ_ESP") then
				plr.Character.EMZ_ESP:Destroy()
			end
		end
	end

	if not espEnemyEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("EMZ_ESP_ENEMY") then
				plr.Character.EMZ_ESP_ENEMY:Destroy()
			end
		end
	end

	if espBoxEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				drawESPBox(plr)
			end
		end
	else
		for _, box in pairs(espBoxes) do
			for _, line in pairs(box) do line.Visible = false end
		end
	end

	if espLineEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				drawESPLine(plr)
			end
		end
	else
		for _, line in pairs(espLines) do line.Visible = false end
	end

	if espNameEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				drawESPName(plr)
			end
		end
	else
		for _, lbl in pairs(espNameLabels) do lbl.Visible = false end
	end

	if espSkeletonEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				drawESPSkeleton(plr)
			end
		end
	else
		for _, lines in pairs(espSkeletonLines) do
			for _, line in pairs(lines) do line.Visible = false end
		end
	end

	if espHealthBarEnabled then
		for _, plr in pairs(Players:GetPlayers()) do
			if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
				drawESPHealthBar(plr)
			end
		end
	else
		for _, bar in pairs(espHealthBars) do
			for _, line in pairs(bar) do line.Visible = false end
		end
	end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
	if noclipEnabled and player.Character then
		for _, part in pairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end
end)

-- FOV CIRCLE
RunService.RenderStepped:Connect(function()
	updateFOVCircle()
end)

-- TOGGLE PANEL
local isOpen = true
toggleButton.MouseButton1Click:Connect(function()
	isOpen = not isOpen
	mainContainer.Visible = isOpen
	toggleButton.Text = isOpen and "◀" or "▶"
	if isOpen then 
		switchTab(lastTab)
	end
end)

-- FLY + SPEED
RunService.RenderStepped:Connect(function()
	if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.Velocity = camera.CFrame.LookVector * flySpeed
	end
	if speedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = walkSpeed
	end
end)

-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
	if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)

-- ====== ANTI-KICK ======
local function setupAntiKick()
	if antiKickConnection then
		antiKickConnection:Disconnect()
	end
	
	antiKickConnection = game:GetService("CoreGui").ChildAdded:Connect(function(child)
		if child.Name:lower():find("kick") or child.Name:lower():find("ban") or child.Name:lower():find("alert") then
			child:Destroy()
		end
	end)
	
	local oldTeleport = TeleportService.Teleport
	TeleportService.Teleport = function(...)
		if not antiKickEnabled then
			return oldTeleport(...)
		end
	end
end

setupAntiKick()

-- Cargar pestaña inicial
switchTab("aimbot")
