import 'package:flutter/material.dart';
import 'package:isometry/exercise_grp_card.dart';


class GrpData extends ChangeNotifier
{
  final List<GrpCard> _cards = [];
  /*
  _cards to make this list private to this file/lib. 
  Any attempt to modify _cards in other files must go
  through the methods of this class, which ensures 
  notifyListener() is called.
  */

  List<GrpCard> get cards => _cards;
  /*
  Expose _cards using property syntax, not method call.
  cards is like a pucblic read_only proxy for _cards
  */ 

  void addCard(GrpCard card)
  {
    _cards.add(card); 
    notifyListeners(); 
  }

  void deleteCard(int index)
  {
    _cards.removeAt(index);
    notifyListeners();
  }

  void updateCard(int index, GrpCard newCard)
  { 
    _cards[index] = newCard; 
    notifyListeners();
  }
}

