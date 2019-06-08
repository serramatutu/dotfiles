import os
import logging
import subprocess

from .installer import CONTEXT, ENV

logger = logging.getLogger(__name__)

def sh(command, pretty_name=None, logger=logger, print_output=True):
    """Run a shell command"""
    _sh_logger = logger.getChild('sh')

    if pretty_name is None:
        pretty_name=command
    _sh_logger.debug("Running '{0}'".format(pretty_name))

    tokens = command.split(' ')
    stdout = None if print_output else subprocess.PIPE
    process = subprocess.run(tokens, 
        cwd=CONTEXT.cwd,
        encoding='utf-8',
        stderr=subprocess.PIPE,
        stdout=stdout
    )
    if process.returncode != 0:
        _sh_logger.error(process.stderr)
        raise RuntimeError("Command failed")
    return process

def apt(package_name, logger=logger):
    """Install an apt package"""
    _apt_logger = logger.getChild('apt')
    _apt_logger.debug("Installing apt package '{0}'".format(package_name))

    # TODO: repository updates, checksum/key checking etc.
    return sh('apt -qq -y install '+package_name, 'apt install', _apt_logger, False)

def snap(package_name, logger=logger):
    """Install a snap package"""
    _snap_logger = logger.getChild('snap')
    if ENV == "TEST":
        _snap_logger.warning("Snap doesn't work inside docker container. Aborting install.")
        return
    _snap_logger.debug("Installing snap package '{0}'".format(package_name))

    # TODO: repository updates, checksum/key checking etc.
    return sh('snap install '+package_name, 'snap install', _snap_logger, False)