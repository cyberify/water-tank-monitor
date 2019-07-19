#!/bin/bash

# Based on: http://www.tunnelsup.com/raspberry-pi-phoning-home-using-a-reverse-remote-ssh-tunnel

createTunnel() {
  /usr/bin/ssh -o ServerAliveInterval=5 -o ServerAliveCountMax=1 -N -R 0.0.0.0:2222:localhost:22 fwd1@RemoteHost
  if [[ $? -eq 0 ]]; then
    echo Tunnel to jumpbox created successfully
  else
    echo An error occurred creating a tunnel to jumpbox. RC was $?
  fi
}

/bin/pidof ssh
if [[ $? -ne 0 ]]; then
  echo Creating new tunnel connection
  createTunnel
fi
