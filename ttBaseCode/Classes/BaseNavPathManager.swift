import SwiftUI

@available(iOS 16.0, *)
public class BaseNavPathManager: ObservableObject {
    
    @Published var path = NavigationPath()
    
    static let shared = BaseNavPathManager()
    
    static func toPage<PathPage: BaseNavigationPath>(_ path: PathPage) {
        BaseNavPathManager.shared.path.append(path)
    }
    
    static func backRoot() {
        BaseNavPathManager.shared.path.removeLast(BaseNavPathManager.shared.path.count)
    }
    
    static func back() {
        BaseNavPathManager.shared.path.removeLast()
    }
}

@available(iOS 13.0, *)
public extension View {
    func toPage<PathPage: BaseNavigationPath>(_ page: PathPage, data: Any? = nil) -> some View {
        if #available(iOS 16.0, *) {
            return self.onTapGesture {
                BaseNavPathManager.toPage(page)
            }
        } else {
            return NavigationLink(destination: page.page.anyView()) {
                self
            }
        }
    }
}

@available(iOS 13.0, *)
public protocol BaseNavigationPath: Hashable {
    var page: any View { get }
}
