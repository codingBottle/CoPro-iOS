//
//  EditPostViewController.swift
//  CoPro
//
//  Created by 문인호 on 2/26/24.
//

import UIKit

protocol editPostViewControllerDelegate: AnyObject{
    func didEditPost(title: String, category: String, content: String, image: [Int], tag: String, part: String)
}

class EditPostViewController: UIViewController {

    weak var delegate: editPostViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
