//
//  TrainCapacityView.swift
//
//  Created by Sven A. Schmidt <sas@finestructure.co>
//

import UIKit


public class TrainCapacityView: UIView {

    let CarriageBuffer = CGFloat(5.0)
    let AspectRatio = CGFloat(2.2)


    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    public init(loads: [Double], maxBounds: CGSize) {

        var carriageHeight = maxBounds.height
        var carriageWidth = carriageHeight * AspectRatio
        let loadsCount = CGFloat(loads.count)


        // Calculate width of view
        var viewWidth = ((loadsCount - 1) * CarriageBuffer) + (loadsCount * carriageWidth)

        if viewWidth > maxBounds.width {
            // Width would overrun, so adjust our carriage height & width to fit
            carriageWidth = (maxBounds.width - ((loadsCount - 1) * CarriageBuffer)) / loadsCount
            carriageHeight = carriageWidth / AspectRatio
            viewWidth = maxBounds.width
        }

        super.init(frame: CGRect(x: 0, y: 0, width: viewWidth, height: carriageHeight))

        for i in 0..<loads.count {
            let carriageType: CarriageType = {
                switch i {
                case 0:             return .LeftEnd
                case loads.count-1: return .RightEnd
                default:            return .Middle
                }
            }()
            let frame = CGRect(x: (carriageWidth + CarriageBuffer) * CGFloat(i), y: 0, width: carriageWidth, height: carriageHeight)
            let carriageView = CarriageView(frame: frame, load: loads[i], carriageNumber: i+1, carriageType: carriageType)
            self.addSubview(carriageView)
        }
        
    }
    
}

