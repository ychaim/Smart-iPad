//
//  CityChooserTableViewController.swift
//  MKHome
//
//  Created by Charles Vu on 24/12/2016.
//  Copyright © 2016 charles. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class CityChooserViewController: ThemableViewController
{
    @IBOutlet var searchBar: UISearchBar?
    @IBOutlet var tableView: UITableView?
    @IBOutlet var spinner: UIActivityIndicatorView?

    fileprivate let appSettings = AppData.sharedInstance
    fileprivate var searchResults : [CLPlacemark] = []
    fileprivate let geocoder = CLGeocoder()
   
    override func refreshColors()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        searchBar?.backgroundColor = colorScheme.alternativeBackground
        searchBar?.tintColor = colorScheme.normalText
        searchBar?.barTintColor = colorScheme.normalText
        let textFieldInsideSearchBar = searchBar?.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = colorScheme.normalText
        tableView?.reloadData()
    }
    
    func lookup(name: String, completion: @escaping (Error?, [CLPlacemark]?) -> Void)
    {
        geocoder.cancelGeocode()
        spinner?.startAnimating()
        geocoder.geocodeAddressString(name)
        { (placemarks, error) in
            self.spinner?.stopAnimating()
            
            if error != nil
            {
                completion(error, nil)
            }
            else
            {
                completion(nil, placemarks)
            }
        }
    }

}

extension CityChooserViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let placemark = searchResults[indexPath.row]

        if let name = placemark.name,
            let coordinate = placemark.location?.coordinate
        {
            UserSettings.sharedInstance.weather.addCity(City(name: name, coordinates: coordinate))
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
}


extension CityChooserViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let placemark = searchResults[indexPath.row]

        let cell = tableView.dequeueReusableCell(withIdentifier: "CityCell")!

        cell.textLabel?.text = placemark.name! + ",  " + placemark.country!

        cell.detailTextLabel?.textColor = colorScheme.alternativeText
        cell.textLabel?.textColor = colorScheme.normalText
        cell.backgroundColor = colorScheme.alternativeBackground

        if UIDevice.current.userInterfaceIdiom == .pad
        {
            cell.preservesSuperviewLayoutMargins = false

            cell.layoutMargins = .zero
            cell.separatorInset = .zero
        }

        return cell
    }
}


extension CityChooserViewController: UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText != ""
        {
            lookup(name: searchText, completion: { (error, placemarks) in
                if let placemarks = placemarks
                {
                    self.searchResults = placemarks
                }
                else
                {
                    self.searchResults.removeAll()
                }
                self.tableView?.reloadData()
            })
        }
        else
        {
            searchResults = []
            self.tableView?.reloadData()
        }
    }
}
