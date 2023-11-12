import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sikshya/core/common/app/providers/user_provider.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get size => mediaQuery.size;
  double get width => size.width;
  double get height => size.height;
  UserProvider get userProvider => read<UserProvider>();
  EdgeInsets get padding => mediaQuery.padding;
  double get topPadding => padding.top;
}
