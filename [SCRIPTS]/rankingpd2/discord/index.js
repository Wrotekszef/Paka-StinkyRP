//const DC_TOKEN = GetConvar('pd_token', 'null');
//const DC_APP_ID = GetConvar('pd_dc_app_id', 'null');
//const DC_LEADERBOARD_CHANNEL_ID = GetConvar(
//  'pd_dc_leaderboard_channel_id',
//  'null'
//);
const DC_TOKEN = GetConvar('frakcje_dc_token', 'null');
const DC_APP_ID = GetConvar('frakcje_dc_app_id', 'null');
const DC_LEADERBOARD_CHANNEL_ID = GetConvar(
  'frakcje3_dc_leaderboard_channel_id',
  'null'
);

if (DC_TOKEN !== 'null' && DC_APP_ID !== 'null') {
  const { Client, Collection, RichEmbed } = require('discord.js');
  const client = new Client();

  /* Main */

  client.on('ready', () => {
    console.log(`Bot logged in as ${client.user.tag}!`);

    refreshrankingpd2();

    setInterval(refreshrankingpd2, 60 * 10000 * 1);
  });

  const refreshrankingpd2 = () => {
    exports.oxmysql['query']('SELECT chlop, ile FROM rankingpdwyrok ORDER BY ile DESC', {},
    function(result) {
        if (result) {
          const embed = new RichEmbed()
            .setAuthor('ExileRP - Ranking System')
            .setTitle('Ranking TOP (WYROKI)')
            .setThumbnail('https://cdn.discordapp.com/attachments/929854149724602448/975386433688829962/exile.png')
            .setTimestamp()
            .setColor('#43db1d')
            .setFooter('ExileRP - Ranking System', 'https://cdn.discordapp.com/attachments/726860592916201502/989542622269935646/favicon.png');

          const players = [];
          for (const index in result) {
            if (index < 10 && (result[index].wins != 0 || result[index].loses != 0)) {
              players.push(
                `** ${players.length+1}.** ${result[index].chlop} - Wyroki:** ${
                  result[index].ile
                }**`
              );
            }
          }

          embed.setDescription(players.join('\n'));

          const channel = client.channels.get(DC_LEADERBOARD_CHANNEL_ID);
          if (channel) {
            channel.bulkDelete(5).then(() => {
              channel.send(embed);
            });
          }
        }
      }
    );
  };
  client.login(DC_TOKEN).catch((err) => {
    console.log(err);
  });
} else {
  console.log('Invalid convars.');
}
