//
//  ViewController.swift
//  EmojiSlider
//
//  Created by Eyad on 6/23/18.
//  Copyright © 2018 Eyad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.inputAccessoryView = AccessoryTouchBar.init(withField: emailTextField, forInputType: .emailField)
        contentTextField.inputAccessoryView = AccessoryTouchBar.init(withField: contentTextField)
        let volume = eVolumeBar().withTint(.white).withVolumeIconColor(.yellow)
        self.view.addSubview(volume)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

