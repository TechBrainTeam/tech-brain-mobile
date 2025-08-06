//
//  LoginViewModel.swift
//  FobiniYen
//
//  Created by Serhat Şimşek on 2.08.2025.
//

import Foundation

// MARK: - Login View Model Delegate
protocol LoginViewModelDelegate: AnyObject {
    func loginViewModelDidStartLoading()
    func loginViewModelDidStopLoading()
    func loginViewModelDidLoginSuccessfully()
    func loginViewModelDidFailWithError(_ message: String)
}

// MARK: - Login View Model
final class LoginViewModel {
    
    // MARK: - Properties
    weak var delegate: LoginViewModelDelegate?
    private let authService: AuthServiceProtocol
    
    // MARK: - Input Properties
    var email: String = ""
    var password: String = ""
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService.shared) {
        self.authService = authService
    }
    
    // MARK: - Public Methods
    func login() {
        guard validateInputs() else { return }
        
        delegate?.loginViewModelDidStartLoading()
        
        Task {
            do {
                let response = try await authService.login(
                    emailOrUsername: email.trimmingCharacters(in: .whitespacesAndNewlines),
                    password: password
                )
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidLoginSuccessfully()
                }
                
            } catch NetworkError.validationError(let message) {
                print("❌ Validation error: \(message)")
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidFailWithError(message)
                }
            } catch NetworkError.unauthorized {
                print("❌ Unauthorized error")
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidFailWithError("E-posta veya şifre hatalı")
                }
            } catch NetworkError.noInternetConnection {
                print("❌ No internet connection")
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidFailWithError("İnternet bağlantınızı kontrol edin")
                }
            } catch NetworkError.serverError {
                print("❌ Server error")
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidFailWithError("Sunucu hatası, lütfen tekrar deneyin")
                }
            } catch {
                print("❌ Unknown error: \(error)")
                print("❌ Error type: \(type(of: error))")
                await MainActor.run {
                    delegate?.loginViewModelDidStopLoading()
                    delegate?.loginViewModelDidFailWithError("Hata: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func isLoggedIn() -> Bool {
        return authService.isLoggedIn()
    }
    
    // MARK: - Private Methods
    private func validateInputs() -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedEmail.isEmpty else {
            delegate?.loginViewModelDidFailWithError("E-posta adresini giriniz")
            return false
        }
        
        guard !password.isEmpty else {
            delegate?.loginViewModelDidFailWithError("Şifrenizi giriniz")
            return false
        }
        
        guard password.count >= 6 else {
            delegate?.loginViewModelDidFailWithError("Şifre en az 6 karakter olmalıdır")
            return false
        }
        
        return true
    }
}
