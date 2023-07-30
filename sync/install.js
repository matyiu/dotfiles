const { promisify } = require('util');
const { exec } = require('child_process')

const { PACKAGES } = require("./constants");

const install_packages = async () => {
    const promisified_exec = promisify(exec)

    const command = `sudo pacman -Sy ${PACKAGES.join(' ')}`;

    try {
        await promisified_exec(command);
        console.log('Packages installed successfully.');
    } catch (error) {
        console.error(`Error installing packages: ${error.message}`);
    }
}

module.exports = {
    install_packages
}