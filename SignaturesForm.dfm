object frmSignatures: TfrmSignatures
  Left = 587
  Top = 298
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Signatures'
  ClientHeight = 184
  ClientWidth = 405
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lvSignatures: TListView
    Left = 0
    Top = 0
    Width = 405
    Height = 184
    Align = alClient
    Columns = <
      item
        Caption = 'Signer'
        Width = 200
      end
      item
        Caption = 'Validity'
        Width = 200
      end>
    TabOrder = 0
    ViewStyle = vsReport
  end
end
