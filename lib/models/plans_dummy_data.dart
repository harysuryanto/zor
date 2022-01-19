var plans = [
  Plan(
    planId: 2001,
    userId: 1001,
    name: 'Workout Senin',
    exercises: [
      Exercise(
        exerciseId: 1,
        name: 'Jumping Jack',
        duration: 30,
        repetitions: null,
        sets: null,
        restTime: 15,
      ),
      Exercise(
        exerciseId: 2,
        name: 'Dumble Curl',
        duration: null,
        repetitions: 12,
        sets: 4,
        restTime: 60,
      ),
    ],
  ),
  Plan(
    planId: 2002,
    userId: 1001,
    name: 'Workout Selasa',
    exercises: [
      Exercise(
        exerciseId: 1,
        name: 'Jumping Jack',
        duration: 30,
        repetitions: null,
        sets: null,
        restTime: 15,
      ),
      Exercise(
        exerciseId: 2,
        name: 'Barble Curl',
        duration: null,
        repetitions: 12,
        sets: 4,
        restTime: 60,
      ),
    ],
  ),
  Plan(
    planId: 2003,
    userId: 1001,
    name: 'Workout Rabu',
    exercises: [
      Exercise(
        exerciseId: 1,
        name: 'Jumping Jack',
        duration: 30,
        repetitions: null,
        sets: null,
        restTime: 15,
      ),
      Exercise(
        exerciseId: 2,
        name: 'Push Up',
        duration: null,
        repetitions: 12,
        sets: 4,
        restTime: 60,
      ),
    ],
  ),
  Plan(
    planId: 2002,
    userId: 1002,
    name: 'Workout Senin',
    exercises: [
      Exercise(
        exerciseId: 1,
        name: 'Plank',
        duration: 30,
        repetitions: null,
        sets: null,
        restTime: 69,
      ),
      Exercise(
        exerciseId: 2,
        name: 'Tricep with Cable',
        duration: null,
        repetitions: 12,
        sets: 4,
        restTime: 60,
      ),
    ],
  ),
];

class Plan {
  final int planId;
  final int userId;
  final String name;
  List<Exercise>? exercises;

  Plan({
    required this.planId,
    required this.userId,
    required this.name,
    this.exercises,
  });
}

class Exercise {
  final int exerciseId;
  final String name;
  int? duration;
  int? repetitions;
  int? sets;
  final int restTime;

  Exercise({
    required this.exerciseId,
    required this.name,
    this.duration,
    this.repetitions,
    this.sets,
    required this.restTime,
  });
}

void main() {
  print(plans[0].exercises![0].repetitions);
}
