Title: Pelican on Windows
Slug: pelican-on-windows 
Date: 2018-02-12 16:15:01
Category: Blog

Installing Pelican on Windows is quite easy. You need [Python][1] of course, then it is just 'pip install pelican' followed 
by 'pip install MarkDown' and Pelican is installed. All this from [PowerShell][6].

Unfortunately, my setup uses a Makefile (originally I set up this under Linux). So I need make, the Makefile needs sed and tr
and perhaps date. [GnuWin][2] to the rescue, it has packages for [make][3], [sed][4] and [coreutils][5] (which contains tr).

There are some things I haven't got working, like date. The date command from GnuWin coreutils package is installed, when I run
it from a powershell (the same command as in my Makefile, it works. If I enable it in the Makefile, make hangs.
Another issue is that make generates content filenames with prefixed and postfixed with dashes ('-'), even if the Makefile code
to generate a slug works. If the slug is 'this-is-a-test", the filename will be '-this-is-a-test-.md' and I don't know why yet.

[1]: https://www.python.org/
[2]: http://gnuwin32.sourceforge.net/
[3]: http://gnuwin32.sourceforge.net/packages/make.htm
[4]: http://gnuwin32.sourceforge.net/packages/sed.htm
[5]: http://gnuwin32.sourceforge.net/packages/coreutils.htm
[6]: https://en.wikipedia.org/wiki/PowerShell