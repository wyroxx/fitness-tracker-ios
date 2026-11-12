import SwiftUI

struct ProfileView: View {
    var body: some View {
        List {
            Section("Account") {
                Label("Profile details coming soon", systemImage: "person.crop.circle")
                    .foregroundStyle(.secondary)
            }

            Section("Activity") {
                Label("Training insights coming soon", systemImage: "chart.bar")
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
