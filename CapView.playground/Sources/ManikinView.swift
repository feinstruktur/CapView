//
//  ManikinView.swift
//
//  Created by Sven A. Schmidt <sas@finestructure.co>
//

import UIKit


extension UIBezierPath {

    // Draw a segment of a circle (as in a pie chart)
    static func segment(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> UIBezierPath {
        let p = UIBezierPath()
        p.move(to: center)
        p.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        p.close()
        return p
    }

}


let π = CGFloat(Double.pi)


public class ManikinView: UIView {

    var color = UIColor.darkGray


    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }


    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    public init(frame: CGRect, color: UIColor) {
        super.init(frame: frame)
        self.color = color
        self.backgroundColor = UIColor.clear
    }


    func drawHead(in rect: CGRect) {
        let w = rect.size.width
        let r = 0.19*w
        let headRect = CGRect(x: w/2 - r, y: 0, width: 2*r, height: 2*r)
        UIBezierPath(ovalIn: headRect).fill()
    }


    func drawTorso(in rect: CGRect) -> CGRect {
        let w = 0.51*rect.size.width
        let h = 0.4*rect.size.height
        let x = (rect.size.width - w)/2
        let y = 0.18*rect.size.height
        let r = CGRect(x: x, y: y, width: w, height: h)
        UIBezierPath(rect: r).fill()
        return r
    }


    func drawShoulders(in rect: CGRect, torsoPos: CGPoint) {
        let r = torsoPos.x
        do { // left
            let center = CGPoint(x: torsoPos.x, y: torsoPos.y + r)
            UIBezierPath.segment(center: center, radius: r, startAngle: π, endAngle: 3*π/2, clockwise: true).fill()
        }
        do { // right
            let center = CGPoint(x: rect.size.width - torsoPos.x, y: torsoPos.y + r)
            UIBezierPath.segment(center: center, radius: r, startAngle: 0, endAngle: 3*π/2, clockwise: false).fill()
        }
    }


    func drawLimb(in rect: CGRect) {
        let w = rect.size.width
        let r = w/2
        let h = rect.size.height - r
        let x = rect.origin.x
        let y = rect.origin.y
        UIBezierPath(rect: CGRect(x: x, y: y, width: w, height: h)).fill()
        let c = CGPoint(x: x + r, y: y + h)
        UIBezierPath.segment(center: c, radius: r, startAngle: 0, endAngle: π, clockwise: true).fill()
    }


    func drawArms(in rect: CGRect, torsoPos: CGPoint) {
        let shoulderRadius = torsoPos.x
        let y = torsoPos.y + shoulderRadius
        let w = 0.16 * rect.size.width
        let h = 0.25 * rect.size.height
        // left
        self.drawLimb(in: CGRect(x: 0, y: y, width: w, height: h))
        // right
        let x = rect.size.width - w
        self.drawLimb(in: CGRect(x: x, y: y, width: w, height: h))
    }


    func drawLegs(in rect: CGRect, torsoRect: CGRect) {
        let x = torsoRect.origin.x
        let y = torsoRect.origin.y + torsoRect.size.height
        let w = 0.21 * rect.size.width
        let h = rect.size.height - y
        self.drawLimb(in: CGRect(x: x, y: y, width: w, height: h))
        let x2 = x + torsoRect.size.width - w
        self.drawLimb(in: CGRect(x: x2, y: y, width: w, height: h))
    }


    override public func draw(_ rect: CGRect) {
        self.color.setFill()
        self.drawHead(in: rect)
        let torsoRect = self.drawTorso(in: rect)
        self.drawShoulders(in: rect, torsoPos: torsoRect.origin)
        self.drawArms(in: rect, torsoPos: torsoRect.origin)
        self.drawLegs(in: rect, torsoRect: torsoRect)
    }
    
}

