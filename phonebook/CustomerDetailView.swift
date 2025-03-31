import SwiftUI

struct CustomerDetailView: View {
    let customer: Customer

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(customer.displayName)
                .font(.largeTitle)
                .bold()
            Text("Business Name: \(customer.businessName)")
            if let email = customer.emailAddress {
                Text("Email: \(email)")
            }
            if let phone = customer.phone {
                Text("Phone: \(phone)")
            }
            Text("Type: \(customer.type)")
            Text("Active: \(customer.isActive ? "Yes" : "No")")
            if let notes = customer.customerNotes {
                Text("Notes: \(notes)")
            }
            Divider()
            Text("Locations:")
                .font(.headline)
            ForEach(customer.locations, id: \.addressLine1) { location in
                VStack(alignment: .leading) {
                    Text(location.addressLine1)
                    Text("\(location.city), \(location.state) \(location.postalCode)")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .navigationTitle("Customer Details")
    }
}
