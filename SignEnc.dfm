object SignEnc1: TSignEnc1
  Left = 709
  Top = 328
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Encrypt and sign file - Key-based'
  ClientHeight = 274
  ClientWidth = 435
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
    Width = 71
    Height = 13
    Caption = 'File to protect:'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 224
    Width = 425
    Height = 10
    Shape = bsBottomLine
  end
  object Label1: TLabel
    Left = 8
    Top = 56
    Width = 55
    Height = 13
    Caption = 'Output file:'
  end
  object lbSecretKeyList: TLabel
    Left = 8
    Top = 104
    Width = 68
    Height = 13
    Caption = 'Recipient key:'
  end
  object lbPublicKeyList: TLabel
    Left = 8
    Top = 144
    Width = 58
    Height = 13
    Caption = 'Signing key:'
  end
  object editInputFile: TEdit
    Left = 8
    Top = 24
    Width = 337
    Height = 21
    TabOrder = 0
  end
  object btnBrowseInputFile: TButton
    Left = 351
    Top = 22
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 1
    OnClick = btnBrowseInputFileClick
  end
  object btnBrowseKeyringFile: TButton
    Left = 288
    Top = 197
    Width = 138
    Height = 25
    Caption = 'Browse for keyring files ...'
    TabOrder = 4
    OnClick = btnBrowseKeyringFileClick
  end
  object btnEncrypt: TButton
    Left = 240
    Top = 240
    Width = 107
    Height = 25
    Caption = 'Encrypt and sign'
    TabOrder = 7
    OnClick = btnEncryptClick
  end
  object btnClose: TButton
    Left = 352
    Top = 240
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 8
    OnClick = btnCloseClick
  end
  object editOutputFile: TEdit
    Left = 8
    Top = 72
    Width = 337
    Height = 21
    TabOrder = 2
  end
  object btnBrowseOutFile: TButton
    Left = 351
    Top = 70
    Width = 75
    Height = 25
    Caption = 'Browse ...'
    TabOrder = 3
    OnClick = btnBrowseOutputFileClick
  end
  object cbSecretKeySelect: TComboBox
    Left = 8
    Top = 168
    Width = 417
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 5
  end
  object cbPublicKeySelect: TComboBox
    Left = 8
    Top = 120
    Width = 417
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
  end
  object dlgOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 40
    Top = 240
  end
  object pgpKeyring: TElPGPKeyring
    Left = 136
    Top = 240
  end
  object dlgSaveDialog: TSaveDialog
    Left = 72
    Top = 240
  end
  object pgpTempKeyring: TElPGPKeyring
    Left = 168
    Top = 240
  end
  object pgpWriter: TElPGPWriter
    Armor = False
    EncryptionType = etPublicKey
    Compress = False
    CompressionAlgorithm = 1
    CompressionLevel = 9
    OnKeyPassphrase = pgpWriterKeyPassphrase
    Left = 104
    Top = 240
  end
end
