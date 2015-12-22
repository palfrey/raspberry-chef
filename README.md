Chef bootstrap for Raspberry Pi
-------------------------------

This project creates an auto-updating [chef-zero](https://www.chef.io/blog/2013/10/31/chef-client-z-from-zero-to-chef-in-8-5-seconds/) based Raspberry Pi node.

1. Write a Debian-based image to the SD card for your Pi (I advise the [Jessie Lite](https://www.raspberrypi.org/downloads/raspbian/) image as a good small base)
2. SSH into the node (possibly just `ssh pi@raspberrypi` with password "raspberry" if you're using the defaults)
3. `wget https://raw.githubusercontent.com/palfrey/raspberry-chef/master/bootstrap.sh`
4. `cat bootstrap.sh`
  * Read the contents of bootstrap.sh and make sure you understand it before just randomly running something I told you to.
5. `sudo sh bootstrap.sh`
6. `sudo poweroff`

You've now got an auto-updating SD card, which you can backup and re-use for other nodes. To configure it, there's a series of files in `/boot` which is a FAT32 partition, which means it'll get mounted on Linux, OS X or Windows which means you can configure it without having a working Pi.

The following files in `/boot` are of particular use:
* `wifi.conf` - a wpa_supplicant configuration file. For simple configs, the changes should be obvious, but for more complicated settings see the [example config](http://w1.fi/cgit/hostap/plain/wpa_supplicant/wpa_supplicant.conf)
* `chef-url` - a git URL to clone that contains Chef cookbooks
* `chef-cookbook` - Chef cookbook from the chef-url path to run with chef-client

The `update_chef` daemon will automatically check chef-url/chef-cookbook and run chef-client in [chef-zero](https://www.chef.io/blog/2013/10/31/chef-client-z-from-zero-to-chef-in-8-5-seconds/) configuration if it finds a valid set of configuration.
