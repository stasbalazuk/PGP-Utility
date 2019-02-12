object frmImportKey: TfrmImportKey
  Left = 402
  Top = 257
  BorderStyle = bsDialog
  Caption = 'Import Key'
  ClientHeight = 283
  ClientWidth = 327
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbHint: TLabel
    Left = 8
    Top = 8
    Width = 166
    Height = 13
    Caption = 'The following keys will be imported:'
  end
  object tvKeys: TTreeView
    Left = 8
    Top = 24
    Width = 313
    Height = 209
    Indent = 19
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 152
    Top = 248
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 240
    Top = 248
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
end
