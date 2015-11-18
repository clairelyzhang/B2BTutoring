//
//  LoginProfileViewController.swift
//  B2BTutoring
//
//  Created by Claire Zhang on 10/26/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import UIKit
import Eureka

class LoginProfileViewController: UIViewController, UITextFieldDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // text field
    @IBOutlet weak var firstname: HoshiTextField! {
        didSet {
            firstname.delegate = self
        }
    }
    
    @IBOutlet weak var lastname: HoshiTextField! {
        didSet {
            lastname.delegate = self
        }
    }
    
    @IBOutlet weak var email: HoshiTextField! {
        didSet {
            email.delegate = self
        }
    }
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var slidingView: UIView!
    var firstResponder: UIView?
    
    // profile picture
    @IBOutlet weak var photoButton: UIButton!
    var photo: UIImage!
    
    func signup() {
        let alert = UIAlertController(title: "Alert", message: "Signing Up...", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        let user = User()
        user.username = "Peter"
        user.password = "myPassword"
        user.lastName = "lastname"
        user.firstName = "firstname"
        user.phone = "1231231231"
        user.intro = "this is my intro"
        //user.profileImage = "starwar"
        //user.backgroundImage = "darth_vader"
        user.rating = 5.0
        
        user.tutorSessions = [Session]()
        let query = PFQuery(className: Session.parseClassName())
        query.whereKey("tutor", equalTo:"Mary")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                if let objects = objects as [PFObject]! {
                    for object in objects {
                        if let object = object as? Session {
                            user.tutorSessions!.append(object)
                        }
                    }
                }
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool, error: NSError?) -> Void in
                    if succeeded {
                        self.performSegueWithIdentifier("showTabBarControllerSegue", sender: self)
                    } else {
                        print("Error: \(error!)")
                    }
                }
            } else {
                print("Error: \(error!)")
            }
        }
    }
    
    @IBAction func saveProfile(sender: UIButton) {
        let alert = UIAlertController(title: "Alert", message: "trying logging in...", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true, completion: nil)
        
        User.logInWithUsernameInBackground("myPhoneNumber", password:"myPassword") {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("showTabBarControllerSegue", sender: self)
            } else {
                self.signup()
            }
        }
    }
    
    @IBAction func addPhoto(sender: UIButton) {
        // setup action sheet
        let alert: UIAlertController = UIAlertController(title: "Add Photo", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) {
                UIAlertAction in self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Choose from Library", style: UIAlertActionStyle.Default) {
                UIAlertAction in self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
        }
        
        // add actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        // present alert controller
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        photo = image
        photoButton.setTitle("", forState: .Normal)
        photoButton.setBackgroundImage(photo, forState: .Normal)
        self.dismissViewControllerAnimated(true, completion: nil);
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        firstResponder = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        firstResponder = nil
        return true
    }
    
    func keyboardShow(notification: NSNotification) {
        let dict = notification.userInfo!
        var r = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        r = slidingView.convertRect(r, fromView:nil)
        if let f = firstResponder?.frame {
            let y : CGFloat = f.maxY + r.size.height - slidingView.bounds.height + 5
            if r.origin.y < f.maxY {
                topConstraint.constant = -y
                bottomConstraint.constant = -y
                view.layoutIfNeeded()
            }
        }
    }
    
    func keyboardHide(notification: NSNotification) {
        topConstraint.constant = 0
        bottomConstraint.constant = 0
        view.layoutIfNeeded()
        firstResponder?.resignFirstResponder()
        firstResponder = nil
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
