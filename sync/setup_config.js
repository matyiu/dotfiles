const { symlinkSync } = require('fs');
const { DIRECTORIES, DOTFILES_DIR, CONFIG_DIR, SCRIPTS_DIR, HOME} = require("./constants");

const setup_config = () => {
    console.log('Setting up .config dir...')
    DIRECTORIES.forEach((dir) => {
        symlinkSync(`${DOTFILES_DIR}/.config/${dir}`, CONFIG_DIR)
    })

    console.log('Setting up .scripts dir...')
    symlinkSync(`${DOTFILES_DIR}/.scripts`, SCRIPTS_DIR)

    const OH_MY_ZSH_PATH = `${HOME}/.oh-my-zsh`

    console.log('Setting up Zsh & Oh My Zsh...')
    symlinkSync(`${DOTFILES_DIR}/.zshrc`, `${HOME}/.zshrc`)
    symlinkSync(`${DOTFILES_DIR}/.zprofile`, `${HOME}/.zprofile`)
    symlinkSync(`${DOTFILES_DIR}/.oh-my-zsh`, OH_MY_ZSH_PATH)

    console.log('Setting up Tmux...')
    symlinkSync(`${DOTFILES_DIR}/.tmux`, `${HOME}/.tmux`)
    symlinkSync(`${DOTFILES_DIR}/.tmux.conf`, `${HOME}/.tmux.conf`)
}

module.exports = {
    setup_config
}