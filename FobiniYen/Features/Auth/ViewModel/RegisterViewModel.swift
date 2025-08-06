//
//  RegisterViewModel.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Register View Model Delegate
protocol RegisterViewModelDelegate: AnyObject {
    func registerViewModelDidStartLoading()
    func registerViewModelDidStopLoading()
    func registerViewModelDidRegisterSuccessfully()
    func registerViewModelDidFailWithError(_ message: String)
}

// MARK: - Register View Model
final class RegisterViewModel {
    
    // MARK: - Properties
    weak var delegate: RegisterViewModelDelegate?
    private let authService: AuthServiceProtocol
    
    // MARK: - Input Properties
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var username: String = ""
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func register() {
        guard validateInputs() else { return }
        
        print("🚀 Register starting with:")
        print("   - firstName: '\(firstName)'")
        print("   - lastName: '\(lastName)'")
        print("   - email: '\(email)'")
        print("   - username: '\(username)'")
        print("   - password: '\(password)'")
        print("   - confirmPassword: '\(confirmPassword)'")
        delegate?.registerViewModelDidStartLoading()
        
        Task {
            do {
                print("📡 Making register API call...")
                let response = try await authService.register(
                    email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password,
                    confirmPassword: confirmPassword,
                    username: username.trimmingCharacters(in: .whitespacesAndNewlines),
                    firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                    lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                    profileImage: nil
                )
                
                print("✅ Register successful!")
                await MainActor.run {
                    delegate?.registerViewModelDidStopLoading()
                    delegate?.registerViewModelDidRegisterSuccessfully()
                }
                
            } catch NetworkError.validationError(let message) {
                print("❌ Register validation error: \(message)")
                await MainActor.run {
                    delegate?.registerViewModelDidStopLoading()
                    delegate?.registerViewModelDidFailWithError(message)
                }
            } catch NetworkError.noInternetConnection {
                print("❌ Register no internet connection")
                await MainActor.run {
                    delegate?.registerViewModelDidStopLoading()
                    delegate?.registerViewModelDidFailWithError("İnternet bağlantınızı kontrol edin")
                }
            } catch NetworkError.serverError {
                print("❌ Register server error")
                await MainActor.run {
                    delegate?.registerViewModelDidStopLoading()
                    delegate?.registerViewModelDidFailWithError("Sunucu hatası, lütfen tekrar deneyin")
                }
            } catch {
                print("❌ Register unknown error: \(error)")
                print("❌ Register error type: \(type(of: error))")
                await MainActor.run {
                    delegate?.registerViewModelDidStopLoading()
                    delegate?.registerViewModelDidFailWithError("Hata: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateInputs() -> Bool {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedFirstName.isEmpty else {
            delegate?.registerViewModelDidFailWithError("Adınızı giriniz")
            return false
        }
        
        guard !trimmedLastName.isEmpty else {
            delegate?.registerViewModelDidFailWithError("Soyadınızı giriniz")
            return false
        }
        
        guard !trimmedEmail.isEmpty else {
            delegate?.registerViewModelDidFailWithError("E-posta adresini giriniz")
            return false
        }
        
        guard isValidEmail(trimmedEmail) else {
            delegate?.registerViewModelDidFailWithError("Geçerli bir e-posta adresi giriniz")
            return false
        }
        
        guard !trimmedUsername.isEmpty else {
            delegate?.registerViewModelDidFailWithError("Kullanıcı adını giriniz")
            return false
        }
        
        guard trimmedUsername.count >= 3 else {
            delegate?.registerViewModelDidFailWithError("Kullanıcı adı en az 3 karakter olmalıdır")
            return false
        }
        
        guard !password.isEmpty else {
            delegate?.registerViewModelDidFailWithError("Şifrenizi giriniz")
            return false
        }
        
        guard password.count >= 6 else {
            delegate?.registerViewModelDidFailWithError("Şifre en az 6 karakter olmalıdır")
            return false
        }
        
        guard !confirmPassword.isEmpty else {
            delegate?.registerViewModelDidFailWithError("Şifre tekrarını giriniz")
            return false
        }
        
        guard password == confirmPassword else {
            delegate?.registerViewModelDidFailWithError("Şifreler eşleşmiyor")
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}