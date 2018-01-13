//
//  KJTutorial.swift
//  Goody
//
//  Created by Kenji on 29/5/17.
//  Copyright © 2017 DevLander. All rights reserved.
//

import UIKit

class KJTutorial: NSObject {
  
    enum KJTutorialPosition {
        case top
        case bottom
    }
  
    // MARK: - Configs
  
    @objc static var leftPadding: CGFloat = 20
    @objc static var rightPadding: CGFloat = 20
    @objc static var topPadding: CGFloat = 64
    @objc static var bottomPadding: CGFloat = 64
  
    // MARK: - Props
  
    @objc var focusRectangle: CGRect
    @objc var focusRectangleCornerRadius: CGFloat
    @objc var message: NSAttributedString
    @objc var messagePosition: CGPoint
    @objc var icon: UIImage? = nil
    @objc var iconFrame: CGRect = CGRect.zero
    @objc var isArrowHidden: Bool = false
  
    //MARK: Init
    @objc init(focusRectangle: CGRect, focusRectangleCornerRadius: CGFloat, message: NSAttributedString, messagePosition: CGPoint, icon: UIImage?, iconFrame: CGRect, isArrowHidden: Bool) {
        self.focusRectangle = focusRectangle;
        self.focusRectangleCornerRadius = focusRectangleCornerRadius;
        self.message = message;
        self.messagePosition = messagePosition;
        self.icon = icon  ;
        self.iconFrame=iconFrame;
        self.isArrowHidden=isArrowHidden;
    }
    
    // MARK: - Helpers
  
    static func getMessageFrameAt(position: KJTutorialPosition, message: String, font: UIFont) -> CGRect {
    
        let screenBounds = UIScreen.main.bounds
    
        let size = font.sizeOf(string: message, constrainedToWidth: screenBounds.size.width - leftPadding - rightPadding)
    
        let x = CGFloat(max(leftPadding, (screenBounds.size.width-size.width)/2.0))
    
        var y = screenBounds.size.width/2.0
        switch position {
        case .top:
            y = topPadding
        case .bottom:
            y = screenBounds.size.height - size.height - bottomPadding
        }
    
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
  
    @objc static func textTutorial(focusRectangle: CGRect, text: String, textPosition: CGPoint) -> KJTutorial {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18),
                 NSAttributedStringKey.foregroundColor : UIColor.white]
        let message = NSAttributedString(string: text, attributes: attrs)
        let tutorial = KJTutorial(focusRectangle: focusRectangle, focusRectangleCornerRadius: 4.0, message: message, messagePosition: textPosition, icon: nil, iconFrame: .zero, isArrowHidden: false)
        return tutorial
    }
  
    @objc static func textWithIconTutorial(focusRectangle: CGRect, text: String, textPosition: CGPoint, icon: UIImage, iconFrame: CGRect) -> KJTutorial {
        let attrs = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18),
                 NSAttributedStringKey.foregroundColor : UIColor.white]
        let message = NSAttributedString(string: text, attributes: attrs)
        let tutorial = KJTutorial(focusRectangle: focusRectangle, focusRectangleCornerRadius: 4.0, message: message, messagePosition: textPosition, icon: icon, iconFrame: iconFrame, isArrowHidden: true)
        return tutorial
    }
  
}
