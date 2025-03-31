import Foundation

struct Customer: Identifiable, Codable {
    let id: String
    let businessName: String
    let displayName: String
    let emailAddress: String?
    let phone: String?
    let type: String
    let isActive: Bool
    let locations: [Location]
    let customerNotes: String?

    enum CodingKeys: String, CodingKey {
        case id = "CustomerId"
        case businessName = "BusinessName"
        case displayName = "DisplayName"
        case emailAddress = "EmailAddress"
        case phone = "Phone"
        case type = "Type"
        case isActive = "IsActive"
        case locations = "Locations"
        case customerNotes = "CustomerNotes"
    }
}

struct Location: Codable {
    let addressLine1: String
    let city: String
    let state: String
    let postalCode: String

    enum CodingKeys: String, CodingKey {
        case addressLine1 = "AddressLine1"
        case city = "City"
        case state = "State"
        case postalCode = "PostalCode"
    }
}

struct CustomerData: Codable {
    let customer: [Customer]
}
