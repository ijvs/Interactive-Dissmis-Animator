//
//  DismissAnimator.swift
//  InteractiveDismissAnimation
//
//  Created by Israel Velazquez on 12/5/17.
//  Copyright © 2017 Israel Velazquez. All rights reserved.
//

import Foundation
import UIKit

public protocol ModalDraggingController: class {
    var modalDraggingTransition: ModalDraggingControllerTransition? { get set }
    var interactor: Interactor? { get set }
    func handleModalDraggingPanGesture(sender: UIPanGestureRecognizer)
}

extension ModalDraggingController where Self:UIViewController {
    func handleModalDraggingPanGesture(sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.4
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish ? interactor.finish() : interactor.cancel()
        default:
            break
        }
    }
}

public class ModalDraggingControllerTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    weak public var targetModalDraggingController: ModalDraggingController?
    
    public init(targetModalDraggingController: ModalDraggingController) {
        self.targetModalDraggingController = targetModalDraggingController
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return targetModalDraggingController?.interactor?.hasStarted == true ? targetModalDraggingController?.interactor : nil
    }
}

extension ModalDraggingControllerTransition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        animateOut(using: transitionContext)
    }
    
    func animateOut(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
        animations: {
            fromVC.view.frame = finalFrame
        },completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

public class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}

