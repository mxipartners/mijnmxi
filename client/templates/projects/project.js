// Add event handlers
Template.project.events({

  // Create or edit the project
  "submit form": function(evt) {

    // Prevent default submit behaviour
    evt.preventDefault();

    // Assemble project properties
    var projectProperties = {
      title: d3.select("[name=title]").property("value"),
      description: d3.select("[name=description]").property("value")
    };

    // Insert or update the project
    if(this.mode === PageMode.create) {

      // Add members to the project properties
      projectProperties.members = this.user._id === Meteor.userId() ?
        [ Meteor.userId() ] : [ Meteor.userId(), this.user._id ];

      // Create project (on server)
      Meteor.call("projectInsert", projectProperties, function(error, result) {
        if(error) {
          // FIXME: handle error!
          throwError(error.reason);
        } else {
          Router.go("projectPage", { _id: result._id });
        }
      });
    } else if(this.mode === PageMode.edit) {

      // Update project
      var projectId = this.project._id;
      Projects.update(projectId, { $set: projectProperties}, function(error) {
        if(error) {
          // FIXME: handle error!
          throwError(error.reason);
        } else {
          Router.go("projectPage", { _id: projectId });
        }
      });
    }
  },

  // Cancel the create or edit of the project
  "click .cancel-button": function() {

    // Go back to previous page
    history.back();
  },

  // Close the view of the project
  "click .close-button": function() {

    // Go back to previous page
    history.back();
  }

});
