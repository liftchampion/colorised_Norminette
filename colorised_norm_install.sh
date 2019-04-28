# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm_install.sh                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/28 20:13:36 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

DIRNAME=~/.scripts/
ALIASNAME=norminette
NORM_COLOR=29
NO_NORM_COLOR=202

#############################  CHECK ZSHRC  ####################################

function check_zshrc {
	ISZSHRC=$(find ~ -d 1 -name '.zshrc' 2> /dev/null | wc -w)
	if (( $ISZSHRC == 0)); then
		echo "No ~/.zshrc found. Sorry"
		exit 1
	fi
}
################################  ASK REOPEN  ##################################
function ask_reopen {
	echo "\x1B[38;5;82mReopen\x1B[0m your \x1B[38;5;82mterminal\x1B[0m, please"
}

################  CHECK PREV ALIASES TO COLORISED NORM  ########################

function get_prev_colors {
	NORM_COLOR=$(cat ${DIRNAME}colorised_norm.sh | grep '^NORM_COLOR' | awk -F '=' '{print $2}')
	NO_NORM_COLOR=$(cat ${DIRNAME}colorised_norm.sh | grep '^NO_NORM_COLOR' | awk -F '=' '{print $2}')
}

function find_prev_alias {
	PREV_ALIAS_TO_THIS=$(cat ~/.zshrc | grep '^alias.\+/colorised_norm\.sh')
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		ALIASNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/alias //g' | \
						awk -F '=' '{print $1}')
		DIRNAME=$(echo $PREV_ALIAS_TO_THIS | sed 's/^.*=//g' | \
						awk -F '/' '{$NF=""; print $0}' | tr ' ' '/' | tr -d "'")
		get_prev_colors
		echo "Found \x1B[38;5;202mexisting\x1B[0m alias to this script:"
		echo "alias \x1B[38;5;29m$ALIASNAME\x1B[0m='\x1B[38;5;29m${DIRNAME}colorised_norm.sh\x1B[0m'"
	fi
}
#############################  GET ALIASNAME  ###################################

function get_alias_name {
	echo "Choose \x1B[38;5;128malias name\x1B[0m (leave blank for '$ALIASNAME'):"
	read NEW_ALIASNAME
	NEW_ALIASNAME=$(echo $NEW_ALIASNAME | tr -d '\n')
	WORDS_IN_NEW_ALIASNAME=$(echo $NEW_ALIASNAME | wc -w)
	SAME_ALIASES=$(cat ~/.zshrc | grep "^alias $NEW_ALIASNAME=" | grep -v 'colorised_norm.sh')
	SAME_ALIASES_COUNT=$(echo $SAME_ALIASES | wc -w)
	if (( $WORDS_IN_NEW_ALIASNAME > 1)) || (( $SAME_ALIASES_COUNT > 0)); then
		echo "\x1B[38;5;160mBad aliasname: '$NEW_ALIASNAME'\x1B[0m"
		if (( $SAME_ALIASES_COUNT > 0)); then
			echo "Alias with this name already exists"
			echo $SAME_ALIASES
		fi
		printf "Try again (Y/n): "
		read Q_RES
		if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
			exit 0
		fi
		get_alias_name
	elif (( $WORDS_IN_NEW_ALIASNAME == 1 )) ; then
		ALIASNAME=$NEW_ALIASNAME
	fi
}

#############################  GET DIRNAME  ###################################
function add_slash_to_dirname {
	NEW_DIRNAME=$(echo $NEW_DIRNAME | sed 's/\/$//g' | sed 's/$/\//g')
}

function add_pwd_if_needed {
	FIRST_CHAR=$(echo $NEW_DIRNAME | cut -c 1)
	SCREENED_PWD=$(pwd | sed 's/\//\\\//g' | sed 's/$/\\\//g')
	if [[ "$FIRST_CHAR" != "~" ]] && [[ "$FIRST_CHAR" != "/" ]]; then
		NEW_DIRNAME=$(echo $NEW_DIRNAME | sed "s/^/$SCREENED_PWD/g")
	fi
}

function get_dir_name {
	echo "Choose \x1B[38;5;128mdirectory\x1B[0m (leave blank for '$DIRNAME'):"
	read NEW_DIRNAME
	SCREENED_HOME=$(echo $HOME | sed 's/\//\\\//g')
	NEW_DIRNAME=$(echo $NEW_DIRNAME | tr -d '\n' | sed "s/~/$SCREENED_HOME/g")
	WORDS_IN_NEW_DIRNAME=$(echo $NEW_DIRNAME | wc -w)
	if (( $WORDS_IN_NEW_DIRNAME == 0 )); then
		NEW_DIRNAME=$DIRNAME
	fi
	if (( $WORDS_IN_NEW_DIRNAME > 1 )); then
		echo "Bad directory: '$NEW_DIRNAME'"
		printf "Try again (Y/n): "
		read Q_RES
		if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
			exit 0
		fi
		get_dir_name
	else
		add_pwd_if_needed
		add_slash_to_dirname
		mkdir -p $NEW_DIRNAME 2> /dev/null
		touch "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" 2> /dev/null
		if [ ! -d "$NEW_DIRNAME" ] || [ ! -f "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" ]; then	
			echo "\x1B[38;5;160mBad directory: '$NEW_DIRNAME'\x1B[0m"
			printf "Try again (Y/n): "
			read Q_RES
			if [[ "$Q_RES" == 'n' ]] || [[ "$Q_RES" == 'N' ]]; then
				exit 0
			fi
			get_dir_name
		else
			rm -f "${NEW_DIRNAME}/.test_file_for_installing_colorised_norm" 2> /dev/null
			DIRNAME=$NEW_DIRNAME
		fi
	fi
}

#########################  RM PREV ALIAS TO THIS  ###############################
function rm_prev_alias {
	set -e
	cat ~/.zshrc | grep -v "$PREV_ALIAS_TO_THIS" > ~/.zshrc.backup.colorised_norm
	cat ~/.zshrc.backup.colorised_norm > ~/.zshrc
	rm -f ~/.zshrc.backup.colorised_norm
	rm -f ${DIRNAME}colorised_norm.sh
	set +e
}

################################  INSTALL  ######################################
function install_script {
	PWD=$(pwd)
	TMP_DIRNAME=~/.tmp_for_installing_norm_script
	echo "\x1B[38;5;202mInstallation in progress...\x1B[0m"
	mkdir -p $TMP_DIRNAME
	mkdir -p $DIRNAME
	cd $TMP_DIRNAME
	git init --quiet
	git remote add origin \
			https://liftchampion@bitbucket.org/liftchampion/scripts.git 2> /dev/null
	git fetch --quiet
	git checkout --quiet origin/master -- colorised_norm.sh
	mv colorised_norm.sh "${DIRNAME}colorised_norm.sh"
	cd $PWD
	rm -rf $TMP_DIRNAME
	echo "alias $ALIASNAME='${DIRNAME}colorised_norm.sh'" >> ~/.zshrc
	echo "\x1B[38;5;29mDone!\x1B[0m"
}

##################################  SETTINGS  ####################################

function print_example {
	echo "\nCurrent colors are \x1B[38;5;${NEW_NORM_COLOR}m$NEW_NORM_COLOR\x1B[0m" \
			"\x1B[38;5;${NEW_NO_NORM_COLOR}m$NEW_NO_NORM_COLOR\x1B[0m:"
	echo "'\x1B[38;5;${NEW_NO_NORM_COLOR}mNorme: /Users/ggerardy/CLION/FDF/ft_fdf_events.c\x1B[0m"
	echo " Error: file must end with a single empty line"
	echo " Error (line 127): bad indentation"
	echo " \x1B[38;5;${NEW_NORM_COLOR}mNorme: /Users/ggerardy/CLION/FDF/main.c\x1B[0m'\n"
}

function print_colors {
	echo "Possible colors is:\n"
	for (( b = 0; b < 16; b++ ))
	do
		for (( a = 1; a <= 16; a++ ))
		do
			code=$(( b * 16 + a ))
			printf "\x1B[38;5;${code}m%3d\x1B[0m " $code
		done
		printf "\n"
	done
}

function set_colors {
	cat ${DIRNAME}colorised_norm.sh | awk -v nc=$NORM_COLOR -v nnc=$NO_NORM_COLOR \
		'{if ($0 ~ /^NORM_COLOR=/){$0="NORM_COLOR="nc}
		if ($0 ~ /^NO_NORM_COLOR=/){$0="NO_NORM_COLOR="nnc} print $0}' > ~/.colorised_norm_color_tmp
	cat ~/.colorised_norm_color_tmp > ${DIRNAME}colorised_norm.sh
	rm -f ~/.colorised_norm_color_tmp
}

function read_colors {
	echo "Write norm color (leave blank for \x1B[38;5;${NORM_COLOR}m$NORM_COLOR\x1B[0m)"
	read NEW_NORM_COLOR
	if [[ "$NEW_NORM_COLOR" == "" ]]; then
		NEW_NORM_COLOR=$NORM_COLOR
	fi
	echo "Write NON-norm color (leave blank for \x1B[38;5;${NO_NORM_COLOR}m$NO_NORM_COLOR\x1B[0m)"
	read NEW_NO_NORM_COLOR
	if [[ "$NEW_NO_NORM_COLOR" == "" ]]; then
		NEW_NO_NORM_COLOR=$NO_NORM_COLOR
	fi
	if ! [[ "$NEW_NORM_COLOR" =~ ^[0-9]+$ ]] || ! [[ "$NEW_NO_NORM_COLOR" =~ ^[0-9]+$ ]] ||
		(( $NEW_NORM_COLOR > 256 )) || (( $NEW_NO_NORM_COLOR > 256 )) ||
		(( $NEW_NORM_COLOR <= 0 )) || (( $NEW_NO_NORM_COLOR <= 0 ))
		then
			echo "\x1B[38;5;160mBad color(s)\x1B[0m"
			read_colors
		else
			print_example
			printf "Comfirm? [Y/n]:"
			read Q_RES
			if [[ "$Q_RES" == "n" ]] || [[ "$Q_RES" == "N" ]]; then
				read_colors
			else
				NORM_COLOR=$NEW_NORM_COLOR
				NO_NORM_COLOR=$NEW_NO_NORM_COLOR
			fi
	fi
}

function change_color {
	NEW_NO_NORM_COLOR=$NO_NORM_COLOR
	NEW_NORM_COLOR=$NORM_COLOR
	print_example
	print_colors
	echo ""
	read_colors
	set_colors
}

function ask_color_set {
	echo "Would you like to set custom \x1B[38;5;128mcolors\x1B[0m? [y/N]"
	read Q_RES
	if [[ "$Q_RES" == 'y' ]] || [[ "$Q_RES" == 'Y' ]]; then
		change_color
	fi
}

###############################  ASK MODE  ######################################
function ask_mode {
	if [[ $PREV_ALIAS_TO_THIS != "" ]]; then
		printf "Would you like to Reinstall/Delete/Exit/\x1B[38;5;128mSetColors\x1B[0m?\n[R/d/e/\x1B[38;5;128ms\x1B[0m]: "
		read Q_RES
		if [[ "$Q_RES" == 'd' ]] || [[ "$Q_RES" == 'D' ]]; then
			rm_prev_alias
			ask_reopen
			exit 0
		fi
		if [[ "$Q_RES" == 'e' ]] || [[ "$Q_RES" == 'E' ]]; then
			exit 0
		fi
		if [[ "$Q_RES" == 's' ]] || [[ "$Q_RES" == 'S' ]]; then
			change_color
			exit 0
		fi
		rm_prev_alias
	fi
}

####################################  MAIN  ######################################
check_zshrc
find_prev_alias
ask_mode
get_alias_name
get_dir_name
install_script
ask_color_set
ask_reopen
