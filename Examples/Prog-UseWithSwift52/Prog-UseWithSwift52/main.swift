//
//  main.swift
//  Prog-UseWithSwift52
//
//  Created by Yoctopuce on 27.08.20.
//  Copyright © 2020 Yoctopuce. All rights reserved.
//

import Foundation

var error: NSError?
// Sets up the API to use local USB devices
var res = YAPI.RegisterHub("usb", &error)
if res.rawValue != YAPI_SUCCESS.rawValue {
    print("Error: \(error!.localizedDescription)")
    exit(0)
}

print("Device list:")
var optional_module = YModule.FirstModule()
while let module = optional_module {
    let serial = module.get_serialNumber()
    let productName = module.get_productName()
    print("\(serial) \(productName)")
    let beaconState = module.get_beacon()
    if beaconState == Y_BEACON_ON {
        print("beacon is on")
    }
    module.set_beacon(Y_BEACON_OFF)
    optional_module = module.nextModule()
}

YAPI.FreeAPI()
