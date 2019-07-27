# Raspberry Pi Provisioning

### Operating System Details
```shell
pi@raspberrypi:~/radio $ cat /etc/os-release 
PRETTY_NAME="Raspbian GNU/Linux 10 (buster)"
NAME="Raspbian GNU/Linux"
VERSION_ID="10"
VERSION="10 (buster)"
VERSION_CODENAME=buster
ID=raspbian
ID_LIKE=debian
HOME_URL="http://www.raspbian.org/"
SUPPORT_URL="http://www.raspbian.org/RaspbianForums"
BUG_REPORT_URL="http://www.raspbian.org/RaspbianBugs"
```

```shell
pi@raspberrypi:~/radio $ uname -a
Linux raspberrypi 4.19.58-v7+ #1245 SMP Fri Jul 12 17:25:51 BST 2019 armv7l GNU/Linux
```
#### First Steps
- `sudo apt-get update`
- `sudo apt-get upgrade`
- Set the time:
  - `sudo raspi-config`
  - Select `Localisation Options` and then `Change Timezone`
  - Select `US` , and then `Pacific Ocean`
- Set a static internal IP address for the Raspberry Pi. 

### Software Installation & Setup
#### General
```shell
sudo apt-get install ntp
sudo apt-get install vim
sudo apt-get install git
sudo apt-get install python3
sudo apt-get install ruby
```

**Install ruby gems:**
- `sudo gem install httparty`
- `sudo gem install bundler`

##### CouchDB
```shell
# add Erlang Solutions repository and public key
wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc
sudo apt-get update

# install all build dependencies - note mutiple lines
sudo apt-get --no-install-recommends -y install \
build-essential pkg-config erlang libicu-dev \
libmozjs185-dev libcurl4-openssl-dev

#add couchdb user and home
sudo useradd -d /home/couchdb couchdb
sudo mkdir /home/couchdb
sudo chown couchdb:couchdb /home/couchdb

# Get source - need URL for mirror (see post instructions, above)
wget http://apache.cs.utah.edu/couchdb/source/2.3.1/apache-couchdb-2.3.1.tar.gz

# extract source and enter source directory
tar zxvf apache-couchdb-2.3.1.tar.gz 
cd apache-couchdb-2.3.1/

# configure build and make executable(s)
./configure
make release

#copy built release to couchdb user home directory
cd ./rel/couchdb/
sudo cp -Rp * /home/couchdb
sudo chown -R couchdb:couchdb /home/couchdb
cd /home/couchdb/etc
```

**Daemonizing CouchDB**

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
#### Packetriot
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


### Adafruit RFM69HCW Transceiver Radio Bonnet Setup
#### Prerequisites

- Ensure both I2C and SPI are enabled by running `sudo raspi-config` and enabling them.
- Check that I2C and SPI are enabled by running `ls /dev/i2c* /dev/spi*` and looking for: `/dev/i2c-1 /dev/spidev0.0  /dev/spidev0.1` 

#### Install Circuitpython & Other Libraries
```shell
sudo apt-get install python3-pip
sudo pip3 install RPI.GPIO
sudo pip3 install adafruit-blinka
sudo pip3 install adafruit-circuitpython-ssd1306
sudo pip3 install adafruit-circuitpython-framebuf
sudo pip3 install adafruit-circuitpython-rfm69
```