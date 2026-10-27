import SwiftUI

struct RegisterView: View {
    var onSignUp: (_ name: String, _ email: String, _ password: String) -> Void = { _, _, _ in }
    var onSignIn: () -> Void = {}

    @State private var name = ""
    @State private var confirmation = ""
    @State private var validationMessage: String?
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case name
        case email
        case password
        case confirmation
    }

    private let accent = Color(red: 55 / 255, green: 129 / 255, blue: 231 / 255)

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 32)

                    VStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("Let’s get started!")
                            Text("Sign ") + Text("up").foregroundColor(accent)
                        }
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .accessibilityElement(children: .combine)

                        VStack(spacing: 10) {
                            TextField("Name", text: $name, prompt: Text("Name").foregroundStyle(Color(white: 0.4)))
                                .textContentType(.name)
                                .textInputAutocapitalization(.words)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .name)
                                .onSubmit { focusedField = .email }
                                .accessibilityLabel("Name")
                                .modifier(RegisterFieldStyle())

                            TextField("Email", text: $email, prompt: Text("Email").foregroundStyle(Color(white: 0.4)))
                                .keyboardType(.emailAddress)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .focused($focusedField, equals: .email)
                                .onSubmit { focusedField = .password }
                                .accessibilityLabel("Email")
                                .modifier(RegisterFieldStyle())

                            SecureField("Enter password", text: $password, prompt: Text("Enter password").foregroundStyle(Color(white: 0.4)))
                                .textContentType(.newPassword)
                                .submitLabel(.next)
                                .focused($focusedField, equals: .password)
                                .onSubmit { focusedField = .confirmation }
                                .accessibilityLabel("Password")
                                .modifier(RegisterFieldStyle())

                            SecureField("Confirm password", text: $confirmation, prompt: Text("Confirm password").foregroundStyle(Color(white: 0.4)))
                                .textContentType(.newPassword)
                                .submitLabel(.go)
                                .focused($focusedField, equals: .confirmation)
                                .onSubmit(signUp)
                                .accessibilityLabel("Confirm password")
                                .modifier(RegisterFieldStyle())

                            if let validationMessage {
                                Text(validationMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button(action: signUp) {
                                Text("Sign up")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(minHeight: 44)
                                    .background(
                                        LinearGradient(
                                            colors: [accent, Color(red: 32 / 255, green: 69 / 255, blue: 117 / 255)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        in: RoundedRectangle(cornerRadius: 16)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .frame(maxWidth: 420)

                    Spacer(minLength: 32)

                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 4) {
                            Text("Already registered?")
                            signInButton
                        }
                        VStack(spacing: 4) {
                            Text("Already registered?")
                            signInButton
                        }
                    }
                    .font(.system(size: 16))
                }
                .padding(.horizontal, 24)
                .padding(.top, 64)
                .padding(.bottom, 24)
                .frame(maxWidth: .infinity)
                .frame(minHeight: geometry.size.height)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
        }
        .foregroundStyle(.black)
        .background(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255).ignoresSafeArea())
        .preferredColorScheme(.light)
    }

    private var signInButton: some View {
        Button("Sign in", action: onSignIn)
            .foregroundStyle(accent)
            .buttonStyle(.plain)
            .frame(minHeight: 44)
    }

    private func signUp() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !trimmedEmail.isEmpty,
              !password.isEmpty, !confirmation.isEmpty else {
            validationMessage = "Please fill in all fields."
            return
        }
        guard password == confirmation else {
            validationMessage = "Passwords don’t match."
            focusedField = .confirmation
            return
        }
        validationMessage = nil
        focusedField = nil
        onSignUp(trimmedName, trimmedEmail, password)
    }
}

private struct RegisterFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .padding(.horizontal, 12)
            .frame(minHeight: 44)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    RegisterView()
}
