# Windows Icon Deployment

The project aims at deploying customized icons to folders by adjusting the 
hidden `Desktop.ini` with respect to a formatted config file.

## Usage

1. Edit `config` properly
2. Run `install.cmd` for installation
3. Run `uninstall.cmd` for uninstallation

### Config

The config file consists of lines of the same format:

	<target_directory>:<icon_file>:<index>

Note that there are no spaces allowed before or after the colons.

If you are using `.ico` files, the `<index>` should always be 0. 
However, once you have `.dll` as a source (which is the trick Windows do), 
the `<index>` decides the one chosen from the icon pack.

### Install

The script can be called as following:

	.\install.cmd [target_directory_root] [-s] [-c]

All the parameters are optional. 

* target_directory_root

	The root is `..\` by default (note that double-click the script runs it 
with no parameters). If you want to specify the root manually, it must be the 
first parameter, though.

* silence mode

	The flag `-s` enables silence mode. The script won't pause on terminating.

* copy mode

	The flag `-c` enables copy mode. The script copies icon files so that one 
can remove the original ones after installation.

### Uninstall

The script can be called as following:

	.\install.cmd [target_directory_root] [-s]

The behaviours of the parameters are the same as in Install