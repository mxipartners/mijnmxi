// Add intialization at render time.
// Replace help text about using gravatar with gravatar image (if already present).
Template.profilePage.onRendered(function() {
  Gravatar.retrieve(Template.parentData().user.emails[0].address, function(imageDataURL) {
      d3.select('#gravatar_help').html('<img class="img-circle" src="' + imageDataURL + '"/>' +
        '<p>Uw avatar zoals geregistreerd bij <a href="https://gravatar.com">gravatar.com</a>.</p>');
  });
});

// Add event handlers
Template.profilePage.events({

  // Edit the profile
  "submit form": function(evt) {

    // Prevent default submit behaviour
    evt.preventDefault()

    // Update the profile
    if(this.mode === PageMode.edit) {

      // Assemble profile properties
      var profileProperties = {
        name: d3.select("[name=name]").property("value"),
        telephone_nr: d3.select("[name=telephone_nr]").property("value"),
        skype_id: d3.select("[name=skype_id]").property("value")
      };

      // Update user
      var userId = this.user._id
      Meteor.users.update(userId, {$set: profileProperties}, function(error) {
        if(error) {
          // FIXME: handle errror!
          throwError(error.reason);
        } else {
          Router.go("memberPage", {_id: userId});
        }
      });
    }
  },

  // Cancel the edit of the profile
  "click .cancel-button": function() {

    // Go back to previous page
    history.back();
  },

  // Close the view of the profile
  "click .close-button": function() {

    // Go back to previous page
    history.back();
  }
});
