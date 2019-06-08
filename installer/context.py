import pathlib

_args = _cwd = _dotfiles = _env = _apt = _snap = _loglevel = None
class InstallContext:
    def __init__(self, **kwargs):
        global _args, _cwd, _dotfiles, _env, _apt, _snap, _loglevel
        _args = kwargs

        _dotfiles = _cwd = kwargs.get('dotfiles', None)
        _apt = kwargs.get('apt', True)
        _env = kwargs.get('env', 'INSTALL')
        _snap = kwargs.get('snap', True)
        _loglevel = kwargs.get('loglevel', 'DEBUG')

    @property
    def args(self):
        return _args

    @property
    def home(self):
        return str(pathlib.Path.home())

    @property
    def dotfiles(self):
        return _dotfiles

    @property
    def env(self):
        return _env

    @property
    def snap(self):
        return _snap

    @property
    def apt(self):
        return _apt

    @property
    def loglevel(self):
        return _loglevel

    @property
    def cwd(self):
        return _cwd

    @cwd.setter
    def cwd(self, v):
        global _cwd
        _cwd = v