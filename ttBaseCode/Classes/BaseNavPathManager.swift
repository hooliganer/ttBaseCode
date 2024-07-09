import SwiftUI

@available(iOS 16.0, *)
public class BaseNavPathManager: ObservableObject {
    
    @Published var path = NavigationPath()
    
    static let shared = BaseNavPathManager()
    
    static func toPage<PathPage: Hashable>(_ path: PathPage) {
        BaseNavPathManager.shared.path.append(path)
    }
    
    static func backRoot() {
        BaseNavPathManager.shared.path.removeLast(BaseNavPathManager.shared.path.count)
    }
    
    static func back() {
        BaseNavPathManager.shared.path.removeLast()
    }
}

@available(iOS 16.0, *)
public extension View {
    func toPage<PathPage: Hashable>(_ page: PathPage, data: Any? = nil) -> some View {
        self.onTapGesture {
            BaseNavPathManager.toPage(page)
        }
    }
}
