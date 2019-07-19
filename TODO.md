# TODO:

### Essential setup
- set up Pi for remote SSH access
- double check CouchDB config settings
- get the app running!!!
- set up hosted couchDB instance using [smileupps][]

### PRIMARY FEATURES TO IMPLEMENT
- derive and store tank **volume** measurements from distance measurement
- add email alert for low water levels
- record date/time data for intervals during which the Pi is offline (this is in order to acquire data pertaining to 'down time' the system experiences from power loss due to weather conditions)

### Web
- create basic web page to present data

### Ruby
- deployment via `vlad`
- **get `couchrest_model` working**

---
### Additional feature/enhancement ideas
- read/record battery charge levels to evaluate solar panel efficacy
- implement more precise loop control (use something like [eventmachine](http://javieracero.com/blog/starting-with-eventmachine-iv))
- implement security on wireless  ***loco M NanoStation***



[smileupps]: https://www.smileupps.com/store/apps/couchdb
