# File Integrity Monitor


![FIM Flow Chart](https://github.com/kennethrockson/File-Monitor/assets/110367362/8c7aebb8-a510-4f16-87be-7989835204ac)

A simple file integrity monitor written in Powershell.

## Features

* Monitors a specified directory for changes to files.
* Calculates the hash of each file and stores it in a baseline.
* Compares the current hash of each file to the baseline to detect changes.
* Alerts the user if any changes are detected.

