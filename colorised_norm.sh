# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2021/05/06 05:17:28 by amalliar         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

# Write here color codes you want
## You can find codes here: http://www.lihaoyi.com/post/Ansi/Rainbow256.png
### Warning! In your terminal colors may differ

# ! better way to change colors:
#	use installer:
# sh -c "$(curl -s https://bitbucket.org/liftchampion/colorised-norminette/raw/b4272f2c2dac52b1da721ae658815c43f64e5cb2/colorised_norm_install_installer.sh)"
NORM_COLOR=10
NO_NORM_COLOR=9

python -m norminette "$@" | awk -v nc="$NORM_COLOR" -v nnc="$NO_NORM_COLOR" '
BEGIN {
    nc = "\x1b[38;5;" nc "m"
    nnc = "\x1b[38;5;" nnc "m"
    noc = "\x1b[0m"
}
{
    output = $0

    if (output ~ /OK!/)
        print nc output noc
    else if (output ~ /Error!/)
        print nnc output noc
    else
        print output
}
'
