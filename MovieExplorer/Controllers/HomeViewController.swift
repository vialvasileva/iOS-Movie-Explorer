import UIKit

final class HomeViewController: UIViewController {

    private var sections: [MovieSection] = [

        .init(title: "Action", query: "Action", movies: []),
        .init(title: "Sci-Fi", query: "Sci-Fi", movies: []),
        .init(title: "Fantasy", query: "Fantasy", movies: []),
        .init(title: "Romance", query: "Romance", movies: []),
        .init(title: "Comedy", query: "Comedy", movies: []),
        .init(title: "Drama", query: "Drama", movies: []),
        .init(title: "Horror", query: "Horror", movies: []),
        .init(title: "Thriller", query: "Thriller", movies: []),
        .init(title: "Adventure", query: "Adventure", movies: []),
        .init(title: "Family", query: "Family", movies: [])
    ]

    private let tableView: UITableView = {

        let tv = UITableView(
            frame: .zero,
            style: .plain
        )

        tv.translatesAutoresizingMaskIntoConstraints = false

        tv.separatorStyle = .none
        tv.backgroundColor = .systemBackground

        tv.register(
            MovieSectionCell.self,
            forCellReuseIdentifier: MovieSectionCell.identifier
        )

        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Movie Explorer"

        view.backgroundColor = .systemBackground

        setupTableView()
        loadSections()
    }

    private func setupTableView() {

        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            )
        ])
    }

    private func loadSections() {

        Task {

            for index in sections.indices {

                do {

                    let movies = try await APIService.shared.searchMovies(
                        query: sections[index].query
                    )

                    let sortedMovies = movies.sorted {
                        $0.releaseYear > $1.releaseYear
                    }

                    sections[index].movies = Array(
                        sortedMovies.prefix(12)
                    )

                    await MainActor.run {

                        tableView.reloadData()
                    }

                } catch {

                    print(error)
                }
            }
        }
    }
}

// MARK: UITableView

extension HomeViewController:
UITableViewDataSource,
UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        sections.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieSectionCell.identifier,
            for: indexPath
        ) as? MovieSectionCell else {

            return UITableViewCell()
        }

        cell.configure(
            section: sections[indexPath.row],
            parent: self
        )

        cell.selectionStyle = .none

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {

        320
    }
}
