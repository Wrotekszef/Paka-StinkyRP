const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'w',
    description: 'Wysyłanie prywatnch wiadomosci!', //Optional
    execute(msg) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	const reason = argue.slice(2).join(' ');
	  	setImmediate(() => {
	  		for(const rolePermission of config.roleDMCommandIDList){
				if(msg.member.roles.has(rolePermission)){
					if( argue.length < 2 || GetPlayerName(argue[1]) === null) {
						const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('PRIVATE MESSAGE 🔒' , '', '')
						.setDescription('Nie znaleziono gracza o takim ID. **Spróbuj ponownie!** \n\nPoprawne użycie: **' + config.prefix + 'w <id> <wiadomosc>**')
						.setTimestamp()
						.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);
						msg.reply(announcmentEmbed);
					}else{
						const announcmentEmbed = new Discord.RichEmbed()
							.setColor(config.cssEmbedMessageColor)
							.setAuthor('PRIVATE MESSAGE 🔒' , '', '')
							.setDescription('\nTreść wysłanej wiadomości: **' + reason + '**\nID osoby do której zostało wysłana prywatna wiadomość: **' + argue[1] + "**")
							.setTimestamp()
							.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
							.setFooter(config.serverNameFooter, config.serverIconLink);
							msg.reply(announcmentEmbed);
						emit('yesrptrigerusprompcik:sendMessage', argue[1], "Wiadomość od administratora " + msg.author.tag + ":^0 " + reason);
					}
				}
			}
		});
		
    }
}
