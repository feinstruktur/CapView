//
//  BadgeView.swift
//
//  Created by Sven A. Schmidt <sas@finestructure.co>
//

import UIKit


public class BadgeView: UIView {

    var text: String? = nil
    public var fillColor = UIColor.white
    public var strokeColor = UIColor.darkGray
    public var fontColor = UIColor.darkGray
    public var lineWidth: CGFloat = 2


    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    public init(frame: CGRect, text: String?) {
        self.text = text
        self.lineWidth = {
            let lw = min(frame.size.height, frame.size.width)/10
            if lw > 8 {
                return 8
            } else {
                return lw
            }
        }()

        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }


    override public func draw(_ rect: CGRect) {
        guard let string = self.text else {
            return
        }

        self.fillColor.setFill()
        self.strokeColor.setStroke()

        let insetRect = rect.insetBy(dx: self.lineWidth/2, dy: self.lineWidth/2)
        do { // fill
            UIBezierPath(ovalIn: insetRect).fill()
        }
        do { // border
            let p = UIBezierPath(ovalIn: insetRect)
            p.lineWidth = self.lineWidth
            p.stroke()
        }
        do { // text
            let fontSize = insetRect.height*0.65
            let font = UIFont.boldSystemFont(ofSize: fontSize)
            let attr: [String: Any] = [NSFontAttributeName: font, NSForegroundColorAttributeName: self.fontColor]
            let s = NSAttributedString(string: string, attributes: attr)
            let size = s.boundingRect(with: CGSize(width: 0, height: 0), options: .truncatesLastVisibleLine, context: nil)
            s.draw(at: CGPoint(
                x: self.lineWidth/2 + (insetRect.width - size.width)/2,
                y: self.lineWidth/2 + (insetRect.height - size.height)/2)
            )
        }

    }

}
