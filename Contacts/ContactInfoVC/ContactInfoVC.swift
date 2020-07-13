//
//  ContactInfoVC.swift
//  Contacts
//
//  Created by Madi Kabdrash on 7/7/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation
import SnapKit

class ContactInfoVC: UIViewController {
    
    private var firstNameTextField = UITextField()
    private var lastNameTextField = UITextField()
    private var phoneTextField = UITextField()
    private let firstNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.text = "First Name:"
        return label
    }()
    private let lastNameLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.text = "Last Name:"
        return label
    }()
    private let phoneLabel: UILabel = {
        var label = UILabel()
        label.textColor = .systemBlue
        label.text = "Phone:"
        return label
    }()
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private var contactId: Int?
    
    let viewModel: ViewModelContactInfo
    weak var delegate: ContactDetailDelegate?
    
    init(contact: ContactDetails) {
        self.viewModel = ViewModelContactInfo(contact: contact)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        phoneTextField.delegate = self
        
        addElements()
        
        self.view.backgroundColor = .white
        
        firstNameTextField.text = viewModel.contact.firstName
        lastNameTextField.text = viewModel.contact.lastName
        lastNameTextField.placeholder = "Last Name"
        phoneTextField.text = viewModel.contact.number
        phoneTextField.placeholder = "Phone number"
        contactId = viewModel.contact.id!

    }

    func addElements(){
        
        view.addSubview(firstNameLabel)
        view.addSubview(firstNameTextField)
        view.addSubview(lastNameLabel)
        view.addSubview(lastNameTextField)
        view.addSubview(phoneLabel)
        view.addSubview(phoneTextField)
        view.addSubview(saveButton)
        
        firstNameTextField.borderStyle = .roundedRect
        lastNameTextField.borderStyle = .roundedRect
        phoneTextField.borderStyle = .roundedRect
        
        firstNameTextField.isUserInteractionEnabled = false
        lastNameTextField.isUserInteractionEnabled = false
        phoneTextField.isUserInteractionEnabled = false
        
        firstNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        firstNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        lastNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        lastNameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        phoneLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(5)
        }
        saveButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(15)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    @objc func editButtonPressed(){
        firstNameTextField.isUserInteractionEnabled = true
        lastNameTextField.isUserInteractionEnabled = true
        phoneTextField.isUserInteractionEnabled = true
        firstNameTextField.becomeFirstResponder()
    }
    
    @objc func saveButtonPressed(){
        delegate?.saveDetails(firstName: firstNameTextField.text ?? "", lastName: lastNameTextField.text ?? "", phone: phoneTextField.text ?? "", id: contactId!)
        navigationController?.popViewController(animated: true)
    }
}

extension ContactInfoVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            firstNameTextField.resignFirstResponder()
        } else if textField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
        } else {
            phoneTextField.resignFirstResponder()
        }
        return true
    }
}

protocol ContactDetailDelegate: class {
    func saveDetails(firstName: String, lastName: String, phone: String, id: Int)
}
