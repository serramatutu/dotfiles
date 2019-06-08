import os
import argparse

def parse_args():
    parser = argparse.ArgumentParser(
        prog="serramatutu's dotfiles installer",
        usage="use as 'sh install/bootstrap'. do not call python directly"
    )
    parser.add_argument(
        "dotfiles",
        default=os.getcwd(),
        help="where the dotfiles repo is located at"
    )
    parser.add_argument(
        "--env",
        default="INSTALL",
        help="whether the program is being tested or installed"
    )
    parser.add_argument(
        "--no-apt",
        dest="apt",
        action="store_false",
        help="do not perform apt installs"
    )
    parser.set_defaults(apt=True)
    parser.add_argument(
        "--no-snap",
        dest="snap",
        action="store_false",
        help="do not perform snap installs"
    )
    parser.set_defaults(snap=True)
    parser.add_argument(
        "--no-zsh",
        dest="zsh",
        action="store_false",
        help="do not perform zsh environment updates"
    )
    parser.set_defaults(zsh=True)

    parser.add_argument(
        "--quiet", "-q",
        dest="loglevel",
        action="store_const",
        const="WARNING",
        help="shhhhhhhh!"
    )
    parser.add_argument(
        "--verbose", "-v",
        dest="loglevel",
        action="store_const",
        const="DEBUG",
        help="enable verbose logging"
    )
    parser.set_defaults(loglevel="INFO")

    return parser.parse_args()