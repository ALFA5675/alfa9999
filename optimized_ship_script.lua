-- سكربت السفينة بعد التعديل لمنع التعليق - إصدار تارنو
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local selectedPlayerName = nil
local isRunning = false

-- Dropdown لاختيار اللاعب
AddDropdown(Main, {
    Name = "اختار اللاعب",
    Options = (function()
        local names = {}
        for _, player in pairs(Players:GetPlayers()) do
            table.insert(names, player.Name)
        end
        return names
    end)(),
    Callback = function(selected)
        selectedPlayerName = selected
    end
})

-- زر لتشغيل وإيقاف السحب
AddToggle(Main, {
    Name = "تشغيل / إيقاف السفينة",
    Default = false,
    Callback = function(state)
        isRunning = state
    end
})

-- الوظيفة الأساسية - محدثة لتعمل فقط أثناء التفعيل
task.spawn(function()
    local Attachment1
    local Folder, Part

    while true do
        if isRunning and selectedPlayerName then
            local player = Players:FindFirstChild(selectedPlayerName)
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if not Attachment1 then
                    Folder = Instance.new("Folder", Workspace)
                    Part = Instance.new("Part", Folder)
                    Attachment1 = Instance.new("Attachment", Part)
                    Part.Anchored = true
                    Part.CanCollide = false
                    Part.Transparency = 1
                end

                local root = player.Character.HumanoidRootPart
                Attachment1.WorldCFrame = root.CFrame
            end
        end
        task.wait(0.1)
    end
end)

-- إعداد السيموليشن بدون ضغط زائد
task.spawn(function()
    while true do
        if isRunning then
            settings().Physics.AllowSleep = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer then
                    pcall(function()
                        player.MaximumSimulationRadius = 0
                        sethiddenproperty(player, "SimulationRadius", 0)
                    end)
                end
            end
            Players.LocalPlayer.MaximumSimulationRadius = math.huge
            setsimulationradius(math.huge)
        end
        task.wait(0.3)
    end
end)
