# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install_installer.sh                :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/25 21:06:13 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

TMP_DIRNAME=.tmp_for_installing_norm_script
echo "\x1B[38;5;202mInstallation in progress...\x1B[0m"
mkdir -p $TMP_DIRNAME
cd $TMP_DIRNAME
git init --quiet
git remote add origin \
	https://liftchampion@bitbucket.org/liftchampion/scripts.git 2> /dev/null
git fetch --quiet
git checkout --quiet origin/master -- colorised_norm.sh

./colorised_norm.sh ~/CLION/lem_in/srcs
cd ..
rm -rf $TMP_DIRNAME
echo "\x1B[38;5;29mDone!\x1B[0m"
