import SwiftUI

struct OnboardingView: View {
    @Binding var hasSeenOnboarding: Bool
    @State private var selectedPage = 0
    
    // Дані для слайдів
    let onboardingSteps = [
        OnboardingStep(
            imageName: "map.fill",
            title: "Explore the Map",
            description: "Easily locate available cars nearby. Check allowed driving zones and find convenient pickup locations."
        ),
        OnboardingStep(
            imageName: "car.side.fill",
            title: "Book in a Few Taps",
            description: "Browse our autopark, review specs like fuel consumption, and instantly select your rental dates."
        ),
        OnboardingStep(
            imageName: "checkmark.seal.fill",
            title: "Track Your Bookings",
            description: "Keep everything under control. Monitor your reservation statuses directly from your personal profile."
        )
    ]
    
    var body: some View {
        ZStack {
            // Твій фірмовий градієнтний фон
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
            
            VStack {
                // Карусель слайдів
                TabView(selection: $selectedPage) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        OnboardingPage(step: onboardingSteps[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                
                // Кнопка керування
                Button(action: {
                    if selectedPage < onboardingSteps.count - 1 {
                        withAnimation { selectedPage += 1 }
                    } else {
                        // Завершення онбордингу
                        hasSeenOnboarding = true
                    }
                }) {
                    Text(selectedPage == onboardingSteps.count - 1 ? "Get Started" : "Next")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white) // Світла кнопка на темному фоні виглядає стильно
                        .cornerRadius(16)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 50)
                }
            }
        }
    }
}

// MARK: - Допоміжні структури
struct OnboardingStep {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPage: View {
    let step: OnboardingStep
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // Велика іконка з ефектом світіння
            Image(systemName: step.imageName)
                .font(.system(size: 100))
                .symbolRenderingMode(.hierarchical)
                .foregroundColor(.white)
                .shadow(color: .green.opacity(0.5), radius: 20)
            
            VStack(spacing: 16) {
                Text(step.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                
                Text(step.description)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            
            Spacer()
            Spacer()
        }
    }
}
