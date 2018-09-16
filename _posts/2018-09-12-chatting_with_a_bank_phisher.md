---
layout: post
title:  "Chatting with a (lazy) Bank Phisher"
date:   2018-09-12 21:35:00 -0400
categories:
  - OSINT
tags:
  - phishing
  - scam
---

Everything began with a tweet. A friend of mine "report" a phishing attempt to the Banco de Reservas (Dominican Republic). ![Original Tweet][report-tweet]

And I quoted "report" because I really doubt that the Community Manager is completely aware on how dangerous a Phishing campaign could be... but, let's move on, maybe at the end of this post non-technical users will learned something.

### Following the instructions ###

My first stop was to follow the instructions:

```
$ curl http://opora-company.ru/__MACOSX/layouts/libraries/cms/
<META HTTP-EQUIV='refresh' content='0; URL=iniciox/?id=9690e2fa37a78804ee419dabbd0052859690e2fa37a78804ee419dabbd005285'>
$ curl http://opora-company.ru/__MACOSX/layouts/libraries/cms/iniciox/
<META HTTP-EQUIV='refresh' content='0; URL=backup.php?id=b48b707c8e900df29a5f88025e18a4aeb48b707c8e900df29a5f88025e18a4ae'>
$ curl "http://opora-company.ru/__MACOSX/layouts/libraries/cms/iniciox/backup.php?id=b48b707c8e900df29a5f88025e18a4aeb48b707c8e900df29a5f88025e18a4ae'"
```

I didn't receive any response, so let's try with `-v`:

```
$ curl -v http://opora-company.ru/__MACOSX/layouts/libraries/cms/iniciox/backup.php
*   Trying 37.140.192.154...
* TCP_NODELAY set
* Connected to opora-company.ru (37.140.192.154) port 80 (#0)
> GET /__MACOSX/layouts/libraries/cms/iniciox/backup.php HTTP/1.1
> Host: opora-company.ru
> User-Agent: curl/7.54.0
> Accept: */*
>
< HTTP/1.1 302 Moved Temporarily
< Server: nginx/1.14.0
< Date: Wed, 12 Sep 2018 01:12:51 GMT
< Content-Type: text/html
< Content-Length: 0
< Connection: keep-alive
< X-Powered-By: PHP/5.3.28
< location: https://tangbadoummere.com/NetBanking/Login.htm
<
* Connection #0 to host opora-company.ru left intact
```

I don't know why all this jumps, but finally we got the site: `https://tangbadoummere.com/NetBanking/Login.htm`:

![Phishing Warning][phishing-warning]

Since Firefox is preventing/alerting users to go to that site, let's try to jump over the warning:

![Login][banreservas-phishing]

Ok... we're on a subfolder... let's see what we can find at the index...

![Index of][index-of]

Fuck, they're doing this since 2016! Let's calm down and read the code because that's what they want, right? if not, why they upload the code into a zip file without password?

After a quick look of the code we can find few things:

* The code was done by a really bad coder.
* In order to validate the input, they're sending requests to the official internet's banking website (*clever*).
* They're sending the stealed information to `optimus316@gmail.com`
* The code is written in spanish with a lot of typos, so they person is most likely to be dominican.
* They're stealing not just logins but codes.

Now we have an email address `optimus316@gmail.com` and a handler `optimus316`, so now we can search for more information.

### What can we find on the internet? ###

With `optimus316@gmail.com` we can find that this address is known as a bank phishing spammer:

![Spammer][spammer]

That's something that we already know... but... what happens if we try with `optimus316@hotmail.com` or/and just `optimus`?

![Hello Foros][hello-foros]
![Foros Bits][foros-bits]
![iPod Total][ipod-total]

We just found at least found 3 spanish speaking profiles and it looks like they guy could be dominican... also `optimus316` exists on a hacking forum:

![Black Hat World][black-hat-world]

It seems `optimus316@gmail.com` and `optimus316@hotmail.com` are related... let's see what Google can tell me about it, I'm going to try to recovery the `gmail.com` account:

![Google recovery][google-recovery-one]

Ummmm... let's try with `optimus316@hotmail.com`:

![Google recovery][google-recovery-two]

**Bingo!**

Also, with a little extra effort I found and IP from Dominican Republic related to `optimus316@hotmail.com`:

![Dominican IP][dominican-ip]

Now we could build a profile of this scammer:

* Dominican.
* Bad coder.
* Between 20 and 35 years old.
* He's from Santo Domingo.
* Man.
* IT Guy (maybe support).
* He's married with with an american citizen.
* He likes easy money.

### Contact attempt ###

With all this information I can try to reach him via email and ask some questions and I tried but, of course, he was faking to be confused. That's something that we can expect at first. Let's add him to skype as we found there is a handler named `optimus316`:

![Skype][skype-optimus316]

Maybe I can help him with a good cloacker...

![Skype optimus316][skype-optimus316-found]

Good. After this, he finally decided to don't be so rude with me and he talked to me :)

### Chat logs ###

```
Hey!

H [PHISHING GUY], 12:18 AM
?

12:19 AM
por qué bajaste las páginas?

H [PHISHING GUY], 12:22 AM
Montro

Que ud quiere y hable rápido 

12:22 AM
cómo lo haces?

H [PHISHING GUY], 12:22 AM
Y diga quien es y punto 

12:22 AM
cómo consigues los servidores?
cómo haces que los correos lleguen al inbox y no al spam
?

H [PHISHING GUY], 12:22 AM
Sino ando rifando bloqueos 

Y ud tiene él primero 

12:23 AM
montro
responda
y lo dejo en paz

H [PHISHING GUY], 12:25 AM
Pero quien es ud 

Simple 

12:25 AM
es mejor que no lo sepas
te dejaré en paz

H [PHISHING GUY], 12:25 AM
Plástico 

12:25 AM
montro, no se haga el más listo de la cuenta
cómo sé que hiciste el phishing del reservas?
sabes que lo sé
necesitabas escucharlo?

H [PHISHING GUY], 12:26 AM
Eres plastico o no 

12:26 AM
qué es plástico? qué es esa jerga?

H [PHISHING GUY], 12:26 AM
Jajajajjaa

Que país eres 

Y que necesitas en si 

quiero saber cómo lo haces
cómo consigues los servidores?
cómo haces que los correos lleguen al inbox y no al spam?
qué es plástico?
por qué no mejor utilizaste el apk del reservas con un backdoor?
trabajas solo?

H [PHISHING GUY], 12:29 AM
Te llego a imbox por que tienes ese email agregado 

Simple 

12:29 AM
cómo consigues los servidores?
trabajas solo?
qué más sabes hacer?
hiciste el código tú?
de ser así eres muy malo con el código, pero la idea fue bastante buena, debo admitir
qué es ser plástico?

H [PHISHING GUY], 12:35 AM
Para que lo quieres 

Que país eres

Que bank

12:36 AM
cómo consigues los servidores? trabajas solo?

H [PHISHING GUY], 12:36 AM
Bye

Muchas preguntas 

12:36 AM
montro

H [PHISHING GUY], 12:36 AM
Nada de respuestas 

no lo haga más difícil
solo quiero saber
igual ta bajaste el site
y el banco fue notificado
lo sabes
no lo haga más dificil
sabes que no podrás hacer ese phising otra vez, y te quedan pocas opciones porque ya la mayoría usa token rsa

H [PHISHING GUY], 12:38 AM
No me has contestado 

12:39 AM
qué necesitas saber 

H [PHISHING GUY], 12:39 AM
Debes tener unos 25 años y empezando 

Dominicano 

12:39 AM
dominicano igual que tú

H [PHISHING GUY], 12:39 AM
Le das a paypal y esas vainas 

12:40 AM
por qué a la gente común? que trabaja y se parte el lomo?
por qué no otros targets?
cómo consigues los servidores? trabajas solo?

Para finalizar l conversación, solo hago lo que me piden 

12:41 AM
cuanto cobras?

H [PHISHING GUY], 12:41 AM
Y para responder lo otro 

El banco tiene su seguro 


yes
Los clientes que se parten el lomo no lo pierden 

12:42 AM
cuanto cobras?

H [PHISHING GUY], 12:42 AM
Llámale a quien lo hace robin hood

12:42 AM
trabajas para rusos o consigues los servers en algun market?
sabes que estás dentro de varias listas y creen que eres ruso?

H [PHISHING GUY], 12:45 AM
Listas?

De los más buscados?

12:45 AM
no
de phishing de bancos

H [PHISHING GUY], 12:48 AM
Qué haces?

12:48 AM
curiosear

H [PHISHING GUY], 12:48 AM
A qué le das?

12:49 AM
todo lo que cause curiosidad 

H [PHISHING GUY], 12:50 AM
Bien 

12:50 AM
quiero saber más sobre cómo funcionan las cosas

H [PHISHING GUY], 12:50 AM
Pues no soy el indicado 

12:50 AM
por qué creen que eres ruso?
quién es el indicado?
cómo consigues los servidores? trabajas solo?
en un market?

Policía  

Investigue mejorn

Bye 

12:51 AM
montro
no lo haga más dificil

H [PHISHING GUY], 12:51 AM
Block 

12:51 AM
has dejado demasiado rastro
no lo haga más dificil
estás minando todavía?

H [PHISHING GUY], 12:52 AM
Pues llegueme 

12:52 AM
no soy policía
ni trabajo en banco
solo quiero saber cómo
listo
no debes usar claves fácil de cracker
crackear*
montro, no lo haga más difícil, ni soy policía ni trabajo en banco
solo quiero saber
mi trabajo es hacer que empresas no caigan en cosas como lo que le hiciste a banreservas
por un lado lo hiciste muy mal, porque tengo demasiada información suya, pero por el otro, sé tus víctimas fueron muchas


Haga lo que tenga que hacer 

Para eso le pagan 

Para eso me pagan 

1:07 AM
solo quiero saber cómo lo haces
no hagamos esta conversación incómoda
quiero proteger a mis clientes

H [PHISHING GUY], 1:07 AM
Y tengo cara de que quiero contar historia 

montro

H [PHISHING GUY], 1:07 AM
Bien 

Protéjalo 

1:07 AM
no lo haga más díficil, por favor
no fue dificil encontrarte 

H [PHISHING GUY], 1:08 AM
Na 

Lo sé 

Se dejan migajas 

1:08 AM
te estoy haciendo varias preguntas
no me interesa más nada
cómo lo haces
hay una red?

sabes que en santo domingo norte hay una red
eres parte?
por qué creen que eres ruso?
es por los servidores? cómo los consigues?
hay un marketplace?
```

### Final thoughs ###

He thinks he's safe and nobody can touch him. After this, he, or they, decided to power off some others phishing campaigns. They have dozens of domains pointing to the same IP, all containing phishing websites. At the moment I'm writing this the IP isn't responding. I think he isn't going to rerun the same campaign against Banreservas's clients, but he won't stop doing other phishing. It's 2018 and people keep falling into this kind of things, companies should work harder to educate their employees.

PSD: I'm too lazy to translate the chat, sorry.

[report-tweet]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/DmfgGRiUwAAnX33.jpg.large.jpeg
[phishing-warning]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/phishing_reservas_warning.png
[banreservas-phishing]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/banreservas_phishing.png
[index-of]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/index_of_phishing.png
[spammer]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/spammer_optimus.png
[hello-foros]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/hello_foros_optimus316.png
[foros-bits]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/foros_bits_optimus316.png
[ipod-total]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/ipods_optimus316.png
[black-hat-world]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/black_hat_world_optimus316.png
[google-recovery-one]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/google_recovery_one.png
[google-recovery-two]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/google_recovery_two.png
[dominican-ip]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/curl_optimus316.png
[skype-optimus316]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/skype_optimus316.png
[skype-optimus316-found]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/optimus316_found_skype.png