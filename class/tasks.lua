-- > On vérifie que la metatable United est existante 
if United ~= nil then 

-- > LIGHT TaskCron
United["TaskCron"] = {}
United["TaskCron"].Core = function()

    local Task = United.TaskCron
    
    -- > Metamethode
    Task.__index = Task
    Task.__call  = function(mt)  
        mt:Update()
    end
    Task.__tostring = function(mt)
        return #mt.opentask.." running for "..mt.alloued.." alloued loop"
    end
    
    -- > Variable
    Task.opentask = {}
    Task.alloued  = 5
    
    -- [ Add a new task to the while list ] -- 
    function Task:New(name,loop,innerTable,callback,finalcallback)
        local OpenTask = self.opentask 
        local TaskNumber = #OpenTask
        local Alloued = self.alloued
        
        -- > On vérifie que le nombre de task ne dépasse pas la limite de la variable "alloued".
        if TaskNumber < Alloued then
            OpenTask[name] = {
                name = name or "",
                loop = 0,
                innerTable = innerTable,
                max_loop = loop or 1,
                reverse = false,
                callback = callback or Nil,
                finalcallback = finalcallback or Nil
            }
            return true
        else
            return false
        end
    end
    
    function Task:Reverse(key)
        if self.opentask[key] ~= nil then
            print("Reverse call")
            self.opentask[key].reverse = not self.opentask[key].reverse
            self.opentask[key].loop = self.opentask[key].max_loop - self.opentask[key].loop
        else
            return nil
        end
    end
    
    -- [ Function Update task ] --
    function Task:Update()
        local search = pairs
        for k,v in search(self.opentask) do
            if v.loop <= v.max_loop then
                v.callback(v)
                v.loop = v.loop + 1
            else
                v.finalcallback(v)
                self.opentask[k] = nil
            end
        end
    end
    
    -- > ApplyMetatable
    setmetatable(Task,Task)
    TASK = Task 
    
    -- > Prevent destroy core 
    United["TaskCron"].Core = nil 
    
end

end