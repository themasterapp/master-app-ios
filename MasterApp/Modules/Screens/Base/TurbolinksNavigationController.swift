import UIKit
import WebKit
import Turbolinks

/*!
 This is the TurbolinksNavigationController, which contains a Turbolinks Session object
 Use it to push Turbolinks.VisitableViewController
 */
class TurbolinksNavigationController: UINavigationController {
    // URL to be visited
    private var URL : NSURL;

    // whether this view controller should be reloaded or not on viewWillAppear.
    private var shouldReloadOnAppear : Bool = false;

    private lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()

    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addScriptMessageHandler(self, name: K.Session.ScriptMessageHandler.MasterApp)
        configuration.processPool = AppDelegate.webViewProcessPool
        configuration.applicationNameForUserAgent = K.Session.UserAgent
        return configuration
    }()

    // MARK: public
    func visit(URL: NSURL) {
        showVisitableForSession(session, URL: URL)
    }

    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        self.URL = NSURL();
        super.init(coder: aDecoder)
    }

    init(url: NSURL) {
        self.URL = url;
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        addNotificationCenterObservers()
        showVisitableForSession(session, URL: URL)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if shouldReloadOnAppear {
            session.reload()
            shouldReloadOnAppear = false
        }
    }

    deinit {
        removeNotificationCenterObservers()
    }

    // MARK: NSNotificationCenter
    private func addNotificationCenterObservers() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleDismissedForm), name: K.NotificationCenter.hasDismissedForm, object: nil)
    }

    private func removeNotificationCenterObservers() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc private func handleDismissedForm() {
        shouldReloadOnAppear = true
    }

    // MARK: other
    private func showVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        guard let path = URL.path else {
            printGuardError("No path for URL:", URL)
            return
        }

        if path == K.URL.Native.More.path {
            showMoreViewController()
        } else if path == K.URL.Native.Search.path {
            showSearchViewController()
        } else {
            showVisitableViewControllerWithUrl(URL, action: action)
        }
    }

    private func showMoreViewController() {
        let viewController = MoreViewController()
        pushViewController(viewController, animated: true)
    }

    private func showSearchViewController() {
        let viewController = SearchViewController()
        pushViewController(viewController, animated: true)
    }

    private func showVisitableViewControllerWithUrl(URL: NSURL, action: Action) {
        let finalUrl = UrlBuilder(URL: URL).build()
        let visitable : BaseVisitableViewController = BaseVisitableViewController(URL: finalUrl)

        switch action {
        case .Advance:
            pushViewController(visitable, animated: true)
        case .Replace:
            if viewControllers.count == 1 {
                setViewControllers([visitable], animated: false)
            } else {
                popViewControllerAnimated(false)
                pushViewController(visitable, animated: false)
            }
        case .Restore:
            // from the [docs](https://github.com/turbolinks/turbolinks#restoration-visits): 
            // > Restoration visits have an action of restore and Turbolinks reserves them for internal use. You should not attempt to annotate links or invoke Turbolinks.visit with an action of restore.
            break
        }

        session.visit(visitable)
    }
}

extension TurbolinksNavigationController: SessionDelegate {
    func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
        if shouldBeDismissedFromURL(self.URL, toURL:URL) {
            NSNotificationCenter.defaultCenter().postNotificationName(K.NotificationCenter.hasDismissedForm, object: nil)
            dismissViewControllerAnimated(true, completion: {})
            return
        }

        if shouldBePresentedFromURL(self.URL, toURL:URL) {
            presentViewController(URL)
            return
        }

        showVisitableForSession(session, URL: URL, action: action)
    }
    
    func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        guard let visitableViewController = visitable as? BaseVisitableViewController else { return }
        visitableViewController.handleError(error)
    }

    func session(session: Session, openExternalURL URL: NSURL) {
        if #available(iOS 10.0, *) {
            UIApplication.sharedApplication().openURL(URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.sharedApplication().openURL(URL)
        }
    }

    func sessionDidStartRequest(session: Session) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }

    func sessionDidFinishRequest(session: Session) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }

    // Change here if you want a path to be dismissed on a visit proposal
    private func shouldBeDismissedFromURL(fromURL: NSURL, toURL: NSURL) -> Bool {
        return isModal() && (
            (toURL != K.URL.SignUp && toURL != K.URL.ForgotPassword) ||
            (fromURL == K.URL.ForgotPassword && toURL == K.URL.SignIn)
        )
    }

    // Change here if you want a path to be presented on a visit proposal
    private func shouldBePresentedFromURL(fromURL: NSURL, toURL: NSURL) -> Bool {
        guard let toPath = toURL.path else { return false }
        return (toPath.hasPrefix(K.URL.Prefix.Recipe) && toPath.hasSuffix(K.URL.Suffix.Edit)) ||
            (fromURL != K.URL.SignIn && toURL == K.URL.SignUp) ||
            (toURL == K.URL.ForgotPassword) ||
            (toURL == K.URL.SignIn) ||
            (toURL == K.URL.AddRecipe)
    }
}

extension TurbolinksNavigationController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        switch message.name {
        case K.Session.ScriptMessageHandler.MasterApp:
            guard let response = message.body as? [String:AnyObject] else { return }

            if let authToken = response[K.Session.ScriptMessageHandler.ResponseKeys.AuthToken] {
                guard let token = authToken as? String else {return}
                UserSessionManager.sharedInstance.saveAuthToken(token)
                didLogin()
            }

            if let scrollToTop = response[K.Session.ScriptMessageHandler.ResponseKeys.ScrollToTop] as? Bool where scrollToTop {
                guard let vc = topViewController as? BaseVisitableViewController else { return }
                vc.scrollToTop()
            }
        default:
            fatalError("Unexpected message")
        }
    }

    // This method considers that every login is screen is modally presented
    private func didLogin() {
        NSNotificationCenter.defaultCenter().postNotificationName(K.NotificationCenter.hasDismissedForm, object: nil)
        if let tabBarController = presentingViewController as? CustomTabbarViewController {
            tabBarController.resetTabbar()
        }
        dismissViewControllerAnimated(true, completion: {
        })
    }
}

// MARK: extension to presentViewController using URL
extension TurbolinksNavigationController {
    private func presentViewController(URL: NSURL) {
        let finalUrl = UrlBuilder(URL: URL).build()
        let vc = TurbolinksNavigationController(url: finalUrl)
        presentViewController(vc, animated: true, completion: nil)
    }
}

