--[[
  M0$$AD / V5.3 — Démo avec actions indépendantes et notifications personnalisées.

  Chaque jeu a sa fonction Action. Par défaut, elle fait seulement un print
  distinct : aucun code de bypass, d'injection ou de modification de jeu.

  Personnalisation :
    Name    : nom affiché dans la liste et les notifications.
    Icon    : nom de ton PNG dans le dossier GitHub assets/.
    Initial : lettres de secours si l'image ne charge pas.
    Action  : exemple indépendant appelé une seule fois par jeu.

  Exemple :
    {
      Name = "Mon Jeu",
      Icon = "mon_jeu.png",
      Initial = "MJ",
      Action = function()
        print("Mon Jeu : ma démo personnalisée")
      end,
    },
]]

local BASE = "https://raw.githubusercontent.com/DrPurplee/UI-Bpass/main"
local UI = loadstring(game:HttpGet(BASE .. "/ui.lua"))()

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ============================================================
-- 1. TES JEUX : UNE ACTION DIFFÉRENTE POUR CHAQUE LIGNE
-- ============================================================
local GAMES = {
    {
        Name = "Mon Jeu RP",
        Icon = "game_custom.png",
        Initial = "RP",
        Action = function()
            print("[M0$$AD] MON JEU RP : démo activée")
        end,
    },
    {
        Name = "Call of Duty (BO6)",
        Icon = "game_cod.png",
        Initial = "BO6",
        Action = function()
            print("[M0$$AD] CALL OF DUTY BO6 : action exemple")
        end,
    },
    {
        Name = "Fortnite",
        Icon = "game_fortnite.png",
        Initial = "FN",
        Action = function()
            print("[M0$$AD] FORTNITE : test personnalisé")
        end,
    },
    {
        Name = "Rainbow Six Siege",
        Icon = "game_r6.png",
        Initial = "R6",
        Action = function()
            print("[M0$$AD] RAINBOW SIX SIEGE : simulation lancée")
        end,
    },
    {
        Name = "Rust",
        Icon = "game_rust.png",
        Initial = "RS",
        Action = function()
            print("[M0$$AD] RUST : exemple indépendant")
        end,
    },
}

-- ============================================================
-- 2. NOTIFICATIONS M0$$AD (DARK NAVY + BLEU CYBER)
--    N'utilise PAS les notifications Roblox par défaut.
-- ============================================================
local COLORS = {
    Base = Color3.fromRGB(7, 13, 24),
    BaseBottom = Color3.fromRGB(10, 25, 44),
    Border = Color3.fromRGB(34, 80, 126),
    Blue = Color3.fromRGB(56, 151, 247),
    BluePale = Color3.fromRGB(153, 211, 255),
    White = Color3.fromRGB(240, 247, 255),
    Muted = Color3.fromRGB(161, 181, 204),
    Success = Color3.fromRGB(107, 219, 174),
    Warning = Color3.fromRGB(255, 196, 117),
    Error = Color3.fromRGB(255, 135, 146),
}

local function make(className, properties, parent)
    local item = Instance.new(className)
    for key, value in pairs(properties) do
        item[key] = value
    end
    if parent then item.Parent = parent end
    return item
end

local function fadeTo(item, duration, goal)
    local tween = TweenService:Create(
        item,
        TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        goal
    )
    tween:Play()
    return tween
end

local player = Players.LocalPlayer
local guiParent = player and player:WaitForChild("PlayerGui") or game:GetService("CoreGui")
if type(gethui) == "function" then
    local ok, target = pcall(gethui)
    if ok and typeof(target) == "Instance" then guiParent = target end
end

-- Si la démo est relancée, on retire les anciennes notifications.
local existing = guiParent:FindFirstChild("M0SSAD_ToastLayer")
if existing then existing:Destroy() end

local toastGui = make("ScreenGui", {
    Name = "M0SSAD_ToastLayer",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 1800,
}, guiParent)

local visibleToasts = {}
local MAX_TOASTS = 3
local TOAST_HEIGHT = 90
local TOAST_GAP = 10

local function reflowToasts()
    for index, toast in ipairs(visibleToasts) do
        if toast.Parent then
            fadeTo(toast, 0.22, {
                Position = UDim2.new(1, -18, 0, 20 + (index - 1) * (TOAST_HEIGHT + TOAST_GAP))
            })
        end
    end
end

local function removeToast(toast)
    for index = #visibleToasts, 1, -1 do
        if visibleToasts[index] == toast then
            table.remove(visibleToasts, index)
            break
        end
    end
    if toast.Parent then
        toast:Destroy()
    end
    reflowToasts()
end

local function notify(gameName, state)
    if not toastGui.Parent then return end
    local already = state == "already"
    local failed = state == "error"
    local accent = failed and COLORS.Error or (already and COLORS.Warning or COLORS.Blue)
    local wording = failed and "Print indisponible" or (already and "Print déjà activé" or "Print Activé")
    local fullMessage = "M0$$AD ~ " .. tostring(gameName) .. " " .. wording

    if #visibleToasts >= MAX_TOASTS then
        removeToast(visibleToasts[1])
    end

    local targetY = 20 + #visibleToasts * (TOAST_HEIGHT + TOAST_GAP)
    local toast = make("Frame", {
        Name = "M0SSAD_Toast",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 340, 0, targetY),
        Size = UDim2.fromOffset(334, TOAST_HEIGHT),
        BackgroundColor3 = COLORS.Base,
        BorderSizePixel = 0,
        ZIndex = 20,
        ClipsDescendants = true,
    }, toastGui)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, toast)
    make("UIStroke", {
        Color = COLORS.Border,
        Thickness = 1,
        Transparency = 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, toast)
    make("UIGradient", {
        Rotation = 90,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, COLORS.Base),
            ColorSequenceKeypoint.new(1, COLORS.BaseBottom),
        }),
    }, toast)

    make("Frame", {
        Name = "AccentBar",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        ZIndex = 21,
    }, toast)

    make("TextLabel", {
        Name = "Brand",
        Position = UDim2.fromOffset(16, 8),
        Size = UDim2.fromOffset(200, 20),
        BackgroundTransparency = 1,
        Text = "M0$$AD",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = COLORS.White,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 22,
    }, toast)

    make("TextLabel", {
        Name = "State",
        Position = UDim2.fromOffset(214, 8),
        Size = UDim2.fromOffset(103, 20),
        BackgroundTransparency = 1,
        Text = failed and "ERREUR" or (already and "DÉJÀ ACTIF" or "ACTIVÉ"),
        Font = Enum.Font.GothamBold,
        TextSize = 10,
        TextColor3 = accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        ZIndex = 22,
    }, toast)

    make("TextLabel", {
        Name = "Message",
        Position = UDim2.fromOffset(16, 32),
        Size = UDim2.fromOffset(300, 45),
        BackgroundTransparency = 1,
        Text = fullMessage,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextWrapped = true,
        TextColor3 = COLORS.White,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = 22,
    }, toast)

    local progress = make("Frame", {
        Name = "TimeoutProgress",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 3, 1, 0),
        Size = UDim2.new(1, -3, 0, 2),
        BackgroundColor3 = accent,
        BackgroundTransparency = 0.22,
        BorderSizePixel = 0,
        ZIndex = 22,
    }, toast)

    table.insert(visibleToasts, toast)
    fadeTo(toast, 0.26, {Position = UDim2.new(1, -18, 0, targetY)})
    local lifetime = 4.5
    TweenService:Create(progress, TweenInfo.new(lifetime, Enum.EasingStyle.Linear), {
        Size = UDim2.fromOffset(0, 2),
    }):Play()
    task.delay(lifetime, function()
        if not toast.Parent then return end
        local exit = fadeTo(toast, 0.18, {
            Position = UDim2.new(1, 350, 0, toast.Position.Y.Offset)
        })
        exit.Completed:Wait()
        removeToast(toast)
    end)
end

-- ============================================================
-- 3. EXÉCUTION UNIQUE PAR JEU (ET NOTIFICATION À CHAQUE CLIC)
-- ============================================================
local gameByName = {}
for _, gameInfo in ipairs(GAMES) do
    gameByName[gameInfo.Name] = gameInfo
end
local activated = {}

local function activateGame(gameName, app)
    local gameInfo = gameByName[gameName]
    if not gameInfo then
        warn("[M0$$AD] Jeu inconnu : " .. tostring(gameName))
        return
    end

    if activated[gameName] then
        notify(gameName, "already")
        app:SetStatus(gameName .. " • DÉJÀ ACTIVÉ", "loading")
        return
    end

    local ok, err = pcall(function()
        if type(gameInfo.Action) == "function" then
            gameInfo.Action()
        end
    end)

    if not ok then
        warn("[M0$$AD] Erreur de l'action " .. gameName .. ": " .. tostring(err))
        notify(gameName, "error")
        app:SetStatus(gameName .. " • ERREUR", "error")
        return
    end

    activated[gameName] = true
    notify(gameName, "activated")
    app:SetStatus(gameName .. " • ACTIVÉ", "success")
end

-- ============================================================
-- 4. CHARGEMENT DE L'UI EXISTANTE, SANS CHANGER SON DESIGN
-- ============================================================
local app = UI.new({
    AssetBaseURL = BASE .. "/assets",
    CacheVersion = "v5_2_m0ssad_custom_1", -- mêmes images que V5.2.1
    ShowScene = false,
    Keybind = "RightShift",
    ButtonText = "LANCER LE PRINT",
    Games = GAMES,

    -- Clic directement sur une ligne de jeu.
    OnSelect = function(gameName, currentApp)
        activateGame(gameName, currentApp)
    end,

    -- Clic sur le bouton principal pour le jeu sélectionné.
    OnLaunch = function(gameName, currentApp)
        activateGame(gameName, currentApp)
    end,
})

-- Les notifications sont dans un ScreenGui indépendant : elles restent
-- visibles même lorsque le panneau principal est masqué.
