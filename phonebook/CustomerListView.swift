import SwiftUI

struct CustomerListView: View {
    @State private var customers: [Customer] = []
    @State private var searchText: String = ""
    @State private var displayedCustomers: [Customer] = []
    @State private var isLoading: Bool = false
    @State private var currentPage: Int = 0
    @State private var editingCustomer: Customer? = nil // Track the customer being edited
    private let pageSize: Int = 20

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, onSearch: filterCustomers)
                List {
                    ForEach(displayedCustomers) { customer in
                        NavigationLink(destination: CustomerDetailView(customer: customer)) {
                            VStack(alignment: .leading) {
                                Text(customer.displayName)
                                    .font(.headline)
                                Text(customer.locations.first?.city ?? "Unknown City")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                if !customer.locationErrors.isEmpty {
                                    Image(systemName: "exclamationmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                            .opacity(customer.isActive ? 1.0 : 0.5) // Grayed out if inactive
                        }
                        .swipeActions(edge: .trailing) {
                            Button(customer.isActive ? "Deactivate" : "Activate") {
                                toggleCustomerActiveState(customer)
                            }
                            .tint(.blue)
                            Button("Delete") {
                                deleteCustomer(customer)
                            }
                            .tint(.red)
                            Button("Edit") {
                                editingCustomer = customer // Set the customer to be edited
                            }
                            .tint(.green)
                        }
                    }
                    if isLoading {
                        ProgressView()
                            .onAppear(perform: loadMoreCustomers)
                    }
                }
            }
            .navigationTitle("Customers")
            .onAppear(perform: loadCustomers)
            .sheet(item: $editingCustomer) { customer in
                EditCustomerView(customer: customer, onSave: { updatedCustomer in
                    updateCustomer(updatedCustomer)
                })
            }
        }
    }

    private func loadCustomers() {
        if let url = Bundle.main.url(forResource: "customerSample", withExtension: "json"),
           let data = try? Data(contentsOf: url),
           let decoded = try? JSONDecoder().decode(CustomerData.self, from: data) {
            customers = decoded.customer
            displayedCustomers = Array(customers.prefix(pageSize))
        }
    }

    private func loadMoreCustomers() {
        guard !isLoading else { return }
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let startIndex = self.currentPage * self.pageSize
            let endIndex = min(startIndex + self.pageSize, self.customers.count)
            if startIndex < endIndex {
                self.displayedCustomers.append(contentsOf: self.customers[startIndex..<endIndex])
                self.currentPage += 1
            }
            self.isLoading = false
        }
    }

    private func filterCustomers() {
        if searchText.isEmpty {
            displayedCustomers = Array(customers.prefix(pageSize))
        } else {
            displayedCustomers = customers.filter {
                $0.displayName.localizedCaseInsensitiveContains(searchText) ||
                $0.locations.first?.city.localizedCaseInsensitiveContains(searchText) == true
            }
        }
    }

    private func toggleCustomerActiveState(_ customer: Customer) {
        if let index = customers.firstIndex(where: { $0.id == customer.id }) {
            customers[index].isActive.toggle()
            filterCustomers()
        }
    }

    private func deleteCustomer(_ customer: Customer) {
        customers.removeAll { $0.id == customer.id }
        filterCustomers()
    }

    private func updateCustomer(_ updatedCustomer: Customer) {
        if let index = customers.firstIndex(where: { $0.id == updatedCustomer.id }) {
            customers[index] = updatedCustomer
            filterCustomers()
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search by name or city", text: $text, onEditingChanged: { _ in }, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            Button(action: onSearch) {
                Text("Search")
            }
            .padding(.trailing)
        }
    }
}
