//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Ravi Shankar on 19/11/15.
//  Copyright © 2015 Ravi Shankar. All rights reserved.
//

import UIKit

class AddUserViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    let firebase = Firebase(url:"https://<your_identifier>.firebaseio.com/profiles")
    var dateOfBirthTimeInterval: NSTimeInterval = 0
    
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func save(sender: AnyObject) {

        let name = nameTextField.text
        var data: NSData = NSData()

        if let image = photoImageView.image {
           data = UIImageJPEGRepresentation(image,0.1)!
        }
        
        let base64String = data.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)

        let user: NSDictionary = ["name":name!,"dob":dateOfBirthTimeInterval, "photoBase64":base64String]
        
        //add firebase child node
        let profile = firebase.ref.childByAppendingPath(name!)
        
        // Write data to Firebase
        profile.setValue(user)
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func datePicked(sender: AnyObject) {
        dateOfBirthTimeInterval = datePicker.date.timeIntervalSinceNow
        dateOfBirthTextField.text = formatDate(datePicker.date)
    }
    
    func applyStyle() {
        view.backgroundColor = backgroundColor
 
        nameTextField.font = standardTextFont
        nameTextField.textColor = UIColor.whiteColor()
        
        dateOfBirthTextField.font = standardTextFont
        dateOfBirthTextField.textColor = UIColor.whiteColor()
        
        datePicker.backgroundColor = backgroundColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}

extension AddUserViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        photoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK:- Add Picture
    
    @IBAction func addPicture(sender: AnyObject) {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera
            
            presentViewController(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            presentViewController(imagePicker, animated: true, completion:nil)
        }
    }
}
