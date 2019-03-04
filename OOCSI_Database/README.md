# OOCSI Database (source code)

DBSU10 (2018-3) - Tyria Team 05

OOCSI database for the Tyria World. The database saves data by retrieving a groupname, timestamp, datanames and data through [an OOCSI server](https://github.com/iddi/oocsi). This data will be mapped to a [Navigable map](https://docs.oracle.com/javase/7/docs/api/java/util/NavigableMap.html) and saved on the database. OOCSI clients can then request the data by sending a timestamp, the needed group and a request handle.
