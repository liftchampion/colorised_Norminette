# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install_installer.sh                :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/28 20:28:39 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

TMP_DIRNAME=~/.tmp_for_installing_norm_script
MAIN_PWD=$(pwd)
echo "\x1B[38;5;202mInstallation in progress...\x1B[0m"
mkdir -p $TMP_DIRNAME
cd $TMP_DIRNAME
TMP_PWD=$(pwd)
git init --quiet
git remote add origin \
	https://liftchampion@bitbucket.org/liftchampion/colorised-norminette.git 2> /dev/null
git fetch --quiet
git checkout --quiet origin/master -- colorised_norm_install.sh
cd $MAIN_PWD
${TMP_PWD}/colorised_norm_install.sh
rm -rf $TMP_DIRNAME
echo "\x1B[38;5;29mDone!\x1B[0m"
