-- > New Call
setmetatable( Vector3, { __call = function(Object, ...) return Object:New(...) end } )
setmetatable( Quaternion, { __call = function(Object, ...) return Object:New(...) end } )
setmetatable( Plane, { __call = function(Object, ...) return Object:New(...) end } )


-- > Math 
function math.MinMax(a,b)
    return (a>b) and b,a or a,b 
end

function math.Lerp(A,B,Step)
    return B + (A-B)*Step
end

function math.RoundLerp(A,B,Step)
    return (Step > 0.5 and A) or B
end

function math.RoundFrom(Dec,Numb)
    local dec = 10 ^ Dec
    local fx = math.round
    return fx(Numb*dec)/dec
end

function math.FloorFrom(Dec,Numb)
    local dec = 10 ^ Dec
    local fx = math.floor
    return fx(Numb*dec)/dec
end

function math.CeilFrom(Dec,Numb)
    local dec = 10 ^ Dec
    local fx = math.ceil
    return fx(Numb*dec)/dec
end