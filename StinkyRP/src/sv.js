const timeouts = require('./src/timeouts.json')

let ESX = null;
emit("exile:getsharedobject", (obj) => ESX = obj);

setInterval(writeFile, 60*2*1000)

RegisterCommand('dailycase', (source, args, rawCommand) => {
    if(!GetPlayerName(source).toLowerCase().includes('exilerp.eu') && !GetPlayerName(source).toLowerCase().includes('exilerp')) return emitNet("esx:showNotification", source, `Aby móc odebrać skrzynke musisz posiadać fraze serwera w nicku!`)
    let ids = getIdentifiers(source);
    let xPlayer = ESX.GetPlayerFromId(source)
    if(!timeouts[ids.license]) {
        updateEXP(ids.license);
        xPlayer.addInventoryItem('dailycase', 1)
        return
    }
    if(timeouts[ids.license].exp < Date.now()/1000) {
        updateEXP(ids.license)
        xPlayer.addInventoryItem('dailycase', 1)
    } else {
        let difference = Math.floor(timeouts[ids.license].exp - Date.now()/1000)
        emitNet("esx:showNotification", xPlayer.source, `Aby odebrać skrzynke poczekaj jeszcze ${Math.floor(difference/3600)} godzin/y(${Math.floor(difference/60)} minut/y)`)
    }
})

function getIdentifiers(id) {
    let identifiers = {"steam":"Brak","license":"Brak","discord":"Brak"}
    for (let i = 0; i < GetNumPlayerIdentifiers(id); i++) {
        const identifier = GetPlayerIdentifier(id, i);

        if (identifier.includes('steam:')) identifiers.steam = identifier;
        if (identifier.includes('license:')) identifiers.license = identifier;
        if (identifier.includes('discord:')) identifiers.discord = identifier;
    }

    return identifiers;
}

function updateEXP(identifier) {
        timeouts[identifier] = {exp: Math.floor(new Date()/1000) + 86400}
}

function writeFile() {
    SaveResourceFile(GetCurrentResourceName(), "src/timeouts.json", JSON.stringify(timeouts), -1);
}