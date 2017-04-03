//
//  SearchViewController.swift
//  Sos
//
//  Created by MasterApp on 9/7/16.
//  Copyright © 2016 MasterApp. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var instructions: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }

    // MARK: setup
    private func setup() {
        title = NSLocalizedString("SearchViewController.title", comment: "")
        view.backgroundColor = K.Colors.Gray

        instructions.text = NSLocalizedString("SearchViewController.hint", comment: "")
        instructions.font = K.Font.Body
        searchBar.delegate = self

        addGestureRecognizer()
    }

    // MARK: UIGestureRecognizer
    private func addGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapView))
        view.addGestureRecognizer(gesture)
    }

    @objc private func didTapView(gestureRecognizer: UIGestureRecognizer)  {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        performSearchForQuery(searchBar.text ?? "")
        searchBar.text = ""
    }


    // MARK: public
    // This method provides the search function
    func performSearchForQuery(query: String) {
        guard let
            container = navigationController as? TurbolinksNavigationController
            else {
                printGuardError("Can't execute search")
                return
        }

        let searchQuery = query.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let escapedQuery = searchQuery.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()) ?? searchQuery
        let searchUrlString = K.URL.Search.absoluteString ?? ""
        let url = NSURL(string:searchUrlString + escapedQuery) ?? NSURL()

        container.visit(url)
    }
}
