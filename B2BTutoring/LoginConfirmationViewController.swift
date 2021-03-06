//
//  LoginConfirmationViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/26/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import Parse

class LoginConfirmationViewController: UIViewController {
    var phoneNumber: String?
    var verificationCode: String?

    @IBOutlet weak var message: UILabel!

    @IBOutlet weak var display: UILabel!

    @IBAction func appendDigit(sender: UIButton) {
        if enteredCode.characters.count < 4 {
            enteredCode += sender.currentTitle!
        }
    }

    @IBAction func confirmCode(sender: UIButton) {
        if enteredCode.characters.count == 4 {
            if enteredCode == verificationCode! {
                performSegueWithIdentifier("Show Create Profile", sender: self)
            } else {
                animateOnError()
            }
        }
    }

    @IBAction func deleteDigit(sender: UIButton) {
        if enteredCode.characters.count > 0 {
            display.text = String(enteredCode.characters.dropLast())
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // compute 4-digit verification code
        verificationCode = String(format: "%04d", UInt((arc4random())) % 10000)
        print("Computed verification code: " + verificationCode!)

        // send verification code
        print("Phone number to verify: " + phoneNumber!)
        PFCloud.callFunctionInBackground("sendVerificationCode", withParameters: ["number": phoneNumber!, "verificationCode": verificationCode!]) {
            (response, error) in
            if (error != nil) {
                // TODO: handle error
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var enteredCode: String {
        get {
            return display.text!
        }
        set {
            display.text = newValue
        }
    }

    func animateOnError() {
        // shake label to indicate error
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.07)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(display.center.x - 10, display.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(display.center.x + 10, display.center.y))
        CATransaction.setCompletionBlock { () -> Void in
            self.enteredCode = ""  // clear label
            self.message.text = "*PLEASE ENTER THE CORRECT CODE*"
        }
        display.layer.addAnimation(animation, forKey: "position")
        CATransaction.commit()
    }

    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Create Profile" {
            if let destinationViewController = segue.destinationViewController as? LoginProfileViewController {
                destinationViewController.phoneNumber = phoneNumber
            }
        }
    }


}
