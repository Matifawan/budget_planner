class UnboardingContent {
  String image; // Store the path as a string
  String title;
  String description;

  UnboardingContent({
    required this.image,
    required this.title,
    required this.description,
  });
}

List<UnboardingContent> contents = [
  UnboardingContent(
    title: 'Create Budgets',
    image: 'assets/images/4.png',
    description:
        'Effortlessly organize your finances by setting budgets for different categories.',
  ),
  UnboardingContent(
    title: 'Track Expenses',
    image: 'assets/images/y2.png',
    description:
        'Record and categorize your expenses to stay on top of your spending habits.',
  ),
  UnboardingContent(
    title: 'Visualize Savings',
    image: 'assets/images/e1.png',
    description:
        'See your savings grow with interactive charts and graphs, empowering you to achieve your financial goals.',
  ),
];

class UserModel {
  final String uid;
  final String displayName;
  final String email;

  UserModel({
    required this.uid,
    required this.displayName,
    required this.email,
  });
}
