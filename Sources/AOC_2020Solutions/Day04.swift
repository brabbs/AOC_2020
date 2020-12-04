//
//  Day04.swift
//  
//  Template for the solution to a particular day of Advent of Code

import Foundation

struct Day04: Solution {
    let identityDocumentData: [String]

    init(input: String) {
        identityDocumentData = time {
            input.components(separatedBy: "\n\n")
        }
    }

    func first() -> Any {
        time {
            identityDocumentData
                .map { IdentitiyDocument(rawString: $0, checkValues: false) }
                .count { $0.isValid() }
        }
    }

    func second() -> Any {
        time {
            identityDocumentData
                .map { IdentitiyDocument(rawString: $0, checkValues: true) }
                .count { $0.isValid() }
        }
    }
}

extension Day04 {
    struct IdentitiyDocument {
        let credentials: Set<Credential>

        init(rawString: String, checkValues: Bool) {
            let credentialPairs = rawString
                .split(separator: "\n")
                .flatMap { $0.split(separator: " ") }
            if checkValues {
                let credentialArray = credentialPairs
                    .map(String.init)
                    .compactMap(Credential.init(keyValuePair:))
                credentials = Set(credentialArray)
            } else {
                let credentialKeys = credentialPairs
                    .map { String($0.split(separator: ":")[0]) }
                    .compactMap(Credential.init(fieldName:))
                credentials = Set(credentialKeys)
            }
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

        init?(keyValuePair: String) {
            let components = keyValuePair.components(separatedBy: ":")
            let fieldName = components[0]
            let value = components[1]
            if let credential = Credential(fieldName: fieldName), credential.validator(value) {
                self = credential
            } else {
                return nil
            }
        }

        var validator: Validator {
            switch self {
            case .birthYear: return Self.isValidBirthYear
            case .issueYear: return Self.isValidIssueYear
            case .expirationYear: return Self.isValidExpirationYear
            case .height: return Self.isValidHeight
            case .hairColor: return Self.isValidHairColor
            case .eyeColor: return Self.isValidEyeColour
            case .passportID: return Self.isValidPassportID
            case .countryID: return Self.isValidCountryID
            }
        }

        typealias Validator = (String) -> Bool
        static let isValidBirthYear: Validator = yearInRange(1920, 2002)
        static let isValidIssueYear: Validator = yearInRange(2010, 2020)
        static let isValidExpirationYear: Validator = yearInRange(2020, 2030)
        static let isValidHeight: Validator = { (heightString: String) in
            guard let value = Int(heightString.dropLast(2)) else { return false }
            let units = heightString.suffix(2)
            switch units {
            case "cm": return 150 <= value && value <= 193
            case "in": return 59 <= value && value <= 76
            default: return false
            }
        }
        static let isValidHairColor: Validator = { (hairColorString: String) in
            try! hairColorString.firstMatch("^#[0-9a-f]{6}$") != nil
        }
        static let isValidEyeColour: Validator = { (eyeColor: String) in
            ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].contains(eyeColor)
        }
        static let isValidPassportID: Validator = { (passportID: String) in
            try! passportID.firstMatch("^[0-9]{9}$") != nil
        }
        static let isValidCountryID: Validator = { _ in true }

        static func yearInRange(_ min: Int, _ max: Int) -> Validator {
            return { (value: String) in
                guard let year = Int(value) else { return false }
                return min <= year && year <= max
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
