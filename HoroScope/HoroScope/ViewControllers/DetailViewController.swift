//
//  DetailViewController.swift
//  HoroScope
//
//  Created by Mañanas on 30/7/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    var isFavorite: Bool = false
    var horoscope: Horoscope? = nil
    
    let defaults = UserDefaults.standard
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    @IBOutlet weak var timeSegmentControl: UISegmentedControl!
    
    //Creo la variable del Bar Button Item para poder acceder a ella.
    @IBOutlet weak var favoriteBarButton: UIBarButtonItem!

    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Este if permite eliminar el opcional y asignarlo en una nueva variable
        if let horoscope = horoscope {
            nameLabel.text = horoscope.name
            logoImageView.image = horoscope.logo
            dateLabel.text = horoscope.dates
        }
        
        loadData()
        
    }
    
    func loadData() {
        let favoriteHoroscope = defaults.string(forKey: "FAVORITE_HOROSCOPE") ?? ""
        isFavorite = horoscope?.id == favoriteHoroscope
        
        setFavoriteBarButton()
        
        if let horoscopeName = horoscope?.name, let horoscopeDate = horoscope?.dates {
            self.navigationItem.title = "\(horoscopeName) - \(horoscopeDate)"
        }
        
        //self.navigationItem.title = horoscope?.name
        nameLabel.text = horoscope?.name
    
        updateHoroscopeForSelectedSegment()
    }
    
    
    //Creo la función que marcará el favorito. Para ello necesito mandarle de parametro el BarButtonItem
    @IBAction func setFavorite(_ sender: UIBarButtonItem) {
        isFavorite = !isFavorite
        if (isFavorite) {
            defaults.setValue(horoscope?.id, forKey: "FAVORITE_HOROSCOPE")
        } else {
            defaults.setValue("", forKey: "FAVORITE_HOROSCOPE")
        }
        setFavoriteBarButton()
    }
    
    func setFavoriteBarButton() {
        if (isFavorite) {
            favoriteBarButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteBarButton.image = UIImage(systemName: "heart")
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        updateHoroscopeForSelectedSegment()
    }
    
    func updateHoroscopeForSelectedSegment() {
        let selectedSegmentIndex = timeSegmentControl.selectedSegmentIndex
                let timePeriod: String
                
                switch selectedSegmentIndex {
                case 0:
                    timePeriod = "daily"
                case 1:
                    timePeriod = "weekly"
                case 2:
                    timePeriod = "monthly"
                default:
                    timePeriod = "daily"
                }
                
                getHoroscope(for: timePeriod)
            }
        
    func getHoroscope(for timePeriod: String) {
            guard let horoscopeId = horoscope?.id else { return }
            
            Task {
                do {
                    loading.isHidden = false
                    let luck = try await HoroscopeProvider.getHoroscopeLuck(horoscopeId: horoscopeId, timePeriod: timePeriod)
                    updateUIWithHoroscope(luck: luck)
                } catch {
                    print("Error fetching horoscope: \(error)")
                }
                loading.isHidden = true
            }
        }
    
    func updateUIWithHoroscope(luck: String) {
        descriptionTextView.text = luck
    }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


