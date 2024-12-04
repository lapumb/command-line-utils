# Command Line Utils

This repository is composed of some scripts I find useful in my day-to-day work as a software engineer who loves the command line. The script names should be fairly straight forward, but if help/usage is required, all scripts support the `-h` (help) flag.

## Dependencies

Install the following:

- [picocom](https://linux.die.net/man/8/picocom) (Available on both MacOS and Linux)
- [esptool](https://docs.espressif.com/projects/esptool/en/latest/esp32/installation.html)
- [jq](https://stedolan.github.io/jq/download/)

## Contributions

Feel free to open a PR if a bug is found or if you wish to add a new script.

If you are adding a new script, please follow the same format as the scripts that currently live in this repository, where:

- The script contains a [shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) so it can be run like `./my_script.extension`
- The script contains a usage that gets thrown on an invalid argument or the `-h` flag. The usage should look like the following:

    ```sh
    USAGE="""
    Description:
        A description of what the script does.

    Usage:
        $0 ...
        $0 -h

    Args:
        -r    Required argument that...
        [-o]  Optional argument that... defaults to...
        [-h]  Show this message

    Examples:
        $0 -r my_arg
        $0 -r my_arg -o optional_arg
    """
    ```
