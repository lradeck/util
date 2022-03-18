#!/bin/sh

function check_connection() {
  host=$1
  port=$2
  echo "Host: $host"
  echo "Port: $port"
  echo "Connecting to http://$host:$port..."
  timeout 2m sh -c "until curl -s http://$host:$port; do sleep 2; done"
  if [ $? -ne 0 ]; then
    echo "Timed out."
    return 1
  else
    echo "Connected."
    return 0
  fi
}

function check_database() {
  echo "User: $1"
  echo "Pass: $2"
  echo "Host: $3"
  echo "Port: $4"
  echo "Db: $5"
  echo "Trying to connect to database..."
  timeout 2m sh -c "until psql postgresql://$1:$2@$3:$4/$5 -c '\q' > /dev/null; do sleep 2; done"
  if [ $? -eq 0 ]; then
    echo "Connected to database"
    npm start
  else
    echo "Timed out."
    echo "Exiting container."
  fi
}
