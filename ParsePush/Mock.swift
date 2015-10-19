//
//  Mock.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/14/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class Mock {
    
    static func getProcedures() -> [Procedure]
    {
        var procedures = [Procedure]()
        for i in 1...20
        {
            let code = "CODE\(i)"
            let title = "Test\(i)"
            let text1 = "This is the description for test \(i)"
            let p = getNewProcedure(i, code: code, title: title, text1: text1)
            procedures.append(p)
        }
        return procedures
    }
    
    static private func getNewProcedure(id: Int, code: String, title: String, text1: String) -> Procedure
    {
        let procedure = Procedure()
        procedure.id = id
        procedure.title = title
        procedure.code = code
        procedure.text1 = text1
        return procedure
    }
}