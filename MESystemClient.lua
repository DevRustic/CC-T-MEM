basePort = 3100
computerNumber = 1
transmitPort = basePort + computerNumber
os.setComputerLabel("Client".." "..computerNumber)

me = peripheral.find("meBridge")
modem = peripheral.wrap("bottom")

while true do 
    local label = os.getComputerLabel()
    local status = "Online"
    local availableStorage = me.getAvailableItemStorage()

    if me.getEnergyUsage() < 10 then
        status = "Offline"
    end

    modem.transmit(transmitPort, transmitPort, {label, status, availableStorage})
    term.clear()    
    print(availableStorage)
    print(me.getEnergyUsage())
    sleep(0)
end