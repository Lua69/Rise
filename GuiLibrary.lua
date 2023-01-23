--[[
    Rise Client!

    Credits to the following people:
    https://github.com/Babyhamsta - CoreGui Bypasses,
    https://github.com/7GrandDadPGN - Vape V4 but for Roblox,
    Sorry but I dont support pedos - Infinite Yield
]]


local config = { -- default/template config, dont touch it >:C
    Name = "Rise", -- name of hud,
    Version = 0.1,
    Colors = { -- colors
        Background = Color3.fromRGB(23, 28, 35),
        Accent = {
            Default = Color3.new(),
            NoBackground = Color3.new(1, 1, 1)
        },
        Button = {
            Default = Color3.fromRGB(225, 225, 225),
            Faded = Color3.fromRGB(180, 180, 180)
        }
    },
    Font = Enum.Font.GothamSS -- font of text
}
local firstTimer = false

local github_repo
do
    local creator = "Lua69"
    local repo = "Rise"
    github_repo = "https://raw.githubusercontent.com/" .. creator .. "/" .. repo .. "/main/"
end

local getasset = getsynasset or getcustomasset or function(location) -- fetch a asset from the web!
    return "rbxasset://" .. location -- daily jjsploit user XD
end

local cloneref = cloneref or function(g) -- cloneref to pretty much hide the instances from the game, (Btw I didnt make this)
    if RunService:IsStudio() then
        g.Parent = CoreGui
    end

    local a = Instance.new("Flag")
    local InstanceList

    for b, c in pairs(getreg()) do
        if type(c) == "table" and #c then
            if rawget(c, "__mode") == "kvs" then
                for d, e in pairs(c) do
                    if e == a then
                        InstanceList = c;
                        break
                    end
                end
            end
        end
    end

    local f = {}

    function f.invalidate(g) -- gets the instances in the the object and sets them to nil
        if not InstanceList then
            return
        end
        for b, c in pairs(InstanceList) do
            if c == g then
                InstanceList[b] = nil;
                return g
            end
        end
    end

    return f.invalidate(g)
end

local protect_gui = syn.protect_gui or function(obj) -- Protect gui if your a synapse user
    obj.Parent = CoreGui
end

local requestfunc =
    syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or request or
        function(tab) -- http request
            if tab.Method == "GET" then
                return {
                    Body = game:HttpGet(tab.Url, true),
                    Headers = {},
                    StatusCode = 200
                }
            else
                return {
                    Body = "Bro fr stop using jjsploit",
                    Headers = {},
                    StatusCode = 404
                }
            end
        end

local writefile = writefile or function() -- Unable to writefile, pretty bad exploit man.
    return false
end

local readfile = readfile or function() -- YOU CANT EVEN READFILE? WOW MAN
    return false
end

local isfile = isfile or function(file) -- Detect if the file exists or not
    local suc, res = pcall(function()
        return readfile(file)
    end)
    return suc and res ~= nil
end

local realRobloxTask = task -- idk I think this works
local task = {} -- override it with a table

if KRNL_LOADED then -- last time I tried to use task.wait on krnl, it failed for me.
    task.delay = realRobloxTask.delay
    task.spawn = realRobloxTask.spawn
    task.wait = function(t)
        local time = t or 0.05 -- default roblox wait time is 0.05
        local tick = tick()

        repeat
            RunService.PreRender:Wait()
        until tick() - tick >= time
    end
else
    task = realRobloxTask
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

function random(min, max) -- roblox's math.random is not really random sometimes tbh
    return Random.new():NextInteger(min, max)
end

function randomString() -- generate a random long string of text
    local array = {}
    local len = random(0, 100)

    for i = 1, len, 1 do
        array[i] = string.char(math.random(1, 128))
    end

    return table.concat(array)
end

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local cachedassets = {}
local yield = task.wait
local rblxStudio = RunService:IsStudio()

if not isfolder("rise") then
    firstTimer = true
    makefolder("rise")
    makefolder("rise/assets")
    makefolder("rise/sounds")
end

if shared.Rise then
    error("Rise seems to be already running!", 0)
    return
end

if rblxStudio then
    CoreGui = Player:WaitForChild("PlayerGui")
end

local gui = Instance.new("ScreenGui")
gui.Name = randomString()
gui.DisplayOrder = 9e9
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protect_gui(gui)
gui.Parent = cloneref(CoreGui)
gui.Parent = game.CoreGui
gui.OnTopOfCoreBlur = true
shared.Rise = gui

function fetchModule(module)
    return loadstring(requestfunc({
        Url = github_repo .. "modules/" .. module .. ".lua",
        Method = "GET"
    }).Body)()
end

local scaleUI = fetchModule("AutoScaleLibrary")
local RippleClick = fetchModule("RippleEffect")

function PropertyExists(obj, prop)
	return ({pcall(function()if(typeof(obj[prop])=="Instance")then error()end end)})[1]
end

function fetchAsset(path)
    if not isfile(path) then    
        task.spawn(function()
            local position, tween = config.HudElement.Position.assetDownloadHeader, config.HudElement.Tween.assetDownloadHeader

            local txt = Instance.new("TextLabel", gui)
            txt.Size = UDim2.new(1, 0, 0.1, 0)
            txt.Position = position.Start
            txt.Text = "Downloading " .. path
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = config.Font
            txt.TextColor3 = config.Colors.Accent.NoBackground

            TweenService:Create(txt, TweenInfo.new(tween.Time, tween.TweenType, tween.TweenDirection), {Position = position.End}):Play()

            repeat
                yield()
            until isfile(path)

            txt:Destroy()
        end)
        local req = requestfunc({
            Url = github_repo .. path:gsub("rise/", ""),
            Method = "GET"
        })
        writefile(path, req.Body)
    end
    if not cachedassets[path] then
        cachedassets[path] = getasset(path)
    end
    return cachedassets[path]
end

function recalibrateGUIObject(obj)
    scaleUI.SetSize(obj, "Scale")
    scaleUI.SetPos(obj, "Scale")
    scaleUI.ScaleText(obj)

    for _, descendant in next, obj:GetDescendants() do
        scaleUI.SetSize(descendant, "Scale")
        scaleUI.SetPos(descendant, "Scale")
        scaleUI.ScaleText(descendant)
    end
end

local create = {}

create.sound = function(info)
    task.spawn(function()
        local snd = Instance.new("Sound", gui)
        snd.Volume = info.Volume or 1
        snd.SoundId = info.SoundId
        snd.Playing = true
        snd.Played:Wait()
        snd:Destroy()
    end)
end

create.window = function()
    local window = Instance.new("Frame")
    local sidebar = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local version = Instance.new("TextLabel")
    local list = Instance.new("Frame")
    local UIListLayout = Instance.new("UIListLayout")
    local sidebtn = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local txt = Instance.new("TextLabel")
    local UICorner_2 = Instance.new("UICorner")
    local properCorner = Instance.new("Frame")
    local UICorner_3 = Instance.new("UICorner")
    local UISizeConstraint = Instance.new("UISizeConstraint")
    local list_2 = Instance.new("ScrollingFrame")
    local btn = Instance.new("TextButton")
    local UICorner_4 = Instance.new("UICorner")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    window.Name = randomString()
    window.Parent = gui
    window.BackgroundColor3 = config.Colors.Background
    window.BorderSizePixel = 0
    window.Position = UDim2.new(0.3204014, 0, 0.292504549, 0)
    window.Size = UDim2.new(0.325932384, 0, 0.431901276, 0)

    sidebar.Name = "sidebar"
    sidebar.Parent = window
    sidebar.BackgroundColor3 = 
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0.0212672371, 0, 0, 0)
    sidebar.Size = UDim2.new(0.203636333, 0, 1, 0)
end

create.frame = function() -- creates a frame hud element
    local img = Instance.new("ImageLabel", nil)
    img.Name = randomString()
    img.BackgroundTransparency = 1
    img.AnchorPoint = Vector2.new(.5, .5)
    img.ImageTransparency = config.BackgroundTransparency

    if config.BackgroundImage then
        img.Image = config.BackgroundImage
    else
        img.Image = fetchAsset("fluffy/assets/WindowBlur.png")
        img.ScaleType = Enum.ScaleType.Slice
        img.SliceCenter = Rect.new(10, 10, 10, 10)
    end

    return img
end

create.btn = function(info)
    local btn = Instance.new("TextButton", nil)
    btn.Name = randomString()
    btn.BackgroundColor3 = config.Colors.Button.Default
    btn.Text = ""
    btn.AnchorPoint = Vector2.new(.5, .5)
    btn.TextTransparency = 1

    local txt = Instance.new("TextLabel", btn)
    txt.BackgroundTransparency = 1
    txt.Size = UDim2.new(1, 0, 1, 0)
    txt.Text = info.Text
    txt.Font = config.Font
    txt.TextSize = info.TextSize
    txt.TextColor3 = config.Colors.Accent.Default

    btn.AutoButtonColor = false
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = config.Colors.Button.Faded
        create.sound({
            SoundId = fetchAsset("fluffy/sounds/osu!sfx/UI/generic-hover-softer.wav")
        })
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = config.Colors.Button.Default
    end)

    btn.MouseButton1Up:Connect(function(x, y)
        create.sound({
            SoundId = fetchAsset("fluffy/sounds/osu!sfx/UI/generic-select-softer.wav")
        })
        RippleClick(btn, Mouse.X, Mouse.Y)
    end)

    return btn
end

create.scroll = function()
    local scroll = Instance.new("ScrollingFrame", nil)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarImageTransparency = 1
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Size = UDim2.new(1, 0, 1, 0)

    local uiList = Instance.new("UIListLayout", scroll)
    uiList.VerticalAlignment = Enum.VerticalAlignment.Center

    return scroll
end