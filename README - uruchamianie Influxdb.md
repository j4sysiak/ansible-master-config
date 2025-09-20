

url do konsoli bazy:    
# http://130.61.228.18:8086

hasło / login   (roles/influxdb/defaults/main.yml)
--------------------------------------------------
jacek / jacekjacek

******************************************


3 packages can be upgraded. Run 'apt list --upgradable' to see them.
ubuntu@ansible-arm-01:~$ systemctl status influxdb
● influxdb.service - InfluxDB is an open-source, distributed, time series database
     Loaded: loaded (/lib/systemd/system/influxdb.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2025-09-19 22:12:51 UTC; 39s ago
       Docs: https://docs.influxdata.com/influxdb/
    Process: 13643 ExecStart=/usr/lib/influxdb/scripts/influxd-systemd-start.sh (code=exited, status=0/SUCCESS)
   Main PID: 13644 (influxd)
      Tasks: 13 (limit: 38435)
     Memory: 47.6M
        CPU: 338ms
     CGroup: /system.slice/influxdb.service
             └─13644 /usr/bin/influxd

Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.600984Z lvl=info msg="Open s>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.601022Z lvl=info msg="Open s>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.601040Z lvl=info msg="Starti>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.601045Z lvl=info msg="Starti>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.601504Z lvl=info msg="Starti>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.603896Z lvl=info msg="Config>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.608833Z lvl=info msg=Startin>
Sep 19 22:12:50 ansible-arm-01 influxd-systemd-start.sh[13644]: ts=2025-09-19T22:12:50.608931Z lvl=info msg=Listeni>
Sep 19 22:12:51 ansible-arm-01 influxd-systemd-start.sh[13643]: InfluxDB started



ubuntu@ansible-arm-01:~$ ss -tlpn | grep 8086
LISTEN 0      4096                    *:8086             *:*
