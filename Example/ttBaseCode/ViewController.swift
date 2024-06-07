//
//  ViewController.swift
//  ttBaseCode
//
//  Created by tantao on 03/27/2024.
//  Copyright (c) 2024 tantao. All rights reserved.
//

import UIKit
import ttBaseCode
import SwiftUI

@available(iOS 14.0, *)
class ViewController: UIViewController {
    
    @TDefaultWrap("testbool", defaultValue: false)
    var testbool: Bool
    
    @TDefaultWrap("model", defaultValue: TestStruct(name: "默认文案"))
    var model: TestStruct
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.testbool = true
        
        
        print(model)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

struct TestStruct: Codable {
    var name: String?
    var num: Int?
    var boolValue: Bool?
    var model: SubModel?
    
    struct SubModel: Codable {
        var text: String?
    }
}
