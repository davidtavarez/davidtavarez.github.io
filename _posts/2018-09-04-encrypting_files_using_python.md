---
layout: post
title:  "Encrypting files using Python"
date:   2018-09-04 19:50:00 -0400
categories:
  - Code
tags:
  - python
  - encryption
  - security
---

We all need to keep our files safe; no matter what you do for living, some people say that everybody has secrets. It's countless how many times friends and family approached me when they just bought (or "found") a new laptop or hard drive and they need to format everything and reinstall the operative system. In a more serious example, as a social and political activist, I've witnessed how the State chases the social activists, burst in their houses and steal all electronic devices. This is a matter of concern because the State tends to use anything to put pressure on activists or even prosecute them.

I don't want to wait until we finally build a perfect world; in the meantime I want to be prepared, so I try to do my job and keep my privacy safe. I found some code out there and I added some more to use it as a command line scrypt to encryp and decrypt files.

### Let's do it! ###

First of all, please install the requirement:

`$ pip install pycrypto`

After that, you can get the scrypt from my [gists](https://gist.github.com/davidtavarez/3ab6ab9ddd36dd501ed9e3c06c53210d).

```
$ chmod a+x safer.py
$ ./safer.py -h
usage: safer.py [-h] -a A -p P -k K [-e E]

optional arguments:
  -h, --help           show this help message and exit
  -a A, -action A      Action encrypt/decrypt.
  -p P, -path P        Starting path.
  -k K, -key K         Key used to encrypt/decrypt.
  -e E, -extensions E  Only parse these types of files.
```

Now we need to generate a key...

```
$ openssl rand -hex 16
6dFdTEsz8BM0iMUPyuAtWeLSf/4DdPY72wfcOsPk9L8=
```

Good, with the key we can encrypt the files.

```
$ python safer.py -a encrypt -p files/ -k 65f9005e13b3b077b2e35fe8315d4ce7
[+] 4 files found.
[+] Working...
[+] Done.
```

So, if we do a `ls` on file we should see something like this:

```
$ ls files/
39179842.png.encrypted              DjaXbaVW4AInQXP.jpg.encrypted       ResumeDTavarezSpanish.pdf.encrypted
```

### Decrypting ###

If everything is done well, we can decrypt the files using the same script like this:

```
$ python safer.py -a decrypt -p files/ -k 65f9005e13b3b077b2e35fe8315d4ce7
[+] 4 files found.
[+] Working...
[+] Done.
```

Now we should have the same files but without the extension `.encrypted`

### Final thoughs ###

This is really a basic encrypting and decrypting script written in Python. We should generate a better key with symbols, numbers and letters. Besides, we can compress the files into a zip file protected by password. Later, I will post something explaining how we can create cron jobs to run this little script automatically. If you want to modify the script to improve it, please, do it and send me the revision.
