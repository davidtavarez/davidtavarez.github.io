---
layout: post
title: "Troubleshooting Grin++"
date: 2020-08-12 23:59:00 -0400
keywords: "grin++, grin, tor, onion, sending, receiving"
comments: true
description: "Fixing common issues with Grin++"
---

Grin++ is a, I'm sorry, the best [Grin](http://grin.mw/) Wallet. Grin++ runs on Windows, Linux and macOS, probably soon on Android, who knows... also Grin++ is multi-language, Grin++ has been translated into 12 differrent languages: Chinese, German, Spanish, Arabic, Italian, Polish, Portuguese, Russian, Ucranian, Russian, Turkish and, recently, Slovenian, it doesn't matter if you don't speak English, Grin++ got you covered 💕. If you're not using Grin++ yet, you should, go to [grinplusplus.github.io](https://grinplusplus.github.io/) and download it, I'll wait for you ⌚. Thanks.

But life isn't perfect 😞; sometimes, some few users face some small tiny issues, and today I will explain to you how to fix these tiny issues 😁👍

# Windows.

## Node isn't installed

![Node isn't installed](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NodeIsntInstalled.png)

Well, this can be easly fixed by making sure our Antivirus is not deleting neither putting into quarantine the Backend: **GrinNode.exe**. In order to confirm that, we need to make sure that the file named as **GrinNode.exe** is located inside the `bin` folder at `C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\` as it's showed in the next picture:

![bin](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/GrinNodeBin.png)

If the **GrinNode.exe** file is actually there and you're still having this problem, you shouldn't because the bundle should include all the dependcies, please, help us solve this by opening an issue at the [Grin++ repository on GitHub](https://github.com/GrinPlusPlus/GrinPlusPlus/issues/new).


## Node isn't running

This is reallz uncommon, but it could happen. The first thing we're gonna do is to open a Command Prompt and `cd` into the `C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\bin\` and then run `dir GrinNode.exe` like this:

![dir](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/BackendPresent.png)

Now we just type `GrinNode.exe` and hit the Enter key, after a few seconds we should see something like this:

![Running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/BackendRunning.png)

If the previous step fails, we should see a message with more information about the issue, feel free to [Join the Grin++ Telegram Channel](https://t.me/GrinPP) and ask for help from there, some others user may have faced the same issue as you.

When the issue is fixed, you should see something like this the next time you open Grin++:

![Running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NodeIsRunning.png)

## The Node process is not running. This is unusual, but don't worry, you just need to restart the wallet.

![Restart Wallet](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureNodeStopped.png)

Wow! this sould never happen, it means the Backend suddenly stopped, please let us know [opening an issue](https://github.com/GrinPlusPlus/GrinPlusPlus/issues/new) or joining the [Grin++ Telegram Channel](https://t.me/GrinPP).