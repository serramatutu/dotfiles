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
    logger.info("Installing topic '{0}'".format(topic))
    module = importlib.import_module(topic+'.install')

def _symlink_home(src):
    dest = os.path.join(
        HOME_DIR, os.path.basename(os.path.normpath(src))
    )
    logger.debug('Symlinking {0} onto {1}'.format(src, dest))

if __name__ == "__main__":
    logger.info('Beginning install')