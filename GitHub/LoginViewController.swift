//
//  LoginViewController.swift
//  GitHub
//
//  Created by Leonard Lamprecht on 14/05/16.
//  Copyright © 2016 Leo Lamprecht. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func didLoginSuccessfully()
}

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    
    var delegate: LoginViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let length = textField.text!.characters.count - range.length + string.characters.count
        if length > 0 {
            submitButton.enabled = true
        } else {
            submitButton.enabled = false
        }
        return true
    }
    

    @IBAction func loginButtonTapped() {
        performSegueWithIdentifier("showAuthorizer", sender: nil)
        //UIApplication.sharedApplication().openURL(NSURL(string: "http://leo.im")!)
        /*
        if usernameField.text == "leo" && passwordField.text == "1234" {
            resignFirstResponder()
            delegate?.didLoginSuccessfully()
        } else {
            let alertController = UIAlertController(title: "Shit happens!", message: "The username and password combination failed.", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            })
            alertController.addAction(ok)
            presentViewController(alertController, animated: true, completion: nil)
        }*/
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
