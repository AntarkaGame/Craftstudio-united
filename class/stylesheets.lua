-- > On vérifie que la metatable United est existante 
if United ~= nil then 

United["Stylesheets"] = {}
United["Stylesheets"].Core = function()

    -- > On vérifie que la class UserInterface existe belle et bien.
    if United.UserInterface ~= nil and United.SceneConstructor ~= nil then 
    
        local Stylesheets = United.Stylesheets
        
        -- > Metamethode
        Stylesheets.__index = Stylesheets
        Stylesheets.__call = function(mt,style)
            mt:Construct(style)
        end
        
        -- > Construct Stylesheets
        function Stylesheets:Construct(style)
            local SC = SceneConstructor
            if SC.Generate then
                local CSS = self[style]
                local search = pairs
                local find = string.find
                local Craft = CS
                for keys,values in search(CSS) do
                
                    local _,_,a,b,c,d,e = find(keys, '([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)[%s]?([%a%d%p]*)')
                    local result = {a,b,c,d,e}
                    
                    for k,v in search(result) do
                        local gameObject = Craft.FindGameObject(v)
                        if gameObject ~= nil then
                            self:ApplyCSS(gameObject,keys,values,tonumber(k))
                        end 
                    end
                    
                end
            else
                United.Err("Vous ne pouvez pas générer une stylesheets sans avoir fait une construction de scène")
            end
        end
        
        -- > ApplyCSS.
        function Stylesheets:ApplyCSS(gameObject,name,t,indexCall)
            local search = pairs
            local find = string.find
            local sub = string.sub
            local Positionnement = {{},{},false}
            local Position_Ok = false
            local Craft = CS
            
            for k,v in search(t) do   
                local K_old = k
                k = string.lower(k)
                
                if find(k,"key",1) == 1 then
                    local index = tonumber(sub(k, 4))
                    if indexCall ~= nil then
                        if indexCall == index then
                            self.Librairie["CSSKeyPattern"](self,gameObject,v,true)
                        end
                    end
                elseif find(k,"_",1) == 1 then 
                    local gameObjectNew = CS.FindGameObject( sub(K_old,2) )
                    if gameObjectNew ~= nil then 
                        self.Librairie["Interaction"](self,gameObject,gameObjectNew,v)
                    end
                else   
                    if k == "right" or k == "left" then
                        Positionnement[1][1] = k
                        Positionnement[1][2] = v or 0
                        Position_Ok = true
                    elseif k == "top" or k == "bottom" then
                        Positionnement[2][1] = k
                        Positionnement[2][2] = v or 0
                        Position_Ok = true
                    elseif k == "resize" then
                        Positionnement[3] = v
                        Position_Ok = true
                    else
                        local Find = Stylesheets.Librairie[k]
                        if Find ~= nil then 
                            Find(self,gameObject,v,true)
                        end
                    end 
                end
                 
            end
            
            if Position_Ok then
                UI:Pos(name,Positionnement[1],Positionnement[2],Positionnement[3])
            end
        end
        
        -- > Function pour les commandes d'action qui va vérifier si les scripts basique sont bien présent sur le bouton.
        function Stylesheets:CheckScript(gameObject,oncall)
            local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
            local Asset
            do local Craft = CS
                Asset = Craft.FindAsset( "United/Librairie/Button/LightButton" , "Script" )
            end
            
            if ScriptedBehavior == nil then
                gameObject:CreateScriptedBehavior( Asset , nil ) 
            end
            
            ScriptedBehavior = gameObject:GetScriptedBehavior( Asset )
            
            if ScriptedBehavior.gameObject[oncall] == nil then
                local elem = oncall.."_call"
                ScriptedBehavior.gameObject[oncall] = function( gameObject, callback ) 
                    if ScriptedBehavior[elem] ~= nil then 
                        ScriptedBehavior[elem][#ScriptedBehavior[elem] + 1] = callback 
                    else 
                        ScriptedBehavior[elem] = {callback} 
                    end
                end
            end
            
            return true
        end
        
        -- > On vérifie si une variable et inexistante, sinon on lui ajoute un comportement
        function Stylesheets:Checkvar(self,gameObject,var)
            local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
            local Asset
            do local Craft = CS
                Asset = Craft.FindAsset( "United/Librairie/Button/LightButton" , "Script" )
            end
            
            if ScriptedBehavior == nil then
                gameObject:CreateScriptedBehavior( Asset , nil ) 
                ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
            end
            if ScriptedBehavior[var] == nil then
                ScriptedBehavior[var] = self.ButtonLibrairie[var](gameObject,ScriptedBehavior["button_type"])
            end
        end
        
        Stylesheets.ButtonLibrairie = {
            ["model"] = function(gameObject)
                return gameObject.modelRenderer:GetModel()
            end,
            ["scale"] = function(gameObject)
                return gameObject.transform:GetLocalScale()
            end,
            ["opacity"] = function(gameObject,button_type)
                if button_type == "Model" then
                    return gameObject.modelRenderer:GetOpacity()
                else
                    return gameObject.textRenderer:GetOpacity()
                end
            end
        }
        
        -- > CSS KEY
        Stylesheets.Librairie = {
        
            ["Interaction"] = function(self,gameObject,gameObjectNew,v) 
                local search = pairs
                for a,b in search(v) do 
                
                    local Exec = self.Librairie[a]
                    if Exec ~= nil then
                        Exec(self,gameObject,b,true)
                    end
                    
                end
            end,
        
            -- > Transform cmd
            ["model"] = function(self,gameObject,v,primary)
                if type(v) == "string" then 
                    self:Checkvar(self,gameObject,"model")
                    local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
                    local Craft = CS
                    if primary then 
                        ScriptedBehavior["model"] = v
                        gameObject.modelRenderer:SetModel( Craft.FindAsset( v , "Model" ) ) 
                    else
                        gameObject.modelRenderer:SetModel( Craft.FindAsset( v , "Model" ) ) 
                    end
                end
            end,
            ["scale"] = function(self,gameObject,v,primary)
                self:Checkvar(self,gameObject,"scale")
                local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
                local Craft = CS
                local Scale
                do local V3 = Vector3
                    if type(v) == "number" then 
                        Scale = V3:New( v )
                    elseif type(v) == "table" then
                        Scale = V3:New( unpack(v) )
                    elseif type(v) == "string" then
                    
                    end
                end
                if primary then 
                    ScriptedBehavior["scale"] = Scale
                    gameObject.transform:SetLocalScale( Scale ) 
                else
                    gameObject.transform:SetLocalScale( Scale ) 
                end
            end,
            ["opacity"] = function(self,gameObject,v,primary)
                self:Checkvar(self,gameObject,"opacity")
                local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
                local Craft = CS
                local comp 
                if ScriptedBehavior["button_type"] == "Model" then
                    comp = gameObject.modelRenderer
                else
                    comp = gameObject.textRenderer
                end
                if type(v) == "number" then
                    if primary then
                        ScriptedBehavior["opacity"] = v 
                        comp:SetOpacity( v )
                    else
                        comp:SetOpacity( v )
                    end
                end
            end,
            ["font"] = function(self,gameObject,v,primary)
            end,
            ["text"] = function(self,gameObject,v,primary)
            end,
            ["text_scale"] = function(self,gameObject,v,primary)
            end,
            
            ["zindex"] = function(self,gameObject,v,primary)    
                if type(v) == "number" then 
                    UI:Zindex(gameObject:GetName(),v)
                end
            end,
            
            -- > Sub Action
            ["url"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    Craft.Web.Open( v )
                end
            end,
            ["redirect"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    Craft.Web.Redirect( v )
                end
            end,
            ["echo"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    local echo = print
                    echo(v)
                end
            end,
            ["loadscene"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    local asset = Craft.LoadScene( v , "Scene" ) 
                    if asset ~= nil then 
                        Craft.GetScene( v ) 
                    end
                end
            end,
            ["destroy"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    Craft.Destroy( gameObject ) 
                end
            end,
            ["exit"] = function(self,gameObject,v,primary)
                if not primary then
                    if type(v) == "boolean" then
                        if v then Craft.Exit() end
                    elseif type(v) == "function" then
                        v()
                        Craft.Exit()
                    end
                end
            end,
            
            -- > Switch & Stride
            ["switch"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "string" then
                    local find = string.find
                    local _,_,a,b = find(v, '([%a%d%p]*)[%s]?([%a%d%p]*)')
                    local result = {a,b}
                    if #result == 1 then
                        UI:Switch(v) 
                    elseif #result == 2 then
                        if UI.ActiveContainer == a then
                            UI:Switch(b)
                        elseif UI.ActiveContainer == b then
                            UI:Switch(a)
                        else
                            UI:Switch(a)
                        end
                    end
                end
            end,
            ["switch_on"] = function(self,gameObject,v,primary)
                local Script = gameObject:GetComponent("ScriptedBehavior")
                if Script["Switch_In"] ~= nil and type(v) == "function" then
                    Script["Switch_In"] = v
                end
            end, 
            ["switch_off"] = function(self,gameObject,v,primary)
                local Script = gameObject:GetComponent("ScriptedBehavior")
                if Script["Switch_Out"] ~= nil and type(v) == "function" then
                    Script["Switch_Out"] = v
                end
            end, 
            ["escape"] = function(self,gameObject,v,primary)
                local Script = gameObject:GetComponent("ScriptedBehavior")
                if Script["Escape"] ~= nil and type(v) == "function" then
                    Script["Escape"] = v
                end
            end, 
            ["stride"] = function(self,gameObject,v,primary)
                if not primary then
                    UI:StrideMove(v)
                end
            end,
            
            ["action"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "function" then
                    v()
                end
            end,
            ["timer_action"] = function(self,gameObject,v,primary)
                if not primary and type(v) == "function" then
                    -- add a task with a final callback
                end
            end,
        
            -- > Call Action
            ["CSSKeyPattern"] = function(self,gameObject,v,primary) 
                if primary then
                    local search = pairs
                    for a,b in search(v) do 
                        local Exec = self.Librairie[a]
                        if Exec ~= nil then
                            Exec(self,gameObject,b,true)
                        end
                    end
                end
            end,
            
            ["onclick"] = function(self,gameObject,v,primary) 
                if self:CheckScript(gameObject,"onclick") then
                    if type(v) == "function" then
                        return gameObject:onclick( v )
                    end
                    local search = pairs
                    for a,b in search(v) do
                        if self.Librairie[a] ~= nil then 
                            gameObject:onclick( function() 
                                self.Librairie[a](self,gameObject,b,false) 
                            end ) 
                        end
                    end
                end
            end,
            ["outclick"] = function(self,gameObject,v,primary) 
                if self:CheckScript(gameObject,"outclick") then
                    if type(v) == "function" then
                        return gameObject:outclick( v )
                    end
                    local search = pairs
                    for a,b in search(v) do
                        if self.Librairie[a] ~= nil then 
                            gameObject:outclick( function() 
                                self.Librairie[a](self,gameObject,b,false) 
                            end ) 
                        end
                    end
                end
            end,
            ["ondoubleclick"] = function(self,gameObject,v,primary) 
                if self:CheckScript(gameObject,"ondoubleclick") then
                    if type(v) == "function" then
                        return gameObject:ondoubleclick( v )
                    end
                    local search = pairs
                    for a,b in search(v) do
                        if self.Librairie[a] ~= nil then 
                            gameObject:ondoubleclick( function() 
                                self.Librairie[a](self,gameObject,b,false) 
                            end ) 
                        end
                    end
                end
            end,
            ["onhover"] = function(self,gameObject,v,primary) 
                if self:CheckScript(gameObject,"onhover") then
                    if type(v) == "function" then
                        return gameObject:onhover( v )
                    end
                    local search = pairs
                    for a,b in search(v) do
                        if self.Librairie[a] ~= nil then 
                            gameObject:onhover( function() 
                                self.Librairie[a](self,gameObject,b,false) 
                            end ) 
                        end
                    end
                end
            end,
            ["outhover"] = function(self,gameObject,v,primary) 
                if self:CheckScript(gameObject,"outhover") then
                    if type(v) == "function" then
                        return gameObject:outhover( v )
                    end
                    local search = pairs
                    for a,b in search(v) do
                        if self.Librairie[a] ~= nil then 
                            gameObject:outhover( function() 
                                self.Librairie[a](self,gameObject,b,false) 
                            end ) 
                        end
                    end
                end
            end,
            ["ondrag"] = function(self,gameObject,v,primary) 
                print("on drag function call")
            end
   
        }
        
        
        -- > ApplyMeta
        setmetatable(Stylesheets,Stylesheets)
        
        -- > Prevent destroy stylesheets Module
        United["Stylesheets"].Core = nil
        
    else
        United.Err("Impossible de charger la class stylesheets alors que la class UserInterface n'existe pas")
    end

end

end