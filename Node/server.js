const express = require('express');
const MongoClient = require('mongodb').MongoClient;
const bodyParser = require('body-parser');
const db = require('./config/db')
const app = express();

const port = 8000;

app.use(bodyParser.urlencoded({ extended: true }));

// MONGO 
MongoClient.connect(db.url, (err, database) => {
    if (err) throw err;

    require('./app/routes')(app, database);
    
    app.listen(port, () => {
        console.log('We are live on port: ' + port);
    });

})