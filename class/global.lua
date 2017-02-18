-- > On vérifie que la metatable United est existante 
if United ~= nil then 

-- > United Font Class
United["Font"] = {}
United["Font"].Core = function()

    local Font = United.Font 
    local Pattern = "Sample Fonts/"
    
    -- > Font disponible
    do local Craft = CS
        Font.Default    = Craft.FindAsset(Pattern.."Titillium Web") 
        Font.Russo      = Craft.FindAsset(Pattern.."Russo One")
    end
    
    -- > Metamethode
    Font.__index = Font
    Font.__call  = function(I,V) return Font.Default end 
    Font.__tostring = function()
        return Pattern
    end
    
    -- > Apply metatable 
    setmetatable(Font,Font) 
    
    -- > Prevent destroy font core
    United["Font"].Core = nil
    
end

-- > United Lang Class
United["Lang"] = {}
United["Lang"].Librairie = {}
United["Lang"].Core = function()

    if SceneConstructor ~= nil then 

        local Language = United.Lang
        
        Language.ActiveLang = nil
        Language.Data = {}
        Language.Error = {__index = function() 
            return "LANG ERR" 
        end }
        
        function Language:Construct()
            for i = 1 ,#United.Lang.Librairie do
                United.Lang.Librairie[i]()
            end
            
            -- > On construit les scripts.
            local R = SceneConstructor:Get("lang")
            if R ~= false then 
                local Craft = CS
                local sub = string.sub
                for i = 1, #R do
                    local keyfind = sub(R[i]:GetName(),6)
                    R[i]:CreateScriptedBehavior( Craft.FindAsset( "United/Librairie/Core/LangScene" , "Script" ) , {key=keyfind} )
                end
            end
        end
        
        -- > Define a new lang
        function Language:New(lang) 
            if Language.Data[lang] ~= nil then 
                self.ActiveLang = lang
                local R = SceneConstructor:Get("lang")
                for i = 1, #R do
                    R[i]:SendMessage("New")
                end
            end
        end
        
        -- > Add lang to registre data
        function Language:Return(lang)
            self.Data[lang] = {}
            setmetatable(self.Data[lang],Language.Error)
            return self.Data[lang] 
        end
        
        -- > Apply metatable
        setmetatable(Language,Language)
        
        -- > Language metamethode
        Language.__index = Language
        Language.__call = function(mt,lang)
            mt:New(lang)
        end
        
    end
    
    -- > Prevent destroy lang core
    United["Lang"].Core = nil

end

-- > United Ascii Class
United["Ascii"] = {}
United["Ascii"].Core = function()

    local Ascii = United.Ascii
    
    -- > Invalide caractères with craftstudio.
    Ascii.BypassTable = {
        ["¨"] = {v=94 ,t="^"},
        ["£"] = {v=36 ,t="$"},
        ["ê"] = {v=36 ,t="$"},
        ["µ"] = {v=42 ,t="*"},
        ["§"] = {v=33 ,t="!"},
        ["é"] = {v=126,t="~"},
        ["è"] = {v=91 ,t="["},
        ["`"] = {v=91 ,t="["},
        ["ç"] = {v=93 ,t="]"},
        ["à"] = {v=64 ,t="@"},
        ["ù"] = {v=37 ,t="%"}
    }
    
    -- > Set methamethode for table Bypass
    setmetatable( Ascii.BypassTable,{
        __index = function(_,char) 
            local fx = string.byte
            return fx(char),"" 
        end,
        __call = function(mt,char)
            return mt[char].v,mt[char].t
        end
    } )
    
    Ascii.librairie = {
        ["DefaultTable"] = {     
          [32] = true,  [33] = true,  [34] = true,  [35] = true,  [36] = true,  [37] = true,  [38] = true,
          [39] = true,  [40] = true,  [41] = true,  [42] = true,  [43] = true,  [44] = true,  [45] = true, 
          [46] = true,  [47] = true,  [48] = true,  [49] = true,  [50] = true,  [51] = true,  [52] = true,
          [53] = true,  [54] = true,  [55] = true,  [56] = true,  [57] = true,  [58] = true,  [59] = true,
          [60] = true,  [61] = true,  [62] = true,  [63] = true,  [64] = true,  [65] = true,  [66] = true,
          [67] = true,  [68] = true,  [69] = true,  [70] = true,  [71] = true,  [72] = true,  [73] = true,
          [74] = true,  [75] = true,  [76] = true,  [77] = true,  [78] = true,  [79] = true,  [80] = true,
          [81] = true,  [82] = true,  [83] = true,  [84] = true,  [85] = true,  [86] = true,  [87] = true,
          [88] = true,  [89] = true,  [91] = true,  [92] = true,  [93] = true,  [94] = true,  [95] = true,
          [90] = true,  [97] = true,  [98] = true,  [99] = true,  [100] = true, [101] = true, [102] = true,
          [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [108] = true, [109] = true,
          [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, [116] = true,
          [117] = true, [118] = true, [119] = true, [120] = true, [121] = true, [122] = true, [123] = true,
          [124] = true, [125] = true, [126] = true
        }
    }
    
    -- > Default ASCII table
    function Ascii:Get(Table,AddChar,RemoveChar)
        local innerTable = self.librairie[Table]
        
        if AddChar ~= nil then
            for i = 1 , #AddChar do
                local ID = AddChar[i]
                innerTable[ID] = true
            end
        end
        
        if RemoveChar ~= nil then
            for i = 1 , #RemoveChar do
                local ID = RemoveChar[i]
                innerTable[ID] = false
            end
        end
        
        return setmetatable(innerTable,{ __index = function() 
            return false 
        end})
    end

    
    -- > ApplyMetatable
    setmetatable(Ascii,Ascii)
    
    -- > Prevent destroy ascii core
    United["Ascii"].Core = nil

end

end