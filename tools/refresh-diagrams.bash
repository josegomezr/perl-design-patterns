DIR=$(git rev-parse --show-toplevel)

for diagram_source in $(find $DIR -type f -iname '*.plantuml'); do
	echo "Processing $diagram_source";
	tmp=$(mktemp)

	zopfli $diagram_source --deflate -c > $tmp

	compressed_contents=$(node tools/encode-plant-uml.js $tmp)

	png_path="${diagram_source%%.plantuml}.png"
	wget -q "http://www.plantuml.com/plantuml/png/$compressed_contents" -O "$png_path"
	echo " -> Generated $png_path";
	rm $tmp
done
