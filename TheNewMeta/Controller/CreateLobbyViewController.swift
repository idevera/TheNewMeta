//
//  CreateLoginViewController.swift
//  TheNewMeta
//
//  Created by Irene DeVera on 1/2/18.
//  Copyright © 2018 Irene DeVera. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import Hue

class CreateLobbyViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Properties
    
    private var signedInUser = User()
    private var currentAPIGames: [Game] = [Game]()
    lazy var gradient: CAGradientLayer = [
        UIColor(hex: "#FD4340"),
        UIColor(hex: "#CE2BAE")
        ].gradient { gradient in
            gradient.speed = 1
            gradient.timeOffset = 1
            return gradient
    }
    
    // Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.addSublayer(gradient)
        getData()
        setupLayout()
        findSignedInUser()
        
        self.playersFieldView.delegate = self
        self.msgFieldView.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        initialPickerField.inputView = pickerView
        
        self.title = "Create Lobby"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        playersFieldView.text = ""
        msgFieldView.text = ""
        initialPickerField.text = ""
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.gradient.frame = self.view.bounds
    }
    
    // When the user clicks on the screen the editing of the text field picker will close
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Picker View
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentAPIGames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("This is the crrentAPIGames title: ", currentAPIGames[row].title)
        return currentAPIGames[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerLabelView.text = currentAPIGames[row].title
        initialPickerField.text = currentAPIGames[row].title
    }
    
    // Private Functions
    
    @objc private func createLobby(_ sender: UIButton) {
        if checkInputs() {
            // This game will always exist
            let game = getGame(gameTitle: initialPickerField.text!)
            print("This game selected exists:", game)
            let newLobby = createNewLobby()
            
            // Perform the migration
            let realm = try! Realm()
            
            // Write to the database
            try! realm.write {
                realm.add(newLobby)
                print("This is the new lobby host ID:", newLobby.hostID)
                // Add the newlobby to the game instance array
                // This should automatically update the newLobby.game property of a lobby
                game!.matchingLobbies.append(newLobby)
                
                // For this created lobby, add the signed in user as a lobby user
                newLobby.lobbyUsers.append(signedInUser)
                
                // Signed in user, add the new lobby to your created Lobbies
                signedInUser.createdLobbies.append(newLobby)
                print("This is the signed in users ID:", signedInUser.userID)
            }
            resetForm()
            
            // Reload the other collection views
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            successCreationAlert()
        }
    }
    
    // Keyboard return after the textfield is done being edited
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return false
//    }
    
    // Keyboard clicks
    
    // Hide the keyboard if the text field is the picker field
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == initialPickerField {
            pickerView.isHidden = false
            return false
        }
        return true
    }
    
    // Hide keyboard when the user clicks on the view
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    private func checkInputs() -> Bool {
        if msgFieldView.text == "" || playersFieldView.text == "" || msgFieldView.text == "" {
            failAlert()
            return false
        }
        return true
    }
    
    private func resetForm() {
        playersFieldView.text = ""
        msgFieldView.text = ""
        initialPickerField.text = ""
    }
    
    private func getGame(gameTitle: String) -> Game? {
        var i = 0
        while i < currentAPIGames.count {
            if currentAPIGames[i].title == gameTitle {
                return currentAPIGames[i]
            } else {
                print("This game does not exist!")
            }
            i += 1
        }
        return nil
    }
    
    private func getData() {
        let realm = try! Realm()
        let returnedGames = realm.objects(Game.self).sorted(byKeyPath: "title")
        for game in returnedGames {
            currentAPIGames.append(game)
        }
        print("This is the current Games count:", currentAPIGames.count)
    }
    
    private func createNewLobby() -> Lobby {
        let lobby = Lobby()
        
        let num: Int? = Int(playersFieldView.text!)
        lobby.numberOfPlayers = num!
        lobby.message = msgFieldView.text!
        
        // It’s worth noting here that these getters will return optional values, so the type of name is String?. When the "name" key doesn’t exist, the code returns nil. It then makes sense to use optional binding to get the value safely:
        if let id = UserDefaults.standard.string(forKey: "userID") {
            lobby.hostID = id
             print("Lobby ID successfully saved for logged in user: \(lobby.hostID)")
        }
        return lobby
    }
    
    private func findSignedInUser() {
        let id = UserDefaults.standard.string(forKey: "userID")
        let realm = try! Realm()
        print("This is the id of the signed in user \(String(describing: id))")
        signedInUser = realm.object(ofType: User.self, forPrimaryKey: id)!
        print("Found signed in user: \(String(describing: signedInUser))")
    }
    
    // Alerts
    
    private func failAlert() {
        let alert = UIAlertController(title: "Try again", message: "Your fields cannot be blank", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func successCreationAlert() {
        let alert = UIAlertController(title: "Lobby Successfully Created", message: "Your lobby was added to your profile", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
        })
        
        alert.addAction(OKAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Views and Constraints
    
    // Initial label to choose a game
    var initialPickerField: UITextField = {
        let initialLabel = UITextField()
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        initialLabel.backgroundColor = .white
        initialLabel.layer.masksToBounds = true
        initialLabel.layer.cornerRadius = 5
        initialLabel.textAlignment = .center
        initialLabel.placeholder = "Click to choose a game"
        return initialLabel
    }()
    
    // Picker View
    var pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.isHidden = false
        return picker
    }()
    
    // Label for each of item in the test Array
    var pickerLabelView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let playersFieldView: UITextField = {
        let playersField = UITextField()
        playersField.translatesAutoresizingMaskIntoConstraints = false
        playersField.backgroundColor = .white
        playersField.layer.cornerRadius = 5
        playersField.textAlignment = .center
        playersField.placeholder = "Number of Players?"
        return playersField
    }()
    
    let msgFieldView: UITextField = {
        let msgField = UITextField()
        msgField.translatesAutoresizingMaskIntoConstraints = false
        msgField.backgroundColor = .white
        msgField.layer.cornerRadius = 5
        msgField.textAlignment = .center
        msgField.placeholder = "Message to your challengers"
        return msgField
    }()
    
    let submitButtonView: UIButton = {
        let submitButton = UIButton()
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.backgroundColor = UIColor(hex: "4F6272")
        submitButton.layer.cornerRadius = 1
        submitButton.setTitle("Create Lobby", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.addTarget(self, action: #selector(createLobby(_:)), for: .touchUpInside)
        return submitButton
    }()
    
    // Setup View Layout
    
    private func setupLayout() {
        view.backgroundColor = UIColor(hex: "#B7C3F3")

        view.addSubview(playersFieldView)
        view.addSubview(initialPickerField)
        view.addSubview(msgFieldView)
        view.addSubview(submitButtonView)
        
        // Have the pickerView add each label
        pickerView.addSubview(pickerLabelView)


        // Player
        playersFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playersFieldView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        playersFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        playersFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        // Initial PickerLabel on click
        initialPickerField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        initialPickerField.bottomAnchor.constraint(equalTo: playersFieldView.topAnchor, constant: -20).isActive = true
        initialPickerField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        initialPickerField.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true

        msgFieldView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        msgFieldView.topAnchor.constraint(equalTo: playersFieldView.bottomAnchor, constant: 20).isActive = true
        msgFieldView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        msgFieldView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05).isActive = true
        
        submitButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButtonView.topAnchor.constraint(equalTo: msgFieldView.bottomAnchor, constant: 20).isActive = true
        submitButtonView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        submitButtonView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1).isActive = true
    }
}

