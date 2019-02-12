object frmGenerateCert: TfrmGenerateCert
  Left = 482
  Top = 239
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Certificate generation'
  ClientHeight = 383
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    477
    383)
  PixelsPerInch = 96
  TextHeight = 13
  object bvlTop: TBevel
    Left = 0
    Top = 57
    Width = 477
    Height = 2
    Align = alTop
  end
  object btnBack: TButton
    Left = 226
    Top = 349
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '< &Back'
    Enabled = False
    TabOrder = 0
    OnClick = btnBackClick
  end
  object btnNext: TButton
    Left = 309
    Top = 349
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Next >'
    Default = True
    TabOrder = 1
    OnClick = btnNextClick
  end
  object btnCancel: TButton
    Left = 391
    Top = 349
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object pcMain: TPageControl
    Left = 0
    Top = 59
    Width = 477
    Height = 289
    ActivePage = tsSelectAction
    Align = alTop
    Style = tsButtons
    TabOrder = 3
    OnChange = pcMainChange
    object tsSelectAction: TTabSheet
      Hint = 'Please select certificate type'#13#10'you want to create'
      Caption = 'Action'
      object lblCertTypeSelect: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'I want to create...'
        Layout = tlCenter
      end
      object gbCertType: TGroupBox
        Left = 8
        Top = 40
        Width = 457
        Height = 217
        Caption = 'Certificate type'
        TabOrder = 0
        object rbSelfSigned: TRadioButton
          Left = 120
          Top = 80
          Width = 225
          Height = 17
          Caption = 'Self-signed certificate'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbChild: TRadioButton
          Left = 120
          Top = 112
          Width = 297
          Height = 17
          Caption = 'Certificate signed by Certificate Authority (CA)'
          TabOrder = 1
        end
      end
    end
    object tsSelectKeyAndHashAlgorithm: TTabSheet
      Hint = 
        'Select public key and hash algorithms'#13#10'For given combination sel' +
        'ect public key length'
      Caption = 'KeyAndHashAlg'
      ImageIndex = 1
      object lblPublicKeyAndHash: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Select public key and hash algorithms: '
        Layout = tlCenter
      end
      object lblSelectPublicKeyLen: TLabel
        Left = 8
        Top = 207
        Width = 115
        Height = 13
        BiDiMode = bdLeftToRight
        Caption = 'Public key length (bits): '
        ParentBiDiMode = False
      end
      object rgPublicKeyAndHash: TRadioGroup
        Left = 8
        Top = 40
        Width = 457
        Height = 153
        Caption = 'Public key and hash type'
        Columns = 2
        TabOrder = 0
      end
      object cbPublicKeyLen: TComboBox
        Left = 8
        Top = 224
        Width = 97
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = '1024'
        Items.Strings = (
          '512'
          '1024'
          '2048')
      end
    end
    object tsSelectParentCertificate: TTabSheet
      Hint = 
        'Select parent certificate and private key'#13#10'You can use storage o' +
        'r load certificate/key from file'
      Caption = 'ParentCert'
      ImageIndex = 2
      object lblParentCertificate: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Select parent certificate and private key:'
        Layout = tlCenter
      end
      object gbCertificate: TGroupBox
        Left = 8
        Top = 40
        Width = 457
        Height = 217
        TabOrder = 0
        object lblCertificateFile: TLabel
          Left = 24
          Top = 155
          Width = 57
          Height = 13
          Caption = 'Certificate: '
        end
        object lblPrivateKeyFile: TLabel
          Left = 24
          Top = 184
          Width = 62
          Height = 13
          Caption = 'Private Key: '
        end
        object edtCertificateFile: TEdit
          Left = 88
          Top = 151
          Width = 270
          Height = 21
          Enabled = False
          TabOrder = 0
        end
        object edtPrivateKeyFile: TEdit
          Left = 88
          Top = 180
          Width = 270
          Height = 21
          Enabled = False
          TabOrder = 1
        end
        object btnLoadCertificate: TButton
          Left = 362
          Top = 150
          Width = 70
          Height = 22
          Caption = 'Browse'
          Enabled = False
          TabOrder = 2
          OnClick = btnLoadCertificateClick
        end
        object btnLoadPrivateKey: TButton
          Left = 362
          Top = 178
          Width = 70
          Height = 22
          Caption = 'Browse'
          Enabled = False
          TabOrder = 3
          OnClick = btnLoadPrivateKeyClick
        end
        object rbFromFile: TRadioButton
          Left = 8
          Top = 132
          Width = 113
          Height = 17
          Caption = 'From file'
          TabOrder = 4
          OnClick = rbFromFileClick
        end
        object rbFromStorage: TRadioButton
          Left = 8
          Top = 10
          Width = 113
          Height = 17
          Caption = 'From storage'
          Checked = True
          TabOrder = 5
          TabStop = True
          OnClick = rbFromStorageClick
        end
        object tvCertificates: TTreeView
          Left = 24
          Top = 27
          Width = 417
          Height = 94
          Indent = 19
          TabOrder = 6
        end
      end
    end
    object tsEnterFields: TTabSheet
      Hint = 
        'Specify contents of Subject fields for new certificate'#13#10'You need' +
        ' to fill all fields'
      Caption = 'EnterFields'
      ImageIndex = 4
      object lblContents: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Specify contents of Subject fields for new certificate :'
        Layout = tlCenter
      end
      object gbSubject: TGroupBox
        Left = 8
        Top = 41
        Width = 457
        Height = 216
        Caption = 'Subject parameters '
        TabOrder = 0
        object lblCountry: TLabel
          Left = 24
          Top = 28
          Width = 43
          Height = 13
          Caption = 'Country:'
        end
        object lblState: TLabel
          Left = 24
          Top = 60
          Width = 87
          Height = 13
          Caption = 'State or Province:'
        end
        object lblLocality: TLabel
          Left = 24
          Top = 92
          Width = 43
          Height = 13
          Caption = 'Locality: '
        end
        object lblOrganization: TLabel
          Left = 24
          Top = 124
          Width = 65
          Height = 13
          Caption = 'Organization:'
        end
        object lblOrganizationUnit: TLabel
          Left = 24
          Top = 156
          Width = 87
          Height = 13
          Caption = 'Organization Unit:'
        end
        object lblCommonName: TLabel
          Left = 24
          Top = 188
          Width = 75
          Height = 13
          Caption = 'Common Name:'
        end
        object edtState: TEdit
          Left = 136
          Top = 56
          Width = 153
          Height = 21
          TabOrder = 0
        end
        object edtLocality: TEdit
          Left = 136
          Top = 88
          Width = 153
          Height = 21
          TabOrder = 1
        end
        object edtOrganization: TEdit
          Left = 136
          Top = 120
          Width = 153
          Height = 21
          TabOrder = 2
        end
        object edtOrganizationUnit: TEdit
          Left = 136
          Top = 152
          Width = 153
          Height = 21
          TabOrder = 3
        end
        object edtCommonName: TEdit
          Left = 136
          Top = 184
          Width = 153
          Height = 21
          TabOrder = 4
        end
        object cbCountry: TComboBox
          Left = 136
          Top = 24
          Width = 297
          Height = 21
          Style = csDropDownList
          DropDownCount = 20
          ItemHeight = 0
          TabOrder = 5
        end
      end
    end
    object tsSpecifyPeriod: TTabSheet
      Hint = 'Specify certificate validity period'
      Caption = 'Period'
      ImageIndex = 5
      object lblCertificateDate: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Specify certificate validity period: '
        FocusControl = gbCertificateDate
        Layout = tlCenter
      end
      object gbCertificateDate: TGroupBox
        Left = 8
        Top = 40
        Width = 457
        Height = 217
        Caption = 'Validity period:'
        TabOrder = 0
        object lblValidFrom: TLabel
          Left = 104
          Top = 67
          Width = 28
          Height = 13
          Caption = 'From:'
          FocusControl = dtpFrom
        end
        object lblValidTo: TLabel
          Left = 104
          Top = 116
          Width = 16
          Height = 13
          Caption = 'To:'
          FocusControl = dtpTo
        end
        object dtpFrom: TDateTimePicker
          Left = 160
          Top = 64
          Width = 186
          Height = 21
          Date = 37733.000000000000000000
          Time = 37733.000000000000000000
          Checked = False
          MaxDate = 73415.000000000000000000
          MinDate = 36525.000000000000000000
          TabOrder = 0
        end
        object dtpTo: TDateTimePicker
          Left = 160
          Top = 112
          Width = 186
          Height = 21
          Date = 37733.000000000000000000
          Time = 37733.000000000000000000
          Checked = False
          MaxDate = 73415.000000000000000000
          MinDate = 36525.000000000000000000
          TabOrder = 1
        end
      end
    end
    object tsGenerate: TTabSheet
      Hint = 
        'Certificate generation'#13#10'Please be patient while certifcate are g' +
        'enerating'
      Caption = 'Generate'
      ImageIndex = 6
      object lbGenerate: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 73
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 
          'The certificate will be generated now. '#13#10'This process can take l' +
          'ong time, depending on the key length.'
        Transparent = True
        Layout = tlCenter
        WordWrap = True
      end
      object btnGenerate: TButton
        Left = 184
        Top = 120
        Width = 121
        Height = 25
        Caption = 'Generate'
        TabOrder = 0
        OnClick = btnGenerateClick
      end
      object pbGenerate: TProgressBar
        Left = 0
        Top = 73
        Width = 469
        Height = 17
        Align = alTop
        TabOrder = 1
        Visible = False
      end
    end
    object tsSelectKeyAlgorithm: TTabSheet
      Hint = 'Select algorithm for public key'
      Caption = 'KeyAlg'
      ImageIndex = 7
      object lblSelectPublicKeyAlg: TLabel
        Left = 0
        Top = 0
        Width = 469
        Height = 49
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Select public key algorithm: '
        Layout = tlCenter
      end
      object lblKeyLen: TLabel
        Left = 8
        Top = 206
        Width = 115
        Height = 13
        Caption = 'Public key length (bits): '
      end
      object gbSelectPublicKeyAlgorithm: TGroupBox
        Left = 8
        Top = 42
        Width = 457
        Height = 151
        Caption = 'Select public key algorithm: '
        TabOrder = 0
        object rbRSA: TRadioButton
          Left = 180
          Top = 40
          Width = 113
          Height = 17
          Caption = 'RSA'
          Checked = True
          TabOrder = 0
          TabStop = True
        end
        object rbDSA: TRadioButton
          Left = 180
          Top = 72
          Width = 113
          Height = 17
          Caption = 'DSA'
          TabOrder = 1
        end
        object rbDH: TRadioButton
          Left = 180
          Top = 104
          Width = 113
          Height = 17
          Caption = 'DH'
          TabOrder = 2
        end
      end
      object cbKeyLen: TComboBox
        Left = 8
        Top = 224
        Width = 105
        Height = 21
        ItemHeight = 13
        TabOrder = 1
        Text = '1024'
        Items.Strings = (
          '512'
          '768'
          '1024'
          '2048'
          '4096')
      end
    end
    object tsSaveCertificateRequest: TTabSheet
      Hint = 'Save generated request'
      Caption = 'Save'
      ImageIndex = 8
      object lblSelectTargetFiles: TLabel
        Left = 8
        Top = 8
        Width = 281
        Height = 13
        Caption = 'Select the file you want to save the generated request to:'
      end
      object lblRequest: TLabel
        Left = 16
        Top = 40
        Width = 44
        Height = 13
        Caption = 'Request:'
        FocusControl = edRequest
      end
      object lblPrivateKey: TLabel
        Left = 16
        Top = 88
        Width = 59
        Height = 13
        Caption = 'Private Key:'
        FocusControl = edPrivateKey
      end
      object edRequest: TEdit
        Left = 16
        Top = 56
        Width = 401
        Height = 21
        TabOrder = 0
      end
      object edPrivateKey: TEdit
        Left = 16
        Top = 104
        Width = 401
        Height = 21
        TabOrder = 1
      end
      object btnRequest: TButton
        Left = 426
        Top = 54
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 2
        OnClick = btnRequestClick
      end
      object btnPrivateKey: TButton
        Left = 426
        Top = 102
        Width = 25
        Height = 25
        Caption = '...'
        TabOrder = 3
        OnClick = btnPrivateKeyClick
      end
      object btnSave: TButton
        Left = 200
        Top = 152
        Width = 75
        Height = 25
        Caption = 'Save'
        TabOrder = 4
        OnClick = btnSaveClick
      end
    end
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 477
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    FullRepaint = False
    TabOrder = 4
    object imgKeys: TImage
      Left = 12
      Top = 3
      Width = 48
      Height = 48
      AutoSize = True
      Center = True
      Picture.Data = {
        07544269746D6170361B0000424D361B00000000000036000000280000003000
        0000300000000100180000000000001B0000120B0000120B0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBECECECD4D4D4C5C5
        C5D1D1D1E5E5E5F6F6F6FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD
        FDFDF1F1F1D6D6D6A7A7A77E7E7E696969737373999999D1D1D1F6F6F6FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1F1BEBEBE848484868686B5B5B59999
        996666665F5F5F999999E5E5E5FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFECE
        CECE919191BCBCBCE3E3E3F1F1F1FAFAFACCCCCC636363717171CCCCCCF9F9F9
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9A9A9ACCCCCCFFFFFFECECECE3E3E3E5E5
        E5FFFFFF8282825D5D5DAEAEAEEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFEFBFBFBF4F4F4F0F0F0F6F6F6
        FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD2
        D2D29F9F9FFAFAFAF6F6F6D6D6D6999999E6E6E6C1C1C1616161A2A2A2EBEBEB
        FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8E4E4
        E4D6D6D6CBCBCBBABABAB1B1B1C7C7C7E9E9E9FBFBFBFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF1F1F1909090CACACAFBFBFBC3C3C39696
        96F3F3F3B8B8B8636363A9A9A9EEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFEFEFEE6E6E6A0A0A06B71744C65733561784B5E67747474
        ADADADE6E6E6FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8CF
        CFCF858585989898EDEDEDBEBEBE949494F6F6F6B7B7B7646464B6B6B6F2F2F2
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE3B88B21278
        AD2086B741A7CE4DB3D42786AD2D53666F6F6FC0C0C0F4F4F4FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFDDDDDD959595C0C0C0D6D6D6D7D7D7B3B3B39191
        91F3F3F3AAAAAA646464BDBDBDF5F5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFEFEFE3D89B399CDE8FEFFFF80E6FF88EEFF92F8FF3096B9
        415A67A5A5A5ECECECFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEF8B
        8B8BE6E6E6EFEFEFD5D5D5A0A0A0A5A5A5EFEFEF8E8E8E666666C8C8C8F9F9F9
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAEAEAEA458BB382BF
        DDF9FFFF80E6FF6DD3FF92F8FF4DB3CD2A5C769F9F9FEAEAEAFEFEFEFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEACACACACACACF2F2F2E0E0E09E9E9EA3A3
        A3ECECEC8E8E8E686868D2D2D2FDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFEFEFEEBEBEBB0B0B04478955CACD3F2FFFF93E3FE3298FE69CFFF73D9E6
        2B5E79A4A4A4ECECECFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8F8F8CD
        CDCD818181E1E1E1EDEDED929292AAAAAAEAEAEA8181816E6E6ED7D7D7FEFEFE
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE67A0C32875A2176FA3449F
        CFDFFBFF61B7F93096FA86ECFF6AD0E1326580B8B8B8F3F3F3FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFEFEFEE8E8E89A9A9A828282B7B7B7D0D0D0868686B4B4
        B4E6E6E66868687B7B7BDCDCDCFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFEFEFE3486B8AADBEBC2F2FF6BD1FF70D6FE2D93F24CB2F892F8FF3399BE
        577788D7D7D7FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB6B6B69C
        9C9CE5E5E5CACACACBCBCB848484B1B1B1E1E1E1616161838383DFDFDFFEFEFE
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF4F4F43E8BBB78BDDDD4FCFF6BD1
        FF4DB3F52A90EE71D7FC7FE5F410699AABABABEDEDEDFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFEDEDED868686E3E3E3DFDFDFB9B9B9818181BCBC
        BCD0D0D05E5E5E8B8B8BE2E2E2FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3
        F3F3CCCCCC5386A670B9D9D6FFFF66CCFD2B91E83FA5F088EEFF3AA0C850768B
        D4D4D4FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF1F1F1A1
        A1A1ADADADE8E8E8B9B9B97F7F7FC0C0C0BDBDBD606060999999E8E8E8FEFEFE
        FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEB3CCDD588BAD1871AA429BCBD1FFFF60B8
        EF258BE36BD1F977DDF4116B9EA9A9A9EDEDEDFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFF2F2F2C2C2C27F7F7F787878D0D0D0B9B9B97C7C7CC1C1
        C1BABABA5C5C5CA1A1A1EBEBEBFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE62
        A2CC53AAD390D7ED58BEFA66CCFF258BDD399FE780E6FF3FA5D04B7188CECECE
        FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFECCCCCC878787A8
        A8A8999999ABABAB9A9A9A7A7A7ACCCCCCA4A4A45C5C5CA9A9A9EEEEEEFFFFFF
        FFFFFFFFFFFFFEFEFEF9F9F9EEEEEE76A9CC67BBDDBFFFFF5CC2FF4BB1EF1F85
        D75CC2F378DEFA1575AC959C9FE9E9E9FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFEFEFE
        FFFFFFFFFFFFFEFEFE9E9E9EC8C8C8D8D8D8999999A6A6A6949494787878CCCC
        CC9898985E5E5EB4B4B4F2F2F2FFFFFFFFFFFFFFFFFFF9F9F9DADADAAEAEAE74
        8E9F3C9ACEBAFFFF75D2FF258BD5288ED875DBFF44AAD83F7292CBCBCBF8F8F8
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFDFDFDF4F4F4E7E7E7E7E7E7F2F2F2FBFBFBFEFEFE969696C6C6C6D0
        D0D0999999A1A1A18E8E8E7E7E7ECACACA969696595959A3A3A3E5E5E5FCFCFC
        FFFFFFFEFEFEDCE2E75C90B43C6F941F73AB3092CBB4FFFF5DBBEB197FCB4FB5
        ED6ED4FA1777B1939A9EE8E8E8FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFAE5E5E5BFBFBF999999989898
        B4B4B4D3D3D3E4E4E48F8F8FD7D7D7D1D1D19D9D9D9B9B9B7F7F7F868686C4C4
        C47B7B7B46525D6E6E6EADADADE1E1E1F9F9F9FBFBFB75A8CD54B5DF82DEF041
        A5F03DA3FF59BCFF2288CF2187CF6BD1FF46ACDF3C6F90C5C5C5F7F7F7FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9
        F9DBDBDB9F9F9F8686867878786464645F5F5F7474749292927D7D7DCCCCCCC7
        C7C7A4A4A4999999727F895683A74895D33096E02484CE395A736565659B9B9B
        D6D6D6E5E5E52282C895F7FC95F5FF3399FF3DA3FF3EA4EF1379C048AEE96BD1
        FF1C82C1828F98E3E3E3FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFEFEFEE9E9E99C9C9CA3A3A3C2C2C2AFAFAFA4A4A4
        8787876B6B6B5E5E5E7B7B7BBCBCBCBCBCBCACACAC9999992E8EDB55BBF465CB
        FD64CAFF4EB4FC2B91DD2D67945A5A5A8989897297B449AFDF99FFFF71D6FF33
        99FF3DA3FF1F85CA1C82C566CCFF48AEE632729DC2C2C2F5F5F5FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEB2B2
        B2B8B8B8D0D0D0C0C0C0B7B7B7CECECEE5E5E5D5D5D5AEAEAE808080ACACACB8
        B8B8B1B1B1749ABA4AB0F06ED4FF6CD2FF54BAFF53B9FF6DD2FF4AB0E72673AF
        4C5257227BBF7FE5F993F9FF4CB2FF3399FF3096EC0D73B4379DDB66CCFF1D83
        C7828E97E2E2E2FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFEFEFEA4A4A4D4D4D4D3D3D3B7B7B7B0B0B0C9C9C9
        DDDDDDF4F4F4FFFFFFE5E5E5B2B2B2B0B0B0B9B9B93B95DE6FD5FD71D7FF67CD
        FF40A6FF53B9FF6DD2FF86ECFF6BD1EF258BD6349ADD82E7FF72D8FF47ADFF33
        99FF187EC71076B558BEFA4DB3EC32719DBDBDBDF5F5F5FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFC9C9C
        9CD7D7D7D6D6D6B7B7B7A9A9A9BDBDBDD4D4D4E8E8E8FFFFFFF6F6F6E3E3E3D2
        D2D288AED04FB5F276DCFF74DAFF4EB4FF40A6FF53B9FF6DD2FF86ECFF99FFFF
        7FE5F75CC2F476DCFF5FC5FF47ADFF2D93F4086EA92B91D65CC2FF2A90D37286
        93DDDDDDFDFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFF6F6F6A8A8A8DBDBDBD9D9D9ADADADA1A1A1B5B5B5
        CCCCCCE3E3E3FAFAFAFDFDFDEBEBEBD7D7D7419AE576DCFE78DEFF72D8FF379D
        FF40A6FF53B9FF6DD2FF86ECFF99FFFF94FAFF74DAFF68CEFF57BDFF47ADFF16
        7CC5096FAB48AEFA49AFF12975ACB6B6B6F2F2F2FFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDBDBDBA7A7
        A7DEDEDEDCDCDCABABAB999999AFAFAFC6C6C6DCDCDCF0F0F0FFFFFFF1F1F19D
        C4E655BAF57EE3FF7BE1FF56BCFF3399FF40A6FF53B9FF6DD2FF86ECFF99FFFF
        94FAFF80E6FF6BD1FF57BDFF3EA4F202689D2288D04CB2FF298FD76B8497DBDB
        DBFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFD7D7D7BCBCBCE1E1E1DFDFDFB0B0B0999999A7A7A7
        BCBCBCCCCCCCD7D7D7E9E9E9F0F0F0439CEE77DDFD80E5FF79DFFF389EFF3399
        FF40A6FF53B9FF76DCFF89EDFF99FFFF94FAFF80E6FF6BD1FF57BDFF288ED200
        6699379DF343A9F62875AEAAAAAAEEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEC4C4C4BCBC
        BCE4E4E4E2E2E2AAAAAA9A9A9A9E9E9EB4B4B4868686878787ADADAD8BB1D54E
        B4F685EBFF82E8FF63C9FF3399FF3399FF40A6FF53B9FF66CCDFA3FDFF9FFFFF
        94FAFF80E6FF6BD1FF57BDFF47ADFF2389DF3DA3FF2D93E144647CA2A2A2E0E0
        E0FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFEFEFEBCBCBCC8C8C8E7E7E7E5E5E5A9A9A99E9E9E999999
        ADADAD797979666666666666358EE37EE4FD88EEFF85EBFF3DA3FF3399FF3399
        FF40A6FF3096D900669949A9C6A7F5F9A8FBFF80E6FF6BD1FF57BDFF47ADFF33
        99FF3DA3FF258BD93C5569666666A0A0A0D9D9D9F7F7F7FEFEFEFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFEAEAEAED6D6
        D6EBEBEBE9E9E9AEAEAEA4A4A4999999A4A4A4666666F4EAD8ABCBE652B8F98D
        F3FF8AF0FF68CEFF3399FF3399FF3399FF40A6FF3D708C6470773366802883A9
        9BE2ECB8F7FF78D6FF57BDFF47ADFF3399FF3DA3FF49AFFC3298E22F638A5D5D
        5D959595DADADAFBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFEFEFEA4A4A4DDDDDDEEEEEEDFDFDFB1B1B1A6A6A69B9B9B
        9C9C9C6F6E6DD9D0BF48A0F585EBFE8FF5FF8DF3FF3EA4FF3399FF3399FF3399
        FF358ED9666666B3A0A093868660666939708973BCD2D1FBFF82D0FF47ADFF33
        99FF3DA3FF4CB2FF5CC2FF4AB0ED286EA5676E73C5C5C5F7F7F7FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE9C9C9CF3F3
        F3F1F1F1E3E3E3B4B4B4ABABABA0A0A099999976767653799E57BDFD94FAFF92
        F8FF78DEFF3399FF3399FF3399FF3399FF3379AF6E6C6CC2ABABDDBBBBBDA1A1
        6D6B6B4066794496B9D7F5F9B2E0FF409FFF3DA3FF4CB2FF5CC2FF66CCFF3CA2
        E55C7C95D6D6D6FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFBFBFB8E8E8EF6F6F6F4F4F4E6E6E6B9B9B9AEAEAEA4A4A4
        999999A2A2A2439CF5B2ECFFE4FEFFF4FFFFEBF9FF6FB9FF3399FF3399FF3399
        FF3BA1F94983A96066699A8B8BDAB4B4CFA9A96D6A6A3461771D79A6C5E2ECBF
        DFFF3DA3FF4CB2FF5CC2FF66CCFF2881C69F9F9FEAEAEAFEFEFEFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEA8A8A8F9F9
        F9F8F8F8ECECECCCCCCCB2B2B2A7A7A79B9B9B9B9B9B69A2DC4DA6FFD6ECFFF8
        FFFFF3FFFFEFFFFF9BD2FF3E9FFF3399FF40A6FF53B9FF56AFD95B6E767B7474
        CFA9A9BE9B9B63636338586B1C83D22C92F03DA3FF4CB2FF5CC2FF4BB1EF4376
        9EC4C4C4F7F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFDBDBDBA9A9A9FDFDFDFDFDFDFBFBFBF9F9F9F2F2F2DCDCDC
        BEBEBEA4A4A4A9A9A999B2CC3D9CFC93CCFEEFFFFFECFFFFE9FFFFC3ECFF53AC
        FF40A6FF53B9FF6DD2FF83E2F5708383968484D2A6A68E7C7C43708F1A81CE2D
        93F23DA3FF4CB2FF5CC2FF2D93E0788590DDDDDDFEFEFEFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDFDFDF929292B3B3
        B3CECECEFAFAFAF8F8F8F5F5F5F3F3F3F1F1F1EEEEEEDFDFDFD1D1D1C8CED469
        AFF561B2FDDDF9FFE4FFFFE0FFFFD2F9FF7CCAFF53B9FF6DD2FF86ECFF93ECEC
        666666D2A6A6BC95955B6870157CC13197FC3DA3FF4CB2FF4FB5F82F7BBAADAD
        ADEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFF6F6F68989898C8175837B736666669F9F9FD4D4D4F2F2F2
        F0F0F0EDEDEDEBEBEBE9E9E9E6E6E6E3E3E3ABCAEA48A3FBAADFFEDDFFFFD9FF
        FFD5FFFFABEAFF73D5FF86ECFF99FFFF666666C59E9ECF9E9E666666248ACF33
        99FF3DA3FF4CB2FF379DEA547A9BD2D2D2FBFBFBFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFE848484E2BD
        96FFD4AAA998866565658383837D7D7D959595BBBBBBD9D9D9E7E7E7E5E5E5E2
        E2E2E0E0E0C8D5E25CA9F47BC5FDCBF8FFD2FFFFCEFFFFBFFAFF93F0FF96F5F5
        666666D2A6A6CF9E9E6666663EA4F23399FF3DA3FF4AB0FD2585D69B9B9BE8E8
        E8FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFEFEFE858585FFD0A0FFD4AA8C8278565656929292DBDBDB
        DDDDDDAEAEAE858585797979979797B6B6B6DFDFDFDCDCDCDADADA8FBCE85AAF
        FAB0EBFEC9FFFFC6FFFFC3FFFF89B3B3887B7BD2A6A6AF8E8E60738347ADFF33
        99FF3DA3FF3BA1F3427BACC2C2C2F6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF909090D9B6
        93FFD4AAA99886575757616161A0A0A0D4D4D4EDEDEDF8F8F8FDFDFDD2D2D29B
        9B9B6E6E6E7B7B7B9B9B9BC5C5C5B6C9DC4FA2F385D1FDC3FFFF9EC6C66D6B6B
        C1A0A0D2A6A68175755B9AC647ADFF3399FF3DA3FF2B91E8798691DDDDDDFEFE
        FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFC3C3C39F8E7DFFD4AAECCAA9706D6B5353535B5B5B
        808080A9A9A9C5C5C5D6D6D6DEDEDEE0E0E0DFDFDFD4D4D4ABABAB8080806868
        686363633B6EA06D8C9E6D6B6BC4A5A5D6ADADA38B8B697B8357BDFF47ADFF33
        99FF359BF83480C3ADADADEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8080
        80C6AB91FFD9B3E2C7AB7975725E5E5E5454545A5A5A65656572727280808085
        85858585858585858080807272726666665F5F5F666666948989CEB0B0DAB4B4
        9E8A8A738383A4F5F57CDDFF47ADFF3399FF2C92F0587FA1D2D2D2FBFBFBFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFE0E0E06F6F6FB3A08DF5D7B7FFE2C5C6B5A5
        968F896666666363635D5D5D5E5E5E5E5E5E5E5E5E5E5E5E6565656666668883
        83AFA2A2D4BEBEE1C3C3C0A6A6837A7A60788B9CEFF5A4FFFFA0FFFF8DF0FF38
        9EFD2E8EE5A7A7A7E9E9E9FEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFF4F4F48A8A8A797571B3A496ECD6C0FFEAD6FFEFDFE2D9CFD9D4CED9D7D5D9
        D9D9D6D4D4D3CCCCE1D7D7EFE0E0ECD9D9E0CBCBB5A5A5857E7E6F6F6FABABAB
        BCD6EF51AEF868CAFB5FC3F948ADF5399FF275AFE3E9E9E9FAFAFAFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD6D6D6929292666666
        837F7B9F9A94B3ADA7CFCBC6D9D7D5D9D9D9D6D4D4CAC4C4ADA7A79A94947F7C
        7C666666878787B3B3B3EFEFEFFBFBFBFFFFFFF0F7FDC7E1FAC3DDF5DBE8F4F9
        F9F9FEFEFEFEFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFF4F4F4D5D5D5ACACAC97979785858584848484
        8484848484848484939393A4A4A4C9C9C9F4F4F4FCFCFCFEFEFEFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
    end
    object lblInfo: TLabel
      Left = 72
      Top = 8
      Width = 268
      Height = 41
      AutoSize = False
      Caption = 
        'Some SMTP requires authentification. Please, enter your username' +
        ' and password for sending email.'
      Layout = tlCenter
      WordWrap = True
    end
  end
  object odCertificate: TOpenDialog
    Filter = 
      'Binary Encoded Certificate (*.cer)|*.cer|PEM Encoded Certificate' +
      ' (*.pem)|*.pem'
    Left = 241
    Top = 10
  end
  object odPrivateKey: TOpenDialog
    Filter = 
      'Certificate private key (*.der, *.key)|*.der;*key|PEM Encoded Ke' +
      'y (*.pem)|*.pem'
    Left = 313
    Top = 9
  end
  object SaveDlg: TSaveDialog
    Left = 376
    Top = 8
  end
  object tmGenerate: TTimer
    Interval = 200
    OnTimer = tmGenerateTimer
    Left = 420
    Top = 14
  end
end
