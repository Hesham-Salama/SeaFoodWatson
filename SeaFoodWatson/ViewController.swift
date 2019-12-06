//
//  ViewController.swift
//  SeaFoodWatson
//
//  Created by hesham on 1/25/19.
//  Copyright © 2019 hesham. All rights reserved.
//

import UIKit
import VisualRecognition
import SVProgressHUD

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let imagePicker = UIImagePickerController()
    let API_KEY = ""
    let VERSION_DATE = "2019-01-25"
    let CLASS_REQUIRED = "hotdog"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Image isn't found in Picker.")
        }
        
        let visualRecognition = VisualRecognition(version: VERSION_DATE, apiKey: API_KEY)
        visualRecognition.classify(image: imagePicked) { (classifiedImages, error) in
            var flag = false
            var whatWatsonThinksAboutObject = ""
            if let arrClasses = classifiedImages?.result?.images[0].classifiers[0].classes {
                whatWatsonThinksAboutObject = arrClasses[0].className
                for classItem in arrClasses {
                    if classItem.className == self.CLASS_REQUIRED {
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            self.navigationItem.title = self.CLASS_REQUIRED + "!"
                            self.cameraButton.isEnabled = true
                        }
                        flag = true
                        break
                    }
                }
                if !flag {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.navigationItem.title = "Not "+self.CLASS_REQUIRED + " but \(whatWatsonThinksAboutObject)?"
                        self.cameraButton.isEnabled = true
                    }
                }
            }
        }
        foodImageView.image = imagePicked
        SVProgressHUD.show(withStatus: "Waiting for a reply from Watson servers...")
        cameraButton.isEnabled = false
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        self.navigationItem.title = "SeeFoodWatson"
        present(imagePicker, animated: true, completion: nil)
    }
}

