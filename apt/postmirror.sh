#!/bin/sh -e

## anything in this file gets run AFTER the mirror has been run
## put your custom post mirror operations in here ( like rsyncing the installer files and running clean.sh automaticly )

## Example of grabbing the extra translations and installer files from ubuntu ( note rsync needs to be installed 
## and in the path for this example to work correctly )

#################
#
# define binaries
#

ECHO="/bin/echo"
DATE=`/bin/date '+%Y%m%d'`
COPY="/bin/cp -prf"
LN="/bin/ln -s"
RSYNC="/usr/bin/rsync"

#################
#
# define constants
#

REPODIR="/mnt/external/repository"
REPOTMP="/mnt/external/repository_tmp"
REPODATE=`${ECHO} ${REPODIR}${DATE}`
CODENAME="precise"

SYNCURL="ftp.riken.go.jp"
RSYNCSOURCE="rsync://${SYNCURL}/ubuntu/"
BASEDIR="${REPOTMP}/mirror/${SYNCURL}/Linux/ubuntu/dists/${CODENAME}/"
BASEDIR_UPDATES="${REPOTMP}/mirror/${SYNCURL}/Linux/ubuntu/dists/${CODENAME}-updates/"
BASEDIR_SECURITY="${REPOTMP}/mirror/${SYNCURL}/Linux/ubuntu/dists/${CODENAME}-security/"

#################
#
# main(rsync)
#

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}/ ${BASEDIR}

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}/ ${BASEDIR}

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-updates/ ${BASEDIR_UPDATES}

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-updates/ ${BASEDIR_UPDATES}

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-security/ ${BASEDIR_SECURITY}

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-security/ ${BASEDIR_SECURITY}

# move directory
${COPY} ${REPOTMP} ${REPODATE}

# make an symbolic link
# its easier to take a backup this way
${LN} ${REPODATE} ${REPODIR}

echo "aaaaaaaa" >> /tmp/aaaaa
