Title: Pelican 4.0.1 is in
Slug: pelican-4-0-1-is-in
Date: 2019-07-13 16:21:12
Category: Blog

Long time since I posted here. Time has passed, and now Pelican 4.0.1 is out, I installed that on my new workstation (along with a few other missing tools). That's all.

Ok, it seems I managed to break it again. Will this change fix anything?

As it turns out, using `git submodule update` isn't wise. Atleast until you have fixed your submodule setup so
the submodule tracks the correct branch of that repository. Oh well, I learned something.

See [Why is my GIT Submodule HEAD detached from master?][1] on stackoverflow for some answers.


[1]: https://stackoverflow.com/questions/18770545/why-is-my-git-submodule-head-detached-from-master