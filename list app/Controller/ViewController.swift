//
//  ViewController.swift
//  list app
//
//  Created by abdullah's Monterey  on 1.11.2022.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var alertController = UIAlertController()
    var cancelButton = UIAlertAction()
    var defaultButton = UIAlertAction()
    @IBOutlet weak var tableView: UITableView!
    var data = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self

       // tableView.backgroundView?.contentMode = .scaleAspectFill
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }

    
    @IBAction func didTapDeleteBarBtn(_ sender: UIBarButtonItem) {
        
        if  data.first != nil {
            
            presentAlert(title: "list will be deleted", message: "do you approve", preferedStyle: .actionSheet, defaultButtonTitle: "Delete", defaulButtonHandler: { _ in
                self.data.removeAll()
                self.tableView.reloadData()
            }, cancelButtonTitle: "Cancel", isTextFieldAvaible: false)
            
            cancelButton.setValue(UIColor.gray, forKey: "titleTextColor")
            defaultButton.setValue(UIColor.red, forKey: "titleTextColor")
            
        } else{
            presentAlert(title: "Warning", message: "List empty", cancelButtonTitle: "OK")
        }
        
    }
    @IBAction func didTapAddBarBtn(_ sender: UIBarButtonItem) {
        
        presentAddAlert()
        
        
    }
    //method
    
    func presentAddAlert(){
        presentAlert(title: "New Add",
                     message: nil,
                     defaultButtonTitle: "Add",
                     defaulButtonHandler: { _ in
            let text = self.alertController.textFields?.first?.text
            if text != ""
            {
                self.data.append(text!)
                self.tableView.reloadData()
            }
            else{
                self.presentWarningAlert()
            }
        },
                     cancelButtonTitle: "Cancel",
                     isTextFieldAvaible: true)
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      preferedStyle: UIAlertController.Style = .alert,
                      defaultButtonTitle: String? = nil,
                      defaulButtonHandler: ((UIAlertAction)-> Void)? = nil,
                      cancelButtonTitle: String?,
                      isTextFieldAvaible: Bool = false){
        
         alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
      
        
       cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .destructive)
        if defaultButtonTitle != nil {
            defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default ,
                                              handler: defaulButtonHandler)
            alertController.addAction(defaultButton)
        }
        if isTextFieldAvaible {
            alertController.addTextField()
        }
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
        
    }
    func presentWarningAlert(){
        presentAlert(title: "Warning",
                     message: "List Should Not Empty",
                     cancelButtonTitle: "Close")
        
    }
    
}

