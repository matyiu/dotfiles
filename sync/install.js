const { exec } = require('child_process')

const { PACKAGES } = require("./constants");

const exec_command = (command) => {
    return new Promise((resolve, reject) => {
        const process = exec(command)

        process.stdout.on('data', (data) => {
            console.log(data.toString())
        })

        process.stderr.on('data', (data) => {
            console.error(data.toString())
        })

        process.on('close', (code) => {
            if (code === 0) {
                console.log('Successfull instalation.')
                resolve()
            } else {
                reject(new Error(`Command exited with code ${code}`))
            }
        })
    })
}

const install_packages = async () => {
    const command = `sudo pacman -S --noconfirm ${PACKAGES.join(' ')}`;

    try {
        await exec_command(command);
        console.log('Packages installed successfully.');
    } catch (error) {
        console.error(`Error installing packages: ${error.message}`);
    }
}

module.exports = {
    install_packages
}