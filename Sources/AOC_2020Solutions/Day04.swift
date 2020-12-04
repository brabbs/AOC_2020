//
//  Day04.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day04: Solution {
    let identityDocuments: [IdentitiyDocument]

    init(input: String) {
        identityDocuments = time {
            input.components(separatedBy: "\n\n").map(IdentitiyDocument.init)
        }
    }

    func first() -> Any {
        time { identityDocuments.count { $0.isValid() } }
    }

    func second() -> Any {
        "Second answer not yet implemented"
    }
}

extension Day04 {
    struct IdentitiyDocument {
        let credentials: Set<Credential>

        init(rawString: String) {
            let credentialPairs = rawString
                .split(separator: "\n")
                .flatMap { $0.split(separator: " ") }
            let credentialKeys = credentialPairs
                .map { String($0.split(separator: ":")[0]) }
                .compactMap(Credential.init(fieldName:))
            credentials = Set(credentialKeys)
        }

        func isValid() -> Bool {
            Credential.northPoleCredentials.isSubset(of: credentials)
        }
    }
}

extension Day04.IdentitiyDocument {
    enum Credential: CaseIterable {
        case birthYear
        case issueYear
        case expirationYear
        case height
        case hairColor
        case eyeColor
        case passportID
        case countryID

        init?(fieldName: String) {
            switch fieldName {
            case "byr": self = .birthYear
            case "iyr": self = .issueYear
            case "eyr": self = .expirationYear
            case "hgt": self = .height
            case "hcl": self = .hairColor
            case "ecl": self = .eyeColor
            case "pid": self = .passportID
            case "cid": self = .countryID
            default: return nil
            }
        }

        static let northPoleCredentials: Set<Credential> = {
            // North Pole credentials has everything a passport has apart from the country ID
            var credentials = Set(Credential.allCases)
            credentials.remove(.countryID)
            return credentials
        }()
    }
}
