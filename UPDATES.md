NOTICE: AS OF JANUARY 2016 NO FURTHER UPDATES WILL BE ADDED TO THIS
FILE. UPDATES FOR Raspberry Pi SYSTEMS ARE ADDED TO FILE README2.
THE FILE WILL REMAIN ON THE SITE FOR HISTOICAL BACKGROUND AND
DOCUMENTATION PURPOSES (example: the '++++++' feature).

Updates/Additions

1 January, 2009: Added whitelist
--------------------------------

	As a result of operational experience it became evident that
the addition of a whitelist capability would be helpful. A whitelist
file (whitelist.dat) contains entries containing the telephone numbers
of calls the user definitely wants to accept. The program checks for
caller ID matches of these entries first. If a match is found, the
blacklist check is bypassed and the call is accepted.

The issue came up when it was discovered that some telemarketers use
cell phones! For cell phone calls, the 'NAME =' field in the caller ID
string is always: 'Cell Phone   XX', where XX is the originating state
designator (e.g., CA for California). So using the 'NAME =' field as the
search string in a blacklist entry would cause all cell phone calls
from the indicated state to be blocked! In addition, the telemarketers
use several cell phones (probably as employees come and go), so using
the 'NMBR =' field in the caller ID as the search string does not catch
new cell phone callers. Adding a whitelist partially solves this
problem.

With a whitelist, the user can include entries that contain the cell
phone numbers of calls they definitely want to receive from a specific
state (e.g., CA). Then the cell phone 'NAME =' field for the state (e.g.,
'Cell Phone   CA') can be used as the search string in a blacklist
entry. With this arrangement all cell phone calls from the state will
be blocked *except* the ones with numbers present in the whitelist.

In certain cases it might be useful to run the program with just a
whitelist or just a blacklist. The program was modified to support
these cases. For example, a user might want to *only* accept calls
from specific numbers. In that case only a whitelist is needed.

Updates/Additions added after release jcblock_release_2-0

26 July, 2010: Added libasound comment to README file
-----------------------------------------------------

Some user's computers did not have the libasound library or the
asoundlib.h file installed. Text was added to the README file
describing how to install these files using a distribution's package
manager. Search the file for 'asound'. Some minor syntax changes to
printf and fprintf arguments were made in jcblock.c to satisfy more
strict type checking by recent versions of gcc.

30 July, 2010: Added #ifdef's to allow conditional compile
----------------------------------------------------------

Added Do_TONES and DO_TRUNCATE #ifdef's to allow a user to compile
the program with/without these features.

9 August, 2010: Switched from the 5 key to the * key to avoid conflict
--------------------------------------------------------------

It is possible that an automatic caller would present a list of
choices that included the 5 key ("press 1 for...press 5 for..."). If the
listener pressed the 5 key a blacklist entry for the caller would get
generated (if pressed within the listening window). To avoid this, the
key was switched to the star (*, asterisk) key, which is (almost) never
used.

17 August, 2010: Added code to handle non-standard caller ID fields
-------------------------------------------------------------------

Sometimes a call is received in which the NMBR field is not ten digits
and/or the NAME field is not 15 ASCII characters. Example:
--DATE = 081310--TIME = 1930--NMBR = 0--NAME = Unknown--
Some changes had to be made to the way the KEY-* code constructed a
blacklist.dat record for this case.

7 September, 2010 Added code to make sure a blacklist file is present
---------------------------------------------------------------------

I had it so the program would run if only a whitelist.dat was present
(no blacklist.dat file). That didn't make sense -- if a call was not
caught by a record in the whitelist it got answered anyway. If you
want to block all calls not in the whitelist, put a single record in
the blacklist that has a caller ID field that is always present (e.g.,
'NMBR'). I also updated documentation in the README file.

16 September, 2010 Added getopt() call to allow serial port selection
--------------------------------------------------------------------

The default serial port is: /dev/ttyS0. A different port may be specified
using call option -p. Example: jcblock -p /dev/portID

21 September, 2010 Added code to check for malformed list records
-----------------------------------------------------------------

blacklist.dat and whitelist.dat records must contain room for the date
field (so the date can be written to them). If a record does not contain
the required 26 characters (25 + a '\n'), the record is ignored and an
error message is printed.

24 September, 2010 Fixed conflict with telephone answering machines.
--------------------------------------------------------------------

Most answering machines are designed to terminate recording when any
phone on the called line is picked up. The star key feature takes the
modem off-hook to listen for a key press. This terminates the answering
machine's record operation. To avoid this, the program was modified so
that the star key feature is active only if the phone is answered after
the third ring (normal operation, since the third ring indicates that the
call was not blocked). The answering machine *must* then be set to pick
up after the fourth (or later) ring (most people do this). If an answering
machine is not installed on the same line, a conditional compile flag may
be commented out to remove this restriction and the star key feature will
then be available if the call is answered after the third (or later) ring.
Alternatively, the star key feature may be disabled altogether with a
conditional compile flag.

3 October, 2010, Upgraded to Ubuntu 10.04 from 8.04; changes needed.
--------------------------------------------------------------------

Ubuntu 10.04 runs Linux 2.6.32-25-generic. The gcc compiler is more
strict than the one in Ubuntu 8.04, so some changes were needed: Replaced
fprintf( fpCa, ...) with fputs( fpCa, ...) in file jcblock.c to write a
record to file callerID.dat. Directory /usr/include/alsa (and hence,
asoundlib.h) was not present. Loaded package libasound2-dev to correct
this. To speed up response, replaced the three usleep(500000) calls in
jcblock.c with usleep(250000). Other distributions using this version of
Linux (or close) will probably need similar changes.

16 October, 2010, Additional changes needed for Ubuntu 10.04 upgrade.
-------------------------------------------------------------------

Once I got a serial port installed on the new machine that I installed
Ubuntu 10.04 on, I discovered that the program did not run! I discovered
that the source of the problem was parameter 'frames' in the tones.c
file. I had it set to 32 and that value worked fine for the version
of ALSA included with Ubuntu 8.04. But for Ubuntu 10.04, it needed to
be raised to 128. See the NOTE: in the file for further details. At
the present I am using a USB serial port adapter that I got from
TigerDirect.com (~$15). Its discription is: Sabernt 6 Ft USB 2.0 Serial
DB9 Adapter W/ Male Thunbscrews. It worked immediately. Just plug it in
and run: jcblock -p /dev/ttyUSB0. I plan to test a PCI serial port card
soon.

29 October, 2010, Switched from Zoom 3048 to USRobotics 5686G modem
--------------------------------------------------------------------

	I have been using the USRobotics model 5686G modem since
	October 20, 2010 and have seen no errors. I have therefore
	decided to recommend using it instead of the Zoom 3048 modem.

	I used the Zoom modem during most of the development work on
	this project. However, late in the testing I discovered that
	occasionally it did not deliver caller ID data between the first
	and second rings. I tried two 3048 units and saw the same result.
	I also upgraded the firmware in one of them with no effect. I
	sent email to Zoom and got no reply. See the README file for further
details.

12 December, 2010, Evaluation of TRENDnet TFM-560X modem
---------------------------------------------------------

The TRENDnet 56k (V.92) modem is attractive because it is inexpensive
(~$30 vs. ~$90 for USRobotics 5686G; TigerDirect.com, phone/VISA order).
I was suprised to find that it (almost) worked with the jcblock program
when it was run on my Dell Inspiron 570 desktop computer. One problem
was that the caller ID string returned did not have spaces before and
after the equal signs. For example:
--DATE=1205--TIME=1343--NMBR=8885551212--NAME=Cell Phone    NH--
vs. what the program expects:
--DATE = 1205--TIME = 1343--NMBR = 8885551212--NAME = Cell Phone    NH-- 
I added code to detect and insert the spaces. The modem then worked
correctly with the program. There is also a startup problem: I had to
unplug its power and plug it in again to get it to talk to the program.
My conclusion is that it is currently not a good choice for this project.

It also doesn't work with my low power target ebox system. The program gets
"RING" strings but doesn't get the caller ID string between the first and
second rings. Since the program just waits on a blocked read of the modem
serial port, there's not much I can do to isolate this problem. I can only
speculate that it has to do with differences between the ebox and Dell
processors: 1)Linux 2.6-19/ebox vs. 2.6-32/Dell, 2)different clock rates,
3)different UART circuits, etc. If anyone has any ideas on this, please
let me know... The modem may work with target systems using a different
processor, so it may be worthwhile trying it since it is so low cost.

To use the modem with my Dell machine I first had to install a PCI serial
I/O card. I used a: StarTech.com PCI1S550 1 Port PCI 16C550 Serial Card.
Ubuntu found it and assigned node /dev/ttyS0 to it (the jcblock default).
I have also used a: SABRENT USB 2.0 to Serial (9-pin) DB9 RS-232 6-FT
Adapter Cable unit. Ubuntu installs this as /dev/ttyUSB0, so I ran jcblock
with command: jcblock -p /dev/ttyUSB0. I ordered both adapters from
TigerDirect.com. The jcblock.c file currently on the project's SourceForge
site has the code to insert the space characters if needed.

Summary: at this time I have tested three modems with the jcblock program:
Zoom 3048, TRENDnet TFM-560X, USRobotics 5686G. Only the USRobotics unit
works with jcblock without error. I suspect that, since caller ID is not
needed in most modem applications, manufacturers don't see much point in
getting it to work. So at present, you need to use the USRobotics unit.

26 January, 2011 Improved the star key tone detection algorithm
---------------------------------------------------------------

The tone detection algorithm must successfully detect the two tones
generated when the star key is pressed but reject voice audio received
by the mic either from the modem speaker or from ambient room sounds
(i.e., the speach of the person taking the call). The improved algorithm
uses narrower Goertzel filters and also requires ten consecutive detections
of both key press tones before a key press is declared. This requires the
star key to be held down for about 0.66 seconds.

21 August, 2012 Change to simply defeat a "Freshness Filter"
------------------------------------------------------------

It seems that Sourceforge removes projects from its Search facility
if no updates have occurred for a period of time (maybe one year?).
This project has not needed an update, so none have been made. This
addition to the UPDATES file was made simply to change a file so that an
update could be made. No program files were changed. A project update
was then performed. Hopefully, after this update users will again be able
to locate the project by entering 'jcblock' in the Search window.

28 December, 2013 Truncate file records after nine months
---------------------------------------------------------

After running the program (semi)continuously since 2008 on the platform
shown, I noted some occasional "erratic" behavior. Since the only change
that had occurred was the number of records present in the blacklist.dat
and callerID.dat files, I decided to test the program with a shortened
truncation time. So I made the following change in the truncate.c file:

I replaced preprocessor define:
	#define YEAR_SECS    365*24*60*60     // seconds in a (standard) year

with:
	#define KEEP_SECS  (365-90)*24*60*60  // seconds in (about) nine months

and replaced the references to YEAR_SECS with KEEP_SECS in the code.
These are the ONLY CODE CHANGES made. Other changes to file comments
and README text were made to reflect this change. This change corrected
the "erratic" behavior I was seeing. Evidently the number of records in
the .dat files was too large for the program to process. My blacklist.dat
file size went from 207 to 183 records; the callerID.dat file from 1052
to 827 records. This change may or may not be needed for other platforms.
The eBox-3300 has a clock speed of 1 GHz and contains a Vortex86DX SoC.
Note that a blacklist.dat record will still stay in the file indefinitely
as long as it is used to terminate a call within the last nine months. 

20 February, 2014 Added fax tone to off-hook code
-------------------------------------------------

Following suggestions received, I decided to add the generation of a
fax tone after the off-hook command. Others indicated that predictive
dialers will automatically flag a fax tone as a useless number to them
and remove it from their calling list. Some online research indicated
that the initial fax response to a call is to send a so-called CED tone.
This is followed by a 55 to 95 mS pause, followed by a Pre-Message
Identification consisting of 300 BPS "Line Turn-around" preamble. A CED
tone is a 2100 Hz tone that lasts between 2.6 and 4.0 seconds. I chose
to add code that would generate only the CED tone. Hopefully this will
defeat most dialers. The tone is generated by sending an ATA command
("answer incoming call" command). This command starts by sending a CED
tone, followed by additional setup negotiation tones. The code does not
wait for the negotiations. Instead, it switches the modem out of command
mode and back into data mode. It waits long enough for a three second
CED tone to be generated. This feature is optional and is only useful
for users that have a fax modem. It is activated by preprocessor define
DO_FAX_TONE in file jcblock.c. By default it is commented out so that the
program will run for fax and non-fax modems. All code changes for this
feature occurred in the jcblock.c file.

23 February, 2014 Added a tag to a call record
----------------------------------------------

I added code that replaces the first character in a call record with a
tag character before it is written to the callerID.dat file. The tag
indicates how the program handled the call. Here are the possible tag
values:
	B	The call record matched an entry in the blacklist, so
		the call was terminated.

	W	The call record matched an entry in the whitelist, so
		the call was accepted.

	*	The person receiving the call pressed the * key, so an
		entry was placed in the blacklist for the call.

	-	The call record did not match an entry in the blacklist
		or the whitelist, so the call was accepted.

All changes were made in the jcblock.c file.

01 March, 2014 Corrected tag_and_write_callerID_record() calls
--------------------------------------------------------------

A minor correction: Previously, the program tested this routine's
return value and, if the routine had failed, terminated its calling
routine (i.e., terminated wait_for_response()). That ended the program!
This change removed the tests, so the program continues. The
tag_and_write_callerID_record() routine still prints an error message
to the console if it has a problem (not likely). All changes were made
in the jcblock.c file.

05 March, 2014 Made provision for permanent blacklist records
-------------------------------------------------------------

Lately I have been getting calls with caller IDs that start with the
letter'V' followed by nineteen (seemingly random) digits. I was able
to partially block them by adding blacklist records with these first
fields: V0?, V1?, V2?, V3?, V4?, V5? V6?, V7?, V8?, V9?. But if one (or
more) of these records was not used to terminate a call in nine months,
it was removed by the truncate routines. This pointed to the need for a
way to specify permanent blacklist records. So code was added to the
truncate_blacklist_records() routine to test for a record date field
containing '++++++'. When it is found, the record is not deleted. All
code changes were made in files jcblock.c and truncate.c. Some comment
editing was also done in files: blacklist.dat.examples and
whitelist.dat.examples.

08 April, 2014 Changed method of terminating a call
---------------------------------------------------

A project collaborator informed me of a much better way to terminate a
call. Instead of sending off-hook and on-hook commands, the new method
uses properties of modem initialization command: 'AT&D2\r' to accomplish
the termination. This command instructs the modem to terminate the
current call if the modem's serial port DTR line becomes inactive. This
line becomes inactive when the port is closed. So the program closes the
port and then re-opens and re-initializes it to accomplish call
termination (see function close_open_port()). The new method is faster,
so a blacklisted call gets terminated after just one ring.  With this
change, the '*-key' method for automatically adding a call to the
blacklist was extended so that it may be used after the second or third
ring if an answer machine is present, or for any ring after the first if
not. All code changes were made in the jcblock.c file. The README file
was updated to reflect the changes.

29 April, 2014 Added code to truncate too-long caller ID fields
---------------------------------------------------------------

Recently I have been receiving calls that had caller ID fields that
were longer than the normal maximum of 15 characters. I added code to
truncate them to 15 characters. For example, caller ID:
	V4231749020000150314
is now truncated to:
	V42317490200001
The code change was made to the jcblock.c file.

29 April, 2014 Added code to send call record UDP datagrams
-----------------------------------------------------------

Project collaborator Dave Brown submitted code that broadcasts call
records as UDP datagrams to waiting client programs. A sample Python
client program is included (of course, clients may be written in any
language). The call record is the same as the record that is stored in
the callerID.dat file. This is an optional feature that may be
activated by uncommenting preprocessor define SEND_ON_NETWORK. By
default it is commented out. Clients may be run on the same machine or
on networked LAN machines. Client machines may use wired or wireless
connections. The UDP connection uses port 9753, so the machines must
have that port open (i.e., not blocked by firewalls). With Python
installed, the sample client program may be started with command:
	python radioclient.py 

The jcblock.c file contains minor code changes. Most of the code is in
files radio.c, radio.h and radioclient.py. Dave will be submitting a
more extensive client program as a separate project in the near future.
When it is available I will include instructions in this file for
locating it.

13 May, 2014 A reference to Dave's UDP-Python project
-----------------------------------------------------

Dave has a GitHub site for his 'jcmanage' project at:

	https://github.com/smurfless1/jcmanage

It is a work-in-progress, so check back from time to time.

03 June, 2014 non-FAX operation on a FAX USRobotics 5686G modem
---------------------------------------------------------------

In testing the non-FAX mode on my 5686G FAX modem I discovered that
the 1-ring-to-block method for terminating a call was not working.
This update corrects the problem. For the non-FAX mode it makes
sure the modem is in the non-FAX command mode by sending command
"AT+FCLASS=0\r". Then, to get the DTR-drop trick to cancel the call,
I had to include timed command "ATA\r" with a one-second timeout.
If you have been running with a non-FAX modem and the program has
been operating correctly, this change should not affect you.

22 June, 2014 Provision for time-limited "beep" *-key tone
----------------------------------------------------------

For phones that send a time-limited "beep" when the *-key is
pressed (e.g., wireless phones), this option allows the operator to
press the *-key twice to indicate that a blacklist entry should be
added for the call. Note that there is some risk that a "false
positive" result may occur. That is, the algorithm may interpret
"audio noise" as a beep and create an unintended blacklist entry for
the call. The noise can come from: 1) caller audio, 2) audio in the
room where the phone is located or 3) audio from the room where the
modem is located. Requiring two beeps helps to mitigate the risk.
A way to avoid the risk is to put important calls on the whitelist.
The user must still: 1) wait for a second or third ring before
answering, 2) wait for the window-open "clicks" and, 3) in the ten
second window, enter two (or more) *-key presses. Note that the
original detection method (for phones with non-time-limited tone
generation when the *-key is pressed) is still present whether
DO_BEEPS option is activated or not. This option is deactivated by
default in the tones.c file. All changes were made in that file.  

08 August, 2014 Clear audio buffer before tones polling
-------------------------------------------------------

If you are not using the tones detection feature, this change will
not affect you. Recently I had been seeing occasional false postings
of calls to the blacklist. The tones detection algorithm was
indicating ten detections immediately when the call was received. I
suspect that audio samples from the previous call were still in the
ALSA buffer (very hard to tell what happens in the ALSA library
functions!). I added function tonesClearBuffer(). It is called just
before tone polling begins in jcblock.c (before the tonesPoll() calls).
The function is located in the tones.c file. It calls ALSA library
functions snd_pcm_drop() and snd_pcm_prepare(). The first removes
any audio samples currently in the buffer. The second reinitializes
the channel. Files jcblock.c, tones.c and common.h were changed.
(Why this bug showed up at this late date is a mystery!)

20 August, 2014 Initialize numBeeps before tones polling
--------------------------------------------------------

I had a case where a number was placed on the blacklist when only
one tone beep was detected. This could happen if only one beep was
detected for the previous call and 'numBeeps' was left set to 1.
To correct this, numBeeps needs to be set to 0 before tone polling
starts. The most convenient place to do this was in function
tonesClearBuffer(), even though the operation has nothing to do
with clearing the buffer. This was a dumb error on my part. After
fifty years of programming I should have known better (yes, there
were a few computers around in 1964!). Sorry for the inconvenience.
The only code file changed was tones.c.

NOTICE: AS OF JANUARY 2016 NO FURTHER UPDATES WILL BE ADDED TO THIS
FILE. UPDATES FOR Raspberry Pi SYSTEMS ARE ADDED TO FILE README2.
THE FILE WILL REMAIN ON THE SITE FOR HISTOICAL BACKGROUND AND 
DOCUMENTATION PURPOSES (example: the '++++++' feature).

