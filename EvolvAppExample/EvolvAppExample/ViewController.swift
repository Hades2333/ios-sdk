//
//  ViewController.swift
//  EvolvAppExample
//
//  Created by Aliaksandr Dvoineu on 31.05.21.
//

import UIKit
import Combine
import EvolvSwiftSDK

class ViewController: UIViewController {
    
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = HttpConfig.configurationURL()
        cancellable = EvolvAPI.fetchData(for: url)
            .catch {(error: HTTPError) -> Just<String?> in
                print("\(error.localizedDescription)")
                return Just(nil)
            }
            .sink { [weak self] in
                if let body = $0 {
                    print(body)
                    do {
                        let data = body.data(using: .utf8)!
                        configurationData = data
                        
                        let configuration = try JSONDecoder().decode(Configuration.self, from: data)
                        print("Configuration is: \(configuration)")

//                        let keys = self?.getKeys(from: configuration)
//                        print("Keys: \(keys)")
                        
                    } catch let DecodingError.dataCorrupted(context) {
                        print(context)
                    } catch let DecodingError.keyNotFound(key, context) {
                        print("Key '\(key)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.valueNotFound(value, context) {
                        print("Value '\(value)' not found:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch let DecodingError.typeMismatch(type, context)  {
                        print("Type '\(type)' mismatch:", context.debugDescription)
                        print("codingPath:", context.codingPath)
                    } catch {
                        print("error: ", error)
                    }
                }
            }
    }

    // MARK: Methods

//    func getKeys(from configuration: Configuration) -> [String: ExperimentKey] {
//        var keysDictionary = [String: ExperimentKey]()
//        configuration.experiments.forEach { experiment in
//
//        }
//        return keysDictionary
//    }
}

