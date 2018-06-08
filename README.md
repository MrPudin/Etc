#  **etcetra** - _Terminal Enviroment Deployment_. 
Etcetra unifies and simplies the deployment of a terminal enviroment across POSIX systems.

Etcetra allows you to write deployment specification, then proceed to deploy across 
different POSIX-compatible systems with ease.

What you write
```m4
ETC_PKG(wget)
```
What is executed on macos with brew installed
```sh
brew install wget
```

What is executed on Debian with apt-get installed
```sh
sudo apt-get install wget
```

### Example
To define a compound deployment module for C/C++ development
```m4
ETC_MODULE_BEGIN(C_CXX)
    ETC_PKG(gcc)
    ETC_PKG(gdb)
    ETC_PKG(cmake)
    ETC_PKG(doxygen)
ETC_MODULE_END(C_CXX)
```
Copy your dotfiles for neovim and update your plugins using hooks
Sneakly inject shell commands using hooks
```m4
ETC_MODULE_BEGIN(neovim_plug)
    ETC_PKG(neovim,pip3)
    ETC_PKG(jedi,pip3)
    ETC_REMOTE_RESOURCE(https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim,$(HOME)/.local/share/nvim/site/autoload/plug.vim)
    ETC_DEPLOY_COPY(dotfiles/init.vim,$(HOME)/.config/nvim/init.vim)
    
    ETC_UPGRADE_HOOK(`
        ETC_RUN_NORM(nvim +PlugUpdate +qa)
    ')
    ETC_TEARDOWN_HOOK(`
        ETC_RUN_NORM(rm -rf $(HOME)/.local/share/nvim/plugged)
    ')
ETC_MODULE_END(neovim_plug)
```

Make your zsh plugins dependent on having zsh already installed:
```m4
ETC_MODULE_DEPEND(zsh_plug,zsh)

ETC_MODULE(zsh,ETC_PKG(zsh))

ETC_MODULE_BEGIN(zsh_plug)
    ETC_REMOTE_RESOURCE(https://raw.githubusercontent.com/zplug/installer/master/installer.zsh,/tmp/make_zplug)
    ETC_DEPLOY_COPY(dotfiles/zshrc,$(HOME)/.zshrc)

    ETC_SETUP_HOOK(`
       ETC_RUN_NORM(zsh /tmp/make_zplug)
    ')
    ETC_UPGRADE_HOOK(`
        ETC_RUN_NORM(zsh -c "source $(HOME)/.zshrc; source $(HOME)/.zplug/init.zsh; zplug update")
    ')
    ETC_TEARDOWN_HOOK(`
        ETC_RUN_NORM(rm -rf $(HOME)/.zplug)
    ')
ETC_MODULE_END(zsh_plug)

```
### Setup/Installation
1. `git clone https://github.com/mrzzy/etcetra ~/.etc`
2. Write your deployment specification in the 'deploy' in '~/.etc' directory 
and naming it as "deployment.m4"
3. Run `sudo make install` to install the etcetera command line tool.

### Usage
Once the etcetra and the deployment specifcation are installed:
1. Install the deployment `etcetra install`
2. Update the deployment `etcetra update`
2. Remove the deployment `etcetra update`

To only interact with a certain module run
`etcetra (install|update|remove) <module(s)>` instead

### Uninstall
Run `make remove`
Well, this is it. Farewell. ;(
