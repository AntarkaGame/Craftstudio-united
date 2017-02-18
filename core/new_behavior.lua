function Nil()
    return nil
end

do local Craft = CS
    function Craft.Get(Name)
        return Craft.FindGameObject(Name)
    end
    
    function Craft.KeyPressed(Name)
        return Craft.Input.WasButtonJustPressed(Name) 
    end
    
    function Craft.KeyReleased(Name)
        return Craft.Input.WasButtonJustReleased(Name)
    end
    
    function Craft.KeyDown(Name)
        return Craft.Input.IsButtonDown(Name)
    end
    
    function Craft.TwoKeyDown(k1,k2)
        k1 = k1 or "a"
        k2 = k2 or "b"
        if Craft.Input.IsButtonDown(k1) and Craft.Input.IsButtonDown(k2) then 
            return true 
        end
    end
    
    function Craft.GetScene( assetName  ) 
        United:Out_Memory()
        return Craft.LoadScene( Craft.FindAsset( assetName , "Scene" ) ) 
    end
    
    function Craft.Delete( V ) 
        local Tv = type(V)
        if Tv == "table" then
            United:DestroyObject( V )
        else
            United:DestroyObject( Craft.FindGameObject(V) )
        end
    end
    
    function Craft.ObjectType( gameObject ) 
        if gameObject.modelRenderer ~= nil then
            return "Model"
        elseif gameObject.textRenderer ~= nil then
            return "Text"
        elseif gameObject.mapRenderer ~= nil then
            return "Map"
        end
    end
end