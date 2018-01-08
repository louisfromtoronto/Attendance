# Attendance
Attendance is an iOS application designed to automatically mark a 
student as present in a class, when their device in a classroom. This is
accomplished using Bluetooth iBeacons. The Attendance iOS client can determine
the proximity of the iBeacon to the device, and mark the student as being
present when the detected proximity is sufficiently close. For the server
software, we're using Node.js running Express and MongoDB. 

# Prerequisites
* A Mac with Xcode
* Node.js
* An iOS device to test the Attendance app on
* One of the following two options:
  * A hardware iBeacon, or
  * A *second* iOS device that will be used to *simulate* an iBeacon.
    Note that this **must be a separate iOS device than what you'll be 
    using to run and test the Attendance app**. You cannot run the Attendance
    app and simulate an iBeacon on the same iOS device. To simulate an iBeacon,
    I recommend using GemTotSDK, [available from the App Store](https://itunes.apple.com/us/app/gemtot-sdk/id967907684?mt=8).
* Ability to deploy the server software either locally on your network, or on
the Internet using Amazon EC2. Alternately, the server can be run on your local
machine using localhost on your Mac, but functionality will be limited, as an
app running on an iOS device cannot connect to localhost.

# Installation and Configuration
Clone the repository to your system. Open the "Node" folder in Terminal, and
enter ``` npm update ```. This will download and install the various packages
necessary to run the server (as defined in the ```package.json``` file).

Open ```server.js```. The ```port``` variable defines which port the Express
server will be running on. I've set it to port 8000, but you can change it
to what you like, if necessary.

Open the ```/config``` directory. Create a file named ```db.js```. This JavaScript document defines where your
MongoD database will be running. Paste the following code into ```db.js``` and put the url for your database in
the quotation marks. I recommend creating and running the database on mlab, 
for most expedient testing.
```
module.exports = {
    url : ""
}
```

Navigate to the directory ```iOS/AttendanceApp/AttendanceApp/``` and open 
the file ```config.swift```. This is where we define the location of the 
routes used for the API calls. For now, we have one route, ```studentsPath```, 
which is set to ```http://localhost:8000/students/```. ```studentsPath``` will
need to be changed to point to wherever the Express server is running.

Finally, you'll need to set up your iBeacon. Find the UUID, majorValue,
minorValue and name for the iBeacon. Open the file ```Defaults.swift```,
and change the values accordingly. Note that the UUID should be in format:
```00000000-0000-0000-0000-000000000000``` (*yes, you need the dashes*)
