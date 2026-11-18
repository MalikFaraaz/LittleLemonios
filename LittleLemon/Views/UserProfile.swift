import SwiftUI
import UIKit

struct UserProfile: View {
    @AppStorage(AppKeys.isLoggedIn) private var isLoggedIn = false
    @AppStorage(AppKeys.firstName) private var savedFirstName = ""
    @AppStorage(AppKeys.lastName) private var savedLastName = ""
    @AppStorage(AppKeys.email) private var savedEmail = ""
    @AppStorage(AppKeys.phoneNumber) private var savedPhone = ""
    @AppStorage(AppKeys.orderStatuses) private var savedOrderStatuses = true
    @AppStorage(AppKeys.passwordChanges) private var savedPasswordChanges = true
    @AppStorage(AppKeys.specialOffers) private var savedSpecialOffers = true
    @AppStorage(AppKeys.newsletter) private var savedNewsletter = true

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var orderStatuses = true
    @State private var passwordChanges = true
    @State private var specialOffers = true
    @State private var newsletter = true
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Personal information")
                    .font(.llHeading)
                    .foregroundStyle(Color.llCharcoal)

                HStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundStyle(Color.llPrimaryGreen)
                        .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces))
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.llCharcoal)
                        Text(email)
                            .font(.llSmall)
                            .foregroundStyle(Color.llCharcoal.opacity(0.7))
                    }
                }
                .padding(.vertical, 4)

                ProfileField(title: "First name", text: $firstName, kind: .firstName)
                ProfileField(title: "Last name", text: $lastName, kind: .lastName)
                ProfileField(title: "Email", text: $email, kind: .email)
                ProfileField(title: "Phone number", text: $phone, kind: .phone)

                Text("Email notifications")
                    .font(.llHeading)
                    .foregroundStyle(Color.llCharcoal)
                    .padding(.top, 8)

                CheckboxRow(title: "Order statuses", isOn: $orderStatuses)
                CheckboxRow(title: "Password changes", isOn: $passwordChanges)
                CheckboxRow(title: "Special offers", isOn: $specialOffers)
                CheckboxRow(title: "Newsletter", isOn: $newsletter)

                Button("Log out", action: logOut)
                    .buttonStyle(LLSecondaryButtonStyle())
                    .padding(.top, 16)

                HStack(spacing: 12) {
                    Button("Discard changes", action: loadDrafts)
                        .buttonStyle(LLOutlineButtonStyle())
                    Button("Save changes", action: saveChanges)
                        .buttonStyle(LLPrimaryButtonStyle())
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .background(Color.white)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.visible, for: .navigationBar)
        .onAppear(perform: loadDrafts)
        .alert("Profile", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func loadDrafts() {
        firstName = savedFirstName
        lastName = savedLastName
        email = savedEmail
        phone = savedPhone
        orderStatuses = savedOrderStatuses
        passwordChanges = savedPasswordChanges
        specialOffers = savedSpecialOffers
        newsletter = savedNewsletter
    }

    private func saveChanges() {
        let first = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let last = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let mail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !first.isEmpty, !last.isEmpty, !mail.isEmpty else {
            alertMessage = "First name, last name, and email cannot be empty."
            showAlert = true
            return
        }

        guard AppConfig.isValidEmail(mail) else {
            alertMessage = "Please enter a valid email address."
            showAlert = true
            return
        }

        savedFirstName = first
        savedLastName = last
        savedEmail = mail
        savedPhone = trimmedPhone
        savedOrderStatuses = orderStatuses
        savedPasswordChanges = passwordChanges
        savedSpecialOffers = specialOffers
        savedNewsletter = newsletter

        firstName = first
        lastName = last
        email = mail
        phone = trimmedPhone

        alertMessage = "Your changes have been saved."
        showAlert = true
    }

    private func logOut() {
        isLoggedIn = false
        AppKeys.all.forEach { UserDefaults.standard.removeObject(forKey: $0) }
        PersistenceController.shared.clearDatabase()
    }
}

struct ProfileField: View {
    enum Kind { case firstName, lastName, email, phone }

    let title: String
    @Binding var text: String
    var kind: Kind = .firstName

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.llSmall)
                .foregroundStyle(Color.llCharcoal.opacity(0.7))
            TextField(title, text: $text)
                .foregroundStyle(Color.llCharcoal)
                .keyboardType(keyboardType)
                .textContentType(contentType)
                .textInputAutocapitalization(isNameField ? .words : .never)
                .autocorrectionDisabled()
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.llPrimaryGreen.opacity(0.5), lineWidth: 1)
                )
        }
    }

    private var isNameField: Bool {
        kind == .firstName || kind == .lastName
    }

    private var keyboardType: UIKeyboardType {
        switch kind {
        case .firstName, .lastName: return .default
        case .email: return .emailAddress
        case .phone: return .phonePad
        }
    }

    private var contentType: UITextContentType {
        switch kind {
        case .firstName: return .givenName
        case .lastName: return .familyName
        case .email: return .emailAddress
        case .phone: return .telephoneNumber
        }
    }
}

struct CheckboxRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.llPrimaryGreen)
                Text(title)
                    .font(.llBody)
                    .foregroundStyle(Color.llCharcoal)
                Spacer()
            }
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}
