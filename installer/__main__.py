from .installer import _pre_install, _install
from .args import parse_args

if __name__ == "__main__":
    _pre_install(parse_args())
    _install()