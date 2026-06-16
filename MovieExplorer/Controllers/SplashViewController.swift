import UIKit

final class SplashViewController: UIViewController {

    private let logoImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.image = UIImage(systemName: "film.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleAspectFit

        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupUI()
        startAnimation()
        goToMainScreenAfterDelay()
    }

    // MARK: - Setup

    private func setupUI() {

        view.addSubview(logoImageView)

        NSLayoutConstraint.activate([

            logoImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),

            logoImageView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            logoImageView.widthAnchor.constraint(
                equalToConstant: 120
            ),

            logoImageView.heightAnchor.constraint(
                equalToConstant: 120
            )
        ])
    }

    // MARK: - Animation

    private func startAnimation() {

        logoImageView.alpha = 0

        logoImageView.transform = CGAffineTransform(
            scaleX: 0.6,
            y: 0.6
        )

        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.8,
            options: .curveEaseInOut,
            animations: {

                self.logoImageView.alpha = 1
                self.logoImageView.transform = .identity

            }
        )
    }

    // MARK: - Navigation

    private func goToMainScreenAfterDelay() {

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 2.0
        ) {
            
            let tabBarController = MainTabBarController()

            guard
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first
            else {
                return
            }

            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = tabBarController
                }
            )
        }
    }
}
