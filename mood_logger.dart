/// Lab 2 Individual Assignment (A2) -- CLI Mood Logger (TEMPLATE)
///
/// Build a command-line mood tracking application.
/// Implement all the TODO sections below.
///
/// Run with: dart run mood_logger_template.dart
///
/// Requirements:
///   - MoodEntry class to represent a single mood log
///   - MoodLogger class to manage a collection of entries
///   - Interactive CLI with a menu loop
///
/// Do NOT use AI tools. Write all code yourself.

import 'dart:io';

// ============================================================================
// MoodEntry Class
// ============================================================================

/// Represents a single mood log entry.
///
/// Fields:
///   - DateTime createdAt  -- when the entry was created
///   - int score           -- mood score from 1 (very bad) to 10 (excellent)
///   - String? note        -- an optional short description of the mood;
///                            null when the user wrote nothing
///
/// The Flutter Mood Tracker you build from Lab 3 onwards uses the same three
/// fields, so this class carries over almost unchanged.
class MoodEntry {
  final DateTime createdAt;
  final int score;
  final String? note;

  MoodEntry(this.score, this.note) : createdAt = DateTime.now();

  @override
  String toString() {
    String year = createdAt.year.toString();
    String month = createdAt.month.toString().padLeft(2, '0');
    String day = createdAt.day.toString().padLeft(2, '0');
    String hour = createdAt.hour.toString().padLeft(2, '0');
    String minute = createdAt.minute.toString().padLeft(2, '0');
    
    String displayNote = note ?? '(no note)';
    
    return '[$year-$month-$day $hour:$minute] Score: $score/10 - $displayNote';
  }
}

// ============================================================================
// MoodLogger Class
// ============================================================================

/// Manages a collection of MoodEntry objects.
class MoodLogger {
  // 1. La lista privada
  final List<MoodEntry> _entries = [];

  /// Adds a new mood entry with the given score and optional note.
  ///
  /// Validates that score is between 1 and 10 (inclusive).
  /// If invalid, prints an error message and does NOT add the entry.
  /// A note that is empty or only spaces is stored as null.
  
  // 2. Añadir un registro
  bool addEntry(int score, String? note) {
    if (score < 1 || score > 10) {
      print('Error: Score must be between 1 and 10.');
      return false;
    }
    
    // Si la nota solo tiene espacios, la convertimos a null
    if (note != null && note.trim().isEmpty) {
      note = null;
    }
    
    _entries.add(MoodEntry(score, note));
    return true;
    // (No imprimimos "Entry added!" aquí para mantener la lógica separada de la vista, 
    // pero si lo pide el menú luego, lo gestionamos allí).
  }

  /// Returns a copy of all entries.
  List<MoodEntry> getAllEntries() {
    // TODO: return a copy of the entries list
    return List.from(_entries);
  }

  /// Calculates and returns the average mood score.
  ///
  /// Returns null if there are no entries: there is no average to report,
  /// and 0.0 would look like a real (very bad) score.
  double? getAverageScore() {
    if (_entries.isEmpty) return null;
    
    // fold() empieza en 0 y va sumando el 'score' de cada 'entry' de la lista
    int total = _entries.fold(0, (sum, entry) => sum + entry.score);
    return total / _entries.length;
  }

  // 5. Filtrar por nota mínima
  List<MoodEntry> getEntriesAbove(int threshold) {
    // where() actúa como un colador, dejando pasar solo los que cumplen la condición
    return _entries.where((entry) => entry.score >= threshold).toList();
  }


  /// Returns the total number of entries.
  int get entryCount {
    return _entries.length;
  }
}

// ============================================================================
// Main -- Interactive CLI
// ============================================================================

void main() {
  final logger = MoodLogger();
  bool running = true;

  print('=== Mood Logger ===');
  print('Track your daily mood on a scale of 1-10.\n');

  while (running) {
    print('1. Add mood entry');
    print('2. View all entries');
    print('3. View average mood');
    print('4. Filter by minimum score');
    print('5. Quit');
    stdout.write('\nChoose an option: ');

    String? input = stdin.readLineSync();
    int? choice = int.tryParse(input ?? '');

    switch (choice) {
      case 1:
        stdout.write('Enter mood score (1-10): ');
        int? score = int.tryParse(stdin.readLineSync() ?? '');
        
        if (score == null) {
          print('Invalid number.');
          break;
        }
        
        // Añadimos este filtro rápido para cortar al instante
        if (score < 1 || score > 10) {
          print('Error: Score must be between 1 and 10.');
          break;
        }
        
        stdout.write('Enter a note (or press Enter for none): ');
        String? note = stdin.readLineSync();
        
        bool success = logger.addEntry(score, note);
        if (success) {
          print('Entry added!');
        }
        break;
        
      case 2:
        var entries = logger.getAllEntries();
        if (entries.isEmpty) {
          print('No entries yet. Add some entries first!');
        } else {
          for (var entry in entries) {
            print(entry);
          }
        }
        break;
        
      case 3:
        double? avg = logger.getAverageScore();
        if (avg == null) {
          print('No entries yet.');
        } else {
          print('Average mood score: ${avg.toStringAsFixed(1)} (based on ${logger.entryCount} entries)');
        }
        break;
        
      case 4:
        stdout.write('Enter minimum score: ');
        int? min = int.tryParse(stdin.readLineSync() ?? '');
        if (min == null) {
          print('Invalid number.');
          break;
        }
        
        var filtered = logger.getEntriesAbove(min);
        if (filtered.isEmpty) {
          print('No entries found at or above $min.');
        } else {
          for (var entry in filtered) {
            print(entry);
          }
        }
        break;
        
      case 5:
        running = false;
        print('Goodbye!');
        break;
        
      default:
        print('Invalid option. Please choose 1-5.');
    }
    print(''); // Línea en blanco para que quede limpio en la terminal
  }
}
