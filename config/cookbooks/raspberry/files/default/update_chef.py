#!/usr/bin/python
import urllib2
from urlparse import urlparse
import subprocess
from time import sleep
from os.path import exists
from os import chdir
from git import Repo, NoSuchPathError
import shutil
import logging

logger = logging.getLogger(__name__)

formatter = logging.Formatter('%(asctime)s - %(levelname)s: %(message)s')

ch = logging.StreamHandler()
ch.setLevel(logging.DEBUG)
ch.setFormatter(formatter)
logger.addHandler(ch)

ch = logging.FileHandler("/var/log/update-chef.log")
ch.setLevel(logging.INFO)
ch.setFormatter(formatter)
logger.addHandler(ch)

def internet_on():
    try:
        response = urllib2.urlopen('http://www.apple.com/library/test/success.html',timeout=1)
        return True
    except urllib2.URLError:
        return False

while True:
    chdir("/")
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
        logger.warning("Bad Chef url in /boot/chef-url: %s" % chef_url)
        sleep(5)
        continue

    if repo_url == chef_url:
        logger.debug("Repo has correct Chef URL %s" % chef_url)
    else:
        if exists("/chef_data"): # Existing data, but wrong URL
            logger.debug("Killing old /chef_data for %s" % repo_url)
            shutil.rmtree("/chef_data")

        logger.info("Trying Chef URL %s" % chef_url)

        if internet_on():
            try:
                subprocess.check_output(["git", "clone", chef_url, "/chef_data"])
            except subprocess.CalledProcessError, e:
                logger.exception("Error while calling chef, pausing")
                logger.error(e.output)
                sleep(5)
                continue
        else:
            logger.warning("Can't get to the internet, pausing")
            sleep(5)
            continue

    chdir("/chef_data")
    chef_cookbook = open("/boot/chef-cookbook").read().strip()
    if chef_cookbook == "":
        logger.warning("No Chef cookbook specified in /boot/chef-cookbook")
        sleep(5)
        continue
    try:
        subprocess.check_output(["git", "pull"])
        subprocess.check_output(["chef-client", "-z", "-c", "client.rb", "-o", chef_cookbook])
        sleep(60 * 60) # Waiting an hour, because all ok
    except subprocess.CalledProcessError, e:
        logger.exception("Error while calling chef, pausing")
        logger.error(e.output)
        sleep(60)
        continue
