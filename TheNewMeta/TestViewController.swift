//
//  TestViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/12/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let labels = ["My Lobbies", "Host Lobbies"]
    
    @IBOutlet weak var testCollection: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = testCollection.dequeueReusableCell(withReuseIdentifier: "testCollectionCell", for: indexPath) as! TestCell
        print(cell)
        
        cell.labelTestCell.text = labels[indexPath.row]
        return cell
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        testCollection.delegate = self
        testCollection.dataSource = self
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
