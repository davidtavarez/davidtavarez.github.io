---
layout: post
title:  "Was my password leaked?"
date:   2019-01-25 18:47:00 -0400
categories:
  - OSINT
tags:
  - passwords
  - pwndb
  - python
---

![pwndb](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb_py_screenshot.png)
A data leak differs from a data breach in that the former usually happens through omission or faulty practices rather than overt action, and may be so slight that it is never detected. While a data breach usually means that sensitive data has been harvested by someone who should not have accessed it, a data leak is a situation where such sensitive information might have been inadvertently exposed. [pwndb](http://pwndb2am4tzkvold.onion/) is an onion service where **leaked accounts are searchable** using a simple form.

After a breach occurs the data obtained is often put in sell. Sometimes, people try to blackmail the affected company, asking for money in exchange of not posting the data online. The second option is selling the data to a competitor, a rival or even an enemy. This data is used in so many different ways by companies and countries... but when the people responsible for obtaining the data fails on selling it, the bundle became worthless and they end up being placed in some places like [pastebin](https://pastebin.com/) or [pwndb](http://pwndb2am4tzkvold.onion/).

### Searching for leaked credentials.

The easiest way is to search for leaked credentials, is accessing the Onion service using the url: [http://pwndb2am4tzkvold.onion/](http://pwndb2am4tzkvold.onion/) and then type the username and/or the domain name and make click on the button with the label: `email`. You should see somehting like this:

![pwndb](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb_onion_screenshot.png)

### Using the command line.

I love using the Terminal because it's faster, also I want to have more flexibility; so, I decided to create a [command-line tool](https://github.com/davidtavarez/pwndb). I'm using the same settings of Tor Browser to use Tor as a SOCKS5 proxy, so we need to have Tor Browser running or just change the IP and Port:

```python
def create_connection(address, timeout=None, source_address=None):
    sock = socks.socksocket()
    sock.connect(address)
    return sock


socks.setdefaultproxy(socks.PROXY_TYPE_SOCKS5, "127.0.0.1", 9150)

socket.socket = socks.socksocket
socket.create_connection = create_connection

import urllib2
```

Follow these steps:

```
$ git clone https://github.com/davidtavarez/pwndb
Cloning into 'pwndb'...
remote: Enumerating objects: 10, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (9/9), done.
remote: Total 10 (delta 2), reused 4 (delta 0), pack-reused 0
Unpacking objects: 100% (10/10), done.

$ virtualenv venv
New python executable in /Users/davidtavarez/pwndb/venv/bin/python
Installing setuptools, pip, wheel...done.

$ source venv/bin/activate

(venv) $ pip install -r requirements.txt
Collecting PySocks==1.6.8 (from -r requirements.txt (line 1))
Installing collected packages: PySocks
Successfully installed PySocks-1.6.8

(venv) $ python pwndb.py -h
                          _ _
                         | | |
  _ ____      ___ __   __| | |__
 | '_ \ \ /\ / / '_ \ / _` | '_ \
 | |_) \ V  V /| | | | (_| | |_) |
 | .__/ \_/\_/ |_| |_|\__,_|_.__/
 | |
 |_|


pwndb.py -u <username> -d <domain>

(venv) $ python pwndb.py -u zzzz -d gmail.com 
                          _ _
                         | | |
  _ ____      ___ __   __| | |__
 | '_ \ \ /\ / / '_ \ / _` | '_ \
 | |_) \ V  V /| | | | (_| | |_) |
 | .__/ \_/\_/ |_| |_|\__,_|_.__/
 | |
 |_|


Searching...

        ZZZZ@gmail.com : 0987654321
        ZZZZ@gmail.com : ronaldo
        ZZZz@gmail.com : 123987
        zzzz@gmail.com : 01011991
        zzzz@gmail.com : 1221
        zzzz@gmail.com : 123987
        zzzz@gmail.com : 1455881
        zzzz@gmail.com : 26262626
        zzzz@gmail.com : 711041
        zzzz@gmail.com : 850505
        zzzz@gmail.com : aaaa
        zzzz@gmail.com : asdfgh
        zzzz@gmail.com : aser234
        zzzz@gmail.com : bb102102
....

(venv) $
```

We have 2 arguments: `-u` for the username and `-d` for the domain. Note: I'm using `%` as a wildcard character at the end of each argument in order to get more results.

### have i been pwned? (bonus)

Also you can go to [https://haveibeenpwned.com/](https://haveibeenpwned.com/) to see more information:

![haveibeenpwned.com](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/haveibeenpwned_screenshot.png)

REMEMBER: If your password was leaked, **change it**. Anyhow try to not have the same password in all your services and change those credentials frequently.
