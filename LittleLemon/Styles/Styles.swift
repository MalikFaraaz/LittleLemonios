import SwiftUI

extension Color {
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let value = UInt64(cleaned, radix: 16) ?? 0
        self.init(
            red: Double((value >> 16) & 0xFF) / 255,
            green: Double((value >> 8) & 0xFF) / 255,
            blue: Double(value & 0xFF) / 255
        )
    }

    static let llPrimaryGreen = Color(hex: "495E57")
    static let llPrimaryYellow = Color(hex: "F4CE14")
    static let llSecondaryPeach = Color(hex: "EE9972")
    static let llLightGray = Color(hex: "EDEFEE")
    static let llCharcoal = Color(hex: "333333")
}

extension Font {
    static let llDisplay = Font.system(size: 40, weight: .bold, design: .serif)
    static let llSubtitle = Font.system(size: 24, design: .serif)
    static let llHeading = Font.system(size: 20, weight: .bold)
    static let llBody = Font.system(size: 16)
    static let llSmall = Font.system(size: 14)
}

struct LLPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.llPrimaryGreen)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct LLSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundStyle(Color.llCharcoal)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.llPrimaryYellow)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct LLOutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color.llCharcoal)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.llCharcoal.opacity(0.6), lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}
