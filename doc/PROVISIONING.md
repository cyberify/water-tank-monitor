# Raspberry Pi Provisioning
**This documentation is for the following version OS:**


download raspberry pi OS lite (64bit)
flash to SP 32GB microsd card
use raspi config tool to configure user and host details
https://downloads.raspberrypi.org/imager/imager_latest.dmg

networking:
  - set static IP address for pi in router

```
Debian GNU/Linux 11 (bullseye)
```
## First Steps
- `sudo apt-get update`
- `sudo apt-get upgrade`
- Set the time:
  - `sudo raspi-config`
  - Select `Localisation Options` and then `Change Timezone`
  - Select `US` , and then `Pacific Ocean`
- Set a static internal IP address for the Raspberry Pi. 

## Software Installation & Setup
*Note: All of our scripts are run on the Pi as* `root`

### General
```
sudo apt-get install ntp vim git python3 ruby
```

### Ruby gems
```
sudo gem install bundler
sudo gem install httparty
```

### CouchDB
This procedures is based on [the official docs][1]. ***Be sure to update package names to match your 
system’s available package versions.***

Install dependencies
```
sudo apt-get --no-install-recommends -y install build-essential pkg-config libicu-dev libmozjs-78-dev libcurl4-openssl-dev erlang
```

***Note:*** there are often issues installing packages on micro-controllers such as the Pi or Arduino, and CouchDB in
 particular has *always* had to be built manually.

If you run into problems, the recommendation is to **manually install the 
*dependencies* of any package that is problematic.** Often times the failing software install will inform you of which 
dependencies are the cause of the problem. Attempt using `apt-get` to install dependencies (and their 
dependencies, if necessary) before manually building.

See [TROUBLESHOOTING.md](/doc/TROUBLESHOOTING.md) for help with any issues.

---
#### Install from package
```
sudo apt-get -y couchdb
```
If a regular package installation works, **GREAT!** You can skip the following section.

#### Installing from source
Download unpack, and cleanup
```
cd ~
wget https://dlcdn.apache.org/couchdb/source/3.3.2/apache-couchdb-3.3.2.tar.gz
tar zxvf apache-couchdb-3.3.2.tar.gz
rm apache-couchdb-3.3.2.tar.gz
```

Configure and build ***(using the version of SpiderMonkey you have installed)***
```
cd apache-couchdb-3.3.2
./configure --spidermonkey-version 78
make release
```

Set ownership and permissions
```
sudo chown -R couchdb:couchdb /home/couchdb
sudo find /home/couchdb -type d -exec chmod 0770 {} \;
sudo chmod 0644 /home/couchdb/etc/*
```

Create a [CouchDB admin user][2]. When installing from package, there is an interactive prompt. When installing from 
source, you must locate the proper .ini config file, which depends on the location of your installation, such as 
`/opt/couchdb/etc/local.ini`.

The section to modify is as follows (remove the semicolon):

```
[admins]
;admin=password
```

#### Daemonizing CouchDB

```shell
sudo apt-get install runit

# Create a directory where logs will be written:

sudo mkdir /var/log/couchdb
sudo chown couchdb:couchdb /var/log/couchdb

# Create directories that will contain runit configuration for CouchDB:

sudo mkdir /etc/sv/couchdb
sudo mkdir /etc/sv/couchdb/log
```

Create `/etc/sv/couchdb/log/run` :

```shell
#!/bin/sh
exec svlogd -tt /var/log/couchdb
```

*The above script determines where and how the logs will be written. See `man svlogd` for more details.*

Create `/etc/sv/couchdb/run` :

```shell
#!/bin/sh
export HOME=/home/couchdb
exec 2>&1
exec chpst -u couchdb /home/couchdb/bin/couchdb

# This script determines how exactly CouchDB will be launched. Feel free to add any additional arguments and environment variables here if necessary.

# Make scripts executable:
sudo chmod u+x /etc/sv/couchdb/log/run
sudo chmod u+x /etc/sv/couchdb/run

# Then run:
sudo ln -s /etc/sv/couchdb/ /etc/service/couchdb

sudo reboot

# You can control CouchDB service like this:
sudo sv status couchdb
sudo sv stop couchdb
sudo sv start couchdb
```

Create the the following databases: `readings`, `logs`, and `admin`.

Create the following document in the `admin` database
```json
{
    
}
```

Install the scripts
```
sudo cp -R /home/pi/water-tank-monitor/scripts /home/pi/
```

Add the following line to `/etc/crontab` to automatically run the master script on startup
`@reboot   pi  ruby /home/pi/scripts/sensor_monitor.rb`

#### ... That's it! You're done. *Enjoy the water tank monitoring system!*

## *OPTIONAL*
### Packetriot
For remote SSH access
```shell
sudo useradd pktriot 

wget https://pktriot-dl-bucket.sfo2.digitaloceanspaces.com/releases/linux/pktriot-0.9.5.arm32.tar.gz
tar -xzvf pktriot-0.9.5.arm64.tar.gz
cd pktriot-0.9.5
sudo cp pktriot /usr/bin/pktriot
cp pktriot.service /etc/service

sudo mkdir /etc/pktriot
sudo chown -R pktriot:pktriot /etc/pktriot

sudo -u pktriot pktriot configure
sudo -u pktriot pktriot edit --name "RanchPi SSH Tunnel"
sudo -u pktriot pktriot route tcp allocate
sudo -u pktriot pktriot route tcp forward --port <allocated port> --destination <Static Internal IP Address of Pi> --dstport 22

sudo -u pktriot start
```

## *OPTIONAL*
### wireguard tunnel
For remote SSH access / easy couchDB replication
```shell
sudo useradd pktriot 

wget https://pktriot-dl-bucket.sfo2.digitaloceanspaces.com/releases/linux/pktriot-0.9.5.arm32.tar.gz
tar -xzvf pktriot-0.9.5.arm64.tar.gz
cd pktriot-0.9.5
sudo cp pktriot /usr/bin/pktriot
cp pktriot.service /etc/service

sudo mkdir /etc/pktriot
sudo chown -R pktriot:pktriot /etc/pktriot

sudo -u pktriot pktriot configure
sudo -u pktriot pktriot edit --name "RanchPi SSH Tunnel"
sudo -u pktriot pktriot route tcp allocate
sudo -u pktriot pktriot route tcp forward --port <allocated port> --destination <Static Internal IP Address of Pi> --dstport 22

sudo -u pktriot start
```

## *OPTIONAL*
### wireguard tunnel
For remote SSH access / easy couchDB replication

`sudo apt install wireguard`

add `/etc/wireguard/wg0.conf`
```
# define the local WireGuard interface (client)
[Interface]

# contents of file wg-private.key that was recently created
PrivateKey = <>

# define the remote WireGuard interface (server)
[Peer]

# contents of wg-public.key on the WireGuard server
PublicKey = <>

# the IP address of the server on the WireGuard network
AllowedIPs = <>

# public IP address and port of the WireGuard server
Endpoint = <>
```

add `/lib/dhcpcd/dhcpcd-hooks/40-wgroute`:
`ip route add 10.0.100.0/24 via 10.40.0.1`


# Adafruit RFM69HCW Transceiver Radio Bonnet Setup
### Prerequisites

- Ensure both I2C and SPI are enabled by running `sudo raspi-config` and enabling them.
- Check that I2C and SPI are enabled by running `ls /dev/i2c* /dev/spi*` and looking for: `/dev/i2c-1 /dev/spidev0.0  /dev/spidev0.1` 

### Install Circuitpython & Other Libraries
```shell
sudo apt-get install python3-pip
sudo pip3 install RPI.GPIO
sudo pip3 install adafruit-blinka
sudo pip3 install adafruit-circuitpython-ssd1306
sudo pip3 install adafruit-circuitpython-framebuf
sudo pip3 install adafruit-circuitpython-rfm69
```

[1]: https://docs.couchdb.org/en/latest/install/unix.html#dependencies
[2]: https://docs.couchdb.org/en/latest/config/auth.html#config-admins