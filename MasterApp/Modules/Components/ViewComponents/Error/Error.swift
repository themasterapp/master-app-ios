import UIKit

struct Error {
    static let HTTPNotFoundError = Error(
        title:NSLocalizedString("Error.page_not_found.title", comment: ""),
        message:NSLocalizedString("Error.page_not_found.message", comment: "Error.page_not_found.message") )
    static let NetworkError = Error(
        title: NSLocalizedString("Error.network.title", comment: ""),
        message: NSLocalizedString("Error.network.message", comment: ""))
    static let UnknownError = Error(
        title: NSLocalizedString("Error.unknown.title", comment: ""),
        message: NSLocalizedString("Error.unknown.message", comment: ""))

    let title: String
    let message: String

    init(title: String, message: String) {
        self.title = title
        self.message = message
    }

    init(HTTPStatusCode: Int) {
        self.title = NSLocalizedString("Error.http_status_code.title", comment: "")
        self.message = NSLocalizedString("Error.http_status_code.message", comment: "")
    }
}
