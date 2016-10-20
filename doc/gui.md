# GUI Guidelines

Some GUI guidelines for mijn.mxi.nl application.

General guidelines:
* Use CSS for styling (instead of styling within HTML)
* Add CLASS attributes to elements to provide styling
* Use simpel descriptive CLASS names and reference them as a path (eg '.messages .message .header { ... }')
* Use DIVs as a block level element to add styling
* Use SPAN (or DIV with style 'display: inline-block') as inline element to add styling
* Do not use TABLEs, unless a (Excel-like) tabular display is required (probably not required for mijn.mxi.nl)

Make application responsive:
* Use relative sizes as much as possible (use percentages, 'em', 'vw' or 'vh' as size unit)
* Position elements using carefully constructed container/parts (DIVs in DIVs)
* Use MARGIN and PADDING to add additional whitespace (size might be expressed in 'px', 'em', 'vw' or 'vh')
* Using 'position: absolute' will remove an element from normal flow, use it wisely

Adding logic to the GUI:
* Use jQuery to select DOM elements using $ and selectors like below:
```CoffeeScript
    $('.messages')            # All elements with class 'messages'
    $('.messages .message')   # All elements with class 'message' which have a parent with class 'messages'
    $('[name=something]')     # All elements with attribute 'name' equal to 'something'
```
* In coffeescript file add event handler like below:
```CoffeeScript
        Template.myTemplate.events
          'click .control.send': (e) ->
            e.preventDefault()
            content = $('input[name=content]').val()
            Meteor.call 'sendMessage', content, (error, result) ->
              if error
                throwError error.reason
```
