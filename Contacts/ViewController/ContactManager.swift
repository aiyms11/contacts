//
//  ContactManager.swift
//  Contacts
//
//  Created by Madi Kabdrash on 7/3/20.
//  Copyright © 2020 Aiyms. All rights reserved.
//

import Foundation

struct ContactManager {
    
    func getFirstSymbol(word: String) -> Character {
        return word[word.startIndex]
    }

    func createTableData(contactList: [ContactDetails]) -> (firstSymbols: [Character], source: [Character : [ContactDetails]]) {

        var firstSymbols = Set<Character>()

        contactList.forEach { firstSymbols.insert(getFirstSymbol(word: $0.firstName)) }

        var tableViewSourse = [Character : [ContactDetails]]()
        for symbol in firstSymbols {

            var contacts = [ContactDetails]()

            for contact in contactList {
                if symbol == getFirstSymbol(word: contact.firstName) {
                    contacts.append(contact)
                }
            }

            contacts.sort {
              ($0.firstName, $0.lastName ?? "") <
                ($1.firstName, $1.lastName ?? "")
            }
            tableViewSourse[symbol] = contacts
        }

        let sortedSymbols = firstSymbols.sorted(by: {$0 < $1})

        return (sortedSymbols, tableViewSourse)
    }

}

class ViewModelCM {
    var tableViewSource: [Character : [ContactDetails]]?
    var tableViewHeaders: [Character]?
    
    var contactManager = ContactManager()
    
    var updateTableContent: (() -> Void)?
    var createContact: (() -> Void)?
    
    var contactIndex: Int?
    var sectionHeader: Character?
    
    var firstName: String?
    var lastName: String?
    var phone: String?
    
    func getTableData(contacts: [ContactDetails]) {
        tableViewSource = contactManager.createTableData(contactList: contacts).source
        tableViewHeaders = contactManager.createTableData(contactList: contacts).firstSymbols
        updateTableContent?()
    }
    
    func changeContact(_ firstname: String, _ lastname: String, _ phone: String) {
        self.firstName = nil
        self.lastName = nil
        self.phone = nil
        if let header = sectionHeader, let index = contactIndex {
            if header == contactManager.getFirstSymbol(word: firstname){
                tableViewSource?[header]?[index].firstName = firstname
                tableViewSource?[header]?[index].lastName = lastname
                tableViewSource?[header]?[index].number = phone
                contactIndex = nil
                sectionHeader = nil
                updateTableContent?()
            } else {
                tableViewSource?[header]?.remove(at: index)
                self.firstName = firstname
                self.lastName = lastname
                self.phone = phone
                createContact?()
                updateTableContent?()
            }
        }
    }
}

