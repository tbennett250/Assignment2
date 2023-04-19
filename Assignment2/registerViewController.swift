//
//  registerViewController.swift
//  BensAPI
//
//  Created by Thomas Bennett (Student) on 22/03/2023.
//

import UIKit




class registerViewController: UIViewController {
    
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    
    
    @IBOutlet weak var imgViewLabel: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            self.messageLabel.text = ""
        }
        
        
    }
    
    func changeLabelDanger(msg: String){
        DispatchQueue.main.async {
            self.messageLabel.text = msg
            self.messageLabel.textColor = .red
            self.imgViewLabel.image = UIImage(named: "cancel")
        }
    }
    
    func changeLabelSuccess(msg: String){
        DispatchQueue.main.async {
            self.messageLabel.text = msg
            self.messageLabel.textColor = .green
            self.imgViewLabel.image = UIImage(named: "accept")
        }
    }

    
    @IBAction func registerButtonClicked(_ sender: Any) {
        
        guard let username = usernameField.text,
              let password = passwordField.text,
              let email = emailField.text else {
            return
        }
        print(username.isEmpty)
        
        guard !username.isEmpty || !password.isEmpty || !email.isEmpty else{
            self.changeLabelDanger(msg: "Please complete the form.")
            return
        }
        
        let parameters = ["username": username, "password": password, "email": email]
        
        guard let url = URL(string: "http://127.0.0.1:5000/api/users/register") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("Error: Invalid response")
                self.changeLabelDanger(msg: "Error - Invalid response to server")
                return
            }
            
            guard let data = data else {
                print("Error: No data received")
                self.changeLabelDanger(msg: "No data inputted")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [String: Any],
                   let registerSuccess = dict["Register_Success"] as? Bool,
                   registerSuccess == true {
                    print("User registration successful")
                    // In order to change label we need to use another thread:
                    // the code in the dispatchQueue allows the changes to be made
                    
                    self.changeLabelSuccess(msg: "Registration Successful")
                    
                    DispatchQueue.main.async {
                        
                        
                        let LoginVC = (self.storyboard?.instantiateViewController(withIdentifier: "LoginVC"))!
                        self.navigationController?.pushViewController(LoginVC, animated: true)
                    }
                } else {
                    print("User registration failed")
                    self.changeLabelDanger(msg: "User Registration Failed")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
        }.resume()
        
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
