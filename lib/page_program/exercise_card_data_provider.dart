import 'package:flutter/material.dart';
import 'package:isometry/data_manager.dart';

class GrpDataProvider extends ChangeNotifier
{
  final List<GrpCardData> _cards = [];

  List<GrpCardData> get cards => _cards;

  //-----------
  //GROUP-LEVEL
  //-----------

  void addCard(GrpCardData card)
  {
    _cards.add(card); 
    notifyListeners(); 
  }

  void deleteCard(int index)
  {
    _cards.removeAt(index);
    notifyListeners();
  }

  void updateCard(int index, GrpCardData newCard)
  { 
    _cards[index].title = newCard.title; 
    _cards[index].type = newCard.type;
    notifyListeners();
  }

  //--------------
  //EXERCISE-LEVEL
  //--------------
  
  void addExercise(int cardIndex, ExerciseCardData exercise)
  {
    _cards[cardIndex].exercises.add(exercise); 
    notifyListeners();
  }

  void deleteExercise(int cardIndex, int exerciseIndex)
  {
    _cards[cardIndex].exercises.removeAt(exerciseIndex);
    notifyListeners();
  }

  void updateExercise(int cardIndex, int exerciseIndex, ExerciseCardData newExercise)
  {
    _cards[cardIndex].exercises[exerciseIndex] = newExercise; 
    notifyListeners();
  }
}