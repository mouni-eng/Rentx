import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentx/ui/base_widget.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int limit;
  final Color? color;
  final double? fontSize;

  const ExpandableText(
      {Key? key,
      required this.text,
      required this.limit,
      this.color,
      this.fontSize})
      : super(key: key);

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool showMore = true;

  @override
  Widget build(BuildContext context) {
    return RentXWidget(
        builder: (context) => RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                  text: showMore && widget.text.length > widget.limit
                      ? widget.text.substring(0, widget.limit)
                      : widget.text,
                  style: GoogleFonts.poppins(
                      color: widget.color, fontSize: widget.fontSize),
                ),
                TextSpan(
                    text: showMore
                        ? '... ${context.translate('readMore')}'
                        : context.translate('showLess'),
                    style: TextStyle(
                      color: context.theme.customTheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => setState(() {
                            showMore = !showMore;
                          })),
              ]),
            ));
  }
}
