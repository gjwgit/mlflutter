# MLHub Installers

Flutter supports multiple platform targets and the app will run native
on Android, iOS, Linux, MacOS, and Windows, as well as directly in a
browser from the web. While the Flutter functionality is in theory identical
across all platforms, mlhub relies on mlhub packages being
available on the platform. At present we only support dekstops (Linux,
MacOS, and Windows).

## Prerequisite

Install [mlhub](https:///mlhub.au) and the mlhub
[openai](https://survivor.togaware.com/mlhub/openai.html):

```bash
pip install mlhub
mlhub configure
ml install Ting-TT/openai
ml configure openai
```

## Linux tar Archive

+ Download [mlflutter.tar.gz](https://access.togaware.com/mlflutter.tar.gz)

```bash
wget https://access.togaware.com/mlflutter.tar.gz
```

Then, to simply try it locally:

```bash
tar zxvf mlflutter.tar.gz
mlflutter/mlfutter)
```

Or, to install for the current user:

```bash
wget https://access.togaware.com/mlflutter.tar.gz
tar zxvf mlflutter.tar.gz -C ${HOME}/.local/share/
ln -s ${HOME}/.local/share/mlflutter/mlflutter ${HOME}/.local/bin/mlhub
```

For this user, to install a desktop icon and make it known to Gnome
and KDE:

```bash
wget https://raw.githubusercontent.com/gjwgit/mlflutter/dev/installers/mlhub.desktop -O ${HOME}/.local/share/applications/mlhub.desktop
wget https://github.com/gjwgit/mlflutter/raw/dev/installers/mlhub.png -O ${HOME}/.local/share/icons/hicolor/256x256/apps/mlhub.png
sed -i "s/USER/$(whoami)/g" ${HOME}/.local/share/applications/mlhub.desktop
```

Or, for a system-wide install:

```bash
wget https://access.togaware.com/mlflutter.tar.gz
sudo tar zxvf mlflutter.tar.gz -C /opt/
sudo ln -s /opt/mlflutter/mlflutter /usr/local/bin/mlhub
``` 

Once installed you can run the app as Alt-F2 and type `rattle` then
Enter.

## MacOS

The package file `mlflutter.dmg` can be installed on MacOS. Download
the file and open it on your Mac. Then, holding the Control key click
on the app icon to display a menu. Choose `Open`. Then accept the
warning to then run the app. The app should then run without the
warning next time.

## Windows Installer

Download and run the `mlflutter.exe` to self install the app on
Windows.
