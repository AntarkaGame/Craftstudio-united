Data = {}
Data["Option"] = "data_option_001"
Data["Game"] = "data_game_001"

-- > Storage
Storage = {}
Storage["Option"] = {
    general = {
        ["Language"] = "EN",
        ["Screensize"] = 16,
        ["Console_key"] = "_"
    },
    keyboard = {
        ["Avancer"] = "Z",
        ["Reculer"] = "S",
        ["Gauche"] = "Q",
        ["Droite"] = "D",
        ["Sauter"] = "Espace",
        ["SG"] = "SG",
        ["SD"] = "SD"
    },
    mouse = {
        ["Sensibility"] = 1,
        ["Axe"] = true
    },
    sound = {
        ["general"] = 0.5;
        ["musique"] = 0.5;
        ["environnement"] = 0.5;
        ["hud"] = 0.5;
    }
} 
Storage["Game"] = {}

function LoadData(name)
    local StoreName = Storage[name]
    local Craft = CS
    Craft.Storage.Load( Data[name] , function(error, data)
        if error ~= nil then
            return
        end
        if data ~= nil then
            StoreName = data
        end
    end )
end

function SaveData(name)    
    local Craft = CS
    Craft.Storage.Save( Storage[name] , Data[name] , function(error)
        if error ~= nil then
            return
        end
    end )
end

LoadData("Option")
LoadData("Game")
