import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/google_places_service.dart';
import '../utils/app_colors.dart';

class PlacesAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final void Function(double lat, double lng)? onCoordinatesSelected;

  const PlacesAutocompleteField({
    super.key,
    required this.controller,
    required this.hint,
    this.onCoordinatesSelected,
  });

  @override
  State<PlacesAutocompleteField> createState() => _PlacesAutocompleteFieldState();
}

class _PlacesAutocompleteFieldState extends State<PlacesAutocompleteField> {
  final _focusNode = FocusNode();
  final _layerLink = LayerLink();
  final _service = GooglePlacesService();

  OverlayEntry? _overlay;
  List<PlacePrediction> _predictions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus) _removeOverlay();
  }

  void _onTextChanged() {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _fetch(widget.controller.text),
    );
  }

  Future<void> _fetch(String input) async {
    if (!_focusNode.hasFocus) return;
    final results = await _service.autocomplete(input);
    if (!mounted) return;
    _predictions = results;
    if (results.isEmpty) {
      _removeOverlay();
    } else if (_overlay == null) {
      _showOverlay();
    } else {
      _overlay!.markNeedsBuild();
    }
  }

  Future<void> _onPredictionTapped(PlacePrediction prediction) async {
    widget.controller.text = prediction.description;
    _removeOverlay();
    _focusNode.unfocus();

    if (widget.onCoordinatesSelected != null) {
      final coords = await _service.getCoordinates(prediction.placeId);
      if (coords != null && mounted) {
        widget.onCoordinatesSelected!(coords.lat, coords.lng);
      }
    }
  }

  void _showOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final width = renderBox.size.width;
    _overlay = OverlayEntry(builder: (ctx) => _buildOverlayContent(width));
    Overlay.of(context).insert(_overlay!);
  }

  void _removeOverlay() {
    _overlay?.remove();
    _overlay = null;
  }

  Widget _buildOverlayContent(double width) {
    return CompositedTransformFollower(
      link: _layerLink,
      showWhenUnlinked: false,
      offset: const Offset(0, 52),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: width,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(6),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 220),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.warmGrey),
              ),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: _predictions.length,
                separatorBuilder: (_, index) =>
                    const Divider(height: 1, color: AppColors.warmGrey),
                itemBuilder: (_, i) => InkWell(
                  onTap: () => _onPredictionTapped(_predictions[i]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _predictions[i].description,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _removeOverlay();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary10,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: AppColors.warmGrey, width: 1),
        ),
        child: TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          style: GoogleFonts.beVietnamPro(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 1.0,
            letterSpacing: 0,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: GoogleFonts.beVietnamPro(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 1.0,
              letterSpacing: 0,
              color: AppColors.textBlack60,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            suffixIcon: const Icon(
              Icons.location_searching,
              color: AppColors.primary,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
