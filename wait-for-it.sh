#!/bin/bash
# wait-for-it.sh
# Ce script attend que le service MySQL soit prêt avant d'exécuter la commande suivante.

host="$1"
shift
cmd="$@"

until mysql -h"$host" -u"root" -ppassword -e "select 1" > /dev/null 2>&1; do
  echo "Attente de MySQL..."
  sleep 2
done

echo "MySQL prêt, exécution de la commande"
exec $cmd
