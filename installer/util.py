import logging
import subprocess

logger = logging.getLogger(__name__)

def sh(command, pretty_name=None, logger=logger):
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