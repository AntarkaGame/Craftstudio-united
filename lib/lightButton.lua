do
    local Script = Behavior
    local Craft = CS
    
    local Comportement = {
        ["Model"] = function(self)
        
            if self.next_call ~= nil then 
                for i=1 , #self.next_call do
                    self.next_call[i]()
                end
            end
            
            if UI.ray:IntersectsModelRenderer( self.gameObject.modelRenderer ) ~= nil then 
            
                if not self.button_hover then
                    self.button_hover = true
                    if self.onhover_call ~= nil then 
                        for i=1 , #self.onhover_call do
                            self.onhover_call[i]()
                        end
                    end
                end
            
                if Craft.Input.WasButtonJustReleased("SG") then 
                    if self.onclick_call ~= nil then 
                        self.button_click = true
                        for i=1 , #self.onclick_call do
                            self.onclick_call[i]()
                        end
                    end
                end
                
            else
            
                if self.button_hover then
                    self.button_hover = false
                    
                    if self.button_click then
                        self.button_click = false
                        if self.outclick_call ~= nil then 
                            for i=1 , #self.outclick_call do
                                self.outclick_call[i]()
                            end
                        end
                    end
                    
                    if self.outhover_call ~= nil then 
                        for i=1 , #self.outhover_call do
                            self.outhover_call[i]()
                        end
                    end
                    self:Reset_button()
                end
                
            end

        end;
        ["Text"] = function(self)
        
            if self.next_call ~= nil then 
                for i=1 , #self.next_call do
                    self.next_call[i]()
                end
            end
            
            if UI.ray:IntersectsTextRenderer( self.gameObject.textRenderer ) ~= nil then 
            
                if not self.button_hover then
                    self.button_hover = true
                    if self.onhover_call ~= nil then 
                        for i=1 , #self.onhover_call do
                            self.onhover_call[i]()
                        end
                    end
                end
            
                if Craft.Input.WasButtonJustReleased("SG") then 
                    if self.onclick_call ~= nil then 
                        self.button_click = true
                        for i=1 , #self.onclick_call do
                            self.onclick_call[i]()
                        end
                    end
                end
                
            else
            
                if self.button_hover then
                    self.button_hover = false
                    
                    if self.button_click then
                        self.button_click = false
                        if self.outclick_call ~= nil then 
                            for i=1 , #self.outclick_call do
                                self.outclick_call[i]()
                            end
                        end
                    end
                    
                    if self.outhover_call ~= nil then 
                        for i=1 , #self.outhover_call do
                            self.outhover_call[i]()
                        end
                    end
                    self:Reset_button()
                end
                
            end
        
        end
    }
    
    local Reset_Comportement = {
        ["Model"] = function(self)
            local V3 = Vector3
            
            -- > On vérifie si modèle est différent de nil 
            if self.model ~= nil then
                if self.model ~= self.gameObject.modelRenderer:GetModel() then
                    self.gameObject.modelRenderer:SetModel( self.model ) 
                end
            end
            
            if self.scale ~= nil then
                if self.scale ~= self.gameObject.transform:GetLocalScale() then
                    self.gameObject.transform:SetLocalScale( self.scale )
                end
            end
            
            if self.opacity ~= nil then
                if self.opacity ~= self.gameObject.modelRenderer:GetOpacity() then
                    self.gameObject.modelRenderer:SetOpacity( self.opacity ) 
                end
            end
            
        end,
        ["Text"] = function(self)
            local V3 = Vector3
            
            if self.scale ~= nil then
                if self.scale ~= self.gameObject.transform:GetLocalScale() then
                    self.gameObject.transform:SetLocalScale( self.scale )
                end
            end
            
            if self.opacity ~= nil then
                if self.opacity ~= self.gameObject.textRenderer:GetOpacity() then
                    self.gameObject.textRenderer:SetOpacity( self.opacity ) 
                end
            end
            
        end
    }
    
    if United.UserInterface ~= nil then 
    
        function Script:Awake()
            if self.wakning == nil then 
                self.wakning = true
                self.button_hover = false
                self.button_click = false
                self.button_type = Craft.ObjectType(self.gameObject) 
            end
        end
        
        function Script:Reset_button()
            Reset_Comportement[self.button_type](self)
        end
        
        function Script:Update()
            Comportement[self.button_type](self)
        end
        
    end

end
