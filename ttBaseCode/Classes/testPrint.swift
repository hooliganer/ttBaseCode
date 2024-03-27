//
//  testPrint.swift
//  SUBaseCode
//
//  Created by 谭滔 on 2024-03-27.
//

import Foundation

public class TestTool {
    
    public static let shared = TestTool()
    
    public func testPrint(text: String) {
        debugPrint(text)
    }
}
