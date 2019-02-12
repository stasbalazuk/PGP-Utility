object DNSKeys1: TDNSKeys1
  Left = 606
  Top = 194
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generation DNS domain keys'
  ClientHeight = 470
  ClientWidth = 399
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lblGranularity: TLabel
    Left = 18
    Top = 19
    Width = 99
    Height = 13
    Caption = 'Granularity (optional):'
  end
  object lblNotes: TLabel
    Left = 18
    Top = 48
    Width = 77
    Height = 13
    Caption = 'Notes (optional):'
  end
  object lblPublicKeySize: TLabel
    Left = 18
    Top = 88
    Width = 101
    Height = 13
    Caption = 'Public Key Size (bits):'
  end
  object bvlSeparator: TBevel
    Left = 3
    Top = 235
    Width = 394
    Height = 2
  end
  object lblDNSRecord: TLabel
    Left = 18
    Top = 250
    Width = 64
    Height = 13
    Caption = 'DNS Record:'
  end
  object lblPrivateKey: TLabel
    Left = 18
    Top = 316
    Width = 203
    Height = 13
    Caption = 'Private Key to use to sign e-mail messages:'
  end
  object TLabel
    Left = 134
    Top = 115
    Width = 18
    Height = 13
    Caption = '256'
  end
  object TLabel
    Left = 175
    Top = 115
    Width = 24
    Height = 13
    Caption = '1024'
  end
  object TLabel
    Left = 234
    Top = 115
    Width = 24
    Height = 13
    Caption = '2048'
  end
  object TLabel
    Left = 352
    Top = 115
    Width = 24
    Height = 13
    Caption = '4096'
  end
  object TLabel
    Left = 294
    Top = 115
    Width = 24
    Height = 13
    Caption = '3072'
  end
  object edtGranularity: TEdit
    Left = 132
    Top = 17
    Width = 244
    Height = 21
    TabOrder = 0
  end
  object edtNotes: TEdit
    Left = 132
    Top = 46
    Width = 244
    Height = 21
    TabOrder = 1
  end
  object trkPublicKeySize: TTrackBar
    Left = 132
    Top = 76
    Width = 244
    Height = 40
    Max = 15
    PageSize = 1
    Position = 3
    TabOrder = 2
    TickMarks = tmBoth
  end
  object btnGenerate: TButton
    Left = 18
    Top = 169
    Width = 358
    Height = 23
    Caption = 'Generate Private Key and DNS Record'
    TabOrder = 4
    OnClick = btnGenerateClick
  end
  object edtDNSRecord: TEdit
    Left = 18
    Top = 265
    Width = 358
    Height = 21
    ReadOnly = True
    TabOrder = 6
  end
  object cbxTestMode: TCheckBox
    Left = 18
    Top = 142
    Width = 112
    Height = 17
    Caption = 'Use Test Mode'
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object btnRevoke: TButton
    Left = 18
    Top = 199
    Width = 358
    Height = 23
    Caption = 'Revoke Public Key and Generate DNS Record'
    TabOrder = 5
    OnClick = btnRevokeClick
  end
  object memPrivateKey: TMemo
    Left = 18
    Top = 331
    Width = 358
    Height = 90
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 8
    WordWrap = False
  end
  object btnCopyDNSRecord: TButton
    Left = 276
    Top = 292
    Width = 100
    Height = 23
    Caption = 'Copy to Clipboard'
    TabOrder = 7
    OnClick = btnCopyDNSRecordClick
  end
  object btnSavePrivateKey: TButton
    Left = 276
    Top = 430
    Width = 100
    Height = 23
    Caption = 'Save to File'
    TabOrder = 10
    OnClick = btnSavePrivateKeyClick
  end
  object btnCopyPrivateKey: TButton
    Left = 168
    Top = 430
    Width = 100
    Height = 23
    Caption = 'Copy to Clipboard'
    TabOrder = 9
    OnClick = btnCopyPrivateKeyClick
  end
  object dlgSavePrivateKey: TSaveDialog
    DefaultExt = 'pem'
    Filter = 'Private Key Files (*.pem)|*.pem|All Files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist]
    Title = 'Save Private Key'
    Left = 87
    Top = 429
  end
end
