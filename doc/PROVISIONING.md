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
sudo apt-get install -y ntp vim git python3 ruby
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

See [TROUBLESHOOTING](TROUBLESHOOTING.md) for help with any issues.

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
source, you must edit (**and SAVE**) the proper .ini config file, which depends on the location of your installation, e
.g. 
`/opt/couchdb/etc/local.ini`.

The section to modify is as follows (remove the semicolon):

```
[admins]
;admin=password
```

#### Database setup
Create the the following databases: `readings`, `logs`, and `admin`.

Once created, go into 
the configuration UI using Fauxton,
and remove the `_admin` roles from both 
`Admins` and `Members` 
sections. This is the simplest way to enable access.

**NOTE: We are now running insecurely with open access to the databases.**

Our master script 
currently 
implements no authorization, therefore databases must be open in order for the system to work. For private networks, 
this setup is totally fine. *For systems with public access, you should definitely consider authorization*.

#### System configuration
Create the following document in `admin` database, and name it `config`.
```json
{
  "_id": "config",
  "threshold_low": 700,
  "threshold_high": 0,
  "poll_interval_sensor": 300,
  "poll_interval_alerts": 900
}
```

*See [README](../README.md) for explanation of configuration values*

#### Daemonizing CouchDB
If you use a package install, `systemctl` can be used to control CouchDB:
```
sudo systemctl status couchdb
sudo systemctl stop couchdb
sudo systemctl start couchdb
```

#### Final tasks
To daemonize the script, first symbolically link it
```
sudo ln -s <path-to-repo>/scripts/monitor.rb /usr/local/bin/monitor
```

#### That's it! You're done. *Enjoy the water tank monitoring system!*

## *OPTIONAL*
### Wireguard tunnel
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
sudo apt-get -y install python3-pip
sudo pip3 install RPI.GPIO
sudo pip3 install adafruit-blinka
sudo pip3 install adafruit-circuitpython-ssd1306
sudo pip3 install adafruit-circuitpython-framebuf
sudo pip3 install adafruit-circuitpython-rfm69
```

[1]: https://docs.couchdb.org/en/latest/install/unix.html#dependencies
[2]: https://docs.couchdb.org/en/latest/config/auth.html#config-admins