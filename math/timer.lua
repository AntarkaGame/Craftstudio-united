Timer = {
    v=0,
    state = true,
    __call = function(I,minus)
        if I.state then 
            if I.v > 0 then
                local fx_max = math.max
                I.v = (minus~=nil) and fx_max(I.v - minus,0) or fx_max(I.v - 1,0)
                return false
            elseif I.v < 0 then
                local fx_min = math.min
                I.v = (minus~=nil) and fx_min(I.v + minus,0) or fx_min(I.v + 1,0)  
                return false
            else
                if I.boucle then
                    I:Reset(I.default)
                else
                    I:State()
                end
                I:callback()
                return true
            end
        end
    end           
}
Timer.__index = Timer
setmetatable(Timer,Timer)

function Timer:New(V,boucle,state,callback)
    return setmetatable( { v = V, default = V, state = state or true, boucle = boucle or false, callback = callback or function() end}, self )
end

function Timer:Reset(V)       
    self.v,self.default = V,V
end

function Timer:State(V)
    self.state = V or false
end

function Timer:Get()      
    return self.v       
end