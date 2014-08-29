#!/bin/bash
# Author: Oxnz

# show banner
cat <<End-Of-Info | sed -e 's/.\{80\}/&\n/g'
Kernel: $(uname -r)
Uptime: $(uptime)
Mail: $(/usr/sbin/sendmail -bp)
Memory:
$(free -h)
Crontab:
M H D m W command
$(crontab -l 2>&1)
End-Of-Info

cat <<"End-Of-Cow"
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
End-Of-Cow
cat <<"End-of-peek"
/*       _\|/_
         (o o)
 +----oOO-{_}-OOo-+
 |hello           |
 +---------------*/
End-of-peek
