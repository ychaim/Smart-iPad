//
//  WeatherSettingsViewController.swift
//  MKHome
//
//  Created by charles on 07/01/2017.
//  Copyright © 2017 charles. All rights reserved.
//

import Foundation
import UIKit

class WeatherSettingsViewController: ThemableViewController
{
    fileprivate let userSettings = UserSettings.sharedInstance
    
    @IBOutlet var cityWeatherTableView: UITableView?
    
    override func refreshColors()
    {
        view.backgroundColor = colorScheme.alternativeBackground
        cityWeatherTableView?.reloadData()
    }
       
    override func viewWillAppear(_ animated: Bool)
    {
        cityWeatherTableView?.reloadData()
    }
    
    @IBAction func onCloseClicked(button: UIButton)
    {
        dismiss(animated: true)
    }
}

extension WeatherSettingsViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userSettings.weather.getCities().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let city = userSettings.weather.getCities()[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
        cell.textLabel?.text = city.name
        cell.backgroundColor = colorScheme.alternativeBackground
        cell.textLabel?.textColor = colorScheme.normalText
        
        return cell
    }
}

extension WeatherSettingsViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    @objc(tableView:commitEditingStyle:forRowAtIndexPath:)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete)
        {
            let city = userSettings.weather.getCities()[indexPath.row]
            userSettings.weather.removeCity(city)
            tableView.reloadData()
        }
    }
}
