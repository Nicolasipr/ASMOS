ASMOS
=====

*Assembly Operating System from scratch* 


*Concepts you may want to know beforehand: terminal, compiler, emulator, nasm, qemu*

## Table of Contents
--------------------

- [Getting Started](#Getting-started)
    - [Prerequisites](#Prerequisites)
- [How To Use it](#How-To-Use-it)
- [Strategy](#strategy)

- [Maintainers](#maintainers)
- [Contribute](#contribute)
- [License](#license)


## Getting Started
------------------

This project was created with its sole purpose of studying assembly by NASM for a College project at Metropolitan University of Technology, as a research about how Assembly NASM works on this subject 'Computer Organization'

Our code is merely taken by two githubs repositories [MikeOS](https://github.com/mig-hub/mikeOS) and [cfenollosa/os-tutorial](https://github.com/cfenollosa/os-tutorial), modified them and had learn how they work, some minor changes applies had been done, and I'm not taking credits of any of this work, if you want to know more about this implementation and how its done, I suggest to go to [MikeOS Offical Site](http://mikeos.sourceforge.net/) as well as [NASM Oficcial documentation](https://nasm.us/doc/nasmdoci.html). 




### Prerequisites

This project works on [nasm](https://www.nasm.us/) and uses [qemu](https://www.qemu.org/) as a machine emulator so if you haven't already installed it, make sure to have it installed in order to compile our code.

On a mac, [install Homebrew](http://brew.sh) and then `brew install qemu nasm`
On Linux, install from you prefered package manager, such as `sudo apt-get install build-essential qemu nasm`


## How To Use this
------------------

To compile assembly with nasm, you have to write this simple command on your terminal in your file folder:

```
nasm filename.asm -o filename.bin

```
if it's good it will not show any errors

To use QEMU as machine emulator, you have write this command on your terminal:

```
qemu-system-x86_64 filename.bin

```
or use this instead


```
qemu-system-x86_64 -M accel=kvm:tcg -soundhw ac97 -m 1024 -drive file="filename.bin",format=raw

```

Later on You can use our sh file to do some recursive compiling and add some disk images to better  handling this situation. 


## Strategy
-----------

Our goals to code in our code are this:

- Boot from sratch, without GRUB
- Enter 32-bit mode
- Build Kernel
- Screen input and output
- Write filesystem to store and delete files
- User mode
- Create a shelk
- add some video-games
- GUI 

##Contribute
------------




