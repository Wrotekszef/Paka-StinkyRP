const Discord = require('discord.js');
const client = new Discord.Client();
const config = require('./config.json')
const fs = require('fs');
const root = GetResourcePath(GetCurrentResourceName());
const commandFiles = fs.readdirSync(`${root}/commands/`).filter(file => file.endsWith('.js'))
const ready = require('./handlers/ready.js')

client.commands = new Discord.Collection();
for(const file of commandFiles){
    const command = require(`${root}/commands/${file}`);
    client.commands.set(command.name, command);
}

client.on('message', msg => {
    if(!msg.content.startsWith(config.prefix)||msg.author.bot) return

    const args = msg.content.slice(config.prefix.length).split(/ +/);
    const command = args.shift().toLowerCase();

    
     if(command === 'revive'){
        client.commands.get('revive').execute(msg);
    }else if(command === 'skin'){
        client.commands.get('skin').execute(msg);
    }else if(command === 'pw'){
        client.commands.get('pw').execute(msg);
    }else if(command === 'giveitem'){
        client.commands.get('giveitem').execute(msg);
    }else if(command === 'setjob'){
        client.commands.get('setjob').execute(msg);
    }else if(command === 'zacmienie'){
        client.commands.get('zacmienie').execute(msg, client);
    }
});

client.login(config.token); // Token bota 


