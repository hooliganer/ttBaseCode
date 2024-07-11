//
//  TestScrollApple.swift
//  ttBaseCode_Example
//
//  Created by 谭滔 on 2024-06-12.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import SwiftUI
import ttBaseCode

@available(iOS 13.0, *)
struct TestScrollApple: View {
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            
            Color.red
                .width(.screenWidth)
                .height(colorHeight)
                .padding(.top, 0.9)
            
            ScrollView {
                VStack {
                    GeometryReader { geometry in
                        Color.clear.preference(key: OffsetPreferenceKey.self, value: geometry.frame(in: .named("scrollView")).origin.y)
                    }
                    .frame(height: 0)
                    
                    ForEach(TestScrollAppleType.allCases, id: \.self) { index in
                        Text(index.title)
                            .frame(height: 40)
                            .padding()
                            .background(Color.randomColor)
                            .animation(.default, value: offset)
                            .contentShape(Rectangle())
                            .toPage(index)
                    }
                }
                .padding(.bottom, 100)
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(OffsetPreferenceKey.self) { value in
                self.offset = value
            }
            .maxSize()
            
            Color.red
                .width(.screenWidth)
                .height(colorHeight)
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    let initHeight: CGFloat = 20
    let maxHeight: CGFloat = 100
    let boundaryMin: CGFloat = 150
    let boundaryMax: CGFloat = 350
    
    var colorHeight: CGFloat {
        if offset >= -boundaryMin {
            return initHeight
        } else if offset >= -boundaryMax {
            return initHeight + abs(offset) - boundaryMin
        } else {
            return initHeight + boundaryMax - boundaryMin
        }
    }
}

@available(iOS 13.0, *)
#Preview {
    TestScrollApple()
}

struct OffsetPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

@available(iOS 13.0, *)
enum TestScrollAppleType: BaseNavigationPath, CaseIterable {
    case a
    case b
    case c
    
    var title: String { String(describing: self) }
    
    var page: any View {
        Text(title)
    }
}
