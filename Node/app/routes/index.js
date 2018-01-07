const studentRoutes = require('./student_routes');
const beaconRoutes = require('./beacon_routes');

module.exports = function(app, db) {
    studentRoutes(app, db);
    beaconRoutes(app, db);
}