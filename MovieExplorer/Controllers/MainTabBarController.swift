import UIKit
import SwiftUI

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabs()
        setupAppearance()
    }

    // MARK: - Tabs

    private func setupTabs() {

        let homeVC = HomeViewController()
        let searchVC = SearchViewController()
        let favoritesVC = FavoritesViewController()

        let profileVC = UIHostingController(
            rootView: ProfileView()
        )

        let homeNav = UINavigationController(
            rootViewController: homeVC
        )

        let searchNav = UINavigationController(
            rootViewController: searchVC
        )

        let favoritesNav = UINavigationController(
            rootViewController: favoritesVC
        )

        let profileNav = UINavigationController(
            rootViewController: profileVC
        )

        homeNav.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        searchNav.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )

        favoritesNav.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill")
        )

        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )

        viewControllers = [
            homeNav,
            searchNav,
            favoritesNav,
            profileNav
        ]
    }

    // MARK: - Appearance

    private func setupAppearance() {

        let appearance = UITabBarAppearance()

        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = .systemBlue
    }
}
