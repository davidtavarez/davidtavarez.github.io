---
layout: post
title:  "Setting up Alfa AWUS1900 in Raspberry Pi (Re4son Kernel)"
date:   2018-09-09 12:03:00 -0400
categories:
  - Tools
tags:
  - raspbian
  - linux
  - alfa
  - raspbian
  - re4son
---

I was playing a little bit with my old Raspberry Pi and recently I bought a USB Wi-fi adapter, the Alfa AWUS1900 (the one with four antennas). So, I decided to setting up the Pi to test this Wi-fi adapter. I know that on Kali Linux we just have to run `# apt-get install realtek-rtl88xxau-dkms`, but on the Raspberry Pi is not that straight forward because we need to compile the drivers for the ARM chip. I must say that the last **Raspbian Stretch Lite** works just fine and better with the Re4son-Kernel. Some interesting Re4son "*current stable*" Kernel highlights are:

- Raspberry Pi 3 B+ support
- Supports armel (Pi 1, Zero, Zero W) and armhf (Pi 2, 3)
- Linux kernel 4.14.50
- Includes wifi injection patch, use mon0up to start monitor, mon0down to stop
- RTL8188EU driver (TL-WN722N v2) with monitor mode support
- RTL8812AU & RTL8811 & **RTL8814AU** with *monitor & injection* support

You can see more about Re4son Kernel [here](https://re4son-kernel.com/re4son-pi-kernel/) and if you want to install Kali just watch [this video from NullByte](https://www.youtube.com/watch?v=5ExWmpFnAnE)

### Let's begin! ###

## System base: Raspbian Stretch Lite ##

Like I said before, I'm using Raspbian Stretch Lite. For a while I'm noticing that I never use the Desktop Enviroment anymore, so I have installed the Lite version of Raspbian Stretch. If you want to give a try just go [here](https://www.raspberrypi.org/downloads/raspbian/) and follow the [Installation Guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md).

## Re4son Kernel ##

My first attempt was to compile the driver over a fresh installation of Raspbian Stretch Lite (Linux kernel 4.14.50+), but although I did compile the drivers and the device was installed, I was not able to get authenticated into any Access Point. If you are also at this point, *Re4son Kernel* is the solution. Installing this kernel is easy:

```
$ sudo su
# cd /usr/local/src
# wget  -O re4son-kernel_current.tar.xz https://re4son-kernel.com/download/re4son-kernel-current/
# tar -xJf re4son-kernel_current.tar.xz
# rm re4son-kernel_current.tar.xz &&cd re4son-kernel_4*
# ./install.sh
# reboot
```

Now, you should be able to see `wlan1` with `ifconfig`.

## RTL8814AU ##

Now we need install our drivers. This repo from the **aircrack-ng** team works pretty good, and the installation is also really easy:

```
$ sudo apt install raspberrypi-kernel-headers bc
$ git clone https://github.com/aircrack-ng/rtl8812au
$ cd rtl8812au
$ make RTL8814=1 ARCH=arm
$ sudo make install RTL8814=1 ARCH=arm
$ sudo reboot
```

Adding `RTL8814=1 ARCH=arm` is crucial, becuase without the `make` command will to find the linux headers for `armv7l` and it won't find them.

## Bonus: Connecting to WPA/WP2 network from the terminal ##

With a fresh installation of Raspbian Stretch Lite we don't have a Desktop Enviroment. I created a small bash script to connect to a Access Point, but first we need to generate the config a save it to a file:

```
$ mkdir conf
$ wpa_passphrase <ssid> [passphrase] > ./conf/[FILE].conf
```

Alsa, I want to see the logs:

```
$ mkdir logs
```

Now, save this script whereever you want as wifi_connect_SSID.sh:

```bash
#!/bin/bash
if [ -z "$1" ]
    then
        echo "No arguments supplied."
  exit 1
fi

INTERFACE=$1
sudo killall wpa_supplicant > /dev/null 2>&1 &
sudo ifconfig $INTERFACE up
sudo wpa_supplicant -i $INTERFACE -D nl80211 -c /home/pi/conf/[FILE].conf >  /home/pi/logs/wifi.logs.txt 2>&1 &
```

Note: I have a config file for each ssid.

```
$ chmod a+x wifi_connect_SSID.sh
```

And finally run the script as follow:

```
$ ./wifi_connect_SSID.sh wlan1
```

Change `wlan1` for your interface.

If everything is done right you can have an IP and be able to navigate:

```
pi@raspberrypi:~ $ ifconfig wlan1
wlan1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.5  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::2280:ace0:2f01:a299  prefixlen 64  scopeid 0x20<link>
        ether 00:c0:ca:96:77:c4  txqueuelen 1000  (Ethernet)
        RX packets 587  bytes 73762 (72.0 KiB)
        RX errors 0  dropped 6  overruns 0  frame 0
        TX packets 428  bytes 68216 (66.6 KiB)
        TX errors 0  dropped 13 overruns 0  carrier 0  collisions 0
```
pi@raspberrypi:~ $ ping -c4 bing.com
PING bing.com (204.79.197.200) 56(84) bytes of data.
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=1 ttl=113 time=72.3 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=2 ttl=113 time=69.7 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=3 ttl=113 time=74.4 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=4 ttl=113 time=72.4 ms

--- bing.com ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 69.723/72.239/74.433/1.705 ms
pi@raspberrypi:~ $
```
