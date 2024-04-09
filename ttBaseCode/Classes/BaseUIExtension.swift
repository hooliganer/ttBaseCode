//
//  BaseUIExtension.swift
//  ttBaseCode
//
//  Created by 谭滔 on 2024-04-09.
//

import UIKit
import SwiftUI

public extension CGFloat {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return UIWindow.getKeyWindow()?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    static var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, *) {
            return UIWindow.getKeyWindow()?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }
    
    static let screenWidth = UIScreen.main.bounds.width
    
    static let screenHeight = UIScreen.main.bounds.height
}

public extension UIWindow {
    /// 当前Window
    class func getKeyWindow() -> UIWindow? {
        if #available(iOS 13.0, *) {
            let originalKeyWindow = UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }.first
            return originalKeyWindow
        }
        return UIApplication.shared.keyWindow
    }
}
