import SwiftUI

struct EditCustomerView: View {
    @State private var customer: Customer
    var onSave: (Customer) -> Void

    init(customer: Customer, onSave: @escaping (Customer) -> Void) {
        self._customer = State(initialValue: customer)
        self.onSave = onSave
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Details")) {
                    TextField("Name", text: $customer.displayName)
                    TextField("Business Name", text: $customer.businessName)
                    TextField("Email", text: Binding($customer.emailAddress, default: ""))
                    TextField("Phone", text: Binding($customer.phone, default: ""))
                }
            }
            .navigationTitle("Edit Customer")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(customer)
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // Dismiss the sheet
                    }
                }
            }
        }
    }
}

extension Binding {
    init<T>(_ source: Binding<T?>, default defaultValue: T) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { source.wrappedValue = $0 }
        )
    }
}
