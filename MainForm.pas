unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SBMessages, StdCtrls, ComCtrls, ExtCtrls, Buttons, SBCustomCertStorage,
  SButils, SBX509;

type
  TEncSert = class(TForm)
    ElMessageEncryptor1: TElMessageEncryptor;
    ElMessageDecryptor1: TElMessageDecryptor;
    ElMessageSigner1: TElMessageSigner;
    ElMessageVerifier1: TElMessageVerifier;
    PageControl1: TPageControl;
    TabSheetSelectCertificates: TTabSheet;
    TabSheetEncrypt2: TTabSheet;
    TabSheetSelect: TTabSheet;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Panel1: TPanel;
    LabelSelectCertificates: TLabel;
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    Panel2: TPanel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label3: TLabel;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    TabSheetEncrypt3: TTabSheet;
    LabelSelectFiles: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Edit2: TEdit;
    SpeedButton2: TSpeedButton;
    Label6: TLabel;
    TabSheetPreview: TTabSheet;
    LabelInfo: TLabel;
    Memo1: TMemo;
    ButtonDoIt: TButton;
    TabSheetFinish: TTabSheet;
    Label8: TLabel;
    TabSheetSign2: TTabSheet;
    Label10: TLabel;
    RadioButton11: TRadioButton;
    RadioButton12: TRadioButton;
    TabSheetDecrypt4: TTabSheet;
    Label20: TLabel;
    Memo4: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    ElMemoryCertStorage1: TElMemoryCertStorage;
    Panel3: TPanel;
    Bevel1: TBevel;
    Image1: TImage;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    TabSheetSignType: TTabSheet;
    Label2: TLabel;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    Label4: TLabel;
    Label7: TLabel;
    RadioButton18: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure ButtonDoItClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    procedure RefreshCertificateListbox;
    function WriteCertificateInfo(Storage : TElCustomCertStorage) : string;
    function GetAlgorithmName(AlgId : integer) : string;
  public
    procedure Encrypt(Step : integer);
    procedure Sign(Step : integer);
    procedure Decrypt(Step : integer);
    procedure Verify(Step : integer);
  end;

var
  EncSert: TEncSert;
  Operation : integer;

const
  SSelectCertificatesForEncryption = 'Please choose certificates, which may be used to decrypt encrypted message';
  SSelectFilesForEncryption        = 'Please select file to encrypt and file where to write encrypted data';
  SInfoEncryption                  = 'Ready to start encryption. Please check all the parameters to be valid';
  SSelectFilesForSigning           = 'Please select file to sign and file where to write signed data';
  SInfoSigning                     = 'Ready to start signing. Please check that all signing options are correct.';
  SSelectCertificatesForSigning    = 'Please choose certificates which should be used to sign the file. At least one certificate must be loaded with corresponding private key';
  SSelectCertificatesForDecryption = 'Please select certificates which should be used to decrypt message. Each certificate should be loaded with corresponding private key';
  SSelectFilesForDecryption        = 'Please select input (encrypted) file and file where to write decrypted data';
  SInfoDecryption                  = 'Ready to start decryption. Please check that all decryption options are correct.';
  SSelectCertificatesForVerifying  = 'Please select certificates which should be used to verify digital signature. Note, that in most cases signer''s certificates are included in signed message, so you may leave certificate list empty';
  SSelectFilesForVerifying         = 'Please select file with a signed message and file where to put original message';
  SInfoVerifying                   = 'Ready to start verifying. Please check that all options are correct.';

  STEP_SELECT_CERTIFICATES   = 1;
  STEP_SELECT_ALGORITHM      = 2;
  STEP_SELECT_FILES          = 3;
  STEP_CHECK_DATA            = 4;
  STEP_PROCESS               = 5;
  STEP_SELECT_SIGNATURE_TYPE = 6;

  OPERATION_ENCRYPTION                  = 1;
  OPERATION_SIGNING                     = 2;
  OPERATION_DECRYPTION                  = 3;
  OPERATION_VERIFYING                   = 4;

implementation

{$R *.DFM}

uses
  SBConstants;

procedure TEncSert.Button1Click(Sender: TObject);
var
  F : file;
  Buf : array of byte;
  Cert : TElX509Certificate;
  KeyLoaded : boolean;
  Sz : word;
begin
  KeyLoaded := false;
  OpenDialog1.Title := 'Select certificate file';
  OpenDialog1.Filter := 'PEM-encoded certificate (*.pem)|*.PEM|DER-encoded certificate (*.cer)|*.CER|PFX-encoded certificate (*.pfx)|*.PFX';
  if OpenDialog1.Execute then
  begin
    AssignFile(F, OpenDialog1.Filename);
    Reset(F, 1);
    SetLength(Buf, FileSize(F));
    BlockRead(F, Buf[0], Length(Buf));
    CloseFile(F);
    Cert := TElX509Certificate.Create(nil);
    if OpenDialog1.FilterIndex = 3 then
      Cert.LoadFromBufferPFX(@Buf[0], Length(Buf), InputBox('Please enter passphrase:', '',''))
    else
    if OpenDialog1.FilterIndex = 1 then
      Cert.LoadFromBufferPEM(@Buf[0], Length(Buf), '')
    else
    if OpenDialog1.FilterIndex = 2 then
      Cert.LoadFromBuffer(@Buf[0], Length(Buf))
    else
    begin
      Cert.Free;
      Exit;
    end;
  end
  else
    Exit;
  if (Operation = OPERATION_DECRYPTION) or (Operation = OPERATION_SIGNING) then
  begin
    Sz := 0;
    Cert.SaveKeyToBuffer(nil, Sz);

    if (Sz = 0) then
    begin
      OpenDialog1.Title := 'Select the corresponding private key file';
      OpenDialog1.Filter := 'PEM-encoded key (*.pem)|*.PEM|DER-encoded key (*.key)|*.key';
      if OpenDialog1.Execute then
      begin
        AssignFile(F, OpenDialog1.Filename);
        Reset(F, 1);
        SetLength(Buf, FileSize(F));
        BlockRead(F, Buf[0], Length(Buf));
        CloseFile(F);
        if OpenDialog1.FilterIndex = 1 then
          Cert.LoadKeyFromBufferPEM(@Buf[0], Length(Buf), InputBox('Please enter passphrase:', '',''))
        else
          Cert.LoadKeyFromBuffer(@Buf[0], Length(Buf));
        KeyLoaded := true;
      end;
    end
    else
      KeyLoaded := true;
  end;
  if (Operation = OPERATION_DECRYPTION) and (not KeyLoaded) then
    MessageDlg('Private key was not loaded, certificate ignored', mtError,
      [mbOk], 0)
  else
  begin
    ElMemoryCertStorage1.Add(Cert);
    RefreshCertificateListbox;
  end;
  Cert.Free;
end;

procedure TEncSert.Button5Click(Sender: TObject);
begin
  EncSert.Close;
end;

procedure TEncSert.Button4Click(Sender: TObject);
var
  I : integer;
  Sz : word;
  Found : boolean;
begin
  if PageControl1.ActivePageIndex = 0 then
  begin
    if RadioButton1.Checked then
    begin
      Operation := OPERATION_ENCRYPTION;
      Encrypt(STEP_SELECT_CERTIFICATES);
    end
    else if RadioButton2.Checked then
    begin
      Operation := OPERATION_SIGNING;
      Sign(STEP_SELECT_SIGNATURE_TYPE);
    end
    else if RadioButton3.Checked then
    begin
      Operation := OPERATION_DECRYPTION;
      Decrypt(STEP_SELECT_CERTIFICATES);
    end
    else if RadioButton4.Checked then
    begin
      Operation := OPERATION_VERIFYING;
      Verify(STEP_SELECT_CERTIFICATES);
    end;
  end
  else if PageControl1.ActivePageIndex = 1 then
  begin
    case Operation of
      OPERATION_ENCRYPTION :
      begin
        if ElMemoryCertStorage1.Count = 0 then
          MessageDlg('No recipient certificate selected. Please select one.',
            mtError, [mbOk], 0)
        else
          Encrypt(STEP_SELECT_ALGORITHM);
      end;
      OPERATION_SIGNING :
      begin
        if ElMessageSigner1.SignatureType = mstPublicKey then
        begin
          Found := false;
          for I := 0 to ElMemoryCertStorage1.Count - 1 do
          begin
            Sz := 0;
            ElMemoryCertStorage1.Certificates[I].SaveKeyToBuffer(nil, Sz);
            if (Sz > 0) then
            begin
              Found := true;
              Break;
            end;
          end;
          if not Found then
            MessageDlg('At least one certificate should be loaded with corresponding private key',
              mtError, [mbOk], 0)
            else
              Sign(STEP_SELECT_ALGORITHM);
        end
        else
        begin
          if ElMemoryCertStorage1.Count = 0 then
            MessageDlg('No recipient certificates selected. Please select at least one certificate.',
              mtError, [mbOk], 0)
          else
            Sign(STEP_SELECT_ALGORITHM);
        end;
      end;
      OPERATION_DECRYPTION :
      begin
        if ElMemoryCertStorage1.Count = 0 then
          MessageDlg('No certificate selected. Please select one.',
            mtError, [mbOk], 0)
        else
          Decrypt(STEP_SELECT_FILES);
      end;
      OPERATION_VERIFYING :
      begin
        Verify(STEP_SELECT_FILES);
      end;
    end; 
  end
  else if PageControl1.ActivePageIndex = 2 then
  begin
    if RadioButton5.Checked then
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_3DES
    else if RadioButton6.Checked then
    begin
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_RC4;
      ElMessageEncryptor1.BitsInKey := 128;
    end
    else if RadioButton7.Checked then
    begin
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_RC4;
      ElMessageEncryptor1.BitsInKey := 40;
    end
    else if RadioButton8.Checked then
    begin
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_RC2;
      ElMessageEncryptor1.BitsInKey := 128;
    end
    else if RadioButton9.Checked then
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_AES128
    else if RadioButton10.Checked then
      ElMessageEncryptor1.Algorithm := SB_ALGORITHM_CNT_AES256;
    Encrypt(STEP_SELECT_FILES);
  end
  else if PageControl1.ActivePageIndex = 3 then
  begin
    if (Edit1.Text = '') or (Edit2.Text = '') then
      MessageDlg('You must select both input and output files', mtError, [mbOk], 0)
    else
    begin
      if Operation = OPERATION_ENCRYPTION then
        Encrypt(STEP_CHECK_DATA)
      else if Operation = OPERATION_SIGNING then
        Sign(STEP_CHECK_DATA)
      else if Operation = OPERATION_DECRYPTION then
        Decrypt(STEP_CHECK_DATA)
      else if Operation = OPERATION_VERIFYING then
        Verify(STEP_CHECK_DATA);
    end;
  end
  else if PageControl1.ActivePageIndex = 6 then
  begin
    if RadioButton11.Checked then
      ElMessageSigner1.HashAlgorithm := SB_ALGORITHM_DGST_MD5
    else if RadioButton12.Checked then
      ElMessageSigner1.HashAlgorithm := SB_ALGORITHM_DGST_SHA1
    else if RadioButton13.Checked then
      ElMessageSigner1.HashAlgorithm := SB_ALGORITHM_DGST_SHA256
    else if RadioButton14.Checked then
      ElMessageSigner1.HashAlgorithm := SB_ALGORITHM_DGST_SHA384
    else if RadioButton15.Checked then
      ElMessageSigner1.HashAlgorithm := SB_ALGORITHM_DGST_SHA512;
    ElMessageSigner1.MacAlgorithm := SB_ALGORITHM_MAC_HMACSHA1;
    Sign(STEP_SELECT_FILES);
  end
  else if PageControl1.ActivePageIndex = 8 then
  begin
    if RadioButton16.Checked then
      ElMessageSigner1.SignatureType := mstPublicKey
    else
      ElMessageSigner1.SignatureType := mstMAC;
    Sign(STEP_SELECT_CERTIFICATES);
  end;
end;

procedure TEncSert.Encrypt(Step : integer);
var
  InBuf, OutBuf : array of byte;
  F : file;
  Sz : integer;
  I : integer;
begin
  Button3.Enabled := true;
  Button4.Enabled := true;
  case Step of
    STEP_SELECT_CERTIFICATES :
    begin
      while ElMemoryCertStorage1.Count > 0 do
        ElMemoryCertStorage1.Remove(0);
      ListBox1.Clear;
      LabelSelectCertificates.Caption := SSelectCertificatesForEncryption;
      PageControl1.ActivePageIndex := 1;
    end;
    STEP_SELECT_ALGORITHM :
    begin
      PageControl1.ActivePageIndex := 2;
    end;
    STEP_SELECT_FILES :
    begin
      Edit1.Text := '';
      Edit2.Text := '';
      LabelSelectFiles.Caption := SSelectFilesForEncryption;
      PageControl1.ActivePageIndex := 3;
    end;
    STEP_CHECK_DATA :
    begin
      Memo1.Lines.Clear;
      LabelInfo.Caption := SInfoEncryption;
      ButtonDoIt.Caption := 'Encrypt';
      Memo1.Lines.Add('File to encrypt: ' + Edit1.Text + #13#10);
      Memo1.Lines.Add('File to write decrypted data: ' + Edit2.Text);
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Certificates: ');
      Memo1.Lines.Text := Memo1.Lines.Text + WriteCertificateInfo(ElMemoryCertStorage1);
      Memo1.Lines.Add('Algorithm: ' + GetAlgorithmName(ElMessageEncryptor1.Algorithm));
      PageControl1.ActivePageIndex := 4;
      Button4.Enabled := false;
    end;
    STEP_PROCESS :
    begin
      AssignFile(F, Edit1.Text);
      Reset(F, 1);
      SetLength(InBuf, FileSize(F));
      BlockRead(F, InBuf[0], Length(InBuf));
      CloseFile(F);
      Sz := 0;
      Button3.Enabled := false;
      Button4.Enabled := false;
      Button5.Caption := 'Finish';
      Button5.Default := true;
      ElMessageEncryptor1.Encrypt(@InBuf[0], Length(InBuf), nil, Sz);
      SetLength(OutBuf, Sz);
      Cursor := crHourGlass;
      I := ElMessageEncryptor1.Encrypt(@InBuf[0], Length(InBuf), @OutBuf[0], Sz);
      if I = 0 then
      begin
        SetLength(OutBuf, Sz);
        AssignFile(F, Edit2.Text);
        Rewrite(F, 1);
        BlockWrite(F, OutBuf[0], Sz);
        CloseFile(F);
        Label8.Caption := 'The operation was completed successfully';
      end
      else
        Label8.Caption := 'Error #' + IntToHex(I, 4) + ' occured while encrypting';
      Cursor := crDefault;
      PageControl1.ActivePageIndex := 5;
    end;
  end;
end;

procedure TEncSert.Sign(Step : integer);
var
  InBuf, OutBuf : array of byte;
  F : file;
  Sz : integer;
  I : integer;
begin
  Button3.Enabled := true;
  Button4.Enabled := true;
  case Step of
    STEP_SELECT_SIGNATURE_TYPE:
    begin
      PageControl1.ActivePageIndex := 8;
    end;
    STEP_SELECT_CERTIFICATES :
    begin
      while ElMemoryCertStorage1.Count > 0 do
        ElMemoryCertStorage1.Remove(0);
      ListBox1.Clear;
      LabelSelectCertificates.Caption := SSelectCertificatesForSigning;
      PageControl1.ActivePageIndex := 1;
    end;
    STEP_SELECT_ALGORITHM :
    begin
      PageControl1.ActivePageIndex := 6;
      RadioButton11.Enabled := ElMessageSigner1.SignatureType = mstPublicKey;
      RadioButton12.Enabled := ElMessageSigner1.SignatureType = mstPublicKey;
      RadioButton13.Enabled := ElMessageSigner1.SignatureType = mstPublicKey;
      RadioButton14.Enabled := ElMessageSigner1.SignatureType = mstPublicKey;
      RadioButton15.Enabled := ElMessageSigner1.SignatureType = mstPublicKey;
      RadioButton18.Enabled := ElMessageSigner1.SignatureType = mstMAC;
      if ElMessageSigner1.SignatureType = mstMAC then
        RadioButton18.Checked := true
      else
        RadioButton11.Checked := true;
    end;
    STEP_SELECT_FILES :
    begin
      Edit1.Text := '';
      Edit2.Text := '';
      LabelSelectFiles.Caption := SSelectFilesForSigning;
      PageControl1.ActivePageIndex := 3;
    end;
    STEP_CHECK_DATA :
    begin
      Memo1.Lines.Clear;
      LabelInfo.Caption := SInfoSigning;
      ButtonDoIt.Caption := 'Sign';
      if ElMessageSigner1.SignatureType = mstPublicKey then
        Memo1.Lines.Add('Signature type: PUBLIC-KEY')
      else
        Memo1.Lines.Add('Signature type: MAC');
      ElMessageSigner1.RecipientCerts := ElMemoryCertStorage1;
      Memo1.Lines.Add('File to sign: ' + Edit1.Text + #13#10);
      Memo1.Lines.Add('File to write signed data: ' + Edit2.Text);
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Certificates: ');
      Memo1.Lines.Text := Memo1.Lines.Text + WriteCertificateInfo(ElMemoryCertStorage1);
      Memo1.Lines.Add('Algorithm: ' + GetAlgorithmName(ElMessageSigner1.HashAlgorithm));
      PageControl1.ActivePageIndex := 4;
      Button4.Enabled := false;
    end;
    STEP_PROCESS :
    begin
      AssignFile(F, Edit1.Text);
      Reset(F, 1);
      SetLength(InBuf, FileSize(F));
      BlockRead(F, InBuf[0], Length(InBuf));
      CloseFile(F);
      Sz := 0;
      Button3.Enabled := false;
      Button4.Enabled := false;
      Button5.Caption := 'Finish';
      Button5.Default := true;
      ElMessageSigner1.Sign(@InBuf[0], Length(InBuf), nil, Sz);
      SetLength(OutBuf, Sz);
      Cursor := crHourGlass;
      I := ElMessageSigner1.Sign(@InBuf[0], Length(InBuf), @OutBuf[0], Sz);
      if I = 0 then
      begin
        SetLength(OutBuf, Sz);
        AssignFile(F, Edit2.Text);
        Rewrite(F, 1);
        BlockWrite(F, OutBuf[0], Sz);
        CloseFile(F);
        Label8.Caption := 'The operation was completed successfully';
      end
      else
        Label8.Caption := 'Error #' + IntToHex(I, 4) + ' occured while signing';
      Cursor := crDefault;
      PageControl1.ActivePageIndex := 5;
    end;
  end;
end;

procedure TEncSert.Decrypt(Step : integer);
var
  InBuf, OutBuf : array of byte;
  F : file;
  Sz : integer;
  I : integer;
begin
  Button3.Enabled := true;
  Button4.Enabled := true;
  case Step of
    STEP_SELECT_CERTIFICATES :
    begin
      while ElMemoryCertStorage1.Count > 0 do
        ElMemoryCertStorage1.Remove(0);
      ListBox1.Clear;
      LabelSelectCertificates.Caption := SSelectCertificatesForDecryption;
      PageControl1.ActivePageIndex := 1;
    end;
    STEP_SELECT_FILES :
    begin
      Edit1.Text := '';
      Edit2.Text := '';
      LabelSelectFiles.Caption := SSelectFilesForDecryption;
      PageControl1.ActivePageIndex := 3;
    end;
    STEP_CHECK_DATA :
    begin
      Memo1.Lines.Clear;
      LabelInfo.Caption := SInfoDecryption;
      ButtonDoIt.Caption := 'Decrypt';
      Memo1.Lines.Add('File to decrypt: ' + Edit1.Text + #13#10);
      Memo1.Lines.Add('File to write decrypted data: ' + Edit2.Text);
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Certificates: ');
      Memo1.Lines.Text := Memo1.Lines.Text + WriteCertificateInfo(ElMemoryCertStorage1);
      PageControl1.ActivePageIndex := 4;
      Button4.Enabled := false;
    end;
    STEP_PROCESS :
    begin
      AssignFile(F, Edit1.Text);
      Reset(F, 1);
      SetLength(InBuf, FileSize(F));
      BlockRead(F, InBuf[0], Length(InBuf));
      CloseFile(F);
      Sz := 0;
      Button3.Enabled := false;
      Button4.Enabled := false;
      Button5.Default := true;
      ElMessageDecryptor1.Decrypt(@InBuf[0], Length(InBuf), nil, Sz);
      SetLength(OutBuf, Sz);
      Cursor := crHourGlass;
      I := ElMessageDecryptor1.Decrypt(@InBuf[0], Length(InBuf), @OutBuf[0], Sz);
      Button5.Caption := 'Finish';
      Label20.Caption := 'Decryption results';
      Memo4.Lines.Clear;
      if I = 0 then
      begin
        Memo4.Lines.Add('Successfully decrypted');
        Memo4.Lines.Add('Algorithm: ' + GetAlgorithmName(ElMessageDecryptor1.Algorithm));
        SetLength(OutBuf, Sz);
        AssignFile(F, Edit2.Text);
        Rewrite(F, 1);
        BlockWrite(F, OutBuf[0], Sz);
        CloseFile(F);
      end
      else
        Memo4.Lines.Add('Decryption failed with error #' + IntToHex(I, 4));
      Cursor := crDefault;
      PageControl1.ActivePageIndex := 7;
    end;
  end;
end;

procedure TEncSert.Verify(Step : integer);
var
  InBuf, OutBuf : array of byte;
  F : file;
  Sz : integer;
  I : integer;
begin
  Button3.Enabled := true;
  Button4.Enabled := true;
  case Step of
    STEP_SELECT_CERTIFICATES :
    begin
      while ElMemoryCertStorage1.Count > 0 do
        ElMemoryCertStorage1.Remove(0);
      ListBox1.Clear;
      LabelSelectCertificates.Caption := SSelectCertificatesForVerifying;
      PageControl1.ActivePageIndex := 1;
    end;
    STEP_SELECT_FILES :
    begin
      Edit1.Text := '';
      Edit2.Text := '';
      LabelSelectFiles.Caption := SSelectFilesForVerifying;
      PageControl1.ActivePageIndex := 3;
    end;
    STEP_CHECK_DATA :
    begin
      Memo1.Lines.Clear;
      LabelInfo.Caption := SInfoVerifying;
      ButtonDoIt.Caption := 'Verify';
      Memo1.Lines.Add('File to verify: ' + Edit1.Text + #13#10);
      Memo1.Lines.Add('File to write verified data: ' + Edit2.Text);
      Memo1.Lines.Add('');
      Memo1.Lines.Add('Certificates: ');
      Memo1.Lines.Text := Memo1.Lines.Text + WriteCertificateInfo(ElMemoryCertStorage1);
      PageControl1.ActivePageIndex := 4;
      Button4.Enabled := false;
    end;
    STEP_PROCESS :
    begin
      AssignFile(F, Edit1.Text);
      Reset(F, 1);
      SetLength(InBuf, FileSize(F));
      BlockRead(F, InBuf[0], Length(InBuf));
      CloseFile(F);
      Sz := 0;
      Button3.Enabled := false;
      Button4.Enabled := false;
      Button5.Caption := 'Finish';
      Button5.Default := true;
      ElMessageVerifier1.Verify(@InBuf[0], Length(InBuf), nil, Sz);
      SetLength(OutBuf, Sz);
      Cursor := crHourGlass;
      I := ElMessageVerifier1.Verify(@InBuf[0], Length(InBuf), @OutBuf[0], Sz);
      Label20.Caption := 'Verifying results';
      Memo4.Lines.Clear;
      if I = 0 then
      begin
        Memo4.Lines.Add('Successfully verified!');
        Memo4.Lines.Add('');
        if ElMessageVerifier1.SignatureType = mstPublicKey then
        begin
          Memo4.Lines.Add('Signature type: PUBLIC KEY');
          Memo4.Lines.Add('');
        end
        else
        begin
          Memo4.Lines.Add('Signature type: MAC');
          Memo4.Lines.Add('');
          Memo4.Lines.Add('MAC algorithm: ' + GetAlgorithmName(ElMessageVerifier1.MacAlgorithm));
        end;
        Memo4.Lines.Add('Hash Algorithm: ' + GetAlgorithmName(ElMessageVerifier1.HashAlgorithm));
        Memo4.Lines.Add('');
        Memo4.Lines.Add('Certificates contained in message:');
        Memo4.Lines.Add(WriteCertificateInfo(ElMessageVerifier1.Certificates));
        SetLength(OutBuf, Sz);
        AssignFile(F, Edit2.Text);
        Rewrite(F, 1);
        BlockWrite(F, OutBuf[0], Sz);
        CloseFile(F);
      end
      else
        Memo4.Lines.Add('Verification failed with error #' + IntToHex(I, 4));
      Cursor := crDefault;
      PageControl1.ActivePageIndex := 7;
    end;
  end;
end;

procedure TEncSert.RefreshCertificateListbox;
var
  I : integer;
begin
  ListBox1.Clear;
  for I := 0 to ElMemoryCertStorage1.Count - 1 do
    ListBox1.Items.Add(ElMemoryCertStorage1.Certificates[I].SubjectName.CommonName);
end;

procedure TEncSert.Button2Click(Sender: TObject);
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    ElMemoryCertStorage1.Remove(ListBox1.ItemIndex);
    RefreshCertificateListbox;
  end;
end;

procedure TEncSert.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Select input file';
  OpenDialog1.Filter := 'All files (*.*)|*.*';
  if OpenDialog1.Execute then
    Edit1.Text := OpenDialog1.Filename;
end;

procedure TEncSert.SpeedButton2Click(Sender: TObject);
begin
  SaveDialog1.Title := 'Select output file';
  SaveDialog1.Filter := 'All files (*.*)|*.*';
  if SaveDialog1.Execute then
    Edit2.Text := SaveDialog1.Filename;
end;

function TEncSert.WriteCertificateInfo(Storage : TElCustomCertStorage) : string;
var
  I : integer;
  Cert : TElX509Certificate;
  Sz : word;
begin
  for I := 0 to Storage.Count - 1 do
  begin
    Cert := Storage.Certificates[I];
    Result := Result + 'Certificate #' + IntToStr(I + 1) + ':'#13#10;
    Result := Result + 'Issuer: C=' + Cert.IssuerName.Country + ', L=' +
      Cert.IssuerName.Locality + ', O=' + Cert.IssuerName.Organization + ', CN=' +
      Cert.IssuerName.CommonName + #13#10;
    Result := Result + 'Subject: C=' + Cert.SubjectName.Country + ', L=' +
      Cert.SubjectName.Locality + ', O=' + Cert.SubjectName.Organization + ', CN=' +
      Cert.SubjectName.CommonName + #13#10;
    Sz := 0;
    Cert.SaveKeyToBuffer(nil, Sz);
    if Sz > 0 then
      Result := Result + 'Private key available'#13#10#13#10
    else
      Result := Result + 'Private key is not available'#13#10#13#10;
  end;
end;

function TEncSert.GetAlgorithmName(AlgId : integer) : string;
begin
  case AlgId of
    SB_ALGORITHM_CNT_3DES : Result := 'Triple DES';
    SB_ALGORITHM_CNT_RC4 : Result := 'RC4';
    SB_ALGORITHM_CNT_RC2 : Result := 'RC2';
    SB_ALGORITHM_CNT_AES128 : Result := 'AES128';
    SB_ALGORITHM_CNT_AES256 : Result := 'AES256';
    SB_ALGORITHM_DGST_MD5 : Result := 'MD5';
    SB_ALGORITHM_DGST_SHA1 : Result := 'SHA1';
    SB_ALGORITHM_DGST_SHA256 : Result := 'SHA256';
    SB_ALGORITHM_DGST_SHA384 : Result := 'SHA384';
    SB_ALGORITHM_DGST_SHA512 : Result := 'SHA512';
    SB_ALGORITHM_MAC_HMACSHA1 : Result := 'HMAC-SHA1';
  else
    Result := 'Unknown';
  end;
end;

procedure TEncSert.ButtonDoItClick(Sender: TObject);
begin
  if Operation = OPERATION_ENCRYPTION then
    Encrypt(STEP_PROCESS)
  else if Operation = OPERATION_SIGNING then
    Sign(STEP_PROCESS)
  else if Operation = OPERATION_DECRYPTION then
    Decrypt(STEP_PROCESS)
  else if Operation = OPERATION_VERIFYING then
    Verify(STEP_PROCESS);
end;

procedure TEncSert.Button3Click(Sender: TObject);
begin
  if PageControl1.ActivePageIndex = 1 then
  begin
    if Operation = OPERATION_SIGNING then
      PageControl1.ActivePageIndex := 8
    else
    begin
      PageControl1.ActivePageIndex := 0;
      Button3.Enabled := false;
    end;
  end
  else if PageControl1.ActivePageIndex = 8 then
  begin
    PageControl1.ActivePageIndex := 0;
    Button3.Enabled := false;
  end
  else if (PageControl1.ActivePageIndex = 2) or (PageControl1.ActivePageIndex = 6) then
    PageControl1.ActivePageIndex := 1
  else if PageControl1.ActivePageIndex = 3 then
  begin
    if Operation = OPERATION_ENCRYPTION then
      PageControl1.ActivePageIndex := 2
    else if (Operation = OPERATION_DECRYPTION) or (Operation = OPERATION_VERIFYING) then
      PageControl1.ActivePageIndex := 1
    else if (Operation = OPERATION_SIGNING) then
      PageControl1.ActivePageIndex := 6;
  end
  else if PageControl1.ActivePageIndex = 4 then
  begin
    PageControl1.ActivePageIndex := 3;
    Button4.Enabled := true;
  end
end;


initialization
SetLicenseKey('ADDCD14AD06709806817E0B3D7BFD0A2222D536FE156466C5D5FE65DB5DEAE76' + 
  'FFDEBC07E915A5751C12C01C783958872A38E4A5EDA140E7247E0F2E56442A3C' + 
  'F3E9347AD8FDE52083A0DFC86BC00ECB0FD0CF1B51159A2BCB84F6EA6349EF47' + 
  '5C15A59AFCC55F7C3AAD26C279628B5D91B1DC94BD2385354A70CCA3B76101D9' + 
  'F41C84A639FC3CCE4BA8F0CC4A66DCD150114A3F58C1AD46B7B94643741BC20A' + 
  '8DCA83AB921480951B423CAA19EF1863A47CA2C3422E7E5634BED98939A5AE43' + 
  'DE1E4BAD79E66D8A5C973B3455656C8C9B6FF024FADD6CDA02D0F506D98493C8' + 
  'BD1ED7B237DB75FA31F2C82654490CDDDEE24E19939137B9E1DB05508733B22F');

end.
