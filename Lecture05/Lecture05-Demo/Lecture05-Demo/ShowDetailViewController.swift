//
//  ShowDetailViewController.swift
//  Lecture05-Demo
//
//  Created by 买明 on 03/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class ShowDetailViewController: UIViewController {

    @IBAction func clickBack(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
