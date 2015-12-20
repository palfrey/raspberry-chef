import urllib2

def internet_on():
    try:
        response=urllib2.urlopen('http://www.apple.com/library/test/success.html',timeout=1)
        return True
    except urllib2.URLError as err:
        return False

print internet_on()
