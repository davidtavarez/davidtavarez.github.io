---
layout: post
title:  "Building a simple encrypted cloud accessible through tor"
date:   2019-07-21 23:00:00 -0400
keywords: "python, security, tor, onion, owncloud, safer"
comments: true
description: "Storing encrypted files using tor"
---

Lately I've been playing with my Raspberry Pi and it's impressive how many cool things we can do with them. There are some blog posts explaining how to install [ownCloud](https://owncloud.org/) in the Raspberry Pi, which is nice, but I feel like, for me ownCloud it's like using a hammer to kill a mosquito. So, I decided to write my own API to upload and download files :)

## Safer
### A torifyed-dockerized RESTful API for storing encrypted files

Safer is a RESTful API written in Python using Flask which is mount it inside a docker container and it's accessible via Tor. All files are encrypted and can be only decrypted by using a **Key**; this key is generated from a *password*. In order download any file you need the *ID* of the file and the *Key*. Since the key isn't stored by the server you will need to save it by yourself. The funny thing is that a [Hidden Service](https://2019.www.torproject.org/docs/onion-services) is created and an **.onion v3** is generated.

### How it works?

![Running a Hidden Tor Service with Docker Compose](https://i.imgur.com/POdnQSA.png)

(Docker) Compose is a tool for defining and running multi-container Docker applications. With Compose, you use a Compose file to configure your application's services. Then, using a single command, you cat create and start all the services from your configuration.

I'm using Docker Compose to run a Hidden Service for the API. The URL is generated internally using (pytor)[https://github.com/cmehay/pytor]. To manage the containers you need to use a bash script called **manage** (I'm too creative! right?!):

```bash
$ bash manage -h
  _____  ____  _____  ___  ____
 / ___/ /    ||     |/  _]|    \
(   \_ |  o  ||   __/  [_ |  D  )
 \__  ||     ||  |_|    _]|    /
 /  \ ||  _  ||   _]   [_ |    \
 \    ||  |  ||  | |     ||  .  \
  \___||__|__||__| |_____||__|\_|
------------------------------------------------------------------------
Usage: manage [-h]
Usage: manage [option...] --{init|start|halt|clean|stats}

   --- MANAGEMENT ---
   -i, --init, init           Initializes the containers.
   -s, --start, start         Starts all configured services.
   -p, --halt, halt           Stops all configured services.
   -r, --reload, reload       Restart all configured services.
   -b, --rebuild, rebuild     Rebuild all configured services.
   -c, --clean, clean         Cleans containers, volumes, images.

   --- UTILITIES ---
   -o, --onion, onion         Get the onion URL.
   -h, --help, help           Shows this help box.
------------------------------------------------------------------------
```

*Docker compose should be installed.**

### Starting the service

We just need to run: `bash manage init`:

```bash
...
Creating saferapi ... done
Creating saferhiddenservice ... done

Waiting 20 seconds, tor is booting up...

Finding the .onion URL...
3acgxzofjcd5vnoe262zgnpx7ldotfvlwhiia7g7i6g7vgywosfmffqd.onion

Adding an upload function to your .bash_profile file...
Adding a download function to your .bash_profile file...
Done. Remember to do: source ~/.bash_profile
```

Now 2 functions were created: `upload` and `download`. Also we can access the url using Tor Browser to confirm if the containers are running:

![index](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/safer_onion.png)

### Uploading files.

We just need to pass 2 parameters, the path and the password to generate the key; for example we're going to upload the docker-compose.yml file:

```bash
$ upload docker-compose.yml password1234

Uploading file...
{"id": 2, "key": "AHWRnPCEwnaKPfezcEnBl6dZ0DeHx9j55DeB-Ur405g="}
Done.
```

Now we have an `id` and a `key` that we're going to use to download the file.

### Downloading files.

With the `id` and the `key` we can download the file like this:

```bash
$ download 2 "AHWRnPCEwnaKPfezcEnBl6dZ0DeHx9j55DeB-Ur405g\=" docker-compose.decrypted.yml
Downloading file...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   603  100   420  100   183    372    162  0:00:01  0:00:01 --:--:--   373

$ ls -lh
...
-rw-r--r--  1 davidtavarez  staff   420B Jul 22 23:18 docker-compose.decrypted.yml
-rw-r--r--  1 davidtavarez  staff   420B Jul 21 14:17 docker-compose.yml
...
```

It works perfectly!

### What's next?!

Well, I think this is a pretty simple and fast solution for storing some important and personal files. I truly recommend to run the service on an encrypted disk. Try it by yourself using this link: [safer](https://davidtavarez.github.io/safer/). Feel free to open an issue if you found something; also I would love some contributions too.

Stay safe!
