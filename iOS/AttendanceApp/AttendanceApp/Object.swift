//
//  Object.swift
//  AttendanceApp
//
//  Created by Louis Mark on 2018-01-02.
//  Copyright © 2018 Louis Mark. All rights reserved.
//

import Foundation
import CoreLocation

class Object {
    let uuid: UUID
    let majorValue: CLBeaconMajorValue
    let minorValue: CLBeaconMinorValue
    let name: String
    
    init(uuid: UUID, majorValue: Int, minorValue: Int, name: String){
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
        self.name = name
    }
    
    func asCLBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: uuid,
                              major: majorValue,
                              minor: minorValue,
                              identifier: name)
    }
}

func ==(item: Object, beacon: CLBeacon) -> Bool {
    return ((beacon.proximityUUID.uuidString == item.uuid.uuidString)
        && (Int(beacon.major) == Int(item.majorValue))
        && (Int(beacon.minor) == Int(item.minorValue)))
}
