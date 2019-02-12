object EncF: TEncF
  Left = 535
  Top = 314
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Encryption file - key-based'
  ClientHeight = 193
  ClientWidth = 441
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbInputFileName: TLabel
    Left = 8
    Top = 8
    Width = 73
    Height = 13
    Caption = 'File to encrypt:'
  end
  object lbOutputFileName: TLabel
    Left = 8
    Top = 56
    Width = 55
    Height = 13
    Caption = 'Output file:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 144
    Width = 425
    Height = 10
    Shape = bsBottomLine
  end
  object lbSelectKey: TLabel
    Left = 8
    Top = 104
    Width = 95
    Height = 13
    Caption = 'Please select a key:'
  end
  object editInputFile: TEdit
    Left = 8
    Top = 24
    Width = 345
    Height = 21
    TabOrder = 0
  end
  object editOutputFile: TEdit
    Left = 8
    Top = 72
    Width = 345
    Height = 21
    TabOrder = 2
  end
  object btnBrowseInputFile: TButton
    Left = 359
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 1
    OnClick = btnBrowseInputFileClick
  end
  object btnBrowseOutputFile: TButton
    Left = 360
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 3
    OnClick = btnBrowseOutputFileClick
  end
  object btnBrowseKeyringFile: TButton
    Left = 359
    Top = 117
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 5
    OnClick = btnBrowseKeyringFileClick
  end
  object btnEncrypt: TButton
    Left = 256
    Top = 160
    Width = 99
    Height = 25
    Caption = 'Encrypt'
    TabOrder = 6
    OnClick = btnEncryptClick
  end
  object btnClose: TButton
    Left = 360
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 7
    OnClick = btnCloseClick
  end
  object cbKeySelect: TComboBox
    Left = 8
    Top = 120
    Width = 345
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object cbAutoKeySelect: TCheckBox
    Left = 8
    Top = 168
    Width = 225
    Height = 17
    Caption = 'Automatically select appropriate keys'
    Checked = True
    State = cbChecked
    TabOrder = 8
  end
  object dlgOpenDialog: TOpenDialog
    Left = 104
    Top = 48
  end
  object pgpPubKeyring: TElPGPKeyring
    Left = 200
    Top = 48
  end
  object pgpWriter: TElPGPWriter
    Armor = False
    EncryptionType = etPublicKey
    Compress = False
    CompressionAlgorithm = 1
    CompressionLevel = 9
    Left = 168
    Top = 48
  end
  object dlgSaveDialog: TSaveDialog
    Left = 136
    Top = 48
  end
end
