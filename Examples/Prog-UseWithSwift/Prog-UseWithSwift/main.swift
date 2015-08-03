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
if res.value != YAPI_SUCCESS.value {
    println("Error: \(error?.localizedDescription)")
    exit(0)
}

println("Device list:")
var module = YModule.FirstModule()
while module != nil {
    var serial = module.get_serialNumber()
    var productName = module.get_productName()
    println("\(serial) \(productName)")
    module = module.nextModule()
}
YAPI.FreeAPI()