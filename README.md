# Water tank monitoring system
Multi-component system for monitoring, logging, and reporting liquid volume levels of a water tank.

## Technology
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

---

[Raspberry Pi 1 model B]: https://www.adafruit.com/product/998
[Apache CouchDB]: http://couchdb.apache.org
[Ultrasonic Sensor HC–SR04]: http://randomnerdtutorials.com/complete-guide-for-ultrasonic-sensor-hc-sr04/
[Ubiquiti Loco M2 airMAX NanoStation]: https://www.ubnt.com/airmax/nanostationm/