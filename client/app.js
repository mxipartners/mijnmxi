Meteor.startup(function() {
    if (Meteor.isServer) {

        BrowserPolicy.content.allowOriginForAll("http://meteor.local");

    }

    console.log(Meteor.status().status);

});
