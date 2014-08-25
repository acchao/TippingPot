//
//  SettingsViewController.swift
//  TippingPot
//
//  Created by Andrew Chao on 8/24/14.
//  Copyright (c) 2014 Andrew Chao. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var editTipField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadDefaultTipValues()
        loadEditTipField()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onEditTip(sender: AnyObject) {
        // change the tip value of the selected segment
        // we assign to a new variable to prevent non-integer values
        // we also use bridgeToObjectiveC().integerValue because it would otherwise
        // create a text value of "Optional(x)" and using ! causes a fatal error
        // when invalid values are pasted in
        var newTipValue = editTipField.text._bridgeToObjectiveC().integerValue
        tipControl.setTitle("\(newTipValue)%", forSegmentAtIndex: tipControl.selectedSegmentIndex)

        //save to user defaults
        //TODO(Andrew): clean this up, not familiar enough with swift enums
        var defaults = NSUserDefaults.standardUserDefaults()
        if (tipControl.selectedSegmentIndex == 0) {
            defaults.setInteger(newTipValue, forKey: ViewController.TipOptions.FrugalTip.toRaw())
        } else if (tipControl.selectedSegmentIndex == 1) {
            defaults.setInteger(newTipValue, forKey: ViewController.TipOptions.RegularTip.toRaw())
        } else if (tipControl.selectedSegmentIndex == 2) {
            defaults.setInteger(newTipValue, forKey: ViewController.TipOptions.GenerousTip.toRaw())
        }
    }

    @IBAction func onTipSelected(sender: AnyObject) {
        loadEditTipField()
    }

    func loadEditTipField() {
        var selectedTipText = tipControl.titleForSegmentAtIndex(tipControl.selectedSegmentIndex)
        // Strip the %
        editTipField.text = selectedTipText.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    // TODO(Andrew) this should really be a public static method
    func loadDefaultTipValues() {
        var defaults = NSUserDefaults.standardUserDefaults()
        var tipValues = Array(Zip2([0,1,2], ViewController.TipOptions.allValues))
        for (index, tipKey) in tipValues {
            var tipValue = defaults.stringForKey(tipKey.toRaw())
            tipControl.setTitle("\(tipValue!)%", forSegmentAtIndex: index)
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
