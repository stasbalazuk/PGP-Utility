object frmMainForm: TfrmMainForm
  Left = 686
  Top = 361
  BorderStyle = bsDialog
  Caption = 'Decrypt and verify file - key-based'
  ClientHeight = 179
  ClientWidth = 433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbInputFileName: TLabel
    Left = 8
    Top = 8
    Width = 125
    Height = 13
    Caption = 'File to decrypt and verify:'
  end
  object Bevel1: TBevel
    Left = 0
    Top = 128
    Width = 433
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
    Top = 448
    Width = 109
    Height = 13
    Caption = 'Key list for decryption:'
    Enabled = False
  end
  object lbPublicKeyList: TLabel
    Left = 8
    Top = 496
    Width = 84
    Height = 13
    Caption = 'Key for verifying:'
    Enabled = False
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
    Top = 101
    Width = 138
    Height = 25
    Caption = 'Browse for keyring files ...'
    TabOrder = 5
    OnClick = btnBrowseKeyringFileClick
  end
  object btnDecrypt: TButton
    Left = 168
    Top = 144
    Width = 153
    Height = 25
    Caption = 'Decrypt and verify'
    TabOrder = 8
    OnClick = btnDecryptClick
  end
  object btnClose: TButton
    Left = 328
    Top = 144
    Width = 99
    Height = 25
    Caption = 'Close'
    TabOrder = 9
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
    Top = 464
    Width = 417
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 6
  end
  object cbPublicKeySelect: TComboBox
    Left = 8
    Top = 512
    Width = 417
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    TabOrder = 7
  end
  object cbAutoKeySelect: TCheckBox
    Left = 8
    Top = 104
    Width = 273
    Height = 17
    Caption = 'Automatically select appropriate keys'
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = cbAutoKeySelectClick
  end
  object dlgOpenDialog: TOpenDialog
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 8
    Top = 144
  end
  object pgpKeyring: TElPGPKeyring
    Left = 104
    Top = 144
  end
  object dlgSaveDialog: TSaveDialog
    Left = 40
    Top = 144
  end
  object pgpReader: TElPGPReader
    OnKeyPassphrase = pgpReaderKeyPassphrase
    OnSignatures = pgpReaderSignatures
    Left = 72
    Top = 144
  end
  object pgpTempKeyring: TElPGPKeyring
    Left = 136
    Top = 144
  end
end
