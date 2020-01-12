//
//  AddViewController.swift
//  MyGames
//
//  Created by zupper on 11/01/20.
//  Copyright © 2020 zupper. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfConsole: UITextField!
    @IBOutlet weak var dpReleaseDate: UIDatePicker!
    @IBOutlet weak var btCover: UIButton!
    @IBOutlet weak var btAddEdit: UIButton!
    @IBOutlet weak var ivCover: UIImageView!
    
    
    var game : Game!
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .white
        return pickerView
    }()
    
    var consolesManager = ConsoleManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game != nil{
            title = "Editar jogo"
            btAddEdit.setTitle("Alterar", for: .normal)
            tfName.text = game.title
            if let console = game.console, let index = consolesManager.consoles.firstIndex(of: console){
                tfConsole.text = console.name
                pickerView.selectRow(index, inComponent: 0, animated: false)
            }
            ivCover.image = game.cover as? UIImage
            if let releaseData = game.realeseDate{
                dpReleaseDate.date = releaseData
            }
            if game.cover != nil {
            btCover.setTitle(nil, for: .normal)
            }
        }
        prepareConsoleTextField()
        
    }
        func prepareConsoleTextField(){
            
            let toobar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
                   toobar.tintColor = UIColor(named: "main")
                   
            let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
            let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
            let lbFlexibleSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                toobar.items = [btCancel, lbFlexibleSpace, btDone]
                   
        tfConsole.inputView = pickerView
        tfConsole.inputAccessoryView = toobar
            
        }

    
    @objc func cancel(){
        tfConsole.resignFirstResponder()
    }
    
    @objc func done(){
        
        tfConsole.text = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)].name
        
        cancel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consolesManager.loadConsole(with: context)
    }
    
    @IBAction func addEditGame(_ sender: Any) {
        if game ==  nil {
            game = Game(context: context)
        }
        
        game.title = tfName.text
        game.realeseDate = dpReleaseDate.date
        
        if tfConsole.text!.isEmpty{
            let console = consolesManager.consoles[pickerView.selectedRow(inComponent: 0)]
            game.console = console
        }
        game.cover = ivCover.image
        
        do{
             try context.save()
        } catch{
            print(error.localizedDescription)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addEditCover(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Selecionar poster", message: "De onde você quer escolher o poster ?", preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(libraryAction)
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func selectPicture(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        imagePicker.navigationBar.tintColor = UIColor(named: "main")
        present(imagePicker, animated: true, completion: nil)
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

extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return consolesManager.consoles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let console = consolesManager.consoles[row]
        return console.name
    }
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        ivCover.image = image
        btCover.setTitle(nil, for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
