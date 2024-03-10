# Project Notes
## Hardware concerns
The water tank environment is humid, so be extra careful to ensure that an airtight seal is used around the sensor mount, to protect it from corrosion and water damage.

## Initial testing
- Leaving the system running for a year resulted in **134774** records being generated. 

## CouchDB
- Partial replications can be done by passing the  `since_seq` setting, an integer value 
corresponding the `n-th` document to begin replication with.
