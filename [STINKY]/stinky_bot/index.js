const Discord = require('discord.js')

const client = new Discord.Client({
    intents: ["GUILDS", "GUILD_MEMBERS", "GUILD_BANS", "GUILD_EMOJIS_AND_STICKERS", "GUILD_INTEGRATIONS", "GUILD_WEBHOOKS", "GUILD_INVITES", "GUILD_VOICE_STATES", "GUILD_PRESENCES", "GUILD_MESSAGES", "GUILD_MESSAGE_REACTIONS", "GUILD_MESSAGE_TYPING", "DIRECT_MESSAGES", "DIRECT_MESSAGE_REACTIONS", "DIRECT_MESSAGE_TYPING"],
    partials: ["USER", "REACTION", "MESSAGE", "GUILD_SCHEDULED_EVENT", "GUILD_MEMBER", "CHANNEL"]
})

const FiveM = require("fivem")
const srv = new FiveM.Server('51.75.50.144:30120')

client.once('ready', () => {
    console.log(`Bot uruchomil sie poprawnie!`)

    setInterval(async () => {
        srv.getPlayers().then(data => {
            console.log(data)
            client.user.setActivity(`StinkyRP.eu: ${data}/64`, {type: 'PLAYING'})
        }).catch(function(err) {
            client.user.setActivity(`StinkyRP: OFFLINE`, {type: 'PLAYING'})
        })
    }, 600);
})

client.login("MTA3MTQ5Njg3ODAxNDg3NzcwNg.Gmspgo.i-zkaCgGaa1jnocOeQDo2dQacdCntyuCWJmllc")


