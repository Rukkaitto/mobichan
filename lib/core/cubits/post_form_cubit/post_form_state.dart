part of 'post_form_cubit.dart';

class PostFormState extends Equatable {
  final TextEditingController commentController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();

  static const double contractedHeight = 190;
  static const double expandedHeight = 320;
  static const double imageHeight = 50;

  final String comment;
  final bool isVisible;
  final double height;
  final XFile? file;

  PostFormState({
    this.comment = '',
    this.isVisible = false,
    this.height = contractedHeight,
    this.file,
  });

  @override
  List<Object?> get props => [comment, isVisible, height, file];

  bool get isExpanded => height == expandedHeight;

  double get heightWithImage => height + (file != null ? imageHeight : 0);
}
