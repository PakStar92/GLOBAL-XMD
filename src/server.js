const express = require('express');
const { createServer } = require('http');
const fetch = require('node-fetch');
const path = require('path');
const app = express();
const server = createServer(app);
const PORT = process.env.PORT || process.env.SERVER_PORT || 3000;

// Correct path to package.json
const packageInfo = require(path.join(__dirname, '..', 'package.json'));

app.all('/', (req, res) => {
	if (process.send) {
		process.send('uptime');
		process.once('message', (uptime) => {
			res.json({
				bot_name: packageInfo.name,
				version: packageInfo.version,
				author: packageInfo.author,
				description: packageInfo.description,
				uptime: `${Math.floor(uptime)} seconds`
			});
		});
	} else {
		console.warn('Process not running with IPC. Cannot send/receive uptime info.');
		res.json({ error: 'Process not running with IPC' });
	}
});

app.all('/process', (req, res) => {
	const { send } = req.query;
	if (!send) return res.status(400).json({ error: 'Missing send query' });

	if (process.send) {
		process.send(send);
		res.json({ status: 'Send', data: send });
	} else {
		console.warn('Process not running with IPC. Cannot send message.');
		res.json({ error: 'Process not running with IPC' });
	}
});

app.all('/chat', (req, res) => {
	const { message, to } = req.query;
	if (!message || !to) {
		return res.status(400).json({ error: 'Missing message or to query' });
	}
	// Placeholder logic, can be extended later
	res.status(200).json({ status: true, message: 'Chat simulation not started yet' });
});

// KeepAlive function
function keepAlive() {
	const url = process.env.APP_URL;
	if (!url) {
		console.log('⚠️ No APP_URL provided, skipping keepAlive...');
		return;
	}

	if (/(\/\/|\.)undefined\./.test(url)) {
		console.log('⚠️ Invalid APP_URL format, skipping keepAlive...');
		return;
	}

	setInterval(() => {
		fetch(url)
			.then(res => console.log(`✅ Pinged ${url}: ${res.status}`))
			.catch(err => console.error(`❌ KeepAlive error: ${err.message}`));
	}, 5 * 60 * 1000); // 5 minutes
}

// Start keepAlive pinger
keepAlive();

module.exports = { app, server, PORT };
