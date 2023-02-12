const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'revive',
    description: 'Komenda na revive', //Optional
    execute(msg) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	const reason = argue.slice(1).join(' ');
	  	setImmediate(() => {
	  		for(const rolePermission of config.roleReviveIDList){
				if(msg.member.roles.has(rolePermission)){
					if(GetPlayerName(reason) === null){
						const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('REVIVE COMMAND 🚑' , '', '')
						.setDescription('Nie znaleziono gracza o takim ID. **Spróbuj ponownie!** \n\nPoprawne użycie: **' + config.prefix + 'revive <id>**')
						.setTimestamp()
						.setThumbnail("https://i.pinimg.com/originals/99/4a/e4/994ae44a70b1239bd16b99642b7e883e.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);
						msg.reply(announcmentEmbed);
					}else{
						const announcmentEmbed = new Discord.RichEmbed()
							.setColor(config.cssEmbedMessageColor)
							.setAuthor('REVIVE COMMAND 🚑' , '', '')
							.setDescription('\nPomyślnie nadano revive graczu o id: **' + reason + '**')
							.setTimestamp()
							.setThumbnail("https://i.pinimg.com/originals/99/4a/e4/994ae44a70b1239bd16b99642b7e883e.gif")
							.setFooter(config.serverNameFooter, config.serverIconLink);
							msg.reply(announcmentEmbed);
							emitNet('hypex_ambulancejob:hypexrevive', reason);
					}
				}
			}
		});
		
    }
}
