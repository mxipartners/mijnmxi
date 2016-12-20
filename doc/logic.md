# Logic Guidelines

Some logic (Javascript) guidelines for mijn.mxi.nl application.

General guidelines:
* Use braces for blocks (also single line if-statements)
* Use double quotes for strings (except if string contains only a single double quote like `'"'`)
* Use === and !== for comparison

Add event handlers to page:
```Javascript
Template.myTemplate.events({
  "click .my_class": function(e) {
    // Handle click event
  },
  "click .other_class": function(e) {
    // Handle other click event
  }
});
```

Add template event handlers:
```Javascript
Template.myTemplate.onCreated(function() {
  // Add logic to instantiate template instance
});
```
