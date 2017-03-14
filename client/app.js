Meteor.startup(function() {
    if (Meteor.isServer) {

        BrowserPolicy.content.allowOriginForAll("http://meteor.local");

    }

    console.log(Meteor.status().status);

    // App gestart via notificatie
    Push.addListener('startup', function(notification) {
        //console.log(notification.message);
        Router.go('memberPage', {
            _id: Meteor.userId()
        });
    });

    // In-app notificaties ontvangen
    Push.addListener('message', function(notification) {
        alert('in-app notificatie!');
    });

});
