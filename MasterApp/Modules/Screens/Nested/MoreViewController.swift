import UIKit
import Turbolinks

private let CellIdentifier = "CellIdentifier"

enum MoreViewControllerItems : String {
    case AddRecipe = "MoreViewController.add_recipe"
    case Edit = "MoreViewController.edit"
    case Login = "MoreViewController.login"
    case Logout = "MoreViewController.logout"

    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

class MoreViewController: UITableViewController {
    private var tableData : [MoreViewControllerItems] {
        get {
            if UserSessionManager.sharedInstance.isUserLogged() {
                return [
                    .AddRecipe,
                    .Edit,
                    .Logout
                ]
            } else {
                return [
                    .Login,
                ]
            }
        }
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: setup
    private func setup() {
        title = NSLocalizedString("MoreViewController.title", comment: "")
        view.backgroundColor = K.Colors.Gray
        tableView.tableFooterView = UIView()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
    }

    // MARK: UITableViewDelegate and UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath)

        let item = tableData[indexPath.row]
        switch item {
        case .AddRecipe:
            cell.textLabel?.text = NSLocalizedString("MoreViewController.add_recipe", comment: "")
            cell.defaultCellSetup()
        case .Edit:
            cell.textLabel?.text = NSLocalizedString("MoreViewController.edit", comment: "")
            cell.defaultCellSetup()
        case .Login:
            cell.textLabel?.text = NSLocalizedString("MoreViewController.login", comment: "")
            cell.defaultCellSetup()
        case .Logout:
            cell.textLabel?.text = NSLocalizedString("MoreViewController.logout", comment: "")
            cell.destructiveCellSetup()
        }

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = tableData[indexPath.row]
        switch item {
        case .AddRecipe:
            addRecipe()
        case .Edit:
            editUserData()
        case .Login:
            login()
        case .Logout:
            logout()
        }
    }

    // MARK: action
    func addRecipe() {
        let visitable = TurbolinksNavigationController(url: K.URL.AddRecipe)
        presentViewController(visitable, animated: true, completion: nil);
    }

    func editUserData() {
        let visitable = TurbolinksNavigationController(url: K.URL.MyAccount)
        presentViewController(visitable, animated: true, completion: nil);
    }

    func login() {
        let visitable = TurbolinksNavigationController(url: K.URL.SignIn)
        presentViewController(visitable, animated: true, completion: nil);
    }

    func logout() {
        let visitable = TurbolinksNavigationController(url: K.URL.SignOut)
        UserSessionManager.sharedInstance.logout()
        presentViewController(visitable, animated: true, completion: {});
    }
}
