import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sklyit/api/home_page.dart';

class HomePageProvider with ChangeNotifier {
  List<Map<String, dynamic>> highlights = [];
  List<Map<String, dynamic>> topServices = [];
  List<Map<String, dynamic>> personal_care = [];
  List<Map<String, dynamic>> appliance_services = [];
  List<Map<String, dynamic>> home_services = [];
  bool isInitial = true;

  // Call these methods to fetch and update data
  void reload() async {
    var trendingProfessionalService = await HomePageApi.getServicesOrderedByMostBookingsByProfessional(10);
    var trendingBusinessService = await HomePageApi.getServicesOrderedByMostBookings(10);
    var trending = trendingBusinessService.followedBy(trendingProfessionalService);
    var topBusiness = await HomePageApi.getTopBusinesses(limit: 50);
    var topProffesionals = await HomePageApi.getTopProfessionals(50);
    var personalCareBusiness = await HomePageApi.getByTag('Personal Care');
    var personalCareProfessional = await HomePageApi.searchProfessionalByTag('Personal Care');
    var personal_care = personalCareBusiness.followedBy(personalCareProfessional);
    var applianceServicesBusiness = await HomePageApi.getByTag('Appliance Repair');
    var applianceServicesProfessional = await HomePageApi.searchProfessionalByTag('Appliance Repair');
    var appliance_services = applianceServicesBusiness.followedBy(applianceServicesProfessional);
    var homeServicesBusiness = await HomePageApi.getByTag('Home Cleaning');
    var homeServicesProfessional = await HomePageApi.searchProfessionalByTag('Home Cleaning');    
    var home_services = homeServicesBusiness.followedBy(homeServicesProfessional);
    var top_services = await HomePageApi.getServicesOrderedByMostBookings(10);

    print(trending);
    print(topBusiness);
    
    highlights = List<Map<String, dynamic>>.from(trending ?? []);
    topBusiness = List<Map<String, dynamic>>.from(topBusiness);
    topProffesionals = List<Map<String, dynamic>>.from(topProffesionals);
    topServices = List<Map<String, dynamic>>.from(top_services);
    this.personal_care = List<Map<String, dynamic>>.from(personal_care);
    this.appliance_services = List<Map<String, dynamic>>.from(appliance_services);
    this.home_services = List<Map<String, dynamic>>.from(home_services);


    if(highlights.length < 5){
      highlights.addAll(topServices);
    }

    notifyListeners();  // Notify listeners after data is updated
  }

  void setInitial(bool value) {
    isInitial = value;
    notifyListeners();  // Notify listeners when isInitial changes
  }
}