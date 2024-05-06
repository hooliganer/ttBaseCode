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

@available(iOS 13.0, *)
public extension View {
    
    func maxWidth() -> some View { self.frame(maxWidth: .infinity) }
    
    func maxHeight() -> some View { self.frame(maxHeight: .infinity) }
    
    func maxSize(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    func height(_ height: CGFloat) -> some View { self.frame(height: height) }
    
    func width(_ width: CGFloat) -> some View { self.frame(width: width) }
    
    /// 设置宽高相等的size
    /// - Parameter value: 数值
    /// - Returns: View
    func size(_ value: CGFloat) -> some View { self.frame(width: value, height: value) }
    
    func backgroundColor(_ color: Color) -> some View {  self.background(color) }
    
    @available(iOS 15.0, *)
    func backgroundGradientColor(_ colors: [Color] =  [.red, .orange],
                                   startPoint: UnitPoint = .top,
                                   endPoint: UnitPoint = .bottom) -> some View {
        self.background {
            LinearGradient(colors: colors, startPoint: startPoint, endPoint: endPoint)
        }
    }
    
    func scroll() -> some View {
        ScrollView(.vertical) {
            self
        }
    }
    
}
