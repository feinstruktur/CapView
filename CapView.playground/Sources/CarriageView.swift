//
//  CarriageView.swift
//
//  Created by Sven A. Schmidt <sas@finestructure.co>
//

import UIKit


public func sigmoid(x: Double, L: Double = 1, k: Double = 1, x0: Double = 0) -> Double {
    return L / (1 + exp(-k * (x - x0)))
}


// Compute a scaling factor depending on the height of a view
// The idea is that it's doing an ease-in-out from maxVal to minVal around the given midHeight
// using a sigmoid function.
func scaleForHeight(_ height: CGFloat) -> CGFloat {
    let maxVal = 0.6
    let minVal = 0.3
    let L = maxVal - minVal
    let midHeight = 50.0
    return CGFloat(maxVal - sigmoid(x: Double(height), L: L, k: 0.08, x0: midHeight))
}


public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}


public enum CarriageType: Int {
    case LeftEnd
    case Middle
    case RightEnd
}


func drawCarriageFrame(_ rect: CGRect, lineWidth: CGFloat, cornerRadius: CGFloat, mirror: Bool) {
    let a = 0.35 * rect.height
    let R = cornerRadius
    let r = R/2
    let o = rect.origin
    let w = rect.size.width
    let h = rect.size.height
    let t: (CGFloat) -> (CGFloat) = { x in
        if mirror {
            return w - x
        } else {
            return x
        }
    }

    let l = UIBezierPath()
    l.lineWidth = lineWidth

    let p0 = CGPoint(x: t(r/sqrt(2)), y: a - r/sqrt(2)) + o
    l.move(to: p0)

    let p1 = CGPoint(x: t(a - r/sqrt(2)), y: r/sqrt(2)) + o
    let p2 = CGPoint(x: t(a + r), y: 0) + o
    let c1 = CGPoint(x: t(a), y: 0) + o
    l.addLine(to: p1)
    l.addQuadCurve(to: p2, controlPoint: c1)

    let p3 = CGPoint(x: t(w - R), y: 0) + o
    l.addLine(to: p3)

    let p4 = CGPoint(x: t(w), y: R) + o
    let c2 = CGPoint(x: t(w), y: 0) + o
    l.addQuadCurve(to: p4, controlPoint: c2)

    let p5 = CGPoint(x: t(w), y: h - R) + o
    l.addLine(to: p5)

    let p6 = CGPoint(x: t(w - R), y: h) + o
    let c3 = CGPoint(x: t(w), y: h) + o
    l.addQuadCurve(to: p6, controlPoint: c3)

    let p7 = CGPoint(x: t(R), y: h) + o
    l.addLine(to: p7)

    let p8 = CGPoint(x: t(0), y: h - R) + o
    let c4 = CGPoint(x: t(0), y: h) + o
    l.addQuadCurve(to: p8, controlPoint: c4)

    let p9 = CGPoint(x: t(0), y: a + r) + o
    l.addLine(to: p9)

    let c5 = CGPoint(x: t(0), y: a) + o
    l.addQuadCurve(to: p0, controlPoint: c5)

    l.stroke()
}


public class CarriageView: UIView {

    var load = 0.0
    var carriageNumber: Int? = nil
    var carriageType: CarriageType = .Middle

    var lineWidth: CGFloat = 8
    var cornerRadius: CGFloat = 16
    var fillColor = UIColor.clear
    var strokeColor = UIColor.darkGray

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    public init(frame: CGRect, load: Double, carriageNumber: Int? = nil, carriageType: CarriageType = .Middle) {
        self.load = load
        self.carriageNumber = carriageNumber
        self.carriageType = carriageType
        self.cornerRadius = frame.size.height * 0.17
        self.lineWidth = frame.size.height * 0.04
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }


    override public func draw(_ rect: CGRect) {
        self.fillColor.setFill()
        self.strokeColor.setStroke()

        let padding = self.lineWidth * 1.8
        let innerRect = rect.insetBy(dx: padding, dy: padding)

        // carriage frame
        switch self.carriageType {
        case .Middle:
            let p = UIBezierPath(roundedRect: innerRect, cornerRadius: cornerRadius)
            p.lineWidth = self.lineWidth
            p.stroke()
        case .LeftEnd:
            drawCarriageFrame(innerRect, lineWidth: self.lineWidth, cornerRadius: self.cornerRadius, mirror: false)
        case .RightEnd:
            drawCarriageFrame(innerRect, lineWidth: self.lineWidth, cornerRadius: self.cornerRadius, mirror: true)
        }

        // manikin views
        let level = LoadLevel(value: self.load)
        for i in 0..<(level?.rawValue ?? 0) {
            let xSpacing = padding
            let ySpacing = 1.5*padding
            let manikinWidth = (innerRect.width - 4*padding)/5 - xSpacing
            let frame = CGRect(
                x: 3*padding + (CGFloat(i) + 0.5)*xSpacing + CGFloat(i)*manikinWidth,
                y: padding + ySpacing,
                width: manikinWidth, height: innerRect.height - 2*ySpacing
            )
            let m = ManikinView(frame: frame)
            self.addSubview(m)
        }

        // carriage number badge
        if let carriageNumber = self.carriageNumber {
            let size = rect.height * scaleForHeight(rect.height)
            let frame = CGRect(
                x: rect.width - size, y: rect.height - size,
                width: size, height: size
            )
            let b = BadgeView(frame: frame, text: "\(carriageNumber)")
            let color = LoadLevel.color(load: load)
            b.fillColor = color
            if load > 0.8 {
                b.fontColor = UIColor.white
            }
            self.addSubview(b)
        }
    }
    
}

