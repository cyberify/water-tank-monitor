#
# Copyright 2017 PiTunnel
# All Rights Reserved.
#

import subprocess
import tempfile

temp_dir = tempfile.gettempdir()
hw = "pi"

print "Installing on", hw, "\nToken is hnctV3Sa3"

print "Downloading"
subprocess.call("wget -q http://pitunnel.com/static/dist/%s/tunnel_client.tgz --directory-prefix=%s -N" % (hw, temp_dir), shell=True)
# wget http://node-arm.herokuapp.com/node_latest_armhf.deb
subprocess.call("wget -q http://pitunnel.com/static/dist/%s/node_latest_armhf.deb --directory-prefix=%s -N" % (hw, temp_dir), shell=True)
# git clone https://github.com/krishnasrinivas/wetty
subprocess.call("wget -q http://pitunnel.com/static/dist/%s/wetty.tgz --directory-prefix=%s -N" % (hw, temp_dir), shell=True)

print "Shutting down any running instances of pitunnel and its agents"
pids = []
for app_name in ['pitunnel', 'monitor_device', 'wetty']:
    try:
        pids.extend(subprocess.check_output(["pidof", app_name]).strip().split(' '))
    except:
        pass
for pid in pids:
    try:
        subprocess.check_output('sudo kill -9 %s 2> /dev/null' % pid, shell=True)
    except:
        pass

print "Removing old installations"
subprocess.call("rm -rf /usr/local/lib/tunnel_client", shell=True)
subprocess.call("rm -rf /usr/local/lib/wetty", shell=True)

print "Extracting"
subprocess.call("tar -zxf %s/tunnel_client.tgz -C /usr/local/lib" % temp_dir, shell=True)
subprocess.call("tar -zxf %s/wetty.tgz -C /usr/local/lib" % temp_dir, shell=True)

print "Installing" # By creating symlinks
subprocess.call("ln -sf /usr/local/lib/tunnel_client/tunnel_client /usr/local/bin/pitunnel", shell=True)
subprocess.call("ln -sf /usr/local/lib/tunnel_client/monitor_device /usr/local/bin/monitor_device", shell=True)

print "Creating token file"
with open('/usr/local/lib/tunnel_client/tunnel_token', 'w') as f:
    f.write('hnctV3Sa3')

print "Setting up Remote Terminal"
subprocess.call("sudo dpkg -i %s/node_latest_armhf.deb" % temp_dir, shell=True)
subprocess.call("cd /usr/local/lib/wetty; npm install", shell=True)
print ""

print "Configuring Startup"
lines = []
with open('/etc/rc.local', 'r') as f:
    for line in f:
        lines.append(line)
# Backup the old rc.local
subprocess.call('mv /etc/rc.local /etc/rc.local.bak', shell=True)
# Find the correct spot in rc.local to insert the startup command
command = 'bash /usr/local/lib/tunnel_client/pitunnel_start.conf\n'
wrote_command = False
with open('/etc/rc.local', 'w') as f:
    for line in lines:
        if not wrote_command:
            if 'sh ' in line and 'pitunnel_start.conf' in line:
                # Found an existing command, so overwrite it
                f.write(command)
                wrote_command = True
            elif line.startswith('exit '):
                # Found the end of file, write out the command followed by the current line
                f.write(command)
                wrote_command = True
                f.write(line)
            else:
                f.write(line)
        else:
            f.write(line)

    if not wrote_command:
        # Didn't find anywhere to insert it, so just put it a the end
        f.write(command)
# Set the correct permissions on rc.local
subprocess.call('chmod 755 /etc/rc.local', shell=True)

print "Register the device"
subprocess.call("pitunnel --register", shell=True)

print "Starting PiTunnel"
subprocess.call('nohup bash /usr/local/lib/tunnel_client/pitunnel_start.conf >/dev/null 2>&1 &', shell=True)

print ""
print ""
print "## All done!! ##"
print "Please visit www.pitunnel.com to access your device!"
print ""