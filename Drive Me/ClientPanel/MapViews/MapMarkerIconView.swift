
import SwiftUI

struct MapMarkerIconView: View {
    let color: Color
    let icon: String
    var scale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Image(systemName: "triangle.fill")
                .resizable()
                .frame(width: 12 * scale, height: 9 * scale)
                .rotationEffect(.degrees(180))
                .foregroundStyle(.black.gradient)
                .offset(y: 12 * scale)
            
            Circle()
                .fill(color.gradient)
                .frame(width: 24 * scale, height: 24 * scale)
                .overlay(Circle().stroke(Color.black, lineWidth: 1.5 * scale))
            
            Image(systemName: icon)
                .font(.system(size: 11 * scale, weight: .bold))
                .foregroundColor(.white)
        }
        .frame(width: 24 * scale, height: 32 * scale)
        .shadow(color: .black.opacity(0.3), radius: 2 * scale, x: 0, y: 2 * scale)
    }
}
