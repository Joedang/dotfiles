# A little gallery of neat one-liners and helpful reminders

## Get information about CLI tools
* man -- brief manual pages
* info -- long-winded and explanations 
* apropos -- man pages with matchning keywords

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
01 - The Starting Line.flac  
02 - Floor Corn.flac         
03 - ACVC.flac               
04 - 300MB.flac              
05 - Revolution #5.flac      
06 - Dear Dinosaur.flac      
07 - Annoyed Grunt.flac   
08 - Bustin.flac          
09 - Blockbuster.flac     
10 - Busta.flac           
11 - Tiger.flac           
12 - The End.flac         
13 - Shady Interlude.flac 
14 - T.I.M.E..flac        
15 - Smooth.flac
16 - Stand By Meme.flac 
17 - Wallspin.flac
18 - Wow Wow.flac
19 - Mouth Pressure.flac
20 - Shit.flac
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
`avconv` and `flac2mp3` are pretty good. The default settings for `flac2mp3` are basically perfect. You'll probably have to compile flac2mp3 from source.  
`youtube-dl` is also good for acquiring stuff, but don't count on your package manager's repos being up to date _\*cough\*Ubuntu\*cough\*_. You pretty much have to compile both `youtube-dl` and `avconv` from source. (`libav` is the parent package/project for the `avconv` command.)

## Installing Fonts
GIMP checks for typefaces on its own, so running `$ sudo fc-cache -fv` may be unnecessary.

### For Everyone:
Copy the font to `/usr/share/fonts/truetype/` (or the appropriate directory if it's not TTF) and run `$ sudo fc-cache -fv`.

### For Only You:
Copy to `~/.fonts/` and run `$ sudo fc-cache -fv`.

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
