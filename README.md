# Water tank monitoring system
Multi-component system for monitoring, logging, and reporting liquid volume levels of a water tank.

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

## Software & packages
- Ruby 2
    - `activesupport`
    - `activesupport-core-ext`
    - `vlad` ***(deployment only)***
- Python
- CouchDB

## Installation & Deployment
**NOTE**: `couchrest_model` required an older version of `activesupport`, so `4.2.6` was installed.

---
#### Resources
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