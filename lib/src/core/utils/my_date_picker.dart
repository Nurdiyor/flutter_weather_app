// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

const Size _calendarPortraitDialogSize = Size(330.0, 518.0);
const Size _calendarLandscapeDialogSize = Size(496.0, 346.0);
const Size _inputPortraitDialogSize = Size(330.0, 270.0);
const Size _inputLandscapeDialogSize = Size(496, 160.0);
const Duration _dialogSizeAnimationDuration = Duration(milliseconds: 200);

Future<DateTime?> showDatePickerX({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
  DateTime? currentDate,
  DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
  SelectableDayPredicate? selectableDayPredicate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  Locale? locale,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  TextDirection? textDirection,
  TransitionBuilder? builder,
  DatePickerMode initialDatePickerMode = DatePickerMode.day,
  String? errorFormatText,
  String? errorInvalidText,
  String? fieldHintText,
  String? fieldLabelText,
}) async {
  assert(context != null);
  assert(initialDate != null);
  assert(firstDate != null);
  assert(lastDate != null);
  initialDate = DateUtils.dateOnly(initialDate);
  firstDate = DateUtils.dateOnly(firstDate);
  lastDate = DateUtils.dateOnly(lastDate);
  assert(
    !lastDate.isBefore(firstDate),
    'lastDate $lastDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isBefore(firstDate),
    'initialDate $initialDate must be on or after firstDate $firstDate.',
  );
  assert(
    !initialDate.isAfter(lastDate),
    'initialDate $initialDate must be on or before lastDate $lastDate.',
  );
  assert(
    selectableDayPredicate == null || selectableDayPredicate(initialDate),
    'Provided initialDate $initialDate must satisfy provided selectableDayPredicate.',
  );
  assert(initialEntryMode != null);
  assert(useRootNavigator != null);
  assert(initialDatePickerMode != null);
  assert(debugCheckHasMaterialLocalizations(context));

  Widget dialog = DatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    selectableDayPredicate: selectableDayPredicate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    initialCalendarMode: initialDatePickerMode,
    errorFormatText: errorFormatText,
    errorInvalidText: errorInvalidText,
    fieldHintText: fieldHintText,
    fieldLabelText: fieldLabelText,
  );

  if (textDirection != null) {
    dialog = Directionality(
      textDirection: textDirection,
      child: dialog,
    );
  }

  if (locale != null) {
    dialog = Localizations.override(
      context: context,
      locale: locale,
      child: dialog,
    );
  }

  return showDialog<DateTime>(
    context: context,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    builder: (BuildContext context) {
      return builder == null ? dialog : builder(context, dialog);
    },
  );
}

/// A Material-style date picker dialog.
///
/// It is used internally by [showDatePicker] or can be directly pushed
/// onto the [Navigator] stack to enable state restoration. See
/// [showDatePicker] for a state restoration app example.
///
/// See also:
///
///  * [showDatePicker], which is a way to display the date picker.
class DatePickerDialog extends StatefulWidget {
  /// A Material-style date picker dialog.
  DatePickerDialog({
    Key? key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    DateTime? currentDate,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.initialCalendarMode = DatePickerMode.day,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.restorationId,
  })  : assert(initialDate != null),
        assert(firstDate != null),
        assert(lastDate != null),
        initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        currentDate = DateUtils.dateOnly(currentDate ?? DateTime.now()),
        assert(initialEntryMode != null),
        assert(initialCalendarMode != null),
        super(key: key) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
    assert(
      selectableDayPredicate == null ||
          selectableDayPredicate!(this.initialDate),
      'Provided initialDate ${this.initialDate} must satisfy provided selectableDayPredicate',
    );
  }

  /// The initially selected [DateTime] that the picker should display.
  final DateTime initialDate;

  /// The earliest allowable [DateTime] that the user can select.
  final DateTime firstDate;

  /// The latest allowable [DateTime] that the user can select.
  final DateTime lastDate;

  /// The [DateTime] representing today. It will be highlighted in the day grid.
  final DateTime currentDate;

  /// The initial mode of date entry method for the date picker dialog.
  ///
  /// See [DatePickerEntryMode] for more details on the different data entry
  /// modes available.
  final DatePickerEntryMode initialEntryMode;

  /// Function to provide full control over which [DateTime] can be selected.
  final SelectableDayPredicate? selectableDayPredicate;

  /// The text that is displayed on the cancel button.
  final String? cancelText;

  /// The text that is displayed on the confirm button.
  final String? confirmText;

  /// The text that is displayed at the top of the header.
  ///
  /// This is used to indicate to the user what they are selecting a date for.
  final String? helpText;

  /// The initial display of the calendar picker.
  final DatePickerMode initialCalendarMode;

  final String? errorFormatText;

  final String? errorInvalidText;

  final String? fieldHintText;

  final String? fieldLabelText;

  final String? restorationId;

  @override
  _DatePickerDialogState createState() => _DatePickerDialogState();
}

class _DatePickerDialogState extends State<DatePickerDialog>
    with RestorationMixin {
  late final RestorableDateTime _selectedDate =
      RestorableDateTime(widget.initialDate);
  late final _RestorableDatePickerEntryMode _entryMode =
      _RestorableDatePickerEntryMode(widget.initialEntryMode);
  final RestorableBool _autoValidate = RestorableBool(false);

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_autoValidate, 'autovalidate');
    registerForRestoration(_entryMode, 'calendar_entry_mode');
  }

  final GlobalKey _calendarPickerKey = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleOk() {
    if (_entryMode.value == DatePickerEntryMode.input ||
        _entryMode.value == DatePickerEntryMode.inputOnly) {
      final FormState form = _formKey.currentState!;
      if (!form.validate()) {
        setState(() => _autoValidate.value = true);
        return;
      }
      form.save();
    }
    Navigator.pop(context, _selectedDate.value);
  }

  void _handleDateChanged(DateTime date) {
    setState(() {
      _selectedDate.value = date;
      //qushdim//
      Navigator.pop(context, _selectedDate.value);
    });
  }

  Size _dialogSize(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    switch (_entryMode.value) {
      case DatePickerEntryMode.calendar:
      case DatePickerEntryMode.calendarOnly:
        switch (orientation) {
          case Orientation.portrait:
            return _calendarPortraitDialogSize;
          case Orientation.landscape:
            return _calendarLandscapeDialogSize;
        }
      case DatePickerEntryMode.input:
      case DatePickerEntryMode.inputOnly:
        switch (orientation) {
          case Orientation.portrait:
            return _inputPortraitDialogSize;
          case Orientation.landscape:
            return _inputLandscapeDialogSize;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.of(context).orientation;
    final TextTheme textTheme = theme.textTheme;
    // Constrain the textScaleFactor to the largest supported value to prevent
    // layout issues.
    final double textScaleFactor =
        math.min(MediaQuery.of(context).textScaleFactor, 1.3);

    final String dateText = localizations.formatMediumDate(_selectedDate.value);
    final Color onPrimarySurface = colorScheme.brightness == Brightness.light
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final TextStyle? dateStyle = orientation == Orientation.landscape
        ? textTheme.headline5?.copyWith(color: onPrimarySurface)
        : textTheme.headline4?.copyWith(color: onPrimarySurface);

    CalendarDatePicker calendarDatePicker() {
      return CalendarDatePicker(
        key: _calendarPickerKey,
        initialDate: _selectedDate.value,
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        currentDate: widget.currentDate,
        onDateChanged: _handleDateChanged,
        selectableDayPredicate: widget.selectableDayPredicate,
        initialCalendarMode: widget.initialCalendarMode,
      );
    }

    final Widget picker;
    picker = calendarDatePicker();

    final Size dialogSize = _dialogSize(context) * textScaleFactor;
    return Dialog(
      child: AnimatedContainer(
        width: dialogSize.width,
        // height: dialogSize.height,
        duration: _dialogSizeAnimationDuration,
        curve: Curves.easeIn,
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: textScaleFactor,
          ),
          child: Builder(builder: (BuildContext context) {
            switch (orientation) {
              case Orientation.portrait:
                return picker;
              case Orientation.landscape:
                return picker;
            }
          }),
        ),
      ),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      clipBehavior: Clip.antiAlias,
    );
  }
}

class _RestorableDatePickerEntryMode
    extends RestorableValue<DatePickerEntryMode> {
  _RestorableDatePickerEntryMode(
    DatePickerEntryMode defaultValue,
  ) : _defaultValue = defaultValue;

  final DatePickerEntryMode _defaultValue;

  @override
  DatePickerEntryMode createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(DatePickerEntryMode? oldValue) {
    assert(debugIsSerializableForRestoration(value.index));
    notifyListeners();
  }

  @override
  DatePickerEntryMode fromPrimitives(Object? data) =>
      DatePickerEntryMode.values[data! as int];

  @override
  Object? toPrimitives() => value.index;
}

const Duration _monthScrollDuration = Duration(milliseconds: 200);

const double _monthItemHeaderHeight = 58.0;
const double _monthItemFooterHeight = 12.0;
const double _monthItemRowHeight = 42.0;
const double _monthItemSpaceBetweenRows = 8.0;
const double _horizontalPadding = 8.0;
const double _maxCalendarWidthLandscape = 384.0;
const double _maxCalendarWidthPortrait = 480.0;

class _CalendarKeyboardNavigator extends StatefulWidget {
  const _CalendarKeyboardNavigator({
    Key? key,
    required this.child,
    required this.firstDate,
    required this.lastDate,
    required this.initialFocusedDay,
  }) : super(key: key);

  final Widget child;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime initialFocusedDay;

  @override
  _CalendarKeyboardNavigatorState createState() =>
      _CalendarKeyboardNavigatorState();
}

class _CalendarKeyboardNavigatorState
    extends State<_CalendarKeyboardNavigator> {
  late Map<LogicalKeySet, Intent> _shortcutMap;
  late Map<Type, Action<Intent>> _actionMap;
  late FocusNode _dayGridFocus;
  TraversalDirection? _dayTraversalDirection;
  DateTime? _focusedDay;

  @override
  void initState() {
    super.initState();

    _shortcutMap = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.arrowLeft):
          const DirectionalFocusIntent(TraversalDirection.left),
      LogicalKeySet(LogicalKeyboardKey.arrowRight):
          const DirectionalFocusIntent(TraversalDirection.right),
      LogicalKeySet(LogicalKeyboardKey.arrowDown):
          const DirectionalFocusIntent(TraversalDirection.down),
      LogicalKeySet(LogicalKeyboardKey.arrowUp):
          const DirectionalFocusIntent(TraversalDirection.up),
    };
    _actionMap = <Type, Action<Intent>>{
      NextFocusIntent:
          CallbackAction<NextFocusIntent>(onInvoke: _handleGridNextFocus),
      PreviousFocusIntent: CallbackAction<PreviousFocusIntent>(
          onInvoke: _handleGridPreviousFocus),
      DirectionalFocusIntent: CallbackAction<DirectionalFocusIntent>(
          onInvoke: _handleDirectionFocus),
    };
    _dayGridFocus = FocusNode(debugLabel: 'Day Grid');
  }

  @override
  void dispose() {
    _dayGridFocus.dispose();
    super.dispose();
  }

  void _handleGridFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _focusedDay ??= widget.initialFocusedDay;
      }
    });
  }

  /// Move focus to the next element after the day grid.
  void _handleGridNextFocus(NextFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.nextFocus();
  }

  /// Move focus to the previous element before the day grid.
  void _handleGridPreviousFocus(PreviousFocusIntent intent) {
    _dayGridFocus.requestFocus();
    _dayGridFocus.previousFocus();
  }

  /// Move the internal focus date in the direction of the given intent.
  ///
  /// This will attempt to move the focused day to the next selectable day in
  /// the given direction. If the new date is not in the current month, then
  /// the page view will be scrolled to show the new date's month.
  ///
  /// For horizontal directions, it will move forward or backward a day (depending
  /// on the current [TextDirection]). For vertical directions it will move up and
  /// down a week at a time.
  void _handleDirectionFocus(DirectionalFocusIntent intent) {
    assert(_focusedDay != null);
    setState(() {
      final DateTime? nextDate =
          _nextDateInDirection(_focusedDay!, intent.direction);
      if (nextDate != null) {
        _focusedDay = nextDate;
        _dayTraversalDirection = intent.direction;
      }
    });
  }

  static const Map<TraversalDirection, int> _directionOffset =
      <TraversalDirection, int>{
    TraversalDirection.up: -DateTime.daysPerWeek,
    TraversalDirection.right: 1,
    TraversalDirection.down: DateTime.daysPerWeek,
    TraversalDirection.left: -1,
  };

  int _dayDirectionOffset(
      TraversalDirection traversalDirection, TextDirection textDirection) {
    // Swap left and right if the text direction if RTL
    if (textDirection == TextDirection.rtl) {
      if (traversalDirection == TraversalDirection.left)
        traversalDirection = TraversalDirection.right;
      else if (traversalDirection == TraversalDirection.right)
        traversalDirection = TraversalDirection.left;
    }
    return _directionOffset[traversalDirection]!;
  }

  DateTime? _nextDateInDirection(DateTime date, TraversalDirection direction) {
    final TextDirection textDirection = Directionality.of(context);
    final DateTime nextDate = DateUtils.addDaysToDate(
        date, _dayDirectionOffset(direction, textDirection));
    if (!nextDate.isBefore(widget.firstDate) &&
        !nextDate.isAfter(widget.lastDate)) {
      return nextDate;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      shortcuts: _shortcutMap,
      actions: _actionMap,
      focusNode: _dayGridFocus,
      onFocusChange: _handleGridFocusChange,
      child: _FocusedDate(
        date: _dayGridFocus.hasFocus ? _focusedDay : null,
        scrollDirection: _dayGridFocus.hasFocus ? _dayTraversalDirection : null,
        child: widget.child,
      ),
    );
  }
}

/// InheritedWidget indicating what the current focused date is for its children.
///
/// This is used by the [_MonthPicker] to let its children [_DayPicker]s know
/// what the currently focused date (if any) should be.
class _FocusedDate extends InheritedWidget {
  const _FocusedDate({
    Key? key,
    required Widget child,
    this.date,
    this.scrollDirection,
  }) : super(key: key, child: child);

  final DateTime? date;
  final TraversalDirection? scrollDirection;

  @override
  bool updateShouldNotify(_FocusedDate oldWidget) {
    return !DateUtils.isSameDay(date, oldWidget.date) ||
        scrollDirection != oldWidget.scrollDirection;
  }

  static _FocusedDate? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_FocusedDate>();
  }
}

class _MonthItemGridDelegate extends SliverGridDelegate {
  const _MonthItemGridDelegate();

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final double tileWidth =
        (constraints.crossAxisExtent - 2 * _horizontalPadding) /
            DateTime.daysPerWeek;
    return _MonthSliverGridLayout(
      crossAxisCount: DateTime.daysPerWeek + 2,
      dayChildWidth: tileWidth,
      edgeChildWidth: _horizontalPadding,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(_MonthItemGridDelegate oldDelegate) => false;
}

const _MonthItemGridDelegate _monthItemGridDelegate = _MonthItemGridDelegate();

class _MonthSliverGridLayout extends SliverGridLayout {
  const _MonthSliverGridLayout({
    required this.crossAxisCount,
    required this.dayChildWidth,
    required this.edgeChildWidth,
    required this.reverseCrossAxis,
  })  : assert(crossAxisCount != null && crossAxisCount > 0),
        assert(dayChildWidth != null && dayChildWidth >= 0),
        assert(edgeChildWidth != null && edgeChildWidth >= 0),
        assert(reverseCrossAxis != null);

  /// The number of children in the cross axis.
  final int crossAxisCount;

  /// The width in logical pixels of the day child widgets.
  final double dayChildWidth;

  /// The width in logical pixels of the edge child widgets.
  final double edgeChildWidth;

  /// Whether the children should be placed in the opposite order of increasing
  /// coordinates in the cross axis.
  ///
  /// For example, if the cross axis is horizontal, the children are placed from
  /// left to right when [reverseCrossAxis] is false and from right to left when
  /// [reverseCrossAxis] is true.
  ///
  /// Typically set to the return value of [axisDirectionIsReversed] applied to
  /// the [SliverConstraints.crossAxisDirection].
  final bool reverseCrossAxis;

  /// The number of logical pixels from the leading edge of one row to the
  /// leading edge of the next row.
  double get _rowHeight {
    return _monthItemRowHeight + _monthItemSpaceBetweenRows;
  }

  /// The height in logical pixels of the children widgets.
  double get _childHeight {
    return _monthItemRowHeight;
  }

  @override
  int getMinChildIndexForScrollOffset(double scrollOffset) {
    return crossAxisCount * (scrollOffset ~/ _rowHeight);
  }

  @override
  int getMaxChildIndexForScrollOffset(double scrollOffset) {
    final int mainAxisCount = (scrollOffset / _rowHeight).ceil();
    return math.max(0, crossAxisCount * mainAxisCount - 1);
  }

  double _getCrossAxisOffset(double crossAxisStart, bool isPadding) {
    if (reverseCrossAxis) {
      return ((crossAxisCount - 2) * dayChildWidth + 2 * edgeChildWidth) -
          crossAxisStart -
          (isPadding ? edgeChildWidth : dayChildWidth);
    }
    return crossAxisStart;
  }

  @override
  SliverGridGeometry getGeometryForChildIndex(int index) {
    final int adjustedIndex = index % crossAxisCount;
    final bool isEdge =
        adjustedIndex == 0 || adjustedIndex == crossAxisCount - 1;
    final double crossAxisStart =
        math.max(0, (adjustedIndex - 1) * dayChildWidth + edgeChildWidth);

    return SliverGridGeometry(
      scrollOffset: (index ~/ crossAxisCount) * _rowHeight,
      crossAxisOffset: _getCrossAxisOffset(crossAxisStart, isEdge),
      mainAxisExtent: _childHeight,
      crossAxisExtent: isEdge ? edgeChildWidth : dayChildWidth,
    );
  }

  @override
  double computeMaxScrollOffset(int childCount) {
    assert(childCount >= 0);
    final int mainAxisCount = ((childCount - 1) ~/ crossAxisCount) + 1;
    final double mainAxisSpacing = _rowHeight - _childHeight;
    return _rowHeight * mainAxisCount - mainAxisSpacing;
  }
}

/// Displays the days of a given month and allows choosing a date range.
///
/// The days are arranged in a rectangular grid with one column for each day of
/// the week.
class _MonthItem extends StatefulWidget {
  /// Creates a month item.
  _MonthItem({
    Key? key,
    required this.selectedDateStart,
    required this.selectedDateEnd,
    required this.currentDate,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    required this.displayedMonth,
    this.dragStartBehavior = DragStartBehavior.start,
  })  : assert(firstDate != null),
        assert(lastDate != null),
        assert(!firstDate.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            !selectedDateStart.isBefore(firstDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isBefore(firstDate)),
        assert(
            selectedDateStart == null || !selectedDateStart.isAfter(lastDate)),
        assert(selectedDateEnd == null || !selectedDateEnd.isAfter(lastDate)),
        assert(selectedDateStart == null ||
            selectedDateEnd == null ||
            !selectedDateStart.isAfter(selectedDateEnd)),
        assert(currentDate != null),
        assert(onChanged != null),
        assert(displayedMonth != null),
        assert(dragStartBehavior != null),
        super(key: key);

  /// The currently selected start date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDateStart;

  /// The currently selected end date.
  ///
  /// This date is highlighted in the picker.
  final DateTime? selectedDateEnd;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  final DateTime firstDate;

  /// The latest date the user is permitted to pick.
  final DateTime lastDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  final DragStartBehavior dragStartBehavior;

  @override
  _MonthItemState createState() => _MonthItemState();
}

class _MonthItemState extends State<_MonthItem> {
  /// List of [FocusNode]s, one for each day of the month.
  late List<FocusNode> _dayFocusNodes;

  @override
  void initState() {
    super.initState();
    final int daysInMonth = DateUtils.getDaysInMonth(
        widget.displayedMonth.year, widget.displayedMonth.month);
    _dayFocusNodes = List<FocusNode>.generate(
      daysInMonth,
      (int index) =>
          FocusNode(skipTraversal: true, debugLabel: 'Day ${index + 1}'),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check to see if the focused date is in this month, if so focus it.
    final DateTime? focusedDate = _FocusedDate.of(context)?.date;
    if (focusedDate != null &&
        DateUtils.isSameMonth(widget.displayedMonth, focusedDate)) {
      _dayFocusNodes[focusedDate.day - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (final FocusNode node in _dayFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Color _highlightColor(BuildContext context) {
    return Theme.of(context).colorScheme.primary.withOpacity(0.12);
  }

  void _dayFocusChanged(bool focused) {
    if (focused) {
      final TraversalDirection? focusDirection =
          _FocusedDate.of(context)?.scrollDirection;
      if (focusDirection != null) {
        ScrollPositionAlignmentPolicy policy =
            ScrollPositionAlignmentPolicy.explicit;
        switch (focusDirection) {
          case TraversalDirection.up:
          case TraversalDirection.left:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtStart;
            break;
          case TraversalDirection.right:
          case TraversalDirection.down:
            policy = ScrollPositionAlignmentPolicy.keepVisibleAtEnd;
            break;
        }
        Scrollable.ensureVisible(
          primaryFocus!.context!,
          duration: _monthScrollDuration,
          alignmentPolicy: policy,
        );
      }
    }
  }

  Widget _buildDayItem(BuildContext context, DateTime dayToBuild,
      int firstDayOffset, int daysInMonth) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final TextDirection textDirection = Directionality.of(context);
    final Color highlightColor = _highlightColor(context);
    final int day = dayToBuild.day;

    final bool isDisabled = dayToBuild.isAfter(widget.lastDate) ||
        dayToBuild.isBefore(widget.firstDate);

    BoxDecoration? decoration;
    TextStyle? itemStyle = textTheme.bodyText2;

    final bool isRangeSelected =
        widget.selectedDateStart != null && widget.selectedDateEnd != null;
    final bool isSelectedDayStart = widget.selectedDateStart != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateStart!);
    final bool isSelectedDayEnd = widget.selectedDateEnd != null &&
        dayToBuild.isAtSameMomentAs(widget.selectedDateEnd!);
    final bool isInRange = isRangeSelected &&
        dayToBuild.isAfter(widget.selectedDateStart!) &&
        dayToBuild.isBefore(widget.selectedDateEnd!);

    _HighlightPainter? highlightPainter;

    if (isSelectedDayStart || isSelectedDayEnd) {
      // The selected start and end dates gets a circle background
      // highlight, and a contrasting text color.
      itemStyle = textTheme.bodyText2?.apply(color: colorScheme.onPrimary);
      decoration = BoxDecoration(
        color: colorScheme.primary,
        shape: BoxShape.circle,
      );

      if (isRangeSelected &&
          widget.selectedDateStart != widget.selectedDateEnd) {
        final _HighlightPainterStyle style = isSelectedDayStart
            ? _HighlightPainterStyle.highlightTrailing
            : _HighlightPainterStyle.highlightLeading;
        highlightPainter = _HighlightPainter(
          color: highlightColor,
          style: style,
          textDirection: textDirection,
        );
      }
    } else if (isInRange) {
      // The days within the range get a light background highlight.
      highlightPainter = _HighlightPainter(
        color: highlightColor,
        style: _HighlightPainterStyle.highlightAll,
        textDirection: textDirection,
      );
    } else if (isDisabled) {
      itemStyle = textTheme.bodyText2
          ?.apply(color: colorScheme.onSurface.withOpacity(0.38));
    } else if (DateUtils.isSameDay(widget.currentDate, dayToBuild)) {
      // The current day gets a different text color and a circle stroke
      // border.
      itemStyle = textTheme.bodyText2?.apply(color: colorScheme.primary);
      decoration = BoxDecoration(
        border: Border.all(color: colorScheme.primary, width: 1),
        shape: BoxShape.circle,
      );
    }

    // We want the day of month to be spoken first irrespective of the
    // locale-specific preferences or TextDirection. This is because
    // an accessibility user is more likely to be interested in the
    // day of month before the rest of the date, as they are looking
    // for the day of month. To do that we prepend day of month to the
    // formatted full date.
    String semanticLabel =
        '${localizations.formatDecimal(day)}, ${localizations.formatFullDate(dayToBuild)}';
    if (isSelectedDayStart) {
      semanticLabel =
          localizations.dateRangeStartDateSemanticLabel(semanticLabel);
    } else if (isSelectedDayEnd) {
      semanticLabel =
          localizations.dateRangeEndDateSemanticLabel(semanticLabel);
    }

    Widget dayWidget = Container(
      decoration: decoration,
      child: Center(
        child: Semantics(
          label: semanticLabel,
          selected: isSelectedDayStart || isSelectedDayEnd,
          child: ExcludeSemantics(
            child: Text(localizations.formatDecimal(day), style: itemStyle),
          ),
        ),
      ),
    );

    if (highlightPainter != null) {
      dayWidget = CustomPaint(
        painter: highlightPainter,
        child: dayWidget,
      );
    }

    if (!isDisabled) {
      dayWidget = InkResponse(
        focusNode: _dayFocusNodes[day - 1],
        onTap: () => widget.onChanged(dayToBuild),
        radius: _monthItemRowHeight / 2 + 4,
        splashColor: colorScheme.primary.withOpacity(0.38),
        onFocusChange: _dayFocusChanged,
        child: dayWidget,
      );
    }

    return dayWidget;
  }

  Widget _buildEdgeContainer(BuildContext context, bool isHighlighted) {
    return Container(color: isHighlighted ? _highlightColor(context) : null);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    final int weeks = ((daysInMonth + dayOffset) / DateTime.daysPerWeek).ceil();
    final double gridHeight =
        weeks * _monthItemRowHeight + (weeks - 1) * _monthItemSpaceBetweenRows;
    final List<Widget> dayItems = <Widget>[];

    for (int i = 0; true; i += 1) {
      // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
      // a leap year.
      final int day = i - dayOffset + 1;
      if (day > daysInMonth) break;
      if (day < 1) {
        dayItems.add(Container());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final Widget dayItem = _buildDayItem(
          context,
          dayToBuild,
          dayOffset,
          daysInMonth,
        );
        dayItems.add(dayItem);
      }
    }

    // Add the leading/trailing edge containers to each week in order to
    // correctly extend the range highlight.
    final List<Widget> paddedDayItems = <Widget>[];
    for (int i = 0; i < weeks; i++) {
      final int start = i * DateTime.daysPerWeek;
      final int end = math.min(
        start + DateTime.daysPerWeek,
        dayItems.length,
      );
      final List<Widget> weekList = dayItems.sublist(start, end);

      final DateTime dateAfterLeadingPadding =
          DateTime(year, month, start - dayOffset + 1);
      // Only color the edge container if it is after the start date and
      // on/before the end date.
      final bool isLeadingInRange = !(dayOffset > 0 && i == 0) &&
          widget.selectedDateStart != null &&
          widget.selectedDateEnd != null &&
          dateAfterLeadingPadding.isAfter(widget.selectedDateStart!) &&
          !dateAfterLeadingPadding.isAfter(widget.selectedDateEnd!);
      weekList.insert(0, _buildEdgeContainer(context, isLeadingInRange));

      // Only add a trailing edge container if it is for a full week and not a
      // partial week.
      if (end < dayItems.length ||
          (end == dayItems.length &&
              dayItems.length % DateTime.daysPerWeek == 0)) {
        final DateTime dateBeforeTrailingPadding =
            DateTime(year, month, end - dayOffset);
        // Only color the edge container if it is on/after the start date and
        // before the end date.
        final bool isTrailingInRange = widget.selectedDateStart != null &&
            widget.selectedDateEnd != null &&
            !dateBeforeTrailingPadding.isBefore(widget.selectedDateStart!) &&
            dateBeforeTrailingPadding.isBefore(widget.selectedDateEnd!);
        weekList.add(_buildEdgeContainer(context, isTrailingInRange));
      }

      paddedDayItems.addAll(weekList);
    }

    final double maxWidth =
        MediaQuery.of(context).orientation == Orientation.landscape
            ? _maxCalendarWidthLandscape
            : _maxCalendarWidthPortrait;
    return Column(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          height: _monthItemHeaderHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: AlignmentDirectional.centerStart,
          child: ExcludeSemantics(
            child: Text(
              localizations.formatMonthYear(widget.displayedMonth),
              style: textTheme.bodyText2!
                  .apply(color: themeData.colorScheme.onSurface),
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: gridHeight,
          ),
          child: GridView.custom(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: _monthItemGridDelegate,
            childrenDelegate: SliverChildListDelegate(
              paddedDayItems,
              addRepaintBoundaries: false,
            ),
          ),
        ),
        const SizedBox(height: _monthItemFooterHeight),
      ],
    );
  }
}

/// Determines which style to use to paint the highlight.
enum _HighlightPainterStyle {
  /// Paints nothing.
  none,

  /// Paints a rectangle that occupies the leading half of the space.
  highlightLeading,

  /// Paints a rectangle that occupies the trailing half of the space.
  highlightTrailing,

  /// Paints a rectangle that occupies all available space.
  highlightAll,
}

/// This custom painter will add a background highlight to its child.
///
/// This highlight will be drawn depending on the [style], [color], and
/// [textDirection] supplied. It will either paint a rectangle on the
/// left/right, a full rectangle, or nothing at all. This logic is determined by
/// a combination of the [style] and [textDirection].
class _HighlightPainter extends CustomPainter {
  _HighlightPainter({
    required this.color,
    this.style = _HighlightPainterStyle.none,
    this.textDirection,
  });

  final Color color;
  final _HighlightPainterStyle style;
  final TextDirection? textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    if (style == _HighlightPainterStyle.none) {
      return;
    }

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Rect rectLeft = Rect.fromLTWH(0, 0, size.width / 2, size.height);
    final Rect rectRight =
        Rect.fromLTWH(size.width / 2, 0, size.width / 2, size.height);

    switch (style) {
      case _HighlightPainterStyle.highlightTrailing:
        canvas.drawRect(
          textDirection == TextDirection.ltr ? rectRight : rectLeft,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightLeading:
        canvas.drawRect(
          textDirection == TextDirection.ltr ? rectLeft : rectRight,
          paint,
        );
        break;
      case _HighlightPainterStyle.highlightAll:
        canvas.drawRect(
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint,
        );
        break;
      case _HighlightPainterStyle.none:
        break;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
