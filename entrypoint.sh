#!/bin/bash

# Add local user
# use USER_ID

useradd --shell /bin/bash -u ${USER_ID} -o -c "" -d /opt user
echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

exec /usr/bin/gosu user "$@"
