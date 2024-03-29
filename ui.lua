local startUpArgs = getgenv().startUpArgs or {'Universal'}

---@dependencies
local inputService   = game:GetService('UserInputService')
local runService     = game:GetService('RunService')
local tweenService   = game:GetService('TweenService')
local tpService      = game:GetService('TeleportService')
local players        = game:GetService('Players')
local http           = game:GetService('HttpService')
local coreGui        = game:GetService('CoreGui')

local localPlayer    = players.LocalPlayer
local eventLogs = {}
local screenSize = workspace.CurrentCamera.ViewportSize
local c3new, fromrgb = Color3.new, Color3.fromRGB
local newUDim2, newVector2 = UDim2.new, Vector2.new
local round = math.round

local menu = game:GetObjects('rbxassetid://12360181183')[1]
if syn then syn.protect_gui(menu) end
menu.bg.Position = newUDim2(0.5,-menu.bg.Size.X.Offset/2,0.5,-menu.bg.Size.Y.Offset/2)
menu.Parent = coreGui
menu.Enabled = false

local library = {
    gamename = startUpArgs[1];
    colorpicking = false;
    dropdowned = false;
    tabbuttons = {};
    tabs = {};
    options = {};
    flags = {};
    scrolling = false;
    playing = false;multiZindex = 999;
    toInvis = {};
    libColor = fromrgb(240, 142, 214);
    disabledcolor = fromrgb(233, 0, 0);
    connections = {};
    blacklisted = {
        Enum.KeyCode.W,
        Enum.KeyCode.A,
        Enum.KeyCode.S,
        Enum.KeyCode.D,
        Enum.UserInputType.MouseMovement
    };
}
--
if not isfolder('seere') then
    makefolder('seere')
end
local folders = {
    ('seere/%s'):format(library.gamename);
    ('seere/%s/assets'):format(library.gamename);
    ('seere/%s/configs'):format(library.gamename);
    ('seere/%s/cloud'):format(library.gamename);
    ('seere/%s/luas'):format(library.gamename);
}

for _, folder in next, folders do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

function draggable(a)local b=inputService;local c;local d;local e;local f;local function g(h)if not library.colorpicking then local i=h.Position-e;a.Position=newUDim2(f.X.Scale,f.X.Offset+i.X,f.Y.Scale,f.Y.Offset+i.Y)end end;a.InputBegan:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch then c=true;e=h.Position;f=a.Position;h.Changed:Connect(function()if h.UserInputState==Enum.UserInputState.End then c=false end end)end end)a.InputChanged:Connect(function(h)if h.UserInputType==Enum.UserInputType.MouseMovement or h.UserInputType==Enum.UserInputType.Touch then d=h end end)b.InputChanged:Connect(function(h)if h==d and c then g(h)end end)end
draggable(menu.bg)

local tabholder = menu.bg.bg.bg.bg.main.group
local tabviewer = menu.bg.bg.bg.bg.tabbuttons

local keyNames = {
    [Enum.KeyCode.LeftAlt] = 'LALT';
    [Enum.KeyCode.RightAlt] = 'RALT';
    [Enum.KeyCode.LeftControl] = 'LCTRL';
    [Enum.KeyCode.RightControl] = 'RCTRL';
    [Enum.KeyCode.LeftShift] = 'LSHIFT';
    [Enum.KeyCode.RightShift] = 'RSHIFT';
    [Enum.KeyCode.Underscore] = '_';
    [Enum.KeyCode.Minus] = '-';
    [Enum.KeyCode.Plus] = '+';
    [Enum.KeyCode.Period] = '.';
    [Enum.KeyCode.Slash] = '/';
    [Enum.KeyCode.BackSlash] = '\\';
    [Enum.KeyCode.Question] = '?';
    [Enum.UserInputType.MouseButton1] = 'MB1';
    [Enum.UserInputType.MouseButton2] = 'MB2';
    [Enum.UserInputType.MouseButton3] = 'MB3';
}

function library:Connection(signal, func)
    local c = signal:Connect(func)
    table.insert(library.connections, c)
    return c
end

function library:Tween(...)
    tweenService:Create(...):Play()
end

function library:ButtonDown(key)
    if string.find(tostring(key), 'KeyCode') then
        return inputService:IsKeyDown(key)
    else
        for _,v in pairs(inputService:GetMouseButtonsPressed()) do
            if v.UserInputType == key then
                return true
            end
        end
    end
    return false
end

function library:ConvertNumberRange(val,oldmin,oldmax,newmin,newmax)
    return (((val - oldmin) * (newmax - newmin)) / (oldmax - oldmin)) + newmin
end

function library:New(instanceType, properties, drawing)
    local instance = drawing and Drawing.new(instanceType) or Instance.new(instanceType)
    if type(properties) == 'table' then
        for property, value in next, properties do
            instance[property] = value
        end
    end
    return instance
end

local cursor = library:New('Image', {
    Data = game:HttpGet('https://fini.work/cursor.png');
    Size = newVector2(32,32);
    Visible = false;
}, true)

library:Connection(inputService.InputEnded, function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        menu.Enabled = not menu.Enabled
        cursor.Visible = menu.Enabled
        library.scrolling = false
        library.colorpicking = false
        library.dropdowned = false
        for i,v in next, library.toInvis do
            v.Visible = false
        end
    end
end)

function library:Notify(text, time, color)
	local eventLog = {
		text = text;
		startTick = tick();
		lifeTime = time or 5;
		shadowText = self:New('Text', {
			Center = true;
			Outline = false;
			Color = c3new();
			Transparency = 1;
			Text = text;
			Size = 13;
			Font = 2;
			Visible = true
		}, true);
		mainText = self:New('Text', {
			Center = true;
			Outline = false;
			Color = color or c3new(1, 1, 1);
			Transparency = 1;
			Text = text;
			Size = 13;
			Font = 2;
			Visible = true
		}, true)
	}
	function eventLog:Destroy()
		local shadowTextOrigin = self.shadowText.Position
        local mainTextOrigin = self.mainText.Position
        local shadowTextTrans = self.shadowText.Transparency
        local mainTextTrans = self.mainText.Transparency
        for i = 0, 1, 1/90 do
            self.shadowText.Position = shadowTextOrigin:Lerp(Vector2.new(screenSize.X / 2, (screenSize.Y / 2) + 77), i)
            self.mainText.Position = mainTextOrigin:Lerp(Vector2.new(screenSize.X / 2, (screenSize.Y / 2) + 77), i)
			self.shadowText.Transparency = shadowTextTrans * (1 - i)
			self.mainText.Transparency = mainTextTrans * (1 - i)
			runService.RenderStepped:Wait()
		end

		self.mainText:Remove()
		self.shadowText:Remove()
		self.mainText = nil
		self.shadowText = nil
		table.clear(self)
		self = nil
	end

	table.insert(eventLogs, eventLog)
	return eventLog
end

function library:shownow()
    menu.Enabled = true
    cursor.Visible = true
end

local indicators = library:New('ScreenGui', { Name = 'Indicators', Enabled = true; Parent = coreGui})

function library:NewIndicator(args)
    local indicator = {
        title = args.title or 'Indicator';
        size = args.size or newUDim2(0, 200, 0, 21);
        position = args.position or newUDim2(0, 0, 0, 0);
        enabled = args.enabled or false;
        values = {};
    }

    local main = library:New('Frame', {
        Name = indicator.title;
        Parent = indicators;
        BackgroundColor3 = fromrgb(0, 0, 0);
        BorderColor3 = fromrgb(10, 10, 10);
        BorderSizePixel = 2;
        Visible = indicator.enabled;
        Position = indicator.position;
        Size = indicator.size;
    })

    draggable(main)

    local border = library:New('Frame', {
        Name = 'border';
        Parent = main;
        BackgroundColor3 = fromrgb(22, 22, 22);
        BorderColor3 = fromrgb(35, 35, 35);
        Size = newUDim2(1, 0, 1, 0);
        ZIndex = 2;
    })

    local holder = library:New('Frame', {
        Name = 'holder';
        Parent = border;
        BackgroundColor3 = fromrgb(35, 35, 35);
        BackgroundTransparency = 1.000;
        BorderColor3 = fromrgb(35, 35, 35);
        Size = newUDim2(1, 0, 1, 0);
        ZIndex = 2;
    })

    library:New('UIListLayout', {
        Parent = holder;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 0);
    })

    local title = library:New('Frame', {
        Name = 'title';
        Parent = holder;
        BackgroundColor3 = fromrgb(17, 17, 17);
        BorderColor3 = fromrgb(10, 10, 10);
        Size = newUDim2(1, 0, 0, 21);
        ZIndex = 2;
    })
    local border_2 = library:New('Frame', {
        Name = 'border';
        Parent = title;
        BackgroundColor3 = fromrgb(17, 17, 17);
        BorderColor3 = fromrgb(35, 35, 35);
        Size = newUDim2(1, 0, 1, 0);
        ZIndex = 2;
    })

    library:New('TextLabel', {
        Name = 'text';
        Parent = border_2;
        BackgroundColor3 = fromrgb(255, 255, 255);
        BackgroundTransparency = 1.000;
        BorderColor3 = fromrgb(0, 0, 0);
        BorderSizePixel = 0;
        Position = newUDim2(0, 6, 0.5, 0);
        ZIndex = 3;
        Size = newUDim2(0, 1, 0, 1);
        Font = Enum.Font.Code;
        TextXAlignment = Enum.TextXAlignment.Left;
        Text = indicator.title;
        TextColor3 = fromrgb(255, 255, 255);
        TextSize = 13.000;
        TextStrokeTransparency = 0.000;
    })

    function indicator:Update()
        main.Visible = indicator.enabled
        local jig = 0
        for _, v in next, holder:GetChildren() do
            if v.Name == 'value' and v.Visible then
                jig += 1
            end
        end
        main.Size = newUDim2(0, 200, 0, ((jig * 20)) + 21)
    end

    function indicator:AddValue(args)
        local value = {
            key = args.key or 'Key';
            state = args.value or 'Value';
            enabled = args.enabled or false;
        }

        local mains = library:New('Frame', {
            Name = 'value';
            Parent = holder;
            BackgroundColor3 = fromrgb(17, 17, 17);
            BackgroundTransparency = 1.000;
            BorderColor3 = fromrgb(10, 10, 10);
            Size = newUDim2(1, 0, 0, 20);
            ZIndex = 2;
        })

        local border2 = library:New('Frame', {
            Name = 'border';
            Parent = mains;
            BackgroundColor3 = fromrgb(17, 17, 17);
            BackgroundTransparency = 1.000;
            BorderColor3 = fromrgb(35, 35, 35);
            Size = newUDim2(1, 0, 1, 0);
            ZIndex = 3;
        })

        local value1 = library:New('TextLabel', {
            Name = 'value1';
            Parent = border2;
            BackgroundColor3 = fromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = fromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = newUDim2(0, 5, 0.5, 0);
            Size = newUDim2(0, 1, 0, 1);
            Font = Enum.Font.Code;
            ZIndex = 4;
            Text = value.key;
            TextColor3 = fromrgb(255, 255, 255);
            TextSize = 13.000;
            TextStrokeTransparency = 0.000;
            TextXAlignment = Enum.TextXAlignment.Left;
        })
        local value2 = library:New('TextLabel', {
            Name = 'value2';
            Parent = border2;
            BackgroundColor3 = fromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderColor3 = fromrgb(0, 0, 0);
            BorderSizePixel = 0;
            Position = newUDim2(0.980000019, 0, 0.5, 0);
            Size = newUDim2(0, 1, 0, 1);
            ZIndex = 4;
            Font = Enum.Font.Code;
            Text = value.state;
            TextColor3 = fromrgb(255, 255, 255);
            TextSize = 13.000;
            TextStrokeTransparency = 0.000;
            TextXAlignment = Enum.TextXAlignment.Right;
        })

        function value:SetKey(val)
            value.key = val
            value1.Text = val
            indicator:Update()
        end

        function value:SetValue(val)
            value.state = val
            value2.Text = val
            indicator:Update()
        end

        function value:Remove()
            mains:Destroy()
            table.remove(indicator.values, table.find(indicator.values, value))
            indicator:Update()
        end

        function value:SetEnabled(bool)
            if typeof(bool) == 'boolean' then
                mains.Visible = bool
                indicator:Update()
            end
        end

        table.insert(indicator.values, value)
        value:SetEnabled(value.enabled)
        indicator:Update()
        return value
    end

    function indicator:GetValues()
        return indicator.values
    end

    function indicator:SetEnabled(bool)
        if typeof(bool) == 'boolean' then
            indicator.enabled = bool
            indicator:Update()
        end
    end

    return indicator
end

local keybindIndicator = library:NewIndicator({
    title = 'Keybinds';
    position = newUDim2(0, 15, 0, workspace.CurrentCamera.ViewportSize.Y / 4);
    enabled = false;
})

function library:AddTab(name)
    local newTab = tabholder.tab:Clone()
    local newButton = tabviewer.button:Clone()

    table.insert(library.tabs,newTab)
    newTab.Parent = tabholder
    newTab.Visible = false

    table.insert(library.tabbuttons, newButton)
    newButton.Parent = tabviewer
    newButton.Modal = true
    newButton.Visible = true
    newButton.text.Text = name

    local tab = {}
    local groupCount = 0
    local jigCount = 0
    local topStuff = 2000

    for i,v in next, library.tabbuttons do
        v.Size = newUDim2(0,693/#library.tabbuttons,0,22)
    end

    function tab:AddSection(groupname, pos) -- newTab[pos == 0 and 'left' or 'right']

        groupCount -= 1

        local groupbox = library:New('Frame', {
            Parent = newTab[pos == 1 and 'left' or pos == 2 and 'center' or 'right'];
            BackgroundColor3 = fromrgb(255, 255, 255);
            BorderColor3 = fromrgb(35, 35, 35);
            BorderSizePixel = 2;
            Size = newUDim2(0, 215, 0, 8);
            ZIndex = groupCount;
        })

        local grouper = library:New('Frame', {
            Parent = groupbox;
            BackgroundColor3 = fromrgb(20, 20, 20);
            BorderColor3 = fromrgb(0, 0, 0);
            Size = newUDim2(1, 0, 1, 0);
        })

        library:New('UIListLayout', {
            Parent = grouper;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            SortOrder = Enum.SortOrder.LayoutOrder;
        })

        library:New('UIPadding', {
            Parent = grouper;
            PaddingBottom = UDim.new(0, 4);
            PaddingTop = UDim.new(0, 7);
        })

        library:New('Frame', {
            Name = 'element';
            Parent = groupbox;
            BackgroundColor3 = library.libColor;
            BorderSizePixel = 0;
            Size = newUDim2(1, 0, 0, 1);
        })

        local title = library:New('TextLabel', {
            Parent = groupbox;
            BackgroundColor3 = fromrgb(255, 255, 255);
            BackgroundTransparency = 1.000;
            BorderSizePixel = 0;
            Position = newUDim2(0, 17, 0, 0);
            ZIndex = 2;
            Font = 'Code';
            Text = groupname or '';
            TextColor3 = fromrgb(255, 255, 255);
            TextSize = 13.000;
            TextStrokeTransparency = 0.000;
            TextXAlignment = Enum.TextXAlignment.Left;
        })

        local backframe = library:New('Frame', {
            Parent = groupbox;
            BackgroundColor3 = fromrgb(20, 20, 20);
            BorderSizePixel = 0;
            Position = newUDim2(0, 10, 0, -2);
            Size = newUDim2(0, 13 + title.TextBounds.X, 0, 3);
        })

        local group = {}

        function group:SetEnabled(bool)
            if typeof(bool) == 'boolean' then
                groupbox.Visible = bool
            end
        end

        function group:AddToggle(args)
            if not args.flag and args.text then args.flag = args.text end
            if not args.flag then return warn('missing flags on recent toggle') end

            groupbox.Size += newUDim2(0, 0, 0, 20)
            jigCount -= 1
            library.multiZindex -= 1

            local toggleframe = library:New('Frame', {
                Name = 'toggleframe';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 0, 20);
                ZIndex = library.multiZindex;
            })

            local tobble = library:New('Frame', {
                Name = 'tobble';
                Parent = toggleframe;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 3;
                Position = newUDim2(0.0299999993, 0, 0.272000015, 0);
                Size = newUDim2(0, 10, 0, 10);
            })

            local mid = library:New('Frame', {
                Name = 'mid';
                Parent = tobble;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Size = newUDim2(0, 10, 0, 10);
            })

            local front = library:New('Frame', {
                Name = 'front';
                Parent = mid;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                Size = newUDim2(0, 10, 0, 10);
            })

            library:New('UIGradient', {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, fromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, fromrgb(171, 171, 171))};
                Rotation = 90;
                Name = 'gradient';
                Parent = front;
            })

            local text = library:New('TextLabel', {
                Name = 'text';
                Parent = toggleframe;
                BackgroundColor3 = fromrgb(55, 55, 55);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0, 22, 0, 0);
                Size = newUDim2(0, 0, 1, 2);
                Font = 'Code';
                Text = args.text or args.flag;
                TextColor3 = fromrgb(155, 155, 155);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local button = library:New('TextButton', {
                Name = 'button';
                Parent = toggleframe;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(0, 101, 1, 0);
                Font = 'SourceSans';
                Text = '';
                TextColor3 = fromrgb(0, 0, 0);
                TextSize = 14.000;
                ZIndex = library.multiZindex;
            })

            if args.risky then
                button.Visible = false
                text.TextColor3 = fromrgb(255,0,0)
                return
            end

            local state = false
            function toggle(newState)
                state = newState
                library.flags[args.flag] = state
                front.BackgroundColor3 = state and library.libColor or fromrgb(17, 17, 17)
                text.TextColor3 = state and fromrgb(244, 244, 244) or fromrgb(144, 144, 144)
                if args.callback then
                    args.callback(state)
                end
            end
            button.MouseButton1Click:Connect(function()
                state = not state
                front.Name = state and 'accent' or 'back'
                library.flags[args.flag] = state
                mid.BorderColor3 = fromrgb(35, 35, 35)
                front.BackgroundColor3 = state and library.libColor or fromrgb(17, 17, 17)
                text.TextColor3 = state and fromrgb(244, 244, 244) or fromrgb(144, 144, 144)
                if args.callback then
                    args.callback(state)
                end
            end)

            button.MouseEnter:Connect(function()
                library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
			end)

            button.MouseLeave:Connect(function()
                library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
			end)

            library.flags[args.flag] = args.state or false
            toggle(args.state or false)
            library.options[args.flag] = {type = 'toggle',changeState = toggle,skipflag = args.skipflag,oldargs = args,flag = args.flag, risky = args.risky or false}
            local toggle = {}
            function toggle:AddBind(args)
                if not args.flag then return warn('missing arguments') end
                local next = false
                local indicatorVal = keybindIndicator:AddValue({
                    key = 'key';
                    value = 'value';
                    enabled = false;
                })

                local keybind = library:New('Frame', {
                    Parent = toggleframe;
                    BackgroundColor3 = fromrgb(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Position = newUDim2(0.720000029, 4, 0.272000015, 0);
                    Size = newUDim2(0, 51, 0, 10);
                })

                local button = library:New('TextButton', {
                    Parent = keybind;
                    BackgroundColor3 = fromrgb(187, 131, 255);
                    BackgroundTransparency = 1.000;
                    BorderSizePixel = 0;
                    Position = newUDim2(-0.270902753, 0, 0, 0);
                    Size = newUDim2(1.27090275, 0, 1, 0);
                    Font = 'Code';
                    Text = args.key or 'Unknown';
                    TextColor3 = fromrgb(155, 155, 155);
                    TextSize = 13.000;
                    TextStrokeTransparency = 0.000;
                    TextXAlignment = Enum.TextXAlignment.Right;
                })

                function updateValue(val)
                    if library.colorpicking or library.dropdowned then return end
                    library.flags[args.flag] = val
                    button.Text = keyNames[val] or val.Name
                    indicatorVal:SetKey(args.text)
                    indicatorVal:SetValue(('[%s]'):format(keyNames[val] or val.Name))
                end

                inputService.InputBegan:Connect(function(key)
                    local key = key.KeyCode == Enum.KeyCode.Unknown and key.UserInputType or key.KeyCode
                    if next then
                        if not table.find(library.blacklisted,key) then
                            next = false
                            indicatorVal:SetKey(args.text)
                            indicatorVal:SetValue(('[%s]'):format(keyNames[key] or key.Name))
                            library.flags[args.flag] = key
                            button.Text = keyNames[key] or key.Name
                            button.TextColor3 = fromrgb(155, 155, 155)
                        end
                    end
                    if not next and key == library.flags[args.flag] and args.callback then
                        args.callback()
                    end
                end)

                button.MouseButton1Click:Connect(function()
                    if library.colorpicking or library.dropdowned then return end
                    library.flags[args.flag] = Enum.KeyCode.Unknown
                    button.Text = '--'
                    button.TextColor3 = library.libColor
                    next = true
                end)

                library.flags[args.flag] = Enum.KeyCode.Unknown
                library.options[args.flag] = {type = 'keybind',changeState = updateValue,skipflag = args.skipflag,oldargs = args}
                updateValue(args.bind or Enum.KeyCode.Unknown)
            end

            function toggle:AddColor(args)
                if not args.flag and args.text then args.flag = args.text end
                if not args.flag then return warn('missing arguments') end

                library.multiZindex -= 1
                jigCount -= 1
                topStuff -= 1 --args.second

                local currentTrans = args.trans or 0
                local currentColor = args.color or c3new(1,1,1)

                local colorpicker = library:New('Frame', {
                    Parent = toggleframe;
                    BackgroundColor3 = fromrgb(255, 255, 255);
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 3;
                    Position = args.second and newUDim2(0.720000029, 4, 0.272000015, 0) or newUDim2(0.860000014, 4, 0.272000015, 0);
                    Size = newUDim2(0, 20, 0, 10);
                })

                local mid = library:New('Frame', {
                    Name = 'mid';
                    Parent = colorpicker;
                    BackgroundColor3 = fromrgb(255, 255, 255);
                    BorderColor3 = fromrgb(35, 35, 35);
                    BorderSizePixel = 2;
                    Size = newUDim2(1, 0, 1, 0);
                })
                local front = library:New('Frame', {
                    Name = 'front';
                    Parent = mid;
                    BackgroundColor3 = fromrgb(240, 142, 214);
                    BackgroundTransparency = currentTrans;
                    BorderColor3 = fromrgb(0, 0, 0);
                    Size = newUDim2(1, 0, 1, 0);
                })
                local button2 = library:New('ImageButton', {
                    Parent = front;
                    BackgroundColor3 = fromrgb(255, 255, 255);
                    BackgroundTransparency = 1.000;
                    BorderSizePixel = 0;
                    Size = newUDim2(1, 0, 1, 0);
                    Image = 'rbxassetid://70140162';
                    ImageTransparency = 1 - currentTrans;
                    ScaleType = Enum.ScaleType.Crop;
                });

                local colorFrame = library:New('Frame', {
                    Name = 'colorFrame';
                    Parent = toggleframe;
                    Visible = false;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 2;
                    ZIndex = topStuff,
                    Position = newUDim2(0.101092957, 0, 0.75, 0);
                    Size = newUDim2(0, 150, 0, 128);
                })
                local colorFrame_2 = library:New('Frame', {
                    Name = 'colorFrame';
                    Parent = colorFrame;
                    BackgroundColor3 = fromrgb(20, 20, 20);
                    BorderColor3 = fromrgb(35, 35, 35);
                    Size = newUDim2(1, 0, 1, 0);
                })
                local hueframe = library:New('Frame', {
                    Name = 'hueframe';
                    Parent = colorFrame_2;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(35, 35, 35);
                    BorderSizePixel = 2;
                    Position = newUDim2(0, 6, -0.0599999987, 30);
                    Size = newUDim2(0, 100, 0, 100);
                })
                local main = library:New('Frame', {
                    Name = 'main';
                    Parent = hueframe;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(0, 0, 0);
                    Size = newUDim2(0, 100, 0, 100);
                    ZIndex = 6;
                })
                local picker = library:New('ImageLabel', {
                    Name = 'picker';
                    Parent = main;
                    BackgroundColor3 = currentColor;
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = newUDim2(0, 100, 0, 100);
                    ZIndex = 104;
                    Image = 'rbxassetid://2615689005';
                })
                local pickerframe = library:New('Frame', {
                    Name = 'pickerframe';
                    Parent = colorFrame_2;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(35, 35, 35);
                    BorderSizePixel = 2;
                    Position = newUDim2(0.711000025, 8, -0.0599999987, 30);
                    Size = newUDim2(0, 10, 0, 100);
                })
                local main_2 = library:New('Frame', {
                    Name = 'main';
                    Parent = pickerframe;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(0, 0, 0);
                    Size = newUDim2(1, 0, 1, 0);
                    ZIndex = 6;
                })
                local hue = library:New('ImageLabel', {
                    Name = 'hue';
                    Parent = main_2;
                    BackgroundColor3 = fromrgb(255, 0, 178);
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = newUDim2(1, 0, 1, 0);
                    ZIndex = 104;
                    Image = 'rbxassetid://2615692420';
                })

                local trans = library:New('Frame', {
                    Name = 'trans';
                    Parent = colorFrame_2;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(35, 35, 35);
                    BorderSizePixel = 2;
                    Position = newUDim2(0.711000025, 26, -0.0599999987, 30);
                    Size = newUDim2(0, 10, 0, 100);
                    Visible = false;
                })

                if args.trans then
                    trans.Visible = true
                end

                local main_3 = library:New('Frame', {
                    Name = 'main';
                    Parent = trans;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BorderColor3 = fromrgb(0, 0, 0);
                    Size = newUDim2(1, 0, 1, 0);
                    ZIndex = 6;
                })

                local trans_2 = library:New('ImageLabel', {
                    Name = 'trans';
                    Parent = main_3;
                    BackgroundColor3 = fromrgb(255, 255, 255);
                    BorderColor3 = fromrgb(0, 0, 0);
                    BorderSizePixel = 0;
                    Size = newUDim2(1, 0, 1, 0);
                    ZIndex = 104;
                    Image = 'rbxassetid://12223046356';
                })

                local clr = library:New('Frame', {
                    Name = 'clr';
                    Parent = colorFrame;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BackgroundTransparency = 1.000;
                    BorderColor3 = fromrgb(35, 35, 35);
                    BorderSizePixel = 2;
                    Position = newUDim2(0.0280000009, 0, 0, 2);
                    Size = newUDim2(0, 129, 0, 14);
                    ZIndex = 5;
                })
                local copy = library:New('TextButton', {
                    Name = 'copy';
                    Parent = clr;
                    BackgroundColor3 = fromrgb(17, 17, 17);
                    BackgroundTransparency = 1.000;
                    BorderSizePixel = 0;
                    Size = newUDim2(0, 129, 0, 14);
                    ZIndex = library.multiZindex;
                    Font = 'SourceSans';
                    Text = args.text or args.flag;
                    TextColor3 = fromrgb(100, 100, 100);
                    TextSize = 14.000;
                    TextStrokeTransparency = 0.000;
                })

                copy.MouseButton1Click:Connect(function() -- '  '..args.text or '  '..args.flag
                    colorFrame.Visible = false
                end)

                button2.MouseButton1Click:Connect(function()
                    colorFrame.Visible = not colorFrame.Visible
                    if colorFrame.Visible then
                        for i,v in next, library.toInvis do
                            if v ~= colorFrame then
                                v.Visible = false
                            end
                        end
                    end
                    library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
                end)

                button2.MouseEnter:Connect(function()
                    library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
                end)
                button2.MouseLeave:Connect(function()
                    library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
                end)

                local function updateValue(tbl)
                    library.flags[args.flag] = tbl
                    --print(library.flags[args.flag][1])
                    front.BackgroundColor3 = tbl[1]
                    trans_2.BackgroundColor3 = tbl[1]
                    front.BackgroundTransparency = tbl[2]
                    button2.ImageTransparency = 1 - tbl[2]
                    currentColor = tbl[1]
                    currentTrans = tbl[2]
                    --picker.BackgroundColor3 = value
                    if args.callback then
                        args.callback(tbl[1], tbl[2])
                    end
                end

                local white, black = c3new(1,1,1), c3new(0,0,0)
                local colors = {c3new(1,0,0),c3new(1,1,0),c3new(0,1,0),c3new(0,1,1),c3new(0,0,1),c3new(1,0,1),c3new(1,0,0)}
                local heartbeat = runService.Heartbeat

                local pickerX,pickerY,hueY,transY = 0,0,0,0
                local oldpercentX,oldpercentY = 0,0


                hue.MouseEnter:Connect(function()
                    local input = hue.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local percent = (hueY-hue.AbsolutePosition.Y-36)/hue.AbsoluteSize.Y
                                local num = math.max(1, math.min(7,math.floor(((percent*7+0.5)*100))/100))
                                local startC = colors[math.floor(num)]
                                local endC = colors[math.ceil(num)]
                                local color = white:lerp(picker.BackgroundColor3, oldpercentX):lerp(black, oldpercentY)
                                picker.BackgroundColor3 = startC:lerp(endC, num-math.floor(num)) or c3new(0, 0, 0)
                                currentColor = color
                                --print(currentColor)
                                updateValue({color, currentTrans})
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = hue.MouseLeave:Connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                picker.MouseEnter:Connect(function()
                    local input = picker.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local xPercent = (pickerX-picker.AbsolutePosition.X)/picker.AbsoluteSize.X
                                local yPercent = (pickerY-picker.AbsolutePosition.Y-36)/picker.AbsoluteSize.Y
                                local color = white:lerp(picker.BackgroundColor3, xPercent):lerp(black, yPercent)
                                currentColor = color
                                --print(currentColor)
                                updateValue({color, currentTrans})
                                oldpercentX,oldpercentY = xPercent,yPercent
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = picker.MouseLeave:Connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                trans_2.MouseEnter:Connect(function()
                    local input = trans_2.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local percent = (transY-trans_2.AbsolutePosition.Y-36)/trans_2.AbsoluteSize.Y
                                trans = tonumber(('%.2f'):format(tostring(percent)))
                                currentTrans = trans
                                --print(currentColor)
                                updateValue({currentColor, trans})
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = trans_2.MouseLeave:Connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                --
                hue.MouseMoved:Connect(function(_, y) hueY = y end)
                trans_2.MouseMoved:Connect(function(_, y) transY = y end)
                picker.MouseMoved:Connect(function(x, y) pickerX, pickerY = x,y end)
                --

                table.insert(library.toInvis,colorFrame)
                library.flags[args.flag] = {c3new(1,1,1), 0}
                library.options[args.flag] = {type = 'colorpicker',changeState = updateValue,skipflag = args.skipflag,oldargs = args}

                updateValue({args.color or c3new(1,1,1), args.trans or 0})
            end
            return toggle
        end
        function group:AddButton(args)
            if not args.callback or not args.text then return warn('missing arguments') end
            groupbox.Size += newUDim2(0, 0, 0, 22)
            library.multiZindex -= 1

            local buttonframe = library:New('Frame', {
                Name = 'buttonframe';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 0, 21);
            })
            local bg = library:New('Frame', {
                Name = 'bg';
                Parent = buttonframe;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = newUDim2(0.0299999993, -1, 0.140000001, 0);
                Size = newUDim2(0, 205, 0, 15);
            })
            local main = library:New('Frame', {
                Name = 'main';
                Parent = bg;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
            })
            local button = library:New('TextButton', {
                Name = 'button';
                Parent = main;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 1, 0);
                Font = 'Code';
                Text = args.text or args.flag;
                ZIndex = library.multiZindex;
                TextColor3 = fromrgb(255, 255, 255);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
            })
            library:New('UIGradient', {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, fromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, fromrgb(171, 171, 171))};
                Rotation = 90;
                Name = 'gradient';
                Parent = main;
            })

            local clicked, counting = false, false
            button.MouseButton1Click:Connect(function()
                if not library.colorpicking then
                    task.spawn(function()
                        if args.confirm then
                            if clicked then
                                clicked = false
                                counting = false
                                button.Text = args.text or args.flag
                                args.callback()
                            else
                                clicked = true
                                counting = true
                                for i = 3,1,-1 do
                                    if not counting then
                                        break
                                    end
                                    button.Text = ('Confirm? (%u)'):format(i)
                                    task.wait(1)
                                end
                                clicked = false
                                counting = false
                                button.Text = args.text or args.flag
                            end
                        else
                            args.callback()
                        end
                    end)
                end
            end)
            button.MouseEnter:Connect(function()
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
			end)
			button.MouseLeave:Connect(function()
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
			end)
        end
        function group:AddSlider(args)
            if not args.flag or not args.max or not args.increment then return warn('âš ï¸ missing arguments âš ï¸') end
            if args.text then
                groupbox.Size += newUDim2(0, 0, 0, 30)
            else
                groupbox.Size += newUDim2(0, 0, 0, 20)
            end
            library.multiZindex -= 1

            local slider = library:New('Frame', {
                Name = 'slider';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = args.text and newUDim2(1, 0, 0, 30) or newUDim2(1, 0, 0, 20);
            })
            local bg = library:New('Frame', {
                Name = 'bg';
                Parent = slider;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = args.text and newUDim2(0.0299999993, -1, 0, 16) or newUDim2(0.0299999993, -1, 0.22, 0);
                Size = newUDim2(0, 205, 0, 10);
            })
            local main = library:New('Frame', {
                Name = 'main';
                Parent = bg;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
            })
            local fill = library:New('Frame', {
                Name = 'fill';
                Parent = main;
                BackgroundColor3 = library.libColor;
                BackgroundTransparency = 0.200;
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 0;
                Size = newUDim2(0.617238641, 13, 1, 0);
            })
            local button = library:New('TextButton', {
                Name = 'button';
                Parent = main;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Size = newUDim2(1, 0, 1, 0);
                Font = 'SourceSans';
                Text = '';
                TextColor3 = fromrgb(0, 0, 0);
                ZIndex = library.multiZindex;
                TextSize = 14.000;
            })
            local valuetext = library:New('TextLabel', {
                Parent = main;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.5, 0, 0.5, 0);
                Font = 'Code';
                Text = '';
                TextColor3 = fromrgb(255, 255, 255);
                TextSize = 14.000;
                TextStrokeTransparency = 0.000;
            })
            library:New('TextLabel', {
                Name = 'text';
                Parent = slider;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.0299999993, -1, 0, 7);
                ZIndex = 2;
                Font = 'Code';
                Text = args.text or args.flag;
                Visible = args.text and true or false;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local entered = false
			local scrolling = false

            --------------------------------------

            local function updateValue(value)
                if library.colorpicking or library.dropdowned then return end
                local size, pos = fill.Size, fill.Position

				if args.min >= 0 then
					size = newUDim2((value - args.min) / (args.max - args.min), 0, 1, 0)
				else
					size = newUDim2(value / (args.max - args.min), 0, 1, 0)
                    pos = newUDim2((0 - args.min) / (args.max - args.min), 0, 0, 0)
                end

                fill:TweenSize(size, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.05)
                fill:TweenPosition(pos, Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.05)

                valuetext.Text = value..args.suffix
                library.flags[args.flag] = value
                if args.callback then
                    args.callback(value)
                end
			end

			local function updateScroll()
                if scrolling or library.scrolling or not newTab.Visible or library.colorpicking or library.dropdowned then return end
                while inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and menu.Enabled do runService.RenderStepped:Wait()

                    library.scrolling = true
                    valuetext.TextColor3 = fromrgb(255,255,255)
					scrolling = true
                    ----
                    local val = library:ConvertNumberRange((inputService:GetMouseLocation() - button.AbsolutePosition).X, 0 , button.AbsoluteSize.X, args.min, args.max);
                    local newValue

                    if args.increment < 1 then
                        local numdec = string.len(string.split(args.increment, '.')[2])
                        newValue = tonumber(('%.'..numdec..'f'):format( math.clamp(args.increment * (val/args.increment), args.min, args.max)))
                    else
                        newValue = math.clamp(args.increment * math.floor(val/args.increment), args.min, args.max)
                    end

					if newValue > args.max then newValue = args.max end
                    if newValue < args.min then newValue = args.min end
					updateValue(newValue)
                end
                if scrolling and not entered then
                    valuetext.TextColor3 = fromrgb(255,255,255)
                end
                if not menu.Enabled then
                    entered = false
                end
                scrolling = false
                library.scrolling = false
			end

			button.MouseEnter:Connect(function()
                if library.colorpicking or library.dropdowned then return end
				if scrolling or entered then return end
                entered = true
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
				while entered do wait()
					updateScroll()
				end
			end)

			button.MouseLeave:Connect(function()
                entered = false
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
			end)

            if args.value then
                updateValue(args.value)
            end

            library.flags[args.flag] = 0
            library.options[args.flag] = {type = 'slider',changeState = updateValue,skipflag = args.skipflag,oldargs = args}
            updateValue(args.value or 0)
        end
        function group:AddText(args)
            if not args.flag then return warn('missing arguments') end
            groupbox.Size += newUDim2(0, 0, 0, 35)

            local textbox = library:New('Frame', {
                Name = 'textbox';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 0, 35);
                ZIndex = 10;
            })
            local bg = library:New('Frame', {
                Name = 'bg';
                Parent = textbox;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = newUDim2(0.0299999993, -1, 0, 16);
                Size = newUDim2(0, 205, 0, 15);
            })
            local main = library:New('ScrollingFrame', {
                Name = 'main';
                Parent = bg;
                Active = true;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
                CanvasSize = newUDim2(0, 0, 0, 0);
                ScrollBarThickness = 0;
            })
            local box = library:New('TextBox', {
                Name = 'box';
                Parent = main;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Selectable = false;
                Size = newUDim2(1, 0, 1, 2);
                Font = 'Code';
                Text = args.value or '';
                TextColor3 = fromrgb(255, 255, 255);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            local gradient = library:New('UIGradient', {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, fromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, fromrgb(171, 171, 171))};
                Rotation = 90;
                Name = 'gradient';
                Parent = main;
            })
            local text = library:New('TextLabel', {
                Name = 'text';
                Parent = textbox;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.0299999993, -1, 0, 7);
                ZIndex = 2;
                Font = 'Code';
                Text = args.text or args.flag;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            box:GetPropertyChangedSignal('Text'):Connect(function(val)
                if library.colorpicking or library.dropdowned then return end
                library.flags[args.flag] = box.Text
                args.value = box.Text
                if args.callback then
                    args.callback()
                end
            end)

            library.flags[args.flag] = args.value or ''
            library.options[args.flag] = {type = 'textbox',changeState = function(text) box.Text = text end,skipflag = args.skipflag,oldargs = args}
        end
        function group:AddSeparator(args)
            groupbox.Size += newUDim2(0, 0, 0, 15)

            local div = library:New('Frame', {
                Name = 'div';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = newUDim2(0, 0, 0.743662, 0);
                Size = newUDim2(0, 202, 0, 15);
            })
            local text = library:New('TextLabel', {
                Name = 'text';
                Parent = div;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Size = newUDim2(0,0,0,0);
                Position = newUDim2(0.5, 0, 0.5, 0);
                ZIndex = 2;
                Font = 'Code';
                Text = args.text;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Center;
            })
        end
        function group:AddList(args)
            if not args.flag or not args.values then return warn('missing arguments') end
            if args.text then
                groupbox.Size += newUDim2(0, 0, 0, 35)
            else
                groupbox.Size += newUDim2(0, 0, 0, 25)
            end

            library.multiZindex -= 1

            local list = library:New('Frame', {
                Name = 'list';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = args.text and newUDim2(1, 0, 0, 35) or newUDim2(1, 0, 0, 25);
                ZIndex = library.multiZindex;
            })
            local bg = library:New('Frame', {
                Name = 'bg';
                Parent = list;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = args.text and newUDim2(0.0299999993, -1, 0, 16) or newUDim2(0.0299999993, -1, 0, 5);
                Size = newUDim2(0, 205, 0, 15);
            })
            local main = library:New('ScrollingFrame', {
                Name = 'main';
                Parent = bg;
                Active = true;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
                CanvasSize = newUDim2(0, 0, 0, 0);
                ScrollBarThickness = 0;
            })
            local button = library:New('TextButton', {
                Name = 'button';
                Parent = main;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Size = newUDim2(0, 191, 1, 0);
                Font = 'SourceSans';
                Text = '';
                ZIndex = library.multiZindex;
                TextColor3 = fromrgb(0, 0, 0);
                TextSize = 14.000;
            })
            local dumbtriangle = library:New('ImageLabel', {
                Name = 'dumbtriangle';
                Parent = main;
                BackgroundColor3 = fromrgb(0, 0, 0);
                BackgroundTransparency = 1.000;
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = newUDim2(1, -11, 0.5, -3);
                Size = newUDim2(0, 7, 0, 6);
                ZIndex = 3;
                Image = 'rbxassetid://8532000591';
            })
            local valuetext = library:New('TextLabel', {
                Name = 'valuetext';
                Parent = main;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.00200000009, 3, 0, 8);
                ZIndex = 2;
                Font = 'Code';
                Text = '';
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            local gradient = library:New('UIGradient', {
                Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, fromrgb(255, 255, 255)), ColorSequenceKeypoint.new(1.00, fromrgb(171, 171, 171))};
                Rotation = 90;
                Name = 'gradient';
                Parent = main;
            })
            local text = library:New('TextLabel', {
                Name = 'text';
                Parent = list;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.0299999993, -1, 0, 7);
                ZIndex = 2;
                Font = 'Code';
                Visible = args.text and true or false;
                Text = args.text or args.flag;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local frame = library:New('Frame', {
                Name = 'frame';
                Parent = list;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = args.text and newUDim2(0.0299999993, -1, 0.605000019, 15) or newUDim2(0.0299999993, -1, 0.605000019, 10);
                Size = newUDim2(0, 205, 0, 0);
                Visible = false;
                ZIndex = library.multiZindex;
            })

            local holder = library:New('Frame', {
                Name = 'holder';
                Parent = frame;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
                ZIndex = library.multiZindex;
            })
            local UIListLayout = library:New('UIListLayout', {
                Parent = holder;
                SortOrder = Enum.SortOrder.LayoutOrder;
            })

            function setcallback(p_callback)
                args.callback = p_callback
            end

			local function updateValue(value)
                if value == nil then valuetext.Text = 'None' return end
				if args.multiselect then
                    if type(value) == 'string' then
                        if not table.find(library.options[args.flag].values,value) then return end
                        if table.find(library.flags[args.flag],value) then
                            for i,v in pairs(library.flags[args.flag]) do
                                if v == value then
                                    table.remove(library.flags[args.flag],i)
                                end
                            end
                        else
                            table.insert(library.flags[args.flag],value)
                        end
                    else
                        library.flags[args.flag] = value
                    end
					local buttonText = ''
					for i,v in pairs(library.flags[args.flag]) do
						local jig = i ~= #library.flags[args.flag] and ', ' or ''
						buttonText = buttonText..v..jig
					end
                    if buttonText == '' then buttonText = 'None' end
					for i,v in next, holder:GetChildren() do
						if v.ClassName ~= 'Frame' then continue end
						v.off.TextColor3 = c3new(0.65,0.65,0.65)
						for _i,_v in next, library.flags[args.flag] do
							if v.Name == _v then
								v.off.TextColor3 = c3new(1,1,1)
							end
						end
					end
					valuetext.Text = buttonText
					if args.callback then
						args.callback(library.flags[args.flag])
					end
				else
                    if not table.find(library.options[args.flag].values,value) then value = library.options[args.flag].values[1] end
                    library.flags[args.flag] = value
					for i,v in next, holder:GetChildren() do
						if v.ClassName ~= 'Frame' then continue end
						v.off.TextColor3 = c3new(0.65,0.65,0.65)
                        if v.Name == library.flags[args.flag] then
                            v.off.TextColor3 = c3new(1,1,1)
                        end
					end
					frame.Visible = false
                    library.dropdowned = false
                    if library.flags[args.flag] then
                        valuetext.Text = library.flags[args.flag]
                        if args.callback then
                            args.callback(library.flags[args.flag])
                        end
                    end
				end
			end


            function refresh(tbl)
                for i,v in next, holder:GetChildren() do
                    if v.ClassName == 'Frame' then
                        v:Destroy()
                    end
					frame.Size = newUDim2(0, 203, 0, 0)
                end
                for i,v in pairs(tbl) do
                    frame.Size += newUDim2(0, 0, 0, 20)

                    local option = library:New('Frame', {
                        Name = v;
                        Parent = holder;
                        BackgroundColor3 = fromrgb(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Size = newUDim2(1, 0, 0, 20);
                    })
                    local button_2 = library:New('TextButton', {
                        Name = 'button';
                        Parent = option;
                        BackgroundColor3 = fromrgb(17, 17, 17);
                        BackgroundTransparency = 0.850;
                        BorderSizePixel = 0;
                        Size = newUDim2(1, 0, 1, 0);
                        Font = 'SourceSans';
                        ZIndex = library.multiZindex;
                        Text = '';
                        TextColor3 = fromrgb(0, 0, 0);
                        TextSize = 14.000;
                    })
                    library:New('TextLabel', {
                        Name = 'off';
                        Parent = option;
                        BackgroundColor3 = fromrgb(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Position = newUDim2(0, 4, 0, 0);
                        Size = newUDim2(0, 0, 1, 0);
                        Font = 'Code';
                        Text = v;
                        TextColor3 = args.multiselect and c3new(0.65,0.65,0.65) or c3new(1,1,1);
                        TextSize = 14.000;
                        TextStrokeTransparency = 0.000;
                        TextXAlignment = Enum.TextXAlignment.Left;
                    })

                    button_2.MouseButton1Click:Connect(function()
                        updateValue(v)
                    end)
                end
                library.options[args.flag].values = tbl
                updateValue(table.find(library.options[args.flag].values,library.flags[args.flag]) and library.flags[args.flag] or library.options[args.flag].values[1])
            end

            button.MouseButton1Click:Connect(function()
                if not library.colorpicking then
                    frame.Visible = not frame.Visible
                    library.dropdowned = frame.Visible
                    if frame.Visible then
                        for i,v in next, library.toInvis do
                            if v ~= frame then
                                v.Visible = false
                            end
                        end
                    end
                end
            end)
            button.MouseEnter:Connect(function()
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
			end)
			button.MouseLeave:Connect(function()
                library:Tween(main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
			end)

            table.insert(library.toInvis,frame)
            library.flags[args.flag] = args.multiselect and {} or ''
            library.options[args.flag] = {type = 'list',changeState = updateValue,changeCallback = setcallback,values = args.values,refresh = refresh,skipflag = args.skipflag,oldargs = args}

            refresh(args.values)
            updateValue(args.selected or not args.multiselect and args.values[1] or 'abcdefghijklmnopqrstuwvxyz')
        end
        function group:AddListBox(args)
            if not args.flag or not args.values then return warn('missing arguments') end
            groupbox.Size += newUDim2(0, 0, 0, 138)
            library.multiZindex -= 1

            local list2 = library:New('Frame', {
                Name = 'list2';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = newUDim2(0, 0, 0.108108111, 0);
                Size = newUDim2(1, 0, 0, 138);
            })
            local frame = library:New('Frame', {
                Name = 'frame';
                Parent = list2;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                Position = newUDim2(0.0299999993, -1, 0.0439999998, 0);
                Size = newUDim2(0, 205, 0, 128);
            })
            local main = library:New('Frame', {
                Name = 'main';
                Parent = frame;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
            })
            local holder = library:New('ScrollingFrame', {
                Name = 'holder';
                Parent = main;
                Active = true;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = newUDim2(0, 0, 0.00571428565, 0);
                Size = newUDim2(1, 0, 1, 0);
                BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png';
                CanvasSize = newUDim2(0, 0, 0, 0);
                ScrollBarThickness = 0;
                TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png';
                AutomaticCanvasSize = Enum.AutomaticSize.Y;
                ScrollingEnabled = true;
                ScrollBarImageTransparency = 0;
            })
            local UIListLayout = library:New('UIListLayout', {
                Parent = holder;
            })
            local dwn = library:New('ImageLabel', {
                Name = 'dwn';
                Parent = frame;
                BackgroundColor3 = fromrgb(0, 0, 0);
                BackgroundTransparency = 1.000;
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = newUDim2(0.930000007, 4, 1, -9);
                Size = newUDim2(0, 7, 0, 6);
                ZIndex = 3;
                Image = 'rbxassetid://8548723563';
                Visible = false;
            })
            local up = library:New('ImageLabel', {
                Name = 'up';
                Parent = frame;
                BackgroundColor3 = fromrgb(0, 0, 0);
                BackgroundTransparency = 1.000;
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Position = newUDim2(0, 3, 0, 3);
                Size = newUDim2(0, 7, 0, 6);
                ZIndex = 3;
                Image = 'rbxassetid://8548757311';
                Visible = false;
            })
            
            function setcallback(p_callback)
                args.callback = p_callback
            end

            local function updateValue(value)
                if value == nil then return end
                if not table.find(library.options[args.flag].values,value) then value = library.options[args.flag].values[1] end
                library.flags[args.flag] = value

                for i,v in next, holder:GetChildren() do
                    if v.ClassName ~= 'Frame' then continue end
                    if v.TheOne.Text == library.flags[args.flag] then
                        v.TheOne.TextColor3 = library.libColor
                    else
                        v.TheOne.TextColor3 = fromrgb(255,255,255)
                    end
                end
                if library.flags[args.flag] then
                    if args.callback then
                        args.callback(library.flags[args.flag])
                    end
                end
                holder.Visible = true
            end
            holder:GetPropertyChangedSignal('CanvasPosition'):Connect(function()
                up.Visible = (holder.CanvasPosition.Y > 1)
                dwn.Visible = (holder.CanvasPosition.Y + 1 < (holder.AbsoluteCanvasSize.Y - holder.AbsoluteSize.Y))
            end)

            


            function refresh(tbl)
                for i,v in next, holder:GetChildren() do
                    if v.ClassName == 'Frame' then
                        v:Destroy()
                    end
                end
                for i,v in pairs(tbl) do
                    local item = library:New('Frame', {
                        Name = v;
                        Parent = holder;
                        Active = true;
                        BackgroundColor3 = fromrgb(0, 0, 0);
                        BackgroundTransparency = 1.000;
                        BorderColor3 = fromrgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Size = newUDim2(1, 0, 0, 18);
                    })
                    local button = library:New('TextButton', {
                        Parent = item;
                        BackgroundColor3 = fromrgb(17, 17, 17);
                        BackgroundTransparency = 1;
                        BorderColor3 = fromrgb(0, 0, 0);
                        BorderSizePixel = 0;
                        Size = newUDim2(1, 0, 1, 0);
                        Text = '';
                        TextTransparency = 1.000;
                    })
                    local text = library:New('TextLabel', {
                        Name = 'TheOne';
                        Parent = item;
                        BackgroundColor3 = fromrgb(255, 255, 255);
                        BackgroundTransparency = 1.000;
                        Size = newUDim2(1, 0, 0, 18);
                        Font = 'Code';
                        Text = v;
                        TextColor3 = fromrgb(255, 255, 255);
                        TextSize = 14.000;
                        TextStrokeTransparency = 0.000;
                    })

                    button.MouseButton1Click:Connect(function()
                        updateValue(v)
                    end)
                end

                holder.Visible = true
                library.options[args.flag].values = tbl
                updateValue(table.find(library.options[args.flag].values,library.flags[args.flag]) and library.flags[args.flag] or library.options[args.flag].values[1])
            end


            library.flags[args.flag] = ''
            library.options[args.flag] = {type = 'cfg', changeCallback = setcallback, changeState = updateValue,values = args.values,refresh = refresh,skipflag = args.skipflag,oldargs = args}

            refresh(args.values)
            updateValue(args.value or not args.multiselect and args.values[1] or 'abcdefghijklmnopqrstuwvxyz')
        end
        function group:AddColor(args)
            if not args.flag then return warn('missing arguments') end
            groupbox.Size += newUDim2(0, 0, 0, 20)

            library.multiZindex -= 1
            jigCount -= 1
            topStuff -= 1

            local currentTrans, currentColor = args.trans or 0, args.color or c3new(1,1,1)

            local colorpicker = library:New('Frame', {
                Name = 'colorpicker';
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 0, 20);
                ZIndex = library.multiZindex;
            })
            local colorpicker_2 = library:New('Frame', {
                Name = 'colorpicker';
                Parent = colorpicker;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 3;
                Position = newUDim2(0.860000014, 4, 0.272000015, 0);
                Size = newUDim2(0, 20, 0, 10);
            })
            local mid = library:New('Frame', {
                Name = 'mid';
                Parent = colorpicker_2;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Size = newUDim2(1, 0, 1, 0);
            })
            local front = library:New('Frame', {
                Name = 'front';
                Parent = mid;
                BackgroundColor3 = fromrgb(240, 142, 214);
                BorderColor3 = fromrgb(0, 0, 0);
                Size = newUDim2(1, 0, 1, 0);
            })
            local button2 = library:New('ImageButton', {
                Parent = front;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 1, 0);
                Image = 'rbxassetid://70140162';
                ImageTransparency = 1 - currentTrans;
                ScaleType = Enum.ScaleType.Crop;
            });

            local text = library:New('TextLabel', {
                Name = 'text';
                Parent = colorpicker;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.0299999993, -1, 0, 10);
                Font = 'Code';
                Text = args.text or args.flag;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })

            local colorFrame = library:New('Frame', {
                Name = 'colorFrame';
                Parent = colorpicker;
                Visible = false;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 2;
                ZIndex = topStuff,
                Position = newUDim2(0.101092957, 0, 0.75, 0);
                Size = newUDim2(0, 150, 0, 128);
            })
			local colorFrame_2 = library:New('Frame', {
                Name = 'colorFrame';
                Parent = colorFrame;
                BackgroundColor3 = fromrgb(20, 20, 20);
                BorderColor3 = fromrgb(35, 35, 35);
                Size = newUDim2(1, 0, 1, 0);
            })
			local hueframe = library:New('Frame', {
                Name = 'hueframe';
                Parent = colorFrame_2;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Position = newUDim2(0, 6, -0.0599999987, 30);
                Size = newUDim2(0, 100, 0, 100);
            })
			local main = library:New('Frame', {
                Name = 'main';
                Parent = hueframe;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                Size = newUDim2(0, 100, 0, 100);
                ZIndex = 6;
            })
			local picker = library:New('ImageLabel', {
                Name = 'picker';
                Parent = main;
                BackgroundColor3 = currentColor;
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = newUDim2(0, 100, 0, 100);
                ZIndex = 104;
                Image = 'rbxassetid://2615689005';
            })
			local pickerframe = library:New('Frame', {
                Name = 'pickerframe';
                Parent = colorFrame_2;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Position = newUDim2(0.711000025, 8, -0.0599999987, 30);
                Size = newUDim2(0, 10, 0, 100);
            })
			local main_2 = library:New('Frame', {
                Name = 'main';
                Parent = pickerframe;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                Size = newUDim2(1, 0, 1, 0);
                ZIndex = 6;
            })
            local hue = library:New('ImageLabel', {
                Name = 'hue';
                Parent = main_2;
                BackgroundColor3 = fromrgb(255, 0, 178);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 1, 0);
                ZIndex = 104;
                Image = 'rbxassetid://2615692420';
            })

            local trans = library:New('Frame', {
                Name = 'trans';
                Parent = colorFrame_2;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Position = newUDim2(0.711000025, 26, -0.0599999987, 30);
                Size = newUDim2(0, 10, 0, 100);
                Visible = false;
            })

            if args.trans then
                trans.Visible = true
            end

            local main_3 = library:New('Frame', {
                Name = 'main';
                Parent = trans;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BorderColor3 = fromrgb(0, 0, 0);
                Size = newUDim2(1, 0, 1, 0);
                ZIndex = 6;
            })

            local trans_2 = library:New('ImageLabel', {
                Name = 'trans';
                Parent = main_3;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BorderColor3 = fromrgb(0, 0, 0);
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 1, 0);
                ZIndex = 104;
                Image = 'http://www.roblox.com/asset/?id=12223046356';
            })

			local clr = library:New('Frame', {
                Name = 'clr';
                Parent = colorFrame;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BackgroundTransparency = 1.000;
                BorderColor3 = fromrgb(35, 35, 35);
                BorderSizePixel = 2;
                Position = newUDim2(0.0280000009, 0, 0, 2);
                Size = newUDim2(0, 129, 0, 14);
                ZIndex = 5;
            })
			local copy = library:New('TextButton', {
                Name = 'copy';
                Parent = clr;
                BackgroundColor3 = fromrgb(17, 17, 17);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(0, 129, 0, 14);
                ZIndex = library.multiZindex;
                Font = 'SourceSans';
                Text = args.text or args.flag;
                TextColor3 = fromrgb(100, 100, 100);
                TextSize = 14.000;
                TextStrokeTransparency = 0.000;
            })

            copy.MouseButton1Click:Connect(function()
                colorFrame.Visible = false
            end)

            button2.MouseButton1Click:Connect(function()
				colorFrame.Visible = not colorFrame.Visible
                if colorFrame.Visible then
                    for i,v in next, library.toInvis do
                        if v ~= colorFrame then
                            v.Visible = false
                        end
                    end
                end
                mid.BorderColor3 = fromrgb(35, 35, 35)
            end)

            button2.MouseEnter:Connect(function()
                library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = library.libColor})
            end)
            button2.MouseLeave:Connect(function()
                library:Tween(mid, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BorderColor3 = fromrgb(35, 35, 35)})
            end)

                local function updateValue(tbl)
                    library.flags[args.flag] = tbl
                    front.BackgroundColor3 = tbl[1]
                    trans_2.BackgroundColor3 = tbl[1]
                    front.BackgroundTransparency = tbl[2]
                    button2.ImageTransparency = 1 - tbl[2]
                    currentColor = tbl[1]
                    currentTrans = tbl[2]
                    if args.callback then
                        args.callback(tbl[1], tbl[2])
                    end
                end

                local white, black = c3new(1,1,1), c3new(0,0,0)
                local colors = {c3new(1,0,0),c3new(1,1,0),c3new(0,1,0),c3new(0,1,1),c3new(0,0,1),c3new(1,0,1),c3new(1,0,0)}
                local heartbeat = runService.Heartbeat

                local pickerX,pickerY,hueY,transY = 0,0,0,0
                local oldpercentX,oldpercentY = 0,0

                hue.MouseEnter:Connect(function()
                    local input = hue.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local percent = (hueY-hue.AbsolutePosition.Y-36)/hue.AbsoluteSize.Y
                                local num = math.max(1, math.min(7,math.floor(((percent*7+0.5)*100))/100))
                                local startC = colors[math.floor(num)]
                                local endC = colors[math.ceil(num)]
                                local color = white:lerp(picker.BackgroundColor3, oldpercentX):lerp(black, oldpercentY)
                                picker.BackgroundColor3 = startC:lerp(endC, num-math.floor(num)) or c3new(0, 0, 0)
                                currentColor = color
                                updateValue({color, currentTrans})
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = hue.MouseLeave:Connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                picker.MouseEnter:Connect(function()
                    local input = picker.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local xPercent = (pickerX-picker.AbsolutePosition.X)/picker.AbsoluteSize.X
                                local yPercent = (pickerY-picker.AbsolutePosition.Y-36)/picker.AbsoluteSize.Y
                                local color = white:lerp(picker.BackgroundColor3, xPercent):lerp(black, yPercent)
                                currentColor = color
                                updateValue({color, currentTrans})
                                oldpercentX,oldpercentY = xPercent,yPercent
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = picker.MouseLeave:Connect(function()
                        input:disconnect()
                        leave:disconnect()
                    end)
                end)

                trans_2.MouseEnter:Connect(function()
                    local input = trans_2.InputBegan:Connect(function(key)
                        if key.UserInputType == Enum.UserInputType.MouseButton1 then
                            while heartbeat:wait() and inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                                library.colorpicking = true
                                local percent = (transY-trans_2.AbsolutePosition.Y-36)/trans_2.AbsoluteSize.Y
                                trans = tonumber(('%.2f'):format(tostring(percent)))
                                currentTrans = trans
                                updateValue({currentColor, trans})
                            end
                            library.colorpicking = false
                        end
                    end)
                    local leave
                    leave = trans_2.MouseLeave:Connect(function()
                    input:disconnect()
                    leave:disconnect()
                end)
            end)

            --
            hue.MouseMoved:Connect(function(_, y) hueY = y end)
            trans_2.MouseMoved:Connect(function(_, y) transY = y end)
            picker.MouseMoved:Connect(function(x, y) pickerX, pickerY = x,y end)
            --
            table.insert(library.toInvis,colorFrame)
            library.flags[args.flag] = {c3new(1,1,1), 0}
            library.options[args.flag] = {type = 'colorpicker',changeState = updateValue,skipflag = args.skipflag,oldargs = args}

            updateValue({args.color or c3new(1,1,1), args.trans or 0})
        end
        function group:AddBind(args)
            if not args.flag then return warn('missing arguments') end
            groupbox.Size += newUDim2(0, 0, 0, 20)
            local next = false
            local indicatorVal = keybindIndicator:AddValue({
                key = 'key';
                value = 'value';
                enabled = false;
            })

                --library.flags[args.flag] = Enum.KeyCode.Unknown
            local keybindframe = library:New('Frame', {
                Parent = grouper;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Size = newUDim2(1, 0, 0, 20);
            })
            local text = library:New('TextLabel', {
                Parent = keybindframe;
                BackgroundColor3 = fromrgb(255, 255, 255);
                BackgroundTransparency = 1.000;
                Position = newUDim2(0.0299999993, -1, 0, 10);
                Font = 'Code';
                Text = args.text or args.flag;
                TextColor3 = fromrgb(244, 244, 244);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Left;
            })
            local button = library:New('TextButton', {
                Parent = keybindframe;
                BackgroundColor3 = fromrgb(187, 131, 255);
                BackgroundTransparency = 1.000;
                BorderSizePixel = 0;
                Position = newUDim2(7.09711117e-08, 0, 0, 0);
                Size = newUDim2(0.978837132, 0, 1, 0);
                Font = 'Code';
                ZIndex = library.multiZindex;
                Text = '--';
                TextColor3 = fromrgb(155, 155, 155);
                TextSize = 13.000;
                TextStrokeTransparency = 0.000;
                TextXAlignment = Enum.TextXAlignment.Right;
            })

            function updateValue(val)
                if library.colorpicking or library.dropdowned then return end
                library.flags[args.flag] = val
                button.Text = keyNames[val] or val.Name
                indicatorVal:SetKey(args.text)
                indicatorVal:SetValue(('[%s]'):format(keyNames[val] or val.Name))
            end
            inputService.InputBegan:Connect(function(key)
                local key = key.KeyCode == Enum.KeyCode.Unknown and key.UserInputType or key.KeyCode
                if next then
                    if not table.find(library.blacklisted,key) then
                        next = false
                        indicatorVal:SetKey(args.text)
                        indicatorVal:SetValue(('[%s]'):format(keyNames[key] or key.Name))
                        library.flags[args.flag] = key
                        button.Text = keyNames[key] or key.Name
                        button.TextColor3 = fromrgb(155, 155, 155)
                        
                    end
                end
                if not next and key == library.flags[args.flag] and args.callback then
                    args.callback()
                end
            end)

            button.MouseButton1Click:Connect(function()
                if library.colorpicking or library.dropdowned then return end
                library.flags[args.flag] = Enum.KeyCode.Unknown
                button.Text = '--'
                button.TextColor3 = library.libColor
                next = true
            end)

            library.flags[args.flag] = Enum.KeyCode.Unknown
            library.options[args.flag] = {type = 'keybind',changeState = updateValue,skipflag = args.skipflag,oldargs = args}

            updateValue(args.bind or Enum.KeyCode.Unknown)
        end
        return group, groupbox
    end

    function tab:ShowTab()
        for i,v in next, library.tabs do
            v.Visible = v == newTab
        end
        for i,v in next, library.toInvis do
            v.Visible = false
        end
        for i,v in next, library.tabbuttons do
            local state = v == newButton
            if state then
                v.element.Visible = true
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.000})
                v.text.TextColor3 = fromrgb(244, 244, 244)
            else
                library:Tween(v.element, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1.000})
                v.text.TextColor3 = fromrgb(144, 144, 144)
            end
        end
    end

    newButton.MouseButton1Click:Connect(function() tab:ShowTab() end)

    return tab
end

function library:UpdateAccents(x)
    task.spawn(function()
        for i, v in next, menu:GetDescendants() do
            if v.Name == 'element' or v.Name == 'fill' or v.Name == 'accent' or v:IsA('Frame') and v.BackgroundColor3 == library.libColor or v:IsA('TextButton') and v.BackgroundColor3 == library.libColor then
                v.BackgroundColor3 = x
            elseif v:IsA('TextLabel') and v.Name == 'TheOne' and v.TextColor3 == library.libColor then
                v.TextColor3 = x
            end
        end
        for i, v in next, indicators:GetDescendants() do
            if v.Name == 'element' then
                v.BackgroundColor3 = x
            end
        end
        library.libColor = x
    end)
end

function library:createConfig()
    local name = library.flags['config_name']
    if table.find(library.options['selected_config'].values, name) then return library:Notify('[seere] the config \''..name..'.cfg\' already exists.', 5, c3new(1,0,0)) end
    if name == '' then return library:Notify('[seere] you should probably name the config first.', 5, c3new(1,1,0)) end
    library:Notify('[seere] building config.', 5, c3new(1,1,0))
    local jig = {}
    for i,v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == 'Color3' then
            jig[i] = {v.R,v.G,v.B}
        elseif typeof(v) == 'EnumItem' then
            jig[i] = {string.split(tostring(v),'.')[2],string.split(tostring(v),'.')[3]}
        elseif typeof(v) == 'table' and typeof(v[1]) == 'Color3' then
            jig[i] = {{v[1].R,v[1].G,v[1].B}, v[2]}
        else
            jig[i] = v
        end
    end
    writefile('seere/'..library.gamename..'/configs/'..name..'.cfg',http:JSONEncode(jig))
    library:Notify('[seere] succesfully created config \''..name..'.cfg\'', 5, c3new(0,1,0))
    library:refreshConfigs()
end

function library:saveConfig()
    local name = library.flags['selected_config']
    local jig = {}
    for i,v in next, library.flags do
        if library.options[i].skipflag then continue end
        if typeof(v) == 'Color3' then
            jig[i] = {v.R,v.G,v.B}
        elseif typeof(v) == 'EnumItem' then
            jig[i] = {string.split(tostring(v),'.')[2],string.split(tostring(v),'.')[3]}
        elseif typeof(v) == 'table' and typeof(v[1]) == 'Color3' then
            jig[i] = {{v[1].R,v[1].G,v[1].B}, v[2]}
        else
            jig[i] = v
        end
    end
    writefile('seere/'..library.gamename..'/configs/'..name..'.cfg',http:JSONEncode(jig))
    library:Notify('[seere] succesfully updated config \''..name..'.cfg\'', 5, c3new(0,1,0))
    library:refreshConfigs()
end

function library:loadConfig()
    local name = library.flags['selected_config']
    if not isfile('seere/'..library.gamename..'/configs/'..name..'.cfg') then
        return library:Notify('[seere] config file not found.', 5, c3new(1,0,0))
    end
    local config = http:JSONDecode(readfile('seere/'..library.gamename..'/configs/'..name..'.cfg'))
    for i,v in next, library.options do
        spawn(function()
            local s, e = pcall(function()
                if config[i] then
                    if v.type == 'colorpicker' then
                        v.changeState({c3new(config[i][1][1],config[i][1][2],config[i][1][3]), config[i][2]})
                    elseif v.type == 'keybind' then
                        v.changeState(Enum[config[i][1]][config[i][2]])
                    elseif v.type == 'toggle' and v.risky then
                        return library:Notify(('[seere] ignored a toggle, due to it being disabled in \'%s.cfg\' (%s)'):format(name, v.oldargs.text), 5, c3new(1,0,0))
                    else
                        if config[i] ~= library.flags[i] then
                            v.changeState(config[i])
                        end
                    end
                else
                    if v.type == 'toggle' then
                        v.changeState(false)
                    elseif v.type == 'slider' then
                        v.changeState(v.args.value or 0)
                    elseif v.type == 'textbox' or v.type == 'list' or v.type == 'cfg' then
                        v.changeState(v.args.value or v.args.text or '')
                    elseif v.type == 'colorpicker' then
                        v.changeState({v.args.color or c3new(1,1,1), v.args.trans or 0})
                    elseif v.type == 'list' then
                        v.changeState('')
                    elseif v.type == 'keybind' then
                        v.changeState(v.args.key or Enum.KeyCode.Unknown)
                    end
                end
            end)
        end)
    end
    library:Notify('[seere] succesfully loaded config \''..name..'.cfg\'', 5, c3new(0,1,0))
end

function library:refreshConfigs()
    local tbl = {}
    for i,v in next, listfiles('seere/'..library.gamename..'/configs') do
        table.insert(tbl,v:split('\\')[2]:split('.')[1])
    end
    library.options['selected_config'].refresh(tbl)
end

function library:deleteConfig()
    if isfile('seere/'..library.gamename..'/configs/'..library.flags['selected_config']..'.cfg') then
        delfile('seere/'..library.gamename..'/configs/'..library.flags['selected_config']..'.cfg')
        library:refreshConfigs()
    end
end

function library:refreshLuas()
	local tbl = {}
	for i,v in next, listfiles(('seere/%s/luas'):format(library.gamename)) do
		table.insert(tbl, v:split('\\')[2]:split('.')[1])
	end
	library.options['selected lua'].refresh(tbl)
end
---
function library:CreateSettingsTab()
    local settingsTab = library:AddTab('Settings');

    local configSection = settingsTab:AddSection('Create Configs', 1);
    local configSection2 = settingsTab:AddSection('Config Settings', 1);
    local ui = settingsTab:AddSection('UI Settings', 2);
    local server = settingsTab:AddSection('Servers', 3);
    local other = settingsTab:AddSection('Other', 3);

    configSection:AddText({text = 'Name',flag = 'config_name'})
    configSection:AddButton({text = 'Create',callback = library.createConfig})

    configSection2:AddListBox({text = 'Configs',flag = 'selected_config',skipflag = true,values = {}})
    configSection2:AddButton({text = 'Load',confirm = true, callback = library.loadConfig})
    configSection2:AddButton({text = 'Update',confirm = true, callback = library.saveConfig})
    configSection2:AddButton({text = 'Delete',confirm = true, callback = library.deleteConfig})
    configSection2:AddButton({text = 'Refresh', callback = library.refreshConfigs})
    library:refreshConfigs()

    ui:AddToggle({text = 'Show Game Name', flag = 'show gamename', state = true})
    ui:AddText({text = 'Menu Title',flag = 'cheat_name'})
    ui:AddText({text = 'Domain',flag = 'cheat_domain'})
    ui:AddList({
        text = 'Title Alignment';
        flag = 'cheat title alignment';
        multiselect = false;
        values = { 'Left'; 'Right'; 'Center' };
        selected = 'Center';
        callback = function(v)
            menu.bg.pre.TextXAlignment = Enum.TextXAlignment[v]
        end
    })
    ui:AddColor({text = 'Domain Accent',flag = 'domain_color',color = fromrgb(240, 142, 213)})
    ui:AddColor({text = 'Menu Accent',flag = 'menu_accent',color = fromrgb(240, 142, 214),ontop = true,callback = function(x)
        library:UpdateAccents(x)
    end})

    library:refreshConfigs()
    server:AddButton({text = 'Rejoin Server', confirm = true, callback = function()
        tpService:TeleportToPlaceInstance(game.PlaceId, game.JobId);
    end})
    server:AddButton({text = 'Server Hop', confirm = true, callback = function()
        if library.flags['max players'] <= library.flags['min players'] then return library:Notify('[seere] the # max players can not be lower than nor equal to the # minimum players.', 5, c3new(1,0,0)) end
        local serverlist, teleported = http:JSONDecode(game:HttpGet(('https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100'):format(game.PlaceId))), false
        library:Notify('[seere] searching for an available server.', 5, c3new(1,1,0))
        for _, placeid in pairs(serverlist.data) do
            if placeid.playing ~= nil then
                --library:Notify(('[seere] checking id \'%s-XXXX-XXXX-XXXX-XXXXXXXXXXXX\'.'):format(string.sub(placeid.id, 0, 8)), 5, c3new(1,1,0))
                if placeid.playing ~= placeid.maxPlayers and placeid.playing >= library.flags['min players'] and placeid.playing <= library.flags['max players'] and placeid.ping <= library.flags['max ping']  and game.JobId ~= placeid.id then
                    library:Notify(('[seere] teleporting to \'%s-XXXX-XXXX-XXXX-XXXXXXXXXXXX\'.'):format(string.sub(placeid.id, 0, 8)), 5, c3new(0,1,0))
                    tpService:TeleportToPlaceInstance(game.PlaceId, placeid.id)
                    teleported = true
                    break
                end
            end
            wait(0.0144)
        end
        if not teleported then
            library:Notify('[seere] no server available with the given settings.', 5, c3new(1,0,0))
        end
    end})
    server:AddSeparator({text = 'Serer Hop Settings'})
    server:AddSlider({text = 'Minimum Players', flag = 'min players', min = 1, max = players.MaxPlayers - 1, suffix = '', increment = 1, value = players.MaxPlayers - 2, skipflag = true})
    server:AddSlider({text = 'Max Players', flag = 'max players', min = 1, max = players.MaxPlayers - 1, suffix = '', increment = 1, value = players.MaxPlayers - 1, skipflag = true})
    server:AddSlider({text = 'Max Avg. Latency', flag = 'max ping', min = 20, max = 300, suffix = 'ms', increment = 1, value = 144, skipflag = true})

    --other:AddToggle({text = 'Show Keybinds', flag = 'keybinds', callback = function(v) keybindIndicator:SetEnabled(v) end})
    other:AddButton({text = 'Copy Game Invite', callback = function()
        setclipboard('Roblox.GameLauncher.joinGameInstance('..game.PlaceId..',"'..game.JobId..'")')
    end})

    return settingsTab;
end
---
local mouse = localPlayer:GetMouse()
library:Connection(runService.RenderStepped, function()
    -- notifications
	local count = #eventLogs
	local removedFirst = false
	for i = 1, count do
		local curTick = tick()
		local eventLog = eventLogs[i]
		if eventLog then
			if curTick - eventLog.startTick > eventLog.lifeTime then
				task.spawn(eventLog.Destroy, eventLog)
				table.remove(eventLogs, i)
			elseif count > 99 and not removedFirst then
				removedFirst = true
				local first = table.remove(eventLogs, 1)
				task.spawn(first.Destroy, first)
			else
				local previousEventLog = eventLogs[i - 1]
				local basePosition
				if previousEventLog then
					basePosition = Vector2.new(screenSize.X / 2, previousEventLog.mainText.Position.y + previousEventLog.mainText.TextBounds.y + 1)
				else
					basePosition = Vector2.new(screenSize.X / 2, screenSize.Y * 0.7)
				end
				eventLog.shadowText.Position = (basePosition + Vector2.new(1, 1))
				eventLog.mainText.Position = basePosition
				eventLog.shadowText.Transparency = i
				eventLog.mainText.Transparency = i
				runService.RenderStepped:Wait()
			end
		end
	end
    -- cursor
    cursor.Position = newVector2(mouse.X-16,mouse.Y+18)
    -- menu name
    if library.flags['cheat_name'] then
        if library.flags['cheat_name'] == '' then library.flags['cheat_name'] = 'Seere' end
        if library.flags['cheat_domain'] == '' then library.flags['cheat_domain'] = '.vip' end
        menu.bg.pre.Text = ('%s<font color=\'rgb(%s,%s,%s)\'>%s</font>%s'):format(library.flags['cheat_name'], round(library.flags['domain_color'][1].R * 255 ),  round(library.flags['domain_color'][1].G * 255), round(library.flags['domain_color'][1].B * 255), library.flags['cheat_domain'], (library.flags['show gamename'] and (' - %s'):format(library.gamename) or ''))
    end
end)
return library,menu,tabholder,tabviewer
