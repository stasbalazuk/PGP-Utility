object Form1: TForm1
  Left = 825
  Top = 263
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'PGP'
  ClientHeight = 327
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btn1: TButton
    Left = 8
    Top = 8
    Width = 169
    Height = 25
    Hint = 'X.509 Certificate'
    Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' X.509 '#1057#1077#1088#1090#1080#1092#1080#1082#1072#1090#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 8
    Top = 104
    Width = 313
    Height = 25
    Hint = 'Encrypt - Decrypt - Verifi Signature File X.509 Sertificate'
    Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072' '#1087#1088#1080' '#1087#1086#1084#1086#1097#1080' X.509 '#1057#1077#1088#1090#1080#1092#1080#1082#1072#1090#1072
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 8
    Top = 136
    Width = 313
    Height = 25
    Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' PGP '#1082#1083#1102#1095#1077#1081
    TabOrder = 2
    OnClick = btn3Click
  end
  object btn4: TButton
    Left = 8
    Top = 168
    Width = 313
    Height = 25
    Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072' '#1087#1088#1080' '#1087#1086#1084#1086#1097#1080' '#1087#1091#1073#1083#1080#1095#1085#1086#1075#1086' '#1082#1083#1102#1095#1072
    TabOrder = 3
    OnClick = btn4Click
  end
  object btn5: TButton
    Left = 8
    Top = 200
    Width = 313
    Height = 25
    Caption = #1056#1072#1089#1096#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1092#1072#1081#1083#1072' '#1087#1088#1080' '#1087#1086#1084#1086#1097#1080' '#1089#1077#1082#1088#1077#1090#1085#1086#1075#1086' '#1082#1083#1102#1095#1072
    TabOrder = 4
    OnClick = btn5Click
  end
  object btn6: TButton
    Left = 8
    Top = 264
    Width = 313
    Height = 25
    Caption = 'PGP '#1096#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1080' '#1088#1072#1089#1096#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1089' '#1089#1078#1072#1090#1080#1077#1084' '#1092#1072#1081#1083#1072
    TabOrder = 5
    OnClick = btn6Click
  end
  object btn7: TButton
    Left = 8
    Top = 232
    Width = 313
    Height = 25
    Hint = 'Encrypt and sign file - Key-based'
    Caption = #1064#1080#1092#1088#1086#1074#1072#1085#1080#1077' '#1080' '#1074#1077#1088#1080#1092#1080#1082#1072#1094#1080#1103' '#1092#1072#1081#1083#1072' '#1087#1091#1073#1083#1080#1095#1085#1099#1084' '#1082#1083#1102#1095#1086#1084
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = btn7Click
  end
  object btn8: TButton
    Left = 184
    Top = 8
    Width = 137
    Height = 25
    Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' '#1057#1077#1088#1090#1080#1092#1080#1082#1072#1090#1072
    TabOrder = 7
    OnClick = btn8Click
  end
  object btn9: TButton
    Left = 8
    Top = 296
    Width = 313
    Height = 25
    Caption = #1047#1072#1097#1080#1090#1072' PGP E-mail '#1089#1086#1086#1073#1097#1077#1085#1080#1081' (S/MIME/PGP)'
    TabOrder = 8
    OnClick = btn9Click
  end
  object btn10: TButton
    Left = 8
    Top = 40
    Width = 313
    Height = 25
    Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' SSH '#1082#1083#1102#1095#1077#1081
    TabOrder = 9
    OnClick = btn10Click
  end
  object btn11: TButton
    Left = 8
    Top = 72
    Width = 313
    Height = 25
    Caption = #1043#1077#1085#1077#1088#1072#1090#1086#1088' DNS '#1082#1083#1102#1095#1077#1081' '#1044#1086#1084#1077#1085#1072
    TabOrder = 10
    OnClick = btn11Click
  end
end
