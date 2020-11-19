class Messages{
  final String simple_message;
  final String internal_message;

  Messages({
    this.simple_message,
    this.internal_message
  });

  factory Messages.fromJson(Map<String, dynamic> parsedJson){
    return Messages(
        simple_message:parsedJson['simple_message'],
        internal_message:parsedJson['internal_message']
    );
  }

}