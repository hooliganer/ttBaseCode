//
//  TestPlayerView.swift
//  ttBaseCode_Example
//
//  Created by 谭滔 on 2024-06-13.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import ttBaseCode

@available(iOS 15.0, *)
class TestPlayerManager: ObservableObject {
    
    static let shared = TestPlayerManager()
    
    @Published var isFloating = false
        
    @Published var pwd: String = ""
    @Published var pwdAgain: String = ""
    
    var canNext: Bool { !pwd.isEmpty && pwd == pwdAgain }
    
    var showBottom: Bool { pwd == "1111" }
    
    func toggleFloating() {
        withAnimation {
            isFloating.toggle()
        }
    }
    
    func test() {

    }
}

@available(iOS 15.0, *)
struct TestPlayerView: View {
    
    @Namespace var anim: Namespace.ID
    
    @StateObject var vm = TestPlayerManager.shared
    
    var body: some View {
        ZStack {
            
            if vm.isFloating {
                VStack(spacing: 0) {
                    Spacer()
                     
                    HStack(spacing: 0) {
                        TestPlayerFloating(anim: anim)
                            .padding(.leading, 10)
                        
                        Spacer()
                    }
                }
            } else {
                TestPlayerPage(anim: anim)
            }
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    TestPlayerView()
}

@available(iOS 15.0, *)
struct TestPlayerPage: View {
    
    let anim: Namespace.ID
    
    @StateObject var vm = TestPlayerManager.shared
    
    var body: some View {
        ZStack {
            page
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                Spacer()
                    
                    Text("悬浮")
                        .onTapGesture {
                            vm.toggleFloating()
                        }
                }
                Spacer()
            }
            
            GeometryReader { geo in
                bottomTips
                    .offset(.init(width: 0, height: vm.showBottom ? 0 : geo.size.height))
                    .animation(.default, value: vm.showBottom)
            }
        }
            .maxSize()
            .matchedGeometryEffect(id: "abcccc", in: anim)
            .edgesIgnoringSafeArea(.all)
        
    }
    
    var page: some View {
        VStack(spacing: 0) {
            Text("标题")
                .padding(.vertical, 10)
            
            TextField("111", text: $vm.pwd)
                .textFieldStyle(MoreHeightTextFieldStyle(height: 100))
            
            TextField("222", text: $vm.pwdAgain)
                .textFieldStyle(MoreHeightTextFieldStyle(height: 50))
            
            Color.red
                .size(50)
                .opacity(vm.canNext ? 1 : 0.3)
                .animation(.default, value: vm.canNext)
            
            Spacer()
        }
    }
    
    var bottomTips: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Text("恭喜触发!!!!")
                .height(100)
                .maxWidth()
                .backgroundColor(.yellow)
        }
    }
}


@available(iOS 15.0, *)
struct TestPlayerFloating: View {
    
    let anim: Namespace.ID
    
    @StateObject var vm = TestPlayerManager.shared
    
    var body: some View {
        Color.white
            .matchedGeometryEffect(id: "abcccc", in: anim)
            .width(.screenWidth)
            .height(50)
//            .corner_radius_normal(999)
            .shadow(radius: 10)
            .onTapGesture {
                vm.toggleFloating()
            }
    }
    
}
