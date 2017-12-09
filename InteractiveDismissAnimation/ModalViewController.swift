//
//  ModalViewController.swift
//  InteractiveDismissAnimation
//
//  Created by Israel Velazquez on 12/5/17.
//  Copyright © 2017 Israel Velazquez. All rights reserved.
//

import Foundation
import UIKit

class ModalViewController: UIViewController, ModalDraggingController {
    
    @IBOutlet weak var headerView: UIView!
    
    var modalDraggingTransition: ModalDraggingControllerTransition?
    var interactor: Interactor? = Interactor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTransition()
    }
    
    func configureTransition() {
        modalDraggingTransition = ModalDraggingControllerTransition(targetModalDraggingController: self)
        self.transitioningDelegate = modalDraggingTransition
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.headerView.addGestureRecognizer(panGesture)
    }
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        handleModalDraggingPanGesture(sender: sender)
    }
    
}
