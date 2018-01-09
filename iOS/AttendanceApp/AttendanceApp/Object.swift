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
    let majorValue: CLBeaconMajorValue // UInt16 TYPEALIAS
    let minorValue: CLBeaconMinorValue // UInt16 TYPEALIAS
    let name: String
    var proximity: String?
    
    init(uuid: UUID, majorValue: CLBeaconMajorValue, minorValue: CLBeaconMinorValue, name: String){
        self.uuid = uuid
        self.majorValue = CLBeaconMajorValue(majorValue)
        self.minorValue = CLBeaconMinorValue(minorValue)
        self.name = name
        self.proximity = nil
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
