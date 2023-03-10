| Foreword: |
|:---|
| <br/>This repository is a fork of Walter S. Heath's Junk Calls Blocker : https://sourceforge.net/projects/jcblock/ <br/><br/> My goal here is not to make extensive changes to it, only what is necessary to make it work properly; fix some things here, format some other there, nothing too crazy (as I won't have the time to maintain it anyway). <br/> I have a french phone provider, my setup is a Raspberry Pi Zero with a Sewel-like modem (https://www.amazon.fr/dp/B016MXLCEQ) |


## Program: jcblock

A program to block telemarketing (junk) calls.

### PROGRAM DESCRIPTION:

This program connects to a modem and listens for the caller ID string that is sent between the first and second rings.
Itrecords the string in file callerID.dat.
It then reads strings from file whitelist.dat and scans them against the caller ID string for a match.
If it finds a match it accepts the call.
If a match is not found, it reads strings from file blacklist.dat and scans them against the caller ID string for a match.
If it finds a match to a string in the blacklist, it terminates the junk call.

The program also updates the date field of a matching whitelist or blacklist entry.
Entries that are old may then be identified so that they may be removed.
Note that the program will operate with only a blacklist.dat file defined.
A whitelist is not required.

Functions to manage the truncation (removal) of records from the blacklist.dat and callerID.dat files are present in file truncate.c.
Records in the blacklist.dat file that have not been used to terminate a call within the last nine months are removed.
Records in the callerID.dat file that are older than nine months are removed.
The operations are performed every thirty days. 
Alternatively, entries in the .dat files may be edited manually.

### EDITORIAL NOTE:
The next few paragraphs describe a method for detecting a star (\*, asterick) key press using a mic to listen for the tones produced by a modem's speaker.
The performance of this method has always been marginal. An ATian modem provides a better way. It is a voice/FAX modem.
As such it contains circuitry to detect touchtone keypad entries. This feature is now used to detect a \*-key press.
Search file README2 for "ATian" for more information.

An additional feature is supported by functions in file tones.c.
The program will add a record to the blacklist.dat file for the current call if the operator presses the star (\*, asterick) key on a touch tone telephone handset during an allotted time period.
The program detects the tone via a microphone placed near the modem speaker.
Functions in file tones.c detect the presence of tones(941 Hz and 1209 Hz) produced by pressing the star (\*) key.
If an answering machine is installed on the same line this feature mustbe restricted to be active only if a call is answered after the second or third ring
(the answering machine *must* also be set to answer on the fourth or later ring).
If an answering machine is not installed on the line the star key feature is available for calls answered after the second or later ring.
This option is controlled by a conditional compile flag.
Also see the NOTE: in the file concerning an ALSA version conditional compile selection.

The program requires a serial modem that can deliver caller ID and contains a speaker.
The recommended unit is the USRobotics model 5686G. It will return caller ID if it is sent command: *AT+VCID=1*
Note that the modem is used just to detect a call's caller ID and the star key tones; the modem's normal communication function is not used.
The program may be terminated by sending it a SIGINT (Ctrl-C) signal or a SIGKILL signal.

The program runs on a standard PC (it was written and tested on a Dell Dimension B110 running Ubuntu).
The features supported by functions in files truncate.c and tones.c may be removed by disabling conditional compile flags DO_TRUNCATE and DO_TONES, respectively, in file jcblock.c.
The default serial port specifier is: /dev/ttyS0. The program will accept an option to select a different port.
The syntax of the call is:

    jcblock -p /dev/portID

The entire program may be compiled with the following command:

    gcc -o jcblock jcblock.c tones.c truncate.c -lasound -ldl -lm

Linux installations may or may not install the libasound library. It is usually installed in /usr/lib.
Also, the tones.c file includes file asoundlib.h, which is usually located in directory /usr/include/alsa.
If not installed, they can be by using the distribution's package manager.
For example, for an Ubuntu distribution, the Synaptic Package Manager may be used to install alsa-base, to install the library, and alsa-source, to install the source files.
If /usr/include/alsa is not yet present install libasound2-dev.
It is also a good idea to install alsa-utils in case testing/debugging of the sound interface is needed.
Here is a full list of the alsa packages I have installed on my Ubuntu 10.04 machine (you can show the ones installed on your machine by entering 'alsa' in the Synaptic Package Manager's Quick Search: window):
||||
| --- | --- | --- |
| alsa-utils | alsa-base | alsa-source |
| libasound2 | libasound2-doc | libasound2-dev |
| libasound2-plugins | libsdl1.2debian-alsa | linux-sound-base |
| gstreamer0.10-alsa | bluez-alsa | libao2 |

No doubt some of these are not needed for the jcblock program, but if you install all of them, jcblock should run.

If jcblock is run on a desktop or laptop, a microphone must be placed near the modem's speaker and turned on.
The volume level must then be adjusted so that when the star key is pressed, the audio generated causes the program's tone filter thresholds to be exceeded.
Mic audio volume may usually be set by a Preferences option. For Ubuntu the path is: System|Preferences|Sound.
Then make sure the proper sound device is selected under Hardware. The mic volume may then be set under Input.
The setting depends on the position of the mic relative to the modem's speaker. The slider is quite sensitive.
Another way is to use the alsamixer program: choose the sound interface (F6) and the Mic slider (arrow keys).
Using this program you have a numeric setting displayed that can be reused.
Remember to keep the phone you answer with away from the mic, since the mic will respond to the tones received by the handset!

For continuous use, the program should be run on a low-power single board computer so that it can be left on all the time.

### More on the whitelist:

As a result of operational experience it became evident that the addition of a whitelist capability would be helpful.
The whitelist file (whitelist.dat) holds entries containing the telephone numbers of calls the user definitely wants to accept.
The program checks for caller ID matches of these entries first. If a match is found, the blacklist check is bypassed and the call is accepted.

The issue came up when it was discovered that some telemarketers use cell phones!
For cell phone calls, the 'NAME =' field in the caller ID string is usually: 'Cell Phone   XX', where XX is the originating state designator (e.g., CA for California).
So using the 'NAME =' field as the search string in a blacklist entry would cause all cell phone calls from the indicated state to be blocked!
In addition, the telemarketers use several cell phones (probably as employees come and go), so using the 'NMBR =' field in the caller ID as the search string does not catch new cell phone callers.
Adding a whitelist partially solves this problem.

With a whitelist, the user can include entries that contain the cell phone numbers of calls they definitely want to receive from a specific state (e.g., CA).
Then the cell phone 'NAME =' field for the state (e.g., 'Cell Phone   CA') can be used as the search string in a blacklist entry.
With this arrangement all cell phone calls from the state will be blocked *except* the ones with numbers present in the whitelist.

As another example, a person might want to receive calls from just certain numbers and no others (an elderly person, for example).
In that case the records for the numbers of interest would be placed in the whitelist and a single record placed in the blacklist that contains a field that is present in all caller IDs (e.g., 'NMBR').
Then all calls not matched by records in the whitelist would be terminated.

### Wrap-up:

The most detailed source of documentation for the project it the comments in the listings. I have added many for this purpose.
The system runs continuously at our home and terminates junk calls indicated in the blacklist file.
After about six months the number of junk calls we received decreased to only a few a week as the telemarketers removed us from their call lists.

The easiest way to get started with this project is to just compile the program and run it on a standard PC.
It works fine that way, but you have to leave your PC on all the time for it to be useful in terminating calls.
If you do that anyway then you are all set! Otherwise you should eventually consider installing it on a dedicated low power embedded computer system.
