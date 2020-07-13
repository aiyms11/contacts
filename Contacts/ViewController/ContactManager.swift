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

    func getTableData(contacts: [ContactDetails]) {
        tableViewSource = contactManager.createTableData(contactList: contacts).source
        tableViewHeaders = contactManager.createTableData(contactList: contacts).firstSymbols
        updateTableContent?()
    }
}

