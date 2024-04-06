enum OperationTypes { insert, update, delete }

enum MessageStatuses { done, waiting, error }

enum VisibilityTypes {
  public,
  private,
}

VisibilityTypes visibilityTypeFromString(String visibility) {
  switch (visibility.toLowerCase()) {
    case 'public':
      return VisibilityTypes.public;
    case 'private':
      return VisibilityTypes.private;
    default:
      throw Exception('Invalid visibility type: $visibility');
  }
}

enum ChallengeTypes {
  fixed,
  unfixed,
}

ChallengeTypes challengeTypeFromString(String type) {
  switch (type.toLowerCase()) {
    case 'fixed':
      return ChallengeTypes.fixed;
    case 'unfixed':
      return ChallengeTypes.unfixed;
    default:
      throw Exception('Invalid challenge type: $type');
  }
}
