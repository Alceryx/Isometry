class GrpCardData
{
  String title;
  String type;  
  List<ExerciseCardData> exercises;
  
  GrpCardData
  ({
    required this.title,
    required this.type, 
    List<ExerciseCardData>? exercises
  }) : exercises = exercises ?? []; 
}

class ExerciseCardData 
{
  String name; 
  ExerciseCardData
  ({
    required this.name
  });
}