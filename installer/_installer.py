import os
import sys
import logging
import pathlib
import importlib
import subprocess

import coloredlogs

logging.basicConfig()
coloredlogs.install(
    fmt='%(name)s %(levelname)s %(message)s',
    level='DEBUG'
)
logger = logging.getLogger("installer")

HOME_DIR = str(pathlib.Path.home())
DOTFILES_DIR = sys.argv[1] if 1 < len(sys.argv) else None

def _install(topic):
    logger.info("Installing topic '{0}'".format(topic))
    module = importlib.import_module(topic+'.install')

def _symlink_home(src):
    dest = os.path.join(
        HOME_DIR, os.path.basename(os.path.normpath(src))
    )
    logger.debug('Symlinking {0} onto {1}'.format(src, dest))

def sh(command, pretty_name=None, logger=logger):
    logger.debug('fon')
    _sh_logger = logger.getChild('sh')

    if pretty_name is None:
        pretty_name=command
    _sh_logger.debug("Running '{0}'".format(pretty_name))

    tokens = command.split(' ')
    process = subprocess.run(tokens, encoding='utf-8', stderr=subprocess.PIPE)
    if process.returncode != 0:
        _sh_logger.error(process.stderr)
        raise RuntimeError("Command failed")
    return process

def apt(package_name, logger=logger):
    _apt_logger = logger.getChild('apt')
    _apt_logger.debug("Installing apt package '{0}'".format(package_name))

    # TODO: repository updates, checksum/key checking etc.
    return sh('sudo apt install '+package_name, 'apt install', _apt_logger)

if __name__ == "__main__":
    logger.info('Beginning install')