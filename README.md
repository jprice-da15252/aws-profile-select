# AWS Profile Select Tool

_Note: Only tested with bash, version 4+_

## A painless way to select an AWS profile

This script scans your aws configuration for profile names, and allows you to choose them by number, because messing with environment variables repeatedly is toil. Toil sucks.

It's also a handy way to see the currently selected profile, as it is given in an informational message above the selection menu. You may press crtl+c at any time to exit the tool.

---

### Prerequistites

##### Shell compatibility

aps has been tested to be compatible with the following shell versions:

-   Bash: v4 and newer
-   ZSH: tested with v5.8 (with [Oh My Zsh!](https://github.com/ohmyzsh/ohmyzsh/wiki) installed, but should work equally well without it)

It may work with shells sharing compatibility with the above, but it's certainly not guaranteed.

##### AWS CLI

You will need to have your AWS CLI configured with profiles before this tool does anything useful. For more information on configuring AWS named profiles, see the documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html . This tool works with the named profiles in the `~.aws/config` file, as shown in the above link's second example.

For configuring different AWS profiles using a single IAM account and MFA, see the documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html

---

### To install/upgrade:

_Note_: the procedures below will be replaced by a homebrew tap in the near future. Until then, installation and upgrade is a manual process.

1. Download, optionally inspect, and copy the script to an appropriate folder:
    ```
    curl -o /tmp/aws-profile-select.sh https://raw.githubusercontent.com/jprice-da15252/aws-profile-select/main/aws-profile-select.sh
    sudo cp /tmp/aws-profile-select.sh /usr/local/bin/aws-profile-select.sh
    ```
2. Add aliases:
    ```
    echo -e "\nalias aps='source /usr/local/bin/aws-profile-select.sh'" >> ~/.bash_profile
    echo -e "\nalias aps='source /usr/local/bin/aws-profile-select.sh'" >> ~/.zshrc
    ```

Adding an alias to both config files is advised. Even if you only use one of the above shells, this will ensure that aps works the same in either, should the need arise.

### To use:

Using a new terminal window or tab (required for the new alias settings to take effect), simply run the script using the alias created above (aps):

```
aws-superstar@hackstation-[~]: aps

------------- AWS Profile Select-O-Matic -------------
No profile set yet

Type the number of the profile you want to use from the list below, and press enter

-: Unset Profile
0: default
1: personal
2: company-main

Selection:
```

Typing `2` and pressing enter will make this terminal use the selected profile until you re-run this command and select another profile.

```
Selection: 2
Activating profile 2: company-main
aws-superstar@hackstation-[~]: (company-main):
```

Not necessary to run, just proof this thing does what it says:

```
aws-superstar@hackstation[~]: (company-main): echo $AWS_PROFILE
company-main
```

##### Aditional usage:
```
Usage: aps [-n|--no-sdk] [-h|--help]

If you do not want the AWS_SDK_LOAD_CONFIG environment variable to be set to `1` (true), append -n or --no-sdk to the command
```

###### © Copyright 2022 Jesse Price, all rights reserved
