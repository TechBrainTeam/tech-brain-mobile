import UIKit
import SnapKit

class ChatViewController: UIViewController {
    
    // MARK: - Properties
    private let viewModel: ChatViewModel
    weak var coordinator: ChatCoordinator?
    
    // MARK: - UI Elements
    private let tableView = UITableView()
    private let inputContainerView = UIView()
    private let messageTextField = UITextField()
    private let sendButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    // MARK: - Initialization
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupKeyboardHandling()
        setupViewModel()
        viewModel.loadChatHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = viewModel.phobiaDisplayName
        
        // Table View
        view.addSubview(tableView)
        
        // Input Container
        inputContainerView.backgroundColor = .systemGray6
        inputContainerView.layer.cornerRadius = 20
        inputContainerView.layer.borderWidth = 1
        inputContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        view.addSubview(inputContainerView)
        
        // Message Text Field
        messageTextField.placeholder = "Mesajınızı yazın..."
        messageTextField.font = UIFont.systemFont(ofSize: 16)
        messageTextField.delegate = self
        inputContainerView.addSubview(messageTextField)
        
        // Send Button
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.tintColor = .systemBlue
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        inputContainerView.addSubview(sendButton)
        
        // Activity Indicator
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        // Constraints
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(inputContainerView.snp.top).offset(-10)
        }
        
        inputContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.height.equalTo(50)
        }
        
        messageTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.trailing.equalTo(sendButton.snp.leading).offset(-12)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ChatMessageCell.self, forCellReuseIdentifier: "ChatMessageCell")
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    // MARK: - Keyboard Handling
    private func setupKeyboardHandling() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tableView.addGestureRecognizer(tap)
    }
    
    private func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardHeight + 10)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.inputContainerView.snp.updateConstraints { make in
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    private func scrollToBottom(animated: Bool) {
        guard viewModel.messageCount > 0 else { return }
        let indexPath = IndexPath(row: viewModel.messageCount - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
    }
    
    private func scrollToTop(animated: Bool) {
        guard viewModel.messageCount > 0 else { return }
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    // MARK: - Actions
    @objc private func sendButtonTapped() {
        guard let message = messageTextField.text, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        messageTextField.text = ""
        viewModel.sendMessage(message)
    }
}

// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatMessageCell", for: indexPath) as! ChatMessageCell
        if let message = viewModel.getMessage(at: indexPath.row) {
            cell.configure(with: message)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendButtonTapped()
        return true
    }
}

// MARK: - ChatViewModelDelegate
extension ChatViewController: ChatViewModelDelegate {
    func didLoadMessages() {
        tableView.reloadData()
        // İlk yüklemede en son mesajları göster (en altta)
        scrollToBottom(animated: false)
    }
    
    func didSendMessage() {
        tableView.reloadData()
        // Yeni mesaj gönderildiğinde en alta scroll
        scrollToBottom(animated: true)
    }
    
    func didReceiveReply() {
        tableView.reloadData()
        // Bot yanıtı geldiğinde en alta scroll
        scrollToBottom(animated: true)
    }
    
    func didFailToLoadMessages(error: Error) {
        let alert = UIAlertController(
            title: "Hata",
            message: "Sohbet geçmişi yüklenirken bir hata oluştu.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func didFailToSendMessage(error: Error) {
        let alert = UIAlertController(
            title: "Hata",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
    
    func didStartLoading() {
        activityIndicator.startAnimating()
    }
    
    func didFinishLoading() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Chat Message Cell
class ChatMessageCell: UITableViewCell {
    
    private let messageBubbleView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(messageBubbleView)
        messageBubbleView.addSubview(messageLabel)
        messageBubbleView.addSubview(timeLabel)
        
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        
        timeLabel.font = UIFont.systemFont(ofSize: 12)
        timeLabel.textColor = .secondaryLabel
        
        messageBubbleView.layer.cornerRadius = 16
        
        messageBubbleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.width.lessThanOrEqualTo(280)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(timeLabel.snp.top).offset(-4)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configure(with message: ChatMessage) {
        messageLabel.text = message.message
        
        // Tarih formatla
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let date = ISO8601DateFormatter().date(from: message.createdAt) {
            timeLabel.text = formatter.string(from: date)
        } else {
            timeLabel.text = ""
        }
        
        // Kullanıcı mesajı mı bot mesajı mı?
        if message.role == "user" {
            // Kullanıcı mesajı - sağda
            messageBubbleView.backgroundColor = .systemBlue
            messageLabel.textColor = .white
            timeLabel.textColor = .white.withAlphaComponent(0.7)
            
            messageBubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.trailing.equalToSuperview().offset(-16)
                make.width.lessThanOrEqualTo(280)
            }
        } else {
            // Bot mesajı - solda
            messageBubbleView.backgroundColor = .systemGray5
            messageLabel.textColor = .label
            timeLabel.textColor = .secondaryLabel
            
            messageBubbleView.snp.remakeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(-8)
                make.leading.equalToSuperview().offset(16)
                make.width.lessThanOrEqualTo(280)
            }
        }
    }
} 