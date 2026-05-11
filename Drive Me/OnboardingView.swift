import SwiftUI

struct OnboardingStep: Identifiable {
    let id = UUID()
    let type: StepType
    let title: String
    let description: String
    
    enum StepType {
        case systemIcon(name: String)
        case assetImage(name: String)
    }
}

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var selectedPage = 0
    
    let onboardingSteps = [
        OnboardingStep(
            type: .assetImage(name: "DriveMeImg"),
            title: "Welcome to Drive Me",
            description: "A complete carsharing platform. While clients enjoy seamless booking on the map, admins get a powerful panel for fleet control."
        ),
        OnboardingStep(
            type: .systemIcon(name: "map.fill"),
            title: "Explore the Map",
            description: "Easily locate available cars nearby. Check allowed driving zones and find convenient pickup locations."
        ),
        OnboardingStep(
            type: .systemIcon(name: "car.side.fill"),
            title: "Book in a Few Taps",
            description: "Browse our autopark, review specs like fuel consumption, and instantly select your rental dates."
        ),
        OnboardingStep(
            type: .systemIcon(name: "checkmark.seal.fill"),
            title: "Track Your Bookings",
            description: "Keep everything under control. Monitor your reservation statuses directly from your personal profile."
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 50/255, green: 80/255, blue: 40/255),
                    Color(red: 35/255, green: 60/255, blue: 25/255),
                    Color(red: 20/255, green: 40/255, blue: 15/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                TabView(selection: $selectedPage) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        OnboardingPage(step: onboardingSteps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                
                Button(action: {
                    if selectedPage < onboardingSteps.count - 1 {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedPage += 1
                        }
                    } else {
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(selectedPage == onboardingSteps.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                }
            }
        }
    }
}

struct OnboardingPage: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 50)
            
            Group {
                switch step.type {
                case .systemIcon(let name):
                    Image(systemName: name)
                        .font(.system(size: 100))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.white)
                        .shadow(color: .green.opacity(0.5), radius: 20)
                        .frame(height: 150)
                    
                case .assetImage(let name):
                    Image(name)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 180)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .padding(.horizontal, 40)
                }
            }
            .padding(.bottom, 40)
            
            VStack(spacing: 16) {
                Text(step.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                
                Text(step.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 40)
                    .lineSpacing(5)
            }
            
            Spacer(minLength: 30)
        }
    }
}
