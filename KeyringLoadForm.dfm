object frmKeyringLoad: TfrmKeyringLoad
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Load keyring'
  ClientHeight = 146
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblPublicKeyring: TLabel
    Left = 8
    Top = 8
    Width = 69
    Height = 13
    Caption = 'Public keyring:'
  end
  object lblSecretKeyring: TLabel
    Left = 8
    Top = 56
    Width = 73
    Height = 13
    Caption = 'Secret keyring:'
  end
  object editPubKeyring: TEdit
    Left = 8
    Top = 24
    Width = 273
    Height = 21
    TabOrder = 0
  end
  object editSecKeyring: TEdit
    Left = 8
    Top = 72
    Width = 273
    Height = 21
    TabOrder = 1
  end
  object btnBrowsePub: TButton
    Left = 288
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 2
    OnClick = btnBrowsePubClick
  end
  object btnBrowseSec: TButton
    Left = 288
    Top = 72
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 3
    OnClick = btnBrowseSecClick
  end
  object btnOK: TButton
    Left = 104
    Top = 112
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 184
    Top = 112
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object OpenDialog: TOpenDialog
    Left = 304
    Top = 24
  end
end
