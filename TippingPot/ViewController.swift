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
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var taxValueLabel: UILabel!
    
    enum TipOptions : String {
        case FrugalTip = "frugal", RegularTip = "regular", GenerousTip = "generous"
        
        static let allValues = [FrugalTip, RegularTip, GenerousTip]
    }
    
    let DEFAULT_TAX = "DEFAULT_TAX"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tipLabel.text = "$0.00"
        totalLabel.text = "$0.00"

        //check if we initialized already
        var defaults = NSUserDefaults.standardUserDefaults()
        if (defaults.objectForKey(TipOptions.FrugalTip.toRaw()) == nil) {
            initializeDefaultValues()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        loadDefaultValues()
        calculateTotal()
    }

    func initializeDefaultValues() {
        // Initialize tip amounts
        var tipPercentageDefaults = [15, 20, 22]
        var tipDefaults = Array(Zip2(tipPercentageDefaults, TipOptions.allValues))

        var defaults = NSUserDefaults.standardUserDefaults()
        for (value, key) in tipDefaults {
            defaults.setInteger(value, forKey: key.toRaw())
        }
        
        // Initialize tax amounts
        var taxDefault = 8.25
        defaults.setDouble(taxDefault, forKey: DEFAULT_TAX)
        
        defaults.synchronize()
    }

    func loadDefaultValues() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var tipValues = Array(Zip2([0,1,2], TipOptions.allValues))
        for (index, tipKey) in tipValues {
            var tipValue = defaults.stringForKey(tipKey.toRaw())
            tipControl.setTitle("\(tipValue!)%", forSegmentAtIndex: index)
        }

        var tax = defaults.doubleForKey(DEFAULT_TAX)
        taxLabel.text = "\(tax)%"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        calculateTotal()
    }

    func calculateTotal() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var tipPercentage = getTipPercentage()
        var billAmount = billField.text._bridgeToObjectiveC().doubleValue
        var tip = billAmount * tipPercentage
        var tax = billAmount * defaults.doubleForKey(DEFAULT_TAX) / 100
        var total = billAmount + tip + tax

        tipLabel.text = String(format: "$%.2f", tip)
        taxValueLabel.text = String(format: "$%.2f", tax)
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

