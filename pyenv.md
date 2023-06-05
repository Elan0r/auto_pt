# Using EoL Python Versions on Kali


Install pyenv.
```bash
apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev python3-openssl git
```

```bash
curl https://pyenv.run | bash
```

```bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo -e 'eval "$(pyenv init --path)"\neval "$(pyenv init -)"\neval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
```

```bash
exec $SHELL
```

Install Python version 3.10.10.
```bash
pyenv install 3.10.10
```

Create a virtual environment with the installed version of Python and name it "certipy".
```bash
pyenv virtualenv 3.10.10 certipy
```

Activate created virtual environment.
```bash
pyenv activate certipy
```

Install the tool using pip.
```bash
pip install certipy-ad
```

Deactivate the virtual environment (to exit the virtual environment).
```bash
pyenv deactivate
```

List all of the install candidates.
```bash
pyenv install --list
```
List all of the installed versions.
```bash
pyenv versions 
```

List all created virtual environments.
```bash
pyenv virtualenvs
```

Delete the virtual environment.
```bash
pyenv virtualenv-delete certipy
```
