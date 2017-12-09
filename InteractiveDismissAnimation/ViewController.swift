//
//  ViewController.swift
//  InteractiveDismissAnimation
//
//  Created by Israel Velazquez on 12/5/17.
//  Copyright © 2017 Israel Velazquez. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showView(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModalViewController") as! ModalViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    
}


