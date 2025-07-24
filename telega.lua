script_properties('work-in-pause')

local samp = require('samp.events')
local effil = require('effil')
local ffi = require('ffi')
local encoding = require('encoding')
encoding.default = 'CP1251'
u8 = encoding.UTF8

-- Çàìåíåíû íà ôèêñèðîâàííûå çíà÷åíèÿ
local chatID = 'чат ид '
local token = 'токен'

local effilTelegramSendMessage = effil.thread(function(text)
    local requests = require('requests')
    requests.post(('https://api.telegram.org/bot%s/sendMessage'):format(token), {
        params = {
            text = text,
            chat_id = chatID,
        }
    })
end)

function url_encode(text)
    local text = string.gsub(text, "([^%w-_ %.~=])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return string.gsub(text, " ", "+")
end

function sendTelegramMessage(text)
    local text = text:gsub('{......}', '') -- óáðàòü öâåòîâûå êîäû
    effilTelegramSendMessage(url_encode(u8(text)))
end

function main()
    while not isSampAvailable() do wait(0) end
    sampAddChatMessage('[telegram] {ffffff}Ñêðèïò àêòèâåí. Îæèäàåì ñîîáùåíèÿ â ÷àòå...', 0x3083ff)
    wait(-1)
end

function samp.onServerMessage(color, text)
    if text:lower():find('ñòðîé') then
        sendTelegramMessage('Â ÷àòå îáíàðóæåíî ñîîáùåíèå: ' .. text)
    end
end
