
Program: jcblock

A program to block telemarketing (junk) calls.

FILE CONTENTS:

This file contains information related to running the jcblock
program on a Raspberry Pi processor using various modem models.
The present preferred modem choice is the Sewell (previously
called the ATian) modem. Search for 'Sewell' in this file for
details. The jcblock program, itself, is described in file
README.

NOTE: See the RECENT ACTIVITY section (below) for changes.

23 November 2014: Raspberry Pi System with TRENDnet modem
---------------------------------------------------------

A site photo shows a Raspberry Pi B+ processor (~$35) with a
TRENDnet TFM-561U modem (~$25). This represents a minimal
system for running the program. The program's tones feature is
not operable (the tones feature allows the operator to press
the *-key on a touchtone phone to automatically generate a
blacklist entry for the call). The FAX tone feature is also not
available (this feature causes a FAX tone to be sent to the
caller to fool them into thinking they have reached a FAX
machine). The program must therefore be compiled with
precompiler flags DO_TONES and DO_FAX_TONE commented out.

To compile the program for this hardware configuration edit
the makejcblock file to contain a compile command that looks
	like this:
	gcc -o jcblock jcblock.c truncate.c -ldl -lm

The program will then compile on the Pi. You will need to
determine the USB device that the Pi assigns to the TFM when
it is plugged in. I find that the easiest way to do this is
to list the /dev/tty* device IDs with and without the device
installed. You will see a new device when it is plugged in.
It will probably be ttyACM0. So the command to run jcblock
would then be:
	./jcblock -p /dev/ttyACM0

When you first run the Pi you will need to configure the system.
In addition to text presented when the system boots, there is a
README file for another of my projects, jablock, on SourceForge
that goes into considerable detail on this subject. There are
also several excellent tutorials on the web.

OPERATION:

The TFM-561U modem delivers caller ID data that is consistent
with USA/Canada telephone systems. Unfortunately there is no
worldwide standard caller ID format. There are three major
standards: 1) Bellcore (USA, Canada, etc.), 2) DTMF (parts of
Europe, etc.) and ETSI (other parts of Europe, etc.). For
details search the web for 'caller ID'. Here is an example
source:
	http://www.ainslie.org.uk/callerid.htm

The TFM-561U uses the Bellcore format. It may be possible to
install a caller ID converter that converts DTMF or ETSI formats
to Bellcore (a "box" that goes in the phone line before the TFM).
Search for 'caller ID converter'. Here is a reference to an
EM3100 unit (also check ebay):

http://www.aliexpress.com/popular/caller-id-converter.html

I do not know if these units solve the problem (since I do not
have access to non-US phone systems!). If you try one, I would
greatly appreciate hearing from you (at: walmarheath@comcast.net
or add a topic to the site's Discussion menu area).


29 November 2014: Raspberry Pi System with USR5637 modem
	---------------------------------------------------------

A site photo shows a Raspberry Pi processor (~$35) with a
USRobotics USR5637 modem (~$50). As for the TFM system, the
program's tone feature is not operable. The FAX tone feature is
also not operable. The program must therefore be compiled with
DO_TONES and DO_FAX_TONE commented out. In addition, the program
cannot use the "DTR trick" to cancel calls (see UPDATES for details).
Instead, it uses the off-hook/on-hook method. To activate this,
DO_USR5637_MODEM must be uncommented. However, unlike the
USR5686G modem, this modem does accept country codes (see below).
So there is the possibility that the caller ID format issue
discussed above has been solved within the modem (if you have
experience with this, I would very much like to hear from you!).

The instructions for compiling and running the program are the
same as for the TFM system above.

22 January 2015: Raspberry Pi System with USR5686G modem
-------------------------------------------------------

	Note: site photos for this system were removed to make room
	for photos of newer systems.

Site photos show a Raspberry Pi Model B+ processor (~$35) with
a USRobotics 5686G modem (~$90) and a Cirrus Logic Audio Card
(a.k.a., Wolfson Audio Card+, ~$40). This system implements the
entire jcblock system. The audio card provides a microphone
(mic) interface to the RPi. Audio tones produced by pressing the
asterisk (*) key are detected by the mic and processed to place
an entry for the call in the blacklist (see the README file for
details). The mic on a Skulcandy INKD "ear buds" headset (Radio
Shack, ~$24) is used. The unit is housed in an inverted storage
box, which shields the RPi from static discharge (we have cats!),
concentrates modem speaker sound around the mic and shields the
mic from room noise.

Compilation:
There were enough program changes to the tones.c file to warrant
a separate file, tonesRPi.c, for the RPi version. So the tones.c
file in makejcblock should be replaced with tonesRPi.c. Also, make
sure the DO_TONES preprocessor define in jcblock.c is uncommented.
To compile this program libasound2-dev must be installed. To do
this the RPi must be connected to the Internet. Then run:
	$sudo su
	#apt-get update
	#apt-get install libasound2-dev

The makejcblock script should then compile the program.

Audio Card:
The audio card is described at (one line URL):

http://www.element14.com/community/community/raspberry-pi/
	raspberry-pi-accessories/cirrus_logic_audio_card

A User Manual may be downloaded. The card provides interfaces
to multiple audio devices. This project uses the analog headset
interface only. Device drivers for the card are not yet part
of the Raspian package, so they must be installed. The manual
indicates that there are two choices: 1) download and install
an entire Linux microSD card image (Method A), 2) install an
updated kernel containing the needed drivers (Method B). If
you have not yet installed Raspian, I would recommend Method
A, since you will then also find the "Use Case" configuration
scripts in directory /home/pi. These are not available using
Method B. The scripts are not strictly necessary for this
project, since I have copied (and modified) parts to start-up
script: startjcblock. The image may be installed on a microSD
card using the procedure described here (one line URL):

http://www.raspberrypi.org/documentation/installation/
	installing-images/linux.md

Be careful with the 'dd' operation in this procedure! If
you choose to just install the drivers (Method B), You will not
need the Use Case scripts for this project, since script
startjcblock contains all that is needed. The manual describes
the Use Case scripts.

Image Configuration Tips:
If you install the Method A image on a microSD card, and install
it in an RPi, it should boot on a system with display (TV),
keyboard and mouse. If you are not in the UK one change you will
want to make immediately is to set the default keyboard. If
you start a LXTerminal and press the '#' key you see a British
pound (currency) symbol, edit /etc/default/keyboard and change
XKBLAOUT='gb' to indicate your locale (e.g., 'us' for the US).
I also changed the default editor by adding line:
	export EDITOR=/usr/bin/vi (or your choice of editor)

to the end of the .bashrc file in /home/pi. Then reboot.

At this point you will probably want to make other configuration
changes:
	$sudo su
	#raspi-config
This will display the initial configuration menu that the Raspian
installation displays. The raspi-config utility presents menus
using an ncurses GUI. Some general rules for navigating the menus
are as follows: 1) to move up or down a menu list use the up/down
arrows, 2) to select an item, press the Enter key, 3) to toggle
an entry, use the Space bar, 4) to select an option at the bottom
of a menu, press the left or right arrows (some times multiple
times!), 5) to exit the utility, press the Esc key.

Under Advanced Options, you will want to activate SSH. This will
start its daemon so you can ssh in remotely. Make other changes
as you see fit.

Startup Script:
File startjcblock is available at the web site. This may be run
to start jcblock. It must be made executable:
	$chmod +x startjcblock

The file starts with a (modified) version of the Use Case
Reset_paths.sh file. The second part is a (modified) version of
the Record_from_Headset.sh file. Among other operations it sets
the mic volume to 48 (max). The script then changes to the
directory of the jcblock program:
	cd /home/pi/<yourPath>

You will need to substitute your path here. It then starts jcblock
running in the background (the &). It is important that it run in
the background so that the script can continue. The rest of the
script has to do with shutdown and will be discussed in the next
section.

It is convenient to have the startjcblock script run automatically
when the RPi boots. Normally scripts that must run at startup are
placed in /etc/init.d and soft links are made to them in
directories rcN.d, where N is the run level. These scripts run at
root level. But we would like our script to run at user level.
There is a feature of the cron utility, called @reboot, that will
do this.

When a RPi user uses the cron utility a file is created:
/var/spool/cron/crontabs/pi to hold the user commands.
The best way to edit this file is to run:
	$crontab -e

The file will be opened using the RPi user's default editor. Enter
the following line at the end of the file:
	@reboot /home/pi/<yourPath>/startjcblock &

WARNING! Don't forget the '&'! It causes the script to be run
in a forked off separate process -- so that the boot process
can continue. Without it the boot process will stall in the
script! If this happens to you, refer to section BOOT HANG
RECOVERY: below. There are other useful crontab options:
crontab -l lists entries; crontab -r removes entries. See its
man page for details.

Shutdown:
The lower part of the startjcblock script provides a way to
shut down the RPi (i.e., run: shutdown -h now) without having
to enter the command in a terminal window. It uses a package
called usbmount that automaticlly mounts a USB flash memory
stick on a fixed mount point when the stick is inserted. The
package is installed using:
	#apt-get install usbmount

To confirm installation, enter:
	#df -h

Then insert a USB flash memory stick (one with a vfat file
system on it) and enter the above command again. The drive
should appear mounted on /media/usb0. That insertion may be
used to initiate shutdown. The startjcblock script runs a while
loop that contains a test for directory shutdownDir on a flash
memory stick mounted on /media/usb0. If the directory is
present, the shutdown process is started. After the process is
started, wait for the RPi green LED (memory access) to stop
blinking before turning power off.

To make this work it is necessary to create directory
shutdownDir on a USB memory stick. With the stick mounted
enter:
	$mkdir shutdownDir

I have found that usbmount will mount a memory stick that
contains a vfat file system (as originally formatted). I had
no luck getting sticks with other file systems to work. 

With automatic startup and memory stick shutdown, the system may
be run "headless" -- that is, without display, keyboard or mouse.
Although unexpected power loss does not seem to cause damage, it
is prudent to run the system with a power source that is UPS
protected so that if power fails, there will be time to bring the
system down properly.  Note that for systems that do not contain
the audio card, the startjcblock script may be used if the audio
card configuration statements are removed.

Operation:
As indicated in the system photos, the mic needs to be mounted
in a fixed location above the modem speaker. There is a volume
control on the left side of the unit. I have mine set at half
volume. You may need to coordinate the mount position and this
setting with the THRESHOLD value in the tonesRPi.c file to get
acceptable detection results.

12 March, 2016: Raspberry Pi System with Sewell Voice/FAX Modem
-------------------------------------------------------------

The Sewell modem (~$17, available at Amazon.com) implements all
hardware functions needed by the program, including touchtone
detection. Therefore all features of the program are available with
this modem. The touchtone function is used to detect a *-key press.
When the program is in the *-key detection window, pressing the
key causes a record for the call to be automatically written to
the blacklist. The window opens when the listener hears some
"clicks". The listener then has ten seconds to press the *-key.
The window opens about seven seconds after the last received ring.

Since this modem required a fair number of program changes, a
separate source file was written. The new files needed for this
program are: jcblockAT.c, makejcblockAT and startjcblockAT. The
program uses POSIX threads (pthreads), so gcc compile option
-pthread is required in the makejcblockAT file. The pthread
library is available by default on the RPi.

The modem:
The Sewell modem comes with no documentation. It is a voice
modem and some voice AT commands were needed to activate the
touchtone feature. I was able to find a Cisco document containing
AT voice commands that was sufficient at (a one-line URL):

	http://www.cisco.com/c/en/us/td/docs/routers/access/modem/
		AT/wic/command/reference/atwic/atwic6.html

Not all the commands in the document work, but the ones used in the
program are described in the document. You can experiment with AT
commands using miniterm.py. See an entry under the Documentation
menu of this site for details.

Startup/Shutdown:
You may want to use startjcblockAT to start and shutdown jcblockAT.
See the writeups above under: Startup Script: and Shutdown: for the
similar script: startjcblock.

Platform:
I am running the program on a Raspberry Pi Model B+ processor. But
I developed and ran it on my Dell desktop. No changes were required
to run it on the RPi, so it will probably run on other RPi models
without changes. At most maybe some of the usleep() delays will
need to be adjusted. Keep in mind that we are using a modem in an
application for which it was not designed.

-------------------------For all systems ----------------------

ETHERNET SETUP:

I did most of my work with the RPi disconnected from the TV
and, instead, accessed over an Ethernet connection using ssh.
To set up the connection I edited file /etc/network/interfaces.
Since I prefer to use static connections for wired links I
commented out line: 'iface eth0 inet dhcp' and added the
following lines at the end of the file:
	iface eth0 inet static
	address 192.168.0.17
	netmask 255.255.255.0
	gateway 192.168.0.1

where the address was a free static address available from my
router and the router gateway address is 192.168.0.1. Then on
my desktop workstation I added the following line to file
/etc/hosts:
	192.168.0.17    raspi

After rebooting, I could then log into the RPi using:
	$ssh pi@raspi

The RPi asks for the password (by default: raspberry). If you
want to have a secure connection (and not have to enter a
password), and you have an RSA public key in your
.ssh/id_rsa.pub file, you can copy and paste it into file
.ssh/authorized_keys on the RPI (you will have to create
directory /home/pi/.ssh first). If you don't yet have keys in
your workstation .ssh directory you can generate them with
command ssh-keygen (see the man page or an online tutorial).

It is convenient to be able to run an X11 client on the RPi
and have it displayed by the X11 server on your workstation.
To do this the RPi file /etc/ssh/sshd_config must contain
these lines:
	X11Forwarding yes
	X11DisplayOffset 10

After rebooting, you should be able to remotely log in with:
	ssh -X pi@raspi
and run X11 clients.

At this point you should be able to transfer files to the
RPi with:
	$scp <filename> pi@raspi:/home/pi

and from the RPi with:
	$scp pi@raspi:/home/pi/<filename> .


	BOOT HANG RECOVERY:

As indicated above, it is possible to hang the boot sequence if
the startjcblock script is not constructed and called properly.
If this happens, the only solution is to remove the SD card and
mount it on another computer where corrections can be made. A
USB card reader is needed. Once the card is mounted, all files
will be accessible and you will be able to make corrections.

COUNTRY CODES:

Some modems require a country code that is specific for the
country of operation. The jcblock.c program contains a pre-
processor define, DO_COUNTRY_CODE, which may be uncommented to
send a code to the modem. It does this by sending modem command:
"AT+GCI=XX\r", where XX is the country code. Here is a list of
available country codes:

Australia	09	India		53	Philippines	89
Austria		0A	Indonesia	54	Portugal	8B
Belgium		0F	Ireland		57	Singspore	9C
Canada		20	Italy		59	South Africa	9F
Denmark		31	Japan		00	Spain		A0
Europe		72	Korea		61	Sweden		A5
Finland		3C	Malaysia	6C	Switzerland	A6
France		3D	Mexico		73	Thailand	A9
Germany	04 or	42	Netherlands	7B	Turkey		AE
Greece		46	New Zeland	7E	United Kingdom	B4
Hong Kong	50	Norway		82	United States	B5
Hungary		51	China		26	Vietnam		BC

Note that, as indicated for the TFM-561U modem, this may not be
the only change needed to get the program to work with a specific
country's telephone system. In fact, it is not clear what the
country code actually does! So this may or may not help. The
experience of one user in Italy is that it did not solve the
caller ID format problem for his TFM system.


RECENT ACTIVITY:

01 December, 2014: Way to make the TFM_561U send the fax tone.
--------------------------------------------------------------

If you uncomment define DO_FAX_TONE and replace statement:
	send_modem_command(fd,"AT+FCLASS=2.0\r");
with
	send_modem_command(fd,"AT+FCLASS=0\r");

the modem will send the fax tone (the caller will hear it).
I don't know why! This is just something I stumbled onto.
This does not work for the USR5637 modem.

13 March, 2015: jcblock.c correction; THRESHOLD change.
-------------------------------------------------------

If you are not using the *-key feature (DO_TONES is disabled),
this change does not affect you. Occasionally on the full 
function (USR5686G modem) system the first "off hook" command:

	send_modem_command(fd, "ATH1\r"); // off hook
returns:
	did not get command OK

I have added a quarter-second delay after the preceeding
open_port() call:
	open_port( OPEN_PORT_BLOCKED );
		usleep( 250000 );         // quarter second	

I "think" this will solve the problem, but can't be sure until
I get sufficient calls. Since this could take a month or two
(we only get 0-2 junk calls/day now), I thought I would submit
the change in case others are seeing the same symptom. The
program runs fine without the fix on the ebox system. Since the
RPi is faster and the two systems are using the same modem, I am
speculating that it is a timing problem. If I find out otherwise
I will submit a correction.

Recently I also changed the value of THRESHOLD in tonesRPi.c
from 0.5 to 1.5 on my system. As noted earlier, this is a
"tuning" parameter and its best value depends on the hardware
configuration of your mic, modem speaker volume, enclosure,
etc. You will need to adjust it for your own system. As a
consequence I am not submitting a tonesRPI.c file change.

14 April, 2015: jcblock runs on a Mac; general cleanup.
-------------------------------------------------------

A user reported that he has jcblock running on a Mac. He
compiled it using a C99 compiler (ISO 9899:1999) and it ran
immediately. The only difficulty was in determining the serial
port:
	./jcblock -p /dev/tty.usbmodem24680241

This is a version with the *-key feature disabled (DO_TONES is
commented out). The *-key feature requires the libasound ALSA
(Advanced Linux Sound Architecture) library, which (probably)
is not available on the Mac.

He also mentioned that the compiler spit out some non-fatal
warnings, so I decided to check the posted files for them.
I did this by adding option -Wall to the gcc command in file
makejcblock. Files jcblock.c, truncate.c, tones.c tonesRPi.c
required changes. I have uploaded these corrected files. No
functional change in program operation was involved, so you
may wish to ignore these changes.

Another user has ported jcblock to the Python language.

The above (13 March, 2015) addition of:

	usleep( 250000 );         // quarter second

seems to have fixed that problem, so it is now part of the
posted tonesRPi.c file.

09 June, 2015: jcblock version for ATian voice/FAX modem.
---------------------------------------------------------

Submitted a separate version (jcblockAT.c) for the ATian
modem. See the write-up above.

12 March, 2016: Revised jcblockAT documentation above.
------------------------------------------------------

If you have been following this project for awhile you will
know that I had some considerable trouble with itermittent
operation of the jcblockAT program. At that time I had the
ATian modem mounted on a board with the modem USB cable
"pinched" tight. Later I changed to a second ATian modem
that was unmounted. That system has run continuously without
a fault for over two months. Therefore the problem was either:
1) a faulty first modem (unlikely), or 2) a "pinched" USB
cable (likely). Lesson learned: don't "pinch" the USB cable!
Since this system: ATian modem/RPi/jcblockAT implements all
features of the program reliably, It is now the preferred
design. I revised the ATian documentation above to reflect
these results.

08 May, 2016: ATian modem replaced with Sewell modem
----------------------------------------------------

Well, just when I got everything working, a user reported that
the ATian modem is no longer available at Amazon.com! But the
same modem is available from a company called Sewell. If you do
a google search on 'Sewell voice/FAX modem' you will find a link
to it. It operates the same as the ATian. Also, you will find a
link to an offer from Amazon.com for the Sewell modem. Here is
a link directly to the Sewell modem:

https://sewelldirect.com/voicefax-56k-usb-modem-two-jacks-

06 June, 2016: Web-based interface to jcblock
---------------------------------------------

Don Cross sent me a description of a web-based graphical user
interface for jcblock. I have not yet tried it but it looks
very powerful. He has made a web site for it at:

https://github.com/cosinekitty/jcadmin

The site has screen shots and a good description. It uses Node.js,
which is a system for running JavaScript programs using Google's
JavaScript engine (called "V8"). He uses it to create a web server
called jcadmin that runs on the system running jcblock. Client
logic, jcclient.js, runs on the user's browser system (which can
be an iPhone or other cell phone display) and talks to jcadmin.js
using AJAX. Responses come back in JSON format. It is able to
display call data dynamically as calls come in!

30 March, 2018: Final jcblockAT update
--------------------------------

Occasionally (i.e., a few months) the SEWELL modem has hung in
the off-hook state. This is a very hard problem to solve! This
update attempts to solve it by completely reinitializing the
modem after each call and then sending an on-hook command. If
it is a hardware problem in the modem, itself, this may fix it.
(see NOTICE: below).

26 June, 2018: Update success
-----------------------------

The 30 March, 2018 jcblockAT program update appears to have
solved the "hang off-hook" problem. I have been running the
update for three months now without any errors. Evidently the
problem is in the modem. By completely reinitializing it after
processing each received call the problem is avoided. To my
knowledge, there are no other problems in the jcblock and
jcblockAT programs.

20 July, 2018: Final jcblock update
	-----------------------------

I corrected one warning (more "picky" compiler now) and disabled
software *-key detection (DO_TONES) to make program compilation
easier for first-time users. If you want *-key detection (highly
recommended) I suggest you get a Sewell modem and run jcblockAT
on it. The *-key feature allows you to automatically add a
record to the blacklist for the current call when the *-key is
pressed (after you hear some clicks on the phone line). The only
files changed were: jcblock.c, makejcblock and README2.
(see NOTICE: below)

NOTICE:
About two years ago I was diagnosed with Parkinson's disease.
Since then my symptoms have progressed to the point where I
am having difficulty typing, etc. As a result, I will no longer
be able to maintain this site. I will still answer questions
sent to me at: walsheath@gmail.com as long as I can. Thank you
for your interest and help with this project.
