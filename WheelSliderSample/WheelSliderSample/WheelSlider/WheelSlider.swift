//
//  WheelSlider.swift
//  WheelSliderSample
//
//  Created by 曽和修平 on 2015/10/31.
//  Copyright © 2015年 deeptoneworks. All rights reserved.
//

import UIKit

protocol WheelSliderDelegate{
    func updateSliderValue(value:Double) -> ()
}

public enum WSKnobLineCap{
    case WSLineCapButt
    case WSLineCapRound
    case WSLineCapSquare
    var getLineCapValue:String{
        switch self{
        case .WSLineCapButt:
            return kCALineCapButt
        case .WSLineCapRound:
            return kCALineCapRound
        case .WSLineCapSquare:
            return kCALineCapSquare
        }
    }
}

@IBDesignable
public class WheelSlider: UIView {
    
    private let wheelView:UIView
    
    private var beforePoint:Double = 0
    private var currentPoint:Double = 0{
        didSet{
            wheelView.layer.removeAllAnimations()
            wheelView.layer.addAnimation(nextAnimation(), forKey: "rotateAnimation")
            valueTextLayer?.string = "\(Int(calcCurrentValue()))"
            delegate?.updateSliderValue(calcCurrentValue())//notofication
        }
    }
    private var beganTouchPosition = CGPointMake(0, 0)
    private var moveTouchPosition = CGPointMake(0, 0){
        didSet{
            calcCurrentPoint()
        }
    }
    private var valueTextLayer:CATextLayer?
    
    var delegate : WheelSliderDelegate?
    
    //backgroundCircleParameter
    @IBInspectable public var backStrokeColor : UIColor = UIColor.darkGrayColor()
    @IBInspectable public var backFillColor : UIColor = UIColor.darkGrayColor()
    @IBInspectable public var backWidth : CGFloat = 10.0
    
    
    //knobParameter
    @IBInspectable public var knobStrokeColor : UIColor = UIColor.grayColor()
    @IBInspectable public var knobWidth : CGFloat = 25.0
    @IBInspectable public var knobLength : CGFloat = 0.025
    public var knobLineCap = WSKnobLineCap.WSLineCapRound
    
 
    @IBInspectable public var minVal:Int = 0
    @IBInspectable public var maxVal:Int = 10
    @IBInspectable public var speed:Int = 40
    @IBInspectable public var isLimited:Bool = false
    @IBInspectable public var allowNegativeNumber:Bool = true
    @IBInspectable public var isValueText:Bool = true
    @IBInspectable public var valueTextColor:UIColor = UIColor.whiteColor()
    @IBInspectable public var valueTextFontSize:CGFloat = 20.0
    public lazy var font:UIFont = UIFont.systemFontOfSize(self.valueTextFontSize)
    
    override init(frame: CGRect) {
        wheelView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        super.init(frame: frame)
        addSubview(wheelView)
        wheelView.layer.addSublayer(drawBackgroundCicle())
        wheelView.layer.addSublayer(drawPointerCircle())
        if let layer = drawValueText(){
            valueTextLayer = layer
            self.layer.addSublayer(layer)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        wheelView = UIView();
        super.init(coder: aDecoder)
        wheelView.frame = bounds
        addSubview(wheelView)
        wheelView.layer.addSublayer(drawBackgroundCicle())
        wheelView.layer.addSublayer(drawPointerCircle())
        if let layer = drawValueText(){
            valueTextLayer = layer
            self.layer.addSublayer(layer)
        }
    }
    
    private func drawValueText()->CATextLayer?{
        guard(isValueText)else{
            return nil
        }
        let textLayer = CATextLayer()
        textLayer.string = "\(0)"
        textLayer.font = font
        textLayer.fontSize = font.pointSize
        textLayer.frame = CGRectMake(frame.origin.x/2 - bounds.width/2, frame.origin.y/2, bounds.width, bounds.height)
        textLayer.foregroundColor = valueTextColor.CGColor
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        return textLayer
    }
    
    private func drawBackgroundCicle() -> CAShapeLayer{
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = backStrokeColor.CGColor
        ovalShapeLayer.fillColor = backFillColor.CGColor
        ovalShapeLayer.lineWidth = backWidth
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let start = CGFloat(0)
        let end = CGFloat(2.0 * M_PI)
        ovalShapeLayer.path = UIBezierPath(arcCenter: center, radius: max(bounds.width, bounds.height) / 2, startAngle:start, endAngle: end ,clockwise: true).CGPath
        return ovalShapeLayer
        
    }
    private func drawPointerCircle() -> CAShapeLayer{
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = knobStrokeColor.CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = knobWidth
        ovalShapeLayer.lineCap = knobLineCap.getLineCapValue
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let start = CGFloat(M_PI * 3.0/2.0)
        let end = CGFloat(M_PI * 3.0/2.0) + knobLength

        ovalShapeLayer.path = UIBezierPath(arcCenter: center, radius: max(bounds.width, bounds.height) / 2, startAngle:start, endAngle: end ,clockwise: true).CGPath
        return ovalShapeLayer
    
    }
    
    private func nextAnimation()->CABasicAnimation{

        let start = CGFloat(beforePoint/Double(speed) * M_PI)
        let end = CGFloat(currentPoint/Double(speed) * M_PI)
        
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.duration = 0
        anim.repeatCount = 0
        anim.fromValue = start
        anim.toValue =  end
        anim.removedOnCompletion = false;
        anim.fillMode = kCAFillModeForwards;
        anim.removedOnCompletion = false
        return anim
    
    }
    
    private func calcCurrentValue() -> Double{
        let normalization = Double(maxVal) / Double(speed)
        let val = currentPoint*normalization/2.0
        if(isLimited && val > Double(maxVal)){
            beforePoint = 0
            currentPoint = 0
        }
        return val
    }
    
    private func calcCurrentPoint(){
        
        let displacementY = abs(beganTouchPosition.y - moveTouchPosition.y)
        let displacementX = abs(beganTouchPosition.x - moveTouchPosition.x)
        
        guard(max(displacementX,displacementY) > 1.0)else{
            return
        }
        guard(allowNegativeNumber || calcCurrentValue() > 0)else{
            currentPoint++
            return
        }
        
        let centerX = bounds.size.width/2.0
        let centerY = bounds.size.height/2.0
        beforePoint = currentPoint
        if(displacementX > displacementY){
            if(centerY > beganTouchPosition.y){
                if(moveTouchPosition.x >= beganTouchPosition.x){
                    currentPoint++
                }else{
                    currentPoint--
                }
            }else{
                if(moveTouchPosition.x > beganTouchPosition.x){
                    currentPoint--
                }else{
                    currentPoint++
                }
            }
        }else{
            if(centerX <= beganTouchPosition.x){
                if(moveTouchPosition.y >= beganTouchPosition.y){
                    currentPoint++
                }else{
                    currentPoint--
                }
            }else{
                if(moveTouchPosition.y > beganTouchPosition.y){
                    currentPoint--
                }else{
                    currentPoint++
                }
            }
        }
    }
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch?
        if let t = touch{
            let pos = t.locationInView(self)
            beganTouchPosition = moveTouchPosition
            moveTouchPosition = pos
        }
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
