const { mkdirSync, renameSync, existsSync} = require('fs')
const { BACKUP_DIR, SCRIPTS_DIR, CONFIG_DIR, DIRECTORIES, DOTFILES_DIR} = require("./constants");

const backup_config = () => {
    mkdirSync(BACKUP_DIR, { recursive: true })
    mkdirSync(BACKUP_DIR + '/.scripts', { recursive: true })
    mkdirSync(BACKUP_DIR + '/.config', { recursive: true })
    mkdirSync(SCRIPTS_DIR, { recursive: true })

    DIRECTORIES.forEach((dir) => {
        const fileOrDir = `${CONFIG_DIR}/${dir}`
        if (!existsSync(fileOrDir)) {
            return
        }

        renameSync(fileOrDir, `${BACKUP_DIR}/${dir}`)
    })

    renameSync(SCRIPTS_DIR, BACKUP_DIR + '/.scripts')
}

module.exports = {
    backup_config
}
