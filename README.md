# LDS General Conference

```bash
# Load the "library"
source genconflib.sh

# Scrape session indexes for links to each talk's HTML page (1-2 minutes)
get_talk_links 1971 2015 > talk-links.txt

# Download talks (approximately 1 hour, 1/2 Gb)
get_talks talk-links.txt talks/

# Parse HTML files to build a catalog of basic info for all talks (2-3 minutes)
echo -e "Year\tMonth\tSpeaker\tTitle\tMP3" > talks.tsv
for file in talks/*.html; do parse_talk $file >> talks.tsv; done

# Grab audio files of all talks from a particular speaker
grep 'Neal A. Maxwell' talks.tsv | cut -f 5 | xargs -n 1 curl -O
```

One talk (that I know of) had an issue downloading on the initial pass.
Re-downloaded with the following and repeated the last step.

```bash
echo "1990/04/family-traditions?lang=eng" > temp
get_talks temp talks/
```
