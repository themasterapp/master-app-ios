//
//  CustomTabbarViewController.swift
//  Sos
//
//  Created by MasterApp on 8/11/16.
//  Copyright © 2016 MasterApp. All rights reserved.
//

import UIKit

/*!
 This TabBarController just setup the tabBar for this app.
 */
class CustomTabbarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let tab1 = TurbolinksNavigationController(url: K.URL.Home);
        tab1.tabBarItem = UITabBarItem.init(title: NSLocalizedString("CustomTabbarViewController.recipe", comment: ""), image: UIImage.init(named: "ic-recipe"), tag: 0);

        let tab2 = TurbolinksNavigationController(url: K.URL.MyRecipes);
        tab2.tabBarItem = UITabBarItem.init(title: NSLocalizedString("CustomTabbarViewController.my_recipe", comment: ""), image: UIImage.init(named: "ic-write"), tag: 1);

        let tab3 = TurbolinksNavigationController(url: K.URL.Native.Search);
        tab3.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.Search, tag: 2);

        let tab4 = TurbolinksNavigationController(url: K.URL.Native.More);
        tab4.tabBarItem = UITabBarItem.init(tabBarSystemItem: UITabBarSystemItem.More, tag: 3);

        self.setViewControllers([tab1, tab2, tab3, tab4], animated: false);
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func resetTabbar() {
        guard let viewControllers = self.viewControllers else {return}
        for vc : UIViewController in viewControllers {
            if let nav = vc as? TurbolinksNavigationController {
                nav.popToRootViewControllerAnimated(false)
                nav.reset()
            }
        }
        let homeIndex = 0
        self.selectedIndex = homeIndex
    }
}
