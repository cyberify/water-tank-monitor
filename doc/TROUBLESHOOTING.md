# Issues Encountered
### Installing CouchDB
Nearly all of the problems we ran into when provisioning were related to installing CouchDB. It has a ton of 
dependencies, many of which are quite old and even out of date, and it is likely that if there is a `couchdb` package
 available for your system, it won't install properly due to some dependency failing.
- **SpiderMonkey**
- **Erlang** failed to install from the `erlang` package using `apt-get`
  - Cause uknown, `apt-get` reported that several dependencies were impossible to install, due to *their* 
  dependencies being unable to install.
  - **SOLUTION:** we were able to use `apt-get` to install the failing dependencies-of-dependencies of `erlang`, 
  then the dependencies of `erlang`, then `erlang`, in that order.

### Raspberry Pi - `jessie`
- Our first attempt to daemonize the main script under CouchDB resulted in two issues
	- The script was stuck repeatedly exiting and restarting
	- Two instances of the script were kept alive for some reason