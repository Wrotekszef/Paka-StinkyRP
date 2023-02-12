const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'giveitem',
    description: 'Wysyłanie prywatnch wiadomosci!', //Optional
    execute(msg) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	  	setImmediate(() => {
	  		for(const rolePermission of config.roleGiveItemIDList){
				if(msg.member.roles.has(rolePermission)){
					if( argue.length < 2 || GetPlayerName(argue[1]) === null) {
						const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('GIVEITEM COMMAND 💼' , '', '')
						.setDescription('Nie znaleziono gracza o takim ID. **Spróbuj ponownie!** \n\nPoprawne użycie: **' + config.prefix + 'giveitem <id> <nazwa_przedmiotu> <ilosc_przedmiotu>**')
						.setTimestamp()
						.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);
						msg.reply(announcmentEmbed);
					}else{
						const announcmentEmbed = new Discord.RichEmbed()
							.setColor(config.cssEmbedMessageColor)
							.setAuthor('GIVEITEM COMMAND 💼' , '', '')
							.setDescription('\nNadany przedmiot: **' + argue[2] + '**\nW ilosci:** x' + argue[3] + "**\nID gracza któremu zostały dodane przedmioty: **" + argue[1] + "**")
							.setTimestamp()
							.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
							.setFooter(config.serverNameFooter, config.serverIconLink);
							msg.reply(announcmentEmbed);
						emit('yesrptrigerusprompcik:sendMessage', argue[1], "Administrator ^0" + msg.author.tag + " oddał ci przedmiot o nazwie ^0" + argue[2] + " w ilosci ^0x" + argue[3]);
						emit('yesrptrigerusprompcik:addItem', argue[1], argue[2], argue[3])
					}
				}
			}
		});
		
    }
}
