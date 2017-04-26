//
//  AddSoundViewController.swift
//  GroupBoard
//
//  Created by Mikael Mantis on 4/26/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class AddSoundViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var soundLabelField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPictureButton: UIButton!
    
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var newSound: SoundObj!
    var didRecordAudio: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingSession = AVAudioSession.sharedInstance()
        soundLabelField.delegate = self
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        self.showAlert(flag: "")
                    }
                }
            }
        } catch {
            showAlert(flag: "")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadRecordingUI() {
        recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playTapped), for: .touchUpInside)
        
    }
    
    func showAlert(flag: String) {
        switch flag {
        case "text" :
            let alert = UIAlertController(title: "Oops", message: "Please provide a label before recording audio", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        case "image" :
            let alert = UIAlertController(title: "Oops", message: "Please provide an image before recording audio", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        case "image2" :
            let alert = UIAlertController(title: "Oops", message: "Unable to save image", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        case "emptyFields" :
            let alert = UIAlertController(title: "Oops", message: "Please provide a label, image, and recording", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        default:
            let alert = UIAlertController(title: "Oops", message: "Unable to record audio", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(soundLabelField.text! + "_recording.mp4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil
        
        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
            didRecordAudio = true
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
        }
    }
    
    func recordTapped() {
        
        if soundLabelField.text == nil {
            showAlert(flag: "text")
        } else if imageView.image == nil {
            showAlert(flag: "image")
        } else if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    func playTapped() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(soundLabelField.text! + "_recording.mp4a")
        
        //if audioRecorder.isRecording == false {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            audioPlayer.delegate = self
            audioPlayer.play()
        } catch {
            showAlert(flag: "")
        }
        
        // }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("done playing!")
    }
    
    @IBAction func addPicture(_ sender: Any) {
        let picker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        picker.mediaTypes = [kUTTypeImage as String]
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        do {
            if let data = UIImagePNGRepresentation(imageView.image!) {
                let imageFileName = getDocumentsDirectory().appendingPathComponent(soundLabelField.text! + "_image.png")
                try data.write(to: imageFileName)
                
                self.dismiss(animated: true, completion: nil)

            }
        } catch {
            showAlert(flag: "image2")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "addNewSound" {
            if soundLabelField.text == "" || imageView.image == nil || !didRecordAudio {
                showAlert(flag: "emptyFields")
                return false
            } else {
                return true
            }
        }
        return true
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       
        if let dest = segue.destination as? SoundViewController {
            let label = soundLabelField.text! as String
            
            let imageFileName = getDocumentsDirectory().appendingPathComponent(label + "_image.png")
            let audioFileName = getDocumentsDirectory().appendingPathComponent(label + "_recording.mp4a")
            print (label)
            newSound = SoundObj(label: label)
            newSound.imageURL = imageFileName
            newSound.soundURL = audioFileName
            //dest.sounds.append(newSound)
        }

        
    }
    
    
    

}
