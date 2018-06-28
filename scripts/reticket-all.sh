#!/bin/sh

## FIXME!!
MYREPO=${HOME}/src/icu-git/repos/icu

if [ ! -d  ${MYREPO} ];
then
    echo no such dir: ${MYREPO}
    echo fix MYREPO
    exit 1
fi

MYREPO=file://${MYREPO}

RETICKET="./reticket"

# ICU 63
${RETICKET} -d ${MYREPO} -r 41507 -f 13788 -t 13778 # jefgen

# ICU 62
${RETICKET} -d ${MYREPO} -r 41339 -f 13034 -t 13035 # shane
${RETICKET} -d ${MYREPO} -r 41436 -f 11230 -t 13717 # shane
${RETICKET} -d ${MYREPO} -r 41437 -f 11230 -t 13717 # shane
${RETICKET} -d ${MYREPO} -r 41438 -f 11230 -t 13717 # shane
${RETICKET} -d ${MYREPO} -r 41439 -f 11230 -t 13717 # shane
${RETICKET} -d ${MYREPO} -r 41440 -f 11230 -t 13717 # shane

# ICU 61
${RETICKET} -d ${MYREPO} -r 39054 -f 12517 -t 12617 # ccornelius

# ICU 60
${RETICKET} -d ${MYREPO} -r 40472 -f 11372 -t 13372 # yoshito

# ICU 59
${RETICKET} -d ${MYREPO} -r 39977 -f 39974 -t 13088 # shane
${RETICKET} -d ${MYREPO} -r 39907 -f 13003 -t 13002 # ccornelius

# ICU 59m1
${RETICKET} -d ${MYREPO} -r 39385 -f 12572 -t 12752 # srl

# ICU 59m1
${RETICKET} -d ${MYREPO} -r 39352 -f 12796 -t 12706 # nrunge


# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41507 -f 13788 -t 13778
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41339 -f 13034 -t 13035
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41436 -f 11230 -t 13717
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41437 -f 11230 -t 13717
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41438 -f 11230 -t 13717
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41439 -f 11230 -t 13717
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 41440 -f 11230 -t 13717
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 39054 -f 12517 -t 12617
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 40472 -f 11372 -t 13372
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 39977 -f 39974 -t 13088
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 39907 -f 13003 -t 13002
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 39385 -f 12572 -t 12752
# ./reticket -d /home/srl/src/icu-git/repos/icu -r 39352 -f 12796 -t 12706
