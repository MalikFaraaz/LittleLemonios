import SwiftUI

struct LogoView: View {
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "leaf.fill")
                .font(.system(size: 28))
                .foregroundStyle(Color.llPrimaryYellow)
            Text("LITTLE LEMON")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundStyle(Color.llPrimaryGreen)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Little Lemon")
    }
}

struct Header: View {
    var body: some View {
        ZStack {
            LogoView()
            HStack {
                Spacer()
                NavigationLink {
                    UserProfile()
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundStyle(Color.llPrimaryGreen)
                }
                .accessibilityLabel("User profile")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}
