import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 2
    @State private var waveTrigger = false
    @Namespace private var animationNamespace
    
    var body: some View {
        ZStack {
            // Background Color Animation
            Color(selectedTab == 0 ? .orange : selectedTab == 1 ? .blue : selectedTab == 2 ? .green : selectedTab == 3 ? .pink : .purple)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: selectedTab)
            
            // **Expanding Circle Wave Effect**
            Circle()
                .fill(Color.white.opacity(0.2))
                .frame(width: waveTrigger ? 400 : 0, height: waveTrigger ? 400 : 0)
                .scaleEffect(waveTrigger ? 1 : 0)
                .opacity(waveTrigger ? 0 : 1)
                .animation(.easeOut(duration: 0.5), value: waveTrigger)
            
            VStack {
                Spacer()
                
                // **Animated Wave when switching pages**
                VStack {
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 150, height: 150)
                        .scaleEffect(waveTrigger ? 1.2 : 0.8)
                        .opacity(waveTrigger ? 0 : 1)
                        .animation(.easeInOut(duration: 0.6), value: waveTrigger)
                    
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .scaleEffect(waveTrigger ? 1.5 : 0.9)
                        .opacity(waveTrigger ? 0 : 1)
                        .animation(.easeOut(duration: 0.4), value: waveTrigger)
                }
                
                Spacer()
                
                BottomNavbar(selectedTab: $selectedTab, waveTrigger: $waveTrigger)
            }
        }
    }
}

#Preview {
    ContentView()
}
