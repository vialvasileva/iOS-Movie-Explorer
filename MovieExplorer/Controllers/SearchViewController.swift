import UIKit

final class SearchViewController: UIViewController {

    private var movies: [Movie] = []

    private var searchTask: DispatchWorkItem?

    // MARK: - UI

    private let searchBar: UISearchBar = {

        let searchBar = UISearchBar()

        searchBar.placeholder = "Search movies..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        return searchBar
    }()

    private let collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 12

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )

        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search"
        view.backgroundColor = .systemBackground

        setupUI()
        setupDelegates()
    }

    // MARK: - Setup

    private func setupUI() {

        view.addSubview(searchBar)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([

            searchBar.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            searchBar.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            searchBar.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            collectionView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor
            ),

            collectionView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 12
            ),

            collectionView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -12
            ),

            collectionView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func setupDelegates() {

        searchBar.delegate = self

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    // MARK: - Search

    private func searchMovies(query: String) {

        searchTask?.cancel()

        let task = DispatchWorkItem { [weak self] in

            guard let self else { return }

            Task {

                do {

                    let result = try await APIService.shared.searchMovies(
                        query: query
                    )

                    await MainActor.run {

                        self.movies = result
                        self.collectionView.reloadData()
                    }

                } catch {

                    print("Search error:", error)

                    await MainActor.run {

                        self.movies = []
                        self.collectionView.reloadData()
                    }
                }
            }
        }

        searchTask = task

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.4,
            execute: task
        )
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {

    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String
    ) {

        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !query.isEmpty else {

            movies = []
            collectionView.reloadData()

            return
        }

        searchMovies(query: query)
    }

    func searchBarSearchButtonClicked(
        _ searchBar: UISearchBar
    ) {

        searchBar.resignFirstResponder()
    }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {

        movies.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MovieCollectionViewCell.identifier,
            for: indexPath
        ) as? MovieCollectionViewCell else {

            return UICollectionViewCell()
        }

        let movie = movies[indexPath.item]

        cell.configure(with: movie)

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        let movie = movies[indexPath.item]

        let detailVC = DetailViewController(
            movie: movie
        )

        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SearchViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let width = (collectionView.frame.width - 12) / 2

        return CGSize(
            width: width,
            height: 280
        )
    }
}
