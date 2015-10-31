//
//  ViewController.swift
//  WheelSliderSample
//
//  Created by 曽和修平 on 2015/10/31.
//  Copyright © 2015年 deeptoneworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WheelSliderDelegate {

    @IBOutlet weak var slider: WheelSlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    func updateSliderValue(value: Double) {
        print("currentValue \(value)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

