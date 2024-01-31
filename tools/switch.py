#!/usr/bin/env python3

"""
Program to switch betweeen different versions of neoVim distributions.

Premise:
I basically have two versions of NeoVim configurations which I use, one
is my own customized version and the other is NvChad(apart from LunarVim)

The problem is, as compared to LunarVim which I can use without having to
alter my normal NeoVim, I am not able to do the same with NvChad, hence 
the requirement of this program.

Requirement:
When this program would be run, it will check for the necessary directories
being present and based on the presence, it will inform the user about the 
status accordingly. If all the configurations are present, then this program
will allow for switching between my normal vim configuration and NvChad - which
is also heavily customized by me.

Author:
Sayantan Bhattacharya
"""

from argparse import ArgumentParser
from enum import Enum
from os import sep
from pathlib import Path
from sys import exit

# these are kept here so that we can work on this later on
BUILD_ICON = "\U0001F528"
ERROR_ICON = "\U0001F626"
PASS_ICON = "\U0001F60E"
FILE_ICON = "\U0001F4C4"
EDIT_ICON = "\U0001F589"
GEAR_ICON = "\U00002699"
PRINTER_ICON = "\U0001F5B6"
DOCUMENT_ICON = "\U0001F5CE"
LINK_ICON = "\U0001F517"
RIGHT_ARROW_ICON = "\U000020D7"
CHECK_ICON = "\U0001F5F8"

"""
Temporary Requirement gathering section:
    - Allow for adding command line arguments [done]
    - Check presence of necessary directories
"""

class Paths(Enum):
    CHAD_DPATH = f"{Path.home()}{sep}.config/nvim.chad"
    NVIM_DPATH = f"{Path.home()}{sep}.config/nvim.vim"
    SYMLINK_FPATH = f"{Path.home()}{sep}.config/nvim"


class ConfigType(Enum):
    SB = 1
    CHAD = 2

def parse_cli_args() -> dict:
    arg_parser = ArgumentParser(prog="Switch", 
                                usage="\n\tswitch.py --[sb|chad]", 
                                description="Switch SB config or NvChad", 
                                conflict_handler="error", 
                                add_help=True)

    # required arguments
    xor_group_config_type = arg_parser.add_mutually_exclusive_group(required=True)
    xor_group_config_type.add_argument("--sb", action="store_true", 
                                       help="Select SB's custom configuration")
    xor_group_config_type.add_argument("--chad", action="store_true", 
                                       help="Select NvChad config with SB's modifications")

    # optional arguments
    arg_parser.add_argument(*["-v", "--version"], action="store_true", help="Show the version information")

    return vars(arg_parser.parse_args())

def check_and_link(config_type: ConfigType) -> bool:
    is_symlink_present = False

    # Now check if the symlink exists or not
    if Path(Paths.SYMLINK_FPATH.value).is_symlink():
        print(f"{EDIT_ICON} : Symlink is present, will be modifying it")
        is_symlink_present = True
    else:
        print(f"{DOCUMENT_ICON} : Symlink is not present, will be creating it")

    # check the value of the link now, if it is already in the required value, then 
    # just return
    if config_type == ConfigType.CHAD:
        if is_symlink_present:
            if str(Path(Paths.SYMLINK_FPATH.value).readlink()) == Paths.CHAD_DPATH.value:
                print(f"{GEAR_ICON} : Already using NvChad configuration with SB's custom modifications")
                return False
            # if the symlink is present but does not match, delete it
            print(f"{LINK_ICON} : Unlinking existing symlink at : {Paths.SYMLINK_FPATH.value}")
            Path(Paths.SYMLINK_FPATH.value).unlink()
        # if the condition does not match, create the symlink
        print(f"{LINK_ICON} : Recreating link : {Paths.SYMLINK_FPATH.value} {RIGHT_ARROW_ICON} {Paths.CHAD_DPATH.value}")
        Path(Paths.SYMLINK_FPATH.value).symlink_to(Paths.CHAD_DPATH.value)
    elif config_type == ConfigType.SB:
        if is_symlink_present:
            if str(Path(Paths.SYMLINK_FPATH.value).readlink()) == Paths.NVIM_DPATH.value:
                print(f"{GEAR_ICON} : Already using SB's custom configuration")
                return False
            # if the symlink is present but does not match, delete it
            print(f"{LINK_ICON} : Unlinking existing symlink at : {Paths.SYMLINK_FPATH.value}")
            Path(Paths.SYMLINK_FPATH.value).unlink()
        # if the condition does not match, create the symlink
        print(f"{LINK_ICON} : Recreating link : {Paths.SYMLINK_FPATH.value} {RIGHT_ARROW_ICON} {Paths.NVIM_DPATH.value}")
        Path(Paths.SYMLINK_FPATH.value).symlink_to(Paths.NVIM_DPATH.value)

    print(f"\n{CHECK_ICON} : Switching completed ...")
    return True


def chk_dpath_exists() -> bool:
    # check for the presence of the necessary directories
    if not Path(Paths.CHAD_DPATH.value).resolve().exists():
        print(f"{ERROR_ICON} : NvChad configuration directory does not exist")
        return False
    if not Path(Paths.NVIM_DPATH.value).exists():
        print(f"{ERROR_ICON} : SB's NeoVim configuration directory does not exist")
        return False

    print(f"{PASS_ICON} : Both NvChad and SB's custom configuration directories found")
    return True

def main() -> None:
    """
    Main function to switch between multiple versions of the vim editor
    """
    arguments = None
    try:
        arguments = parse_cli_args()
    except Exception as exception:
        print(f"{ERROR_ICON} : Something went wrong while parsing CLI arguments : {exception.args}")

    if isinstance(arguments, dict):
        if arguments.get("sb"):
            if not chk_dpath_exists():
                exit(-1)  # exit with a negative number as the program execution return value
            print(f"\n{PRINTER_ICON} : Switching to SB's custom configuration")

            if not check_and_link(config_type=ConfigType.SB):
                exit(-1)

        elif arguments.get("chad"):
            if not chk_dpath_exists():
                exit(-1)  # exit with a negative number as the program execution return value
            print(f"\n{PRINTER_ICON} : Switching to NvChad config with SB's modifications")

            if not check_and_link(config_type=ConfigType.CHAD):
                exit(-1)

if __name__ == "__main__":
    main()
