//
//  AddMovieVC.swift
//  SQLiteList
//
//  Created by Macbook on 29/05/2022.
//

import UIKit

class AddMovieVC: UIViewController {
    
    // Outlets
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameTextField: UITextField!
    
    // Variables
    var imagePicker: UIImagePickerController?
    var pickedImage = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker?.delegate = self
        
    }
    
    // this function launches Action Sheet for the photos
    func showActionSheet() {
        
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // declaring camera button
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            // if camera available on device, than show
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(with: .camera)
            }
            
        }
        
        // declaring library button
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            // checking availability of photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
            }
            
        }
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // adding buttons to the sheet
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
        
    }
    //to show the picker
    func showPicker(with source: UIImagePickerController.SourceType){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func addPictureTapGestureClicked(_ sender: Any) {

        showActionSheet()
        
    }
    

    @IBAction func addButtonClicked(_ sender: Any) {
        
        DBManager.shared.createTable()

        DBManager.shared.insertData(name: movieNameTextField.text as NSString? ?? "", image: pickedImage as NSString? ?? "")
        
        DBManager.shared.query()
        
        navigationController?.popViewController(animated: true)
   

    }
    

}

extension AddMovieVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // accessing selected image from its variable
        let image = info[UIImagePickerController.InfoKey(rawValue: convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage))] as? UIImage
        
        movieImageView.image = image
        
        //1=> Getting Image Path
        let imagePath = info[UIImagePickerController.InfoKey.imageURL] as? URL
        
        //2=> Create Document Directory
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            
            let finalPathImage = imagePath?.lastPathComponent
        let path = documentDirectory[0].appendingPathComponent(finalPathImage!)
            let jpegData = try? image!.jpegData(compressionQuality: 1.0)?.write(to: path, options: .atomic)
        print(path)
            
        pickedImage = finalPathImage ?? ""
            
        } catch {
             
            
        }
        
        dismiss(animated: true)

    }
    
    
    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }

    // Helper function inserted by Swift 4.2 migrator.
    fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
}

