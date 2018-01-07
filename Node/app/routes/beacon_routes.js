var ObjectID = require('mongodb').ObjectID;

module.exports = function(app, db) {
    app.post('/beacons', (req, res) => {
        const document = { UUID: req.body.UUID,
                            major: req.body.major,
                           minor: req.body.minor,
                            name: req.body.name,
                           class: req.body.class }
        db.collection('beacons').insert(document, (err, result) => {
            if (err) {
                res.send({ 'error' : 'An error has occured'});
            } else {
                res.send(result.ops[0]);
            }
        });
    });

    app.get('/beacons/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        db.collection('beacons').findOne(details, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occoured'});
            } else {
                res.send(item);
            }
        });
    });

    app.put('/beacons/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        const document = { UUID: req.body.UUID,
                          major: req.body.major,
                          minor: req.body.minor,
                           name: req.body.name,
                          class: req.body.class }        
        db.collection('beacons').update(details, document, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occoured'});
            } else {
                res.send(item);
            }
        });
    });

    app.delete('/beacons/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        db.collection('beacons').remove(details, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occoured'});
            } else {
                res.send('Document with ' + id + ' deleted');
            }
        });
    });


}