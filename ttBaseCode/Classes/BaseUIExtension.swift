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
    
    func anyView() -> AnyView { AnyView(self) }
    
    func corner_radius_normal(_ value: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerSize: .init(width: value, height: value)))
    }
    
    func corner_radius_only(_ value: CGFloat, edges: [Alignment] = []) -> some View {
        self.clipShape(OnlyCornerShape(radius: value, edges: edges))
    }
    
    func border_line(radius: CGFloat,
                     color: Color = .black,
                     line_width: CGFloat = 1) -> some View {
        self.cornerRadius(radius)
            .overlay(
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .stroke(color, lineWidth: line_width)
            )
            .padding(line_width)
    }
    
    /// 设置行高
    /// - Parameter lineHeight: 行高
    /// - Returns: View
    func line_height(_ lineHeight: CGFloat) -> some View {
        let font = UIFont.preferredFont(forTextStyle: .body)
        let scaledLineHeight = UIFontMetrics.default.scaledValue(for: lineHeight)
        
        return self
            .font(.system(size: font.pointSize, weight: .medium))
            .lineSpacing(scaledLineHeight - font.lineHeight)
    }
    
    /// 扩展View，添加if -> bool 函数
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, modify: (Self) -> Content) -> some View {
        if conditional {
            modify(self)
        } else {
            self
        }
    }
    
    /// 扩展View，添加if -> optional 函数
    @ViewBuilder
    func `if`<Content: View, T>(value: T?, content: (Self, T) -> Content) -> some View {
        if let value = value {
            content(self, value)
        } else {
            self
        }
    }
    
}

@available(iOS 13.0, *)
struct OnlyCornerShape: Shape {
    
    var radius: CGFloat
    
    var edges: [Alignment]
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            if edges.contains(.topLeading) {
                path.move(to: .init(x: 0, y: radius))
                path.addArc(center: .init(x: radius, y: radius),
                            radius: radius,
                            startAngle: .init(degrees: -180),
                            endAngle: .init(degrees: -90),
                            clockwise: false)
            } else {
                path.move(to: .zero)
            }
            
            if edges.contains(.topTrailing) {
                path.addArc(center: .init(x: rect.width - radius, y: radius),
                            radius: radius,
                            startAngle: .init(degrees: -90),
                            endAngle: .init(degrees: 0),
                            clockwise: false)
            } else {
                path.addLine(to: .init(x: rect.width, y: 0))
            }
            
            if edges.contains(.bottomTrailing) {
                path.addArc(center: .init(x: rect.width - radius, y: rect.height - radius),
                            radius: radius,
                            startAngle: .init(degrees: 0),
                            endAngle: .init(degrees: 90),
                            clockwise: false)
            } else {
                path.addLine(to: .init(x: rect.width, y: rect.height))
            }
            
            if edges.contains(.bottomLeading) {
                path.addArc(center: .init(x: radius, y: rect.height - radius),
                            radius: radius,
                            startAngle: .init(degrees: 90),
                            endAngle: .init(degrees: 180),
                            clockwise: false)
            } else {
                path.addLine(to: .init(x: 0, y: rect.height))
            }
        }
    }
    
}
