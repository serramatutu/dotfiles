import os
import sys
import logging
import pathlib
import importlib

import coloredlogs

logging.basicConfig()
coloredlogs.install(
    fmt='%(name)s %(levelname)s %(message)s',
    level='DEBUG'
)
logger = logging.getLogger("installer")

HOME_DIR = str(pathlib.Path.home())
DOTFILES_DIR = sys.argv[1] if 1 < len(sys.argv) else None

def _pre_install():
    logger.info("Found HOME dir: {0}".format(HOME_DIR))

    sys.path.append(DOTFILES_DIR)
    os.makedirs(os.path.join(HOME_DIR, '.zsh'), exist_ok=True)

def _install():
    logger.info('Beginning install')

    success = []
    failed = []
    topics_dir = os.path.join(DOTFILES_DIR, 'topics')
    topics = os.listdir(topics_dir)
    for topic in topics:
        try:
            _install_topic(topic)
            success.append(topic)
        except Exception as e:
            logger.error(
                "Failed install for {0}. {1}"
                .format(topic, getattr(e, 'message', None))
            )
            failed.append(topic)

    logger.info("Installed {0}".format(', '.join(success)))
    logger.warning("Failed install for {0}".format(', '.join(failed)))

    logger.info('Finished install')

def _load_install_method(topic):
    install_module = importlib.import_module('topics.'+topic+'.install')
    if (hasattr(install_module, 'install') and 
        callable(getattr(install_module, 'install'))):
        return getattr(install_module, 'install')
    else:
        raise ValueError(
            "Invalid install module for topic '{0}'"
            .format(topic)
        )
    return None

def _install_topic(topic):
    """Installs a topic"""
    logger.info("Installing topic '{0}'".format(topic))

    topic_path = os.path.join(DOTFILES_DIR, 'topics', topic)
    install_method = None
    zsh_files = []
    symlink_files = []
    for file_name in os.listdir(topic_path):
        file_path = os.path.join(topic_path, file_name)
        base_name, ext = os.path.splitext(file_name)

        if file_name == 'install.py':
            install_method = _load_install_method(topic)
        
        elif ext == '.symlink':
            symlink_files.append(file_path)
        elif ext == '.zsh':
            zsh_files.append(file_path)
        else:
            logger.debug(
                "{0} will not be symlinked nor loaded into zsh."
                .format(file_name)
            )

    if install_method is not None:
        install_method()
    for zsh_file in zsh_files:
        _load_env(zsh_file)
    for symlink_file in symlink_files:
        _symlink_home(symlink_file)
    
    logger.info("'{0}' installed successfully".format(topic))

def _symlink_home(src):
    """Symlinks a file into the user's home directory"""
    base_name, ext = os.path.splitext(src)
    dest = os.path.join(
        HOME_DIR, os.path.basename(os.path.normpath(base_name))
    )
    logger.debug('Symlinking {0} onto {1}'.format(src, dest))
    os.symlink(src, dest)

def _load_env(src):
    """Loads .zsh file contents onto the zsh environment"""
    pass

if __name__ == "__main__":
    _pre_install()
    _install()