# TestConnect port ping
Script that uses the 'nc' command in a loop to test connection to a specific port on a host

You can costumize a few default settings, including the saved hosts and port keywords, right in the beginning of the script
## Usage

```
Usage:  ./TestConnect.sh <host> <port> [time_interval]

  - The time interval between each test is an optional argument and it's in seconds. Default value is 2 seconds.



These are the keywords for saved hosts:
    goog          =    google.com
    one           =    1.1.1.1

These are the keywords for saved ports that this script acceps:
    ssh           =    22
    https-alt     =    8443
    https         =    443
    vnc           =    5900
    http          =    80
    rdp           =    3389
    http-alt      =    8080
```

## Screenshots

![example_sucess.png](/screenshots/example_sucess.png)
![example_failure.png](/screenshots/example_failure.png)
