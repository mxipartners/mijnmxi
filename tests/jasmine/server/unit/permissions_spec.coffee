describe 'A user, when added to a project', ->

  project = {members: ['id']}

  it 'owns a project', ->
    expect(isProjectMember('id', project)).toBe true

  it 'owns the items in the project', ->
    spyOn(Projects, 'findOne').and.returnValue(project)
    expect(ownsProjectItem('id', {projectId: 'projectId'})).toBe true


describe 'A user, when not added to a project', ->

  project = {members: ['another id']}

  it 'is not an owner', ->
    expect(isProjectMember('id', project)).toBe false

  it "doesn't own items in the project", ->
    spyOn(Projects, 'findOne').and.returnValue(project)
    expect(ownsProjectItem('id', {projectId: 'projectId'})).toBe false
