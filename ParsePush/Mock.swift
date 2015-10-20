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
            let text1 = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \(i)"
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