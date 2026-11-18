import SwiftUI

struct Hero: View {
    @Binding var searchText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Little Lemon")
                .font(.llDisplay)
                .foregroundStyle(Color.llPrimaryYellow)

            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Chicago")
                        .font(.llSubtitle)
                        .foregroundStyle(.white)
                    Text("We are a family-owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .font(.llBody)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.llSecondaryPeach)
                    .frame(width: 130, height: 130)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.system(size: 40))
                            .foregroundStyle(Color.llCharcoal)
                    )
                    .accessibilityHidden(true)
            }

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.llCharcoal)
                TextField("Search menu", text: $searchText)
                    .foregroundStyle(Color.llCharcoal)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.search)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.llCharcoal.opacity(0.6))
                            .padding(6)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.llLightGray)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .background(Color.llPrimaryGreen)
    }
}
