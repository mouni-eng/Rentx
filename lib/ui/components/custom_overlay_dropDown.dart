import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:rentx/size_config.dart';

/*class CustomDropDownOverLayWidget extends StatefulWidget {
  const CustomDropDownOverLayWidget({
    Key? key,
    this.title,
    required this.dropDownData,
  }) : super(key: key);

  final String? title;
  final Widget? dropDownData;

  @override
  State<CustomDropDownOverLayWidget> createState() =>
      _CustomDropDownRejectWidget();
}

class _CustomDropDownRejectWidget extends State<CustomDropDownOverLayWidget> {
  GlobalKey? actionKey = LabeledGlobalKey("dropdown");
  double? heights, widths, xPosition, yPosition;
  final _scrollController = ScrollController();

  void findDropdownData() {
    final renderBox = context.findRenderObject() as RenderBox;
    heights = renderBox.size.height;
    widths = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: xPosition,
          width: widths,
          top: yPosition! + heights! + height(7),
          height: 4 * heights! + 30,
          child: RentXWidget(
            builder: (rentxcontext) => Container(
              width: widths,
              height: height(284),
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
                vertical: height(8),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: rentxcontext.theme.customTheme.inputFieldBorder,
                ),
                color: rentxcontext.theme.customTheme.onPrimary,
              ),
              child: Scrollbar(
                thickness: width(4),
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: widget.dropDownData,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingStates>(
      listener: (context, state) {},
      builder: (context, state) {
        BookingCubit cubit = BookingCubit.get(context);
        return GestureDetector(
          onTap: () {
            if (cubit.floatingDropdown != null) {
              cubit.floatingDropdown!.remove();
              cubit.floatingDropdown = null;
            } else {
              findDropdownData();
              cubit.floatingDropdown = _createFloatingDropdown();
              Overlay.of(context)!.insert(cubit.floatingDropdown!);
            }
          },
          child: RentXWidget(
            builder: (rentxcontext) => Container(
              key: actionKey,
              height: height(47),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: width(16),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: rentxcontext.theme.customTheme.inputFieldBorder,
                ),
                color: rentxcontext.theme.customTheme.inputFieldFill,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                      color: rentxcontext.theme.customTheme.headdline,
                      fontSize: width(14),
                      text: widget.title!),
                  SvgPicture.asset("assets/img/dropdown.svg"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}*/

/*class CustomOverlay extends StatelessWidget {
  const CustomOverlay({
    Key? key,
    required this.widgetBuilder,
    required this.overlayBuilder,
    required this.onPressed,
    required this.onDismiss,
    this.overlay,
  }) : super(key: key);

  final Widget widgetBuilder, overlayBuilder;
  final Function(OverlayEntry overlay) onPressed;
  final Function() onDismiss;
  final OverlayEntry? overlay;

  @override
  Widget build(BuildContext context) {
    double? heights, widths, xPosition, yPosition;

    void findDropdownData() {
      final renderBox = context.findRenderObject() as RenderBox;
      heights = renderBox.size.height;
      widths = renderBox.size.width;
      Offset offset = renderBox.localToGlobal(Offset.zero);
      xPosition = offset.dx;
      yPosition = offset.dy;
    }

    /*OverlayEntry _createOverlay() {
      return OverlayEntry(
        builder: (context) {
          return Positioned(
            left: offset.dx,
            width: renderBox.size.width,
            top: offset.dy! + renderBox.size.height! + height(7),
            height: 8.5 * renderBox.size.height! + 30,
            child: overlayBuilder,
          );
        },
      );
    }*/

    return GestureDetector(
      onTap: () {
        if (overlay != null) {
          onDismiss();
        } else {
          findDropdownData();
          onPressed(_createOverlay());
          Overlay.of(context)!.insert(overlay!);
        }
        /*if (overlay != null) {
          overlay!.remove();
          overlay = null;
        } else {
          findDropdownData();
          overlay = _createFloatingDropdown();
          Overlay.of(context)!.insert(overlay!);
        }*/
      },
      child: widgetBuilder,
    );
  }
}*/

class CustomOverLayWidget extends StatelessWidget {
  const CustomOverLayWidget(
      {Key? key,
      required this.widgetBuilder,
      required this.overlayBuilder,
      this.overLayHeight,
      required this.visible,
      this.onDismiss})
      : super(key: key);

  final Widget widgetBuilder, overlayBuilder;
  final bool visible;
  final void Function()? onDismiss;
  final double? overLayHeight;

  @override
  Widget build(BuildContext context) {
    return PortalTarget(
      visible: visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onDismiss,
      ),
      child: PortalTarget(
        visible: visible,
        anchor: const Aligned(
          target: Alignment.bottomCenter,
          follower: Alignment.topCenter,
          portal: Alignment.topCenter,
        ),
        portalFollower: Container(
          margin: EdgeInsets.symmetric(
            horizontal: width(16),
            vertical: height(10),
          ),
          height: overLayHeight,
          child: overlayBuilder,
        ),
        child: GestureDetector(onTap: onDismiss, child: widgetBuilder),
      ),
    );
  }
}
