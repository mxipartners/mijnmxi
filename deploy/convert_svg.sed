# Remove the generator comment
s/<!-- Generator: Adobe Illustrator.*-->//

# Replace x y coordinates on svg element
s/\(<svg .*\)x="0px" y="0px"\(.*\)/\1\2/

# Remove enable-background style */
s/enable-background:new [0-9\. ]*;//

# Remove empty styles
s/style="" //

# Mark viewBox element for replacement
s/viewBox="[0-9\. ]*"/viewBox="@@VIEWBOX@@"/

# Append extra group for positioning (centering image)
s/\(<\/style>\)/\1<g transform="translate@@TRANSLATE@@">/
s/\(<\/svg>\)/<\/g>\1/
