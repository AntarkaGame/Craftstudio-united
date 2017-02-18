function Behavior:Awake()
    self.Asset = "Bruitages/ConduitVentilation"
    self.Cam = CS.FindGameObject("Camera")
    -- Sound3D:New( asset, object, max, min, speed, loop, listener, static )
    self.Son = United.Sound3D:New( self.Asset, self.gameObject, 50, 2, 0.3, true, self.Cam , true )
    print(self.Son)
end

function Behavior:Update()
    self.Son:Check()
end
