do 
    local Script = Behavior

    function Script:Start()
        self.active = false
        if self.key ~= "nil" then
            self.active = true
            self.gameObject.textRenderer:SetText( United.Lang.Data[ United.Lang.ActiveLang ][self.key] )  
        end
    end
    
    function Script:New()
        if self.active then 
            self.gameObject.textRenderer:SetText( United.Lang.Data[ United.Lang.ActiveLang ][self.key] )  
        end
    end

end