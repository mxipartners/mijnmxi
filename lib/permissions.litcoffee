To check whether a user may edit a particular item, the following functions
are used.

    @isProjectMember = (userId, project) -> userId in project.members

    @ownsProjectItem = (userId, item) ->
      isProjectMember userId, Projects.findOne(item.projectId)
