# Water Tank Monitoring System
This is a multi-component system for monitoring, logging, and reporting the liquid volume levels of an external water 
tank.

### Contents
- [General Usage](#general-usage)
- [Hardware](#hardware)
- [Software](#software)
- [Installation & Deployment](#installation--deployment)
- [Configuration](#configuration)
- [Notes](#notes)
- [Resources](#resources)
- [Contribution](#contribution)
- [License](#license)

---
# General Usage
Follow the hardware and software installation guides, and see [NOTES](doc/NOTES.md) for more information.

#### Web View
*Coming soon*

#### CouchDB / Fauxton
Access the database at: http://0.0.0.0:5984/_utils

### Tank specs
This project is based off a *B-3500* horizontal capsule tank with *3200* (imperial) gallon capacity, *7'6"* diameter, and *14'6"* length.

**Note**: current tank specs are stored in CouchDB 

# Hardware
#### [Ultrasonic Sensor HC–SR04]
Water level is measured using an ultrasonic sensor suspended vertically inside the tank. Due to the ambient humidity, the sensor must be protected adequately, or it risks corrosion. ***todo: add more detail here***

#### [Raspberry Pi 1 model B]
The system is controlled from a Raspberry Pi configured to run continuously as long as there is power. It periodically collects depth measurements from connected sensor(s). A local instance of [Apache CouchDB] is used to persist the data (and replicate to off-site mirror), provide views for displaying records as a simple web page, and maintain daemonized script(s).

#### POWER
- Power for the system is provided via `100W` pole-mounted solar panels.
- A `12V` Deep Cycle battery functions as power source when weather conditions are unfavorable.
- ***todo: add charge controller info***

# Software
- Ruby 2.7
    - `activesupport`
    - `activesupport-core-ext`
    - `couchrest_model`
- Python 3
- CouchDB 3
  - Erlang OTP (24.x, 25.x)
  - ICU
  - OpenSSL
  - Mozilla SpiderMonkey (1.8.5, 60, 68, 78, 91)
  - GNU Make
  - GNU Compiler Collection
  - libcurl

# Installation & Deployment
### HARDWARE

There are two hardware stations that are part of this project.
There is the remote, off-grid station, and there is the local, on-grid station.

The remote station is powered by a solar panel connected to a charge controller and a marine battery. There is a Feather M4 Express microcontroller connected to both a radio transceiver and ultrasonic sensor. The Feather M4 polls the sensor, gets the distance to the water level, and uses that radio connected to a directional Yagi antenna to beam the water level data to the local site. 

The local station utilizes a Raspberry Pi 4 with an attached radio transceiver, running CouchDB and a script that continually listens for data from the remote system. Upon receiving data, the water level is logged to the CouchDB database, and logic to check for low water levels will trigger a script that messages a Telegram group.

The core components at the remote station:
- [Feather M4 Express](https://www.adafruit.com/product/3857)
- [Radio Transceiver](https://www.adafruit.com/product/3229)
- [Connecting Board](https://www.adafruit.com/product/3417)
- [Yagi Antenna](https://a.co/d/9ARyaSF)
- [Datasheet of kind of ultrasonic sensors used](https://maxbotix.com/pages/xl-maxsonar-wr-datasheet) 

The core components at the local station:
- [Raspberry Pi 4](https://www.adafruit.com/product/4296)
- [Pi Radio Transceiver](https://www.adafruit.com/product/4072)
- [Spring Antenna (or similar)](https://www.adafruit.com/product/4269)


### SOFTWARE
#### See [PROVISIONING](doc/PROVISIONING.md) for instructions.

# Configuration
Once setup, you will most likely want to specify custom parameters for your system. Do so by editing the `config` 
document in the `admin` database. Add the following values:

- `poll_interval_sensor`

  Number of **Seconds** between water level sensor readings
  
- `poll_interval_alerts`

  Number of **Seconds** to wait between generating alerts
  
- `threshold_low`

  Generate an alert if water is at or below this level in **Millimeters**
  
# Notes
### Conventions
- **Underscores** are used to delineate words in *keys* (as oppposed to **hyphens**)

# Resources
##### CouchDB
- https://pouchdb.com/2014/05/01/secondary-indexes-have-landed-in-pouchdb.html
- https://stackoverflow.com/questions/4812235/whats-the-best-way-to-store-datetimes-timestamps-in-couchdb
- https://stackoverflow.com/questions/2587345/why-does-date-parse-give-incorrect-results/2587398#2587398
- [cloud hosting option 1](https://bitnami.com/stack/couchdb/cloud)

##### Pi, sensors, and networking
- Raspberry Pi sensor: https://www.modmypi.com/blog/hc-sr04-ultrasonic-range-sensor-on-the-raspberry-pi
- http://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
- http://www.instructables.com/id/Measuring-water-level-with-ultrasonic-sensor/
- https://www.raspberrypi.org/forums/viewtopic.php?p=376722
- Troubleshooting connection to Sensor https://www.raspberrypi.org/forums/viewtopic.php?f=32&t=120112

# Contribution
We would be thrilled to have you considering contributing to our project! Whether you're a seasoned developer or just getting started, your contributions are incredibly valuable and can make a significant impact.

If you have any new features, bug fixes, or enhancements in mind, don't hesitate to dive in and submit a pull request. We welcome all ideas and encourage you to share your creativity and expertise!

# License
#### We use the GNU v3 public license. See [LICENSE](LICENSE).

[Raspberry Pi 1 model B]: https://www.adafruit.com/product/998
[Apache CouchDB]: http://couchdb.apache.org
[Ultrasonic Sensor HC–SR04]: http://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
[Ubiquiti Loco M2 airMAX NanoStation]: https://www.ubnt.com/airmax/nanostationm/
