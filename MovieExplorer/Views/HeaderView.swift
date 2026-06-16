import UIKit

final class HeaderView: UICollectionReusableView {

    static let identifier = "HeaderView"

    // MARK: - UI

    private let titleLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 24,
            weight: .bold
        )

        label.textColor = .label

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let subtitleLabel: UILabel = {

        let label = UILabel()

        label.font = .systemFont(
            ofSize: 14,
            weight: .regular
        )

        label.textColor = .secondaryLabel

        label.numberOfLines = 0

        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {

        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupUI() {

        backgroundColor = .clear

        addSubview(titleLabel)
        addSubview(subtitleLabel)

        NSLayoutConstraint.activate([

            titleLabel.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 8
            ),

            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 12
            ),

            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -12
            ),

            subtitleLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 4
            ),

            subtitleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 12
            ),

            subtitleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -12
            ),

            subtitleLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -8
            )
        ])
    }

    // MARK: - Configure

    func configure(
        title: String,
        subtitle: String? = nil
    ) {

        titleLabel.text = title

        if let subtitle,
           !subtitle.isEmpty {

            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false

        } else {

            subtitleLabel.text = nil
            subtitleLabel.isHidden = true
        }
    }
}
