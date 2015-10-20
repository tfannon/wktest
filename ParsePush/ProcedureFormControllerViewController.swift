//
//  ProcedureFormControllerViewController.swift
//  ParsePush
//
//  Created by Adam Rothberg on 10/19/15.
//  Copyright © 2015 Crazy8Dev. All rights reserved.
//

import UIKit

class ProcedureFormControllerViewController: UIViewController  {

    var scrollView : UIScrollView!
    var scrollManager : SFormScrollViewManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Create the section & field models.
        let section = SFormSection(fields: createFields());
        // Create the form model.
        let form = ShinobiForm ()
        form.sections.append(section)

        // Build the views.
        let formView = SFormFormViewBuilder().buildViewFromModel(form)
        
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
    
    func createFields() -> [SFormField]
    {
        //Create enough fields to be scrollable.
        var fields = [SFormField]()
        for (var fieldIndex = 0; fieldIndex < 20; fieldIndex++) {
            let fieldTitle = "Field \(fieldIndex)"
            let field = SFormTextField(title: fieldTitle)
            fields.append(field)
        }
        
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
