import 'package:flutter/material.dart';

abstract class IntraData<T extends IntraData<T>> extends ChangeNotifier
{
  String title;

  IntraData
  ({
    required this.title
  });
  
  @mustCallSuper
  void edit(T newItem)
  {
    title = newItem.title;
    notifyListeners();
  }
} 

class ListStruct<T> extends ChangeNotifier
{
  final List<T> _items = []; 
  List<T> get items => _items; 

  void addItem(T item)
  {
    _items.add(item); 
    notifyListeners(); 
  }

  void deleteItem(int index)
  {
    _items.removeAt(index);
    notifyListeners();
  }
}

class GridData extends ListStruct<GrpData> {}

class ExerciseList extends ListStruct<ExerciseData> {}
class GrpData extends IntraData<GrpData>
{
  String subTitle;
  ExerciseList exercises; 

  GrpData 
  ({
    required super.title,
    required this.subTitle,
    required this.exercises
  });

  @override 
  void edit(GrpData newItem) 
  {
    super.edit(newItem); 
    subTitle = newItem.subTitle;
  }
}

class TagListLocal extends ListStruct<TagData> {}
class ExerciseData extends IntraData<ExerciseData>
{
  TagListLocal tags;

  ExerciseData
  ({
    required super.title,
    required this.tags
  });

  @override 
  void edit(ExerciseData newItem)
  {
    super.edit(newItem); 
    tags = newItem.tags; 
  }
}

class TagData extends IntraData<TagData>
{
  TagStyle style;

  TagData
  ({
    required super.title,
    required this.style
  });

  @override
  void edit(TagData newItem)
  {
    super.edit(newItem);
    style = newItem.style;
  }
}

class TagStyle {}