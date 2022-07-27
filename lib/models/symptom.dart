import 'package:e2e_period_tracking/utils/codable.dart';

enum Symptom {
  acne,
  sleepDisturbances,
  changesInAppetite,
  chills,
  hairLoss,
  constipation,
  abdominalCramps,
  diarrhea,
  lumbar,
  pelvicPain,
  swelling,
  incontinence,
  headache,
  drySkin,
  moodSwings,
  soreBreast,
  tiredness,
  nightSweats,
  hotFlashes,
  emptyMemory;

  String get description {
    switch (this) {
      case Symptom.acne:
        return "Acne";
      case Symptom.sleepDisturbances:
        return "Sleep disturbances";
      case Symptom.changesInAppetite:
        return "Changes in appetite";
      case Symptom.chills:
        return "Chills";
      case Symptom.hairLoss:
        return "Hair loss";
      case Symptom.constipation:
        return "Constipation";
      case Symptom.abdominalCramps:
        return "Abdominal cramps";
      case Symptom.diarrhea:
        return "Diarrhea";
      case Symptom.lumbar:
        return "Lumbar";
      case Symptom.pelvicPain:
        return "Pelvic pain";
      case Symptom.swelling:
        return "Swelling";
      case Symptom.incontinence:
        return "Incontinence";
      case Symptom.headache:
        return "Headache";
      case Symptom.drySkin:
        return "Dry skin";
      case Symptom.moodSwings:
        return "Mood swings ";
      case Symptom.soreBreast:
        return "Sore breasts";
      case Symptom.tiredness:
        return "Tiredness";
      case Symptom.nightSweats:
        return "Night sweats";
      case Symptom.hotFlashes:
        return "Hot flashes";
      case Symptom.emptyMemory:
        return "Empty memory";
    }
  }
}

enum TestResult {
  positive,
  negative,
  unknown;

  String get description {
    switch (this) {
      case TestResult.positive:
        return "Positive";
      case TestResult.negative:
        return "Negative";
      case TestResult.unknown:
        return "Unknown";
    }
  }
}

enum Period {
  noFlow,
  light,
  medium,
  abundant;

  String get description {
    switch (this) {
      case Period.noFlow:
        return "No flow";
      case Period.light:
        return "Light";
      case Period.medium:
        return "Medium";
      case Period.abundant:
        return "Abundant";
    }
  }
}
