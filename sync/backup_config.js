const { mkdirSync, renameSync, existsSync, rmdirSync, symlinkSync} = require('fs')
const { BACKUP_DIR, SCRIPTS_DIR, CONFIG_DIR, DIRECTORIES, DOTFILES_DIR, HOME, HOME_DIRECTORIES} = require("./constants");

const backup_config = () => {
    console.log('Setting up backup folders...')
    if (existsSync(BACKUP_DIR)) {
        rmdirSync(BACKUP_DIR, { recursive: true })
    }

    mkdirSync(BACKUP_DIR, { recursive: true })
    mkdirSync(BACKUP_DIR + '/.config', { recursive: true })
    mkdirSync(SCRIPTS_DIR, { recursive: true })

    console.log('Backing up config files...')
    DIRECTORIES.forEach((dir) => {
        const pathToBackup = `${CONFIG_DIR}/${dir}`
        if (!existsSync(pathToBackup)) {
            return
        }

        const backupPath = `${BACKUP_DIR}/.config/${dir}`;
        renameSync(pathToBackup, backupPath)
    })

    console.log('Backing up scripts...')
    renameSync(SCRIPTS_DIR, BACKUP_DIR + '/.scripts')

    console.log('Backing up home config...')
    HOME_DIRECTORIES.forEach((dir) => {
        const pathToBackup = `${HOME}/${dir}`
        if (!existsSync(pathToBackup)) {
            return
        }

        const backupPath = `${BACKUP_DIR}/${dir}`;
        renameSync(pathToBackup, backupPath)
    })
}

module.exports = {
    backup_config
}
