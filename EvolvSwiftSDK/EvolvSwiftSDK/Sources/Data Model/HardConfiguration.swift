//
//  HardConfiguration.swift
//  EvolvSwiftSDK
//
//  Created by user on 13.07.21.
//

//import Foundation
//
//// MARK: - Configuration
//public struct Configuration: Decodable, EvolvConfig {
//    public let published: Float
//    public let client: Client
//    public let experiments: [Experiment]
//
//    enum CodingKeys: String, CodingKey {
//        case published = "_published"
//        case client = "_client"
//        case experiments = "_experiments"
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        published = try container.decode(Float.self, forKey: .published)
//        client = try container.decode(Client.self, forKey: .client)
//        experiments = try container.decode([Experiment].self, forKey: .experiments)
//    }
//}
//
//// MARK: - Client
//public struct Client: Codable {
//    public let browser, device, location, platform: String
//}
//
//// MARK: - Experiment
//public struct Experiment: Decodable {
//    public let predicate: ExperimentPredicate?
//    public let id: String?
//    public let paused: Bool?
//
//    public var firstExperimentKey: ExperimentKey?
//    public var secondExperimentKey: ExperimentKey?
//    public var thirdExperimentKey: ExperimentKey?
//    public var fourthExperimentKey: ExperimentKey?
//    public var fivthExperimentKey: ExperimentKey?
//
//    enum CodingKeys: String, CodingKey {
//        case predicate = "_predicate"
//        case paused = "_paused"
//        case id
//
//        case web, home, next
//        case buttonColor = "button_color"
//        case ctaText = "cta_text"
//    }
//
//    public init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        predicate = try container.decode(ExperimentPredicate.self, forKey: CodingKeys.predicate)
//        paused = try container.decode(Bool.self, forKey: CodingKeys.paused)
//        id = try container.decode(String.self, forKey: CodingKeys.id)
//
//        if let firstExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.web) {
//            self.firstExperimentKey = firstExperimentKey
//        }
//        if let secondExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.home) {
//            self.secondExperimentKey = secondExperimentKey
//        }
//        if let thirdExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.next) {
//            self.thirdExperimentKey = thirdExperimentKey
//        }
//        if let fourthExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.buttonColor) {
//            self.fourthExperimentKey = fourthExperimentKey
//        }
//        if let fivthExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.ctaText) {
//            self.fivthExperimentKey = fivthExperimentKey
//        }
//    }
//}
//
//public class ExperimentKey: Decodable {
//    public var isEntryPoint: Bool?
//    public var predicate: ExperimentPredicate?
//    public var values: Bool? = nil
//    public var initializers: Bool?
//    public var dependencies: String? = nil
//
//    public var firstExperimentKey: ExperimentKey?
//    public var secondExperimentKey: ExperimentKey?
//    public var thirdExperimentKey: ExperimentKey?
//    public var fourthExperimentKey: ExperimentKey?
//    public var fivthExperimentKey: ExperimentKey?
//
//    enum CodingKeys: String, CodingKey {
//        case isEntryPoint = "_is_entry_point"
//        case predicate = "_predicate"
//        case values = "_values"
//        case initializers = "_initializers"
//        case dependencies
//
//        case layout
//        case ctaText = "cta_text"
//        case firstInner = "o7b7msnxd"
//
//        case anotherFirstInner = "21zti3xj5"
//        case anotherSecondInner = "hlvg8909z"
//    }
//
//    required public init(from decoder: Decoder) throws {
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        if let isEntryPoint = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.isEntryPoint) {
//            self.isEntryPoint = isEntryPoint
//        }
//        if let values = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.values) {
//            self.values = values
//        }
//        if let initializers = try container.decodeIfPresent(Bool.self, forKey: CodingKeys.initializers) {
//            self.initializers = initializers
//        }
//        if let dependencies = try container.decodeIfPresent(String.self, forKey: CodingKeys.dependencies) {
//            self.dependencies = dependencies
//        }
//        if let predicate = try container.decodeIfPresent(ExperimentPredicate.self, forKey: CodingKeys.predicate) {
//            self.predicate = predicate
//        }
//
//        if let firstExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.layout) {
//            self.firstExperimentKey = firstExperimentKey
//        }
//        if let secondExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.ctaText) {
//            self.secondExperimentKey = secondExperimentKey
//        }
//        if let thirdExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.firstInner) {
//            self.thirdExperimentKey = thirdExperimentKey
//        }
//        if let fourthExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.anotherFirstInner) {
//            self.fourthExperimentKey = fourthExperimentKey
//        }
//        if let fivthExperimentKey = try container.decodeIfPresent(ExperimentKey.self, forKey: CodingKeys.anotherSecondInner) {
//            self.fivthExperimentKey = fivthExperimentKey
//        }
//    }
//}
//
//
//// MARK: - Rule
//public struct Rule: Decodable {
//    public let field: String?
//    public let ruleOperator: RuleOperator?
//    public let value: String?
//
//    public let combinator: String?
//    public let rules: [Rule]?
//
//    enum CodingKeys: String, CodingKey {
//        case field
//        case ruleOperator = "operator"
//        case value
//        case combinator
//        case rules
//    }
//
//    public enum RuleOperator: String, Codable {
//            case equal = "equal"
//            case notEqual = "not_equal"
//            case contains = "contains"
//            case notContains = "not_contains"
//            case exists
//            case regexMatch = "regex64_match"
//            case notRegexMatch = "not_regex_match"
//        }
//}
//
//
//public struct CompoundRule: Decodable {
//    enum Combinator: String, Decodable {
//        case and
//        case or
//    }
//
//    let id: String
//    let combinator: Combinator
//    let rules: [EvolvQuery]
//}
//
//public enum EvolvQuery: Decodable {
//
//    case rule(Rule)
//    case compoundRule(CompoundRule)
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//
//        if let rule = try? container.decode(Rule.self) {
//            self = .rule(rule)
//        } else if let compoundRule = try? container.decode(CompoundRule.self) {
//            self = .compoundRule(compoundRule)
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Mismatched Types")
//        }
//    }
//
//    static func evaluate(_ expression: EvolvQuery, context: [String: String]) -> Bool {
//        switch expression {
//        case .rule(let rule):
//            switch (rule.ruleOperator, rule.value) {
//            case (.exists, let value as String):
//                return context.keys.contains(where: { $0 == value })
//            case (.equal, let values as [String]) where values.count > 1:
//                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] == values[1]
//            case (.notEqual, let values as [String]) where values.count > 1:
//                return context.keys.contains(where: { $0 == values[0] }) && context[values[0]] != values[1]
//            case (.contains, let values as [String]) where values.count > 1:
//                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) })
//            case (.notContains, let values as [String]) where values.count > 1:
//                return context.contains(where: { $0.key == values[0] && $0.value.contains(values[1]) == false })
//            default:
//                return true
//            }
//        case .compoundRule(let compoundRule):
//            guard compoundRule.rules.isEmpty == false else {
//                return true
//            }
//
//            let results = compoundRule.rules.map({ evaluate($0, context: context) })
//
//            switch compoundRule.combinator {
//            case .and:
//                return !results.contains(false)
//            case .or:
//                return results.contains(true)
//            }
//        }
//    }
//
//}
//
//// MARK: - ExperimentPredicate
//public struct ExperimentPredicate: Decodable {
//    public let id: Int?
//    public let combinator: String?
//    public let rules: [Rule]?
//}
