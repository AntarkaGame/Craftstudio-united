-- > On vérifie que la metatable United est existante 
if United ~= nil then 

United["SceneConstructor"] = {}
United["SceneConstructor"].Core = function()

    local SC = United.SceneConstructor
    
    -- > Metamethode
    SC.__index = SC
    SC.__call = function(mt)
        mt:Scanroom()
    end
    
    -- > Regex Librairie
    SC.Regex = {
        ["input_"] = "input",
        ["lang_"] = "lang",
        ["container_"] = "container"
    }
    
    -- > Storage
    SC.Storage = {}
    
    -- > Generation is true ?
    SC.Generate = false
    
    function SC:Scanroom()
        local RoomGameObject
        do local Craft = CS
            RoomGameObject = Craft.GetRootGameObjects()
        end
        for i = 1 , #RoomGameObject do
            self:Scanwhile( RoomGameObject[i]:GetChildren() )
        end
        
        do
            local search = pairs
            local find = string.find
            local lower = string.lower
            
            local NewTable = {
                ["notag"] = {}
            }
            
            -- > On construit les catégories ! 
            for i = 1 , #self.Storage  do
                local name = lower(self.Storage[i][1]:GetName())
                local match = false
                for k,v in search(self.Regex) do
                    if find( name , k , 1 ) == 1 then   
                        local VL = lower(v)
                        if NewTable[ VL ] == nil then
                            NewTable[ VL ] = {}
                        end
                        NewTable[VL][#NewTable[VL] +1] = self.Storage[i][1]
                        match = true
                    end
                end
                if not match then
                    NewTable["notag"][#NewTable["notag"] +1] = self.Storage[i][1]
                end
            end
            
            self.Storage = NewTable
        end
        
        -- > On construit la langue
        United.Lang:Construct() 
        
        -- > Generation True
        SC.Generate = true
    end
    
    function SC:Scanwhile(gameObjects)
        for i = 1 , #gameObjects do
            local gameObject = gameObjects[i]
            local ObjectChild = gameObject:GetChildren() 
            self.Storage[#self.Storage +1] = { gameObject , nil } 
            if ObjectChild ~= 0 then
                self:Scanwhile( ObjectChild )
            end
        end
    end
    
    -- > Add a new tag
    function SC:AddTag(tag,value)
        if tag ~= nil and value ~= nil then
            tag = string.lower(tag)
            value = string.lower(value)
            self.Regex[tag] = value
        end
    end
    
    -- > Retourner tout les gameObjects avec un tag "X" 
    function SC:Get(tag)
        do local lower = string.lower
            tag = lower(tag) or "notag"
        end
        local Group = self.Storage[tag]
        if Group ~= nil then 
            local R = {}
            for i = 1 , #Group do
                R[i] = Group[i] 
            end
            return R
        else
            return false
        end
    end
    
    -- > Echo tag
    function SC:Echo(tag,name)
        name = name or false
        local R = self:Get(tag)
        local search = pairs
        local echo = print
        if name then 
            for k,v in search(R) do
                echo(k,v:GetName())
            end
        else
            for k,v in search(R) do
                echo(k,v)
            end
        end
    end
    
    -- > Détruire tout les gameObjets avec un tag "X"
    function SC:Destroy(tag)
        local Group = self.Storage[tag] 
        if Group ~= nil then
            for i = 1, #Group do
                local Craft = CS
                Craft.Destroy( Group[i][1] ) 
                Group[i] = nil 
            end
            Group = nil 
            return true
        else
            return false
        end
    end
    
    -- > Envoie un message au gameObject du groupe "X"
    function SC:Message(tag,fonction,behavior)
        local Group = self.Storage[tag] 
        if Group ~= nil and fonction ~= nil then
            for i = 1 , #Group do
                local gameObject = Group[i][1]
                local ScriptedBehavior = gameObject:GetComponent("ScriptedBehavior")
                if ScriptedBehavior ~= nil then
                    -- > A verifie si ça marche.
                    if ScriptedBehavior[fonction] ~= nil then 
                        gameObject:SendMessage(fonction,behavior)
                    end
                end
            end
            return true
        else
            return false
        end
    end
    
    -- > Détruire un objet du tableau.
    function SC:ObjectDestroy(gameObject)
        local Craft = CS
        local search = pairs
        local find = false
        local deleteinfo = {tag=nil,k=nil}
        for x,v in search(self.Storage) do
            for i,k in search(v) do
                if k == gameObject then
                    find = true
                    deleteinfo.tag = x 
                    deleteinfo.k = i
                    break
                end
            end
        end
        
        if find then
            self.Storage[ deleteinfo.tag ][ deleteinfo.k ] = nil
            return true
        else
            return false
        end
    end
    
    -- > Out the memory alloued basicly by sceneConstructor.
    function SC:Out_Memory()
        self.Storage = nil
        self.Storage = {}
        self.Generate = false
    end
    
    -- > ApplyMeta
    setmetatable(SC,SC)
    
    SceneConstructor = SC
    
    -- > Prevent destroy constructor scene
    United["SceneConstructor"].Core = nil

end

end