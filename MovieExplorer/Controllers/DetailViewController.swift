import UIKit

final class DetailViewController: UIViewController {

    private let movie: Movie
    private var movieDetail: MovieDetail?

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let posterImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let infoLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(ofSize: 15)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let overviewLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let favoriteButton: UIButton = {

        let button = UIButton(type: .system)

        button.setTitle(
            "Add to Favorites",
            for: .normal
        )

        button.titleLabel?.font = .boldSystemFont(ofSize: 16)

        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    // MARK: - Init

    init(movie: Movie) {

        self.movie = movie

        super.init(
            nibName: nil,
            bundle: nil
        )
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {

        super.viewDidLoad()

        title = "Details"

        view.backgroundColor = .systemBackground

        setupUI()
        configureBasicUI()
        setupActions()
        loadDetails()
        updateFavoriteState()
    }

    // MARK: - Setup

    private func setupUI() {

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(favoriteButton)

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),

            scrollView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),

            scrollView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),

            scrollView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),

            contentView.topAnchor.constraint(
                equalTo: scrollView.topAnchor
            ),

            contentView.leadingAnchor.constraint(
                equalTo: scrollView.leadingAnchor
            ),

            contentView.trailingAnchor.constraint(
                equalTo: scrollView.trailingAnchor
            ),

            contentView.bottomAnchor.constraint(
                equalTo: scrollView.bottomAnchor
            ),

            contentView.widthAnchor.constraint(
                equalTo: scrollView.widthAnchor
            ),

            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 20
            ),

            posterImageView.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),

            posterImageView.widthAnchor.constraint(
                equalToConstant: 180
            ),

            posterImageView.heightAnchor.constraint(
                equalToConstant: 270
            ),

            titleLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor,
                constant: 20
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 20
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -20
            ),

            infoLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 8
            ),

            infoLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            infoLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),

            overviewLabel.topAnchor.constraint(
                equalTo: infoLabel.bottomAnchor,
                constant: 20
            ),

            overviewLabel.leadingAnchor.constraint(
                equalTo: titleLabel.leadingAnchor
            ),

            overviewLabel.trailingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor
            ),

            favoriteButton.topAnchor.constraint(
                equalTo: overviewLabel.bottomAnchor,
                constant: 24
            ),

            favoriteButton.centerXAnchor.constraint(
                equalTo: contentView.centerXAnchor
            ),

            favoriteButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -30
            )
        ])
    }

    private func configureBasicUI() {

        titleLabel.text = movie.title

        infoLabel.text = movie.year

        if movie.poster != "N/A",
           let url = URL(string: movie.poster) {

            ImageLoader.shared.loadImage(
                from: url
            ) { [weak self] image in

                self?.posterImageView.image = image
            }
        }
    }

    private func setupActions() {

        favoriteButton.addTarget(
            self,
            action: #selector(didTapFavorite),
            for: .touchUpInside
        )
    }

    private func loadDetails() {

        Task {

            do {

                let detail = try await APIService.shared.fetchMovie(
                    imdbID: movie.imdbID
                )

                await MainActor.run {

                    self.movieDetail = detail

                    self.infoLabel.text =
                        "\(detail.year) • \(detail.genre ?? "Unknown")"

                    self.overviewLabel.text =
                        detail.plot
                }

            } catch {

                print(error)
            }
        }
    }

    private func updateFavoriteState() {

        let title = FavoritesManager.shared.isFavorite(movie)
            ? "Remove from Favorites"
            : "Add to Favorites"

        favoriteButton.setTitle(
            title,
            for: .normal
        )
    }

    @objc
    private func didTapFavorite() {

        FavoritesManager.shared.toggle(
            movie
        )

        updateFavoriteState()
    }
}
