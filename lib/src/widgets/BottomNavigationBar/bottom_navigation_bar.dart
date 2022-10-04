  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    super.dispose();
  }
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController.value : 1,
                child: Icon(icon,
                    color: isEnable
                        ? LightColor.background
                        : Theme.of(context).iconTheme.color),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    final inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController.value),
            end: inCurve.transform(_yController.value),
          ).transform(_yController.velocity.sign * 0.5 + 0.5),
          Theme.of(context).backgroundColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController.isAnimating) return;
    widget.onIconPresedCallback(index);
    setState(() {
      _selectedIndex = index;
    });

    _yController.value = 1.0;
    _xController.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    final height = 60.0;
    return Container(
      width: appSize.width,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _icon(Icons.home, _selectedIndex == 0, 0),
                _icon(Icons.search, _selectedIndex == 1, 1),
                _icon(Icons.card_travel, _selectedIndex == 2, 2),
                _icon(Icons.favorite_border, _selectedIndex == 3, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
