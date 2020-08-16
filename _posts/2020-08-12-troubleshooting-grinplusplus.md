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

## Node isn't installed

![Node isn't installed](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NodeIsntInstalled.png)

Well, this can be easly fixed by making sure our Antivirus is not deleting neither putting into quarantine the Backend: **GrinNode.exe**. In order to confirm that, we need to make sure that the file named as **GrinNode.exe** is located inside the `bin` folder at `C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\` as it's showed in the next picture:

![bin](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/GrinNodeBin.png)

If the **GrinNode.exe** file is actually there and you're still having this problem, you shouldn't because the bundle should include all the dependcies, please, help us solve this by opening an issue at the [Grin++ repository on GitHub](https://github.com/GrinPlusPlus/GrinPlusPlus/issues/new).

## Node isn't running

This is really uncommon, but it could happen. The first thing we're gonna do is to open a Command Prompt and `cd` into the `C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\bin\` and then run `dir GrinNode.exe` like this:

![dir](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/BackendPresent.png)

Now we just type `GrinNode.exe` and hit the Enter key, after a few seconds we should see something like this:

![Running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/BackendRunning.png)

If the previous step fails, we should see a message with more information about the issue, feel free to [Join the Grin++ Telegram Channel](https://t.me/GrinPP) and ask for help from there, some others users may have faced the same issue as you.

When the issue is fixed, you should see something like this the next time you open Grin++:

![Running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NodeIsRunning.png)

## The Node process is not running. This is unusual, but don't worry, you just need to restart the wallet.

![Restart Wallet](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureNodeStopped.png)

Wow! this should have never happened, it means the Backend suddenly stopped, please let us know [opening an issue](https://github.com/GrinPlusPlus/GrinPlusPlus/issues/new) or joining the [Grin++ Telegram Channel](https://t.me/GrinPP).

## Stuck on "Waiting for Peers"

Sometimes this could happen after upgrading Grin++, you could get stuck on "Waiting for Peers" and you will see something like this:

![Waiting for Peers](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/WaitingForPeers.png)

In order to fix this, you could try 2 things. The first thing you could try is to `(Re)Sync` the chain by clicking on `Settings` and the on Resync below `Node Actions`:

![Settings](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/WalletSettings.png)

![Node Actions](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NodeActions.png)

If the solution above doesn't work you can try this. Close Grin++, go to `C:\Users\[USERNAME]\.GrinPP\MAINNET`, delete the folder called `NODE`:

![Backend Folders](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/BackendFolders.png)

Now open Grin++ again. After a while you will have the chain synced again.

![Syncing Headers](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/SyncingHeaders.png)

## The ~~Grin~~ Slatepack address is not being displayed

![No Address](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NoAddress.png)

This is a pretty annoying issue, I know, but at the same time it's pretty easy to solve. Some people like to run [Niffler Wallet](https://github.com/grinfans/Niffler) or [grin-wallet](https://github.com/mimblewimble/grin-wallet) at the same time as Grin++, without going deep into this, I will recommend not to do it, at least for now, make sure no other grin wallet is running before running Grin++. If you are still facing the issue, please, continue reading this post.

Let's see if `tor.exe` is running by ejecuting the `tasklist` command:

![tor.exe is not running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/NoTorRunning.png)

As we can notice `tor.exe` is not running. My first suggestion is double check if the `tor` folder is in the same directory as `GrinNode.exe` (at `C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\`) and `tor.exe` is present in the `tor` folder. Open the `Command Prompt` and 

```
$ cd C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\bin\tor
$ dir                                                                                                 
 Volume in drive C is OS                                                                              
 Volume Serial Number is XXXX-XXXX                                                                    
                                                                                                      
 Directory of C:\Users\[USERNAME]\AppData\Local\Programs\GrinPlusPlus\resources\app.asar.unpacked\bin\tor  
                                                                                                      
16/08/2020  14:36    <DIR>          .                                                                 
16/08/2020  14:36    <DIR>          ..                                                                
16/08/2020  14:36    <DIR>          data3423                                                          
               0 File(s)              0 bytes                                                         
               3 Dir(s)  90.510.950.400 bytes free
```

So, the `tor` folder is not present, now we can reinstall Grin++ by downloading the latest version, then we open Grin++ and voilà! we now have our address:

![tor.exe is running](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/TorRunning.png)

## The Address is not green! :(

OK... are you living in China, Iran or Venezuela? or any other country with heavy **internet censorship**? Are you behind of a scrict firewall? if the answer is YES, please refer to this post where I explain [how to bypass censorship](https://davidtavarez.github.io/2020/bypass-internet-censorship-and-filtering-grinplusplus/), if not, keep reading.

This issue happens when Tor is not able to establish connection, the first thing you should do is to check if your [Firewall is not blocking tor connections](https://www.dummies.com/computers/pcs/computer-security/how-to-allow-firewall-exceptions-on-your-windows-10-laptop/); after this, your address should be green.

## Is your issue not listed here?

If your issue is not listed here, please feel free to [Join the Grin++ Telegram Channel](https://t.me/GrinPP) and ask for help.