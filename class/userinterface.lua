-- > On vérifie que la metatable United est existante 
if United ~= nil then 

-- > UserInterface Class
United["UserInterface"] = {}
United["UserInterface"].Core = function() 

    if United.SceneConstructor ~= nil then 
    
        local HUD = United["UserInterface"]
        
        -- > MetaMethode
        HUD.__index     = HUD 
        HUD.__call      = function(mt) 
            mt:Update() 
        end
        HUD.__tostring  = function(mt) 
            return mt.name 
        end
        
        ------------------------------------------------------------------------------------------------------------------
                            -- [ BASIC USER INTERFACE FUNCTION ] -- 
        ------------------------------------------------------------------------------------------------------------------                   
    
        -- [ NEW UI ] --
        function HUD:New(env,autocreate,indexSwitch,callback)
            callback = callback or Nil
            local mt = setmetatable( { 
                env = env,
                camera = nil,
                name = env.gameObject.Name , 
                position = 10000 , 
                ray = nil ,
                web = false,
                --State = true, ? Trouver une solution pour bloquer d'éventuel comeAction.
                ObjectList = {},
                AnimationList = {},
                StrideList = {},
                ActiveStride = nil,
                ActiveContainer = nil,
                Screen = { Size = { x = 0 , y = 0 } , Center = { x = 0 , y = 0 } , PTU = nil , SSS = nil },
                OutMemory = {}
            } ,  self ) 
            if autocreate then 
                mt:Create(callback) 
            else 
                callback()
            end
            if indexSwitch ~= nil then
                mt:Switch( indexSwitch )
            else
                local name = SceneConstructor.Storage["container"][1]:GetName()
                local newname = string.sub( name , 11 ) 
                mt:Switch( newname )
            end
            return mt
        end
        
        -- [ CREATE THE CAMERA ] --
        function HUD:Create(callback)
            do
                local V3 = Vector3
                local Craft = CS
                self.env.gameObject.transform:SetPosition( V3:New( 0 , 0 , self.position ) ) 
                do
                    local camera = Craft.CreateGameObject( self.name.."_HUD" , self.env.gameObject ) 
                    camera:CreateComponent( "Camera" ):SetProjectionMode( Camera.ProjectionMode.Orthographic ) 
                    camera.transform:SetLocalPosition( V3:New( 0 , 0 , 50 ) ) 
                    self.camera = camera.camera
                end
                
                if not SceneConstructor.Generate then 
                    SceneConstructor:Scanroom()
                end
                
                -- > On applique une nouvelle position a tout les containers.
                do local R = SceneConstructor:Get("container") 
                    if R ~= false then
                        for i=1, #R do  
                            local PosZ = R[i].transform:GetLocalPosition().z
                            R[i].transform:SetLocalPosition( V3:New( 200 , 0 , PosZ ) ) 
                            R[i]:CreateScriptedBehavior( Craft.FindAsset( "United/Librairie/Core/Container" , "Script" ) , nil ) 
                        end
                    end
                end
            end
            
            United.Index = self.env.gameObject
            
            -- > Après création.on supprime les variables non utile.
            self.position = nil 
            self.env = nil
            
            -- > On apelle la function ScreenSize
            self:ScreenSize()
            
            -- > On execute l'éventuel callback.
            callback() 
        end
        
        -- [ UPDATE HUD META ] -- 
        function HUD:Update()
            local Craft = CS
            do local MousePos = Craft.Input.GetMousePosition()
                self.ray = self.camera:CreateRay( MousePos ) 
            end
            
            if Craft.Input.WasButtonJustReleased("ECHAP") then 
                Craft.FindGameObject("Container_"..self.ActiveContainer):GetComponent("ScriptedBehavior"):Escape()
            end
            
            -- > On vérifie si le joueur redimensionne la fenêtre 
            if self.Screen.Size.x ~= Craft.Screen.GetSize().x or self.Screen.Size.y ~= Craft.Screen.GetSize().y then 
                self:ScreenSize() 
            end
        end
        
        ------------------------------------------------------------------------------------------------------------------
                            -- [ STYLE USER INTERFACE FUNCTION ] -- 
        ------------------------------------------------------------------------------------------------------------------ 
        
        -- [ Get Translation like Small side size, Pixel To Unit and update The OrthoScale to HD release ] --
        function HUD:GetTranslation()
            local SGX,SGY
            do local Craft = CS
                SGY,SGX = Craft.Screen.GetSize().y,Craft.Screen.GetSize().x
            end
            local cam = self.camera
            if not self.web then 
                cam:SetOrthographicScale( SGY / 16 ) 
            end
            if SGX > SGY then 
                self.Screen.SSS = SGY
            else
                self.Screen.SSS = SGX
            end
            self.Screen.PTU = cam:GetOrthographicScale() / self.Screen.SSS 
        end
        
        -- [ This function is called when the screen is resized ] -- 
        function HUD:ScreenSize()
            self:GetTranslation() 
            self.Screen.Size.x,   self.Screen.Size.y   = CS.Screen.GetSize().x, CS.Screen.GetSize().y
            self.Screen.Center.x, self.Screen.Center.y = (self.Screen.Size.x * self.Screen.PTU) / 2 , (self.Screen.Size.y * self.Screen.PTU) / 2
            
            local T = self.ObjectList
            local search = pairs
            
            -- > On parcours notre tableau d'objet actif dans L'UI
            for k,v in search(T) do
                local Animation = self.AnimationList[k]
                
                if Animation ~= nil then 
                    if Animation.state then 
                        self:Pos(unpack(v))
                        local Craft = CS
                        local gameObject = Craft.FindGameObject(k)
                        local pos = gameObject.transform:GetLocalPosition()
                        do
                            Animation.pos = pos
                            local V3 = Vector3
                            Animation.lerp = V3:New( pos.x + Animation.defaut[1] , pos.y + Animation.defaut[2] , pos.z ) 
                            gameObject.transform:SetLocalPosition( V3:New( pos.x + Animation.defaut[1] , pos.y + Animation.defaut[2] , pos.z ) ) 
                        end
                        return
                    end
                end
                
                -- > Si le module doit être resize 
                if v[4] then
                    self:Pos(unpack(v))
                end
            end
        end
        
        ------------------------------------------------------------------------------------------------------------------
                            -- [ UI CORE FUNCTION ] -- 
        ------------------------------------------------------------------------------------------------------------------ 
        
        -- > Créer un container
        function HUD:NewContainer(name,goActive)
            goActive = goActive or false
            local NewContainer
            do local Craft = CS
                NewContainer = Craft.CreateGameObject("Container_"..name,United.Index) 
            end
            if goActive then 
                self:Switch(name) 
            else
                local V3 = Vector3
                local PosZ = NewContainer.transform:GetLocalPosition().z 
                NewContainer.transform:SetLocalPosition( V3:New( 200 , 0 , PosZ ) ) 
            end
        end
        
        -- > Detruire un container
        function HUD:DeleteContainer(name)
            if name ~= self.ActiveContainer then
                local Craft = CS
                local gameObject = Craft.FindGameObject("Container_"..name)
                Craft.Destroy( gameObject )
                SceneConstructor:ObjectDestroy( gameObject )
            else
                United.Err("Vous ne pouvez pas supprimer un container actif")
            end
        end
        
        -- > Switch container or exit the game
        function HUD:Switch(moduleName) 
            local Craft = CS
            if moduleName == nil then
                -- Do nothing
            else
                if string.lower(moduleName) == "exit" then
                    Craft.Exit()
                else
                    local V3 = Vector3
                    if self.ActiveContainer ~= nil then
                        local OLDgameObject = Craft.FindGameObject("Container_"..self.ActiveContainer)
                        local PosZ = OLDgameObject.transform:GetLocalPosition().z
                        OLDgameObject.transform:SetLocalPosition( V3:New( 200 , 0 , PosZ ) ) 
                        OLDgameObject:GetComponent("ScriptedBehavior"):Switch_Out()
                    end
                    do 
                        local gameObject = Craft.FindGameObject("Container_"..moduleName)
                        local PosZ = gameObject.transform:GetLocalPosition().z
                        gameObject.transform:SetLocalPosition( V3:New( 0 , 0 , PosZ ) ) 
                        gameObject:GetComponent("ScriptedBehavior"):Switch_In()
                    end
                    self.ActiveContainer = moduleName
                    self:StrideMove()
                end
            end
        end
        
        -- > Function stride
        function HUD:NewStride(container,defaut,T)
            local Stride = self.StrideList[container]
            T = T or {}
            defaut = defaut or 1
            if Stride == nil then
                self.StrideList[container] = { 
                    defaut = T[defaut],
                    Objects = T 
                }
                local Craft = CS
                local V3 = Vector3
                local search = pairs
                for k,v in search(T) do
                    local gameObject = Craft.FindGameObject(v).transform
                    local PosZ = gameObject:GetLocalPosition().z
                    if k == defaut then 
                        gameObject:SetLocalPosition( V3:New( 0 , 0 , PosZ ) )
                    else
                        gameObject:SetLocalPosition( V3:New( 500 , 0 , PosZ ) )
                    end
                end
                self:StrideMove()
            end
        end
        
        -- > Ajouter une stride a un contenue.
        function HUD:AddStride(container,gameObjects)
            local Stride = self.StrideList[container]
            if Stride ~= nil then
                TgameObject = type(gameObjects)
                if TgameObject == "string" then
                    Stride.Objects[#Stride.Objects + 1] = gameObjects
                elseif TgameObject == "table" then
                    local search = pairs
                    for _,v in search(gameObjects) do
                        local numb = #Stride.Objects + 1
                        Stride.Objects[numb] = v
                    end
                end
            end
        end
        
        -- > Move Stride.
        function HUD:StrideMove(name)
            local Stride = self.StrideList[self.ActiveContainer]
            local V3 = Vector3 
            local Craft = CS
            if name == nil then
                if Stride ~= nil then
                    if self.ActiveStride ~= nil then
                        local gameObject = Craft.FindGameObject(self.ActiveStride).transform
                        local PosZ = gameObject:GetLocalPosition().z
                        gameObject:SetLocalPosition( V3:New( 500 , 0 , PosZ ) )
                    end
                    local Default = Craft.FindGameObject(Stride.defaut)
                    local PosZ = Default.transform:GetLocalPosition().z
                    Default.transform:SetLocalPosition( V3:New( 0 , 0 , PosZ ) )
                    self.ActiveStride = Default:GetName()
                end
                return
            else
                local search = pairs
                local find = false
                for _,v in search(Stride.Objects) do
                    if v == name and name ~= self.ActiveStride then
                        if self.ActiveStride ~= nil then
                            local gameObject = Craft.FindGameObject(self.ActiveStride).transform
                            local PosZ = gameObject:GetLocalPosition().z
                            gameObject:SetLocalPosition( V3:New( 500 , 0 , PosZ ) )
                        end
                        local Default = Craft.FindGameObject(name)
                        local PosZ = Default.transform:GetLocalPosition().z
                        Default.transform:SetLocalPosition( V3:New( 0 , 0 , PosZ ) )
                        self.ActiveStride = Default:GetName()
                        find = true
                        break
                    end
                end
                
                if find then
                    return true
                end
                return false
            end
        end
        
        -- > Function pour changer la profondeur d'un objet.
        function HUD:Zindex(Object,z)
            local gameObject
            do local Craft = CS
                gameObject = Craft.FindGameObject(Object).transform
            end
            local Pos = gameObject:GetLocalPosition()
            local V3 = Vector3
            gameObject:SetLocalPosition( V3:New( Pos.x , Pos.y , Pos.z + z ) )
        end
        
        -- > Function de positionnement.
        function HUD:Pos(Object,x,y,resize)
            resize = resize or true
            
            -- > On vérifie que les valeurs soit correcte.
            x = x       or { }
            x[1] = x[1] or "center"
            x[2] = x[2] or 0
            
            y = y       or { }
            y[1] = y[1] or "center"
            y[2] = y[2] or 0
            
            -- > Si l'object est inexistant dans la table alors on l'ajoute
            if self.ObjectList[Object] == nil then
                self.ObjectList[Object] = { Object,x,y,resize }
            end
            
            -- > On calcule la position.
            do local SCX,SCY = self.Screen.Center.x, self.Screen.Center.y
                x  = (x[1] == "left") and -1* SCX + x[2]        or ( (x[1] == "right")  and 1 * SCX + -x[2]         or ( (x[1] == "center") and x[2] or 0 ) ) 
                y  = (y[1] == "top")  and 1 * SCY + -y[2]       or ( (y[1] == "bottom") and -1 * SCY + y[2]         or ( (y[1] == "center") and y[2] or 0 ) ) 
            end
    
            -- > Apply Position
            local gameObject
            do local Craft = CS
                gameObject = Craft.FindGameObject(Object)
            end
            if gameObject ~= nil then
                local z = gameObject.transform:GetLocalPosition().z
                local V3 = Vector3
                gameObject.transform:SetLocalPosition( V3:New( x , y , z ) ) 
            else
                return false
            end
        end 
        
        -- > Function pour téléporter un point A à B.
        function HUD:AtoB(a,b,chunck)
            chunck = chunck or false
            local Craft = CS
            local gameObjectA = Craft.FindGameObject(a).transform
            local gameObjectB = Craft.FindGameObject(b).transform
            local V3 = Vector3
            if chunck then 
                gameObjectA:SetPosition( V3:New( gameObjectB:GetPosition() ) )
            else    
                gameObjectA:SetLocalPosition( V3:New( gameObjectB:GetLocalPosition() ) )
            end
        end
        
        ------------------------------------------------------------------------------------------------------------------
                            -- [ UI ANIMATION FUNCTION ] -- 
        ------------------------------------------------------------------------------------------------------------------ 
        
        -- > On vérifie que la class TaskCron soit bien présente car les functions ci-dessous fonctionne grâce à cet class.
        if United.TaskCron ~= nil then 
        
            function HUD:NewAnimation(AnimationName,gameObject,speed,pos,scale,easing)
                local T = self.AnimationList[AnimationName]
                if T == nil then
                    speed = speed or 60
                    
                    -- > Pos check 
                    pos = pos or {}
                    pos[1] = pos[1] or 0
                    pos[2] = pos[2] or 0
                    
                    -- > Pos check 
                    scale = scale or {}
                    scale[1] = scale[1] or 0
                    scale[2] = scale[2] or 0
                    
                    local gameObjectPos = gameObject.transform:GetLocalPosition()
                    
                    self.AnimationList[AnimationName] = {
                        gameObject = gameObject,
                        speed = speed,
                        pos = Vector3:New( gameObjectPos.x ,gameObjectPos.y , gameObjectPos.z ),
                        defaut = pos,
                        lerp = Vector3:New( gameObjectPos.x + pos[1] , gameObjectPos.y + pos[2] , gameObjectPos.z ),
                        scale = scale,
                        easing = easing,
                        state = false,
                        play = false
                    }
                end
            end
            
            function HUD:StateAnimation(AnimationName)
                local T = self.AnimationList[AnimationName]
            end
            
            function HUD:PlayAnimation(AnimationName)
                local T = self.AnimationList[AnimationName]
                if T ~= nil then
                
                    -- > Si l'animation joue
                    if T.play then
                        TASK:Reverse(AnimationName)
                        T.state = not T.state
                    else
                    
                        T.play = true
                        T.state = not T.state
                        
                        TASK:New(AnimationName,T.speed,T,
                        function(k)
                            local t = k.innerTable
                            local V3 = Vector3
                            
                            -- > On calcule le facteur et la progression
                            local factor        = k.loop / k.max_loop
                            local progression   = ( 1 - (1 - factor) * (1 - factor) )
                            
                            do 
                                -- > On définie defaut et lerp
                                local POSdefaut = t.state and t.pos  or t.lerp
                                local POSlerp   = t.state and t.lerp or t.pos

                                t.gameObject.transform:SetLocalPosition( V3.Lerp( POSdefaut , POSlerp , progression ) ) 
                            end 
                            
                        end,
                        function(k)
                            local t = k.innerTable
                            t.play = false
                        end)
                        
                    end
                    
                end
            end
            
            function HUD:TriggerAnimation()
            
            end
            
        end
        
    else
    
        United.Err("You need the class SceneConstructor for build UserInterface")
        
    end
    
    -- > Prevent destroy core function.
    United["UserInterface"].Core = nil 
    
end

end