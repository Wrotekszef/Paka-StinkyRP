const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'setjob',
    description: 'Wysyłanie prywatnch wiadomosci!', //Optional
    execute(msg) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	  	setImmediate(() => {
	  		for(const rolePermission of config.roleSetJobIDList){
				if(msg.member.roles.has(rolePermission)){
					if( argue.length < 2 || GetPlayerName(argue[1]) === null) {
						const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('SETJOB COMMAND 💼' , '', '')
						.setDescription('Nie znaleziono gracza o takim ID. **Spróbuj ponownie!** \n\nPoprawne użycie: **' + config.prefix + 'giveitem <id> <nazwa_pracy> <grade_pracy>**')
						.setTimestamp()
						.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);
						msg.reply(announcmentEmbed);
					}else{
						const announcmentEmbed = new Discord.RichEmbed()
							.setColor(config.cssEmbedMessageColor)
							.setAuthor('SETJOB COMMAND 💼' , '', '')
							.setDescription('\nNadana praca: **' + argue[2] + '**\nStopien pracy:** ' + argue[3] + "**\nID gracza któremu została nadana praca: **" + argue[1] + "**")
							.setTimestamp()
							.setThumbnail("https://i.pinimg.com/originals/50/05/db/5005dbccb59bc9929274c043b848eb84.gif")
                            .setFooter(config.serverNameFooter, config.serverIconLink);
                            msg.reply(announcmentEmbed);
						emit('yesrptrigerusprompcik:sendMessage', argue[1], "Administrator ^0" + msg.author.tag + " nadał ci prace o nazwie ^0" + argue[2] + " o stopniu ^0" + argue[3]);
						emit('yesrptrigerusprompcik:setJob', argue[1], argue[2], argue[3])
					}
				}
			}
		});
		
    }
}
