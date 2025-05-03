local Universal = {}

local EasingLibrary = wax.shared.EasingLibrary

Universal.FOV = {
    Enabled = false,

    DefaultFOV = shared.Camera.FieldOfView,
    ModedFOV = shared.Camera.FieldOfView,

    Start = function(Enabled: boolean)
        local self = Universal.FOV
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Camera, "FieldOfView", self.ModedFOV, "FOV")

            shared.Connect:GiveSignal("FOV", shared.Camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
                if not EasingLibrary.RunningTween.FOV then
                    shared.Camera.FieldOfView = self.ModedFOV
                end
            end))
        else
            shared.Connect:DisconnectSignal("FOV")
            EasingLibrary:Ease(shared.Camera, "FieldOfView", self.DefaultFOV, "FOV")
        end
    end,

    SetFOV = function(FOV: number)
        local self = Universal.FOV
        self.ModedFOV = FOV

        if self.Enabled then
            EasingLibrary:Ease(shared.Camera, "FieldOfView", FOV, "FOV")
        end
    end
}

Universal.MaxZoom = {
    Enabled = false,

    DefaultZoom = shared.Speaker.CameraMaxZoomDistance,
    ModedZoom = shared.Speaker.CameraMaxZoomDistance,

    Start = function(Enabled: boolean)
        local self = Universal.MaxZoom
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", self.ModedZoom, "MaxZoom")

            shared.Connect:GiveSignal("MaxZoom", shared.Speaker:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(function()
                if not EasingLibrary.RunningTween.MaxZoom then
                    shared.Speaker.CameraMaxZoomDistance = self.ModedZoom
                end
            end))
        else
            shared.Connect:DisconnectSignal("MaxZoom")
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", self.DefaultZoom, "MaxZoom")
        end
    end,

    SetZoom = function(Zoom: number)
        local self = Universal.MaxZoom
        self.ModedZoom = Zoom

        if self.Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMaxZoomDistance", Zoom, "MaxZoom")
        end
    end
}

Universal.MinZoom = {
    Enabled = false,

    DefaultZoom = shared.Speaker.CameraMinZoomDistance,
    ModedZoom = shared.Speaker.CameraMinZoomDistance,

    Start = function(Enabled: boolean)
        local self = Universal.MinZoom
        self.Enabled = Enabled

        if Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", self.ModedZoom, "MinZoom")

            shared.Connect:GiveSignal("MinZoom", shared.Speaker:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(function()
                if not EasingLibrary.RunningTween.MinZoom then
                    shared.Speaker.CameraMinZoomDistance = self.ModedZoom
                end
            end))
        else
            shared.Connect:DisconnectSignal("MinZoom")
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", self.DefaultZoom, "MinZoom")
        end
    end,

    SetZoom = function(Zoom: number)
        local self = Universal.MinZoom
        self.ModedZoom = Zoom

        if self.Enabled then
            EasingLibrary:Ease(shared.Speaker, "CameraMinZoomDistance", Zoom, "MinZoom")
        end
    end
}

return Universal
