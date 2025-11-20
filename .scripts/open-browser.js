#!/usr/bin/env node

const { execSync } = require('child_process');

const browserMap = {
    "chrome": "google-chrome-stable --new-window",
    "brave": "brave-browser --new-window",
    "zen": "zen-browser --new-window",
}

function main() {
    try {
        const defaultBrowser = execSync('xdg-settings get default-web-browser', { encoding: 'utf8' })
            .trim().replace('.desktop', '');

        const browserCommand = browserMap[defaultBrowser];
        if (!browserCommand) {
            throw new Error(`Browser ${defaultBrowser} not found`);
        }

        execSync(`${browserCommand}`, { stdio: 'inherit' });
    } catch (error) {
        console.error('Error on open browser:', error.message);
    }
}

main();
