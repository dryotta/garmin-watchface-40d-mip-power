using Toybox.WatchUi as Ui;
using Toybox.Math;
using Toybox.Graphics;

module DataFieldIcons {
  //! dc => Drawable object
  //! x  => x-Axis center point
  //! y  => y-Axis center point
  //! size    => max. height & width of the object
  //! penSize => stroke width for unfilled areas

  function drawBattery(dc, x, y, size, penSize) {
    _setAntiAlias(dc);

    var buffer = _getBuffer(size);
    dc.fillPolygon([
      [x + (size / 2.0) - buffer, y], // right outer edge
      [x - (buffer + penSize), y + size / 2.0],  // bottom edge
      [x - 1, y + buffer], // left  inner edge
      [x - (size / 2.0) + buffer, y], // left edge
      [x + buffer + penSize, y - size / 2.0], // top edge
      [x + 1, y - buffer] // right inner edge
    ]);

    _unsetAntiAlias(dc);
  }

  function drawBatteryLow(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize * 0.75);
    var buffer = _getBuffer(size);
    var unfilledSize = size - penSize;
    dc.drawLine(x + (unfilledSize / 2.0) - buffer, y, x - (buffer + penSize), y + unfilledSize / 2.0);
    dc.drawLine(x - (buffer + penSize), y + unfilledSize / 2.0, x - 1, y + buffer);
    dc.drawLine(x - 1, y + buffer, x - (unfilledSize / 2.0) + buffer, y);
    dc.drawLine(x - (unfilledSize / 2.0) + buffer, y, x + penSize, y - (unfilledSize / 2.0));
    dc.drawLine(x + penSize, y - (unfilledSize / 2.0), x + 1, y - buffer);
    dc.drawLine(x + 1, y - buffer, x + (unfilledSize / 2.0) - buffer, y);

    _unsetAntiAlias(dc);
  }

  function drawBatteryLoading(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    var buffer = _getBuffer(size);
    drawBattery(dc, x - buffer, y, size, penSize);

    // arrow up
    dc.fillPolygon([
      [x + size / 2.0, y - size / 4.0 + buffer],
      [x + size / 6.0, y - size / 4.0 + buffer],
      [x + size / 3.0, y - size / 2.0 + buffer]
    ]);
    _unsetAntiAlias(dc);
  }

  function drawSteps(dc, x, y, size, penSize) {
    _setAntiAlias(dc);

    var buffer = _getBuffer(size);
    var bodyWeight = penSize * 1.8;
    var limbWeight = penSize;
    var angleTan = Math.tan(Math.toRadians(20));

    var pos1 = size / 3.0 + buffer;
    dc.fillCircle(x + pos1 * angleTan, y - pos1, penSize);
    
    dc.setPenWidth(bodyWeight);
    pos1 = size / 6.0;
    dc.drawLine(x + pos1 * angleTan, y - pos1, x - pos1 * angleTan, y + pos1);

    dc.setPenWidth(limbWeight);
    var pos2 = size / 2.0;
    // foot back
    dc.drawLine(x - pos1 * angleTan, y + pos1, x - pos2 * angleTan, y + pos2);
    dc.drawLine(x - pos1 * angleTan, y + pos1, x + size / 6.0, y + (size / 3.0));
    dc.drawLine(x + size / 6.0, y + (size / 3.0), x + size / 6.0 + buffer, y + pos2);
  
    // arm back
    dc.drawLine(x + pos1 * angleTan, y - pos1, x - (size / 4.0), y);
    dc.drawLine(x - (size / 4.0), y, x - (size / 4.0), y + limbWeight);

     // arm front
    dc.drawLine(x + pos1 * angleTan, y - pos1, x + (size / 6.0), y);
    dc.drawLine(x + (size / 6.0), y, x + size / 3.0, y + buffer);

    _unsetAntiAlias(dc);
  }

  function drawCalories(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize * 0.75);
    
    var buffer = _getBuffer(size);
    var radius = size - penSize -buffer;
    // first layer
    var x1 = x - radius / 2.0;
    var x2 = x + radius / 2.0;
    var y1 = y - radius / 2.0;
    var y2 = y + radius / 2.0;
    
    dc.drawArc(x1, y1, radius, Graphics.ARC_CLOCKWISE, 0, 270);
    dc.drawArc(x2, y2, radius, Graphics.ARC_CLOCKWISE, 180, 90);
    dc.fillCircle(x1 + radius * Math.cos(Math.toRadians(80)), y1 + radius * Math.sin(Math.toRadians(80)), penSize);

    // second layer
    dc.drawArc(x2, y1, radius, Graphics.ARC_CLOCKWISE, 270, 180);
    dc.drawArc(x1, y2, radius, Graphics.ARC_CLOCKWISE, 90, 0);
    dc.fillCircle(x1 + radius * Math.cos(Math.toRadians(290)), y2 + radius * Math.sin(Math.toRadians(290)), penSize);

    // core
    dc.fillCircle(x, y, penSize);
    
    _unsetAntiAlias(dc);
  }

  function drawActiveMinutes(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);

    y = y + penSize / 2;
    x = x + penSize / 2;
    var buffer = _getBuffer(size);
    var radius = (size - penSize - buffer) / 2.0;
    dc.drawCircle(x, y, radius); // watch

    // watch button top
    dc.drawLine(x, y - radius - penSize, x, y - radius);
    dc.drawLine(x - buffer, y - radius - (penSize * 1.5), x + buffer, y - radius - (penSize * 1.5));

    // watch button side
    var degree = Math.toRadians(135);
    var buttonX1 = (x - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.cos(degree));
    var buttonX2 = (x - size / 2.0) + size - (size / 2.0 + radius * Math.cos(degree));
    var buttonY1 = (y - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.sin(degree));
    var buttonY2 = (y - size / 2.0) + size - (size / 2.0 + radius * Math.sin(degree));
    dc.drawLine(buttonX1, buttonY1, buttonX2, buttonY2);

    dc.setPenWidth(penSize * 0.75);
    dc.drawLine(x, y - (size * 0.2), x, y); // watch hand up
    dc.drawLine(x, y, x + (size * 0.2), y); // watch hand right

    _unsetAntiAlias(dc);
  }

  function drawNotificationInactive(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);

    y = y + penSize / 2;
    x = x + penSize / 2;
    var buffer = _getBuffer(size);
    var radius = (size - penSize - buffer) / 2.0;

    dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, 100, 170);
    var degree = Math.toRadians(45);
    var smallX = (x - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.cos(degree));
    var smallY = (y - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.sin(degree));

    dc.setPenWidth(penSize * 0.75);
     dc.drawCircle(smallX, smallY, (radius - buffer) / 2.0);

    _unsetAntiAlias(dc);
  }

  function drawNotificationActive(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);

    y = y + penSize / 2;
    x = x + penSize / 2;
    var buffer = _getBuffer(size);
    var radius = (size - penSize - buffer) / 2.0;

    dc.drawArc(x, y, radius, Graphics.ARC_CLOCKWISE, 100, 170);
    var degree = Math.toRadians(45);
    var smallX = (x - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.cos(degree));
    var smallY = (y - size / 2.0) + size - (size / 2.0 + (radius + penSize / 2.0) * Math.sin(degree));

    dc.fillCircle(smallX, smallY, (radius - buffer) / 2.0);

    _unsetAntiAlias(dc);
  }

  function drawHeartRate(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);

    y = y + penSize / 2;
    x = x + penSize / 2;
    var buffer = _getBuffer(size);
    dc.drawLine(x - size / 2.0 + penSize, y, x - size / 6.0, y); // baseline
    dc.drawLine(x - size / 6.0, y, x - size / 12.0, y + size / 2.0 - buffer); // down
    dc.drawLine(x - size / 12.0, y + size / 2.0 - buffer, x + size / 12.0, y - size / 2.0 + buffer); // up
    dc.drawLine(x + size / 12.0, y - size / 2.0 + buffer, x + size / 6.0, y); // down
    dc.drawLine(x + size / 6.0, y, x + size / 2.0 - penSize, y); // baseline

    _unsetAntiAlias(dc);
  }

  function drawFloorsUp(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);

    var buffer = _getBuffer(size);
    var stairSize = Math.floor(size / 4.0);

    dc.fillRoundedRectangle(x - stairSize * 2, y + stairSize, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x - stairSize, y, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x, y - stairSize, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x + stairSize, y - stairSize * 2, stairSize, stairSize, 1);

    dc.fillPolygon([
      [x + stairSize * 2 - buffer, y - stairSize * 2 + buffer], // rechts rand
      [x + stairSize * 2, y - stairSize], // rechts unten
      [x - stairSize, y + stairSize * 2], // links unten
      [x - stairSize * 2 + buffer, y + stairSize * 2 - buffer], // links rand
    ]);
    // arrow up
    dc.fillPolygon([
      [x - size / 2.0, y - size / 4.0 + buffer],
      [x - size / 6.0, y - size / 4.0 + buffer],
      [x - size / 3.0, y - size / 2.0 + buffer]
    ]);

    _unsetAntiAlias(dc);
  }

  function drawFloorsDown(dc, x, y, size, penSize) {
    _setAntiAlias(dc);
    dc.setPenWidth(penSize);


    var buffer = _getBuffer(size);
    var stairSize = Math.floor(size / 4.0);

    dc.fillRoundedRectangle(x + stairSize, y + stairSize, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x, y, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x - stairSize, y - stairSize, stairSize, stairSize, 1);
    dc.fillRoundedRectangle(x - stairSize * 2, y - stairSize * 2, stairSize, stairSize, 1);

    dc.fillPolygon([
      [x - stairSize * 2 + buffer, y - stairSize * 2 + buffer], // rechts rand
      [x - stairSize * 2, y - stairSize], // rechts unten
      [x + stairSize, y + stairSize * 2], // links unten
      [x + stairSize * 2 - buffer, y + stairSize * 2 - buffer], // links rand
    ]);
    // arrow down
    dc.fillPolygon([
      [x + size / 2.0, y - size / 2.0 + buffer],
      [x + size / 6.0, y - size / 2.0 + buffer],
      [x + size / 3.0, y - size / 4.0 + buffer]
    ]);

    _unsetAntiAlias(dc);
  }

  function _getBuffer(size) {
    return size / 10.0;
  }

  function _setAntiAlias(dc) {
    if (dc has :setAntiAlias) {
      dc.setAntiAlias(true);
    }
  }

  function _unsetAntiAlias(dc) {
    if (dc has :setAntiAlias) {
      dc.setAntiAlias(false);
    }
  }

}