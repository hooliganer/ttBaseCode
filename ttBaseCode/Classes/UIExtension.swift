import SwiftUI

extension View {
    
    func max_width(alignment: Alignment = .center) -> some View { self.frame(maxWidth: .infinity, alignment: alignment) }
    
    func max_height() -> some View { self.frame(maxHeight: .infinity) }
    
    func max_size(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
    
    func height(_ height: CGFloat, alignment: Alignment = .center) -> some View { self.frame(height: height, alignment: alignment) }
    
    func width(_ width: CGFloat) -> some View { self.frame(width: width) }
    
    /// 设置宽高相等的size
    /// - Parameter value: 数值
    /// - Returns: View
    func size(_ value: CGFloat) -> some View { self.frame(width: value, height: value) }
    
    func background_color(_ color: Color) -> some View {  self.background(color) }
    
    func background_gradient_color(_ colors: [Color] =  [.accent, .second],
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

extension View {
    func corner_radius_normal(_ value: CGFloat) -> some View {
        self.clipShape(RoundedRectangle(cornerSize: .init(width: value, height: value)))
    }
    
    func corner_radius_only(_ value: CGFloat, edges: [Alignment] = []) -> some View {
        self.clipShape(OnlyCornerShape(radius: value, edges: edges))        
    }
    
    /// 部分圆角（必须有背景色，无法镂空边框）
    /// - Parameters:
    ///   - value: 圆角
    ///   - line_width: 线宽
    ///   - line_color: 线条颜色
    ///   - edges: 圆角处
    /// - Returns: View
    func border_radius_only(_ value: CGFloat, line_width: CGFloat = 1, line_color: Color = .black, edges: [Alignment] = []) -> some View {
        self.corner_radius_only(value - line_width, edges: edges)
            .padding(line_width)
            .background_color(line_color)
            .corner_radius_only(value, edges: edges)
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
}

extension View {
    func alert_view<Content: View>(show: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        self.modifier(AlertViewModifier(custom_view: content(), show: show))
    }
}

extension View {
    func first_appear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(action: action))
    }
}

extension View {
    
    /// 使用自定义返回按钮
    /// - Parameters:
    ///   - action: 点击回调
    /// - Returns: View
    func system_back_button(left_views: [any View] = [],
                            action: (() -> Void)? = nil) -> some View
    {
        let back_btn = back_button()
        
        let arr: [AnyView] = [AnyView(back_btn)] + left_views.map({ AnyView($0) })
        
        return self
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 0) {
                        ForEach(Array(arr.enumerated()), id: \.offset) { _, value in
                            value
                        }
                    }
                }
            }
        
    }
    
    func system_nav_right_view(_ views: [any View]) -> some View {
        let arr = views.map({ $0.any_view() })
        return self.toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 0) {
                    ForEach(Array(arr.enumerated()), id: \.offset) { _, value in
                        value
                    }
                }
            }
        }
    }
    
    func to_page(_ page: NavigationPathPage, data: Any? = nil) -> some View {
        self.onTapGesture {
            NavigationPathManager.to_page(page)
        }
    }
}

struct FirstAppearModifier: ViewModifier {
    var action: () -> Void
    
    @State private var is_first_appearance = true
    
    func body(content: Content) -> some View {
        content.onAppear {
            if self.is_first_appearance {
                self.action()
                self.is_first_appearance = false
            }
        }
    }
}

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

extension UIApplication {
    var current_window: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? another_current_window
    }
    
    private var another_current_window: UIWindow? {
        let scene = connectedScenes.first(where: {
            $0.activationState == .foregroundActive ||  $0.activationState == .foregroundInactive
        }) as? UIWindowScene
        return scene?.keyWindow
    }
}

extension CGFloat {
    static var status_bar_height: CGFloat {
        UIApplication.shared.current_window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    }
    
    static var safe_area_bottom: CGFloat {
        UIApplication.shared.current_window?.safeAreaInsets.bottom ?? 0
    }
    
    static var screen_width: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var screen_height: CGFloat {
        UIScreen.main.bounds.height
    }
}

extension Text {
    func text_color(_ color: Color) -> Text {
        if #available(iOS 17.0, *) {
            self.foregroundStyle(color)
        } else {
            self.foregroundColor(color)
        }
    }
    
    func fontSize(_ size: CGFloat, weight: Font.Weight = .regular) -> Text {
        self.font(.system(size: size, weight: weight))
    }
    
}

extension Color {
    static var random_color: Color {
        .init(red: Double(arc4random() % 255) / 255,
              green: Double(arc4random() % 255) / 255,
              blue: Double(arc4random() % 255) / 255)
    }
    
    static func hex_value(_ rgb: Int, _ alpha: Double = 1) -> Color {
        let r = rgb >> 16
        let g = rgb >> 8 & 0xff
        let b = rgb & 0xff
        
        return Color(red: Double(r)/255,
                     green: Double(g)/255,
                     blue: Double(b)/255).opacity(alpha)
    }
}

extension View {
    
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

extension View {
    func alert_bottom<T: View>(show: Binding<Bool>, @ViewBuilder content: @escaping () -> T) -> some View {
        self.if(show.wrappedValue) { aview in
            aview.overlay {
                BottomAlertView(show: show, content: content)
            }
        }
    }
}
