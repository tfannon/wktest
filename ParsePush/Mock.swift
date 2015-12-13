//
//  Mock.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/14/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import Foundation

class Mock {
    

    private static var initialized = false
    
    static func initialize() {
        if !initialized {
            initialized = true
            Services.clearStore()
            for i in 1...20
            {
                let code = "CODE\(i)"
                let title = "Test\(i)"
                let text1 = "<html><head></head><body style='font-family:Helvetica;font-size:14pt'><h1>Important</h1>Lorem Ipsum is simply dummy text of the <span style='font-family:Brush Script MT, cursive;font-size:150%'>printing and typesetting</span> industry. <span style='color:red'>Lorem Ipsum</span> has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type <u>specimen book</u>. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. \(i)</body></html>"
                let _ = createNewProcedure(i, code: code, title: title, text1: text1)
            }
        }
    }
    
    static private func createNewProcedure(id: Int, code: String, title: String, text1: String) -> Procedure
    {
        let extensions = ["docx", "xlsx", "pdf", "ppt"]
        
        let procedure = Procedure()
        
        procedure.id = id
        procedure.title = title
        procedure.code = code
        procedure.text1 = text1.stringByReplacingOccurrencesOfString("Important", withString: "text1")
        procedure.tester = "Bob Dylan"
        procedure.reviewer = "Bronson Pichot"
        procedure.reviewDueDate = NSDate(fromString: "2015-10-30", format: DateFormat.ISO8601(.Date))
        procedure.dueDate = NSDate(fromString: "2015-11-30", format: DateFormat.ISO8601(.Date))
        let text2 = text1.stringByReplacingOccurrencesOfString("Important", withString: "text2")
        procedure.text2 = text2 + text2 + text2 + text2
        procedure.text3 = text1.stringByReplacingOccurrencesOfString("Important", withString: "text3")
        procedure.text4 = text1.stringByReplacingOccurrencesOfString("Important", withString: "text4")
        procedure.resultsText1 = text1.stringByReplacingOccurrencesOfString("Important", withString: "rtext1")
        procedure.resultsText2 = text1.stringByReplacingOccurrencesOfString("Important", withString: "rtext2")
        procedure.resultsText3 = text1.stringByReplacingOccurrencesOfString("Important", withString: "rtext3")
        procedure.resultsText4 = text1.stringByReplacingOccurrencesOfString("Important", withString: "rtext4")
        procedure.allowedStates = [1, 2, 3, 5]
        procedure.parentTitle = "Procedure \(id)'s Parent"
        procedure.parentType = [ObjectType.Risk, ObjectType.Control][Int(arc4random_uniform(2))].rawValue
        
        for i in 0...3 {
            let wp = Workpaper()
            wp.id = id * 100 + i
            wp.title = "Workpaper \(wp.id!)"
            wp.workflowState = i % 4 + 1
            wp.attachmentExtension = extensions[i % extensions.count]
            wp.parentTitle = procedure.title
            wp.parentType = ObjectType.Procedure.rawValue
            wp.reviewDueDate = NSDate(fromString: "2015-10-30", format: DateFormat.ISO8601(.Date))
            wp.dueDate = NSDate(fromString: "2015-11-30", format: DateFormat.ISO8601(.Date))
            Services.saveObject(wp, parent: procedure, log: true)
        }
        
        for i in 0...3 {
            let iss = Issue()
            iss.id = id * 100 + i
            iss.title = "Issue \(iss.id!)"
            iss.workflowState = i % 4 + 1
            iss.allowedStates = [1, 2, 3, 4]
            iss.parentTitle = procedure.title
            iss.parentType = ObjectType.Procedure.rawValue
            iss.reviewDueDate = NSDate(fromString: "2015-10-30", format: DateFormat.ISO8601(.Date))
            iss.dueDate = NSDate(fromString: "2015-11-30", format: DateFormat.ISO8601(.Date))
            iss.manager = "Alice Cooper"
            iss.businessContact = "Russell Edwin Nash"
            iss.reviewer = "Gordon Sumner"
            iss.clean()
            Services.saveObject(iss, parent: procedure, log: true)
            
            for i in 0...3 {
                let wp = Workpaper()
                wp.id = iss.id! * 100 + i
                wp.title = "Workpaper \(wp.id!)"
                wp.workflowState = i % 4 + 1
                wp.attachmentExtension = extensions[i % extensions.count]
                wp.parentTitle = procedure.title
                wp.parentType = ObjectType.Procedure.rawValue
                wp.reviewDueDate = NSDate(fromString: "2015-10-30", format: DateFormat.ISO8601(.Date))
                wp.dueDate = NSDate(fromString: "2015-11-30", format: DateFormat.ISO8601(.Date))
                
                wp.clean()
                Services.saveObject(wp, parent: iss, log: true)
            }
        }
        
        procedure.changes = [Change]()
        if id % 10 != 0 {
            for i in 1...10 {
                let change = Change()
                change.id = id * 1000 + i
                change.date = NSDate().dateByAddingDays(i)
                change.title = "I Changed This \(i)"
                change.user = "User #\(id)"
                procedure.changes?.append(change)
                
                change.details = [ChangeDetail]()
                if i % 3 != 0 {
                    for j in 1...5 {
                        let detail = ChangeDetail()
                        detail.label = "Property \(j)"
                        detail.isHtml = false
                        detail.priorValue = "Prior Value"
                        detail.currentValue = "Current Value"
                        change.details?.append(detail)
                    }
                }
            }
        }
        
        procedure.clean()
        Services.saveObject(procedure, log: true)

        return procedure
    }
}