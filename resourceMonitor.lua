me = peripheral.find("meBridge")
mon = peripheral.wrap("right")

meItemsNeeded = {
    [1] = {"Netherite Ingot", "minecraft:netherite_ingot"},
    [2] = {"Redstone", "minecraft:redstone"},
    [3] = {"Quartz Glass", "ae2:quartz_glass"},
    [4] = {"Sky Stone Dust", "ae2:sky_dust"},
    [5] = {"Glowstone Dust", "minecraft:glowstone_dust"},
    [6] = {"Amethyst Shard", "minecraft:amethyst_shard"},
    [7] = {"Certus Crystal", "ae2:certus_quartz_crystal"},
    [8] = {"Logic Processor", "ae2:logic_processor"},
    [9] = {"Calculation Processor", "ae2:calculation_processor"},
    [10] = {"256k Drive", "ae2things:disk_drive_256k"}
}

function checkMe(checkName, name)
    --Get item info from system
    meItem = me.getItem({name = checkName})
    --Typically caused by typo in item name
    if meItem == nil then
      print("Failed to locate meItem " .. checkName)
      return
    end

    size = tostring(meItem.amount)
    ItemName = meItem.name
    row = row + 1
    itemColor = colors.green

    if ItemName == "ae2things:disk_drive_256k" then
        CenterT(name, row + 1, colors.black, colors.green, "left", false)
        if size == nil or size == "nil" or size == "0" then
            size = "0"
            itemColor = colors.red
        end
        CenterT(size, row + 1, colors.black, itemColor, "right", true)
        return
    end
    
    CenterT(name, row, colors.black, colors.lightGray, "left", false)

    if size == nil or size == "nil" then
        size = "0"
        itemColor = colors.red
    end
    CenterT(size, row, colors.black, itemColor, "right", true)
end





function checkTable()
    row = 2
    --Loop through our me items and check if they need to be crafted
    for i = 1, #meItemsNeeded do
        checkName = meItemsNeeded[i][2]
        name = meItemsNeeded[i][1]
        checkMe(checkName, name)

        print(checkName.. " " ..name)
    end
end





function prepareMonitor()
    mon.clear()
    CenterT(label, 1, colors.black, colors.white, "head", false)
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
        if clear then
            clearBox(2, 1 + length, line, line)
        end
        mon.setCursorPos(2, line)
        mon.write(text)
    elseif pos == "Disk" then
        if clear then
            clearBox(2, 1 + length, line, line)
        end
        mon.setCursorPos(2, line + 1)
        mon.write(text)
    elseif pos == "right" then
        if clear then
            clearBox(monX - length - 8, monX, line, line)
        end
        mon.setCursorPos(monX - length, line)
        mon.write(text)
    end
end

--Clear a specific area, prevents flickering
function clearBox(xMin, xMax, yMin, yMax)
    mon.setBackgroundColor(colors.black)
    for xPos = xMin, xMax, 1 do
        for yPos = yMin, yMax do
            mon.setCursorPos(xPos, yPos)
            mon.write(" ")
        end
    end
end

prepareMonitor()

while true do
    checkTable()
    --Update every 3 seconds
    sleep(0)
end