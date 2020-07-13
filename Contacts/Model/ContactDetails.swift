import Foundation

struct ContactDetails {
    var firstName: String
    var lastName: String?
    var number: String?
    var id: Int?
}

extension ContactDetails : Comparable {
  static func == (lhs: ContactDetails, rhs: ContactDetails) -> Bool {
    return (lhs.firstName, lhs.lastName) ==
             (rhs.firstName, rhs.lastName)
  }

  static func < (lhs: ContactDetails, rhs: ContactDetails) -> Bool {
    let lhsLastName = lhs.lastName ?? ""
    let rhsLastName = rhs.lastName ?? ""
    return (lhsLastName, lhs.firstName) <
             (rhsLastName, rhs.firstName)
  }
}
