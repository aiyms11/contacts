import Foundation

class ContactsSingleton {
    static let shared = ContactsSingleton()
    
    var globalContactId: Int
    var contacts: [ContactDetails]
    
    private init() {
        globalContactId = 0
        contacts = []
    }
    
    func incrementId() {
        globalContactId = globalContactId + 1
    }
    
    func addContact(_ newContact: ContactDetails) {
        var contact = newContact
        contact.id = globalContactId
        incrementId()
        contacts.append(contact)
    }
    
    func updateContact(_ updatedContact: ContactDetails) {
        for (index, contact) in contacts.enumerated() {
            if contact.id == updatedContact.id {
                contacts[index].firstName = updatedContact.firstName
                contacts[index].lastName = updatedContact.lastName
                contacts[index].number = updatedContact.number
            }
        }
    }
    
    func deleteContact(_ deleteContact: ContactDetails){
        for (index, contact) in contacts.enumerated() {
            if contact.id == deleteContact.id {
                contacts.remove(at: index)
            }
        }
    }
    
    func getContacts() -> [ContactDetails] {
        return contacts
    }
}
