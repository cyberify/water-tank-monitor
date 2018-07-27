# Raspberry Pi

### Installed software
- `ruby 2.1.5 (2014-11-13 patchlevel 273) [arm-linux-gnueabihf]`
- `python 2.7.9`
- `git 2.1.4`
- `minicom`
- `miniupnpc`

### Provisioning

**Erlang (OTP 19):**
```shell
sudo apt-get update
sudo apt-get install wget
sudo apt-get install libssl-dev
sudo apt-get install ncurses-dev
wget http://www.erlang.org/download/otp_src_19.0.tar.gz
tar -xzvf otp_src_19.0.tar.gz
cd otp_src_19.0/
./configure
make
sudo make install
```

**Apache CouchDB 1.4.0**
```shell
sudo apt-get install couched
```

### CouchDB
**Config:**

- couchDB configuration file location: `/etc/couchdb/`
	- `default.ini`
	- `local.ini`

**Log Locations**

**Commands:**

- `sudo couchdb -kd` (kill couchDB)
- `sudo service couchdb status` (current status of couchdb service)


---
### TODO:
- implement deployment with `vlad` or something similar