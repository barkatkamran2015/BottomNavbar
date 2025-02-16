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
    @State private var waveProgress: CGFloat = 0.0
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
                // Animated Gradient Background
                RoundedRectangle(cornerRadius: 30)
                    .fill(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple, .orange]),
                            center: .center,
                            startAngle: .degrees(rotationEffect - 45),
                            endAngle: .degrees(rotationEffect + 45)
                        )
                    )
                    .frame(height: 90)
                    .blur(radius: 20)
                    .opacity(0.4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [.white.opacity(0.5), .clear]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .shadow(color: .blue.opacity(0.3), radius: 20, y: 10)
                    .rotationEffect(.degrees(rotationEffect))
                    .animation(
                        Animation.linear(duration: 20)
                            .repeatForever(autoreverses: false),
                        value: rotationEffect
                    )
                
                // Main Navbar Content
                HStack {
                    ForEach(0..<tabBarItems.count, id: \.self) { index in
                        Spacer()
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                selectedTab = index
                                waveTrigger.toggle()
                                rotationEffect += 180
                                scaleEffect = 1.2
                            }
                            
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            
                            withAnimation(.easeOut(duration: 0.2)) {
                                scaleEffect = 1.0
                            }
                            
                            // Wave animation
                            withAnimation(.easeOut(duration: 0.6)) {
                                waveProgress = 1.0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                waveProgress = 0.0
                            }
                        }) {
                            VStack {
                                if index == selectedTab {
                                    Circle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(colors: [.orange, .red]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: tabBarItems[index].0)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.white)
                                                .rotationEffect(.degrees(scaleEffect == 1.2 ? -15 : 0))
                                        )
                                        .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)
                                        .scaleEffect(scaleEffect)
                                        .offset(y: scaleEffect == 1.2 ? -15 : 0)
                                        .matchedGeometryEffect(id: "icon", in: animation)
                                } else {
                                    Image(systemName: tabBarItems[index].0)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.white.opacity(0.7))
                                        .scaleEffect(index == selectedTab ? 0.8 : 1.0)
                                }
                            }
                        }
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: waveProgress * 3)
                                .scaleEffect(waveProgress == 0.0 ? 1 : waveProgress * 3)
                                .opacity(waveProgress == 0.0 ? 0 : 1 - waveProgress)
                                .animation(.easeOut(duration: 0.6), value: waveProgress)
                        )
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 90)
            .padding(.bottom, 10)
        }
        .onAppear {
            rotationEffect = 0
            withAnimation {
                rotationEffect = 360
            }
        }
    }
}
