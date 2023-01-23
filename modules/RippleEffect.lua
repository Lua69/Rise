-- vim bim bam bam boom ting https://www.roblox.com/library/6568338048/Ripple-Effect

local TweenService = game:GetService("TweenService")

-- ReplicatedStorage --
function CircleClick(Button, X, Y)
    task.spawn(function()
        Button.ClipsDescendants = true
		local Circle = Instance.new("ImageLabel", Button)
        Circle.BackgroundTransparency = 1
        Circle.ImageTransparency = .1
        Circle.Image = "rbxassetid://266543268"

		local NewX = X - Circle.AbsolutePosition.X
		local NewY = Y - Circle.AbsolutePosition.Y
		Circle.Position = UDim2.new(0, NewX, 0, NewY)
        Circle.AnchorPoint = Vector2.new(.5, .5)
        Circle.Size = UDim2.new()
		
		local Size = 0
			if Button.AbsoluteSize.X > Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.X*1.5
			elseif Button.AbsoluteSize.X < Button.AbsoluteSize.Y then
				 Size = Button.AbsoluteSize.Y*1.5
			elseif Button.AbsoluteSize.X == Button.AbsoluteSize.Y then																																																																														
				Size = Button.AbsoluteSize.X*1.5
			end
		
        local tween = TweenService:Create(Circle, TweenInfo.new(.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, Size, 0, Size), Position = UDim2.new(0.5, -Size/2, 0.5, -Size/2), ImageTransparency = 1})
        tween:Play()
        tween.Completed:Wait()

		Circle:Destroy()
        Button.ClipsDescendants = false
    end)
end

return CircleClick