//
//  BaseFunction.swift
//  ttBaseCode
//
//  Created by 谭滔 on 2024-04-01.
//

import Foundation

public class MyLinkListNode<Element> {
    public var val: Element
    public var next: MyLinkListNode?
    
    public init(_ val: Element, _ next: MyLinkListNode? = nil) {
        self.val = val
        self.next = next
    }
}

public extension Array {
    
    func toNodeList() -> MyLinkListNode<Self.Element>? {
        return Self.convertArrayToNodeList(self)
    }
    
    static func convertArrayToNodeList(_ array: [Self.Element] = [], i: Int = 0) -> MyLinkListNode<Self.Element>? {
        guard i < array.count else {
            return nil
        }
        let head = MyLinkListNode(array[i])
        head.next = convertArrayToNodeList(array, i: i + 1)
        return head
    }
}
