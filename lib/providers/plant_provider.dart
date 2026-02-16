import 'package:flutter/material.dart';
import '../models/plant.dart';
import '../models/category.dart';
import '../models/reminder.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../utils/sample_data.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> _plants = samplePlants;
  List<Category> _categories = sampleCategories;
  List<Reminder> _reminders = [];
  List<int> _favoritePlantIds = [];
  final DatabaseService _dbService = DatabaseService();
  final NotificationService _notificationService = NotificationService();

  PlantProvider() {
    _loadReminders();
    _loadFavorites();
  }

  List<Plant> get plants => _plants.where((plant) => plant.isApproved).toList();
  List<Plant> get pendingPlants =>
      _plants.where((plant) => !plant.isApproved).toList();
  List<Category> get categories => _categories;
  List<Reminder> get reminders => _reminders;
  List<Plant> get favoritePlants =>
      _plants.where((plant) => _favoritePlantIds.contains(plant.id)).toList();

  bool isFavorite(int plantId) => _favoritePlantIds.contains(plantId);

  Future<void> _loadReminders() async {
    _reminders = await _dbService.getReminders();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    // Load from shared preferences or database
    // For now, initialize empty
    notifyListeners();
  }

  Future<void> toggleFavorite(int plantId) async {
    if (_favoritePlantIds.contains(plantId)) {
      _favoritePlantIds.remove(plantId);
    } else {
      _favoritePlantIds.add(plantId);
    }
    // Save to shared preferences
    notifyListeners();
  }

  List<Plant> getPlantsByCategory(int categoryId) {
    return _plants.where((plant) => plant.categoryId == categoryId).toList();
  }

  void addPlant(Plant plant) {
    _addPlantInternal(plant, isApproved: true);
  }

  void submitPlant(Plant plant) {
    _addPlantInternal(plant, isApproved: false);
  }

  void _addPlantInternal(Plant plant, {required bool isApproved}) {
    // Generate a new ID for the plant
    final maxId = _plants.isEmpty
        ? 0
        : _plants.map((p) => p.id ?? 0).reduce((a, b) => a > b ? a : b);
    final newPlant = Plant(
      id: maxId + 1,
      name: plant.name,
      scientificName: plant.scientificName,
      description: plant.description,
      imageUrl: plant.imageUrl,
      categoryId: plant.categoryId,
      watering: plant.watering,
      sunlight: plant.sunlight,
      soil: plant.soil,
      careInstructions: plant.careInstructions,
      isApproved: isApproved,
    );
    _plants.insert(0, newPlant); // Add to the beginning of the list
    notifyListeners();
  }

  void approvePlant(int plantId) {
    final index = _plants.indexWhere((p) => p.id == plantId);
    if (index == -1) {
      return;
    }

    final plant = _plants[index];
    _plants[index] = Plant(
      id: plant.id,
      name: plant.name,
      scientificName: plant.scientificName,
      description: plant.description,
      imageUrl: plant.imageUrl,
      categoryId: plant.categoryId,
      watering: plant.watering,
      sunlight: plant.sunlight,
      soil: plant.soil,
      careInstructions: plant.careInstructions,
      isApproved: true,
    );
    notifyListeners();
  }

  void rejectPlant(int plantId) {
    _plants.removeWhere((p) => p.id == plantId);
    notifyListeners();
  }

  void updatePlant(Plant plant) {
    final index = _plants.indexWhere((p) => p.id == plant.id);
    if (index != -1) {
      _plants[index] = plant;
      notifyListeners();
    }
  }

  void deletePlant(int plantId) {
    _plants.removeWhere((p) => p.id == plantId);
    // Also remove from favorites if present
    _favoritePlantIds.remove(plantId);
    // Remove associated reminders
    _reminders.removeWhere((r) => r.plantId == plantId);
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    int id = await _dbService.insertReminder(reminder);
    Reminder newReminder = reminder.copyWith(id: id);
    _reminders.add(newReminder);
    await _notificationService.scheduleNotification(
      id,
      reminder.title,
      reminder.description,
      reminder.scheduledTime,
    );
    notifyListeners();
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _dbService.updateReminder(reminder);
    int index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      if (reminder.isActive) {
        await _notificationService.scheduleNotification(
          reminder.id!,
          reminder.title,
          reminder.description,
          reminder.scheduledTime,
        );
      } else {
        await _notificationService.cancelNotification(reminder.id!);
      }
    }
    notifyListeners();
  }

  Future<void> deleteReminder(int id) async {
    await _dbService.deleteReminder(id);
    _reminders.removeWhere((r) => r.id == id);
    await _notificationService.cancelNotification(id);
    notifyListeners();
  }
}
