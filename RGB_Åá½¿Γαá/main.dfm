object Form1: TForm1
  Left = 252
  Top = 116
  Width = 308
  Height = 327
  Caption = 'RGB '#1055#1072#1083#1080#1090#1088#1072
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object bvlPalitraRight: TBevel
    Left = 242
    Top = 50
    Width = 50
    Height = 189
    Cursor = crCross
    Align = alRight
    Shape = bsSpacer
  end
  object bvlPalitraTop: TBevel
    Left = 0
    Top = 0
    Width = 292
    Height = 50
    Cursor = crCross
    Align = alTop
    Shape = bsSpacer
  end
  object bvlPalitraBottom: TBevel
    Left = 0
    Top = 239
    Width = 292
    Height = 50
    Cursor = crCross
    Align = alBottom
    Shape = bsSpacer
  end
  object bvlPalitraLeft: TBevel
    Left = 0
    Top = 50
    Width = 50
    Height = 189
    Cursor = crCross
    Align = alLeft
    Shape = bsSpacer
  end
  object bvl: TBevel
    Left = 50
    Top = 50
    Width = 192
    Height = 189
    Cursor = crCross
    Align = alClient
    Shape = bsSpacer
  end
  object Timer: TTimer
    Interval = 1
    OnTimer = TimerTimer
    Top = 8
  end
end
