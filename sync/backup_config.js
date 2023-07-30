const { mkdirSync, renameSync } = require('fs')
const { BACKUP_DIR, SCRIPTS_DIR, CONFIG_DIR, DIRECTORIES, DOTFILES_DIR} = require("./constants");

const backup_config = () => {
    mkdirSync(BACKUP_DIR)
    mkdirSync(BACKUP_DIR + '/.scripts')
    mkdirSync(BACKUP_DIR + '/.config')
    mkdirSync(SCRIPTS_DIR)

    DIRECTORIES.forEach((dir) => {
        renameSync(DOTFILES_DIR + `/${dir}`, `${BACKUP_DIR}/.scripts/${dir}`)
    })

    renameSync(SCRIPTS_DIR, BACKUP_DIR + '/.scripts')
}

module.exports = {
    backup_config
}
