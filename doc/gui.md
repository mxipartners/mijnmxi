# GUI Guidelines

Some GUI guidelines for mijn.mxi.nl application.

General guidelines:
* Use CSS for styling (instead of styling within HTML)
* Add CLASS attributes to elements to provide styling
* Use simpel descriptive CLASS names and reference them as a path (eg '.messages .message .header { ... }')
* Use DIVs as a block level element to add styling
* Use SPAN (or DIV with style 'display: inline-block') as inline element to add styling
* Do not use TABLEs, unless a (Excel-like) tabular display is required (probably not required for mijn.mxi.nl)

Make application responsive 
* Use relative sizes as much as possible (use percentages, 'em', 'vw' or 'vh' as size unit)
* Position elements using carefully constructed container/parts (DIVs in DIVs)
* Use MARGIN and PADDING to add additional whitespace (size might be expressed in 'px', 'em', 'vw' or 'vh')
* Using 'position: absolute' will remove an element from normal flow, use it wisely
