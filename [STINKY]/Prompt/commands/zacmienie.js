const config = require("../config.json");
const Discord = require("discord.js");

module.exports = {
    name: 'zacmienie',
    description: 'Komenda na ogłoszenie', //Optional
    execute(msg, client) {
	const argue = msg.content.slice(config.prefix.length).trim().split(' ');
	const godzina = argue.slice(1).join(' ');
		if (argue.length < 1) {
			const announcmentEmbed = new Discord.RichEmbed()
				.setColor('#0213ff')
				.setAuthor('ZACMIENIE COMMAND 📢', '', '')
				.setDescription("Poprawne użycie: ``" + config.prefix + "zacmienie <godzina zamienia>")
				.setTimestamp()
				.setThumbnail("https://cliply.co/wp-content/uploads/2019/09/371909470_MEGAPHONE_400px.gif")
				.setFooter('YesRP', 'https://cdn.discordapp.com/icons/734220241898438727/5ea515f2e4839effc57c696ae42f8ef8.webp?size=128');
			msg.reply(announcmentEmbed);
		}

	  	setImmediate(() => {
			for(const rolePermission of config.roleZacmienieIDList){
				if(msg.member.roles.has(rolePermission)){

					const announcmentEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('ZACMIENIE COMMAND 🌘', '', '')
						.setDescription("Zapowiedziano zaćmienie o godzinie: **" + godzina + "**\n\nIlość osób które zobaczyły informacje o zacmieniu: **" + GetNumPlayerIndices() + "**")
						.setTimestamp()
						.setThumbnail("https://cliply.co/wp-content/uploads/2019/09/371909470_MEGAPHONE_400px.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);
                    msg.reply(announcmentEmbed);
                    
					const zacmienieEmbed = new Discord.RichEmbed()
						.setColor(config.cssEmbedMessageColor)
						.setAuthor('ZACMIENIE 🌘', '', '')
						.setDescription("Zapowiedziano zaćmienie o godzinie: **" + godzina + "**\n\nProsimy wszystkich obywateli o **schowanie się** w swoim mieszkaniu/domu do czasu końca zacmienia")
						.setTimestamp()
						.setThumbnail("https://cliply.co/wp-content/uploads/2019/09/371909470_MEGAPHONE_400px.gif")
						.setFooter(config.serverNameFooter, config.serverIconLink);

                    client.channels.get(config.zacmienieChannelID).send(zacmienieEmbed);


					emitNet('chat:addMessage', -1, {
						args: [ "^5🌘 Zapowiedziano zaćmienie wyspy o godzinie: ^0" + godzina + " ^1Prosimy o schowanie się w bezpiecznym miejscu!"]

					});
				}
			}
		});
		  
    }
}
