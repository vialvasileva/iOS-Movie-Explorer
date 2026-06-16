import UIKit

final class MovieSectionCell: UITableViewCell {

    static let identifier = "MovieSectionCell"

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    let moviesCell = HorizontalMoviesCell()

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
        fatalError()
    }

    private func setupUI() {

        backgroundColor = .clear

        moviesCell.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(titleLabel)
        contentView.addSubview(moviesCell)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 12
            ),

            moviesCell.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 12
            ),

            moviesCell.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            moviesCell.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            moviesCell.heightAnchor.constraint(
                equalToConstant: 270
            ),

            moviesCell.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    func configure(
        section: MovieSection,
        parent: UIViewController
    ) {

        titleLabel.text = section.title

        moviesCell.configure(
            movies: section.movies,
            parent: parent
        )
    }
}
