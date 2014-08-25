//
//  ViewController.swift
//  TippingPot
//
//  Created by Andrew Chao on 8/24/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    enum TipOptions : String {
        case FrugalTip = "frugal", RegularTip = "regular", GenerousTip = "generous"
        
        static let allValues = [FrugalTip, RegularTip, GenerousTip]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"

        //check if we initialized already
        var defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(TipOptions.FrugalTip.toRaw()) == nil) {
            initializeDefaultTipValues()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        loadDefaultTipValues()
        calculateTotal()
    }

    func initializeDefaultTipValues() {
        var tipPercentageDefaults = [15, 20, 22]
        var tipDefaults = Array(Zip2(tipPercentageDefaults, TipOptions.allValues))

        var defaults = NSUserDefaults.standardUserDefaults()
        for (value, key) in tipDefaults {
            defaults.setInteger(value, forKey: key.toRaw())
        }
        defaults.synchronize()
    }

    func loadDefaultTipValues() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var tipValues = Array(Zip2([0,1,2], TipOptions.allValues))
        for (index, tipKey) in tipValues {
            var tipValue = defaults.stringForKey(tipKey.toRaw())
            tipControl.setTitle("\(tipValue!)%", forSegmentAtIndex: index)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        calculateTotal()
    }

    func calculateTotal() {
        var tipPercentage = getTipPercentage()
        var billAmount = billField.text._bridgeToObjectiveC().doubleValue
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }

    // Helper to convert the select segment into a tip value
    func getTipPercentage() -> Double{
        var tipString = tipControl.titleForSegmentAtIndex(tipControl.selectedSegmentIndex)
        tipString = tipString.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return tipString._bridgeToObjectiveC().doubleValue/100
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}

