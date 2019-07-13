#!/usr/local/bin/python3.6
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = 'Torfinn Ingolfsen'
SITENAME = 'Just a blog'
SITEURL = 'https://tingox.github.io'

PATH = 'content'

TIMEZONE = 'Europe/Oslo'

DEFAULT_LANG = 'English'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
LINKS = (('Pelican', 'http://getpelican.com/'),
         ('Python.org', 'http://python.org/'),
         ('Jinja2', 'http://jinja.pocoo.org/'),
         ('Torfinn @heim', 'http://heim.bitraf.no/tingo/'),)

# Social widget
SOCIAL = (('LinkedIn profile', 'https://www.linkedin.com/in/torfinn-ingolfsen-9816a93/'),
          ('Another social link', '#'),)

DEFAULT_PAGINATION = 20

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True