import UIKit
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // web view process pool to be shared across all TurbolinksNavigation controller instances
    static let webViewProcessPool = WKProcessPool()

    // MARK: UIApplicationDelegate
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupUIAppearence()

        return true
    }

    // MARK: setup
    private func setupUIAppearence() {
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = K.Colors.Primary
        UINavigationBar.appearance().tintColor = K.Colors.White
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: K.Colors.White]

        UITabBar.appearance().tintColor = K.Colors.Primary
        UITabBar.appearance().translucent = false

        UISearchBar.appearance().translucent = false
        UISearchBar.appearance().barTintColor = K.Colors.Primary
        (UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self])).setTitleTextAttributes([NSForegroundColorAttributeName: K.Colors.White] , forState: .Normal)
    }
}
