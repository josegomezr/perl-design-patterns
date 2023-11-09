# Finds all diagram files *.plantumls and fetches their PNG render.

# Prerequisites:
# zypper in zopfli

DIR=$(git rev-parse --show-toplevel)

for diagram_source in $(find $DIR -type f -iname '*.plantuml'); do
  echo "Processing $diagram_source";
  tmp=$(mktemp)

  # Compress with zopfli
  zopfli $diagram_source --deflate -c > $tmp

  # Encode with the tool
  compressed_contents=$(node tools/encode-plant-uml.js $tmp)

  # Build file paths
  png_path="${diagram_source%%.plantuml}.png"
  
  # Fetch from plantuml site
  wget -q "http://www.plantuml.com/plantuml/png/$compressed_contents" -O "$png_path"

  # Done!
  echo " -> Generated $png_path";

  # Cleanup always...
  rm $tmp
done
