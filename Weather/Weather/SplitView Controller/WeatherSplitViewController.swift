//
//  WeatherSplitViewController.swift
//  Weather
//
//  Created by Payal Singh on 25/08/21.
//

import UIKit

class WeatherSplitViewController:UISplitViewController,UISplitViewControllerDelegate{
    
    override func viewDidLoad() {
            super.viewDidLoad()
        guard let leftNavController = self.viewControllers.first as? UINavigationController,
          let masterViewController = leftNavController.viewControllers.first as? RootViewController,
          let rightNavController = self.viewControllers.last as? UINavigationController,
          let detailViewController = rightNavController.viewControllers.first as? WeatherDetailViewController
          else { return }

            masterViewController.delegate = detailViewController
            self.delegate = self
            self.preferredDisplayMode = .allVisible
        }

        func splitViewController(
                 _ splitViewController: UISplitViewController,
                 collapseSecondary secondaryViewController: UIViewController,
                 onto primaryViewController: UIViewController) -> Bool {
            // Return true to prevent UIKit from applying its default behavior
            return true
        }

}
