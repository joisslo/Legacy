//
//  PicturesViewController.swift
//  CollegeIOS
//
//  Created by Jerry Hill on 5/27/17.
//  Copyright © 2017 Jerry Hill. All rights reserved.
//

import Foundation
import UIKit

class PicturesViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var imagePicker: UIImagePickerController!
    var image: UIImage!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary // .camera
        present(imagePicker, animated: true, completion: nil)

        tableView.delegate = self
    }

    override func tableView(_ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }

    override func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ImageCell", for: indexPath)

        let item = Store.storeInstance().students[indexPath.row]
        let label = cell.viewWithTag(1000) as! UILabel
        let imageView = cell.viewWithTag(1001) as! UIImageView

        imageView.downloadedFrom(link: item.pic)

        label.text = "\(item.StudentName)"

        return cell
    }

    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
            {
            let imagePicker = UIImagePickerController()

            //imagePicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        image = info[UIImagePickerControllerOriginalImage] as? UIImage


        let dm = DataManager()
        print("image chosen \(image.size)")

        if image != nil {
            print(image)
//            let imageData = UIImageJPEGRepresentation(image!, 0.5)
//            let base64String = imageData!.base64EncodedString(options: [])
//            let item = Store.storeInstance().student
//            OperationQueue.main.addOperation {
//
//                dm.uploadImage(studentID: Int(item.StudentID),  image: "", fileName: "Student\(item.StudentID)_Image.jpg" , imageData: base64String) {
//
//                    //Store.storeInstance().offer.bookPic = Store.storeInstance().image.imageURL
//
//                    //print(item.bookPic)
//                }
//            }
        }
    }
}



