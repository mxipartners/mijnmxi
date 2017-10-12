this.Projects = new Mongo.Collection("projects");

Projects.allow({
  update: function(userId, project) {
    return isProjectMember(userId, project);
  },
  remove: function(userId, project) {
    return isProjectMember(userId, project);
  }
});

Projects.deny({
  update: function(userId, project, fieldNames) {
    // may only edit the following fields:
    return _.without(fieldNames, "title", "description", "members").length > 0;
  }
});

Projects.deny({
  update: function(userId, project, fieldNames, modifier) {
    if(modifier.$set === undefined) {
      return "";
    }
    var errors = validateProjectUpdate(modifier.$set);
    return errors.title || errors.members;
  }
});

Meteor.methods({
  projectInsert: function(projectAttributes) {
    check(Meteor.userId(), String);
    validateProject(projectAttributes);
    var user = Meteor.user();
    var project = _.extend(projectAttributes, {
      userId: user._id,
      submitted: new Date(),
      kind: "project"
    });
    var projectId = Projects.insert(project);
    Meteor.call("updateUnreadItems", project, function(error, result) {
      if(error) {
        // FIXME
        throwError(error);
      }
    });
    return { _id: projectId };
  },
  projectRemoveMember: function(projectId, userId) {
    check(projectId, String);
    check(userId, String);
    var project = Projects.findOne(projectId);
    if(project) {
      var members = project.members.filter(function(member) { return member != userId; });
      if(members.length > 0) {
        Projects.update(projectId, { $set: { members: members } }, function(error) {
          if(error) {
            // FIXME: how to get errror to client?
            throwError(error.reason);
          }
        });
        Meteor.call("updateUnreadItems", project, function(error, result) {
          if(error) {
            // FIXME
            throwError(error);
          }
        });
      } else {
        Projects.remove(projectId, function(error) {
          if(error) {
            // FIXME: how to get errror to client?
            throwError(error.reason);
          }
        });
      }
    }
  }
});
