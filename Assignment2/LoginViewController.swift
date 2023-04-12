import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notificationLabel: UILabel!
    
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        var loggedIn = false
        guard let username = usernameTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        let parameters = ["username": username, "password": password]
        
        guard let url = URL(string: "http://127.0.0.1:5000/api/users/login") else {
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
                      return
                  }
            
            guard let data = data else {
                print("Error: No data received")
                return
            }
            
            do {
                let userData = try JSONDecoder().decode([User].self, from: data)
                if userData.count > 0 {
                    UserData.shared.currentUser = userData[0]
                    
                    DispatchQueue.main.async {
                        loggedIn = true
                        self.notificationLabel.text = "Logged in \(userData[0].username)"
                    }
                    print("User logged in successfully")
                } else {
                    print("Invalid username or password")
                }
            } catch {
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                if(loggedIn == true){
                    
                    let uservc = (self.storyboard?.instantiateViewController(withIdentifier: "UserVC"))!
                    self.notificationLabel.text = "Please Login"
                    self.navigationController?.pushViewController(uservc, animated: true)
                }
            }
            
        }.resume()
        
        
    }
}

struct User: Codable {
    let id: Int

    let email: String
    let username: String
    let password: String
}
