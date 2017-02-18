-- > On vérifie que la metatable United est existante 
if United ~= nil then 

United["Sound3D"] = {}
United["Sound3D"].Core = function()

    local Sound3D = United.Sound3D
    
    -- > Metamethode
    Sound3D.__index = Sound3D
    
    
    -------------------------------------------------------------------------------------
                                -- [ FUNCTION SOUND3D ] --
    -------------------------------------------------------------------------------------

    function Sound3D:New( asset, object, max, min, maxsound, loop, listener, static )
    
        local mt = setmetatable(  {
            gameObject    = object,
            Instance      = nil,
            max           = max or 100,
            min           = min or 3,
            maxsound      = maxsound or 1,
            loop          = loop or false,
            pos           = nil,
            listener      = nil,
            static        = nil or true
        } , self )
        local Craft = CS
        local sound = Craft.FindAsset( asset, "Sound" )
        
        if sound == nil then
            print("Sound : "..asset.."doesn't exist !")
            return nil
        elseif listener == nil then
            print("Error : listener doesn't exist !")
            return nil
        else
            mt.listener     = listener
            mt.pos          = mt.gameObject.transform:GetPosition()
            mt.Instance     = sound:CreateInstance()
            mt.Instance:Play()
            mt.Instance:SetLoop(mt.loop)
            return mt
        end
    end
    
    function Sound3D:Check()
        local V3 = Vector3
        local ma = math
        local listenerPos = self.listener.transform:GetPosition()
        local distance = V3.Distance( listenerPos, self.pos )
        
        -- Si l'objet d'écoute est dans le rayon du son alors
        if distance < self.max and distance > 0 then
            if distance < self.min then
                self.Instance:SetVolume(self.maxsound)
            else
                local factor = ( ( self.max - ( distance - self.min ) ) / self.max ) * self.maxsound
                self.Instance:SetVolume(factor)
            end
            
            -- On ajuste la balance des écouteurs
            local listenerPos    = self.listener.transform:GetPosition()
            local listenerOrient = ma.rad(self.listener.transform:GetEulerAngles().y)
            local listenerDirection = V3:New( ma.sin( listenerOrient ), 0, ma.cos( listenerOrient ) )
            local NormListennerDir  = listenerDirection:Normalized()
            
            local SoundDirFromListener   = listenerPos - self.pos
            SoundDirFromListener.y = 0
            
            
            -- Produit scalaire : formule pour avoir un angle avec 2 vecteurs : cos(angle) = (O->A * O->B) / (OA * OB) et le resultat sera toujours positif entre 0 et 180
            -- O->A * O->B = Vector3.Dot(A,B)   --   Dot = produit scalaire
            -- OA = Vector3:Length()
            local DotProduct = V3.Dot(NormListennerDir , SoundDirFromListener)
            local LenghtProd = NormListennerDir:Length() * SoundDirFromListener:Length()
            
            local resulAngle = ma.deg(ma.acos(DotProduct / LenghtProd))
            
            local pan = nil
            if resulAngle > 90 then
                pan = (90 - (resulAngle % 90)) / 100
            else
                pan = resulAngle / 100
            end
            
            -- On utilise la formule du déterminent d'une matrice 2*2 (X,Z) pour savoir si le son est à notre droite ou à notre gauche en fonction de notre orientation
            -- deter de la matrice 2x2 M : |a  b| -- a b = 1er vecteur 2D -- c d = 2em vecteur 2D
            --                             |c  d| = a*d - b*c
            -- le vecteur ab sera représenté sous forme d'une droite et le vecteur cd sous forme d'un point donc
            -- vue que le vecteur ad est notre direction d'orientation et le vecteur cd notre point qui représente l'emplacement du son
            -- nous allons pouvoir savoir si le son est a droite ou a gauche de la droite
            
            local vec1 = listenerDirection
            local vec2 = SoundDirFromListener
            local determinent = vec1.x * vec2.z - vec1.z * vec2.x
            
            -- si le résultat est positif alors le point est à gauche de la droite
            -- si le résultat est négatif alors le point est à droite de la droite
            -- si le résultat est nul alors le point est sur la droite 
            
            if determinent >= 0 then
                self.Instance:SetPan(pan)
            else 
                self.Instance:SetPan(-pan)
            end
        else
            self.Instance:SetVolume(0)
        end
        
        if not self.static then
            self:Move()
        end
    end
    
    function Sound3D:Move()
        self.pos = self.gameObject.transform:GetPosition()
    end
    
    -------------------------------------------------------------------------------------
                                -- [ END FUNCTION SOUND3D ] --
    -------------------------------------------------------------------------------------

    United["Sound3D"].Core = nil
end

end