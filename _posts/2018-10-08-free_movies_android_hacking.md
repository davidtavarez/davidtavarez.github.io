---
layout: post
title:  "How to watch Movies, Series and TV-Shows for free by doing Android Static Analysis on Bluemax2"
date:   2018-10-08 19:20:00 -0400
categories:
  - Tools
tags:
  - adb
  - android
  - dex2jar
---

Who likes free stuff?! I don't know about you guys but I love free stuff. Recently, my brother-in-law sent to me a link to download **Bluemax2**, an app for the FireStick that allows people to see movies, series and tv-shows. The author of this App gives you a credential for an annual small fee. The app is really stable and the streaming has a very good quality, the best that I've ever seen outside Netflix, Amazon or Youtube. I have trust issues, so I decided to see what this app was doing... 10 minutes later I was watching "Hackers" without paying a dime. ![Hackers][hackers-screenshot]

### dex2jar to the rescue ###

Programs for Android are commonly written in Java and compiled to bytecode for the Java virtual machine, which is then translated to Dalvik bytecode and stored in ***.dex*** (Dalvik EXecutable) and .odex (Optimized Dalvik EXecutable) files; related terms odex and de-odex are associated with respective bytecode conversions. The compact Dalvik Executable format is designed for systems that are constrained in terms of memory and processor speed.

Basically an ***.apk** file is a zip containing all the files needed to run the app. So the first thing we need to do is to get the apk and unnzip it. For archeiving this we need the [Android Debug Bridge](https://developer.android.com/studio/command-line/adb "adb"). With the Debug mode enabled, plug the device using an USB cable.

Let's see if our device is detected:

```
$ adb devices
List of devices attached
5a4ece0b	device
```

Good, it is. Now I want to list the apps installed:

```
$ adb shell pm list packages
...
package:com.bluecinemax.tv
...
```
To find where the .apk is located, we can do it with ***pm path***:

```
$ adb shell pm path com.bluecinemax.tv
package:/data/app/com.bluecinemax.tv-5pGnoWSg8RO4t7f0RXxY-g==/base.apk
```

I don't know why those bytes are appended but I don't care for now... let's move that from there:

```
$ adb root
restarting adbd as root

$ adb shell cp /data/app/com.bluecinemax.tv-5pGnoWSg8RO4t7f0RXxY-g==/base.apk /sdcard/com.bluecinemax.tv.apk
```

I had to do it running ***adb root*** first... let's pull the apk file:

```
$ adb wait-for-device pull pull /sdcard/com.bluecinemax.tv.apk ./
```

Easy, right?! Ok, now we need to unzip that:

```
$ cp com.bluecinemax.tv.apk com.bluecinemax.tv.zip

$ unzip com.bluecinemax.tv.zip
Archive: com.bluecinemax.tv.zip
...

$ ls -lh
total 62312
-rw-r--r--@  1 davidtavarez  staff   9.8K Dec 31  1979 AndroidManifest.xml
-rw-r--r--@  1 davidtavarez  staff   9.3M Oct  9 21:30 com.bluecinemax.tv.apk
-rw-r--r--@  1 davidtavarez  staff   9.3M Oct  9 21:10 com.bluecinemax.tv.zip
drwxr-xr-x@  8 davidtavarez  staff   256B Oct  9 21:11 META-INF
drwxr-xr-x@  6 davidtavarez  staff   192B Oct  9 21:11 assets
-rw-r--r--@  1 davidtavarez  staff   7.7M Dec 31  1979 classes.dex
-rw-r--r--@  1 davidtavarez  staff   1.9M Dec 31  1979 classes2.dex
drwxr-xr-x@  3 davidtavarez  staff    96B Oct  9 21:11 org
-rw-r--r--@  1 davidtavarez  staff    33K Dec 31  1979 publicsuffixes.gz
drwxr-xr-x@ 44 davidtavarez  staff   1.4K Oct  9 21:11 res
-rw-r--r--@  1 davidtavarez  staff   715K Dec 31  1979 resources.arsc
```

We can notice two .dex files, we're going to focus on the bigger one and using [d2j-dex2jar](https://github.com/pxb1988/dex2jar), we're going to generate a ***.jar*** file:

```
$ bash ~/Applications/dex2jar-2.0/d2j-dex2jar.sh classes.dex
dex2jar classes.dex -> ./classes-dex2jar.jar
Detail Error Information in File ./classes-error.zip
Please report this file to http://code.google.com/p/dex2jar/issues/entry if possible.
```

Excellent. [JD-Gui](http://jd.benow.ca/) will help us now:

![JD-Gui-screenshot][JD-Gui-screenshot]

### The API ###

JD-Gui allows us to find strings in the code like this:

![JD-Gui-screenshot][JD-Gui-search-screenshot]

After a deep look, we can find interesting things:

![JD-Gui-screenshot-api][JD-Gui-search-api-one]

![JD-Gui-screenshot-api][JD-Gui-search-api-two]

### Free content? Yes! ###

Now that we have an endpoint, we can test it:

```
$ curl http://varnatrd.tech/api/movies > movies.jon
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2519k  100 2519k    0     0  1218k      0  0:00:02  0:00:02 --:--:-- 1218k
```

Interesting... let's see the content:

![Bluemax-API][bluemax-api-movies]

Oh! Can we see the details using the ***id***? Of course!

```
$ curl http://varnatrd.tech/api/movies/5661f3002d2c14e345b743b1 > movie_details.json
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1366  100  1366    0     0   3311      0 --:--:-- --:--:-- --:--:--  3323
```

![Bluemax-API][bluemax-api-movie-details]

As we can notice, there is an array of ***content*** where the item at 0 is a link :)

### Searching the API ###

But wait! Now we can search for whatever we want! Let's write some code for it:

```python
#!/usr/bin/env python

import sys
import requests

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print "\nERROR: Missing arguments.\n"
        sys.exit(1)

    url = "http://varnatrd.tech/api/movies"
    movies_request = requests.get(url)

    if movies_request.status_code:
        movies = movies_request.json()
        search = sys.argv[1].split(" ")
        for movie in movies:
            if any(keyword.lower() in movie['title'].lower() for keyword in search):
                movie_details = requests.get("{}/{}".format(url, movie['_id'])).json()
                print u"TITLE:\t{}\nSYNOPSIS:\n\t{}\nURL:\t{}\n".format(movie_details['title'],
                                                                        movie_details['synopsis'],
                                                                        movie_details['content'][0]['link'])
```

I want to see a movie about hackers, can I?

```
$ python bluemax_movies.py "hacker"
TITLE:	Hacker
SYNOPSIS:
	Alex Danyliuk, un joven inmigrante de Ucrania, llega a Canadá y se involucra con una organización criminal online llamada Darkweb. Poco a poco se va convirtiendo en un adolescente hacker, aprendiendo a estafar tarjetas de crédito, cajeros automáticos, entrar en los bancos y, finalmente, el mercado de valores. Lo que comienza como una manera de ayudar a sus padres económicamente, pronto se convierte en una venganza personal contra todo el sistema bancario cuando su madre es despedida de su trabajo en el banco.
URL:	https://storage.googleapis.com/bluerey-145701.appspot.com/M/2016/Hacker.2016.720p.Eng-S.mp4
```

Does this link work?

![VLC Movie][vlc-screenshot]

Yes! Thank you! :D

### Bonus ###

We can get the last .apk using an endpoint:

```
$ curl http://varnatrd.tech/api/apk > com.bluemax.tv.apk
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 9523k  100 9523k    0     0  3160k      0  0:00:03  0:00:03 --:--:-- 3162k
```

You're welcome.

[hackers-screenshot]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/screenshot_hackers_movies.png
[JD-Gui-screenshot]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/jdGui_bluemax.png
[JD-Gui-search-screenshot]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/jdGui_bluemax_search.png
[JD-Gui-search-api-one]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/jdGui_bluemax_api_one.png
[JD-Gui-search-api-two]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/jdGui_bluemax_api_two.png
[bluemax-api-movies]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/bluemax_movies.png
[bluemax-api-movie-details]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/bluemax_movie_details.png
[vlc-screenshot]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/vlc_hackers.png