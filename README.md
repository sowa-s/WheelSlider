# WheelSlider

#Usage

##InterfaceBuilder
Please create Square View.

##Delegate
```
protocol WheelSliderDelegate{
    func updateSliderValue(value:Double) -> ()
}
```
Value Notification.

##Variable

```
@IBInspectable public var speed:Int
```
Rotational speed.
Since the smaller the value is fast note.

```

```
//backgroundCircleParameter
@IBInspectable public var backStrokeColor : UIColor = UIColor.darkGrayColor()
@IBInspectable public var backFillColor : UIColor = UIColor.darkGrayColor()
@IBInspectable public var backWidth : CGFloat = 10.0


//knobParameter
@IBInspectable public var knobStrokeColor : UIColor = UIColor.whiteColor()
@IBInspectable public var knobWidth : CGFloat = 30.0
@IBInspectable public var knobLength : CGFloat = 0.025
public var knobLineCap = WSKnobLineCap.WSLineCapRound
@IBInspectable public var maxVal:Int = 10
@IBInspectable public var isLimited:Bool = false
@IBInspectable public var allowNegativeNumber:Bool = true
@IBInspectable public var isValueText:Bool = true
@IBInspectable public var valueTextColor:UIColor = UIColor.whiteColor()
@IBInspectable public var valueTextFontSize:CGFloat = 20.0
```
後で書く

