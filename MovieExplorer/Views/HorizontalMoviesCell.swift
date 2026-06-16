import UIKit

final class HorizontalMoviesCell: UITableViewCell {

    static let identifier = "HorizontalMoviesCell"

    private var movies: [Movie] = []

    weak var parentViewController: UIViewController?

    private let collectionView: UICollectionView = {

        let layout = UICollectionViewFlowLayout()

        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .clear

        cv.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: MovieCollectionViewCell.identifier
        )

        return cv
    }()

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
        contentView.backgroundColor = .clear

        contentView.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.dataSource = self

        NSLayoutConstraint.activate([

            collectionView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),

            collectionView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            collectionView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            collectionView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            )
        ])
    }

    func configure(
        movies: [Movie],
        parent: UIViewController
    ) {

        self.movies = movies
        self.parentViewController = parent

        collectionView.reloadData()
    }
}

// MARK: UICollectionView

extension HorizontalMoviesCell:
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

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

        cell.configure(with: movies[indexPath.item])

        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        let movie = movies[indexPath.item]

        let vc = DetailViewController(
            movie: movie
        )

        parentViewController?
            .navigationController?
            .pushViewController(
                vc,
                animated: true
            )
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        CGSize(
            width: 150,
            height: 260
        )
    }
}
