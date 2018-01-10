//
//  BeaconManager.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-09.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import Foundation
import CoreLocation

class BeaconManager: NSObject {
    
    var monitoring = [Object]() // Objects to be monitored
    
    var beaconManagerDelegate: BeaconManagerProtocol?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override init() {
        
        super.init()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        addItemsToBeMonitored()
        startMonitoringLocation();
    }
    
    func addItemsToBeMonitored() {
        
        // For now, this will just monitor the default (iPad Pro)
        let object: Object = Object(uuid: Defaults.uuid,
                                    majorValue: CLBeaconMajorValue(Defaults.majorValue),
                                    minorValue: CLBeaconMinorValue(Defaults.minorValue),
                                    name: Defaults.name)
        monitoring.append(object)
    }
    
    func startMonitoringLocation() {
        
        //TODO: Need to iterate over the monitoring array
        
        let beaconRegion = monitoring[0].asCLBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.requestState(for: beaconRegion)
        //locationManager.startRangingBeacons(in: beaconRegion)
    }
}

extension BeaconManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        print("Entered Region")
        //TODO: Implement this
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        
        if (state == .inside && region is CLBeaconRegion) {
            // Device is already inside of a beacon region. Begin ranging.
            for item in monitoring {
                locationManager.startRangingBeacons(in: item.asCLBeaconRegion())
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        for row in 0..<monitoring.count {
            for beacon in beacons {
                if monitoring[row] == beacon {
                    print("Beacon matches \n Distance: \(beacon.proximityString)");
                    
                    let matched = Object(uuid: beacon.proximityUUID,
                                            majorValue: CLBeaconMajorValue(beacon.major),
                                            minorValue: CLBeaconMinorValue(beacon.minor),
                                            name: Defaults.name)
                    matched.proximity = beacon.proximityString;
                    
                    beaconManagerDelegate?.refreshBeaconView(matched);
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        print("Monitoring failed: \(error.localizedDescription)")
    }
}

protocol BeaconManagerProtocol {
    func refreshBeaconView(_ beacon: Object);
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
