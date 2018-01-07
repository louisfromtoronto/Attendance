var ObjectID = require('mongodb').ObjectID;

module.exports = function(app, db) {
    // Adds student to database if the student isn't already in the database
    app.post('/students', (req, res) => {

        //The iOS client has a bug that puts the entire
        // contents of the JSON into the first key. 
        const reqJSON = Object.keys(req.body)[0];

        const parsed = JSON.parse(reqJSON);

        const document = { "firstName": parsed.firstName,
                            "lastName": parsed.lastName,
                           "studentID": parsed.studentID,
                         "accountType": parsed.accountType}
        
        db.collection('students').insert(document, (err, result) => {
            if (err) {
                res.send({ 'error' : 'An error has occured'});
            } else {
                console.log("Adding Student:")
                console.log('First Name: ' + document.firstName);
                console.log('Last Name: ' + document.lastName);
                console.log('Student Number: ' + document.studentID);
                console.log('Account Type: ' + document.accountType);
                res.send(result.ops[0]);
            }
        });
    });

    app.get('/students/findAll/', (req, res) => {
        db.collection("students").find({}).toArray(function(err, result) {
            if (err) {
                res.send({ 'error' : 'An error has occured'});
            } else {
                console.log(result);
                res.send(result);
            }
          });
    });

    app.get('/students/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        db.collection('students').findOne(details, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occured'});
            } else {
                res.send(item);
            }
        });
    });

    app.put('/students/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        const document = { firstName: req.body.firstName,
                            lastName: req.body.lastName,
                           studentID: req.body.studentID }        
        db.collection('students').update(details, document, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occoured'});
            } else {
                res.send(item);
            }
        });
    });

    app.delete('/students/:id', (req, res) => {
        const id = req.params.id;
        const details = {'_id' : new ObjectID(id)};
        db.collection('students').remove(details, (err, item) => {
            if (err) {
                res.send({ 'error' : 'An error has occoured'});
            } else {
                res.send('Document with ' + id + ' deleted');
            }
        });
    });


}