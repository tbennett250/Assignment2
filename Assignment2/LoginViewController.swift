//
//  LoginViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 12/04/2023.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    
    
    override func viewDidLoad() {
        usernameField.layer.cornerRadius = 20.0
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
