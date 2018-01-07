//
//  ViewController.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-02.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var majorValueLabel: UILabel!
    @IBOutlet weak var minorValueLabel: UILabel!
    
    
    
    var monitoring = [Object]() // Objects to be monitored
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        addItemsToBeMonitored()
        
        startMonitoringLocation()
    }
    
    func startMonitoringLocation() {
        //TODO: Need to iterate over the monitoring array
        
        let beaconRegion = monitoring[0].asCLBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.requestState(for: beaconRegion)
        //locationManager.startRangingBeacons(in: beaconRegion)
        
        
        //print("Monitoring started \n UUID: \(beaconRegion.proximityUUID.uuidString)\n Major: \(beaconRegion.major?.intValue) Minor: \(beaconRegion.minor?.intValue)")
    }
    
    func addItemsToBeMonitored() {
        // For now, this will just monitor the default (iPad Pro)
        let object: Object = Object(uuid: Defaults.uuid,
                                    majorValue: Defaults.majorValue,
                                    minorValue: Defaults.minorValue,
                                    name: Defaults.name)
        monitoring.append(object)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if (state == .inside && region is CLBeaconRegion) {
            // Device is already inside of a beacon region. Begin ranging.
            for item in monitoring {
                locationManager.startRangingBeacons(in: item.asCLBeaconRegion())
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered Region")
        //TODO: Implement this
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for row in 0..<monitoring.count {
            for beacon in beacons {
                if monitoring[row] == beacon {
                    print("Beacon matches \n Distance: \(beacon.proximityString)")
                    
                    descriptionLabel.text = "Beacon found at distance: \(beacon.proximityString)"
                    uuidLabel.text = beacon.proximityUUID.uuidString
                    majorValueLabel.text = "Major: \(beacon.major)"
                    minorValueLabel.text = "Minor: \(beacon.minor)"
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed: \(error.localizedDescription)")
    }
}

extension ViewController: DataPassable {
    func pass(data: Any) {
        print("")
    }
}

extension CLBeacon {
    var proximityString: String {
        switch self.proximity {
        case .unknown: return "unknown"
        case .immediate: return "immediate"
        case .near: return "near"
        case .far: return "far"
        }
    }
}

protocol DataPassable {
    func pass(data: Any);
}

