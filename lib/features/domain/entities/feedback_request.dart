class FeedbackRequest {
  int? feedbackRequestId;
  int? treatmentGlobalId;
  int? exerciseVideoGlobalId;
  String? performanceVideoDownloadURL;
  String? feedbackRequestDescription;
  String? customerUserEmail;
  String? systemManagerResponse;

  FeedbackRequest(
      this.feedbackRequestId,
      this.treatmentGlobalId,
      this.exerciseVideoGlobalId,
      this.performanceVideoDownloadURL,
      this.feedbackRequestDescription,
      this.customerUserEmail,
      );
}
