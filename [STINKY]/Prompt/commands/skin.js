const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'skin',
    description: 'Komenda na skina', //Optional
    execute(msg) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	const reason = argue.slice(1).join(' ');
	  	setImmediate(() => {
	  		for(const rolePermission of config.roleReviveIDList){
				if(msg.member.roles.has(rolePermission)){
					if(GetPlayerName(reason) === null){
						const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('SKIN 🧍' , '', '')
						.setDescription('Nie znaleziono gracza o takim ID. **Spróbuj ponownie!** \n\nPoprawne użycie: **' + config.prefix + 'skin <id>**')
						.setTimestamp()
						.setThumbnail("https://media.discordapp.net/attachments/766026362594656286/823116148756316180/d8a77429263b4b9cda61cc2b1917685f.jpg?width=384&height=682")
						.setFooter(config.serverNameFooter, config.serverIconLink);
						msg.reply(announcmentEmbed);
					}else{
						const announcmentEmbed = new Discord.RichEmbed()
							.setColor(config.cssEmbedMessageColor)
							.setAuthor('SKIN 🧍' , '', '')
							.setDescription('\nPomyślnie nadano skina graczu o id: **' + reason + '**')
							.setTimestamp()
							.setThumbnail("https://media.discordapp.net/attachments/766026362594656286/823116148756316180/d8a77429263b4b9cda61cc2b1917685f.jpg?width=384&height=682")
							.setFooter(config.serverNameFooter, config.serverIconLink);
							msg.reply(announcmentEmbed);
							emitNet('esx_skin:openSaveableMenu', reason);
					}
				}
			}
		});
    }
}
