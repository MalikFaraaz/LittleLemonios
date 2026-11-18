import Foundation

enum AppKeys {
    static let isLoggedIn = "kIsLoggedIn"
    static let firstName = "kFirstName"
    static let lastName = "kLastName"
    static let email = "kEmail"
    static let phoneNumber = "kPhoneNumber"
    static let orderStatuses = "kOrderStatuses"
    static let passwordChanges = "kPasswordChanges"
    static let specialOffers = "kSpecialOffers"
    static let newsletter = "kNewsletter"

    static let all: [String] = [
        isLoggedIn, firstName, lastName, email, phoneNumber,
        orderStatuses, passwordChanges, specialOffers, newsletter
    ]
}

enum AppConfig {
    static let menuURL = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
    static let imageBaseURL = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/images/"

    static func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }
}
