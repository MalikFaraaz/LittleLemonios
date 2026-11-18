import SwiftUI
import UIKit

struct Onboarding: View {
    @AppStorage(AppKeys.isLoggedIn) private var isLoggedIn = false
    @AppStorage(AppKeys.firstName) private var storedFirstName = ""
    @AppStorage(AppKeys.lastName) private var storedLastName = ""
    @AppStorage(AppKeys.email) private var storedEmail = ""

    @State private var page = 0
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        VStack(spacing: 0) {
            LogoView()
                .padding(.top, 40)
                .padding(.bottom, 16)

            TabView(selection: $page) {
                fieldPage(
                    title: "What is your first name?",
                    placeholder: "First name",
                    text: $firstName,
                    contentType: .givenName
                )
                .tag(0)

                fieldPage(
                    title: "What is your last name?",
                    placeholder: "Last name",
                    text: $lastName,
                    contentType: .familyName
                )
                .tag(1)

                fieldPage(
                    title: "What is your email?",
                    placeholder: "Email",
                    text: $email,
                    isEmail: true,
                    contentType: .emailAddress
                )
                .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button(page < 2 ? "Next" : "Register", action: nextTapped)
                .buttonStyle(LLPrimaryButtonStyle())
                .padding(24)
        }
        .background(Color.white.ignoresSafeArea())
        .alert("Registration", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func fieldPage(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isEmail: Bool = false,
        contentType: UITextContentType? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.llHeading)
                .foregroundStyle(Color.llCharcoal)

            TextField(placeholder, text: text)
                .foregroundStyle(Color.llCharcoal)
                .keyboardType(isEmail ? .emailAddress : .default)
                .textContentType(contentType)
                .textInputAutocapitalization(isEmail ? .never : .words)
                .autocorrectionDisabled()
                .submitLabel(isEmail ? .done : .next)
                .onSubmit(nextTapped)
                .padding()
                .background(Color.llLightGray)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Spacer()
        }
        .padding(24)
    }

    private func nextTapped() {
        if page < 2 {
            withAnimation {
                page += 1
            }
        } else {
            register()
        }
    }

    private func register() {
        let first = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !first.isEmpty else {
            alertMessage = "Please enter your first name."
            withAnimation { page = 0 }
            showAlert = true
            return
        }

        guard !last.isEmpty else {
            alertMessage = "Please enter your last name."
            withAnimation { page = 1 }
            showAlert = true
            return
        }

        guard !mail.isEmpty else {
            alertMessage = "Please enter your email address."
            showAlert = true
            return
        }

        guard AppConfig.isValidEmail(mail) else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        storedFirstName = first
        storedLastName = last
        storedEmail = mail
        isLoggedIn = true
    }
}
