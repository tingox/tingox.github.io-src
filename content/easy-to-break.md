Title: Easy to break
Slug: easy-to-break
Date: 2017-08-31 17:36:18
Modified: 2017-09-01 15:06:22
Category: Blog

Pelican works, but it seems a bit fragile. 'make html' works all the time, but 'make publish' followed by the necessary 
git commands doesn't always give the expected result. Sometimes only the text is published, and lacks the "theme", 
which creates a bad look.

2017-09-01: and it broke again today. Not sure why, I must figure that out.

2017-09-01: ok, it turns out that `SITEURL` in `publishconf.py` had http, not https in the URL.
	    Changing that made all the difference.