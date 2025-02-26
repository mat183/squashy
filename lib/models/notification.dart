enum NotificationType {
  match_added,
  match_removed,
  match_updated,
  scheduled_match_reminder,
}

const Map<NotificationType, String> notifications = {
  NotificationType.match_added: 'match_added',
  NotificationType.match_removed: 'match_removed',
  NotificationType.match_updated: 'match_updated',
  NotificationType.scheduled_match_reminder: 'scheduled_match_reminder',
};
