import UIKit

final class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier = "MovieCollectionViewCell"

    private var imageLoadID: UUID?

    // MARK: - UI

    private let posterImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        imageView.layer.cornerRadius = 12

        imageView.backgroundColor = .systemGray6

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )

        label.numberOfLines = 2

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let yearLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 12,
            weight: .medium
        )

        label.textColor = .secondaryLabel

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupUI()
        setupAnimation()
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

        backgroundColor = .clear

        contentView.backgroundColor = .secondarySystemBackground

        contentView.layer.cornerRadius = 12

        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.08
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 6

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

            posterImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),

            posterImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            posterImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            posterImageView.heightAnchor.constraint(
                equalToConstant: 200
            ),

            titleLabel.topAnchor.constraint(
                equalTo: posterImageView.bottomAnchor,
                constant: 8
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8
            ),

            yearLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 4
            ),

            yearLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 8
            ),

            yearLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -8
            ),

            yearLabel.bottomAnchor.constraint(
                lessThanOrEqualTo: contentView.bottomAnchor,
                constant: -8
            )
        ])
    }

    // MARK: - Configure

    func configure(with movie: Movie) {

        titleLabel.text = movie.title
        yearLabel.text = movie.year

        if movie.poster != "N/A",
           let url = URL(string: movie.poster) {

            imageLoadID = ImageLoader.shared.loadImage(
                from: url
            ) { [weak self] image in

                self?.posterImageView.image = image
            }
        }

        animateAppearance()
    }

    // MARK: - Animation

    private func setupAnimation() {

        contentView.alpha = 0

        contentView.transform = CGAffineTransform(
            scaleX: 0.95,
            y: 0.95
        )
    }

    private func animateAppearance() {

        UIView.animate(
            withDuration: 0.25
        ) {

            self.contentView.alpha = 1
            self.contentView.transform = .identity
        }
    }
}
