import SwiftUI

struct LoginView: View {
    var isLoading = false
    var errorMessage: String?
    var onSignIn: (_ email: String, _ password: String) -> Void = { _, _ in }
    var onSignUp: () -> Void = {}

    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?

    private enum Field: Hashable {
        case email
        case password
    }

    private let accent = Color(red: 55 / 255, green: 129 / 255, blue: 231 / 255)

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 32)

                    VStack(spacing: 20) {
                        VStack(spacing: 4) {
                            Text("Welcome back!")
                            Text("Sign \(Text("in").foregroundStyle(accent))")
                        }
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .accessibilityElement(children: .combine)

                        VStack(spacing: 10) {
                            TextField("Email", text: $email, prompt: Text("Email").foregroundStyle(Color(white: 0.4)))
                                .keyboardType(.emailAddress)
                                .textContentType(.username)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .submitLabel(.next)
                                .focused($focusedField, equals: .email)
                                .onSubmit { focusedField = .password }
                                .accessibilityLabel("Email")
                                .modifier(LoginFieldStyle())

                            SecureField("Password", text: $password, prompt: Text("Password").foregroundStyle(Color(white: 0.4)))
                                .textContentType(.password)
                                .submitLabel(.go)
                                .focused($focusedField, equals: .password)
                                .onSubmit(signIn)
                                .accessibilityLabel("Password")
                                .modifier(LoginFieldStyle())

                            if let errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }

                            Button(action: signIn) {
                                Text("Sign in")
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
                            .brightness(isLoading ? -0.12 : 0)
                        }
                        .disabled(isLoading)
                    }
                    .frame(maxWidth: 420)

                    Spacer(minLength: 32)

                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 4) {
                            Text("Not registered?")
                            signUpButton
                        }
                        VStack(spacing: 4) {
                            Text("Not registered?")
                            signUpButton
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

    private var signUpButton: some View {
        Button("Sign up", action: onSignUp)
            .foregroundStyle(accent)
            .buttonStyle(.plain)
            .frame(minHeight: 44)
            .disabled(isLoading)
    }

    private func signIn() {
        guard !isLoading else { return }
        focusedField = nil
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        onSignIn(trimmedEmail, password)
    }
}

private struct LoginFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16))
            .padding(.horizontal, 12)
            .frame(minHeight: 44)
            .background(.white, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    LoginView()
}
