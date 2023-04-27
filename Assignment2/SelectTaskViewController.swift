//
//  SelectTaskViewController.swift
//  Assignment2
//
//  Created by Thomas Bennett (Student) on 27/04/2023.
//

import UIKit

class SelectTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    //this variable we will get from the segue
    var projectId: Int?
    var projectTitle: String?
    
    @IBOutlet weak var dropdown: UIPickerView!
    
    //struct to get titles
    struct Item: Codable{
        let id: Int
        let name: String
    }
    //to store items
    var items: [Item] = []
    var selectedItemId: Int?
    
    //Overwride segue to pass information
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "editTaskSegue"{
            let EditTaskVC = segue.destination as! editTaskViewController
            EditTaskVC.taskId = self.selectedItemId
            EditTaskVC.projectTitle = self.projectTitle
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //overwrite segue
        
        
        
        //guard ensures the project id is recieved from the select projects menu
        guard let id = projectId,
        let pTitle = projectTitle else {
            print("No id found")
            return
        }
        
        print(pTitle)
        
        
        // -=-=-=-=- Code for Wheel
        
        let url = URL(string: "http://127.0.0.1:5000/api/tasks/get/titles?project_id=\(id)")!
        print(url)
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                self.items = try JSONDecoder().decode([Item].self, from: data)
                
                DispatchQueue.main.async {
                    self.dropdown.reloadAllComponents()
                }
            } catch {
                print("error decoding JSON in tasks")
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
        } else {
            selectedItemId = nil
        }
    }

        
        
        
        
        
        

        
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


