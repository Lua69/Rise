-- bam boom wow bing bong https://www.roblox.com/library/1496745047/AutoScale-Lite

--AutoScaleLibrary V4.0
local AutoScaleLibrary = {}
-- local ChangeHistoryService = game:GetService("ChangeHistoryService") -- plugins only use this so the the stuff they changed dont go back to the orginal state
-- AutoScaleLibrary.__index = AutoScaleLibrary

--Functions
local function PropertyExists(obj, prop)
	return ({pcall(function()if(typeof(obj[prop])=="Instance")then error()end end)})[1]
end

-- function AutoScaleLibrary.CustomPrint(msg, gui)
-- 	game:GetService("ContentProvider"):Preload("rbxassetid://2790389767")
-- 	local newgui = gui:Clone()
-- 	newgui.Parent = game:GetService("CoreGui")

-- 	newgui:WaitForChild("BG"):WaitForChild("Msg").Text = msg
-- 	newgui.BG:TweenPosition(UDim2.new(0.104, 0,0.938, 0), "Out", "Quint", .1)
-- 	wait(1)
-- 	newgui.BG:TweenPosition(UDim2.new(0.104, 0,1.2, 0), "Out", "Quint", .2)
-- end

--Text
function AutoScaleLibrary.ScaleText(v)
	if PropertyExists(v, "TextScaled") and not v:FindFirstChildWhichIsA("UITextSizeConstraint") then
		if v.TextScaled == false then
			local tconstraint = Instance.new("UITextSizeConstraint")
			tconstraint.MaxTextSize = v.TextSize
			tconstraint.Parent = v
			v.TextScaled = true
		elseif v.TextScaled == true then
			local textconstraint = Instance.new("UITextSizeConstraint")
			textconstraint.MaxTextSize = v.TextBounds.Y
			textconstraint.Parent = v				
		end
		-- AutoScaleLibrary.CustomPrint("AutoScaled Text", script.Parent:WaitForChild("CustomPrint"))
	end
end

--Position
function AutoScaleLibrary.SetPos(v, params)
	--SCALE
	if params == "Scale" then
		if v:isA("GuiBase2d") and v.Parent and PropertyExists(v, "Position") then
			if PropertyExists(v.Parent, "AbsoluteSize") then
				local ScaleXPos = v.Position.X.Offset/v.Parent.AbsoluteSize.X + v.Position.X.Scale
				local ScaleYPos = v.Position.Y.Offset/v.Parent.AbsoluteSize.Y  + v.Position.Y.Scale
				v.Position = UDim2.new(ScaleXPos, 0, ScaleYPos, 0)
			end
		end

		-- AutoScaleLibrary.CustomPrint("Converted to Scale Pos", script.Parent:WaitForChild("CustomPrint"))
		-- ChangeHistoryService:SetWaypoint("Converted UI element to Scale Position")
		--OFFSET	
	elseif params == "Offset" then
		if v:isA("GuiBase2d") and v.Parent and PropertyExists(v, "Position") then
			if  PropertyExists(v.Parent, "AbsoluteSize") then
				local OffsetXPos = v.Position.X.Scale*v.Parent.AbsoluteSize.X + v.Position.X.Offset
				local OffsetYPos = v.Position.Y.Scale*v.Parent.AbsoluteSize.Y + v.Position.Y.Offset
				v.Position = UDim2.new(0, OffsetXPos, 0, OffsetYPos)
			end	
		end

		-- AutoScaleLibrary.CustomPrint("Converted to Offset Pos", script.Parent:WaitForChild("CustomPrint"))
		-- ChangeHistoryService:SetWaypoint("Converted UI element to Offset Position")	
	end
end

--Size
function AutoScaleLibrary.SetSize(v, params)
	--SCALE
	if params == "Scale" then
		if v:isA("GuiBase2d") and PropertyExists(v, "Size") and not v.Parent:IsA("ScrollingFrame") then
			local Viewport_Size

			if PropertyExists(v.Parent, "AbsoluteSize") then
				Viewport_Size = v.Parent.AbsoluteSize
			elseif v:FindFirstAncestorWhichIsA("GuiObject") and PropertyExists(v:FindFirstAncestorWhichIsA("GuiObject"), "AbsoluteSize") then
				Viewport_Size = v:FindFirstAncestorWhichIsA("GuiObject").AbsoluteSize
			else
				Viewport_Size = workspace.CurrentCamera.ViewportSize
			end

			local LB_Size = v.AbsoluteSize
			v.Size = UDim2.new(LB_Size.X/Viewport_Size.X,0,LB_Size.Y/Viewport_Size.Y, 0)
		end

		-- AutoScaleLibrary.CustomPrint("Converted to Scale Size", script.Parent:WaitForChild("CustomPrint"))
		-- ChangeHistoryService:SetWaypoint("Converted UI element to Scale Size")
		--OFFSET
	elseif params == "Offset" then	
		if v:isA("GuiBase2d") and PropertyExists(v, "Size")then
			local LB_Size = v.AbsoluteSize
			v.Size = UDim2.new(0, LB_Size.X, 0, LB_Size.Y)
		end

		-- AutoScaleLibrary.CustomPrint("Converted to Offset Size", script.Parent:WaitForChild("CustomPrint"))
		-- ChangeHistoryService:SetWaypoint("Converted UI element to Offset Size")
	end
end

--Add Constraint
function AutoScaleLibrary.AddConstraint(v)
	if v:isA("GuiBase2d") then
		local x = v.AbsoluteSize.X
		local y = v.AbsoluteSize.y
		local ratio = x/y

		if v:FindFirstChildWhichIsA("UIAspectRatioConstraint") then
			v:FindFirstChildWhichIsA("UIAspectRatioConstraint").AspectRatio = ratio
			-- AutoScaleLibrary.CustomPrint("Edited UIAspectRatio constraint", script.Parent:WaitForChild("CustomPrint"))	
		else
			local constraint = Instance.new("UIAspectRatioConstraint")
			constraint.Parent = v
			constraint.AspectRatio = ratio
			-- AutoScaleLibrary.CustomPrint("Added UIAspectRatio constraint", script.Parent:WaitForChild("CustomPrint"))	
		end
	end
	-- ChangeHistoryService:SetWaypoint("Added Constraints to UI elements")
end

return AutoScaleLibrary