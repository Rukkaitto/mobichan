part of 'post_form_cubit.dart';

class PostFormState extends Equatable {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  final bool isVisible;
  final bool isExpanded;

  PostFormState({
    this.isVisible = false,
    this.isExpanded = false,
  });

  @override
  List<Object> get props => [isVisible, isExpanded];
}
