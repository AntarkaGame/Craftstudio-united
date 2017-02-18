-- > New global variable for mt
TASK = false
SceneConstructor = false 
UI = false 
Core = false
FrameworkLoad = false

-- > Declare United global variable
United = {}
setmetatable(United,United)

United.ActiveModule = {}

-- > United Error core
United.Err = {}

do

    local Err = United.Err
    
    -- > Error metamethode
    Err.__index = Err
    Err.__call = function(mt,error,exit)
        mt:Call(error,(exit or false))
    end
    Err.__tostring = function()
        return "A error is print" 
    end
    
    -- > Environnement Err
    Err.OccuredError = 0
    Err.AssetError = 0
    
    setmetatable(Err,Err)
    
    function Err:Call(error,exit)
        Err.OccuredError = Err.OccuredError + 1 
        do local echo = print
            echo(tostring(error)) 
        end
        if exit then CS.Exit() end
        return false
    end

end

-- > United Constructor 
United.Constructor = {}

do 
    local Constructor = United.Constructor
    
    -- > Constructor metamethode 
    Constructor.__index = Constructor
    Constructor.__call  = function(mt,constructorTable)
        mt:LoadClass(constructorTable)
    end
    
    setmetatable(Constructor,Constructor)
        
    -- > Function LoadClass
    function Constructor:LoadClass(constructorTable)
        local Framework = United 
        for i = 1 ,#constructorTable do
            local mt = Framework[constructorTable[i]]
            if mt ~= nil then
                mt.Core()
                Framework.ActiveModule[ #Framework.ActiveModule + 1 ] = constructorTable[i]
            else
                United.Err("Invalid core name : "..v.." Constructor dont find the core function",true)
            end
        end
        self:BuildClass()
        
        -- > Define new metamethode for United meta.
        United.__call       = function(mt)
            mt.Core()
        end
        United.__index      = United.Core
        United.__newindex   = United.Core
        
        United.Constructor  = nil 
        FrameworkLoad       = true
        collectgarbage("collect")
    end
    
    -- > Function BuildClass
    function Constructor:BuildClass()
    
        local activeClass   = {}
        local search = pairs
    
        for k,_ in search(United) do
            if k ~= "Err" and k ~= "ActiveModule" and k ~= "Constructor" and k ~= "Core" then 
                for _,v in search(United.ActiveModule) do
                    if k == v then 
                        activeClass[#activeClass + 1] = v  
                    end
                end
            end
        end 
            
    
        do 
            local inactiveClass = {}
            
            -- > Detect inactive class
            for k,_ in search(United) do
                if k ~= "Err" and k ~= "ActiveModule" and k ~= "Constructor" and k ~= "Core" then 
                    inactiveClass[k] = false
                    for _,v in search(activeClass) do
                        if k == v then 
                            inactiveClass[k] = true 
                        end
                    end
                end
            end
            
            -- > Destroy inactive class
            for k,v in search(inactiveClass) do
                if not v then 
                    United[k] = nil  
                end
            end
            
        end 
    
    end
    
end

-- > United Core for gameScript
United.Core = {} 

do 

    local Core = United.Core

    -- > Mouse
    Core.Mouse = {} 
    Core.Mouse.ToUnit = {x=0,y=0} 
    Core.Mouse.Focus = {x=0,y=0}
    Core.Mouse.In = true
    Core.Mouse.Move = true
    
    -- > Other
    Core.Index = nil
    
    Core.TempMemory = {}
    
    setmetatable(Core,Core)
    
    -- > Vider la mémoire de variable global pre-instancier + Variable non core.
    function Core:Out_Memory()
        self.TempMemory = {}
        if SceneConstructor ~= nil then
            SceneConstructor:Out_Memory()
        end
    end
    
    function Core:DestroyObject(gameObject)
        local Craft = CS
        Craft.Destroy( gameObject ) 
        if SceneConstructor ~= nil then
            SceneConstructor:ObjectDestroy(gameObject)
        end
    end
    
    function Core:Update()
        
        -- > Update Mouse value
        do 
            local MousePos      = CS.Input.GetMousePosition()
            local MouseDelta    = CS.Input.GetMouseDelta()
            local ScreenSize    = UI.Screen.Size or {CS.Screen.GetSize().x,CS.Screen.GetSize().y}
            
            if MouseDelta.x ~= 0 or MouseDelta.y ~= 0 and self.Mouse.In then
                self.Mouse.Move = true
            else
                self.Mouse.Move = false
            end
            
            if MousePos.x >= 0 and MousePos.x <= ScreenSize.x and MousePos.y >= 0 and MousePos.y <= ScreenSize.y then
                if not self.Mouse.In then
                    self.Mouse.In = true
                end
                
                do
                    local PTU = UI.Screen.PTU or 16
                    local ScreenCenter = UI.Screen.Center or {x=0,y=0}
                    self.Mouse.ToUnit.x = MousePos.x * PTU
                    self.Mouse.ToUnit.y = MousePos.y * PTU
                    self.Mouse.Focus.x  =  self.Mouse.ToUnit.x - ScreenCenter.x
                    self.Mouse.Focus.y  = -self.Mouse.ToUnit.y + ScreenCenter.y
                end
            else
                if self.Mouse.In then 
                    self.Mouse.In = false
                end
            end
        end
        
        local UnitedActiveModule = United.ActiveModule 
        local search = pairs  
        
        -- > While for update active module.
        for _,v in search(UnitedActiveModule) do
            if v == "UserInterface" then
                UI:Update()
            elseif v == "TaskCron" then
                TASK:Update()
            end
        end 
    end
    
    -- > Core metamethode
    Core.__index    = function(mt,k)
        if FrameworkLoad then
            local search = pairs
            for a,b in search(mt.TempMemory) do
                if a == k then
                    return b
                end
            end
        end
        rawget(mt,k)
    end
    Core.__call     = function(mt) 
        mt:Update() 
    end
    Core.__newindex = function(mt,k,v)
        if FrameworkLoad then
            rawset(mt.TempMemory,k,v)
            print("Nouvelle variable hors Mémoire : "..tostring(k).." = "..tostring(v))
        else
            rawset(mt,k,v)
        end
    end 

end

Core = United.Core 
