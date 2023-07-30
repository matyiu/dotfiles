#!/usr/bin/env node

const { install_packages } = require("./install")
const { backup_config} = require("./backup_config");
const { setup_config} = require("./setup_config");


(async () => {
    await install_packages()
    backup_config()
    await setup_config()
})()