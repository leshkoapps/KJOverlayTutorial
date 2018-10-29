//
//  KJOverlayTutorialVC.swift
//  Goody
//
//  Created by Kenji on 29/5/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit


@objc public class KJOverlayTutorialVC: UIViewController {
    
    @objc public var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.8)
  
    @objc public var tutorials: [KJTutorial] = []
    @objc public var currentTutorialIndex = 0
    @objc public var skipButton: UIButton?
  
    @objc lazy public var hintLabel: UILabel = {
        let label = UILabel()
        label.text = "(Tap to continue)"
        return label
    }()
  
    public override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.view.addGestureRecognizer(tap)
    }
  
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
  
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator);
        self.close();
    }
  
    // MARK: - Methods
  
    @objc public func showInViewController(_ viewController: UIViewController) {
        let window: UIWindow? = viewController.view.window
        guard let finalWindow = window else { return }
        
        self.view.frame = finalWindow.bounds
        finalWindow.addSubview(self.view)
        
        //Show skip button when more than two tutorials are available
        if tutorials.count > 1 {
            skipButton = UIButton(frame: CGRect(x: self.view.bounds.size.width - 70, y: 50, width: 60, height: 30))
            skipButton?.setTitle("Skip", for: .normal)
            skipButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
            skipButton?.addTarget(self, action: #selector(closeAllTutorials), for: .touchUpInside)
            if let skipB = skipButton { finalWindow.addSubview(skipB) }
        }
        
        viewController.addChildViewController(self)
        self.didMove(toParentViewController: viewController)
        
        self.currentTutorialIndex = -1
        self.showNextTutorial()
    }
  
    @objc public func closeAllTutorials() {
        if let _ = skipButton {
            skipButton?.isHidden = true
            skipButton = nil
        }
        self.close()
    }
    
    @objc public func close() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
  
    @objc public func handleTapGesture(gesture: UITapGestureRecognizer) {
        self.showNextTutorial()
    }
  
    @objc public func showNextTutorial() {
        currentTutorialIndex += 1
    
        if currentTutorialIndex >= self.tutorials.count {
            self.close()
            return
        }
    
        let tut = self.tutorials[self.currentTutorialIndex]
        self.showTutorial(tut)
    }
  
    @objc public func showTutorial(_ tutorial: KJTutorial) {
    
        // remove old tutorial
        self.view.backgroundColor = UIColor.clear
        for subView in self.view.subviews {
            if subView.tag == 9999 {
                subView.removeFromSuperview()
            }
        }
    
        // config tutorial
        let bgView = UIView(frame: self.view.bounds)
        bgView.tag = 9999
        bgView.backgroundColor = self.overlayColor
    
        // add focus region
        let path = CGMutablePath()
        path.addRect(self.view.bounds)
        path.addRoundedRect(in: tutorial.focusRectangle,
                        cornerWidth: tutorial.focusRectangleCornerRadius,
                        cornerHeight: tutorial.focusRectangleCornerRadius)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillRule = kCAFillRuleEvenOdd
        bgView.clipsToBounds = true
        bgView.layer.mask = maskLayer
    
        let tutView = UIView(frame: self.view.bounds)
        tutView.tag = 9999
        tutView.backgroundColor = UIColor.clear
    
        // add message
        let lblMessage = UILabel()
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.attributedText = tutorial.message
        let fitSize = lblMessage.sizeThatFits(CGSize(width: min(bgView.bounds.size.width-KJTutorial.leftPadding-KJTutorial.rightPadding,240.0),
                                                 height: bgView.bounds.size.height))
        lblMessage.frame.size = fitSize
        lblMessage.center = tutorial.messagePosition
        tutView.addSubview(lblMessage)
    
        // add image
        if let icon = tutorial.icon {
            let imvIcon = UIImageView(frame: tutorial.iconFrame)
            imvIcon.image = icon
            imvIcon.contentMode = .scaleAspectFit
            tutView.addSubview(imvIcon)
        }
    
        if !tutorial.isArrowHidden {
      
            // add arrow line
            
            let fromCenterPoint = lblMessage.frame.centerPoint
            let toCenterPoint = tutorial.focusRectangle.centerPoint
            
            var fromPoint = fromCenterPoint
            var toPoint = toCenterPoint
            
            if toCenterPoint.y<fromCenterPoint.y {
                fromPoint = lblMessage.frame.topCenterPoint.moveY(-5)
                toPoint = tutorial.focusRectangle.bottomCenterPoint.moveY(5)
            }
            else {
                fromPoint = lblMessage.frame.bottomCenterPoint.moveY(5)
                toPoint = tutorial.focusRectangle.topCenterPoint.moveY(-5)
            }
            
            /*
            if toCenterPoint.x<fromCenterPoint.x {
                toPoint = tutorial.focusRectangle.rightCenterPoint.moveX(5)
            }
            else {
                toPoint = tutorial.focusRectangle.leftCenterPoint.moveX(-5)
            }
            */
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = createCurveLinePath(from: fromPoint, to: toPoint)
            lineLayer.strokeColor = UIColor.white.cgColor
            lineLayer.fillColor = nil
            lineLayer.lineWidth = 2.0;
            lineLayer.lineDashPattern = [10, 5, 5, 5]
            tutView.layer.addSublayer(lineLayer)
      
            // add arrow icon
            /*
            let arrowLayer = CAShapeLayer()
            arrowLayer.path = self.createArrowPathWithCurveLine(from: fromPoint, to: toPoint, size: 10.0)
            arrowLayer.strokeColor = UIColor.white.cgColor
            arrowLayer.fillColor = UIColor.white.cgColor
            arrowLayer.lineWidth = 1.0;
            tutView.layer.addSublayer(arrowLayer)
            */
        }
    
        // showing
        bgView.alpha = 0.0
        tutView.alpha = 0.0
        self.view.addSubview(bgView)
        self.view.addSubview(tutView)
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut, animations: {
            bgView.alpha = 1.0
        })
        UIView.animate(withDuration: 0.35, delay: 0.25, options: .curveEaseOut, animations: {
            tutView.alpha = 1.0
        })
        
        // focus animation
        bgView.alpha = 1.0
        let focusAnim = self.createFocusAnimation(outsideRect: self.view.bounds, focusRect: tutorial.focusRectangle, cornerRadius: 4.0, duration: 0.35)
        maskLayer.add(focusAnim, forKey: nil)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        maskLayer.path = path
        CATransaction.commit()
        
        tutView.alpha = 1.0

    }
  
    @objc public func createCurveLinePath(from: CGPoint, to: CGPoint) -> CGPath {
    
        let vector = CGPoint.createVector(from: from, to: to, isUnit: true)
        let perpendVector = CGPoint.createPerpendicularVectorWith(vector: vector)
        let distance = CGFloat(CGPoint.distanceOf(p1: from, p2: to) * 0.085)
        
        let centerPoint = CGPoint(x: (from.x + to.x)/2.0, y: (from.y + to.y)/2.0)
        let controlDirection: CGFloat = from.x <= to.x ? -1 : 1
        let controlPoint = CGPoint(x: centerPoint.x + perpendVector.x * distance,
                                   y: centerPoint.y + perpendVector.y * distance * controlDirection)
        
        let path = CGMutablePath()
        path.move(to: from)
        path.addQuadCurve(to: to, control: controlPoint)
        return path
    }
  
    @objc public func createArrowPathWithCurveLine(from: CGPoint, to: CGPoint, size: CGFloat) -> CGPath {
    
        // vectors
        let vector = CGPoint.createVector(from: from, to: to, isUnit: true)
        
        let controlDirection: CGFloat = from.x <= to.x ? -1 : 1
        let distance = CGFloat(CGPoint.distanceOf(p1: from, p2: to) * 0.00085) * controlDirection
        var fromCurve = CGPoint(x: to.x - vector.x, y: to.y - vector.y)
        fromCurve = CGPoint(x: fromCurve.x + (-vector.y) * distance, y: fromCurve.y + vector.x * distance)
        
        let curveVector = CGPoint.createVector(from: fromCurve, to: to, isUnit: false)
        let reverseVector = CGPoint.createReverseVectorWith(vector: curveVector)
        let perpendVector = CGPoint.createPerpendicularVectorWith(vector: curveVector)
        
        // calculate points
        let centerPoint = CGPoint(x: to.x + reverseVector.x * size,
                                  y: to.y + reverseVector.y * size)
        let leftPoint = CGPoint(x: centerPoint.x - perpendVector.x * size * 0.5,
                                y: centerPoint.y - perpendVector.y * size * 0.5)
        let rightPoint = CGPoint(x: centerPoint.x + perpendVector.x * size * 0.5,
                                 y: centerPoint.y + perpendVector.y * size * 0.5)
        
        // make triangle
        let path = CGMutablePath()
        path.move(to: to)
        path.addLine(to: leftPoint)
        path.addLine(to: rightPoint)
        path.closeSubpath()
        return path
    }
    
    @objc public func createFocusAnimation(outsideRect: CGRect, focusRect: CGRect, cornerRadius: CGFloat, duration: CFTimeInterval) -> CAAnimation {
        
        let duration1 = duration * 0.4
        let duration2 = duration * 0.3
        let duration3 = duration - duration1 - duration2
        let begin1 = 0.0
        let begin2 = begin1 + duration1
        let begin3 = begin2 + duration2
        
        let distance = min(12, min(focusRect.width, focusRect.height) - 8);
        let offset1 = distance
        let offset2 = distance * 0.5
        
        let rect0 = outsideRect
        let rect1 = focusRect.insetBy(dx: offset1, dy: offset1)
        let rect2 = focusRect.insetBy(dx: -offset2, dy: -offset2)
        let rect3 = focusRect
        
        let path0 = CGMutablePath()
        path0.addRect(rect0)
        path0.addRoundedRect(in: rect0, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        
        let path1 = CGMutablePath()
        path1.addRect(rect0)
        path1.addRoundedRect(in: rect1, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        
        let path2 = CGMutablePath()
        path2.addRect(rect0)
        path2.addRoundedRect(in: rect2, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        
        let path3 = CGMutablePath()
        path3.addRect(rect0)
        path3.addRoundedRect(in: rect3, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
        
        let anim1 = createPathAnimation(fromPath: path0, toPath: path1, beginTime: begin1, duration: duration1)
        let anim2 = createPathAnimation(fromPath: path1, toPath: path2, beginTime: begin2, duration: duration2)
        let anim3 = createPathAnimation(fromPath: path2, toPath: path3, beginTime: begin3, duration: duration3)
        
        let anim = CAAnimationGroup()
        anim.duration = duration
        anim.animations = [anim1, anim2, anim3]
        return anim
    }
    
    @objc public func createPathAnimation(fromPath: CGPath, toPath: CGPath, beginTime: CFTimeInterval, duration: CFTimeInterval) -> CABasicAnimation {
        
        let anim = CABasicAnimation(keyPath: "path")
        
        anim.fromValue = fromPath
        anim.toValue = toPath
        anim.beginTime = beginTime
        anim.duration = duration
        
        return anim
    }
  
}


