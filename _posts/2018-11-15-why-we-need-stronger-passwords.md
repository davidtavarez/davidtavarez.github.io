---
layout: post
title:  "Why do we need strong passwords?"
date:   2018-11-15 18:47:00 -0400
categories:
  - Privacy
tags:
  - Passwords
  - Security
---

A **password** is a string of characters used for user authentication to prove identity or access approval to gain access to a resource, which should to be kept secret from those should not have access. Passwords help ensure that computers or data can only be accessed by those who have been granted the right to view or access them. Your password is more than just a key to your online account. If your password falls into the wrong hands, someone can easily impersonate you while online, sign your name to online service agreements or contracts, engage in transactions, or change your account information.

Reusing passwords is an exceptionally bad security practice. If someone finds a password that you've reused across multiple services, they can gain access to many of your accounts. This is why having multiple, strong, unique passwords is so important. Here are 3 simple reasons why it is important to use strong passwords.

### 1.- Brute Force attacks are still a thing. ###

It might sound impossible but Brute Force attacks still exist. Between 2016 and 2017 a ransomware called [Crysis](https://blog.trendmicro.com/trendlabs-security-intelligence/brute-force-rdp-attacks-plant-crysis-ransomware/) caused a lot of damage infecting tons of servers after gaining access trough RDP. There are still some variants of that ransomware with the same behavior.

[WPSeku](https://github.com/m4ll0k/WPSeku), a Wordpress Security Scanner, allows people to run a brute force attack.

[![WPSeku](https://raw.githubusercontent.com/m4ll0k/WPSeku/master/screen/main.png)](https://github.com/m4ll0k/WPSeku "WPSeku")

[Hydra](https://github.com/vanhauser-thc/thc-hydra) is a proof of concept code, to give researchers and security consultants the possibility to show how easy it would be to gain unauthorized access to a remote system. With Hydra people can launch an online dictionary attack to several protocols.

### 2.- Open-Source Intelligence (OSINT) rise from the dark. ###

OSINT is defined by both the U.S. Director of National Intelligence and the U.S. Department of Defense (DoD), as "produced from publicly available information that is collected, exploited, and disseminated in a timely manner to an appropriate audience for the purpose of addressing a specific intelligence requirement.". OSINT under one name or another has been around for hundreds of years. With the advent of instant communications and rapid information transfer, a great deal of actionable and predictable intelligence can now be obtained from public unclassified sources.

Maltego, Shodan, Google, Social Media Spiders, and others are being used to collect information about people. All this information could be used to generate dictionaries and perform brute force attacks to already collected hashes. [CeWL](https://digi.ninja/projects/cewl.php), [Crunch](https://sourceforge.net/projects/crunch-wordlist/) and [Mentalist](https://github.com/sc0tfree/mentalist) are popular tools used to create custom wordlists.

### 3.- Data Leaks ###

To fully understand what a leak is, it’s useful to reflect on what data breaches are for comparison. To summarize, data breaches are intrusions into sensitive systems perpetuated by a unauthorized user. Data leaks, however, are incidents where this information is simply exposed as the result of a company’s internal processes or by a mistake.

Some leaks include **usernames** and (encrypted) **passwords**. With a bunch of time and good resources, any encrypted password could be cracked. Also, some leaks can be found at [PasteBin](https://pastebin.com/).

### What should we do? ###

It's simple: Avoid reusing passwords, instead of words try using phrases or use passwords generators like [this one](https://davidtavarez.github.io/tools/2018/09/26/creating-stronger-passwords.html).