//
//  StarWarsAnimatedTransitioning.swift
//
//  Created by Ivan Konov on 12/18/14.
//  Copyright (c) 2014 Ivan Konov. All rights reserved.
//

import UIKit

enum StarWarsTransitionDirection: Int {
    case Right
    case Left
    case Up
    case Down
}

enum StarWarsOperation: Int {
    case Present
    case Dismiss
}

class StarWarsAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    var duration: NSTimeInterval = 0.65

    var transitionOperation: StarWarsOperation = .Present
    var transitionDirection: StarWarsTransitionDirection = .Right
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        
        let containerView = transitionContext.containerView()
        
        var animatedLayer: CALayer!
        
        if transitionOperation == .Present {
            animatedLayer = toController?.view.layer
            
            containerView.addSubview(toController!.view)
        }
        else {
            animatedLayer = fromController!.view.layer
        }
        
        setUpAnimationWithLayer(animatedLayer!) {
            if self.transitionOperation == .Dismiss {
                fromController!.view.removeFromSuperview()
            }
            
            transitionContext.completeTransition(true)
        }
    }
    
    private func setUpAnimationWithLayer(layer: CALayer, completion: () -> Void) {
        let maskLayer = CALayer()
        maskLayer.backgroundColor = UIColor.whiteColor().CGColor // the actual color is isrrelevant; all we need is the alpha channel
        layer.mask = maskLayer
        
        let (initalFrame, finalPosition) = maskFrameAndPositionForLayer(layer)
        
        maskLayer.frame = initalFrame
        
        performTransitionWithLayer(layer, finalPosition: finalPosition, completion: completion)
    }
    
    private func maskFrameAndPositionForLayer(layer: CALayer) -> (CGRect, CGPoint){
        var initialMaskFrame: CGRect!
        var finalPosition: CGPoint!
        
        switch transitionDirection {
        case .Right:
            if transitionOperation == .Present {
                initialMaskFrame = layer.bounds
                initialMaskFrame.origin.x -= CGRectGetWidth(initialMaskFrame)
                
                finalPosition = layer.position
            }
            else {
                initialMaskFrame = layer.bounds
                
                finalPosition = layer.position
                finalPosition.x += CGRectGetWidth(layer.bounds)
            }
        case .Left:
            if transitionOperation == .Present {
                initialMaskFrame = layer.bounds
                initialMaskFrame.origin.x += CGRectGetWidth(initialMaskFrame)
                
                finalPosition = layer.position
            }
            else {
                initialMaskFrame = layer.bounds
                
                finalPosition = layer.position
                finalPosition.x -= CGRectGetWidth(layer.bounds)
            }
        case .Up:
            if transitionOperation == .Present {
                initialMaskFrame = layer.bounds
                initialMaskFrame.origin.y += CGRectGetHeight(layer.bounds)
                
                finalPosition = layer.position
            }
            else {
                initialMaskFrame = layer.bounds
                
                finalPosition = layer.position
                finalPosition.y -= CGRectGetHeight(layer.bounds)
            }
        case .Down:
            if transitionOperation == .Present {
                initialMaskFrame = layer.bounds
                initialMaskFrame.origin.y -= CGRectGetHeight(layer.bounds)
                
                finalPosition = layer.position
            }
            else {
                initialMaskFrame = layer.bounds
                
                finalPosition = layer.position
                finalPosition.y += CGRectGetHeight(layer.bounds)
            }
        }
        
        return (initialMaskFrame, finalPosition)
    }
    
    private func performTransitionWithLayer(layer: CALayer, finalPosition: CGPoint, completion: () -> Void) {
        CATransaction.setCompletionBlock {
            // make sure the screen will not blink due to mask layer going back to it's position set in the model
            layer.mask.position = finalPosition
            
            // clean up
            layer.mask = nil
            
            completion()
        }
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.toValue = NSValue(CGPoint: finalPosition)
        
        layer.mask.addAnimation(animation, forKey: "position")
    }
}