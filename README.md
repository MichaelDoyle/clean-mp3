Clean-mp3
=========

MP3s obtained from different sources often come with unnecessary junk in the ID3 tags. Naming conventions are inconsistent. Embedded album art is often far too large. Not only does this waste disk space (the album art is duplicated in every file), but DLNA players such as the PS3 have upper limits on the album art size supported. This shell script alleviates these problems by automating the clean up of unwanted ID3 tags, cleaning up and re-embedding of artwork, and renaming of mp3 files. Extra files such as nfo, cue, log, etc are also removed.

Features
=========

* Remove unrelated files (m3u, log, cue, sfv, nfo, pls, html, html)
* Remove unwanted MP3 ID3 tags including lyrics, comments, url frames, user text frames and file ids
* Strip album art and replace with 150x150 thumbnail based on folder artwork (e.g. folder.jpg)
* Rename MP33 files as "Track Number - Track Title"

Usage
=========

    ./clean_mp3 <location>

Dependencies
=========

* eyeD3
* ImageMagick
