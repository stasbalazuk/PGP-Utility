unit GenerateCert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBX509, ComCtrls, SBCustomCertStorage, SBWinCertStorage, SBPEM,
  SBRDN, SBASN1Tree, SBUtils, SBPKCS10,
  ExtCtrls, Mask;

type
  TfrmGenerateCert = class(TForm)
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    odCertificate: TOpenDialog;
    odPrivateKey: TOpenDialog;
    pcMain: TPageControl;
    tsSelectAction: TTabSheet;
    tsSelectKeyAndHashAlgorithm: TTabSheet;
    tsSelectParentCertificate: TTabSheet;
    tsEnterFields: TTabSheet;
    tsSpecifyPeriod: TTabSheet;
    tsGenerate: TTabSheet;
    lblCertTypeSelect: TLabel;
    lblPublicKeyAndHash: TLabel;
    lblParentCertificate: TLabel;
    gbCertificate: TGroupBox;
    lblCertificateFile: TLabel;
    lblPrivateKeyFile: TLabel;
    edtCertificateFile: TEdit;
    edtPrivateKeyFile: TEdit;
    btnLoadCertificate: TButton;
    btnLoadPrivateKey: TButton;
    rbFromFile: TRadioButton;
    rbFromStorage: TRadioButton;
    tvCertificates: TTreeView;
    gbSubject: TGroupBox;
    lblCountry: TLabel;
    lblState: TLabel;
    lblLocality: TLabel;
    lblOrganization: TLabel;
    lblOrganizationUnit: TLabel;
    lblCommonName: TLabel;
    edtState: TEdit;
    edtLocality: TEdit;
    edtOrganization: TEdit;
    edtOrganizationUnit: TEdit;
    edtCommonName: TEdit;
    lblContents: TLabel;
    lblCertificateDate: TLabel;
    gbCertificateDate: TGroupBox;
    lblValidFrom: TLabel;
    lblValidTo: TLabel;
    dtpFrom: TDateTimePicker;
    dtpTo: TDateTimePicker;
    lbGenerate: TLabel;
    btnGenerate: TButton;
    lblSelectPublicKeyLen: TLabel;
    tsSelectKeyAlgorithm: TTabSheet;
    lblSelectPublicKeyAlg: TLabel;
    lblKeyLen: TLabel;
    gbSelectPublicKeyAlgorithm: TGroupBox;
    rbRSA: TRadioButton;
    rbDSA: TRadioButton;
    rbDH: TRadioButton;
    tsSaveCertificateRequest: TTabSheet;
    SaveDlg: TSaveDialog;
    lblSelectTargetFiles: TLabel;
    lblRequest: TLabel;
    lblPrivateKey: TLabel;
    edRequest: TEdit;
    edPrivateKey: TEdit;
    btnRequest: TButton;
    btnPrivateKey: TButton;
    btnSave: TButton;
    rgPublicKeyAndHash: TRadioGroup;
    bvlTop: TBevel;
    pnlTop: TPanel;
    imgKeys: TImage;
    lblInfo: TLabel;
    cbCountry: TComboBox;
    tmGenerate: TTimer;
    pbGenerate: TProgressBar;
    gbCertType: TGroupBox;
    rbSelfSigned: TRadioButton;
    rbChild: TRadioButton;
    cbPublicKeyLen: TComboBox;
    cbKeyLen: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnLoadCertificateClick(Sender: TObject);
    procedure btnLoadPrivateKeyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure rbFromStorageClick(Sender: TObject);
    procedure rbFromFileClick(Sender: TObject);
    procedure btnRequestClick(Sender: TObject);
    procedure btnPrivateKeyClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure pcMainChange(Sender: TObject);
    procedure tmGenerateTimer(Sender: TObject);
  private
    Generating : boolean;
    FCreateCSR: Boolean;
    FRequest: TElCertificateRequest;
    procedure HandleThreadTerminate(Sender : TObject);
    procedure SetCreateCSR(const Value: Boolean);
    function GetSelfSignedCertificate: Boolean;

    function GetKeyLength: Integer;
    function GetPublicKeyAndHashAlgorithm: Integer;
    function GetPublicKeyAlgorithm: Integer;

    procedure HandleCreateCSRThreadTerminate(Sender : TObject);
    function ProcessSelectParentCertificate: Boolean;
    function ValidateEnterFields: Boolean;
    function ValidateKeyLength: Boolean;
    procedure StartProgressbar;
    procedure StopProgressbar;
  protected
    CACert : TElX509Certificate;

    property SelfSignedCertificate: Boolean read GetSelfSignedCertificate;

    property CreateCSR: Boolean read FCreateCSR write SetCreateCSR;
    property Request: TElCertificateRequest read FRequest;

  public
    class procedure DoCreateCSR;
    class procedure DoCreateCertificate;
  end;

type
  TRequestGenerationThread = class(TThread)
  private
    FRequest: TElCertificateRequest;
    FAlg: Integer;
    FHash: Integer;
    FKeyLen: Integer;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    constructor Create(ARequest: TElCertificateRequest; AAlg, AKeyLen, AHash: Integer); overload;

    destructor Destroy; override;
    procedure Execute; override;

    property Request: TElCertificateRequest read FRequest;
  end;

var
  frmGenerateCert: TfrmGenerateCert;
  OpenIndex1, OpenIndex2: integer;

function GetStringByOID(const S : BufferType) : string;
function GetOIDValue(NTS: TElRelativeDistinguishedName; const S: BufferType; const Delimeter: AnsiString = ' / '): AnsiString;

implementation

uses CertificateGenerationThread, frmMain, CountryList;

{$R *.DFM}

var Thread : TThread;

function GetStringByOID(const S : BufferType) : string;
begin
  if CompareContent(S, SB_CERT_OID_COMMON_NAME) then
    Result := 'CommonName'
  else
  if CompareContent(S, SB_CERT_OID_COUNTRY) then
    Result := 'Country'
  else
  if CompareContent(S, SB_CERT_OID_LOCALITY) then
    Result := 'Locality'
  else
  if CompareContent(S, SB_CERT_OID_STATE_OR_PROVINCE) then
    Result := 'StateOrProvince'
  else
  if CompareContent(S, SB_CERT_OID_ORGANIZATION) then
    Result := 'Organization'
  else
  if CompareContent(S, SB_CERT_OID_ORGANIZATION_UNIT) then
    Result := 'OrganizationUnit'
  else
  if CompareContent(S, SB_CERT_OID_EMAIL) then
    Result := 'Email'
  else
    Result := 'UnknownField';
end;

function GetOIDValue(NTS: TElRelativeDistinguishedName; const S: BufferType; const Delimeter: AnsiString = ' / '): AnsiString;
var
  i: Integer;
  t: AnsiString;
begin
  Result := '';
  for i := 0 to NTS.Count - 1 do
    if CompareContent(S, NTS.OIDs[i]) then
    begin
      t := AnsiString(NTS.Values[i]);
      if t = '' then
        Continue;

      if Result = '' then
      begin
        Result := t;
        if Delimeter = '' then
          Exit;
      end
      else
        Result := Result + Delimeter + t;
    end;
end;

procedure TfrmGenerateCert.FormCreate(Sender: TObject);
var i : integer;
begin
  // Hide tabs
  For i:=0 to pcMain.PageCount - 1 do
    pcMain.Pages[i].TabVisible:=False;

  CACert := TElX509Certificate.Create(nil);
  dtpFrom.Date := Date;
  dtpTo.Date := IncMonth(dtpFrom.Date,12);
  pcMain.ActivePage := tsSelectAction;
  btnBack.Enabled := false;
  btnNext.Enabled := true;
  // Country list
  FillCountryCombo(cbCountry);
  // Fill public key and hash
  rgPublicKeyAndHash.Items.Clear;
  with rgPublicKeyAndHash.Items do
  begin
    AddObject('MD2 with RSA',TObject(SB_CERT_ALGORITHM_MD2_RSA_ENCRYPTION));
    AddObject('MD5 with RSA',TObject(SB_CERT_ALGORITHM_MD5_RSA_ENCRYPTION));
    AddObject('DSA with SHA1',TObject(SB_CERT_ALGORITHM_ID_DSA_SHA1));
    AddObject('SHA1 with RSA',TObject(SB_CERT_ALGORITHM_SHA1_RSA_ENCRYPTION));
    AddObject('SHA224 with RSA',TObject(SB_CERT_ALGORITHM_SHA224_RSA_ENCRYPTION));
    AddObject('SHA256 with RSA',TObject(SB_CERT_ALGORITHM_SHA256_RSA_ENCRYPTION));
    AddObject('SHA384 with RSA',TObject(SB_CERT_ALGORITHM_SHA384_RSA_ENCRYPTION));
    AddObject('SHA512 with RSA',TObject(SB_CERT_ALGORITHM_SHA512_RSA_ENCRYPTION));
    AddObject('RIPEMD160 with RSA',TObject(SB_CERT_ALGORITHM_RSASIGNATURE_RIPEMD160));
  end;
  rgPublicKeyAndHash.ItemIndex:=0;
end;

procedure TfrmGenerateCert.FormDestroy(Sender: TObject);
begin
  FreeAndNil(CACert);
  FreeAndNil(FRequest);
end;

// Used on generation
procedure TfrmGenerateCert.StartProgressbar;
begin
  pbGenerate.Position:=0;
  pbGenerate.Visible:=True;
  tmGenerate.Enabled:=True;
end;

procedure TfrmGenerateCert.StopProgressbar;
begin
  tmGenerate.Enabled:=False;
  pbGenerate.Visible:=False;
  Update; Application.ProcessMessages;
end;

procedure TfrmGenerateCert.btnGenerateClick(Sender: TObject);
var
  Cert : TElX509Certificate;
  SignatureAlgorithm : Integer;
  i : integer;
  Algorithm, Hash: Integer;
begin
  if CreateCSR then
  begin
    FRequest := TElCertificateRequest.Create(nil);
    FRequest.Subject.Count := 6;
    For i:=0 to 5 do FRequest.Subject.Tags[i] := SB_ASN1_PRINTABLESTRING;
    FRequest.Subject.OIDs[0] := SB_CERT_OID_COUNTRY;
    FRequest.Subject.Values[0] := GetCountryAbbr(cbCountry.Text);
    FRequest.Subject.OIDs[1] := SB_CERT_OID_STATE_OR_PROVINCE;
    FRequest.Subject.Values[1] := edtState.Text;
    FRequest.Subject.OIDs[2] := SB_CERT_OID_LOCALITY;
    FRequest.Subject.Values[2] := edtLocality.Text;
    FRequest.Subject.OIDs[3] := SB_CERT_OID_ORGANIZATION;
    FRequest.Subject.Values[3] := edtOrganization.Text;
    FRequest.Subject.OIDs[4] := SB_CERT_OID_ORGANIZATION_UNIT;
    FRequest.Subject.Values[4] := edtOrganizationUnit.Text;
    FRequest.Subject.OIDs[5] := SB_CERT_OID_COMMON_NAME;
    FRequest.Subject.Values[5] := edtCommonName.Text;

    Hash := GetPublicKeyAndHashAlgorithm;
    if Hash = SB_CERT_ALGORITHM_ID_DSA_SHA1 then
      Algorithm := SB_CERT_ALGORITHM_ID_DSA
    else
      Algorithm := SB_CERT_ALGORITHM_ID_RSA_ENCRYPTION;

    Screen.Cursor := crHourGlass;

    Generating := True;
    btnBack.Enabled := false;
    btnNext.Enabled := false;
    btnCancel.Enabled := false;
    btnGenerate.Enabled := false;

    Thread := TRequestGenerationThread.Create(FRequest, Algorithm, GetKeyLength, Hash);
    Thread.OnTerminate := Self.HandleCreateCSRThreadTerminate;
    StartProgressbar;
    Thread.Resume;

    Exit;
  end;
  {
  Serial Number: 61 07 11 43 00 00 00 00 00 34   / '00 AB B6 C5 13 05 DC 60 48 8F A3 35 83 45 A7 E6 A6'
  Issuer Name: Microsoft Code Signing PCA
  Subject Name: Microsoft Corporation
  }
  Cert := TElX509Certificate.Create(nil);
  Cert.SubjectRDN.Count := 6;
  Randomize;
  Cert.SerialNumber := IntToStr(Random(1000000000));//'61 07 11 43 00 00 00 00 00 34';
  Cert.WriteSerialNumber;
  Cert.IssuerUniqueID;
  Cert.IsKeyValid;
  
  For i:=0 to 5 do Cert.SubjectRDN.Tags[i] := SB_ASN1_PRINTABLESTRING;
  Cert.SubjectRDN.OIDs[0] := SB_CERT_OID_COUNTRY;
  Cert.SubjectRDN.Values[0] := GetCountryAbbr(cbCountry.Text);
  Cert.SubjectRDN.OIDs[1] := SB_CERT_OID_STATE_OR_PROVINCE;
  Cert.SubjectRDN.Values[1] := edtState.Text;
  Cert.SubjectRDN.OIDs[2] := SB_CERT_OID_LOCALITY;
  Cert.SubjectRDN.Values[2] := edtLocality.Text;
  Cert.SubjectRDN.OIDs[3] := SB_CERT_OID_ORGANIZATION;
  Cert.SubjectRDN.Values[3] := edtOrganization.Text;
  Cert.SubjectRDN.OIDs[4] := SB_CERT_OID_ORGANIZATION_UNIT;
  Cert.SubjectRDN.Values[4] := edtOrganizationUnit.Text;
  Cert.SubjectRDN.OIDs[5] := SB_CERT_OID_COMMON_NAME;
  Cert.SubjectRDN.Values[5] := edtCommonName.Text;
  Cert.ValidFrom := dtpFrom.Date;
  Cert.ValidTo := dtpTo.Date;

  if rbSelfSigned.Checked then
  begin
    SignatureAlgorithm := GetPublicKeyAndHashAlgorithm();
    Cert.CAAvailable := False;

    Cert.IssuerRDN.Count := 6;
    For i:=0 to 5 do Cert.IssuerRDN.Tags[i] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.Tags[0] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[0] := SB_CERT_OID_COUNTRY;
    Cert.IssuerRDN.Values[0] := GetCountryAbbr(cbCountry.Text);
    Cert.IssuerRDN.Tags[1] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[1] := SB_CERT_OID_STATE_OR_PROVINCE;
    Cert.IssuerRDN.Values[1] := edtState.Text;
    Cert.IssuerRDN.Tags[2] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[2] := SB_CERT_OID_LOCALITY;
    Cert.IssuerRDN.Values[2] := edtLocality.Text;
    Cert.IssuerRDN.Tags[3] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[3] := SB_CERT_OID_ORGANIZATION;
    Cert.IssuerRDN.Values[3] := edtOrganization.Text;
    Cert.IssuerRDN.Tags[4] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[4] := SB_CERT_OID_ORGANIZATION_UNIT;
    Cert.IssuerRDN.Values[4] := edtOrganizationUnit.Text;
    Cert.IssuerRDN.Tags[0] := SB_ASN1_PRINTABLESTRING;
    Cert.IssuerRDN.OIDs[5] := SB_CERT_OID_COMMON_NAME;
    Cert.IssuerRDN.Values[5] := edtCommonName.Text;
  end
  else
  begin
    SignatureAlgorithm := GetPublicKeyAlgorithm();
  end;

  Screen.Cursor := crHourGlass;

  Generating := true;
  btnBack.Enabled := false;
  btnNext.Enabled := false;
  btnCancel.Enabled := false;
  btnGenerate.Enabled := false;

  If rbSelfSigned.Checked then
    Thread := TCertificateGenerationThread.Create(nil, Cert, SignatureAlgorithm, GetKeyLength div 32)
  else
    Thread := TCertificateGenerationThread.Create(CACert, Cert, SignatureAlgorithm, GetKeyLength div 32);
  Thread.OnTerminate := HandleThreadTerminate;
  StartProgressbar;
  Thread.Resume;
end;

procedure TfrmGenerateCert.btnLoadCertificateClick(Sender: TObject);
begin
  if odCertificate.Execute then
  begin
    edtCertificateFile.Text := odCertificate.FileName;
    OpenIndex1 := odCertificate.FilterIndex;
  end;
end;

procedure TfrmGenerateCert.btnLoadPrivateKeyClick(Sender: TObject);
begin
  if odPrivateKey.Execute then
  begin
    edtPrivateKeyFile.Text := odPrivateKey.FileName;
    OpenIndex2 := odPrivateKey.FilterIndex;
  end;
end;

procedure TfrmGenerateCert.FormActivate(Sender: TObject);
begin
  tvCertificates.Items.Clear;
  tvCertificates.Items := SertX509.treeCert.Items;
end;

procedure TfrmGenerateCert.btnCancelClick(Sender: TObject);
begin
  if Generating then
    Thread.Suspend;

  if MessageDlg('Are you sure you want to cancel operation?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if Generating then
    begin
      Thread.OnTerminate := nil;
      Thread.FreeOnTerminate := true;
      Thread.Resume;
    end;
    Close;
  end
  else
  if Generating then
    Thread.Resume;
end;

function TfrmGenerateCert.ValidateKeyLength: Boolean;
var
  KeyLen: Integer;
begin
  Result := False;
  KeyLen := GetKeyLength();
  // Memory storage
  if (rgPublicKeyAndHash.ItemIndex = 0) and (rbFromFile.Checked = False) and
     (KeyLen <> 512) and (KeyLen <> 1024) then
  begin
    ShowMessage('The key length is incorrect');
    Exit;
  end;

  if ((KeyLen < 256) or (KeyLen mod 256 <> 0)) then
  begin
    ShowMessage('The key length is incorrect');
    Exit;
  end;

  if (KeyLen < 1024) and (rgPublicKeyAndHash.ItemIndex > 3) then
  begin
    ShowMessage('The key length is incorrect.'#13#10'For SHA-2 key length must be greatet or equal 1024');
    Exit;
  end;
  Result := True;
end;

function TfrmGenerateCert.ValidateEnterFields: Boolean;
begin
  Result := False;
  if (cbCountry.ItemIndex < 0) or (edtLocality.Text = '') or (edtOrganization.Text = '')
     or (edtCommonName.Text = '') then
  begin
    ShowMessage('One or several fields are empty. Correct, please.');
    Exit;
  end;

  Result := True;
end;

function TfrmGenerateCert.ProcessSelectParentCertificate: Boolean;
var
  Size : word;
  Buffer : array[0..4095] of byte;
  F : file;
  Buffer1 : array[0..4095] of byte;
  I, I1 : integer;
  Flag : byte;
  S : string;
begin
  Result := False;

  if (rbFromFile.Checked) then
  begin
    if (edtCertificateFile.Text = '') then
    begin
      ShowMessage('One or several fields have not been specified. Correct, please.');
      Exit;
    end;

    AssignFile(F, edtCertificateFile.Text);
    Reset(F, 1);
    I := 0;
    while not Eof(F) do
    begin
      BlockRead(F, Buffer1[I], 1);
      Inc(I);
    end;

    CloseFile(F);
    Flag := 1;
    if OpenIndex1 = 1 then              // Binary certificate
      CACert.LoadFromBuffer(@Buffer1[0], I)
    else                                // PEM certificate
    begin
      if InputQuery('Password', 'Enter password:', S) then
      begin
        I1 := CACert.LoadFromBufferPEM(@Buffer1[0], I, S);
        while I1 = PEM_DECODE_RESULT_INVALID_PASSPHRASE do
        begin
          MessageDlg('Incorrect password', mtInformation, [mbOk], 0);
          if InputQuery('Password', 'Enter password:', S) then
            I1 := CACert.LoadFromBufferPEM(@Buffer1[0], I, S)
          else
            Exit;
        end;
      end
      else
        Exit;

      case I1 of
        PEM_DECODE_RESULT_INVALID_FORMAT : MessageDlg('Invalid format', mtInformation, [mbOk], 0);
        PEM_DECODE_RESULT_NOT_ENOUGH_SPACE : MessageDlg('Not enough space', mtInformation, [mbOk], 0);
        PEM_DECODE_RESULT_UNKNOWN_CIPHER : MessageDlg('Unknown cipher', mtInformation, [mbOk], 0);
      end;

      Size := 4096;
      CACert.SaveKeyToBufferPEM(@Buffer[0], Size, S);
      if (Size <> 0) then
      begin
        CACert.LoadKeyFromBufferPEM(@Buffer[0], I, S);
        Flag := 0;
        if CACert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_DH_PUBLIC then
        begin
          ShowMessage('This Certificate can not be used for signing');
          Exit;
        end;
      end
      else
      begin
        ShowMessage('This Certificate does not have a private key.');
        Exit;
      end;
    end;

    if (Flag = 1) and (edtPrivateKeyFile.Text <> '') then
    begin
      AssignFile(F, edtPrivateKeyFile.Text);
      Reset(F, 1);
      I := 0;
      while not Eof(F) do
      begin
        BlockRead(F, Buffer1[I], 1);
        Inc(I);
      end;

      CloseFile(F);
      if OpenIndex2 = 1 then // Binary certificate
        CACert.LoadKeyFromBuffer(@Buffer1[0], I)
      else                                // PEM certificate
        CACert.LoadKeyFromBufferPEM(@Buffer1[0], I, '');

      if CACert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_DH_PUBLIC then
      begin
        ShowMessage('This Certificate can not be used for signing');
        Exit;
      end;
    end
    else
      if (Flag = 1) and (edtPrivateKeyFile.Text = '') then
      begin
        ShowMessage('Private key file name has not been specified. Correct, please.');
        Exit;
      end;
  end
  else
  begin
    if (rbFromStorage.Checked) then
    begin
      if ((tvCertificates.Selected = nil) or (tvCertificates.Selected.Data = nil) or
         not (TObject(tvCertificates.Selected.Data) is TElX509Certificate)) then
        ShowMessage('This is not Certificate type. Correct, please.')
      else
      begin
        Size := 4096;
        TElX509Certificate(tvCertificates.Selected.Data).SaveKeyToBuffer(@Buffer[0], Size);
        if Size = 0 then
        begin
          ShowMessage('This Certificate doesn''t have a private key. Correct your choice, please.');
          Exit;
        end
        else
        begin
          TElX509Certificate(tvCertificates.Selected.Data).Clone(CACert,True);
          if CACert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_DH_PUBLIC then
          begin
            ShowMessage('This Certificate can not be used for signing');
            Exit;
          end;
        end;
      end;
    end;
  end;

  Result := True;
end;

procedure TfrmGenerateCert.btnNextClick(Sender: TObject);
var
  Tab: TTabSheet;
begin
  Tab := pcMain.ActivePage;
  if Tab = tsSelectAction then
  begin
    if SelfSignedCertificate or CreateCSR then
      pcMain.ActivePage := tsSelectKeyAndHashAlgorithm
    else
      pcMain.ActivePage := tsSelectParentCertificate;

    btnBack.Enabled := True;
  end
  else if Tab = tsSelectKeyAndHashAlgorithm then
  begin
    if not ValidateKeyLength then
      Exit;

    pcMain.ActivePage := tsEnterFields;
    btnBack.Enabled := True;
  end
  else if Tab = tsSelectKeyAlgorithm then
  begin
    if not ValidateKeyLength then
      Exit;

    pcMain.ActivePage := tsEnterFields;
  end
  else if Tab = tsEnterFields then
  begin
    if not ValidateEnterFields then
      Exit;

    if CreateCSR then
    begin
      lbGenerate.Caption := 'The certificate request will be generated now. This process can take long time, depending on the key length.';
      pcMain.ActivePage := tsGenerate;
      btnNext.Enabled := False;
    end
    else
      pcMain.ActivePage := tsSpecifyPeriod;
  end
  else if Tab = tsSpecifyPeriod then
  begin
    lbGenerate.Caption := 'The certificate will be generated now. This process can take long time, depending on the key length.';
    pcMain.ActivePage := tsGenerate;
    btnNext.Enabled := False;
  end
  else if Tab = tsSelectParentCertificate then
  begin
    if not ProcessSelectParentCertificate then
      Exit;

    pcMain.ActivePage := tsSelectKeyAlgorithm;
  end;
end;

procedure TfrmGenerateCert.btnBackClick(Sender: TObject);
var
  Tab: TTabSheet;
begin
  Tab := pcMain.ActivePage;
  if Tab = tsSelectParentCertificate then
  begin
    pcMain.ActivePage := tsSelectAction;
    btnBack.Enabled := False;
  end
  else if Tab = tsGenerate then
  begin
    if (CreateCSR) then
      pcMain.ActivePage := tsEnterFields
    else
      pcMain.ActivePage := tsSpecifyPeriod;

    btnNext.Enabled := true;
  end
  else if Tab = tsSpecifyPeriod then
  begin
    pcMain.ActivePage := tsEnterFields;
  end
  else if Tab = tsEnterFields then
  begin
    if SelfSignedCertificate or CreateCSR then
    begin
      pcMain.ActivePage := tsSelectKeyAndHashAlgorithm;
      if (CreateCSR) then
        btnBack.Enabled := false;
    end
    else
    begin
      pcMain.ActivePage := tsSelectKeyAlgorithm;
    end;
  end
  else if Tab = tsSelectKeyAlgorithm then
  begin
    pcMain.ActivePage := tsSelectParentCertificate;
  end
  else if Tab = tsSelectKeyAndHashAlgorithm then
  begin
    pcMain.ActivePage := tsSelectAction;
    btnBack.Enabled := false;
  end
  else if Tab = tsSaveCertificateRequest then
    pcMain.ActivePage := tsGenerate;
end;


procedure TfrmGenerateCert.btnRequestClick(Sender: TObject);
begin
  SaveDlg.Title := 'Save Certificate Request';
  SaveDlg.DefaultExt := 'crq';
  SaveDlg.Filter := 'Certificate Requests (*.crq)|*.crq|Certificate Requests in text format (*.csr)|*.csr|PEM Encoded certificate requests (*.pem)|*.pem|Text Files (*.txt)|*.txt';
  SaveDlg.FilterIndex := 1;
  if SaveDlg.Execute then
    edRequest.Text := SaveDlg.FileName;
end;

procedure TfrmGenerateCert.btnPrivateKeyClick(Sender: TObject);
begin
  SaveDlg.Title := 'Save Private Key';
  SaveDlg.DefaultExt := 'key';
  SaveDlg.Filter := 'Private Keys (*.key)|*.key|MS-secret private keys (*.pvk)|*.pvk|Base64-encoded private keys (*.pem)|*.pem|All Files (*.*)|*.*';
  SaveDlg.FilterIndex := 1;
  if SaveDlg.Execute then
    edPrivateKey.Text := SaveDlg.FileName;
end;

procedure TfrmGenerateCert.btnSaveClick(Sender: TObject);
var
  Ext, Pwd: string;
  Stream: TFileStream;
begin
  if (edRequest.Text = '') or (edPrivateKey.Text = '') then
  begin
    ShowMessage('You must select both files');
    Exit;
  end;

  Stream := TFileStream.Create(edRequest.Text, fmCreate);
  try
    Ext := LowerCase(Copy(edRequest.Text, Length(edRequest.Text) - 3, MaxInt));
    if (Ext = '.csr') or (Ext = '.pem') or (Ext = '.txt') then
      Request.SaveToStreamPEM(Stream)
    else
      Request.SaveToStream(Stream);
  except
    ShowMessage('Failed to save Certificate Signing Request');
    FreeAndNil(Stream);
    Exit;
  end;

  FreeAndNil(Stream);

  Stream := TFileStream.Create(edPrivateKey.Text, fmCreate);
  try
    Ext := LowerCase(Copy(edPrivateKey.Text, Length(edPrivateKey.Text) - 3, MaxInt));
    if (Ext = '.pem') or (Ext = '.pvk') then
    begin
      if not InputQuery('Enter password', 'Enter password for private key', Pwd) then
      begin
        FreeAndNil(Stream);
        Exit;
      end;

      if Ext = '.pem' then
     	Request.SaveKeyToStreamPEM(Stream, Pwd)
      else
        RaiseX509Error(Request.SaveKeyToStreamPVK(Stream, Pwd, True));
    end
    else
      Request.SaveKeyToStream(Stream);
  except
    ShowMessage('Failed to save private key for Certificate Signing Request');
    FreeAndNil(Stream);
    Exit;
  end;

  FreeAndNil(Stream);

  ModalResult := mrOK;
  Close;
end;

procedure TfrmGenerateCert.HandleThreadTerminate(Sender : TObject);
var
  Cert : TElX509Certificate;
  s : string;
  TI,Parent : TTreeNode;
begin
  Generating := False;

  Cert := TCertificateGenerationThread(Sender).Cert;

  Storage.Add(Cert);

  s := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_COMMON_NAME);
  if s = '' then
    s := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_ORGANIZATION);
  if s = '' then
    s := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_EMAIL);

  if not (TObject(SertX509.treeCert.Selected.Data) is TElX509Certificate) then
    Parent := SertX509.treeCert.Selected
  else
    Parent := SertX509.treeCert.Selected.Parent;

  TI:=SertX509.treeCert.Items.AddChildObject(Parent, s, Cert);
  TI.ImageIndex:=3; TI.SelectedIndex:=3;
  StopProgressbar;
  Screen.Cursor := crDefault;
  GlobalCert := Cert;
  Close;
end;

procedure TfrmGenerateCert.HandleCreateCSRThreadTerminate(Sender: TObject);
begin
  StopProgressbar;
  Screen.Cursor := crDefault;
  btnBack.Enabled := true;
  btnCancel.Enabled := true;
  btnGenerate.Enabled := true;
  pcMain.ActivePage := tsSaveCertificateRequest;
end;

procedure TfrmGenerateCert.rbFromStorageClick(Sender: TObject);
begin
  tvCertificates.Enabled := True;
  edtCertificateFile.Enabled := False;
  edtPrivateKeyFile.Enabled := False;
  btnLoadCertificate.Enabled := False;
  btnLoadPrivateKey.Enabled := False;
  rbFromFile.Checked := False;
end;

procedure TfrmGenerateCert.rbFromFileClick(Sender: TObject);
begin
  tvCertificates.Enabled := False;
  edtCertificateFile.Enabled := True;
  edtPrivateKeyFile.Enabled := True;
  btnLoadCertificate.Enabled := True;
  btnLoadPrivateKey.Enabled := True;
  rbFromStorage.Checked := False;
end;

procedure TfrmGenerateCert.SetCreateCSR(const Value: Boolean);
begin
  FCreateCSR := Value;
  if FCreateCSR then
  begin
    Caption := 'Certificate Signing Request generation';
    pcMain.ActivePage := tsSelectKeyAndHashAlgorithm;
  end
  else
  begin
    Caption := 'Certificate generation';
    pcMain.ActivePage := tsSelectAction;
  end;
  pcMainChange(Self);
end;

function TfrmGenerateCert.GetSelfSignedCertificate: Boolean;
begin
  Result := rbSelfSigned.Checked;
end;

function TfrmGenerateCert.GetKeyLength: Integer;
begin
  if SelfSignedCertificate or CreateCSR then
    Result := StrToIntDef(cbPublicKeyLen.Text, 0)
  else
    Result := StrToIntDef(cbKeyLen.Text, 0);
end;

function TfrmGenerateCert.GetPublicKeyAndHashAlgorithm: Integer;
begin
  try
    // Take algorithm from items
    Result:=
      Integer(rgPublicKeyAndHash.Items.Objects[rgPublicKeyAndHash.ItemIndex]);
  except Result:=0; end;
end;

function TfrmGenerateCert.GetPublicKeyAlgorithm: Integer;
begin
  if rbRSA.Checked then
    Result := SB_CERT_ALGORITHM_ID_RSA_ENCRYPTION
  else if rbDSA.Checked then
    Result := SB_CERT_ALGORITHM_ID_DSA
  else
    Result := SB_CERT_ALGORITHM_DH_PUBLIC;
end;

{ TRequestGenerationThread }

constructor TRequestGenerationThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
end;

constructor TRequestGenerationThread.Create(ARequest: TElCertificateRequest; AAlg, AKeyLen, AHash: Integer);
begin
  inherited Create(True);
  FreeOnTerminate := True;
  FRequest := ARequest;
  FAlg := AAlg;
  FKeyLen := AKeyLen;
  FHash := AHash;
end;

destructor TRequestGenerationThread.Destroy;
begin
  inherited;
end;

procedure TRequestGenerationThread.Execute;
begin
  FRequest.Generate(FAlg, FKeyLen, FHash);
end;

procedure TfrmGenerateCert.pcMainChange(Sender: TObject);
begin
  lblInfo.Caption:=pcMain.ActivePage.Hint;
end;

class procedure TfrmGenerateCert.DoCreateCertificate;
var Instance : TfrmGenerateCert;
begin
  Instance:=TfrmGenerateCert.Create(nil);
  Instance.CreateCSR := False;
  Instance.ShowModal;
  Instance.Free;
end;

class procedure TfrmGenerateCert.DoCreateCSR;
var Instance : TfrmGenerateCert;
begin
  Instance:=TfrmGenerateCert.Create(nil);
  Instance.CreateCSR := True;
  Instance.ShowModal;
  Instance.Free;
end;

procedure TfrmGenerateCert.tmGenerateTimer(Sender: TObject);
begin
  pbGenerate.Position:=pbGenerate.Position + 5;
  if pbGenerate.Position >= 100 then pbGenerate.Position:=0;
  Update; Application.ProcessMessages;
end;

end.
