script_properties('work-in-pause')

local encoding = require('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

local samp = require('samp.events')
local effil = require('effil')

-- Настройки Telegram
local chatID = '1239573440'
local token = '7830573550:AAE-39gSXUwUgUJC7xpt8DrXeQBm2S0VTt0'

-- Поток отправки
local effilTelegramSendMessage = effil.thread(function(text)
    local requests = require('requests')
    requests.post(('https://api.telegram.org/bot%s/sendMessage'):format(token), {
        params = {
            chat_id = chatID,
            text = text,
        }
    })
end)

function url_encode(text)
    return text:gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end):gsub(" ", "+")
end

function sendTelegramMessage(text)
    effilTelegramSendMessage(url_encode(u8(text)))
end

function main()
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand("tg", function()
        local nickname = sampGetPlayerNickname(select(2, sampGetPlayerIdByCharHandle(PLAYER_PED)))
        sendTelegramMessage("Ник игрока: " .. nickname)
    end)

    sampAddChatMessage("[Telegram] {FFFFFF}Команда /tg активна. Отправка ника в Telegram.", 0x3083FF)
end
