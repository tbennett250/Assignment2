//
//  AddTaskViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import UIKit

struct Item: Codable {
    let id: Int
    let name: String
}

class AddTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var viewDropdown: UIView!
    @IBOutlet weak var dropdownBox: UIPickerView!
    
    var items: [Item] = []
    var selectedItemId: Int?
    let colorLightBlue = UIColor(red: 0.118, green: 0.651, blue: 0.776, alpha: 1)
    let colorDarkBlue = UIColor(red: 0.118, green: 0.471, blue: 0.678, alpha: 1)

    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var msgImage: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDesc: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    func setErrorMsg(message: String){
        DispatchQueue.main.async {
            self.msgLabel.textColor = .red
            self.msgLabel.text = message
            self.msgImage.image = UIImage(named: "cancel")
        }
    }
    
    func setSuccessMsg(msg: String){
        DispatchQueue.main.async {
            self.msgLabel.textColor = .green
            self.msgLabel.text = msg
            self.msgImage.image = UIImage(named: "accept")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let gradientLeft = CAGradientLayer()
        let gradientRight = CAGradientLayer()
        //sets the gradients frame to the dropdown.
        gradientLeft.frame = viewDropdown.bounds
        gradientLeft.colors = [ colorDarkBlue.cgColor, colorLightBlue.cgColor, colorDarkBlue.cgColor]
        gradientRight.frame = viewDropdown.bounds
        gradientRight.colors = [colorDarkBlue.cgColor, colorLightBlue.cgColor, colorDarkBlue.cgColor]
        //set the picker to have a clear background so can see through the gradient
        dropdownBox.backgroundColor = UIColor.clear
        
        gradientLeft.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLeft.endPoint = CGPoint(x:0.0, y: 1.0)
        gradientRight.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientRight.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        viewDropdown.layer.insertSublayer(gradientLeft, at: 0)
        viewDropdown.layer.insertSublayer(gradientRight, at: 0)
        
        // make api call to get projects.
        let userId = UserData.shared.currentUser!.id
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/titles?id=\(userId)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                self.items = try JSONDecoder().decode([Item].self, from: data)
                
                DispatchQueue.main.async {
                    self.dropdownBox.reloadAllComponents()
                }
            } catch {
                print("error decoding JSON")
            }
        } .resume()
        
        dropdownBox.dataSource = self
        dropdownBox.delegate = self
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < items.count {
            let selectedItem = items[row]
            selectedItemId = selectedItem.id
        } else {
            selectedItemId = nil
        }
    }


// IF button is clicked
    @IBAction func btnPressed(_ sender: Any) {
        
      
        
        //Guard to make sure all values are in
        guard let selectedProject = selectedItemId,
              let name = txtName.text,
              let desc = txtDesc.text,
              let date = datePicker?.date else{
            print("Error Convertin variables")
            self.setErrorMsg(message: "Please fill in the fields")
            return
        }
        
        //Validate Dates and get todays date and format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let todaysDate = Date()
        let formattedTodaysDate = dateFormatter.string(from: todaysDate)
        let formattedDate = dateFormatter.string(from: date)
        
        //guard to check if date is prior totodays date
        guard formattedTodaysDate.compare(formattedDate) != .orderedDescending else{
            self.setErrorMsg(message: "Cannot a date before today.")
            return
        }
        
        //Api Call
        
        let url = "http://127.0.0.1:5000/api/tasks/add"
        let user_id = UserData.shared.currentUser!.id
        
        var task = Task(name: name, description: desc, due_date: formattedDate, project_id: selectedProject, status: 0)
                
        
        URLSession.shared.postData(task, urlString: url) { (result: Result<Task, Error>) in
            switch result {
            case.success(let result):
                print(result)
                self.setSuccessMsg(msg: "Task added, please return")
                
            case.failure(let error):
                print(error.localizedDescription)
                self.setErrorMsg(message: "Error, Please Try again")
            }
        }
        
        
    }
    
    
    
    
}
