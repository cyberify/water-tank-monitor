# Water tank monitoring system
Multi-component system for monitoring, logging, and reporting liquid volume levels of a water tank.

### Tank specs
This project is based off a 'B-3500' tank with *3500* gallon capacity, *8'6"* diameter, and *14'6"* length.

**todo: volume calculations**

**Note**: current tank specs are stored in CouchDB at 

## Hardware
#### [Ultrasonic Sensor HC–SR04]
Water level is measured using an ultrasonic sensor suspended vertically inside the tank. Due to the ambient humidity, the sensor must be protected adequately, or it risks corrosion. ***todo: add more detail here***

#### [Raspberry Pi 1 model B]
The system is controlled from a Raspberry Pi configured to run continuously as long as there is power. It periodically collects depth measurements from connected sensor(s). A local instance of [Apache CouchDB] is used to persist the data (and replicate to off-site mirror), provide views for displaying records as a simple web page, and maintain daemonized script(s).

#### POWER
- Power for the system is provided via `100W` pole-mounted solar panels.
- A `12V` Deep Cycle battery functions as power source when weather conditions are unfavorable.
- ***todo: add charge controller info***

#### [Ubiquiti Loco M2 airMAX NanoStation]
A pole-mounted NanoStation provides line-of-sight access to the wireless LAN, enabling network connectivity for the Pi.

## Software, libraries, and packages
- Ruby 2
    - `activesupport`
    - `activesupport-core-ext`
    - `couchrest_model`
    - `vlad` ***(deployment only)***
- Python
- CouchDB

## Installation & Deployment

### HARDWARE
**todo:** document hardware setup process (add photos if possible)

#### Ubiquiti Loco M2 airMAX NanoStation
- ***IP: https://192.168.1.21***
- Credentials:
    - user: `ubnt`
    - password: `ubnt`

### SOFTWARE (see: [`provisioning.md`](doc/provisioning.md))

## Data
#### Conventions
- Underscores are used to delineate words in keys (as oppposed to *hyphens*)

---
#### Resources
##### CouchDB
- https://www.dimagi.com/blog/what-every-developer-should-know-about-couchdb/
- https://pouchdb.com/2014/05/01/secondary-indexes-have-landed-in-pouchdb.html
- https://stackoverflow.com/questions/4812235/whats-the-best-way-to-store-datetimes-timestamps-in-couchdb
- https://developer.ibm.com/dwblog/2015/defensive-coding-mapindex-functions/
- https://stackoverflow.com/questions/2587345/why-does-date-parse-give-incorrect-results/2587398#2587398
- [cloud hosting option 1](https://bitnami.com/stack/couchdb/cloud)
- [cloud hosting option 2](https://www.smileupps.com/store/apps/couchdb)

##### Pi & networking
- Raspberry Pi site: https://www.modmypi.com/blog/hc-sr04-ultrasonic-range-sensor-on-the-raspberry-pi
- MaxBotix sensor website http://www.maxbotix.com/articles/074.htm
- http://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
- http://www.instructables.com/id/Measuring-water-level-with-ultrasonic-sensor/
- https://www.raspberrypi.org/forums/viewtopic.php?p=376722
- Troubleshooting connection to Sensor https://www.raspberrypi.org/forums/viewtopic.php?f=32&t=120112
- networking with raspberry Pi
  - https://pavelfatin.com/access-your-raspberry-pi-from-anywhere/
  - https://pihw.wordpress.com/guides/direct-network-connection/
  - http://stackoverflow.com/questions/16040128/hook-up-raspberry-pi-via-ethernet-to-laptop-without-router
- networking & SSH materials
  - BEST GUIDES: https://help.github.com/categories/ssh/
  - http://serverfault.com/questions/241588/how-to-automate-ssh-login-with-password
  - http://www.rebol.com/docs/ssh-auto-login.html
  - http://net-ssh.github.io/ssh/v1/chapter-2.html#s2 (ruby interface)

[Raspberry Pi 1 model B]: https://www.adafruit.com/product/998
[Apache CouchDB]: http://couchdb.apache.org
[Ultrasonic Sensor HC–SR04]: http://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
[Ubiquiti Loco M2 airMAX NanoStation]: https://www.ubnt.com/airmax/nanostationm/
