# Raspberry Pi

### Installed software
- `ruby 2.1.5 (2014-11-13 patchlevel 273) [arm-linux-gnueabihf]`
- `python 2.7.9`
- `git 2.1.4`

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

---
### TODO:
- implement deployment with `vlad` or something similar
- add `minicom` and other installed utils