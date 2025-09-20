#!/bin/bash

# Zakończ skrypt, jeśli którekolwiek polecenie zawiedzie
set -e

# Sprawdź, czy konfiguracja już istnieje
if influx config list &> /dev/null; then
  echo "InfluxDB already configured. Exiting."
  exit 0
fi

# Uruchom setup
influx setup \
  --username "$1" \
  --password "$2" \
  --org "$3" \
  --bucket "$4" \
  --retention 0 \
  --force