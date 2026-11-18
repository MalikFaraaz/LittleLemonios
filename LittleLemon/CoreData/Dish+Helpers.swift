import Foundation

extension Dish {
    var formattedPrice: String {
        let value = Double(price ?? "") ?? 0
        return String(format: "$%.2f", locale: Locale(identifier: "en_US_POSIX"), value)
    }

    var imageURL: URL? {
        guard let raw = image?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
            return nil
        }

        if raw.lowercased().hasPrefix("http://") || raw.lowercased().hasPrefix("https://") {
            if let directURL = URL(string: raw) {
                return directURL
            }
            if let encoded = raw.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return URL(string: encoded)
            }
            return nil
        }

        let encoded = raw.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? raw
        return URL(string: AppConfig.imageBaseURL + encoded)
    }
}
