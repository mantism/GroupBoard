//
//  SoundViewController.swift
//  GroupBoard
//
//  Created by Mikael Mantis on 4/26/17.
//  Copyright © 2017 edu.upenn.seas.cis195. All rights reserved.
//

import UIKit
import Firebase
class SoundViewController: UICollectionViewController, UIGestureRecognizerDelegate {

   
    @IBOutlet weak var soundBoard: UICollectionView!
    var sounds: [SoundObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.soundBoard.register(SoundCell.self, forCellWithReuseIdentifier: "soundCell")
        // Do any additional setup after loading the view.
        
        self.soundBoard.delegate = self
        self.soundBoard.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.soundBoard.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelNewSound(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func addNewSound(segue: UIStoryboardSegue) {
        if let src = segue.source as? AddSoundViewController {
            sounds.append(src.newSound)
        }
    }

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
     override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sounds.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soundCell", for: indexPath) as! SoundCell
        let row = indexPath.row
        if row == sounds.count {
             cell.isAddCell = true
            cell.imageView.image = UIImage(named: "addbutton")
        } else {
            let imageUrl = sounds[row].imageURL
            cell.imageView.image = UIImage(contentsOfFile: imageUrl!.path)
            cell.textLabel.text = sounds[row].text
        }
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader :
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "BoardHeader", for: indexPath) as! BoardHeader
            headerView.label.text = "Insert Group Name Here!"
            return headerView
                default:
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */


}
