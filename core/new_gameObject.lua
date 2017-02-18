function GameObject.Get( gameObject, child ) 
    return gameObject:FindChild(child)
end

do
    local FunctionTable = {
        ["Pos"] = function(self)                                                        
            return self.transform:GetPosition()         
        end,
        ["Localpos"] = function(self)                                                        
            return self.transform:GetLocalPosition()    
        end,
        ["Scale"] = function(self)                                                        
            return self.transform:GetLocalScale()       
        end,
        ["Orientation"] = function(self)                                                        
            return self.transform:GetOrientation()      
        end,
        ["Localorientation"] = function(self)                                                        
            return self.transform:GetLocalOrientation() 
        end,
        ["Angles"] = function(self)                                                        
            return self.transform:GetEulerAngles()      
        end,
        ["Localangles"] = function(self)                                                        
            return self.transform:GetLocalEulerAngles() 
        end,
        ["Parent"] = function(self)                                                        
            return self.GetParent()                     
        end,
        ["Name"] = function(self)                        
            return self:GetName()                            
        end,
        ["Children"] = function(self)                    
            return self:GetChildren()                        
        end,
        ["Scriptedbehavior"] = function(self) 
            return self:GetComponent("ScriptedBehavior")                         
        end,
        
        -- ModelRenderer INDEX
        ["Getmodel"] = function(self)
            return self.modelRenderer:GetModel()
        end,
        ["Animation"] = function(self)
            return self.modelRenderer:GetAnimation()
        end,
        ["Animationtime"] = function(self)
            return self.modelRenderer:GetAnimationTime()
        end,
        ["Startanimation"] = function(self)
            return self.modelRenderer:StartAnimationPlayback()
        end,
        ["Stopanimation"] = function(self)
            return self.modelRenderer:StopAnimationPlayback()
        end,
        ["Isplay"] = function(self)
            return self.modelRenderer:IsAnimationPlaying()
        end,
        ["Modelopacity"] = function(self)
            return self.modelRenderer:GetOpacity()
        end,
        
        -- TextRenderer INDEX
        ["Font"] = function(self)
            return self.textRenderer:GetFont()
        end,
        ["Text"] = function(self)
            return self.textRenderer:GetText()
        end,
        ["Alignment"] = function(self)
            return self.textRenderer:GetAlignment()
        end,
        ["Textwidth"] = function(self)
            return self.textRenderer:GetTextWidth()
        end,
        ["Textopacity"] = function(self)
            return self.textRenderer:GetOpacity()
        end,
        
        -- MapRenderer INDEX
        ["Tileset"] = function(self)
            return self.mapRenderer:GetTileSet()
        end,
        ["Mapopacity"] = function(self)
            return self.mapRenderer:GetOpacity()
        end,
        ["Chunk"] = function(self)
            return self.mapRenderer:GetChunkRenderDistance()
        end,
        

        -- Function INDEX
        ["length"] = function(self)
            local Pos = self.transform:GetPosition()
            return Pos:SqrLength()
        end
    }
    
    function GameObject.__index(self,key)
        return FunctionTable[key] and FunctionTable[key](self) or GameObject[key]
    end
end
