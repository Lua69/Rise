--[[
    Rise Client!

    Credits to the following people:
    https://github.com/Babyhamsta - CoreGui Bypasses,
    https://github.com/7GrandDadPGN - Vape V4 but for Roblox,
    Sorry but I dont support pedos - Infinite Yield
]] local config = { -- default/template config, dont touch it >:C
    Name = "Rise", -- name of hud,
    Version = 0.1,
    Colors = { -- colors
        Background = Color3.fromRGB(23, 28, 35),
        Secondary = Color3.fromRGB(18, 20, 25),
        Description = Color3.fromRGB(127, 127, 127),
        Accent = {
            Default = Color3.new(0.117647, 0.337254, 1),
            Text = Color3.new(1, 1, 1)
        }
    },
    Font = Enum.Font.Gotham -- font of text
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

local cloneref = cloneref or
                     function(g) -- cloneref to pretty much hide the instances from the game, (Btw I didnt make this)
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

local modules = {
    scaleUI = fetchModule("AutoScaleLibrary"),
    RippleClick = fetchModule("RippleEffect"),
    SmoothDrag = fetchModule("SmoothDrag")
}

function PropertyExists(obj, prop)
    return ({pcall(function()
        if (typeof(obj[prop]) == "Instance") then
            error()
        end
    end)})[1]
end

function fetchAsset(path)
    if not isfile(path) then
        task.spawn(function()
            local txt = Instance.new("TextLabel", gui)
            txt.Size = UDim2.new(1, 0, 0.1, 0)
            txt.Text = "Downloading " .. path
            txt.BackgroundTransparency = 1
            txt.TextScaled = true
            txt.Font = config.Font
            txt.TextColor3 = config.Colors.Accent.Text

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
    pcall(function()
        modules.scaleUI.SetSize(obj, "Scale")
        modules.scaleUI.SetPos(obj, "Scale")
        modules.scaleUI.ScaleText(obj)

        for _, descendant in next, obj:GetDescendants() do
            modules.scaleUI.SetSize(descendant, "Scale")
            modules.scaleUI.SetPos(descendant, "Scale")
            modules.scaleUI.ScaleText(descendant)
        end
    end)
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

create.window = function() -- wooo its a window!!
    local window = Instance.new("Frame")
    local sidebar = Instance.new("Frame")
    local title = Instance.new("TextLabel")
    local version = Instance.new("TextLabel")
    local properCorner = Instance.new("Frame")
    local list = Instance.new("Frame")
    local btnList = Instance.new("ScrollingFrame")

    window.Name = randomString()
    window.Parent = gui
    window.BackgroundColor3 = config.Colors.Background
    window.BorderSizePixel = 0
    window.Position = UDim2.new(0.3204014, 0, 0.292504549, 0)
    window.Size = UDim2.new(0.325932384, 0, 0.431901276, 0)

    sidebar.Name = randomString()
    sidebar.Parent = window
    sidebar.BackgroundColor3 = config.Colors.Secondary
    sidebar.BorderSizePixel = 0
    sidebar.Position = UDim2.new(0.0212672371, 0, 0, 0)
    sidebar.Size = UDim2.new(0.203636333, 0, 1, 0)

    title.Name = randomString()
    title.Parent = sidebar
    title.BackgroundTransparency = 1
    title.BorderSizePixel = 0
    title.Position = UDim2.new(0.0416666716, 0, 0.014109347, 0)
    title.Size = UDim2.new(0, 166, 0, 50)
    title.Font = Enum.Font.Gotham
    title.Text = config.Name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 30.000
    title.TextXAlignment = Enum.TextXAlignment.Left

    version.Name = randomString()
    version.Parent = sidebar
    version.BackgroundTransparency = 1
    version.BorderSizePixel = 0
    version.Position = UDim2.new(0.0450000018, 0, 0.0759999976, 0)
    version.Size = UDim2.new(0, 160, 0, 22)
    version.Font = Enum.Font.Gotham
    version.Text = tostring(config.Version) .. " Beta"
    version.TextColor3 = config.Colors.Description
    version.TextSize = 15.000
    version.TextXAlignment = Enum.TextXAlignment.Left

    properCorner.Name = randomString()
    properCorner.Parent = window
    properCorner.BackgroundColor3 = sidebar.BackgroundColor3
    properCorner.BorderSizePixel = 0
    properCorner.Position = UDim2.new(-0.000898733386, 0, 0, 0)
    properCorner.Size = UDim2.new(0.130044699, 0, 1, 0)
    properCorner.ZIndex = 0

    list.Name = randomString()
    list.Parent = sidebar
    list.BackgroundTransparency = 1
    list.Position = UDim2.new(0.0416666716, 0, 0.125220463, 0)
    list.Size = UDim2.new(0, 146, 0, 482)

    btnList.Name = randomString()
    btnList.Parent = window
    btnList.Active = true
    btnList.BackgroundTransparency = 1
    btnList.BorderSizePixel = 0
    btnList.Position = UDim2.new(0.23757574, 0, 0.014109347, 0)
    btnList.Size = UDim2.new(0, 620, 0, 552)
    btnList.BottomImage = ""
    btnList.CanvasSize = UDim2.new(0, 0, 0, 0)
    btnList.ScrollBarThickness = 2
    btnList.TopImage = ""
    btnList.ScrollingDirection = Enum.ScrollingDirection.Y
    btnList.AutomaticCanvasSize = Enum.AutomaticSize.Y

    Instance.new("UIListLayout", list)
    Instance.new("UICorner", window)
    Instance.new("UICorner", properCorner)

    local uilistPadding = Instance.new("UIListLayout", btnList)
    uilistPadding.Padding = UDim.new(0, 10)
    uilistPadding.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local size = Instance.new("UISizeConstraint")
    size.MinSize = Vector2.new(500, 500)

    modules.scaleUI.AddConstraint(window)
    recalibrateGUIObject(title)
    recalibrateGUIObject(version)
    recalibrateGUIObject(list)
    recalibrateGUIObject(btnList)
    modules.SmoothDrag.setupDrag(window)

    return {
        window = window,
        sidebar = list,
        list = btnList
    }
end

create.btn = function(info, type) -- clickity clack
    if type then
        local sidebtn = Instance.new("TextButton")
        local txt = Instance.new("TextLabel")

        sidebtn.Name = randomString()
        sidebtn.Parent = info.Parent
        sidebtn.BackgroundColor3 = config.Colors.Accent.Default
        sidebtn.BorderSizePixel = 0
        sidebtn.Size = UDim2.new(0, 88, 0, 31)
        sidebtn.Text = ""
        sidebtn.AutoButtonColor = false

        txt.Name = randomString()
        txt.Parent = sidebtn
        txt.BackgroundTransparency = 1.000
        txt.BorderSizePixel = 0
        txt.Size = UDim2.new(1, 0, 1, 0)
        txt.Font = config.Font
        txt.TextColor3 = config.Colors.Accent.Text
        txt.TextSize = 14.000
        txt.Text = info.Text

        Instance.new("UICorner", sidebtn)

        recalibrateGUIObject(sidebtn)
    else
        local btn = Instance.new("TextButton")
        local title = Instance.new("TextLabel")
        local desc = Instance.new("TextLabel")

        btn.Name = randomString()
        btn.Parent = info.Parent
        btn.BackgroundColor3 = config.Colors.Secondary
        btn.Size = UDim2.new(1, 0, 0.125, 0)
        btn.Text = ""
        btn.AutoButtonColor = false

        title.Name = randomString()
        title.Parent = btn
        title.BackgroundTransparency = 1
        title.BorderSizePixel = 0
        title.Position = UDim2.new(0.0209677424, 0, 0.101449274, 0)
        title.Size = UDim2.new(0.979032278, 0, -0.318840593, 50)
        title.Font = config.Font
        title.TextColor3 = config.Colors.Accent.Text
        title.TextSize = 20.000
        title.TextWrapped = false
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Text = info.Title

        desc.Name = randomString()
        desc.Parent = btn
        desc.BackgroundTransparency = 1
        desc.BorderSizePixel = 0
        desc.Position = UDim2.new(0.0209677424, 0, 0.463768125, 0)
        desc.Size = UDim2.new(0.979032278, 0, -0.318840593, 50)
        desc.Font = config.Font
        desc.TextColor3 = config.Colors.Description
        desc.TextSize = 15.000
        desc.TextWrapped = true
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.Text = info.Description

        Instance.new("UICorner", btn)

        recalibrateGUIObject(btn)
    end
end

local window = create.window()
local search = create.btn({
    Parent = window.sidebar,
    Text = "Search"
}, true)

for _ = 1, 100, 1 do
    local hotbar = create.btn({
        Parent = window.list,
        Title = "Hotbar",
        Description = "Custom hotbar ui!"
    }, false)
end