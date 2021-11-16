part of 'post_form_cubit.dart';

class PostFormState extends Equatable {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  final bool isVisible;
  final bool isExpanded;
  final XFile? file;

  PostFormState({
    this.isVisible = false,
    this.isExpanded = false,
    this.file,
  });

  @override
  List<Object?> get props => [isVisible, isExpanded, file];
}
