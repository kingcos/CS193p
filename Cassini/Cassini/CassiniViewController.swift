//
//  CassiniViewController.swift
//  Cassini
//
//  Created by 买明 on 11/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

class CassiniViewController: UIViewController,
                             UISplitViewControllerDelegate {

    // 设置代理
    override func awakeFromNib() {
        super.awakeFromNib()
        self.splitViewController?.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageVC = segue.destination.contents as? ImageViewController {
                imageVC.imgURL = url
                imageVC.title = (sender as? UIButton)?.currentTitle
            }
        }
    }

    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool {
        if primaryViewController.contents == self {
            if let ivc = secondaryViewController.contents as? ImageViewController,
                   ivc.imgURL == nil  {
                return true
            }
        }
        return false
    }
}
