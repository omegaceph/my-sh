#!/bin/bash

# root
cp ./common/.bashrc.root ~/.bashrc
cp ./common/.bashrc.func ~/.bashrc.func
cp ./common/colors.sh ~/.bashrc.colors

# User who invoked root with the 'su' command
cp ./common/.bashrc /home/$USER/.bashrc
cp ./common/.bashrc.github /home/$USER/.bashrc.github
cp ./common/.bashrc.func /home/$USER/.bashrc.func
cp ./common/colors.sh /home/$USER/.bashrc.colors
chown $USER:$USER /home/$USER/.bashrc
chown $USER:$USER /home/$USER/.bashrc.github
chown $USER:$USER /home/$USER/.bashrc.colors
chown $USER:$USER /home/$USER/.bashrc.func
