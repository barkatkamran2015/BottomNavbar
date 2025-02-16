//
//  BottomNavbar.swift
//  CustomTabBar
//
//  Created by Barkat Ali Kamran on 2025-02-15.
//

import SwiftUI

struct BottomNavbar: View {
    @Binding var selectedTab: Int
    @Binding var waveTrigger: Bool
    @State private var scaleEffect: CGFloat = 1.0
    @State private var rotationEffect: Double = 0.0
    @Namespace private var animation

    let tabBarItems = [
        ("house", "Home"),
        ("magnifyingglass", "Search"),
        ("cart", "Cart"),
        ("heart", "Favorite"),
        ("person", "Profile")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Background with Blur & Shadow
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.white.opacity(0.95), Color.gray.opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: 10)
                    .frame(height: 90)
                    .blur(radius: 1)
                
                HStack {
                    ForEach(0..<tabBarItems.count, id: \.self) { index in
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                selectedTab = index
                                waveTrigger.toggle() // **Trigger the wave animation**
                                UIImpactFeedbackGenerator(style: .light).impactOccurred() // Haptic Feedback
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeOut(duration: 0.2)) {
                                    waveTrigger = false
                                }
                            }
                        }) {
                            VStack {
                                if index == selectedTab {
                                    Circle()
                                        .fill(Color.orange)
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: tabBarItems[index].0)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                        )
                                        .matchedGeometryEffect(id: "icon", in: animation)
                                } else {
                                    Image(systemName: tabBarItems[index].0)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.bottom, 10)
        }
    }
}
