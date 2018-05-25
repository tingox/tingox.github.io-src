Title: git - more to learn
Slug: git-more-to-learn
Date: 2018-05-25 01:59:38
Category: Blog

For some reason, the submodule ("output") had a detached head, and no matter how much I tried
```
git submodule init
git submodule update
```
the HEAD was still detached. In the end, I just changed into the output directory and did a `git checkout master` - the existing content was going to be flushed away by Pelican anyway. That worked nicely.
