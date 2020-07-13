import UIKit
import SnapKit
import SwipeCellKit

class ViewController: UIViewController {
    private let contactsSingleton = ContactsSingleton.shared

    private var tableView = UITableView()
    private var viewModelCM = ViewModelCM()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Contacts"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addContact))
        self.view.backgroundColor = .white
        
        addTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModelCM.updateTableContent = {
            self.tableView.reloadData()
        }

        contactsSingleton.addContact(ContactDetails(firstName: "Aiym", lastName: "Sarsenbayeva", number: "+77011007447"))
        contactsSingleton.addContact(ContactDetails(firstName: "Madi", number: "+77011000000"))
        contactsSingleton.addContact(ContactDetails(firstName: "Sanya", lastName: "Kim", number: "+77011001111"))
        contactsSingleton.addContact(ContactDetails(firstName: "Aizhan", number: "+77011001100"))
        contactsSingleton.addContact(ContactDetails(firstName: "Karlygash", number: "+77011001100"))
        contactsSingleton.addContact(ContactDetails(firstName: "Farkhad", number: "+77011001100"))

        viewModelCM.getTableData(contacts: contactsSingleton.getContacts())
    }
    
    func addTableView(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func addContact(){
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add name", message: "Please enter firstname", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.contactsSingleton.addContact(ContactDetails(firstName: textfield.text!))
            self.viewModelCM.getTableData(contacts: self.contactsSingleton.getContacts())
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Firstname"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }


}
//MARK: - Table View Data Source
extension ViewController: UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModelCM.tableViewHeaders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionHeader = viewModelCM.tableViewHeaders?[section] else {  return "" }
        return String(sectionHeader)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionHeader = viewModelCM.tableViewHeaders?[section]{
            if let sectionData = viewModelCM.tableViewSource?[sectionHeader] {
                return sectionData.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        if let sectionHeader = viewModelCM.tableViewHeaders?[indexPath.section]{
            if let sectionData = viewModelCM.tableViewSource?[sectionHeader] {
                cell.textLabel?.text = sectionData[indexPath.row].firstName
            }
        }
        return cell
    }
    
}

//MARK: - Table View Delegate
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("pressed cell at index \(indexPath)")
        if let sectionHeader = viewModelCM.tableViewHeaders?[indexPath.section]{
            if let sectionData = viewModelCM.tableViewSource?[sectionHeader] {
                let contactInfoVC = ContactInfoVC(contact: sectionData[indexPath.row])
                contactInfoVC.delegate = self
                self.navigationController?.pushViewController(contactInfoVC, animated: true)
            }
        }
        
    }
}
//MARK: - Swipe Table View Delegate
extension ViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            if let sectionHeader = self.viewModelCM.tableViewHeaders?[indexPath.section]{
                if let sectionData = self.viewModelCM.tableViewSource?[sectionHeader] {
                    let contact = sectionData[indexPath.row]
                    self.contactsSingleton.deleteContact(contact)
                    self.viewModelCM.getTableData(contacts: self.contactsSingleton.getContacts())
                }
            }
        }
        // customize the action appearance
        deleteAction.image = UIImage(systemName: "trash")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
}
//MARK: - Contact Detail Delegate
extension ViewController: ContactDetailDelegate{
    func saveDetails(firstName: String, lastName: String, phone: String, id: Int) {
        let contact = ContactDetails(firstName: firstName, lastName: lastName, number: phone, id: id)
        contactsSingleton.updateContact(contact)
        viewModelCM.getTableData(contacts: self.contactsSingleton.getContacts())
    }
}



