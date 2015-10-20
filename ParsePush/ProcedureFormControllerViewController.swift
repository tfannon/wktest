//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class ProcedureFormControllerViewController: UIViewController, SFormDelegate {
    
    private var scrollView : UIScrollView!
    private var scrollManager : SFormScrollViewManager!
    var procedure : Procedure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // background color
        self.view.backgroundColor = UIColor.whiteColor()
        
        // Do any additional setup after loading the view.
        // Create the section & field models.
        let section = SFormSection(fields: createFields());
        // Create the form model.
        let form = ShinobiForm ()
        form.sections.append(section)
        form.delegate = self
        
        // Build the views.
        let formView = SFormFormViewBuilder().buildViewFromModel(form)
        formView.sizeToFit()
        
        // Create a scroll view.
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.autoresizingMask = [
            .FlexibleBottomMargin,
            .FlexibleHeight,
            .FlexibleLeftMargin,
            .FlexibleRightMargin,
            .FlexibleTopMargin,
            .FlexibleWidth]
        self.scrollView = scrollView;
        self.view.addSubview(self.scrollView)
        
        // Add the form view to the scroll view and size the content.
        self.scrollView.addSubview(formView)
        self.scrollView.contentSize = formView.bounds.size
        
        // Create a scroll view manager to manage your field navigation & inset management.
        self.scrollManager = SFormScrollViewManager(scrollView: self.scrollView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func createFields() -> [SFormField]
    {
        //Create enough fields to be scrollable.
        var fields = [SFormField]()
        
        fields.append(SFormTextField(title: "Title"))
        fields.append(SFormTextField(title: "Code"))
        fields.append(SFormDateField(title: "Due Date"))
        fields.append(SFormTextField(title: "Details"))
        
        fields[0].value = procedure.title
        fields[1].value = procedure.code
        fields[2].value = procedure.dueDate
        fields[3].value = procedure.text1
        
        return fields
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
