#!/usr/bin/python
import urllib2
from urlparse import urlparse
import subprocess
from time import sleep
from os.path import exists
from os import chdir
from git import Repo, NoSuchPathError
import shutil

def internet_on():
    try:
        response = urllib2.urlopen('http://www.apple.com/library/test/success.html',timeout=1)
        return True
    except urllib2.URLError:
        return False

while True:
    repo_url = None
    try:
        repo = Repo("/chef_data")
        origin = repo.remotes.origin
        repo_url = origin.url
    except NoSuchPathError:
        pass

    chef_url = open("/boot/chef-url").read().strip()
    result = urlparse(chef_url)
    if result.scheme == "":
        print "Bad Chef url in /boot/chef-url: %s" % chef_url
        sleep(5)
        continue

    if repo_url == chef_url:
        break
    if exists("/chef_data"): # Existing data, but wrong URL
        shutil.rmtree("/chef_data")

    print "Trying Chef URL %s" % chef_url

    if internet_on():
        try:
            subprocess.check_call(["git", "clone", chef_url, "/chef_data"])
            break
        except subprocess.CalledProcessError:
            print "error while calling chef, pausing"
            sleep(5)
    else:
        print "Can't get to the internet, pausing"
        sleep(5)

chdir("/chef_data")
while True:
    chef_cookbook = open("/boot/chef-cookbook").read().strip()
    if chef_cookbook == "":
        print "No Chef cookbook specified in /boot/chef-cookbook"
        sleep(5)
        continue
    try:
        subprocess.check_call(["git", "pull"], stdout = subprocess.PIPE)
        subprocess.check_call(["chef-client", "-z", "-c", "client.rb", "-o", chef_cookbook])
        sleep(60 * 60) # Waiting an hour, because all ok
    except subprocess.CalledProcessError:
        print "error while calling chef, pausing"
        sleep(10)
