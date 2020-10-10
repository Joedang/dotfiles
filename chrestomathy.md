# A little gallery of neat one-liners and helpful reminders
This is like Stack Exchange, but past-Joe answers the questions of present-Joe.
(Necessarily, this only works if present-Joe answers the questions of future-Joe,
by recording how he solves new/obnoxious problems.)

## Shell
`man bash` and `man zshall` are examples of how to learn about your shell (Bash and Zsh, respectively).

### How to tell what shell you're in
All of these work:  
```bash
echo $0
echo $SHELL
ps | grep $$
ps -$$
```
Note, `$$` expands to the process ID of the current shell.

### Get information about CLI tools
- man -- brief manual pages
- info -- long-winded and explanations, but often just the man page
- apropos -- man pages with matchning keywords
- which -- tells you where a command is located 
- type -- tells you how a command will be interpreted (`/^\s*type` in `man bash`)

### How to change your default shell
```bash
chsh -s /usr/bin/zsh
```

### Built-ins
Many commands, such as `read`, `source`, `fg`, `bg`, and `cd`, are built into Bash and don't have their own man pages. 
The Bash manual (`man bash`) talks about these under the heading __SHELL BUILTIN COMMANDS__ on line 2580.
`/^\s*type` in `man bash` would find the `type` built-in relatively quickly by searching for a line that starts with some whitespace followed by "type" (assuming `less` is your pager).

#### Special Variables
```bash
$? # exit status of the previous command
$! # PID of the previous backgrounded command
$0 # the name of the command that invoked the current process
$1 # the first argument of the process
$2 # the second argument of the process
$@ # all arguments of the process
```

#### read
IMO, this is mostly useful for processing files found by `find` or `ls`. 
For this purpose, the `-r` flag is almost always preferred, so files with spaces in their names won't get broken into multiple words. 
(This obvioulsy requires that you feed `read` file names with the spaces escaped.) 
If you want to mess with how the words are broken up, you need to \[temporarily!\] modify the variable `IFS`, which controlls how words are broken. (This is similar to how you might hack `for f in *` to cycle through file names.)

### Getting Around
#### Tree
`tree` is a super-useful command that shows you the structure and contents of a directory.
This will give you an HTML file that links to everything, so you can view it in a browser:

    `tree -H file://\`pwd\` > tree.html` 

### Output Redirection
`echo asdf 2>&1` redirect stream 2 (stderr) to stream 1 (stdout) (so, you get both)  
`echo asdf 1>&/dev/null` redirect stdout into /dev/null (so, basically ignore it)  
`echo asdf >> both.log 2>&1` redirect both outputs to a log file  
`ls notafile 2>&1 | tee -a asdf.log` redirect both outputs to a log file and the terminal

### Readline Configuration
The `readline` library controls the behavior of a lot of programs that use a command line interface (CLI).
This includes shells like Bash and Zsh, as well as stuff like R and Python.
The ~/.inputrc file controls the behavior of this library.
So, spending some time on that can make *all* your shells more productive, enjoyable, and uniform.
The system default is usually somewhere like `/etc/inputrc`.

## R
### Figure out what you're looking at
`str()` gets the structure of something (e.g., if you have a list of lists.)  
`typeof()` tells you the storage type of something.  
`class()` tells you... the class of something.  
`help()` and `??` give you the help pages for functions.  

## Python
### Figure out what you're looking at
`help()` will sometimes give you useful information, if the package authors have bothered to tell you how their objects work.   
`dir()` will tell you the attributes of a thing, though there are usually too many for this to be helpful.  
`print()` can be helpful, but many similar types print in identical ways.  
`type()` tells you the type of an object (specifically, what modules/objects it comes from). This can be surprisingly useless...  

### matplotlib
The usual calls you want are `import matplotlib.pyplot as plt` and `plt.plot(x,y)`.  
If you're going topless (without a display server), you'll need to do 
```python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
```
Otherwise, `matplotlib` will try to access your non-existant cursor and trip all over itself. 

### sequences
Typically, the pythonic way to do things is to use generators instead of sequences. So, stuff like `range()` which only gets instantiated inside things like `for` and `with`.
(__Pay attention to off-by-one errors here!!!__ The convention for this built-in is inconsistent. `range(1,10)` generates the integers from 1 to 9, the last of which is accessed by index 8. Seriously.)

For lists of floats, `numpy.linspace(start, stop, num)` is the best option. Apallingly, there is no mainstream equivalent (AFAIK) to R's `seq()`, so you'll have to manage the step size between elements on your own (and deal with the corresponding fence post rounding BS).

## RegEx
### look-ahead and look-behind
Example: look for anything occurring between `filename="` and `"`. Note that this is using the Perl syntax, `-P`.

```
cat dumpHeader.out | grep -P -e '(?<=filename=").*(?=")'
```

### negative look behind 
Look for "respond" but not "correspond".
```
grep -riP '(?<!cor)respond'
```

Vim, for example, does not use the Perl syntax. See the `pattern-multi-items` help for more info.  

### Lazy Matching
This is also called non-greedy matching.
Say I have an HTML file, and I want to match individual bold sections.

```
<b>Match this,</b> but not this this.  <b>Also match this.</b>
```

`grep -o -P '<b>.*?</b>' example.html` would match only the bold tags and their contents,
unlike `grep -o '<b>.*</b>' example.html` which also matches stuff between bold elements.
Note that this is a Perl-ism, as indicated by the `-P` flag. 
So, this won't work in some regex systems.

### Negation
An example of a negation in Vim would be `^#\@!`, which matches any line that doesn't start with an octothorpe. 

## Get the number of pages in all the PDFs in the CWD:

    ls *.pdf | awk -e '{print "pdfgrep -n [:alphanum:] "$1"| tail -1"}' | sh

Pipe the names of the PDFs to awk. 
Use awk to build those into a command which:
	* uses pdfgrep to search that PDF for lines with any alphanumeric character, prepending the line number
	* pipe the results to tail, which cuts out all but the last result
Send that command to the shell.

This doesn't tell you the file names, and also outputs the text on the last line of each PDF :(

## disable auto-mounting 
My hope is that this is an easy way to thwart usb attacks.

Using dconf-editor, under `org.gnome.desktop.media-handling`, uncheck `automount` and optionally `automount-open`.

To do this without a GUI, you'd do
`gsettings set org.gnome.desktop.media-handling automount false`.

Both of these are frontents for `dconf`.

## get Arduino working

    $ sudo apt-get install arduino arduino-core

* Plug in the arduino
* In the IDE, go to `Tools` -> `Port` select the arduino. (Either figure it out by plugging it in/out or by having it be the only thing plugged in.)

You'll probably need to add yourself to the usergroup that's allowed to talk to ports:

        $ sudo usermod -a -G dialout joedang
On some machines, you may need to restart after adding yourself.

## Key Mapping
### Basics
"Keycodes" refer to the numerical designations of physical keys.
"Keysyms" refer to the abstract syntactic meaning of those keys.
Keysyms have a four-byte hexadecimal representation, but are also referred to by human-readable strings.
Keyboard layouts define how keycodes are translated into keysyms.

For example, keycode 9 refers to the top left key on my keyboard, which happens to have "Esc" printed on it.
Meanwhile, keycode 66 refers to the far-left key on the home row, which happens to have "CapsLock" printed on it.
If I'm using the "correct" keyboard layout, keycode 66 (the "CapsLock" key) will send the "Caps_Lock"

### Tools
`setxkbmap` is the "porcelain" for keyboard layouts.
It allows you to select layouts, perform common remappings, and other stuff.
You can find a list of the pre-configured remapping optins in 
`/usr/share/X11/xkb/rules/base.lst`.
Note that these options are not systematic. Just because you can write something
that sounds like a thing, doesn't mean it will work.
For example, `setxkbmap -option caps:escape` is an option to take whatever keycode is currently
mapped to the Caps_Lock keysym and map it to the Escape keysym. 
However, `a:b` will not do they same with the "a" and "b" keysyms, 
because that is not a preconfigured option.
For something like that, you'd need to use `xmodmap`.

`xmodmap` is a bit more low-level. 
It allows you to explicitly map individual keycodes to keysyms.
`setxkbmap -layout us -option` will reset the keyboard layout to "us" and
clear all the options.

`xev` will print out X events. 
This can be used to figure out what the keycodes of physical keys are 
and what keysyms they're sending.

`xinput` will configure and explore the attached input devices.
`xinput list` shows you what's connected and what it's device ID is.
`xinput list-props DEVICE_ID` shows you the available properties of a device,
what the IDs for those properties are, and what the values of those properties
are.
`xinput set-prop DEVICE_ID PROPERTY_ID` lets you change those properties. 
This can be used to change things like trackpad behavior and pointer acceleration.

### Config Files

## Sensor Status
The `sensors` command from the `lm_sensors` library will print out some pretty info.

### Power
`/sys/class/power_supply/BAT0/` typically has info on the main battery. 
The `power_supply/` directory typically has useful info on other devices.

`upower` can give prettier output, but you need to give it a special device name.
The `upower` man page isn't fully written, so use `upower -h`.
`upower -e` will tell you what device names are available. 

### Temperature
`/sys/class/thermal/thermal_zone0/temp` typically has the temperature of the CPU in milli Celsius. 

## Checking Checksums
Use `$ md5sum myPackage.tar.gz` to show the MD5 hash for a file.  
Use `$ md5sum -c fileList.txt` to check if multiple files are 'OK', with `fileList.txt` being something like 

```
283158c7da8c0ada74502794fa8745eb  ubuntu-6.10-alternate-amd64.iso
549ef19097b10ac9237c08f6dc6084c6  ubuntu-6.10-alternate-i386.iso
5717dd795bfd74edc2e9e81d37394349  ubuntu-6.10-alternate-powerpc.iso
99c3a849f6e9a0d143f057433c7f4d84  ubuntu-6.10-desktop-amd64.iso
b950a4d7cf3151e5f213843e2ad77fe3  ubuntu-6.10-desktop-i386.iso
a3494ff33a3e5db83669df5268850a01  ubuntu-6.10-desktop-powerpc.iso
2f44a48a9f5b4f1dff36b63fc2115f40  ubuntu-6.10-server-amd64.iso
cd6c09ff8f9c72a19d0c3dced4b31b3a  ubuntu-6.10-server-i386.iso
6f165f915c356264ecf56232c2abb7b5  ubuntu-6.10-server-powerpc.iso
4971edddbfc667e0effbc0f6b4f7e7e0  ubuntu-6.10-server-sparc.iso
```
which the distributor will usually provide in that format.  
You can do `$ find -type f -exec sha512sum '{}' + > check.txt` to create such a list.

When you download the source for stuff, this helps you verify that it's not corrupted (or, you know, tampered with). You can also use it to verify that large copy jobs haven't been corrupted.  

If you hash the concatenation of a password and a website name, you can use that as a crude way of adding security to a reused password.
(When you need to log in, rehash the password + site name and copy the result into the password field.)

## Cron Jobs
`cronie` is the implementation I went with on `arxgus`.
It needed to be enabled/started with Systemd.

A user's "crontab" contains "cron jobs".
Each user gets a crontab.
Each jobs is a command that gets run at the specified times.

Cron jobs are edited with `crontab -e` and read with `crontab -l`.
They are not meant to be edited directly.

### Jobs
Cron jobs use the following format.
Each uncommented, non-empty line of a crontab is a job.  
`M H d m u /path/to/command arg1 arg2`  
The things before the command specify when they command is meant to be run.
They are:

| field | scale            | range
| ---   | ---              | ---
| M     | minutes          | 0-59
| H     | hours            | 0-23
| d     | days             | 0-31
| m     | months           | 0-12
| u     | days-of-the-week | 0-7 (Sunday is 0 and 7)

In addition to the numeric values, you can use these symbols to express more complicated schedules:

| symbol | meaning
| ---    | ---
| *      | all possible values
| ,      | separates values in a list
| -      | specifies a range
| /      | specifies a step

The following shorthands can be use to replace the entire 5-field schedule:

| shorthand | meaning
| ---       | ---
| @hourly   | Run once every hour i.e. `0 * * * *`
| @midnight | Run once every day i.e. `0 0 * * *`
| @daily    | same as midnight
| @weekly   | Run once every week, i.e. `0 0 * * 0`
| @monthly  | Run once every month i.e. `0 0 1 * *`
| @annually | Run once every year i.e. `0 0 1 1 *`
| @yearly   | same as @annually
| @reboot   | Run once at every startup

#### Examples
The first job will append "cron works" to `/tmp/crontest` every minute.
The second line will append the same to `/tmp/crontest_hourly` every hour.
```cron
* * * * * /usr/bin/echo "cron works" >> /tmp/crontest
@hourly /usr/bin/echo "cron works" >> /tmp/crontest_hourly
```

### Permissions
Each line of `/etc/cron.allow` contains the username of someone who is *allowed* to use `crontab -e`.
If this file exists, but your username *isn't* in it, `crontab -e` shouldn't work.

Each line of `/etc/cron.deny` contains the username of someone who is *disallowed* to use `crontab -e`.
If this file exists, and your username *is* in it, `crontab -e` shouldn't work.

The cron jobs for a user are run *as* that user.
If you need a cron job to be run as another user, like root, you can use the `su` command or the `-u` flag for crontab.
Note that this will edit the crontab *for that user*, not your crontab.

## Timestamp Manipulation
Set all the mp3 files to have the timestamp of `../flac/Tiger.flac`:  
`$ touch -d "$(date -R -r ../flac/Tiger.flac)" *.mp3`

## Mass Renaming
Strip the track number from a bunch of songs:  
`$ rename 's/^[0-9][0-9] - *//' *`  

```
01 - The Starting Line.mp3  
02 - Floor Corn.mp3         
03 - ACVC.mp3               
04 - 300MB.mp3              
05 - Revolution #5.mp3      
06 - Dear Dinosaur.mp3      
07 - Annoyed Grunt.mp3   
08 - Bustin.mp3          
09 - Blockbuster.mp3     
10 - Busta.mp3           
11 - Tiger.mp3           
12 - The End.mp3         
13 - Shady Interlude.mp3 
14 - T.I.M.E..mp3        
15 - Smooth.mp3
16 - Stand By Meme.mp3 
17 - Wallspin.mp3
18 - Wow Wow.mp3
19 - Mouth Pressure.mp3
20 - Shit.mp3
```
becomes
```
300MB.mp3
ACVC.mp3
Annoyed Grunt.mp3
Blockbuster.mp3
Busta.mp3
Bustin.mp3
Dear Dinosaur.mp3
Floor Corn.mp3
Mouth Pressure.mp3
Revolution #5.mp3
Shady Interlude.mp3
Shit.mp3
Smooth.mp3
Stand By Meme.mp3
The End.mp3
The Starting Line.mp3
Tiger.mp3
T.I.M.E..mp3
Wallspin.mp3
Wow Wow.mp3
```

## Media Conversion

### Audio and Video
`avconv`\* and `flac2mp3` are pretty good. The default settings for `flac2mp3` are basically perfect. You'll probably have to compile flac2mp3 from source.  
\* Lately, `avconv` has not been so great. It couldn't find the codecs required for writing to `mp3`, despite attempts to help it find them.
`lame` is a stand-alone library/command that *only* writes to `mp3`.  
`easytag` is a GUI-only program that handles `mp3` tags (called `ID3`).  
`youtube-dl` is also good for acquiring stuff, but don't count on your package manager's repos being up to date _\*cough\*Ubuntu\*cough\*_. You pretty much have to compile both `youtube-dl` and `avconv` from source. (`libav` is the parent package/project for the `avconv` command.)

#### Remove Audio from a Video
The `-an` flag for `ffmpeg` can be used to remove all audio streams from an output file.
There are similar flags for video, subtitles, and data.
`ffmpeg -i input.mp4 -c copy -an silent.mp4`

### Create animated GIFs
`convert -delay 20 -loop 0 *.png myanimation.gif`  
Compiles all the `PNG`s in the WD to a `GIF`.

A nice way to preview this kind of stuff is with the `animate` command.

I also made a `vid2small` utility in Python3 that can convert stuff to `GIF`.

### Concatenate large videos
Some cameras will output video in chunks, to avoid excessively large files. This can potentially be a pain for editing, if there are many files over which a single shot is broken.

Some file types, such as mp4 can actually be concatenated directly using `cat`. However, this does not recalculate the time stamps, so viewers like `vlc` will not see anything but the first video. 

You can use the `concat` demuxer in ffmpeg to concatenate such files and recalculate the time stamps (without deencoding and reencoding the videos) like so:

```bash
$ cat vidList.txt
file 44.mp4
file 45.mp4
file 46.mp4
$ ffmpeg -f concat -i vidList.txt -c copy bigVid.mp4
```

### Extract Frames From a Video
You can just specify the output file in ffmpeg to be an image with a printf-style number.
In this example, the `drawtext` video filter also adds a timestamp.
```
ffmpeg -i sourceVid.mp4 -ss $(startTime) -to $(stopTime) \
-vf "drawtext=text=time\= %{pts} s: \
fontcolor=green: x=5: y=5: fontsize=35" \
frames%03d.png
```


## Installing Fonts
GIMP checks for typefaces on its own, so running `$ sudo fc-cache -fv` may be unnecessary.

### For Everyone:
Copy the font to `/usr/share/fonts/truetype/` (or the appropriate directory if it's not TTF) and run `$ sudo fc-cache -fv`.

### For Only You:
Copy to `~/.fonts/` and run `$ sudo fc-cache -fv`.

## Operations within subfolders
The `-exec` option in `find` is useful for this. For example, you can create checksums for all the `mp3` files in the CWD by doing

```bash
find . -name '*.mp3' -exec md5sum '{}' \; | tee -a mp3checksum.mp3
```

## Steganography (hiding messages in files)
`steghide` works well, but is limited to a few file formats.

### embed files:
```bash
steghide embed -ef secret.txt -cf fluffybunny.jpg -sf fluffybunny_steg.jpg -p "12345password"
```

### extract from stego' files:
```bash
steghide extract -sf fluffybunny_steg.jpg -xf extracted_secret.txt "12345password"
```

## Sync files between *nix machines
Pull from a remote directory:
```bash
rsync -r user@host:~/yourdir/ ~/mydir/
```
Push to a remote directory:
```bash
rsync -r mydir/ user@host:~/yourdir/
```
`user` is your login name on that machine. (You will need to know the password for `~/.ssh/id_rsa` to get in.) `host` can be an IP address or a domain (`192.168.1.1`, `pdx.edu`, et cetera).

You can also explicitly use ssh as the wrapper for rsync, if a machine doesn't like to talk to rsync by default.
For example, using ssh over port 2222 to copy test.txt from a machine at a local IP:
`rsync -e 'ssh -p 2222' user@192.168.1.111:test.txt ./`

## Git
### Separating Out Histories
Let say, hypothetically, that someone was a butt with their repos. 
They have a repo named `lv3.0-recovery` and, rather than renaming the repo to
`lv3-recovery` and continuing to work or making a new repo called
`lv3.1-recovery`, they've made a directory named `LV3.1` within it and done all
their work in there.

```
git clone lv3.0-recovery lv3.1-recovery                 #1
cd lv3.1-recovery                                       #2
git filter-branch --subdirectory-filter LV3.1 -- --all  #3
```

On line 1, we create a new repo. This could probably be done in a branch, but
paranoia. On line 2, we go into that repo.
On line 3, we rewrite the history to only include the `LV3.1` directory.
This new history will have the same commit messages, dates, names, et cetera.
However, the commit hashes and parents will change.

## SSH
"Secure SHell" (SSH) is a tool to securely communicate with another machine.

### Server
In order to connect via SSH, the host machine (the one where you aren't executing the ssh command) 
needs to have an SSH server running and a port open (22 by default).
`openssh-server` and `sshd` are reasonable options for this.
When you connect to a host, you need to have each other's public keys.
(Or, you need to verify their fingerprint.)

### Opening a Port
You need to open a port in the host's firewall, in order to accept connections.
the easiest way to do this is with the Uncomplicated FireWall package, `ufw`.
`ufw allow 22` will open port 22, the default for ssh.

### Generating Keys
`ssh-keygen` creates keys. 
Checkout `ssh-copy-id` for a convenient way to copy public keys around.
These pages are great:
https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server
https://www.cyberciti.biz/faq/create-ssh-config-file-on-linux-unix/

### Connecting to New Hosts
When you connect to a new host, you'll be confronted with a message like this:

```
$ scp -r joedang@192.168.254.13:.gpg .gpg
The authenticity of host '192.168.254.13 (192.168.254.13)' can't be established.
ECDSA key fingerprint is SHA256:9gohu/O6O4eIBA4cRZ8WBganGxptHsAjE7l/ZeemrWs.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
```

In order to verify that you're not connecting to an imposter, you'll need to verify the host machine's key.
This can be done with `ssh-keygen -lf /etc/ssh/ssh_host_ecdsa_key.pub`.
If you're using older/newer machines, you may need to use a different hashing algorithm. 
(I think my Ubuntu 14 machine used md5.)
This can be controlled with the `-E` option.

When connecting to a new IP, you may get a warning about it being added to the known_hosts file.
To check the fingerprint of the host, you can do `ssh-keygen -lf ~/.ssh/known_hosts`.

GitHub publishes the fingerprints and IP addresses of their SSH servers at `https://api.github.com/meta`.

## Installing things from source
My general strategy is to download an unzip the source into `/tmp/`. **Remember to do a checksum on the downloaded archive!** 

```bash
$ pwd
/tmp
$ cat checksum.txt
6503368c6b069bcbb00461e00a40db9d  MYLIB_1.2.3.tar.gz
$ md5sum -c checksum.txt
MYLIB_1.2.3.tar.gz: OK
$ tar -zxvf MYLIB_1.2.3.tar.gz
```

Of course, you should read anything named `README` or `INSTALL` for more detailed instructions. 
Generally, it should work fine to go into `MYLIB_1.2.3` just run:

```bash
$ ./configure
$ make 
$ sudo make install
```

For tidyness purposes, you may want to create `/tmp/MYLIB_build` and run those commands from there. (You would need to do `make ../MYLIB_1.2.3` et cetera.)

If you're installing into your home directory, you don't need to use `sudo`. I stronly prefer installing free/open software to `/usr/local/` and commercial software to `/opt/`.

Sometimes the software won't put its executables into `/usr/local/bin/`, and so they won't be in your path. To add them, add a line of this form to your `~/.bashrc`:

```bash
PATH=/usr/local/MYLIB/bin:$PATH
export PATH
```

I prefer to put all my path fiddling together, near the end of `.bashrc`, and have just one `export` statement.

**Note**: if the software puts its man and info pages in a sane location, like `/usr/local/MYLIB/man`, then the `man` command will automatically pick them up. 
Otherwise, you'll need to do some similar path concatenations with `MANPATH` and `INFOPATH`. e.g.:

```bash
MANPATH=/usr/local/MYLIB/foobar/man:$MANPATH
export MANPATH
INFOPATH=/usr/local/MYLIB/foobar/man:$INFOPATH
export INFOPATH
```
## Makefiles
Makefiles contain recipes which describe how to build outputs from sources.
If a directory has a file named `Makefile`, you can run `make TARGET` to make a certain output.

Makefiles have their own weird syntax. Most of the useful documentation is in the info pages.
Use `info make` or the `vinfo make` alias.
Sources may alternatively be called prerequisites or inputs.
Outputs may alternatively be called targets.
The basic syntax looks like this:
```make
output.o: source.cpp
	g++ source.cpp -o output.o
```

### Variables
Variables are assigned similar to shell variables: `MYVAR=value`.
You can also do shell expansion there: `MARKDOWNS=$(shell *.md)`.
To access variables, you need to keep the "$()": `echo MYVAR is: $(MYVAR)`.

#### Automatic Variables
There are some variable names which take convenient values for the current recipe.
```make
$@ # target file name
$% # target member name, when the target is an archive memeber
$< # first prerequisite
$^ # list of all prerequisites 
$^ # list of all prerequisites with duplicates
$? # all prerequisites newer than the target
$| # order-only prerequisites
$* # stem that an implicit rule matches
```

Similarly, variables for just the file name or the directory name can be constructed by appending `F` or `D`.
For example, if `$@` is `dir/foo.o`, then `$(@D)` is `dir` and `$(@F)` is `foo.o`.

### Recipes 

## Rip content from a webpage for local viewing
This is hecka useful if you know you're going to be away from da innanetz and want to study. 

`httrack` is the tool to use. 

```bash
$ httrack http://www.seas.upenn.edu/~cis194/spring15/
```

If you want, you can make Python pretend to be a server.

```
$ python3 -m http.server
```

If you don't have Python 3, it would be `python -m SimpleHTTPServer`.

## Strip file extensions
```bash
filename=$(basename "$pathname") # remove the leading directories
extension="${pathname##*.}" # remove everything but the [last] extension
noextension="${pathname%.*}" # remove the [last] extension
```

For clarity, here's an example using Zsh. 
I think it should be the same with any POSIX shell.
```zsh
~
$ pathname=/tmp/bungus.tar.gz
~
$ basename $pathname
bungus.tar.gz
~
$ echo ${pathname##*.}
gz
~
$ echo ${pathname%.*}
/tmp/bungus.tar
```

## Sorting Numbered Files
I had a bunch of book chapters as `PDF`s that I wanted to merge together, but they were named "Chapter-10-..." and the like. So, I couldn't simply rely on the default sorting of `ls`. 
So, I used 

```bash
pdfunite `ls Front*; ls Copy*; ls Pre*; ls Chap* | sort -t - -k 2 -n; ls Ind*` arfken.pdf
```

`-t -` specifies that fields are delimited by dashes. `-k 2` specifies that the second field should be used for sorting. `-n` specifies that sorting should be done by numeric value (as opposed to sorting alphabetically like ...17,18,19,1,20,21... or something). 

## LaTeX

### TeX Live
#### Find the Package that corresponds to a dependency
`tlmgr search --global --file myDependency.sty`  
`tlmgr search --global myPackage`

#### Find Where a File is Located
`kpsewhich` is very similar to the `which` built-in for Bash.
It shows you the locations for a given LaTeX file. 
For example, `kpsewhich article.cls` tells you where the article class is located. 

## Pandoc

### Make clean LaTeX files using Pandoc

Normally, pandoc adds a bunch of coloring information and header crap to files that have code blocks (verbatim environment) that makes the end LaTeX non-human-readable. You can *fix* this by simply adding the `--listings` flag, which tells pandoc that you want to use the `listings` package, rather than put custom coloring on every keyword (seriously). 

*It's really worth noting, however,* that pandoc gives you *only the body of the text.* There's no preable, `\begin{docuemnt}`, or `\end{document}`. 
You can get a standalone document by using the `--standalone` flag. 


```bash
pandoc mydoc.md --listings -o mydoc_body.tex
```

### Specify LaTeX options from within Markdown

Put them in the YAML header like this:  
```
---
title: 3D Printing Checklist
date: \today
fontsize: 12pt
documentclass: article
classoption: twocolumn
geometry: margin=0.75in
numbersections: true
#toc: true
pagestyle: plain
output:
  pdf_document:
      latex_engine: xelatex

---
```

## Monitoring files
It's often useful to be able to monitor the contents of a file. For example, to watch for when lines are added to a log file. 
There are a few ways to accomplish this: `watch`, `tail -F`, and pressing `F` in `less`. 

`watch` can be used to monitor many things, not just files. 
For example, `watch tail myfile.log` will rerun `tail myfile.log` every 2 seconds, while `watch -n 1 echo` will act as a crude clock, and `watch ls /tmp` will monitor the contents of `/tmp`. 

`tail -F` simply displays new lines as they are added.

Pressing `F` in `less` is the same idea as `tail -F`. This is probably the most powerful way to monitor a log file, since you get all the tools normally included in `less`. The only downside is that you can't use them while monitoring. You have to press `F` to start monitoring, and `ctrl+c` to stop monitoring and return to normal viewing. 

## Encryption

### PGP via GPG


### full disk encryption with LUKS
encrypt a device (or partition):  
```
cryptsetup -y -v -h sha256 luksFormat /dev/sdb
```

Get header information about an encrypted device:  
```
cryptsetup luksDump /dev/sdb
```

Decrypt a LUKS device and map it as a bulk storage device:  
```
cryptsetup luksOpen /dev/sdb cry
```

Get the status of a mapped LUKS device:  
```
cryptsetup -v status cry
```

Write zeroes to the device (optional, hides locations of future data):  
```
dd if=/dev/zero of=/dev/mapper/cry
```

Set up a file system on the mapped LUKS device:  
```
mkfs.ext4 /dev/mapper/cry
```

Mount the mapped LUKS device:  
```
mkdir ~/cry
mount /dev/mapper/cry ~/cry
```

Change permissions so it can be used without root/sudo (after decrypting and mounting):  
```
chown -R joedang ~/cry
```

Unmount:  
```
umount ~/cry
```

Stop on-the-fly decryption of a LUKS device:  
```
cryptsetup luksClose cry
```

### Directory encryption with ecryptfs
This all assumes the encrypted version is called `.secure`, the unencrypted version is `secure` and they are both in the working directory.

#### minimal usage
```
mkdir .secure secure
sudo mount -t ecryptfs .secure secure
```
This will ask you for a passphrase and encryption setup stuff.
It doesn't create any record of that setup, so you'll have to re-enter that every time. 
The defaults are sane, but filename encryption is a good idea to turn on.

### Directory encryption with encfs
mount: `encfs .secure secure`
umount: `fusermount -u secure`

## Common Problems
### Random Red Screen
I'm pretty sure this is caused by `slock`.
Killing slock from a virtual terminal should solve it. (`pkill slock`)

## Logout another user

`pkill -u joedang` will kill all processes belonging to the user `joedang`, effectively logging them out.
If you're logged into another session as `joedang`, you'll be logged out too.

You can check what's going to get killed by `pkill` by running `pgrep -u joedang -l`. 
The `-l` option prints the name of the process in addition to the process ID.
The default is to print the process ID alone.

## Forensics
`strings myfile.asdf` will show you the printable characters in a file. 
This is useful for getting information from proprietary binary files.

`binwalk myfile.asdf` searches files for *embedded* files and executables. 
It's kind of like a more powerful/general version of `strings`.

## Disk Management
`fdisk -l` is useful for seeing information about attached disks.

### Terminology
The terminology around partitions is kind of confusing at first.
The items with *emphasis* are specific pieces of jargon with distinct meanings.

*Partition tables*, are global to a physical drive.
They describe where the various partitions are.
There are different *partition table types*. 
The major types are MBR (aka msdos or dos) and GPT (aka GUID)
These are also referred to as *disklabel types*.

*Partitions* are sections of storage space.
The *partition type* is a hint in the partittion table to the OS on how to 
handle the stuff at a particular address referred to in the partition table.
Confusingly, many partition types are named after partition table types or file
system types!
These don't necessarily matter, if the OS is able to figure things out from the
file system.

*File systems* are a way of keeping track of... files.
They can incorporate things like file permissions, journaling, data recovery, 
and encryption.

### Creating Partitions
`cfdisk` is a convenient tool for managing partitions.
`gparted` is the GUI equivalent of `cfdisk`.
`gnome-disks` is also useful, but far less capable.

### MBR Versus GPT
A Master Boot Record (MBR) is the old style of pointing to bootable partitions. 
It's meant to be used with BIOS firmwares.
It's usually more compatible, but limits you to 4 partitions.
If you want more, you need to use logical partitions.
Some softwares call this a "dos" partition.

A GUID Partition Table is the new style.
It's meant to be used with UEFI firmwares.
It's usually not compatible with old hardware, but you can have lots of partitions.

### Formatting Partitions
The `mkfs.*` commands can be used to format a partition to a particular file system.
`gnome-disks` can also be used.

#### Swap Partitions
You can create a "Linux swap" partition and format it with `mkswap`.
Then, if you use `swapon`, you can start using that partition as a swap.
This lets Linux use it like RAM, if you happen to run out of actual RAM.
Obviously, this is much slower, and seriously effects performance when it is used,
but at least it prevents crashes!

### Auto-mounting With fstab
The File System TABle (fstab) is located at `/etc/fstab`.
Entries in fstab will automatically be mounted to the file system.
It usually contains comments hinting at its syntax.
`man fstab` can provide a detailed explanation.

Here's an example of fstab contents:
```
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/sda2 during installation
UUID=c87dcf2c-bef5-4e7d-a4a0-cbd30cbaea5f /               ext4    discard,relatime,errors=remount-ro 0       1
```

The `<file system>` field *can be* a device name, like `/dev/sda1`, however this is generally inferior to using a UUID.
Device names are generated dynamically, whereas a UUID never changes. (unless the device is reformatted?)
You can determine the UUID of a partition with `ls -l /dev/disk/by-partuuid`.
If available, `genfstab -U` will automatically generate a vaid fstab of everything currently mounted.
`fdisk -l` will also tell you the UUID of your disks.

### GRUB
`grub-install /dev/sdc` (or whatever drive, sda, sdb, et cetera...)
`grub-mkconfig -o /boot/grub/grub.cfg`

### Live USBs
The usual way to create a live USB is to start with a live image 
and use some tool to install it on a USB drive.
Most of the popular distros will provide a live image. 
In fact, the preferred way to install many distros is to start with a live USB,
using the live version of the distro to bootstrap the installer.

#### Using a Dedicated Tool
There are a lot of tools available for creating live USBs.
The one I prefer is `unetbootin`.
Starting with a function USB stick, open unetbootin (requires sudo), point it
towards the image you want to use, point it towards the drive, and let it do its
thing.

## Misbehaving Programs
You can use `pgrep` and `pkill` to find and kill processes by their command name.
Typically, I'll just do `pgrep -l mycommand` to confirm that only the intended processes will be selected.
Then, I'll do `pkill mycommand`. Note that this only sends the `TERM` signal, which politely asks the process to stop.
If the process is really pathological, you can use `pkill -KILL mycommand` 
or `kill -KILL PID` (PID is the process ID of the thing you want to kill.)
This tells the Linux kernel to stop the process in a non-graceful way.

`ps axo pid,ppid,comm | grep mycommand` is also useful for finding the *parent process* of a misbehaving program,
so you can determine what started it.

### Orphaned Processes
Often, misbehaving processes are doing so because their parent process terminated, but they are still running.
AFAIK, these always get their parent reassigned to PID 1, which is the init system. 
This can make it difficult to figure out what went wrong.

### Killing an XFCE Session
The brute-force solution is `pkill xfce`. This will nuke XFCE and its child processes.
The more elegant solution would be the following, which actually tells XFCE to logout the user on that display.
Of course, this only works if XFCE is responding.

```
export DISPLAY=':0.0'
xfce4-session-logout --logout
```


## Desktop Environments
You can try out a desktop environment by doing `startx myEnvironment` from a virtual terminal.
For example, Ctrl+Alt+F1 to switch to VT 1 and then `startx i3` to start i3.

## Fun

### ASCII Art
`screenfetch` gives ASCII art of your distro's logo along with statistics.

`aview` and `asciiview` (both provided by the `aview` package) are nice interactive tools for creating ASCII art from images.

`figlet` and `toilet` are tools for converting plain text into ASCII banners of different fonts and colors.

`cowsay` makes speech bubbles with text said by a cow.

`cmatrix` is basically a screensaver like the stuff from The Matrix.

### Color Codes
I have a tl;dr of color codes in `dotfiles/bin/colorCodes`.
`man console_codes` provides a reference for how all the codes work.

### Text-to-Speech
`espeak`

### Text Generation
`misfortune` chooses random fortunes.

`rig` generates random identities with valid state/city/zip fields.

`backronym` (my own Python script) generates random backronyms, given an acronym.

### Text Adventures
`advent` is, of course, a classic.

`frotz` plays a common format of text adventures. 
You can get them [here](http://if.illuminion.de/infocom.html) and [here](http://ifwiki.org/index.php/Main_Page).

## Arch Linux
### Kernel Modules
`modprobe` and friends will help you manage kernel modules. 
Notably, `modprobe -c` will list what's installed and `modprobe MODULE_NAME` will install a module.

Sometimes, after getting a kernel update, you'll get errors related to kernel modules not being available.
For example, you update your kernel and then install a package that implicitly installs a module.
To address this, you should try rebooting, so you're using the newer kernel.
