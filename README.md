#  **etcetra** - _Terminal Enviroment Deployment_. 
etcetra unifies and simplies the deployment of a terminal enviroment. 

### Examples
To define a deployment for wget via using the system package manager.
```m4
ETC_MODULE(wget,`ETC_PKG(wget)')
```

To define a deployment for requests _python module_:
```m4
ETC_MODULE(python_requests,`ETC_PKG(requests,pip3)')
```

To define a compound deployment module for C/C++ development
```m4
ETC_MODULE_BEGIN(C_CXX)
    ETC_PKG(gcc)
    ETC_PKG(gdb)
    ETC_PKG(cmake)
    ETC_PKG(doxygen)
ETC_MODULE_END(C_CXX)
```

Sneakly inject code into a deployment with hooks:
```m4
ETC_HOOK_UPDATE(sh ~/.oh-my-zsh/tools/upgrade.sh)
ETC_GIT(git://github.com/robbyrussell/oh-my-zsh.git,~/.oh-my-zsh)
```

To define a deployment for both neovim and its plugins and make its plugins
depend on having neovim:
```m4
ETC_DEPEND(neovim,neovim_plug)

ETC_MODULE(neovim,`ETC_PKG(neovim)')

ETC_MODULE_BEGIN(neovim_plug)
    ETC_PKG(jedi,pip3)

    ETC_HOOK_CREMATE(rm -rf ~/.local/share/nvim/plugged)
    ETC_RESOURCE(https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim,~/.local/share/nvim/site/autoload/plug.vim)

    ETC_HOOK_EVOLVE(nvim +PlugUpdate +qa)
    ETC_HIERARCHY(ETC_DIR_DEPLOY/data/init.vim, ~/.config/nvim/init.vim)
ETC_MODULE_END(neovim_plug)
```

### Setup/Installation
_Documentation for the ETC... Macros can be generated via `make docs`_

1. Retrieve this repositiory, either using git or downloading the zip.
2. Open a terminal and `cd` into the repositiory directory.
3. Write your deployment specification in the 'deploy' directory and save as `<name>.etc`
The 'deploy' directory is copied together with the deployment specification during installation
and can be used to hold installation files.
The 'deploy' directory can be referenced in the deployment using the macro `ETC_DIR_DEPLOY`  
For example this deployment specification refenreces data/init.vim in the 'deploy'  directory
```m4
ETC_HIERARCHY(ETC_DIR_DEPLOY/data/init.vim, ~/.config/nvim/init.vim)
```
4. Run 'make install'

#### etcetra is now installed with deployment specifications

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
