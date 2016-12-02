#!/bin/sh

# Test for parameter
if [ "$1" == "" ]; then
	echo "Use: $0 <filename>"
	exit 1
fi

# Test if file exists
if [ ! -f "$1" ]; then
	echo "File \"$1\" does not exist"
	exit 1
fi

# Test if file needs to be handled (ie if Generator comment still present)
# If not, exit
fgrep -q "Generator: Adobe Illustrator" "$1"
if [ $? -ne 0 ]; then
	exit 0
fi

# File needs to be converted

# Read viewBox values and test for pattern viewBox="0 0 <width> <height>"
VIEWBOX=`fgrep viewBox "$1" | sed 's/.*viewBox="\([0-9\. ]*\)".*/\1/'`
VIEWBOX_ARR=($VIEWBOX)
if [ "${VIEWBOX_ARR[0]}" != "0" ]; then
	echo "Unexpected non 0 value as first element in viewBox: $VIEWBOX"
	exit 1
fi
if [ "${VIEWBOX_ARR[1]}" != "0" ]; then
	echo "Unexpected non 0 value as second element in viewBox: $VIEWBOX"
	exit 1
fi
VIEWBOX_WIDTH=${VIEWBOX_ARR[2]}
VIEWBOX_HEIGHT=${VIEWBOX_ARR[3]}

# Calculate width/height ratio and calculate surrounding square size and translation the original to center within square
WIDE=`bc -l <<< "$VIEWBOX_WIDTH > $VIEWBOX_HEIGHT"`
if [ $WIDE -eq 1 ]; then
	VIEWBOX_MAX=$VIEWBOX_WIDTH
	VIEWBOX_TRANS_X=0
	VIEWBOX_TRANS_Y=`bc <<< "scale=3; ($VIEWBOX_WIDTH - $VIEWBOX_HEIGHT)/2"`
else
	VIEWBOX_MAX=$VIEWBOX_HEIGHT
	VIEWBOX_TRANS_X=`bc <<< "scale=3; ($VIEWBOX_HEIGHT - $VIEWBOX_WIDTH)/2"`
	VIEWBOX_TRANS_Y=0
fi

# Create property values which will be (re)placed inside the original SVG
VIEWBOX="0 0 $VIEWBOX_MAX $VIEWBOX_MAX"
TRANSLATE="($VIEWBOX_TRANS_X,$VIEWBOX_TRANS_Y)"

# Convert SVG (which will replace/remove certain elements and set markers for $VIEWBOX/$TRANSLATE)
cat "$1" | sed -f convert_svg.sed | sed "s/@@VIEWBOX@@/$VIEWBOX/" | sed "s/@@TRANSLATE@@/$TRANSLATE/"
