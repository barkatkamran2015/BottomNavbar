import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 2
    @State private var waveTrigger = false
    @State private var particleSystem = ParticleSystem()
    @Namespace private var animationNamespace
    
    var body: some View {
        ZStack {
            // Dynamic Animated Background
            AngularGradient(
                gradient: Gradient(colors: backgroundColors),
                center: .center,
                startAngle: .degrees(Double(selectedTab) * -90), // Convert selectedTab to Double
                endAngle: .degrees(Double(selectedTab) * -90 + 360) // Convert selectedTab to Double
            )

                .hueRotation(.degrees(waveTrigger ? 180 : 0))
                .opacity(0.8)
                .blur(radius: 20)
                .animation(.easeInOut(duration: 1.5), value: selectedTab)
                .overlay(.ultraThinMaterial)
                .ignoresSafeArea()
            
            // Particle System
            particleSystemView
            
            // Main Content
            VStack {
                Spacer()
                
                // Animated Tab Content
                tabContentView
                    .padding(.vertical, 40)
                
                Spacer()
                
                BottomNavbar(selectedTab: $selectedTab, waveTrigger: $waveTrigger)
            }
            
            // Wave Effect System
            waveEffectSystem
        }
        .onChange(of: waveTrigger) { _ in
            particleSystem.emit(count: 15)
            UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
    
    // MARK: - Computed Properties
    
    private var backgroundColors: [Color] {
        [Color(hex: 0xFF6B6B), Color(hex: 0x4ECDC4), Color(hex: 0x45B7D1),
         Color(hex: 0x96CEB4), Color(hex: 0xFFEEAD)].shuffled()
    }
    
    private var tabContentView: some View {
        Group {
            switch selectedTab {
            case 0:
                Text("Home")
                    .font(.system(size: 40, weight: .bold))
                    .matchedGeometryEffect(id: "tabContent", in: animationNamespace)
            case 1:
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 40))
                    .matchedGeometryEffect(id: "tabContent", in: animationNamespace)
            case 2:
                Circle()
                    .frame(width: 80, height: 80)
                    .matchedGeometryEffect(id: "tabContent", in: animationNamespace)
            case 3:
                Text("❤️")
                    .font(.system(size: 50))
                    .matchedGeometryEffect(id: "tabContent", in: animationNamespace)
            default:
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 40))
                    .matchedGeometryEffect(id: "tabContent", in: animationNamespace)
            }
        }
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
        .animation(.spring(response: 0.5, dampingFraction: 0.6), value: selectedTab)
    }
    
    private var waveEffectSystem: some View {
        ZStack {
            ForEach(0..<4) { index in
                Circle()
                    .stroke(Color.white.opacity(0.3 - Double(index)*0.08), lineWidth: 2)
                    .frame(width: waveTrigger ? 400 : 0, height: waveTrigger ? 400 : 0)
                    .scaleEffect(waveTrigger ? 1 : 0.2)
                    .opacity(waveTrigger ? 0 : 1)
                    .animation(
                        .easeOut(duration: 0.6)
                        .delay(Double(index) * 0.1),
                        value: waveTrigger
                    )
            }
        }
    }
    
    private var particleSystemView: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                particleSystem.update(date: timeline.date.timeIntervalSinceReferenceDate)
                
                for particle in particleSystem.particles {
                    let frame = CGRect(
                        x: particle.x * size.width,
                        y: particle.y * size.height,
                        width: 8,
                        height: 8
                    )
                    
                    context.opacity = particle.opacity
                    context.fill(
                        Circle().path(in: frame),
                        with: .color(
                            Color(
                                hue: particle.hue,
                                saturation: 0.6,
                                brightness: 1
                            )
                        )
                    )
                }
            }
        }
        .blendMode(.plusLighter)
        .blur(radius: 2)
    }
}

// MARK: - Particle System Implementation

struct Particle: Identifiable {
    let id = UUID()
    var x: Double = 0
    var y: Double = 0
    var hue: Double = 0
    var speedX: Double = 0
    var speedY: Double = 0
    var opacity: Double = 1
    var birthDate = Date.timeIntervalSinceReferenceDate
}

class ParticleSystem {
    var particles = [Particle]()
    
    func emit(count: Int) {
        for _ in 0..<count {
            let particle = Particle(
                x: 0.5 + Double.random(in: -0.1...0.1),
                y: 0.9,
                hue: Double.random(in: 0...1),
                speedX: Double.random(in: -0.1...0.1),
                speedY: Double.random(in: -0.4...0)
            )
            particles.append(particle)
        }
    }
    
    func update(date: TimeInterval) {
        particles = particles.filter { date - $0.birthDate < 2 }
        
        for index in particles.indices {
            particles[index].x += particles[index].speedX * 0.01
            particles[index].y += particles[index].speedY * 0.01
            particles[index].speedY += 0.1
            particles[index].opacity = 1 - (date - particles[index].birthDate) / 2
        }
    }
}

// MARK: - Color Extension

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

#Preview {
    ContentView()
}
