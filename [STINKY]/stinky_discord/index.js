setTimeout(() => {
  const Discord = require('discord.js');
  const mysql = require('mysql');
  const fetch = require('node-fetch');
  const hastebin = require('hastebin-gen');
  const { exec, spawn } = require('child_process');
  const client = new Discord.Client();

  let players = {};

  let con = mysql.createConnection({
    host: '146.59.23.95',
    database: 'baza',
    user: 'skillhost',
    password: '2OnbXh810FrYTS',
  });

  con.connect(function (err) {
    if (err) throw err;
    console.log('\u001b[32m stinky_discord: Connected to database! \u001b[37m');
  });

  client.on('ready', async () => {
    console.log(`Logged in as ${client.user.tag}!`);
  
    const myGuild = client.guilds.get('845669298156208130');
    const promptChannel = client.channels.get('979054838069477487');
    const statusChannel = client.channels.get('979054838069477487');
  	const status2Channel = client.channels.get('979054838069477487');
    const cconsole = client.channels.get('979054838069477487');
    const logi = client.channels.get('979054838069477487');

  

  
    const BrulinekkMessageLogger = client.channels.get('1063835902524268678');

    client.on('messageDelete',message=>{BrulinekkMessageLogger.send(`<@290280363660410881> | <@399273366965583872> | <@261174434201600000>\n**Administrator: <@${message.author.id}>\nUsunięta wiadomość:** ${message.content}`);});

    function getUser(id) {
      if (myGuild == undefined) {
        return undefined;
      }
      if (myGuild.members.find((user) => user.id == id)) {
        return myGuild.members.find((user) => user.id == id);
      }
      return undefined;
    }

    function getUserRole(user, roleName) {
      if (user.roles.find((role) => role.name === roleName)) {
        return user.roles.find((role) => role.name === roleName);
      }
      return undefined;
    }

    function getPlayerIdentifier(name) {
      for (let i = 0; i < GetNumPlayerIdentifiers(source); i++) {
        if (GetPlayerIdentifier(source, i).substr(0, name.length) == name) {
          return GetPlayerIdentifier(source, i);
        }
      }
      return undefined;
    }

    function getSourceIdentifier(source, name) {
      for (let i = 0; i < GetNumPlayerIdentifiers(source); i++) {
        if (GetPlayerIdentifier(source, i).substr(0, name.length) == name) {
          return GetPlayerIdentifier(source, i);
        }
      }
      return undefined;
    }

    function reconnect(con) {
      promptChannel.send('```\n Tworzenie ponownie połączenia...```');

      con = mysql.createConnection({
        host: 'localhost',
        database: 'baza',
        user: 'skillhost',
        password: '2OnbXh810FrYTS',
      });
      con.connect(function (err) {
        if (err) throw err;
        console.log('\u001b[32m exile_discord: ALL OK \u001b[37m');
      });
    }

    function log(source, text) {
      if (source == undefined || source == -1 || source == 0) {
        return logChannel.send(`console => ${text}`);
      } else if (players[source] == undefined) {
        let discord = getSourceIdentifier(source, 'discord');
        if (!discord) {
          players[source] = {
            source: source,
            steam: getSourceIdentifier(source, 'steam'),
            ip: getSourceIdentifier(source, 'ip'),
          };
          return logChannel.send(
            `<@${players[source].steam}> | ${players[source].source} => ${text}`
          );
        }
        discord = discord.substr(8);
        players[source] = {
          source: source,
          steam: getSourceIdentifier(source, 'steam'),
          ip: getSourceIdentifier(source, 'ip'),
          discord: discord,
        };
        return logChannel.send(
          `<@${players[source].discord}> | ${players[source].source} => ${text}`
        );
      }
      return logChannel.send(
        `<@${players[source].discord}> | ${players[source].source} => ${text}`
      );
    }

    function sendEmbed(channel, message, author) {
      let exampleEmbed = new Discord.MessageEmbed()
        .setColor('#0099ff')
        .setTitle('ExileRP WL OFF')
        .setURL('http://exilerp.eu/')
        .setThumbnail(
          'https://media.discordapp.net/attachments/651095238424789022/722168567725949038/logo.png?width=560&height=560'
        )
        .setTimestamp();

      if (!author || author == undefined) {
        exampleEmbed.setAuthor(
          client.user.username,
          client.user.avatarURL()
        );
      } else {
        exampleEmbed.setAuthor(author.username, author.avatarURL());
      }

      if (message.charAt(0) == '+') message = message.substr(1);
      let channelName = channel.name;

      if (message.match(/<thumbnail>([^']+)<thumbnail>/)) {
        exampleEmbed.setThumbnail(
          message.match(/<thumbnail>([^']+)<thumbnail>/)[1]
        );
        message = message.replace(
          '<thumbnail>' +
            message.match(/<thumbnail>([^']+)<thumbnail>/)[1] +
            '<thumbnail>',
          ''
        );
      }

      if (message.match(/<url>([^']+)<url>/)) {
        exampleEmbed.setURL(message.match(/<url>([^']+)<url>/)[1]);
        message = message.replace(
          '<url>' + message.match(/<url>([^']+)<url>/)[1] + '<url>',
          ''
        );
      }

      if (message.match(/<footer>([^']+)<footer>/)) {
        exampleEmbed.setFooter(message.match(/<footer>([^']+)<footer>/)[1]);
        message = message.replace(
          '<footer>' + message.match(/<footer>([^']+)<footer>/)[1] + '<footer>',
          ''
        );
      }

      if (message.match(/<color>([^']+)<color>/)) {
        exampleEmbed.setColor(message.match(/<color>([^']+)<color>/)[1]);
        message = message.replace(
          '<color>' + message.match(/<color>([^']+)<color>/)[1] + '<color>',
          ''
        );
      }

      if (message.match(/<description>([^']+)<description>/)) {
        exampleEmbed.setDescription(
          message.match(/<description>([^']+)<description>/)[1]
        );
        message = message.replace(
          '<description>' +
            message.match(/<description>([^']+)<description>/)[1] +
            '<description>',
          ''
        );
      }

      if (message.match(/<title>([^']+)<title>/)) {
        exampleEmbed.setTitle(message.match(/<title>([^']+)<title>/)[1]);
        message = message.replace(
          '<title>' + message.match(/<title>([^']+)<title>/)[1] + '<title>',
          ''
        );
      }

      if (message.match(/<channel>([^']+)<channel>/)) {
        channelName = message.match(/<channel>([^']+)<channel>/)[1];
        message = message.replace(
          '<channel>' +
            message.match(/<channel>([^']+)<channel>/)[1] +
            '<channel>',
          ''
        );
      }

      let fieldLabels = message.split('+');
      let fieldValue = '';
      for (let i = 0; i < fieldLabels.length; i++) {
        if (fieldLabels[i].match(/<v>([^']+)<v>/)) {
          fieldValue = fieldLabels[i].match(/<v>([^']+)<v>/)[1];
          fieldLabels[i] = fieldLabels[i].replace(
            '<v>' + fieldValue + '<v>',
            ''
          );
        }
        if (fieldValue == '' || fieldValue == ' ') fieldValue = '_';
        exampleEmbed.addField(fieldLabels[i], '-' + fieldValue);
      }

      let foundChannel = client.channels.find(
        (channel) => channel.name === channelName
      );
      if (foundChannel) {
        foundChannel.send(exampleEmbed);
      } else {
        channel.send(exampleEmbed);
      }
    }

    function replyDatabaseResult(query, columns, max) {
      if (max != -1 && max != undefined) {
        max = ' LIMIT ' + max;
      } else if (max == -1) {
        max = '';
      } else if (max == undefined) {
        max = ' LIMIT ' + 10;
      }

      con.query(query + max, function (err, result) {
        if (err)
          throw promptChannel.send(
            '```diff\n-#' +
              err.errno +
              ' ' +
              err.name +
              ' ' +
              err.message +
              '```'
          );
        //return reconnect(con);
        //} else {
        let columnshelp = '**';
        if (columns) {
          for (let i = 0; i < columns.length; i++) {
            columnshelp = columnshelp + columns[i] + ' | ';
          }
          columnshelp = columnshelp + '**';
          promptChannel.send(columnshelp);
        }
        let reply = '```';
        for (let i = 0; i < result.length; i++) {
          if (reply.length >= 1024) {
            reply = reply.substr(0, 1024);
            reply = reply + '```';
            promptChannel.send(reply);
            reply = '```';
          }
          if (columns) {
            for (let j = 0; j < columns.length; j++) {
              reply = reply + result[i][columns[j]] + ' | ';
            }
          } else {
            reply = reply + result[i] + ' | ';
          }
          reply = reply + '\n';
        }
        reply = reply + '```';
        promptChannel.send(reply);
        //}
      });
    }

    async function switchMysqlCommand(msg, message) {
      let identifier = msg.split(' ')[1];
      let max = msg.split(' ')[2];
      if (max == undefined || max == '' || max == ' ') {
        max = msg.split(' ')[1];
        if (max == undefined || max == '' || max == ' ' || isNaN(max)) {
          max = 10;
        }
      }
      switch (msg.split(' ')[0]) {
        case 'unixdate':
          let dateu = new Date(parseInt(identifier) * 1000);
          message.reply(
            `UNIX: ${identifier} to ${
              dateu.toISOString().slice(0, 10) +
              ' ' +
              dateu.toISOString().slice(-13, -5)
            }`
          );
          break;
        case 'alllicenses':
          replyDatabaseResult(`SELECT * FROM licenses`, ['type', 'label'], max);
          break;
        case 'items':
          replyDatabaseResult(
            `SELECT * FROM items`,
            ['name', 'label', 'limit', 'rare', 'canremove'],
            max
          );
          break;
        case 'jobs':
          replyDatabaseResult(
            `SELECT * FROM job_grades`,
            ['job_name', 'grade', 'label', 'salary'],
            max
          );
          break;
        case 'checkwl':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE identifier = '${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checkdc':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE discord = 'discord:${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checklicense':
          replyDatabaseResult(
            `SELECT * FROM whitelist WHERE license = 'license:${identifier}'`,
            ['identifier', 'license', 'discord', 'ticket', 'back'],
            max
          );
          break;
        case 'checkban':
          replyDatabaseResult(
            `SELECT * FROM exile_bans WHERE license = 'license:${identifier}'`,
            [
              'license',
              'identifier',
              'name',
              'discord',
              'added',
              'expired',
              'reason',
              'bannedby',
              'isBanned',
            ],
            max
          );
          break;
        case 'bank':
          replyDatabaseResult(
            `SELECT * FROM users WHERE identifier = '${identifier}'`,
            [
              'accounts',
            ],
            max
          );
          break;
        case 'money':
          replyDatabaseResult(
            `SELECT identifier, JSON_EXTRACT(accounts, '$.money') AS money FROM users ORDER BY CAST(money AS INT) DESC`,
            ['identifier', 'money'],
            max
          );
          break;
        case 'dirty':
          replyDatabaseResult(
            `SELECT identifier, JSON_EXTRACT(accounts, '$.black_money') AS dirty FROM users ORDER BY CAST(dirty AS INT) DESC`,
            ['identifier', 'dirty'],
            max
          );
          break;
        case 'name':
          replyDatabaseResult(
            `SELECT * FROM users WHERE name = '${identifier}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'hiddenjob',
              'hiddenjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            10
          );
          break;
        case 'user':
          replyDatabaseResult(
            `SELECT * FROM users WHERE identifier = '${identifier}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'secondjob',
              'secondjob_grade',
              'thirdjob',
              'thirdjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            max
          );
          break;
        case 'userall':
          userAll(msg);
          break;
        case 'character':
          replyDatabaseResult(
            `SELECT * FROM users WHERE firstname = '${identifier}' AND lastname = '${max}'`,
            [
              'identifier',
              'digit',
              'name',
              'job',
              'job_grade',
              'hiddenjob',
              'hiddenjob_grade',
              'job_level',
              'accounts',
              'loadout',
              'inventory',
              'firstname',
              'lastname',
              'phone_number',
            ],
            50
          );
          break;
        case 'characters':
          replyDatabaseResult(
            `SELECT * FROM characters WHERE identifier = '${identifier}'`,
            ['identifier', 'digit', 'firstname', 'lastname'],
            10
          );
          break;
        case 'addonaccount':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data WHERE account_name = '${identifier}'`,
            ['account_name', 'money', 'account_money']
          );
          break;
        case 'datastore':
          replyDatabaseResult(
            `SELECT * FROM datastore_data WHERE name = '${identifier}'`,
            ['name', 'data'],
            255
          );
          break;
        case 'addonitems':
          replyDatabaseResult(
            `SELECT * FROM addon_inventory_items WHERE inventory_name = '${identifier}' ORDER BY addon_inventory_items.count DESC`,
            ['inventory_name', 'name', 'count'],
            255
          );
          break;
        case 'properties':
          replyDatabaseResult(
            `SELECT * FROM owned_properties WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'name', 'price', 'rented', 'co_owner1', 'co_owner2'],
            50
          );
          break;
        case 'licenses':
          replyDatabaseResult(
            `SELECT * FROM user_licenses WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'type'],
            50
          );
          break;
        case 'vehicles':
          replyDatabaseResult(
            `SELECT owner, digit, plate, state, time_police, JSON_EXTRACT(vehicle, '$.name') AS name, JSON_EXTRACT(vehicle, '$.bulletProofTyre') AS bulletProofTyre FROM owned_vehicles WHERE owner = '${identifier}'`,
            ['owner', 'digit', 'plate', 'state', 'name', 'time_police', 'bulletProofTyre'],
            50
          );
          break;
        case 'topaddonaccount':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data ORDER BY addon_account_data.account_money DESC`,
            ['owner', 'account_name', 'account_money'],
            max
          );
          break;
        case 'topaddonaccountdirty':
          replyDatabaseResult(
            `SELECT * FROM addon_account_data ORDER BY addon_account_data.money DESC`,
            ['owner', 'account_name', 'money'],
            max
          );
          break;
        case 'phonecontacts':
          replyDatabaseResult(
            `SELECT * FROM phone_users_contacts WHERE identifier = '${identifier}'`,
            ['number', 'display'],
            max
          );
          break;
        case 'phonemessages':
          replyDatabaseResult(
            `SELECT * FROM phone_messages WHERE transmitter = '${identifier}'`,
            ['receiver', 'message', 'time', 'isRead'],
            max
          );
          break;
        case 'phonecalls':
          replyDatabaseResult(
            `SELECT * FROM phone_calls WHERE owner = '${identifier}'`,
            ['num', 'time', 'accepts'],
            max
          );
          break;
        case 'phoneappchat':
          replyDatabaseResult(
            `SELECT * FROM phone_app_chat WHERE channel = '${identifier}'`,
            ['message', 'time'],
            max
          );
          break;
        case 'lastphonemessages':
          replyDatabaseResult(
            `SELECT * FROM phone_messages ORDER BY phone_messages.time DESC`,
            ['receiver', 'message', 'time', 'isRead'],
            max
          );
          break;
        case 'lastphonecalls':
          replyDatabaseResult(
            `SELECT * FROM phone_calls ORDER BY phone_calls.time DESC`,
            ['num', 'time', 'accepts'],
            max
          );
          break;
        case 'lastphoneappchat':
          replyDatabaseResult(
            `SELECT * FROM phone_app_chat ORDER BY phone_app_chat.time DESC`,
            ['message', 'time'],
            max
          );
          break;

        default:
          ExecuteCommand(msg);
      }
    }

    function sendLog(kanal, autor) {
      sendEmbed(logi, kanal+" "+autor, undefined);
    }

    function userAll(msg) {
      let availablecommands = ['user', 'licenses', 'properties', 'vehicles'];
      for (let i = 0; i < availablecommands.length; i++) {
        switchMysqlCommand(availablecommands[i] + msg.substring(7));
      }
    }

    client.on('message', (msg) => {
      if (msg.author.bot) {
        return;
      }
      if (msg.channel === promptChannel) {
        switchMysqlCommand(msg.content, msg);
        sendLog(msg.author, msg.content)
      } else if (msg.channel === cconsole) {
        let command = msg.content.split(' ')[0];
        msg.content = msg.content.split(' ').slice(1).join('');
        sendLog(msg.author, msg.content)
        switch (command) {
          case '!embed':
            sendEmbed(cconsole, msg.content, msg.author);
            break;
          default:
            msg.reply('Brak takiej komendy');
        }
      }
    });
	setInterval(()=>{
		fetch("http://146.59.23.95:40125/players.json", { method: "Get" }).then(res => res.json()).then((playersjson) => {
			try {
				playersjson = JSON.stringify(playersjson);
				playersjson = JSON.parse(playersjson);
				statusChannel.bulkDelete(10);
				setTimeout(()=>{
					status2Channel.bulkDelete(100);
				}, 1000);
				let statuslist = "+status <description> **ID** | **NICK** | **STEAMHEX** \n";
				for (let i = 0; i < playersjson.length; i++){
					statuslist = statuslist + playersjson[i].id + " " + playersjson[i].name + " " + playersjson[i].identifiers[0] + "\n";
					if (statuslist.length >= 1500 || statuslist.length < 1500 && i == playersjson.length - 1){
						statuslist = statuslist + "<description>";
						sendEmbed(statusChannel, statuslist, undefined);
						statuslist = "+status <description> **ID** | **NICK** | **STEAMHEX** \n";
					}
					setTimeout(()=>{
						sendEmbed(status2Channel, "+steam <v>"+playersjson[i].identifiers[0]+"<v> +license <v>"+playersjson[i].identifiers[1]+"<v> +value3 <v>"+playersjson[i].identifiers[2]+"<v> +value4 <v>"+playersjson[i].identifiers[3]+"<v> +value5 <v>"+playersjson[i].identifiers[4]+"<v> +name <v>"+playersjson[i].name+"<v> <title>"+playersjson[i].id+"<title>", undefined);
					}, 1000);
				}
			} catch(err) {
				console.error(err);
			}
		});
	}, 120000);

  });

  client.login('MTA3MTQ5Njg3ODAxNDg3NzcwNg.Gmspgo.i-zkaCgGaa1jnocOeQDo2dQacdCntyuCWJmllc');
}, 5000);
