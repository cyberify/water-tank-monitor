# Water tank monitoring system
Multi-component system for monitoring, logging, and reporting liquid volume levels of a water tank.

## *Controller* - Raspberry Pi
**todo:** add hardware spec info here

### Provisioning (installed software)
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

**Ruby 2.1.5 (2014-11-13 patchlevel 273) [arm-linux-gnueabihf]**

## *Ubiquiti NanoStation loco M airMAX station*

## *Ultrasonic water level sensor*

## Periodic data monitoring/reporting
*pseudocode:*

---
### TODO:
- Implement security on wireless  ***loco M NanoStation*** 