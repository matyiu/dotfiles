const { symlinkSync, existsSync } = require('fs');
const { DIRECTORIES, DOTFILES_DIR, CONFIG_DIR, SCRIPTS_DIR, HOME} = require("./constants");
const {exec_command} = require("./install");

const setup_config = async () => {
    console.log('Setting up .config dir...')
    DIRECTORIES.forEach((dir) => {
        const fileOrDir = `${DOTFILES_DIR}/.config/${dir}`
        if (!existsSync(fileOrDir)) {
            return
        }

        symlinkSync(fileOrDir, `${CONFIG_DIR}/${dir}`)
    })

    console.log('Setting up .scripts dir...')
    symlinkSync(`${DOTFILES_DIR}/.scripts`, SCRIPTS_DIR)

    const OH_MY_ZSH_PATH = `${HOME}/.oh-my-zsh`

    console.log('Setting up Zsh & Oh My Zsh...')
    await exec_command('sudo chsh -s $(which zsh)')
    symlinkSync(`${DOTFILES_DIR}/.zshrc`, `${HOME}/.zshrc`)
    symlinkSync(`${DOTFILES_DIR}/.zprofile`, `${HOME}/.zprofile`)
    
    await exec_command('cd .oh-my-zsh && git init && git remote add https://github.com/ohmyzsh/ohmyzsh.git && git pull')
    symlinkSync(`${DOTFILES_DIR}/.oh-my-zsh`, OH_MY_ZSH_PATH)

    console.log('Setting up Tmux...')
    symlinkSync(`${DOTFILES_DIR}/.tmux`, `${HOME}/.tmux`)
    symlinkSync(`${DOTFILES_DIR}/.tmux.conf`, `${HOME}/.tmux.conf`)
}

module.exports = {
    setup_config
}