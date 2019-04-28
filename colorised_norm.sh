# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    colorised_norm.sh                                  :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ggerardy <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2019/04/25 18:53:10 by ggerardy          #+#    #+#              #
#    Updated: 2019/04/28 19:33:19 by ggerardy         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/usr/bin/env bash

# Write here color codes you want
## You can find codes here: http://www.lihaoyi.com/post/Ansi/Rainbow256.png
### Warning! In your terminal colors may differ
NORM_COLOR=184
NO_NORM_COLOR=200

norminette $* | awk -v nc="$NORM_COLOR" -v nnc="$NO_NORM_COLOR" '
BEGIN {buf = "lol"}
{
    if (buf != "lol" && $1 == "Norme:")
    {
        if (buf ~ /Norme:*/)
			print "\x1B[38;5;" nc "m" buf "\x1B[0m"
        else
            print buf
    }
    else if (buf != "lol")
    {
        if (buf ~ /Norme:*/)
            print "\x1B[38;5;" nnc "m" buf "\x1B[0m"
        else
            print buf
    }
    buf = $0
}
END {
    if (buf != "lol")
    {
        if (buf ~ /Norme:*/)
        {
            print "\x1B[38;5;" nc "m" buf "\x1B[0m"
        }
        else
        {
            print buf
        }
    }
}
'
