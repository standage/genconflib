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
```
