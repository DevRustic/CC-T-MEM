basePort = 3100

mon = peripheral.wrap("top")
modem = peripheral.wrap("left")
os.setComputerLabel("Database Control Center")


function openPorts()
    local i = 1
    while i < 19 do
        modem.open(basePort + i)
        i = i + 1
    end
end

availableMESystems = {
    -- Labal - Status - Available Space - Port
    [1] = {"", "", "", basePort + 1},
    [2] = {"", "", "", basePort + 2},
    [3] = {"", "", "", basePort + 3},
    [4] = {"", "", "", basePort + 4},
    [5] = {"", "", "", basePort + 5},
    [6] = {"", "", "", basePort + 6},
    [7] = {"", "", "", basePort + 7},
    [8] = {"", "", "", basePort + 8},
    [9] = {"", "", "", basePort + 9},
    [10] = {"", "", "", basePort + 10},
    [11] = {"", "", "", basePort + 11},
    [12] = {"", "", "", basePort + 12},
    [13] = {"", "", "", basePort + 13},
    [14] = {"", "", "", basePort + 14},
    [15] = {"", "", "", basePort + 15},
    [16] = {"", "", "", basePort + 16},
    [17] = {"", "", "", basePort + 17},
    [18] = {"", "", "", basePort + 18}
}


function setTable(senderChannel, message, channel, tableEntry)
    if senderChannel == channel then 
        availableMESystems[tableEntry][1] = message[1]
        availableMESystems[tableEntry][2] = message[2]
        availableMESystems[tableEntry][3] = message[3]
    end
end


function fillTable()
    event, modemSide, senderChannel, replyChannel, message = os.pullEvent("modem_message")
    local i = 1
    while i < 19 do
        setTable(senderChannel, message, basePort + i, i)
        i = i + 1
    end  
end

function printEntry(currentRow)
    row = row + 1
    local textColor = colors.lightGray
    if availableMESystems[currentRow][2] == "Offline" then 
        textColor = colors.red
    elseif availableMESystems[currentRow][2] == "Online" then
        textColor = colors.green
    end

    remainingStorage = tostring(availableMESystems[currentRow][3].." Bytes")

    CenterT(availableMESystems[currentRow][1], row, colors.black, textColor, "left", false)
    CenterT(availableMESystems[currentRow][2], row, colors.black, textColor, "middle", false)
    CenterT(remainingStorage, row, colors.black, colors.lightGray, "right", false)
end 

function prepareMonitor()
    --mon.clear()
    CenterT(os.getComputerLabel(), 1, colors.black, colors.white, "head", false)
end

function prepareServer()
    row = 4
    fillTable()

    local i = 1

    while i < 19 do
        printEntry(i)
        i = i + 1
    end
end

--A util method to print text centered on the monitor
function CenterT(text, line, txtback, txtcolor, pos, clear)
    if text == nil then
        return
    end
    monX, monY = mon.getSize()
    mon.setTextColor(txtcolor)
    length = string.len(text)
    dif = math.floor(monX - length)
    x = math.floor(dif / 2)

    if pos == "head" then
        mon.setCursorPos(x + 1, line)
        mon.write(text)
    elseif pos == "left" then
        mon.setCursorPos(2, line)
        mon.write(text)
    elseif pos == "right" then
        mon.setCursorPos(monX - length, line)
        mon.write(text)
    elseif pos == "middle" then
        local middleX = math.floor((2 + monX) / 2) -- Calculate the middle position
        local textX = middleX - math.floor(length / 2) -- Calculate the starting position for the text
        mon.setCursorPos(textX, line)
        mon.write(text)
    end
end

prepareMonitor()

while true do
    prepareMonitor()
    prepareServer()
    --sleep(0)
end