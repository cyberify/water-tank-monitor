# NOTES

#### Intial testing
- Leaving the system running for a year resulted in **134774** records being generated, ranging from dates 

### CouchDB
- Partial replications can be done by passing the  `since_seq` setting. **Note** that this is an Integer value corresponding the `n-th` document with which to begin replication.

## Issues encountered
### jessie
- Our first attempt to daemonize the main script under CouchDB resulted in two issues
	- the script was stuck repeatedly exiting and restarting
	- two instances of the script were kept alive for some reason

