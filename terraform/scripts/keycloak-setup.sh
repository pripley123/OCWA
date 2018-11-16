#!/bin/bash -e

export KEYCLOAK_HOME=`pwd`/keycloak
export PATH=$PATH:$KEYCLOAK_HOME/bin

keycloak/bin/kcadm.sh config credentials --server http://ocwa_keycloak:8080/auth --realm master --user $KEYCLOAK_USER --client admin-cli --password $KEYCLOAK_PASSWORD

keycloak/bin/kcadm.sh create realms -s realm=ocwa -s enabled=true -o

CID=$(kcadm.sh create clients -r ocwa -s clientId=outputchecker -s "redirectUris=[\"http://*\",\"https://*\"]" -i)

kcadm.sh get clients/$CID -r ocwa

kcadm.sh create users -r ocwa -s username=testuser -s enabled=true
kcadm.sh set-password -r ocwa --username testuser --new-password $TESTUSER_PASSWORD
