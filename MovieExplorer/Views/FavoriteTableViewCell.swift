import UIKit

final class FavoriteTableViewCell: UITableViewCell {

    static let identifier = "FavoriteTableViewCell"

    private var imageLoadID: UUID?

    // MARK: - UI

    private let posterImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        imageView.backgroundColor = .systemGray6

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 16,
            weight: .semibold
        )

        label.numberOfLines = 2

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let yearLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 13,
            weight: .medium
        )

        label.textColor = .secondaryLabel

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Init

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {

        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Reuse

    override func prepareForReuse() {

        super.prepareForReuse()

        if let imageLoadID {
            ImageLoader.shared.cancelLoad(
                imageLoadID
            )
        }

        posterImageView.image = nil
        titleLabel.text = nil
        yearLabel.text = nil
    }

    // MARK: - Setup

    private func setupUI() {

        selectionStyle = .none

        contentView.addSubview(
            posterImageView
        )

        contentView.addSubview(
            titleLabel
        )

        contentView.addSubview(
            yearLabel
        )

        NSLayoutConstraint.activate([

            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),

            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),

            posterImageView.widthAnchor.constraint(
                equalToConstant: 60
            ),

            posterImageView.heightAnchor.constraint(
                equalToConstant: 90
            ),

            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 12
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 12
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),

            yearLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 6
            ),

            yearLabel.leadingAnchor.constraint(
                equalTo: posterImageView.trailingAnchor,
                constant: 12
            ),

            yearLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -12
            ),

            contentView.bottomAnchor.constraint(
                greaterThanOrEqualTo: posterImageView.bottomAnchor,
                constant: 12
            )
        ])
    }

    // MARK: - Configure

    func configure(with movie: Movie) {

        titleLabel.text = movie.title
        yearLabel.text = movie.year

        guard
            movie.poster != "N/A",
            let url = URL(string: movie.poster)
        else {
            return
        }

        imageLoadID = ImageLoader.shared.loadImage(
            from: url
        ) { [weak self] image in

            self?.posterImageView.image = image
        }
    }
}
