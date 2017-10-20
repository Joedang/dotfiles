# A little gallery of neat one-liners and helpful reminders
This is like Stack Exchange, but past-Joe answers the questions of present-Joe.

## Get information about CLI tools
* man -- brief manual pages
* info -- long-winded and explanations, but often just the man page
* apropos -- man pages with matchning keywords

## R
### Figure out what you're looking at
`str()` gets the structure of something (e.g., if you have a list of lists.)  
`typeof()` tells you the storage type of something.  
`class()` tells you... the class of something.  

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

        $ sudo usermod -a -G dialout joedang

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
$ cat shellsList.txt
file 44.mp4
file 45.mp4
file 46.mp4
$ ffmpeg -f concat -i shellsList.txt -c copy shells.mp4
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
filename=$(basename "$fullfile")
extension="${filename##*.}"
filename="${filename%.*}"
```

## Sorting Numbered Files
I had a bunch of book chapters as `PDF`s that I wanted to merge together, but they were named "Chapter-10-..." and the like. So, I couldn't simply rely on the default sorting of `ls`. 
So, I used 

```bash
pdfunite `ls Front*; ls Copy*; ls Pre*; ls Chap* | sort -t - -k 2 -n; ls Ind*` arfken.pdf
```

`-t -` specifies that fields are delimited by dashes. `-k 2` specifies that the second field should be used for sorting. `-n` specifies that sorting should be done by numeric value (as opposed to sorting alphabetically like ...17,18,19,1,20,21... or something). 

## Make clean LaTeX files using Pandoc

Normally, pandoc adds a bunch of coloring information and header crap to files that have code blocks (verbatim environment) that makes the end LaTeX non-human-readable. You can *fix* this by simply adding the `--listings` flag, which tells pandoc that you want to use the `listings` package, rather than put custom coloring on every keyword (seriously). 

*It's really worth noting, however,* that pandoc gives you *only the body of the text.* There's no preable, `\begin{docuemnt}`, or `\end{document}`. 
You can get a standalone document by using the `--standalone` flag. 


```bash
pandoc mydoc.md --listings -o mydoc_body.tex
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
