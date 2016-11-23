import UIKit
import WebKit
import Turbolinks

/*!
 A VisitableViewController which handles NSError and also sets a dismiss button on presented view controllers
 */
class BaseVisitableViewController: Turbolinks.VisitableViewController {
    // Paths to avoid dismiss button: Array containing paths which shouldn't have a close button.
    // Put an URL path here if you want to remove the close button from your view controller
    let pathsToAvoidDismissButton : [String?] = [
    ]

    // Paths to show add recipe button: Array containing paths which should have an "add recipe" button.
    // Put an URL path here if you want to add the "add recipe" button to your view controller
    let pathsToShowAddRecipeButton : [String?] = [
        K.URL.Home.path
    ]

    // MARK: Public
    func scrollToTop() {
        visitableView.webView?.scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        visitableView.webView?.scrollView.scrollsToTop = true
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: Visitable
    override func visitableDidRender() {
        self.title = visitableView.webView?.title
        setupAddRecipe()
    }

    // MARK: setup
    private func setup() {
        setupDismissButton()
        view.backgroundColor = K.Colors.Gray
    }

    // MARK: add recipe
    private func setupAddRecipe() {
        if UserSessionManager.sharedInstance.isUserLogged() && pathsToShowAddRecipeButton.contains({$0 == visitableURL.path}) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named:"ic-pencil"), style: .Plain, target: self, action: #selector(didTouchAddRecipe))
        }
    }

    @objc private func didTouchAddRecipe() {
        let visitable = TurbolinksNavigationController(url: K.URL.AddRecipe)
        presentViewController(visitable, animated: true, completion: nil);
    }

    // MARK: dismiss
    private func setupDismissButton() {
        if isModal() && navigationController?.viewControllers.count == 1 && !pathsToAvoidDismissButton.contains({$0 == visitableURL.path}) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(didTouchCancel))
        }
    }

    @objc private func didTouchCancel() {
        // TODO: improve this code: nowadays the container checks if it is on the sign_out url to reset the tabbar
        // A better solution would be receiving a message from the JS code telling that the user has logout
        if visitableURL.path == K.URL.SignOut.path, let tabbarController = self.presentingViewController as? CustomTabbarViewController {
            tabbarController.resetTabbar()
        }

        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: Error
    func handleError(error: NSError) {
        guard let errorCode = ErrorCode(rawValue: error.code) else {
            printGuardError("Invalid error:", error)
            presentError(.UnknownError)
            return
        }

        switch errorCode {
        case .HTTPFailure:
            guard let statusCode = error.userInfo["statusCode"] as? Int else {
                printGuardError("Invalid status code:", error.userInfo["statusCode"])
                presentError(.UnknownError)
                return
            }
            switch statusCode {
            case 404:
                presentError(.HTTPNotFoundError)
            default:
                presentError(Error(HTTPStatusCode: statusCode))
            }
        case .NetworkFailure:
            presentError(.NetworkError)
        }
    }

    private func presentError(error: Error) {
        errorView.error = error
        view.addSubview(errorView)
        installErrorViewConstraints()
    }

    private lazy var errorView: ErrorView = {
        guard let view = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil)?.first as? ErrorView else {
            self.printGuardError("No nib found")
            return ErrorView()
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        view.retryButton.addTarget(self, action: #selector(retry(_:)), forControlEvents: .TouchUpInside)
        return view
    }()

    private func installErrorViewConstraints() {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
    }

    @objc private func retry(sender: AnyObject) {
        errorView.removeFromSuperview()
        reloadVisitable()
    }
}
