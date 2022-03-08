part of 'post_form_cubit.dart';

// ignore: must_be_immutable
class PostFormState extends Equatable {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  static const double imageHeight = 50;

  final String comment;
  final bool isVisible;
  final bool isExpanded;
  XFile? file;

  PostFormState({
    this.comment = '',
    this.isVisible = false,
    this.isExpanded = false,
    this.file,
  });

  @override
  List<Object?> get props => [comment, isVisible, isExpanded, file];
}
