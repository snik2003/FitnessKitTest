//
//  GetServerDataOperation.swift
//  FitnessKitTest
//
//  Created by Сергей Никитин on 25/02/2020.
//  Copyright © 2020 Snik2003. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class GetServerDataOperation: AsyncOperation {
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    private var url: String
    private var parameters: Parameters?
    private var method: HTTPMethod
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(url: String, parameters: Parameters? = nil, method: HTTPMethod, headers: [String: String]) {
        self.url = url
        self.parameters = parameters
        self.method = method
        
        request = Alamofire.request(self.url, method: self.method, parameters: self.parameters, headers: headers)
    }
    
    init(url: String, parameters: Parameters? = nil, method: HTTPMethod, headers: [String: String], encoding: ParameterEncoding) {
        
        self.url = url
        self.parameters = parameters
        self.method = method
        
        request = Alamofire.request(self.url, method: self.method, parameters: self.parameters, encoding: encoding, headers: headers)
    }
}
