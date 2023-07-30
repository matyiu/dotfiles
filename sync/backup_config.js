const { mkdirSync, renameSync, existsSync, rmdirSync } = require('fs')
const { BACKUP_DIR, SCRIPTS_DIR, CONFIG_DIR, DIRECTORIES, DOTFILES_DIR} = require("./constants");

const backup_config = () => {
    console.log('Setting up backup folders...')
    if (existsSync(BACKUP_DIR)) {
        rmdirSync(BACKUP_DIR, { recursive: true })
    }

    mkdirSync(BACKUP_DIR, { recursive: true })
    mkdirSync(BACKUP_DIR + '/.scripts', { recursive: true })
    mkdirSync(BACKUP_DIR + '/.config', { recursive: true })
    mkdirSync(SCRIPTS_DIR, { recursive: true })

    console.log('Backing up config files...')
    DIRECTORIES.forEach((dir) => {
        const pathToBackup = `${CONFIG_DIR}/${dir}`
        if (!existsSync(pathToBackup)) {
            return
        }

        const backupPath = `${BACKUP_DIR}/${dir}`;
        renameSync(pathToBackup, backupPath)
    })

    console.log('Backing up scripts...')
    renameSync(SCRIPTS_DIR, BACKUP_DIR + '/.scripts')
}

module.exports = {
    backup_config
}
