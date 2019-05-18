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

def _install_topic(topic):
    """Installs a topic"""
    logger.info("Installing topic '{0}'".format(topic))

    path = os.path.join(DOTFILES_DIR, 'topics', topic)
    install_module = None
    for file_name in os.listdir():
        print(file_name)
        if file_name == 'install.py':
            install_module = importlib.import_module('topics.'+topic+'.install')

def _symlink_home(src):
    """Symlinks a file into the user's home directory"""
    dest = os.path.join(
        HOME_DIR, os.path.basename(os.path.normpath(src))
    )
    logger.debug('Symlinking {0} onto {1}'.format(src, dest))
    os.symlink(src, dest)

def _load_env(src):
    """Loads .zsh file contents onto the zsh environment"""
    pass

if __name__ == "__main__":
    logger.info('Beginning install')

    topics_dir = os.path.join(DOTFILES_DIR, 'topics')
    topics = os.listdir(topics_dir)

    print(topics)