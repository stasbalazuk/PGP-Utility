object GenSertificate1: TGenSertificate1
  Left = 632
  Top = 304
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Generation Certificate'
  ClientHeight = 378
  ClientWidth = 495
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
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 106
    Height = 13
    Caption = 'System Store Location'
  end
  object Label2: TLabel
    Left = 16
    Top = 40
    Width = 93
    Height = 13
    Caption = 'System Store Name'
  end
  object Label3: TLabel
    Left = 16
    Top = 64
    Width = 52
    Height = 13
    Caption = 'Certificates'
  end
  object cbLocation: TComboBox
    Left = 136
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'Current User'
    Items.Strings = (
      'Current User'
      'Local Machine')
  end
  object cbName: TComboBox
    Left = 136
    Top = 40
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 1
    Text = 'MY'
    Items.Strings = (
      'MY'
      'CA'
      'ROOT'
      'ADDRESSBOOK')
  end
  object btnLoad: TButton
    Left = 285
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Load Store'
    TabOrder = 2
    OnClick = btnLoadClick
  end
  object btnExport: TButton
    Left = 285
    Top = 40
    Width = 97
    Height = 25
    Caption = 'Export to PFX...'
    TabOrder = 3
    OnClick = btnExportClick
  end
  object btnImport: TButton
    Left = 389
    Top = 40
    Width = 97
    Height = 25
    Caption = 'Import from PFX...'
    TabOrder = 4
    OnClick = btnImportClick
  end
  object btnDelete: TButton
    Left = 285
    Top = 105
    Width = 204
    Height = 25
    Caption = 'Delete'
    TabOrder = 5
    OnClick = btnDeleteClick
  end
  object btnCreateSelfSigned: TButton
    Left = 285
    Top = 73
    Width = 97
    Height = 25
    Caption = 'Create Self-Signed'
    TabOrder = 6
    OnClick = btnCreateSelfSignedClick
  end
  object btnClose: TButton
    Left = 389
    Top = 8
    Width = 97
    Height = 25
    Caption = 'Close Store'
    TabOrder = 7
    OnClick = btnCloseClick
  end
  object lvCertificates: TListView
    Left = 0
    Top = 137
    Width = 495
    Height = 241
    Align = alBottom
    Columns = <
      item
        Caption = 'Issued To'
        Width = 90
      end
      item
        Caption = 'Issued By'
        Width = 100
      end
      item
        Caption = 'Expiration Date'
        Width = 100
      end
      item
        Caption = 'Friendly Name'
        Width = 100
      end
      item
        Caption = 'Email'
        Width = 100
      end>
    ReadOnly = True
    RowSelect = True
    TabOrder = 8
    ViewStyle = vsReport
  end
  object btnCreateSigned: TButton
    Left = 389
    Top = 72
    Width = 97
    Height = 25
    Caption = 'Create Signed'
    TabOrder = 9
    OnClick = btnCreateSignedClick
  end
  object clCertificateStore1: TclCertificateStore
    StoreName = 'MY'
    CSP = 'Microsoft Base Cryptographic Provider v1.0'
    KeyLength = 2048
    ValidFrom = 40002.000000000000000000
    ValidTo = 72874.000000000000000000
    Left = 312
    Top = 184
  end
end
