// -*- mode:java; tab-width:2; c-basic-offset:2; intent-tabs-mode:nil; -*- ex: set tabstop=2 expandtab:

// Glider's Swiss Knife (GliderSK)
// Copyright (C) 2017-2019 Cedric Dufour <http://cedric.dufour.name>
//
// Glider's Swiss Knife (GliderSK) is free software:
// you can redistribute it and/or modify it under the terms of the GNU General
// Public License as published by the Free Software Foundation, Version 3.
//
// Glider's Swiss Knife (GliderSK) is distributed in the hope that it will be
// useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//
// See the GNU General Public License for more details.
//
// SPDX-License-Identifier: GPL-3.0
// License-Filename: LICENSE/GPL-3.0.txt

using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.Position as Pos;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class GSK_ViewRateOfTurn extends Ui.View {

  //
  // VARIABLES
  //

  // Display mode (internal)
  private var bShow;

  // Resources
  // ... fonts
  private var oRezFontMeter;
  private var oRezFontStatus;
  // ... strings
  private var sValueActivityStandby;
  private var sValueActivityRecording;
  private var sValueActivityPaused;

  // Layout-specific
  private var iLayoutCenter;
  private var iLayoutValueR;
  private var iLayoutCacheY;
  private var iLayoutCacheR;
  private var iLayoutBatteryY;
  private var iLayoutActivityY;
  private var iLayoutTimeY;
  private var iLayoutHeadingY;
  private var iLayoutValueY;
  private var iLayoutUnitY;


  //
  // FUNCTIONS: Layout-specific
  //

  (:layout_240x240)
  function initLayout() {
    self.iLayoutCenter = 120;
    self.iLayoutValueR = 60;
    self.iLayoutCacheY = 100;
    self.iLayoutCacheR = 90;
    self.iLayoutBatteryY = 128;
    self.iLayoutActivityY = 55;
    self.iLayoutTimeY = 142;
    self.iLayoutHeadingY = 22;
    self.iLayoutValueY = 63;
    self.iLayoutUnitY = 200;
  }

  (:layout_260x260)
  function initLayout() {
    self.iLayoutCenter = 130;
    self.iLayoutValueR = 65;
    self.iLayoutCacheY = 108;
    self.iLayoutCacheR = 98;
    self.iLayoutBatteryY = 139;
    self.iLayoutActivityY = 60;
    self.iLayoutTimeY = 154;
    self.iLayoutHeadingY = 24;
    self.iLayoutValueY = 68;
    self.iLayoutUnitY = 217;
  }

  (:layout_280x280)
  function initLayout() {
    self.iLayoutCenter = 140;
    self.iLayoutValueR = 70;
    self.iLayoutCacheY = 120;
    self.iLayoutCacheR = 105;
    self.iLayoutBatteryY = 149;
    self.iLayoutActivityY = 64;
    self.iLayoutTimeY = 166;
    self.iLayoutHeadingY = 26;
    self.iLayoutValueY = 74;
    self.iLayoutUnitY = 233;
  }

  (:layout_390x390)
  function initLayout() {
    self.iLayoutCenter = 195;
    self.iLayoutValueR = 98;
    self.iLayoutCacheY = 170;
    self.iLayoutCacheR = 155;
    self.iLayoutBatteryY = 199;
    self.iLayoutActivityY = 114;
    self.iLayoutTimeY = 226;
    self.iLayoutHeadingY = 56;
    self.iLayoutValueY = 124;
    self.iLayoutUnitY = 333;
  }


  //
  // FUNCTIONS: Ui.View (override/implement)
  //

  function initialize() {
    View.initialize();

    // Layout-specific initialization
    self.initLayout();

    // Display mode
    // ... internal
    self.bShow = false;
  }

  function onLayout(_oDC) {
    //Sys.println("DEBUG: GSK_ViewRateOfTurn.onLayout()");
    // No layout; see drawLayout() below

    // Load resources
    // ... fonts
    self.oRezFontMeter = Ui.loadResource(Rez.Fonts.fontMeter);
    self.oRezFontStatus = Ui.loadResource(Rez.Fonts.fontStatus);
    // ... strings
    self.sValueActivityStandby = Ui.loadResource(Rez.Strings.valueActivityStandby);
    self.sValueActivityRecording = Ui.loadResource(Rez.Strings.valueActivityRecording);
    self.sValueActivityPaused = Ui.loadResource(Rez.Strings.valueActivityPaused);
  }

  function onShow() {
    //Sys.println("DEBUG: GSK_ViewRateOfTurn.onShow()");

    // Reload settings (which may have been changed by user)
    App.getApp().loadSettings();

    // Unmute tones
    App.getApp().unmuteTones(GSK_App.TONES_SAFETY);

    // Done
    self.bShow = true;
    $.GSK_oCurrentView = self;
    return true;
  }

  function onUpdate(_oDC) {
    //Sys.println("DEBUG: GSK_ViewRateOfTurn.onUpdate()");

    // Update layout
    View.onUpdate(_oDC);
    self.drawLayout(_oDC);

    // Done
    return true;
  }

  function onHide() {
    //Sys.println("DEBUG: GSK_ViewRateOfTurn.onHide()");
    $.GSK_oCurrentView = null;
    self.bShow = false;

    // Mute tones
    App.getApp().muteTones();
  }


  //
  // FUNCTIONS: self (cont'd)
  //

  function updateUi() {
    //Sys.println("DEBUG: GSK_ViewRateOfTurn.updateUi()");

    // Request UI update
    if(self.bShow) {
      Ui.requestUpdate();
    }
  }

  function drawLayout(_oDC) {
    // Draw background
    _oDC.setPenWidth(self.iLayoutCenter);

    // ... background
    _oDC.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
    _oDC.clear();

    // ... rate of turn
    var fValue;
    var iColor = $.GSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE;
    _oDC.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_DK_GRAY);
    _oDC.drawArc(self.iLayoutCenter, self.iLayoutCenter, self.iLayoutValueR, Gfx.ARC_COUNTER_CLOCKWISE, 285, 255);
    _oDC.setColor($.GSK_oSettings.iGeneralBackgroundColor, $.GSK_oSettings.iGeneralBackgroundColor);
    _oDC.drawArc(self.iLayoutCenter, self.iLayoutCenter, self.iLayoutValueR, Gfx.ARC_CLOCKWISE, 285, 255);
    fValue = $.GSK_oSettings.iGeneralDisplayFilter >= 1 ? $.GSK_oProcessing.fRateOfTurn_filtered : $.GSK_oProcessing.fRateOfTurn;
    if(fValue != null and $.GSK_oProcessing.iAccuracy > Pos.QUALITY_NOT_AVAILABLE) {
      if(fValue > 0.0f) {
        iColor = Gfx.COLOR_DK_GREEN;
        //var iAngle = (fValue * 900.0f/Math.PI).toNumber();  // ... range 6 rpm <-> 36 °/s
        var iAngle = (fValue * 286.4788975654f).toNumber();
        if(iAngle != 0) {
          if(iAngle > 165) { iAngle = 165; }  // ... leave room for unit text
          _oDC.setColor(iColor, iColor);
          _oDC.drawArc(self.iLayoutCenter, self.iLayoutCenter, self.iLayoutValueR, Gfx.ARC_CLOCKWISE, 90, 90-iAngle);
        }
      }
      else if(fValue < 0.0f) {
        iColor = Gfx.COLOR_RED;
        //var iAngle = -(fValue * 900.0f/Math.PI).toNumber();  // ... range 6 rpm <-> 36 °/s
        var iAngle = -(fValue * 286.4788975654f).toNumber();
        if(iAngle != 0) {
          if(iAngle > 165) { iAngle = 165; }  // ... leave room for unit text
          _oDC.setColor(iColor, iColor);
          _oDC.drawArc(self.iLayoutCenter, self.iLayoutCenter, self.iLayoutValueR, Gfx.ARC_COUNTER_CLOCKWISE, 90, 90+iAngle);
        }
      }
    }

    // ... cache
    _oDC.setColor($.GSK_oSettings.iGeneralBackgroundColor, $.GSK_oSettings.iGeneralBackgroundColor);
    _oDC.fillCircle(self.iLayoutCenter, self.iLayoutCacheY, self.iLayoutCacheR);

    // Draw non-position values
    var sValue;

    // ... battery
    _oDC.setColor($.GSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_DK_GRAY : Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
    sValue = Lang.format("$1$%", [Sys.getSystemStats().battery.format("%.0f")]);
    _oDC.drawText(self.iLayoutCenter, self.iLayoutBatteryY, self.oRezFontStatus, sValue, Gfx.TEXT_JUSTIFY_CENTER);

    // ... activity
    if($.GSK_oActivity == null) {  // ... stand-by
      _oDC.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
      sValue = self.sValueActivityStandby;
    }
    else if($.GSK_oActivity.isRecording()) {  // ... recording
      _oDC.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
      sValue = self.sValueActivityRecording;
    }
    else {  // ... paused
      _oDC.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
      sValue = self.sValueActivityPaused;
    }
    _oDC.drawText(self.iLayoutCenter, self.iLayoutActivityY, self.oRezFontStatus, sValue, Gfx.TEXT_JUSTIFY_CENTER);

    // ... time
    var oTimeNow = Time.now();
    var oTimeInfo = $.GSK_oSettings.bUnitTimeUTC ? Gregorian.utcInfo(oTimeNow, Time.FORMAT_SHORT) : Gregorian.info(oTimeNow, Time.FORMAT_SHORT);
    sValue = Lang.format("$1$$2$$3$ $4$", [oTimeInfo.hour.format("%02d"), oTimeNow.value() % 2 ? "." : ":", oTimeInfo.min.format("%02d"), $.GSK_oSettings.sUnitTime]);
    _oDC.setColor($.GSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    _oDC.drawText(self.iLayoutCenter, self.iLayoutTimeY, Gfx.FONT_MEDIUM, sValue, Gfx.TEXT_JUSTIFY_CENTER);

    // Draw position values

    // ... heading
    fValue = $.GSK_oSettings.iGeneralDisplayFilter >= 2 ? $.GSK_oProcessing.fHeading_filtered : $.GSK_oProcessing.fHeading;
    if(fValue != null and $.GSK_oProcessing.iAccuracy > Pos.QUALITY_NOT_AVAILABLE) {
      //fValue = ((fValue * 180.0f/Math.PI).toNumber()) % 360;
      fValue = ((fValue * 57.2957795131f).toNumber()) % 360;
      sValue = fValue.format("%.0f");
    }
    else {
      sValue = $.GSK_NOVALUE_LEN3;
    }
    _oDC.drawText(self.iLayoutCenter, self.iLayoutHeadingY, Gfx.FONT_MEDIUM, Lang.format("$1$°", [sValue]), Gfx.TEXT_JUSTIFY_CENTER);

    // ... rate of turn
    fValue = $.GSK_oSettings.iGeneralDisplayFilter >= 1 ? $.GSK_oProcessing.fRateOfTurn_filtered : $.GSK_oProcessing.fRateOfTurn;
    if(fValue != null and $.GSK_oProcessing.iAccuracy > Pos.QUALITY_NOT_AVAILABLE) {
      fValue *= $.GSK_oSettings.fUnitRateOfTurnCoefficient;
      if($.GSK_oSettings.iUnitRateOfTurn == 1) {
        sValue = fValue.format("%+.1f");
        if(fValue <= -0.05f or fValue >= 0.05f) {
          _oDC.setColor(iColor, Gfx.COLOR_TRANSPARENT);
        }
      }
      else {
        sValue = fValue.format("%+.0f");
        if(fValue <= -0.05f or fValue >= 0.5f) {
          _oDC.setColor(iColor, Gfx.COLOR_TRANSPARENT);
        }
      }
    }
    else {
      sValue = $.GSK_NOVALUE_LEN3;
    }
    _oDC.drawText(self.iLayoutCenter, self.iLayoutValueY, self.oRezFontMeter, sValue, Gfx.TEXT_JUSTIFY_CENTER);
    _oDC.setColor($.GSK_oSettings.iGeneralBackgroundColor ? Gfx.COLOR_BLACK : Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
    _oDC.drawText(self.iLayoutCenter, self.iLayoutUnitY, Gfx.FONT_TINY, $.GSK_oSettings.sUnitRateOfTurn, Gfx.TEXT_JUSTIFY_CENTER);
  }
}

class GSK_ViewRateOfTurnDelegate extends GSK_ViewGlobalDelegate {

  function initialize() {
    GSK_ViewGlobalDelegate.initialize();
  }

  function onPreviousPage() {
    //Sys.println("DEBUG: GSK_ViewRateOfTurnDelegate.onPreviousPage()");
    Ui.switchToView(new GSK_ViewSafety(), new GSK_ViewSafetyDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

  function onNextPage() {
    //Sys.println("DEBUG: GSK_ViewRateOfTurnDelegate.onNextPage()");
    Ui.switchToView(new GSK_ViewVariometer(), new GSK_ViewVariometerDelegate(), Ui.SLIDE_IMMEDIATE);
    return true;
  }

}
