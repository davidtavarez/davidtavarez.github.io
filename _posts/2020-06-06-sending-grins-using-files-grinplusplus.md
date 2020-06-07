---
layout: post
title: "Sending $GRIN ツ using Grin++ via Files"
date: 2020-06-07 23:59:00 -0400
keywords: "grin++, grin, tor, onion, sending, receiving"
comments: true
description: "Sending $GRIN ツ using Grin++ via Files"
---

**Grin** is an anonymous privacy-oriented cryptocurrency. Grin is based on the **Mimblewimble** protocol, if you are a Harry Potter fan, you have probably come across this word. In the Harry Potter's universe, [Mimblewimble](https://harrypotter.fandom.com/wiki/Tongue-Tying_Curse) is the tongue-tying curse that binds the target's tongue to keep them from talking about a specific topic or subject. For Grin, this means that, **there are no addresses**. Instead, the parties share a "blinding factor". The blinding factor encrypts the inputs and outputs of the transaction along with both parties' public and private keys. This blinding factor is shared as a secret between the two parties who were engaged in the transaction. Due to the blinding factor replacing addresses, only the two parties know that they were involved in a transaction. This keeps the privacy of the network at a high level. Unlike Bitcoin, Grin's transactions are truly anonymous.

Grin is a _Disruptive Technology_, why am I so confident saying this? Because disruptive technologies are sometimes described as being simultaneously destructive and creative because they make old products, and sometimes even entire industries, **obsolete**, creating new ones in their place. Disruptive technologies have the power to change the way we work, live, think and behave. And this is what Grin is doing right now and it will keep doing.

Today, we're going to learn how to send Grins via Files.. files?! yes, files!

The first thing that we're going to do is to click on the Send button to open the Sending screen, then we're going to type the amount, in this case 8.1 grins, like this:

![Amount](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile001.png)

After filling the amount field, click on **"Save Tx"** and you will be asked to confirm your password:

![Password](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile002.png)

A Save As dialog is prompted to save the file:

![Save As](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile003.png)

The ongoing transaction is now displayed like this:

![Sending](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile005.png)

This file should be sent to the receiver. This is the coolest step because this file can be [encrypted](https://github.com/coleifer/beefish) and securely shared using, for instance, [OnionShare](https://onionshare.org/).

### Receiving Grins via file.

After receiving the file, the receiver imports this file to Grin++:

![Import file](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/ReceiveViaFile001.png)

This will generate a _.response_ file, the receiver should send this file back to the sender to Finalize the transaction:

![.response file](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/ReceiveViaFile002.png)

### Finalizing Transaction.

To finalize the transaction, you (the sender) need to select the .response file and click on "Process":

![finalize](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile006.PNG)

![finalized](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile007.PNG)

That's all! After finalized, the Transaction should be confirmed:

![waiting confirmation](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/CaptureViaFile008.PNG)

I know this is a bit tedious, but **Privacy** and **Anonymity** should be preserved at all costs. Grin is a pain in the ass for authoritarian goverments, corporations and banks. Grin is for those who love **Freedom**.
