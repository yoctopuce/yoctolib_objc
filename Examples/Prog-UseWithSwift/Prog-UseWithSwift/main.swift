//
//  main.swift
//  Prog-UseWithSwift
//
//  Created by Yoctopuce on 12/03/15.
//  Copyright (c) 2015 Yoctopuce. All rights reserved.
//

import Foundation

var error: NSError?
// Sets up the API to use local USB devices
var res = YAPI.RegisterHub("usb", &error)
if res.rawValue != YAPI_SUCCESS.rawValue {
    print("Error: \(error?.localizedDescription)")
    exit(0)
}

print("Device list:")
var module = YModule.FirstModule()
while module != nil {
    var serial = module.get_serialNumber()
    var productName = module.get_productName()
    print("\(serial) \(productName)")
    module = module.nextModule()
}
YAPI.FreeAPI()