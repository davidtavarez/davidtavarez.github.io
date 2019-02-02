---
layout: post
title:  "How to use pwndb.py"
date:   2019-02-02 01:00:00 -0400
categories:
  - Tools
tags:
  - OSINT
  - pwndb
  - python
  - leaks
---

![pwndb](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb.py.screenshot.png)
**pwndb.py** is a python command-line tool for searching leaked credentials using the Onion service with the same name. In this post I'll describe all the possible options.

## Disclaimer

```
[!] Legal disclaimer: Usage of pwndb.py for attacking targets without
prior mutual consent is illegal. It is the end user's responsibility
to obey all applicable local, state and federal laws. Developers assume
no liability and are not responsible for any misuse or damage caused.
```

### Using a single email:

`$ python pwndb.py --target testing@email.com`

![single-email](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb.py_single_email_screenshot.png)

### Using a domain name:

`$ python pwndb.py --target @testing.com`

![domain-name](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb.py_domain_screenshot.png)

### Using a file:

Example file:

```
juanpapafrancisco@gmail.com, romeoyjulietasantos@hotmail.com, dddd@email.com.do
jhonpope@vatican.com
friend@email.com, John Smith <john.smith@email.com>, Jane Smith <jane.smith@uconn.edu>
```

`$ python pwndb.py --list targets_example.txt`

![file](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb.py_file_screenshot.png)

### Using %:

`$ python pwndb.py --target testing.%`

![wildcard](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/pwndb.py_wildcard.png)