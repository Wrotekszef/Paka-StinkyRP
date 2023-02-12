const DC_TOKEN = GetConvar('crimeGANG_dc_token', 'null');
const DC_APP_ID = GetConvar('crimeGANG_dc_app_id', 'null');
const DC_LEADERBOARD_CHANNEL_ID = GetConvar(
  'crimeGANG_dc_leaderboard_channel_id',
  'null'
);

if (DC_TOKEN !== 'null' && DC_APP_ID !== 'null') {
  const { Client, Collection, RichEmbed } = require('discord.js');
  const client = new Client();

  /* Main */

  client.on('ready', () => {
    console.log(`Bot logged in as ${client.user.tag}!`);

    RefreshTopByKDGANG();
    RefreshTopByStrefyGANG();
    RefreshTopByNapadGANG();

    setInterval(RefreshTopByKDGANG, 60 * 10000 * 1);
    setInterval(RefreshTopByStrefyGANG, 60 * 10000 * 1);
    setInterval(RefreshTopByNapadGANG, 60 * 10000 * 1);
  });

  /* Leaderboard */
  const RefreshTopByKDGANG = () => {
    exports.oxmysql['query']('SELECT org_label, wins, loses, wins/(wins+loses), (wins+loses) AS razem FROM bitkigang ORDER BY razem DESC', {},
    function(result) {
        if (result) {
          const embed = new RichEmbed()
            .setAuthor('ExileRP - Ranking System')
            .setTitle('Ranking TOP 5 (BITKI)')
            .setThumbnail('https://cdn.discordapp.com/attachments/929854149724602448/975386433688829962/exile.png')
            .setTimestamp()
            .setColor('#43db1d')
            .setFooter('ExileRP - Ranking System', 'https://cdn.discordapp.com/attachments/726860592916201502/989542622269935646/favicon.png');

          const players = [];
          for (const index in result) {
            if (index < 10 && (result[index].wins != 0 || result[index].loses != 0)) {
              players.push(
                `** ${players.length+1}.** ${result[index].org_label} - Wygrane:** ${
                  result[index].wins
                } **, Przegrane: **${result[index].loses}** WR: **${
                  (
                    result[index].wins /
                    (result[index].wins + result[index].loses)
                  ).toFixed(2) * 100
                }%**, RAZEM: **${
                  (
                    (result[index].wins + result[index].loses)
                  )
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

  const RefreshTopByStrefyGANG = () => {
    exports.oxmysql['query']('SELECT org_label, wins, loses FROM strefy_gangi ORDER BY wins DESC', {},
    function(result) {
        if (result) {
          const embed = new RichEmbed()
            .setAuthor('ExileRP - Ranking System')
            .setTitle('Ranking TOP 5 (STREFY)')
            .setThumbnail('https://cdn.discordapp.com/attachments/929854149724602448/975386433688829962/exile.png')
            .setTimestamp()
            .setColor('#43db1d')
            .setFooter('ExileRP - Ranking System', 'https://cdn.discordapp.com/attachments/726860592916201502/989542622269935646/favicon.png');

          const players = [];
          for (const index in result) {
            if (index < 5 && result[index].wins != 0) {
              players.push(
                `** ${players.length+1}.** ${result[index].org_label} - Ilość: **${
                  result[index].wins
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

  const RefreshTopByNapadGANG = () => {
    exports.oxmysql['query']('SELECT org_label, wins, loses FROM napady_gangi ORDER BY wins DESC', {},
    function(result) {
        if (result) {
          const embed = new RichEmbed()
            .setAuthor('ExileRP - Ranking System')
            .setTitle('Ranking TOP 5 (NAPADY)')
            .setThumbnail('https://cdn.discordapp.com/attachments/929854149724602448/975386433688829962/exile.png')
            .setTimestamp()
            .setColor('#43db1d')
            .setFooter('ExileRP - Ranking System', 'https://cdn.discordapp.com/attachments/726860592916201502/989542622269935646/favicon.png');

          const players = [];
          for (const index in result) {
            if (index < 5 && result[index].wins != 0) {
              players.push(
                `** ${players.length+1}.** ${result[index].org_label} - Ilość: **${
                  result[index].wins
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