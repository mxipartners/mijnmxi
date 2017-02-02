// This file contains different helper functions.
//
// To create globally accessible elements, the elements (functions, objects, etc)
// are attached to the global 'window' object.
//

// Page Mode functions ---------------------------------------------------

// Page Mode instance
window.PageMode = {
  create: "create",
  edit: "edit",
  view: "view"
};

// Create helpers for all the different modes
Object.keys(PageMode).forEach(function(mode) {

  // Generate the name "in<mode>Mode" like "inEditMode"
  var modeString = PageMode[mode];
  var helperName = "in" + modeString.replace(/^[a-z]/, function(firstChar) { return firstChar.toUpperCase(); }) + "Mode";

  // Add helper which can be used in templates to test for a specific page mode (like in {{#if inEditMode}})
  Template.registerHelper(helperName, function() {
    return this.mode === modeString;
  });
});

// Create helper for readonly input fields
Template.registerHelper("input_readonly", function() {
  return this.mode === PageMode.view ? "readonly" : "";
});

// Gravatar functions ----------------------------------------------------

// Retrieve gravatar for specified email address.
// If succesful the 'callback' function is called with an image data URL.
// This URL takes the form: "data:image/jpeg;base64,...."
// The URL can be used to create an 'inline' image like:
//    <img src="data:image/jpeg;base64...." ...>
window.Gravatar = {

  retrieve: function(emailAddress, callback) {

    // Calculate hash for gravatar and check if it is in cache
    var hash = CryptoJS.MD5(emailAddress.trim().toLowerCase());

    // Test if hash is already in the cache
    if(window.gravatarCache) {

      // Try to retrieve gravatar image, if none is present continue
      var imageDataURL = window.gravatarCache[hash];
      if(imageDataURL !== undefined) {

        // An empty image means, there was no gravatar found (previously)
        if(imageDataURL.length > 0) {
          callback(imageDataURL);
        }
        return;
      }
    } else {

      // The cache does not exist yet, create it
      window.gravatarCache = {}
    }

    // Retrieve gravatar from gravatar website.
    // Returns an image of size 160x160 pixels (as specified in URL below).
    // Returns 404 if no gravatar is present (as specified in URL below).
    // A number of browsers will show the 404 in the console since it is
    // an error to receive a 404 on retrieving a resource.
    var url = "https://www.gravatar.com/avatar/" + hash + "?d=404&s=160";
    d3.request(url)
      .mimeType("image/jpeg")
      .responseType("arraybuffer")
      .get(function(error, data) {

        // Store gravatar (or "" in absence) in cache for later usage
        if(!error && data && data.response) {
          var arrayBuffer = new Uint8Array(data.response);
          var binary = "";
          for(var i = 0; i < arrayBuffer.length; i++) {
            binary += String.fromCharCode(arrayBuffer[i]);
          }
          var imageDataURL = "data:image/jpeg;base64," + window.btoa(binary);
          window.gravatarCache[hash] = imageDataURL;

          // Gravatar found
          callback(imageDataURL);

        } else if(error && error.target && error.target.status === 404) {

          // Result is 404, no gravatar exists. Store empty string in cache.
          window.gravatarCache[hash] = "";
        }
      })
    ;
  }
};


// Utility functions -----------------------------------------------------

// Hack to access parentTemplate. Code taken from:
//   http://stackoverflow.com/questions/27949407/how-to-get-the-parent-template-instance-of-the-current-template
Blaze.TemplateInstance.prototype.parentTemplate = function(levels) {
  var view = this.view;
  if(typeof levels === "undefined") {
    levels = 1;
  }
  while(view) {
    if(view.name.substring(0, 9) === "Template." && !(levels--)) {
      return view.templateInstance();
    }
    view = view.parentView;
  }
};

// Add simple localStorage implementation if one is not present
if(!window.localStorage) {
  window.localStorage = {
    keysAndValues: {},
    clear: function() { this.keysAndValues = {}; },
    getItem: function(key) { return this.keysAndValues[key]; },
    setItem: function(key, value) { this.keysAndValues[key] = value; },
    removeItem: function(key) { delete this.keysAndValues[key]; },
    key: function(index) { throw "localStorage.key not implemented"; }
  }
}
