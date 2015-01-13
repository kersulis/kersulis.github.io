---
layout: post
title: Installing MATLAB on Ubuntu Linux
image:
  feature: MATLABdoityourself.png
  <!-- teaser: MATLABfail.png -->
  credit: Jonas Kersulis
  creditlink: https://plus.google.com/+jonaskersulis/posts
---

It's no secret that MATLAB focuses on Windows users. Mac gets some love, but Linux gets zero. This is how you install MATLAB R2013a on Linux.

My situation:  I purchased a MATLAB student license through my school last year. After using MATLAB on Windows during the school year, I decided to switch to Julia on Ubuntu during my summer internship. I fell in love with Julia, IPyton notebooks, and Ubuntu; I vowed never to return to my dated MATLAB ways. Now it's the fall semester and I'm taking a class that requires MATLAB. I reasoned with the professor (who uses Julia himself), but he said I must turn in MATLAB code like everyone else. Fine. I'm disappointed, but not despondent. For my first homework assignment I did everything in Julia then rebooted into Windows to write MATLAB code. I turned in both versions of the code. Not willing to give up IPython notebooks, I wound up pasting the MATLAB code from a dropbox-synced .m file into the IJulia notebook containing my Markdown and Julia code.

It took forever. I need to get MATLAB working on the Ubuntu side.

**Step 1:**  Google "download matlab linux". Find [this super-long page][1] that beats around the bush without telling you, as a Linux user, what to do.

**Step 2:**  Google "download matlab" in hopes that a more generic query will yield a more useful page. Find [this page][2].

**Step 3:**  Choose "Download Previously Purchased Products" and then "Linux (64-bit)". Thank God I don't have a 32-bit system.

**Step 4:**  Find that I must have JRE to download multiple MATLAB products at once. Even though MATLAB is a massive, decades-old company, I need to download third-party software in order to install it. Of course, I could just manually download each piece, but I don't have six hours to carve out of my schedule.

**Step 5:**  Choose "I have JRE" because I have Java and that should be good enough. Check the packages I want on the list that appears, and click "Download".

**Step 6:**  Open the "download_agent" file that appears in my Downloads folder. See a Firefox window displaying raw XML and telling me it doesn't know what to do.

**Step 7:**  Look for Java plugin on Chrome, find that it [never existed on Linux][3] and [no longer exists anywhere else][4].

**Step 8:**  Scratch head. Download [Java][5] as compressed binary for 64-bit Linux in desperation.

**Step 9:**  Unpack .tar.gz and explore. Try passing "download_agent" to "java" as an argument to no avail.

**Step 10:**  Google "how the fuck do I install matlab on linux?" Find a [hysterical catalog of MATLAB's inadequacies][6].

**Step 11:**  [Discover that something called "Java Web Start" is the program that runs "download_agent"][7].

**Step 12:**  Guess that `jre1.7.0/bin/javaws` is the magical "Java Web Start" program that can make this nightmare go away. Run `javaws ~/Downloads/download_agent`.

**Step 13:**  See the MATLAB download assistant program. Wipe tears of joy on sleeve.

**Step 14:**  Wait two hours for 1.5 GB of MathWorks software to download over the school Wi-Fi network. Write blog post while waiting.

**Step 15:**  Launch installer. Accept license agreement. Tell installer it's okay to create `/usr/local/MATLAB/R2013a_Student` and put MATLAB there. See error:  "Failed to create folder (/usr/local/MATLAB/R2013a_Student/)." Guess I need to re-run the installer with sudo privilege?

**Step 16:**  Run installer using `sudo ./install` in 

```
/tmp/mathworks_downloads/R2013a_Student_Version
``` 
Accept license agreement again. This time the installer is able to make a new folder. Hallelujah.

**Step 17:**  Tell installer to create symbolic links in `usr/local/bin`. Confirm all my elections thus far. Depending on how long this takes I may need to cancel. One does not simply skip a pasta dinner.

**Step 18:**  See activation window, which tells me to enter a serial number and email. Go to My Account on mathworks.com, download license file, copy into 

```
/usr/local/MATLAB/R2013a_Student/licenses
```

**Step 19:**  Try running `matlab` from command line. See this:

```
License checkout failed.
License Manager Error -9
The hostid of your computer (000000000000) does not match the hostid of the license file
(DISK_SERIAL_NUM=20383011).

Troubleshoot this issue by visiting:
http://www.mathworks.com/support/lme/R2013a/9

Diagnostic Information:
Feature: SR_MATLAB
License path: /home/jkersulis/.matlab/R2013a_licenses:/usr/local/MATLAB/R2013a_Student/licenses/license.dat:/usr/l
ocal/MATLAB/R2013a_Student/licenses/license.lic
Licensing error: -9,57.
```

**Step 20:**  Cry inside. Google "matlab serial number" hoping there is a way to find the actual number rather than downloading an ignorant broken license file. Find [this page][8].

**Step 21:**  Go back to My Account and notice the serial number in a tiny, lightweight gray font. Swear profusely.

**Step 22:**  Enter serial number and student email into activation window. See this:
	Error -2,007: Unable to activate your machine. The activation process cannot detect a valid Host ID which utilizes a currently supported naming convention. Please refer to the following solution ID, to help resolve this issue: 1-661QJD

**Step 23:**  Abandon hope of finishing this grueling process today. Google "1-661QJD", which makes top ten stupidest search queries of my life.

**Step 24:**  Find [this page][9], which says I need to jump through hoops to get my computer to produce a unique machine ID so MATLAB can make sure I'm not cheating.

**Step 25:**  Realize that illegal activation via fake license would have let me unlock the entire MATLAB product suite and go home after Step 18.

**Step 26:**  Sigh deeply. Go home to eat dinner.

**Step 27:**  Delete license file from Step 18, run `sudo matlab`. Enter serial number, school email address, and other personal info.

**Step 28:**  Receive warning that I cannot add a new activation as I have too many. Go to my MathWorks account page and deactivate the MATLAB on my 6-year-old laptop (which doesn't even have MATLAB on it anymore).

**Step 29:**  Run `sudo matlab` again.

**Step 30:**  Receive confirmation that MATLAB has been registered and is ready to go. Sleep.

All this and I still get a nice "Student License" warning every time I open the program along with an obnoxious watermark on every plot I produce. Thanks MathWorks!

## S. Morris's 3-step process to install R2011a on Ubuntu 11.04:

1. Go back in time to 2011.
2. Download MATLAB R2011a from PirateBay.
3. ./run

[1]: http://www.mathworks.com/help/install/ug/install-mathworks-software.html
[2]: http://www.mathworks.com/downloads/web_downloads/
[3]: https://support.google.com/chrome/answer/2429779?hl=en
[4]: http://askubuntu.com/questions/470594/how-do-i-get-java-plugin-working-on-google-chrome
[5]: https://java.com/en/download/manual.jsp
[6]: http://abandonmatlab.wordpress.com/
[7]: http://www.mathworks.com/matlabcentral/answers/100421-how-do-i-open-the-download_agent-file-that-was-downloaded-on-my-mac-os-x-machine
[8]: http://www.mathworks.com/matlabcentral/answers/92207-where-do-i-find-the-serial-number-for-my-matlab-simulink-student-version
[9]: http://askubuntu.com/questions/280000/unable-to-activate-matlab