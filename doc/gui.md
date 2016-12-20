# GUI Guidelines

Some GUI guidelines for mijn.mxi.nl application.

General guidelines:
* Use CSS for styling (instead of styling within HTML)
* Add `class` attributes to elements to provide styling
* Use simpel descriptive `class` names and reference them as a path (eg `.messages .message .header { ... }`)
* Use `div`s as a block level element to add styling
* Use `span` (or `div` with style `display: inline-block`) as inline element to add styling
* Do not use `table`s, unless a (Excel-like) tabular display is required (probably not required for mijn.mxi.nl)

Make application responsive:
* Use relative sizes as much as possible (use percentages, `em`, `vw` or `vh` as size unit)
* Position elements using carefully constructed container/parts (`div`s in `div`s)
* Use `margin` and `padding` to add additional whitespace (size might be expressed in `px`, `em`, `vw` or `vh`)
* Using `position: absolute` will remove an element from normal flow, use it wisely

Adding logic to the GUI:
* Use D3 to select DOM elements using `d3.select()` and `d3.selectAll()` like below:
```Javascript
d3.selectAll('.messages')            // All elements with class 'messages'
d3.selectAll('.messages .message')   // All elements with class 'message' which have a parent with class 'messages'
d3.select('[name=something]')        // First element with attribute 'name' equal to 'something'
d3.select(e.target).selectAll('div') // All div elements which are child of the current event's target (eg in click handler)
```
* In Javascript file add event handler like below (do not forget e.preventDefault() when clicking on A tags):
```Javascript
Template.myTemplate.events({
  'click .control.send': function(e) {
    e.preventDefault();
    var content = d3.select('input[name=content]').property('value');
    Meteor.call('sendMessage', content, function(error, result) {
      if(error) {
        throwError error.reason
      }
    });
  }
});
```
