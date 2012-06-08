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
MV="/bin/mv"
LN="/bin/ln -s"
RSYNC="/usr/bin/rsync"

#################
#
# define constants
#

REPODIR="./mnt/external/repository"
REPOTMP="./mnt/external/repository_tmp"
REPODATE=`${ECHO} ${REPODIR}${DATE}`
CODENAME="precise"

RSYNCSOURCE="rsync://jp.archive.ubuntu.com/ubuntu"
BASEDIR="${REPODIR}/mirror/archive.ubuntu.com/ubuntu/"

#################
#
# main(rsync)
#

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}/ ${BASEDIR}/dists/${CODENAME}/

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}/ ${BASEDIR}/dists/${CODENAME}/

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-updates/ ${BASEDIR}/dists/${CODENAME}-updates/

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-updates/ ${BASEDIR}/dists/${CODENAME}-updates/

${RSYNC} --recursive --times --links --hard-links \
      --exclude "Packages*" --exclude "Sources*" --exclude "Release*" --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-security/ ${BASEDIR}/dists/${CODENAME}-security/

${RSYNC} --recursive --times --links --hard-links --delete --delete-after --no-motd \
      ${RSYNCSOURCE}/dists/${CODENAME}-security/ ${BASEDIR}/dists/${CODENAME}-security/

# move directory
${MV} -p ${REPOTMP} ${REPODATE}

# make an symbolic link
# its easier to take a backup this way
${LN} ${REPODATE} ${REPODIR}

