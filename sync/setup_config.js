const { symlinkSync, existsSync } = require('fs');
const { DIRECTORIES, DOTFILES_DIR, CONFIG_DIR, SCRIPTS_DIR, HOME} = require("./constants");
const {exec_command} = require("./install");

const setup_config = async () => {
    console.log('Setting keyboard layout')
    await exec_command('localectl --no-convert set-x11-keymap es');

    console.log('Setting up .scripts dir...')
    symlinkSync(`${DOTFILES_DIR}/.scripts`, SCRIPTS_DIR)

    console.log('Setting up .config dir...')
    DIRECTORIES.forEach((dir) => {
        const fileOrDir = `${DOTFILES_DIR}/.config/${dir}`
        if (!existsSync(fileOrDir)) {
            return
        }

        symlinkSync(fileOrDir, `${CONFIG_DIR}/${dir}`)
    })

    const OH_MY_ZSH_PATH = `${HOME}/.oh-my-zsh`

    console.log('Setting up Zsh & Oh My Zsh...')
    await exec_command('sudo chsh -s $(which zsh)')
    symlinkSync(`${DOTFILES_DIR}/.zshrc`, `${HOME}/.zshrc`)
    symlinkSync(`${DOTFILES_DIR}/.zprofile`, `${HOME}/.zprofile`)

    if (!existsSync(`${DOTFILES_DIR}/.oh-my-zsh/.git`)) {
        await exec_command('cd .oh-my-zsh && git init && git remote add origin https://github.com/ohmyzsh/ohmyzsh.git && git pull origin master')
    }

    if (!existsSync(`${DOTFILES_DIR}/.oh-my-zsh/custom/plugins/zsh-autosuggestions`)) {
        await exec_command(`git clone https://github.com/zsh-users/zsh-autosuggestions ${DOTFILES_DIR}/.oh-my-zsh/custom/plugins/zsh-autosuggestions`)
    }
    symlinkSync(`${DOTFILES_DIR}/.oh-my-zsh`, OH_MY_ZSH_PATH)

    console.log('Setting up Tmux...')
    symlinkSync(`${DOTFILES_DIR}/.tmux`, `${HOME}/.tmux`)
    symlinkSync(`${DOTFILES_DIR}/.tmux.conf`, `${HOME}/.tmux.conf`)
}

module.exports = {
    setup_config
}
