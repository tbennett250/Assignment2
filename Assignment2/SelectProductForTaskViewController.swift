//
//  SelectProductForTaskViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import UIKit



class SelectProductForTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var passableDate: Int?
 
    var projectTitle: String?
    

    @IBOutlet weak var dropdown: UIPickerView!
    struct Item: Codable {
        let id: Int
        let name: String
    }
    
    var items: [Item] = []
    var selectedItemId: Int?
    
    //allows the passthrough of data between the two view controllers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "taskSegue"{
            let SelectTaskVC = segue.destination as! SelectTaskViewController
            SelectTaskVC.projectId = self.selectedItemId
            SelectTaskVC.projectTitle = self.projectTitle
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
      
        
        // Do any additional setup after loading the view.
        
        //Get project information based on userID
        
        let userId = UserData.shared.currentUser!.id
        let url = URL(string: "http://127.0.0.1:5000/api/projects/get/titles?id=\(userId)")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                self.items = try JSONDecoder().decode([Item].self, from: data)
                
                DispatchQueue.main.async {
                    self.dropdown.reloadAllComponents()
                }
            } catch {
                print("error decoding JSON")
            }
        } .resume()
        
        dropdown.dataSource = self
        dropdown.delegate = self
        
    }
        
    //Functions for project picker
    
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
            projectTitle = selectedItem.name
            
        } else {
            selectedItemId = nil
        }
    }

    
    
    
    
    @IBAction func btnDelete(_ sender: Any) {
        
        guard let projectID = selectedItemId else {
            return
        }
        
        
        
        
        
        
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
