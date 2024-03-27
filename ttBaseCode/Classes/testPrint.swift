//
//  testPrint.swift
//  SUBaseCode
//
//  Created by 谭滔 on 2024-03-27.
//

import Foundation

public class TestTool {
    
    static let shared = TestTool()
    
    func testPrint(text: String) {
        debugPrint(text)
    }
}
