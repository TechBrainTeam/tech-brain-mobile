import Foundation

protocol ChatViewModelDelegate: AnyObject {
    func didLoadMessages()
    func didSendMessage()
    func didReceiveReply()
    func didFailToLoadMessages(error: Error)
    func didFailToSendMessage(error: Error)
    func didStartLoading()
    func didFinishLoading()
}

final class ChatViewModel {
    
    // MARK: - Properties
    weak var delegate: ChatViewModelDelegate?
    
    private let userPhobiaId: String
    private let phobiaName: String
    private var messages: [ChatMessage] = []
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                delegate?.didStartLoading()
            } else {
                delegate?.didFinishLoading()
            }
        }
    }
    
    // MARK: - Computed Properties
    var messageCount: Int {
        return messages.count
    }
    
    var phobiaDisplayName: String {
        return "\(phobiaName) Sohbeti"
    }
    
    // MARK: - Initialization
    init(userPhobiaId: String, phobiaName: String) {
        self.userPhobiaId = userPhobiaId
        self.phobiaName = phobiaName
    }
    
    // MARK: - Public Methods
    func loadChatHistory() {
        isLoading = true
        
        Task {
            do {
                let endpoint = APIEndpoint.getChatHistory(userPhobiaId: userPhobiaId, page: 1, limit: 50)
                let response: ChatHistoryResponse = try await NetworkService.shared.request(endpoint, responseType: ChatHistoryResponse.self)
                
                await MainActor.run {
                    // API'den gelen mesajları ters çevir (en son mesaj en aşağıda olacak)
                    self.messages = response.data.reversed()
                    
                    print("📱 Chat History Loaded:")
                    print("   Messages count: \(self.messages.count)")
                    if self.messages.count > 0 {
                        print("   First message: \(self.messages.first?.role ?? "unknown")")
                        print("   Last message: \(self.messages.last?.role ?? "unknown")")
                    }
                    
                    print("📱 Chat History Loaded:")
                    print("   Messages count: \(self.messages.count)")
                    if self.messages.count > 0 {
                        print("   First message: \(self.messages.first?.role ?? "unknown")")
                        print("   Last message: \(self.messages.last?.role ?? "unknown")")
                    }
                    
                    // Eğer hiç mesaj yoksa hoş geldin mesajı ekle
                    if self.messages.isEmpty {
                        let welcomeMessage = ChatMessage(
                            id: UUID().uuidString,
                            role: "model",
                            message: "Merhaba! \(self.phobiaName) ile ilgili konuşmak için buradayım. Size nasıl yardımcı olabilirim?",
                            createdAt: ISO8601DateFormatter().string(from: Date())
                        )
                        self.messages.append(welcomeMessage)
                    }
                    
                    self.isLoading = false
                    self.delegate?.didLoadMessages()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.delegate?.didFailToLoadMessages(error: error)
                }
            }
        }
    }
    
    func sendMessage(_ messageText: String) {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // UI'da kullanıcı mesajını hemen göster
        let userMessage = ChatMessage(
            id: UUID().uuidString,
            role: "user",
            message: messageText,
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
        
        messages.append(userMessage)
        delegate?.didSendMessage()
        
        // Loading state'i başlat
        isLoading = true
        
        // API'ye gönder
        Task {
            do {
                let request = SendMessageRequest(userPhobiaId: userPhobiaId, message: messageText)
                let endpoint = APIEndpoint.sendMessage(request)
                let response: SendMessageResponse = try await NetworkService.shared.request(endpoint, responseType: SendMessageResponse.self)
                
                await MainActor.run {
                    // Bot yanıtını ekle
                    let botMessage = ChatMessage(
                        id: UUID().uuidString,
                        role: "model",
                        message: response.data.reply,
                        createdAt: ISO8601DateFormatter().string(from: Date())
                    )
                    
                    self.messages.append(botMessage)
                    self.isLoading = false
                    self.delegate?.didReceiveReply()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    
                    // AI servisi aşırı yüklenmişse özel mesaj göster
                    if let networkError = error as? NetworkError {
                        switch networkError {
                        case .validationError(let message):
                            if message.contains("overloaded") || message.contains("503") {
                                self.delegate?.didFailToSendMessage(error: NSError(
                                    domain: "ChatError",
                                    code: 503,
                                    userInfo: [NSLocalizedDescriptionKey: "AI servisi şu anda çok yoğun. Lütfen birkaç dakika sonra tekrar deneyin."]
                                ))
                            } else {
                                self.delegate?.didFailToSendMessage(error: error)
                            }
                        default:
                            self.delegate?.didFailToSendMessage(error: error)
                        }
                    } else {
                        self.delegate?.didFailToSendMessage(error: error)
                    }
                }
            }
        }
    }
    
    func getMessage(at index: Int) -> ChatMessage? {
        guard index < messages.count else { return nil }
        return messages[index]
    }
    
    func getAllMessages() -> [ChatMessage] {
        return messages
    }
} 