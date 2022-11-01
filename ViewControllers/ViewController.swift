//
//  ViewController.swift
//  Jokester
//
//  Created by Michael Kampouris on 11/1/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var jokeTextView: UITextView!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var jokeTypeButton1: UIButton!
    @IBOutlet weak var jokeTypeButton2: UIButton!
    @IBOutlet weak var jokeTypeButton3: UIButton!
    @IBOutlet weak var jokeTypeButton4: UIButton!
    
    @IBOutlet weak var jokeFilterButton1: UIButton!
    @IBOutlet weak var jokeFilterButton2: UIButton!
    @IBOutlet weak var jokeFilterButton3: UIButton!
    @IBOutlet weak var jokeFilterButton4: UIButton!
    @IBOutlet weak var jokeFilterButton5: UIButton!
    @IBOutlet weak var jokeFilterButton6: UIButton!
    
    
    //MARK: - Properties
    
    private var selectedFilters: [JokeFilter] = []
    private var selectedType: JokeEndpoint = .miscellaneous
    
    private var jokeTypeButtons: [UIButton] = []
    private var jokeFilterButtons: [UIButton] = []
    
    private let apiLayer = APILayer(session: URLSession.shared)
    private let constructor = URLConstructor()
    
    private var joke: Joke? {
        didSet {
            switch joke?.type {
            case "twopart":
                DispatchQueue.main.async { [weak self] in
                    self?.jokeTextView.text = """
                                            \(self?.joke?.setup ?? "")
                                            
                                            \(self?.joke?.delivery ?? "")
                                            """
                }
            default:
                DispatchQueue.main.async { [weak self] in
                    self?.jokeTextView.text = self?.joke?.jokeText
                }
            }
        }
    }
    
    private var isLoading: Bool = false {
        didSet {
            switch isLoading {
            case true:
                startLoading()
            case false:
                stopLoading()
            }
        }
    }
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
    }
    
    
    //MARK: - Functions
    
    fileprivate func setupButtons() {
        jokeTypeButtons = [jokeTypeButton1, jokeTypeButton2, jokeTypeButton3, jokeTypeButton4]
        jokeFilterButtons = [jokeFilterButton1,jokeFilterButton2,jokeFilterButton3,jokeFilterButton4,jokeFilterButton5,jokeFilterButton6]
        
        jokeTypeButtons[0].isSelected = true
        jokeTypeButtons[0].backgroundColor = .black

        jokeTypeButtons.forEach { button in
            button.setTitle(JokeEndpoint.allCases[button.tag].rawValue.capitalized, for: .normal)
            button.layer.cornerRadius = 8
        }
        
        jokeFilterButtons.forEach { button in
            button.setTitle(JokeFilter.allCases[button.tag].rawValue.capitalized, for: .normal)
            button.layer.cornerRadius = 8
        }
        
        generateButton.layer.cornerRadius = 8
    }
    
    fileprivate func startLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.alpha = 1
            self?.activityIndicator.startAnimating()
        }
    }
    
    fileprivate func stopLoading() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.alpha = 0
            self?.activityIndicator.stopAnimating()
        }
    }
    
    
    //MARK: - Actions
    
    @IBAction func jokeTypeButtonPressed(_ sender: UIButton) {
        jokeTypeButtons.forEach { button in
            button.backgroundColor = .opaqueSeparator
        }
        sender.backgroundColor = .black
        selectedType = JokeEndpoint.allCases[sender.tag]
    }
    
    @IBAction func jokeFilterPressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        switch sender.isSelected {
        case true:
            selectedFilters.append(JokeFilter.allCases[sender.tag])
            sender.backgroundColor = .black
        case false:
            selectedFilters.removeAll { filter in
                filter == JokeFilter.allCases[sender.tag]
            }
            sender.backgroundColor = .opaqueSeparator
        }
    }
    
    @IBAction func getJoke(_ sender: UIButton) {
        isLoading = true
        DispatchQueue.main.async { [weak self] in
            self?.jokeTextView.text = nil
        }
        if let url = constructor.constructURLWith(jokeType: selectedType, filters: selectedFilters) {
            print(url)
            Task {
                joke = await apiLayer.getJokeFrom(url: url)
                isLoading = false
            }
        }
    }

}

