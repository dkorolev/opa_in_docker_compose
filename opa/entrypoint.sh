#!/bin/bash

rm -f /shared/.stop

echo -n "Starting OPA ..."
opa run --server -l error &
OPA_PID=$!

function cleanup()
{
  if [ "$OPA_PID" != "" ] ; then
    echo
    echo -n "Stopping OPA ..."
    kill $OPA_PID
    echo -e "\b\b\b\b: Done."
    OPA_PID=""
  fi
}

trap cleanup SIGINT SIGTERM SIGQUIT

echo -e "\b\b\b\b: PID=${OPA_PID}"
echo

HEALTHY=false
for i in $(seq 30); do
  if [ "$(curl -s localhost:8181/health)" == "{}" ] ; then
    HEALTHY=true
    break
  fi
  sleep 0.1
done

if [ "$HEALTHY" != "true" ] ; then
  echo
  echo "The OPA server did not start."
  cleanup
  exit 1
else
  echo
  echo "The OPA server is ready."
  touch .opa_up
fi

while ! [ -f /shared/.stop ] ; do
  sleep 1
done

cleanup
