//
//  WheelSlider.swift
//  WheelSliderSample
//
//  Created by 曽和修平 on 2015/10/31.
//  Copyright © 2015年 deeptoneworks. All rights reserved.
//

import UIKit


@IBDesignable
class WheelSlider: UIView {
    
    private let wheelView:UIView
    
    private var beforePint:Double = 0
    private var currentPoint:Double = 0{
        didSet{
            wheelView.layer.removeAllAnimations()
            wheelView.layer.addAnimation(nextAnimation(), forKey: "sample")
        }
    }
    
    private var beganTouchPosition = CGPointMake(0, 0){
        didSet{
            moveTouchPosition = CGPointMake(0, 0)
        }
    }
    private var moveTouchPosition = CGPointMake(0, 0){
        didSet{
            calcCurrentPoint()
        }
    }
    
    
    
//    @IBInspectable public var minVal:Int = 0
    @IBInspectable public var maxVal:Int = 100
    @IBInspectable public var speed : Double = 2.0
//
    
    override init(frame: CGRect) {
        wheelView = UIView(frame: CGRectMake(0, 0, frame.width, frame.height))
        super.init(frame: frame)
        addSubview(wheelView)
       
    }

    required init?(coder aDecoder: NSCoder) {
        wheelView = UIView();
        super.init(coder: aDecoder)
        wheelView.frame = bounds
   
        addSubview(wheelView)
        drawPointerCircle(1.0)
//        wheelView.backgroundColor = UIColor.redColor()
//        wheelView.layer.addAnimation(rotateAnimation(CGFloat(-M_PI),end: CGFloat(M_PI)), forKey: "sample")
    
        
    }
    
    private func drawPointerCircle(currentPoint:CGFloat) -> CAShapeLayer{
        let ovalShapeLayer = CAShapeLayer()
        ovalShapeLayer.strokeColor = UIColor.blueColor().CGColor
        ovalShapeLayer.fillColor = UIColor.clearColor().CGColor
        ovalShapeLayer.lineWidth = 5.0
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let start = CGFloat(M_PI * 3.0/2.0)
        let end = CGFloat(M_PI * 3.0/2.0 + 0.2)

        ovalShapeLayer.path = UIBezierPath(arcCenter: center, radius: max(bounds.width, bounds.height) / 2, startAngle:start, endAngle: end ,clockwise: true).CGPath
        wheelView.layer.addSublayer(ovalShapeLayer)
        return ovalShapeLayer
    
    }
    
    private func nextAnimation()->CABasicAnimation{
        
        let start = CGFloat(beforePint/Double(maxVal) * M_PI)
        let end = CGFloat(currentPoint/Double(maxVal) * M_PI)
        
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
    
    private func rotateAnimation(start:CGFloat,end:CGFloat)->CABasicAnimation{
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.duration = 2.0
        anim.repeatCount = 1000
        anim.fromValue = start
        anim.toValue =  end
        anim.removedOnCompletion = false
        return anim
        
    }
    
    
    
    
    private func calcCurrentPoint(){
        guard(true)else{
            
        }
        let centerX = bounds.size.width/2.0
        beforePint = currentPoint
        
        if(centerX > moveTouchPosition.x){
            if(moveTouchPosition.y > beganTouchPosition.y){
                currentPoint+=speed;
            }else{
                currentPoint-=speed;
            }
        }else{
            if(moveTouchPosition.y > beganTouchPosition.y){
                currentPoint-=speed;
            }else{
                currentPoint+=speed;
            }
        }
        
        beganTouchPosition = moveTouchPosition
        print(moveTouchPosition.y)
        
        
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch?
        if let t = touch{
            let pos = t.locationInView(self)
            beganTouchPosition = pos
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch?
        if let t = touch{
            let pos = t.locationInView(self)
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
