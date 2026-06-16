import UIKit

final class FavoritesViewController: UIViewController {

    private var favorites: [Movie] = []

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            FavoriteTableViewCell.self,
            forCellReuseIdentifier: FavoriteTableViewCell.identifier
        )
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Favorites"
        view.backgroundColor = .systemBackground

        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavorites()
    }

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }

    private func loadFavorites() {

        favorites = FavoritesManager.shared.getFavorites()
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension FavoritesViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        favorites.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FavoriteTableViewCell.identifier,
            for: indexPath
        ) as? FavoriteTableViewCell else {

            return UITableViewCell()
        }

        let movie = favorites[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoritesViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        let movie = favorites[indexPath.row]

        let detailVC = DetailViewController(movie: movie)

        navigationController?.pushViewController(
            detailVC,
            animated: true
        )
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {

        guard editingStyle == .delete else {
            return
        }

        let movie = favorites[indexPath.row]

        FavoritesManager.shared.remove(movie)

        favorites.remove(at: indexPath.row)

        tableView.deleteRows(
            at: [indexPath],
            with: .automatic
        )
    }
}
