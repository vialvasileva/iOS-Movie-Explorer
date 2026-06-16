import UIKit

extension UIView {

    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }

    // MARK: - Center

    func centerInSuperview() {

        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }

    // MARK: - Pin edges

    func pinToSuperviewEdges(insets: UIEdgeInsets = .zero) {

        guard let superview = superview else { return }

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

    // MARK: - Size

    func setSize(width: CGFloat, height: CGFloat) {

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    // MARK: - Width / Height

    func setWidth(_ width: CGFloat) {

        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setHeight(_ height: CGFloat) {

        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
