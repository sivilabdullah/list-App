//
//  ViewController.swift
//  list app
//
//  Created by abdullah's Monterey  on 1.11.2022.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    var alertController = UIAlertController()
    var cancelButton = UIAlertAction()
    var defaultButton = UIAlertAction()
    @IBOutlet weak var tableView: UITableView!
    var data = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        fetch()
        // tableView.backgroundView?.contentMode = .scaleAspectFill
        
    }
    
    
    
    
    @IBAction func didTapDeleteBarBtn(_ sender: UIBarButtonItem) {
     
        presentAlert(title: "Warning",
                     message: "The entire list will be deleted, do you agree?",
                     preferedStyle: .alert,
                     defaultButtonTitle: "Delete",
                     defaulButtonHandler: { _ in
            
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            
            if managedObjectContext != nil {
                for object in self.data
                {
                    managedObjectContext!.delete(object)
                    try?  managedObjectContext?.save()
                    self.tableView.reloadData()
                }
            }
            else
            {
                self.presentWarningAlert()
            }
            
        },
                     cancelButtonTitle: "Cancel",
                     isTextFieldAvaible: false)
        
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
                //self.data.append(text!)
                //veritabani erisimi
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                let managedObjectContext = appDelegate?.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "ListItem", in: managedObjectContext!)
                
                let listItem = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
                listItem.setValue(text, forKey: "value")
                
                try? managedObjectContext?.save()
                
                self.fetch()
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
    
    func fetch() {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedObjectContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")
        data = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        let listItem = data[indexPath.row]
        cell.textLabel?.text = listItem.value(forKey: "value") as? String
        
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction =  UIContextualAction(style: .normal,
                                               title: "Delete") { _, _, _ in
            //silme
            //self.data.remove(at: indexPath.row)
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            let managedObjectContext = appDelegate?.persistentContainer.viewContext
            managedObjectContext?.delete(self.data[indexPath.row])
            try?  managedObjectContext?.save()
            self.fetch()
        }
        deleteAction.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            
            self.presentAlert(title: "Warning!",
                              message: "Do you want edit this text?",
                              defaultButtonTitle: "OK",
                              defaulButtonHandler: { _ in
                let text = self.alertController.textFields?.first?.text
                if text != ""
                {
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    let managedObjectContext = appDelegate?.persistentContainer.viewContext
                    self.data[indexPath.row].setValue(text, forKey: "value")
                    if managedObjectContext!.hasChanges{
                        try? managedObjectContext?.save()
                    }
                    self.tableView.reloadData()
                }
                else{
                    self.presentWarningAlert()
                }
            },
                              cancelButtonTitle: "Cancel",
                              isTextFieldAvaible: true)
            
        }
        let config = UISwipeActionsConfiguration(actions: [editAction])
        return config
    }
    
}

