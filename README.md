# AWS Profile Select Tool

## A painless way to select an AWS profile
This script scans your aws configuration for profile names, and allows you to choose them by number, because messing with environment variables repeatedly is toil.  Toil sucks. 

It's also a handy way to see the currently selected profile, as it is given in an informational message above the selection menu. You may press crtl+c at any time to exit the tool. 

---
### Prerequistites

You will need to have your AWS CLI configured with profiles before this tool does anything useful.  For more information on configuring AWS named profiles, see the documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-profiles.html . This tool works with the named profiles in the `~.aws/config` file, as shown in the above link's second example. 

For configuring different AWS profiles using a single IAM account and MFA, see the documentation here: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html

---
### To install:
```
cd <directory containing script>
sudo cp aws-profile-select.sh /usr/local/bin/aws-profile-select.sh
echo -e "\nalias aps='source /usr/local/bin/aws-profile-select.sh'" >> ~/.bash_profile
```
 
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

###### Copyright 2019 Jesse Price ######