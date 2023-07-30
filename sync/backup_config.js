const { mkdirSync, renameSync, existsSync, rmdirSync, symlinkSync} = require('fs')
const { BACKUP_DIR, SCRIPTS_DIR, CONFIG_DIR, DIRECTORIES, DOTFILES_DIR, HOME} = require("./constants");

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

    console.log('Backing up Zsh & Oh My Zsh...')
    renameSync(`${HOME}/.zshrc`, `${BACKUP_DIR}/.zshrc`)
    renameSync(`${HOME}/.zprofile`, `${BACKUP_DIR}/.zprofile`)
    renameSync(`${HOME}/.oh-my-zsh`, `${BACKUP_DIR}/.oh-my-zsh`)

    console.log('Backing up Tmux...')
    renameSync(`${HOME}/.tmux`, `${BACKUP_DIR}/.tmux`)
    renameSync(`${HOME}/.tmux.conf`, `${BACKUP_DIR}/.tmux.conf`)
}

module.exports = {
    backup_config
}
