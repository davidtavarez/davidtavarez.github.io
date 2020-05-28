---
layout: post
title: "Bypassing Internet Censorship to receive Grins via Grin++"
date: 2020-05-28 20:20:00 -0400
keywords: "grin++, grin, tor, onion, censorship"
comments: true
description: "How to bypass censorship to receive Grins via Grin++ and Tor"
---

With [Grin](http://grin.mw), users are able to send and receive money via **Files** and [**Tor**](https://lifehacker.com/what-is-tor-and-should-i-use-it-1527891029). Users from countries with high levels of censorship usually face issues trying to receive coins because Tor is unable to establish a connection with a relay. Tor relays are also referred to as "routers" or "nodes", they receive traffic on the Tor network and pass it along.

### Is my Grin++ Wallet Unavailable (or not reachable)?

When you login into your account, [Grin++](https://grinplusplus.github.io/) gives you an address, this "address" can be used to receive Grins from any Exchange and/or user. Grin++ will run a periodical check to validate if the address is reachable from other wallets.

![checking](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/photo5080116429453371532.jpg)

If your wallet is not reachable, the URL will turn orange after a while.

![failed](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/photo5080116429453371534.jpg)

To fix this, we will need to tell Grin++ to use **Bridges**. Bridges are Tor relays which are not publicly listed as part of the Tor network. Bridges are essential censorship-circumvention tools in countries that regularly block the IP addresses of all publicly listed Tor relays, such as China.

These are the **5 easy steps** to bypass the censorship:

1. Close Grin++, wait a moment to make sure the background program is completely closed.

2. Open the file manager and find the folder Tor according to the path `~/.GrinPP/MAINNET/TOR/` (macOS/Linux) or `%userprofile%/.GrinPP/MAINNET/TOR` (Windows 7/8/10).

3. Create a file named `.torrc`, and save it to this directory. Note that the file format is `.torrc`, not a `.txt` file.

4. Open your Web Browser and go to [https://bridges.torproject.org/options](https://bridges.torproject.org/options) and follow the instructions.

5. Copy each line starting with `Bridge` and copy these line to the `.torrc` file. Add `UseBridges 1` at the end of the file; you should have something like this:

```
Bridge obfs4 <IP-address 1:port 1> <Fingerprint of bridge 1>
Bridge obfs4 <IP-address 2:port 2> <Fingerprint of bridge 2>
Bridge obfs4 <IP-address 3:port 3> <Fingerprint of bridge 3>
UseBridges 1
```

When you are ready, open Grin++ again; if the http address continues to appear orange, please wait for a while, and it should automatically turn green and will look like this:

![good](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/photo5080116429453371533.jpg)

Author: **1478 8930**.
