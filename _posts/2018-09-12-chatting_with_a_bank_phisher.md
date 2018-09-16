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

Since Firefox is preventing/alerting users go to that site, let's try to jump over the warning:

![Login][banreservas-phishing]

Ok... we're on a subfolder... let's see what we can find at the index...

![Index of][index-of]

[report-tweet]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/DmfgGRiUwAAnX33.jpg.large.jpeg
[phishing-warning]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/phishing_reservas_warning.png
[banreservas-phishing]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/banreservas_phishing.png
[index-of]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/index_of_phishing.png
