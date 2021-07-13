//
//  AnotherConfiguration.swift
//  EvolvSwiftSDK
//
//  Created by user on 12.07.21.
//

import Foundation

public var configurationData: Foundation.Data?


// MARK: - Configuration
public struct Configuration: Decodable, EvolvConfig {
    public let published: Float
    public let client: Client
    public let experiments: [Experiment]

    enum CodingKeys: String, CodingKey {
        case published = "_published"
        case client = "_client"
        case experiments = "_experiments"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        published = try container.decode(Float.self, forKey: .published)
        client = try container.decode(Client.self, forKey: .client)
        experiments = try container.decode([Experiment].self, forKey: .experiments)
    }
}

// MARK: - Client
public struct Client: Codable {
    public let browser, device, location, platform: String
}

// MARK: - Experiment
public struct Experiment: Decodable {
    public var experimentKeys: DecodedArrayOfExperimentKeys.DecodedArray?
    public let predicate: ExperimentPredicate?
    public let id: String?
    public let paused: Bool?

    enum CodingKeys: String, CodingKey {
        case predicate = "_predicate"
        case paused = "_paused"
        case id
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        predicate = try container.decode(ExperimentPredicate.self, forKey: CodingKeys.predicate)
        paused = try container.decode(Bool.self, forKey: CodingKeys.paused)
        id = try container.decode(String.self, forKey: CodingKeys.id)

        guard let configurationData = configurationData else {
            return
        }
        experimentKeys = try JSONDecoder().decode(DecodedArrayOfExperimentKeys.self, from: configurationData).arrayOfKeys
    }
}

public struct DecodedArrayOfExperimentKeys: Decodable {

    public typealias DecodedArray = [ExperimentKey]

    public var arrayOfKeys = DecodedArray()

    public struct DynamicCodingKeys: CodingKey {

        public var stringValue: String
        public init?(stringValue: String) {
            self.stringValue = stringValue
        }

        public var intValue: Int?
        public init?(intValue: Int) {
            return nil
        }
    }

    public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)
        var tempArray = [ExperimentKey]()

        // here must be dynamic keys
        for key in container.allKeys {
            print("Key \(key)")

            let decodedObject = try container.decode(ExperimentKey.self, forKey: DynamicCodingKeys.init(stringValue: key.stringValue)!)
            print("Decoded object: \(decodedObject)")
            tempArray.append(decodedObject)
        }
        arrayOfKeys = tempArray
    }
}

public class ExperimentKey: Decodable {
    public var isEntryPoint: Bool?
    public var predicate: ExperimentPredicate?
    public var values: Bool? = nil
    public var initializers: Bool?
    public var dependencies: String? = nil
    public var experimentKeys: DecodedArrayOfExperimentKeys?

    public let experimentKeyId: String


    enum CodingKeys: String, CodingKey {
        case isEntryPoint = "_is_entry_point"
        case predicate = "_predicate"
        case values = "_values"
        case initializers = "_initializers"
        case dependencies
    }

    required public init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let isEntryPoint = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.isEntryPoint) {
            self.isEntryPoint = isEntryPoint
        }
        if let values = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.values) {
            self.values = values
        }
        if let initializers = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.initializers) {
            self.initializers = initializers
        }
        if let dependencies = try container.decodeIfPresent(String.self, forKey: CodingKeys.dependencies) {
            self.dependencies = dependencies
        }
        if let predicate = try container.decodeIfPresent(ExperimentPredicate.self, forKey: CodingKeys.predicate) {
            self.predicate = predicate
        }
        experimentKeyId = container.codingPath.first!.stringValue

        guard let configurationData = configurationData else {
            return
        }
        experimentKeys = try JSONDecoder().decode(DecodedArrayOfExperimentKeys.self, from: configurationData)
    }
}


// MARK: - Rule
public struct Rule: Decodable {
    public let field: String?
    public let ruleOperator: RuleOperator?
    public let value: String?

    public let combinator: String?
    public let rules: [Rule]?

    enum CodingKeys: String, CodingKey {
        case field
        case ruleOperator = "operator"
        case value
        case combinator
        case rules
    }

    public enum RuleOperator: String, Codable {
            case equal = "equal"
            case notEqual = "not_equal"
            case contains = "contains"
            case notContains = "not_contains"
            case exists
            case regexMatch = "regex64_match"
            case notRegexMatch = "not_regex_match"
        }
}


public struct CompoundRule: Decodable {
    enum Combinator: String, Decodable {
        case and
        case or
    }

    let id: String
    let combinator: Combinator
    let rules: [EvolvQuery]
}

public enum EvolvQuery: Decodable {

    case rule(Rule)
    case compoundRule(CompoundRule)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let rule = try? container.decode(Rule.self) {
            self = .rule(rule)
        } else if let compoundRule = try? container.decode(CompoundRule.self) {
            self = .compoundRule(compoundRule)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Mismatched Types")
        }
    }

    static func evaluate(_ expression: EvolvQuery, context: [String: String]) -> Bool {
        switch expression {
        case .rule(let rule):
            switch (rule.ruleOperator, rule.value) {
            case (.exists, let value as String):
                return context.keys.contains(where: { $0 == value })
            case (.equal, let values as [String]) where values.count > 1:
                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] == values[1]
            case (.notEqual, let values as [String]) where values.count > 1:
                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] != values[1]
            case (.contains, let values as [String]) where values.count > 1:
                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) })
            case (.notContains, let values as [String]) where values.count > 1:
                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) == false })
            default:
                return true
            }
        case .compoundRule(let compoundRule):
            guard compoundRule.rules.isEmpty == false else {
                return true
            }

            let results = compoundRule.rules.map({ evaluate($0, context: context) })

            switch compoundRule.combinator {
            case .and:
                return !results.contains(false)
            case .or:
                return results.contains(true)
            }
        }
    }

}

// MARK: - ExperimentPredicate
public struct ExperimentPredicate: Decodable {
    public let id: Int?
    public let combinator: String?
    public let rules: [Rule]?
}


extension DecodedArrayOfExperimentKeys: Collection, Sequence {

    // Required nested types, that tell Swift what our collection contains
    public typealias Index = DecodedArray.Index
    public typealias Element = DecodedArray.Element

    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index { return arrayOfKeys.startIndex }
    public var endIndex: Index { return arrayOfKeys.endIndex }

    // Required subscript, based on a dictionary index
    public subscript(index: Index) -> Iterator.Element {
        get { return arrayOfKeys[index] }
    }

    // Method that returns the next index when iterating
    public func index(after i: Index) -> Index {
        return arrayOfKeys.index(after: i)
    }
}
