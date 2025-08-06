import Foundation

protocol LibraryViewModelDelegate: AnyObject {
    func didLoadPhobias()
    func didFailToLoadPhobias(error: Error)
    func didStartLoading()
    func didFinishLoading()
}

final class LibraryViewModel {
    
    // MARK: - Properties
    weak var delegate: LibraryViewModelDelegate?
    
    private var allPhobias: [Phobia] = []
    private var filteredPhobias: [Phobia] = []
    private var apiCategories: [PhobiaCategory] = []
    private var selectedCategory: String? = nil
    private var searchText: String = ""
    
    // MARK: - Computed Properties
    var phobias: [Phobia] {
        return filteredPhobias
    }
    
    var categories: [String] {
        var categoryNames = ["Tümü"]
        categoryNames.append(contentsOf: apiCategories.map { $0.name })
        return categoryNames
    }
    
    var isLoading: Bool = false {
        didSet {
            if isLoading {
                delegate?.didStartLoading()
            } else {
                delegate?.didFinishLoading()
            }
        }
    }
    
    // MARK: - Public Methods
    func loadPhobias() {
        isLoading = true
        
        Task {
            do {
                let response = try await PhobiaService.shared.getPhobias()
                await MainActor.run {
                    self.allPhobias = response.data.data
                    self.apiCategories = response.data.categories
                    self.filterPhobias()
                    self.isLoading = false
                    self.delegate?.didLoadPhobias()
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.delegate?.didFailToLoadPhobias(error: error)
                }
            }
        }
    }
    
    func filterByCategory(_ category: String?) {
        // "Tümü" veya boş string ise filtreyi temizle
        selectedCategory = (category == "Tümü" || category?.isEmpty == true) ? nil : category
        print("🔍 Filtering by category: '\(category ?? "nil")' -> selectedCategory: '\(selectedCategory ?? "nil")'")
        filterPhobias()
        delegate?.didLoadPhobias()
    }
    
    func searchPhobias(_ text: String) {
        searchText = text
        filterPhobias()
        delegate?.didLoadPhobias()
    }
    
    func getPhobia(at index: Int) -> Phobia? {
        guard index < filteredPhobias.count else { return nil }
        return filteredPhobias[index]
    }
    
    func getPhobiaCount() -> Int {
        return filteredPhobias.count
    }
    
    // MARK: - Private Methods
    private func filterPhobias() {
        let originalCount = allPhobias.count
        filteredPhobias = allPhobias.filter { phobia in
            let matchesCategory = selectedCategory == nil ||
                phobia.categories.contains { $0.name == selectedCategory }
            let matchesSearch = searchText.isEmpty ||
                phobia.name.localizedCaseInsensitiveContains(searchText) ||
                phobia.englishName.localizedCaseInsensitiveContains(searchText)
            
            return matchesCategory && matchesSearch
        }
        print("🔍 Filtered \(originalCount) phobias to \(filteredPhobias.count) (category: '\(selectedCategory ?? "nil")', search: '\(searchText)')")
    }
}
