# weewx-docker 🌩🐳 #

Fork from `felddy/weewx-docker` adding support for WeatherFlow devices like the Tempest

This docker container can be used to quickly get a
[WeeWX](http://weewx.com) instance up and running.

This container has the following WeeWX extensions installed:

- [mqtt](https://github.com/weewx/weewx/wiki/mqtt)
- [weatherflow-udp](https://github.com/captain-coredump/weatherflow-udp)

## Running ##

### Running with Docker ###

Pull `felddy/weewx` from the Docker repository:

```console
docker pull ghcr.io/simonsickle/weewx-docker:release
```

## Volumes ##

| Mount point | Purpose        |
|-------------|----------------|
| `/data`     | configuration file and sqlite database storage |

## Environment Variables ##

| Variable       | Purpose | Default |
|----------------|---------|---------|
| `TIMEZONE`     | Container [TZ database name](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones#List) | `UTC` |
| `WEEWX_UID`    | `uid` the daemon will be run under | `weewx` |
| `WEEWX_GID`    | `gid` the deamon will be run under | `weewx` |

## License ##

This project is in the worldwide [public domain](LICENSE).

This project is in the public domain within the United States, and
copyright and related rights in the work worldwide are waived through
the [CC0 1.0 Universal public domain
dedication](https://creativecommons.org/publicdomain/zero/1.0/).

All contributions to this project will be released under the CC0
dedication. By submitting a pull request, you are agreeing to comply
with this waiver of copyright interest.
