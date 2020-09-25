Title: Static generators for picture galleries
Slug: static-generators-for-picture-galleries
Date: 2020-09-25 19:39:42
Tags: web, static generators, pictures, galleries
Category: blog

If I want to put picture galleries on the web, I should look at static generators for picture galleries, as I have no need of comments and all that stuff.
Some possible candidates are [curator](http://curator.sourceforge.net/local/), [fgallery](https://www.thregr.org/~wavexx/software/fgallery/), 
[lazygal](https://sml.zincube.net/~niol/repositories.git/lazygal/about/), [Sigal](http://sigal.saimon.org/en/latest/), [Sitelen Mute](https://github.com/kensanata/sitelen-mute).
The question then, is how to choose one? curator is written in Python (good), but is a bit old (Python 2?). fgallery is written in perl, and has a bigger list of dependencies than
the other candidates. lazygal looks quite all right, Python >= 3.7 (good) and can do lots of stuff. Sigal requires Python >= 3.5 (good), can do the same things that lazygal can, it 
supports relative output, and more. It doesn't have support for facedetect, if you need that. Sitelen Mute requires perl (like fgallery) and has a quite big list of dependencies, 
so even if it has facedetect, I think I'll opt out of using it.

Hmm, it seems like I have decided to try Sigal then.