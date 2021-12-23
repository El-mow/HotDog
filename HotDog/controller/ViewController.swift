//
//  ViewController.swift
//  HotDog
//
//  Created by mobin on 12/19/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
           imageView.image = pickedImage
           
           guard  let ciImage = CIImage(image: pickedImage) else {
               fatalError("could not convert image")
           }
           detect(image: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker
                , animated: true, completion: nil)
        
    }
    
    func detect(image:CIImage) {
        guard let imageModel =  try? VNCoreMLModel(for: Inceptionv3().model)else {
            fatalError(" problem for loading image")
        }
        
        let request = VNCoreMLRequest(model: imageModel) { request, error  in
            guard  let results = request.results as? [VNClassificationObservation] else {
                fatalError("we have problem to classifaction model")
            }
            if let firstRes = results.first{
                  print(firstRes)
                if firstRes.identifier.contains("hotDog") || firstRes.identifier.contains("hot dog"){
                    self.navigationItem.title = "this hot dog"
                    self.navigationController?.navigationBar.backgroundColor = .green
                }else {
                    self.navigationItem.title = "this is not dog"
                    self.navigationController?.navigationBar.backgroundColor = .red 

                }
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        do {
            try! handler.perform([request])
            
        }catch {
            print(error)
        }

        
    }
    
}

