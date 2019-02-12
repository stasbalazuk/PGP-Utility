unit PGPMail;

interface

{$IFDEF VER120}
  {$DEFINE D_3_UP}
  {$DEFINE D_4_UP}
  {$DEFINE VCL40}
{$ENDIF}

{$IFDEF VER125}
  {$DEFINE B_3_UP}
  {$DEFINE B_4_UP}
  {$DEFINE B_4}
  {$DEFINE VCL40}
  {$DEFINE BUILDER_USED}
{$ENDIF}

{$IFDEF VER130}
	{$IFDEF BCB}
		{$DEFINE B_3_UP}
		{$DEFINE B_4_UP}
		{$DEFINE B_5_UP}
		{$DEFINE B_5}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE BUILDER_USED}
    {$ELSE}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}

{$IFDEF VER140}
	{$IFDEF BCB}
		{$DEFINE B_3_UP}
		{$DEFINE B_4_UP}
		{$DEFINE B_5_UP}
		{$DEFINE B_6_UP}
		{$DEFINE B_6}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{$DEFINE BUILDER_USED}
    {$ELSE}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE D_6_UP}
		{$DEFINE D_6}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}


{$IFDEF VER150}
	{$IFNDEF BCB}
		{$DEFINE D_3_UP}
		{$DEFINE D_4_UP}
		{$DEFINE D_5_UP}
		{$DEFINE D_6_UP}
		{$DEFINE D_7_UP}
		{$DEFINE D_7}
		{$DEFINE VCL40}
		{$DEFINE VCL50}
		{$DEFINE VCL60}
		{$DEFINE VCL70}
		{.DEFINE USEADO}
    {$ENDIF}
{$ENDIF}

{$IFDEF VER160}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_8}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {.$DEFINE USE_NAME_SPACE} // Optional !!!
{$ENDIF}

{$IFDEF VER170}
    {$DEFINE D_3_UP}
    {$DEFINE D_4_UP}
    {$DEFINE D_5_UP}
    {$DEFINE D_6_UP}
    {$DEFINE D_7_UP}
    {$DEFINE D_8_UP}
    {$DEFINE D_9_UP}
    {$DEFINE D_9}
    {$DEFINE VCL40}
    {$DEFINE VCL50}
    {$DEFINE VCL60}
    {$DEFINE VCL70}
    {$DEFINE VCL80}
    {$DEFINE VCL90}
    {.$DEFINE USE_NAME_SPACE} // Optional !!!
{$ENDIF}

{$ifdef CLR}
	{$DEFINE DELPHI_NET}
{$endif}

uses
{$IFDEF DELPHI_NET}
  System.IO,
  System.Text,
  System.Drawing,
  Borland.VCL.Windows, Borland.VCL.Messages, Borland.VCL.SysUtils,
  Borland.VCL.Classes,
  Borland.VCL.Forms, Borland.VCL.Controls,
  Borland.VCL.Dialogs, Borland.VCL.StdCtrls, Borland.VCL.Buttons,
  Borland.VCL.ComCtrls, Borland.VCL.ExtCtrls,
  Borland.VCL.Graphics,
{$ELSE}
  Windows, Messages, SysUtils, Classes,
  Graphics, Controls, Forms, {$IFDEF D_6_UP}Variants,{$ENDIF}
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls,
{$ENDIF}
  SBRDN, SBUtils, SBCustomCertStorage, SBX509, SBX509Ext, SBConstants,
  SBMessages, SBMIME, SBSMIMECore,
  SBPGPKeys, SBPGPConstants, SBPGPUtils, SBPGPMIME;

type
  TmailPGP1 = class(TForm)
    Panel3: TPanel;
    Bevel1: TBevel;
    Panel2: TPanel;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    imgLogo: TImage;
    PageControl: TPageControl;
    tsSelectCertificates: TTabSheet;
    lbSelectCertificates: TLabel;
    lbxCertificates: TListBox;
    btnAddCertificate: TButton;
    btnRemoveCertificate: TButton;
    tsAlgorithm: TTabSheet;
    lbChooseAlgorithm: TLabel;
    rbTripleDES: TRadioButton;
    rbRC4_128: TRadioButton;
    rbRC4_40: TRadioButton;
    rbRC2: TRadioButton;
    rbAES_128: TRadioButton;
    rbAES_256: TRadioButton;
    tsSelectFiles: TTabSheet;
    lbSelectFiles: TLabel;
    lbInputFile: TLabel;
    sbInputFile: TSpeedButton;
    sbOutputFile: TSpeedButton;
    lbOutputFile: TLabel;
    edInputFile: TEdit;
    edOutputFile: TEdit;
    tsCheckData: TTabSheet;
    lbInfo: TLabel;
    mmInfo: TMemo;
    btnDoIt: TButton;
    tsSignAlgorithm: TTabSheet;
    lbChooseSignAlgorithm: TLabel;
    rbMD5: TRadioButton;
    rbSHA1: TRadioButton;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    tsSelectAction: TTabSheet;
    lbActionToPerform: TLabel;
    rbSMimeVerify: TRadioButton;
    rbSMimeDecrypt: TRadioButton;
    rbSMimeSign: TRadioButton;
    rbSMimeEncrypt: TRadioButton;
    tsResult: TTabSheet;
    lbSMime: TLabel;
    lbPGPMime: TLabel;
    rbPGPMimeEncrypt: TRadioButton;
    rbPGPMimeSign: TRadioButton;
    rbPGPMimeDecrypt: TRadioButton;
    rbPGPMimeVerify: TRadioButton;
    rbDES: TRadioButton;
    rbAES_192: TRadioButton;
    mmResult: TMemo;
    lbResult: TLabel;
    tsSelectKeys: TTabSheet;
    lbSelectKeys: TLabel;
    btnAddKey: TButton;
    btnRemoveKey: TButton;
    tsSelectKey: TTabSheet;
    lbSelectKey: TLabel;
    lbKeyring: TLabel;
    edKeyring: TEdit;
    sbKeyring: TSpeedButton;
    tvKeys: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure sbInputFileClick(Sender: TObject);
    procedure sbOutputFileClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnAddCertificateClick(Sender: TObject);
    procedure btnRemoveCertificateClick(Sender: TObject);
    procedure btnRemoveKeyClick(Sender: TObject);
    procedure sbKeyringClick(Sender: TObject);
    procedure btnAddKeyClick(Sender: TObject);
  private
    FAction: Integer;
    FCurrentPage: Integer;
    FMemoryCertStorage: TElMemoryCertStorage;
    FKeyring: TElPGPKeyring;

    FSecretRing: TElPGPKeyring;
    FPublicRing: TElPGPKeyring;
    
    procedure ClearData;

    procedure SMimeEncryptNext;
    procedure SMimeDecryptNext;
    procedure SMimeSignNext;
    procedure SMimeVerifyNext;

    function SMimeEncrypt(const InputFileName, OutputFileName: string;
                const CryptAlgorithm, CryptAlgorithmBitsInKey: Integer): string;
    function SMimeDecrypt(const InputFileName, OutputFileName: string): string;
    function SMimeSign(const InputFileName, OutputFileName: string;
                const SignAlgorithm: string): string;
    function SMimeVerify(const InputFileName: string): string;

    procedure PGPEncryptNext;
    procedure PGPDecryptNext;
    procedure PGPSignNext;
    procedure PGPVerifyNext;

    function PGPEncrypt(const InputFileName, OutputFileName: string): string;
    function PGPDecrypt(const InputFileName, OutputFileName: string): string;
    function PGPSign(const InputFileName, OutputFileName: string): string;
    function PGPVerify(const InputFileName: string): string;

    procedure PGPMIMEKeyPassphrase(Sender: TObject; Key : TElPGPCustomSecretKey;
                   var Passphrase: string; var Cancel: boolean);

    function GetAlgorithm: Integer;
    function GetAlgorithmBitsInKey: Integer;
    function GetAlgorithmName: string;
    function GetSignAlgorithm: string;

    procedure SetResults(const Res: string);

    procedure UpdateCertificatesList;
    function WriteCertificateInfo(Storage: TElCustomCertStorage): string;

    procedure UpdateKeysList;
    function WriteKeyringInfo(Keyring: TElPGPKeyring): string;
  public
    procedure SetPage(Page: Integer);
    procedure Back;
    procedure Next;

    property Action: Integer read FAction write FAction;
    property CurrentPage: Integer read FCurrentPage write FCurrentPage;
  end;

var
  mailPGP1: TmailPGP1;

const
  ACTION_UNKNOWN                = 0;
  ACTION_SMIME_ENCRYPT          = 1;
  ACTION_SMIME_SIGN             = 2;
  ACTION_SMIME_DECRYPT          = 3;
  ACTION_SMIME_VERIFY           = 4;
  ACTION_PGPMIME_ENCRYPT        = 5;
  ACTION_PGPMIME_SIGN           = 6;
  ACTION_PGPMIME_DECRYPT        = 7;
  ACTION_PGPMIME_VERIFY         = 8;

  PAGE_DEFAULT                  = 0;
  PAGE_SELECT_ACTION            = 1;
  PAGE_SELECT_FILES             = 2;
  PAGE_SELECT_CERTIFICATES      = 3;
  PAGE_SELECT_ALGORITHM         = 4;
  PAGE_SELECT_KEYS              = 5;
  PAGE_CHECK_DATA               = 6;
  PAGE_PROCESS                  = 7;

const
  cDemoVersion = '2005.04.18';
  cXMailerDemoFieldValue = 'EldoS ElMime Demos, version: ' + cDemoVersion +
    ' ( '+cXMailerDefaultFieldValue + ' )';

resourcestring
  sSelectFilesForEncryption        = 'Please select message file to encrypt and file where to write encrypted data';
  sSelectFilesForDecryption        = 'Please select input (encrypted) file and file where to write decrypted data';
  sSelectFilesForSigning           = 'Please select file to sign and file where to write signed data';
  sSelectFilesForVerifying         = 'Please select file with a signed message'{ and file where to put original message'};

  sSelectCertificatesForEncryption = 'Please choose certificates which should be used to encrypt message';
  sSelectCertificatesForDecryption = 'Please select certificates which may be used to decrypt message. Each certificate should be loaded with corresponding private key';
  sSelectCertificatesForSigning    = 'Please choose certificates which should be used to sign the file. At least one certificate must be loaded with corresponding private key';
  sSelectCertificatesForVerifying  = 'Please select certificates which may be used to verify digital signature. Note, that in most cases signer''s certificates are included in signed message, so you may leave certificate list empty';

  sSelectKeysForEncryption         = 'Please choose PGP public key which should be used to encrypt message';
  sSelectKeysForDecryption         = 'Please select PGP secret keys which may be used to decrypt message';
  sSelectKeysForSigning            = 'Please choose PGP secret key which should be used to sign the file';
  sSelectKeysForVerifying          = 'Please select PGP public keys which may be used to verify digital signature.';

  sInfoEncryption                  = 'Ready to start encryption. Please check all the parameters to be valid';
  sInfoSigning                     = 'Ready to start signing. Please check that all signing options are correct.';
  sInfoDecryption                  = 'Ready to start decryption. Please check that all decryption options are correct.';
  sInfoVerifying                   = 'Ready to start verifying. Please check that all options are correct.';

  sSelectInputFiles                = 'You must select input file';
  sSelectInputOutputFiles          = 'You must select both input and output files';

implementation

{$R *.dfm}

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

function GetPublicKeyNames(Key: TElPGPPublicKey): string;
var
  i: Integer;
begin
  Result := '';
  if not Assigned(Key) then
    Exit;

  for i := 0 to Key.UserIDCount - 1 do
    if Key.UserIDs[i].Name <> '' then
    begin
      if Result <> '' then
        Result := Result + ', ';

      Result := Result + Key.UserIDs[i].Name;
    end;
end;

procedure TmailPGP1.Back;
var
  NewPage: Integer;
begin
  if not Assigned(PageControl.ActivePage) then
  begin
    SetPage(PAGE_DEFAULT);
    Exit;
  end;

  NewPage := PAGE_DEFAULT;
  case CurrentPage of
    PAGE_SELECT_FILES: NewPage := PAGE_SELECT_ACTION;
    PAGE_SELECT_CERTIFICATES: NewPage := PAGE_SELECT_FILES;
    PAGE_SELECT_ALGORITHM: NewPage := PAGE_SELECT_CERTIFICATES;
    PAGE_SELECT_KEYS: NewPage := PAGE_SELECT_FILES;
    PAGE_CHECK_DATA:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT, ACTION_SMIME_SIGN:
          NewPage := PAGE_SELECT_ALGORITHM;

        ACTION_SMIME_DECRYPT, ACTION_SMIME_VERIFY:
          NewPage := PAGE_SELECT_CERTIFICATES;
      else
        NewPage := PAGE_SELECT_KEYS;
      end;
    end;

    PAGE_PROCESS: NewPage := PAGE_CHECK_DATA;
  end;

  SetPage(NewPage);
end;

procedure TmailPGP1.btnAddCertificateClick(Sender: TObject);
var
  F: TFileStream;
  Buf: array of Byte;
  Cert: TElX509Certificate;
  sFrom: string;
  KeyLoaded: Boolean;
  Res: Integer;
{$IFDEF DELPHI_NET}
  Sz: Integer;
{$ELSE}
  Sz: Word;
{$ENDIF}
  Index : integer;
begin
  KeyLoaded := False;
  OpenDlg.FileName := '';
  OpenDlg.Title := 'Select certificate file';
  OpenDlg.Filter := 'PEM-encoded certificate (*.pem)|*.pem|DER-encoded certificate (*.cer)|*.cer|PFX-encoded certificate (*.pfx)|*.pfx';
  if not OpenDlg.Execute then
    Exit;

  F := TFileStream.Create(OpenDlg.Filename, fmOpenRead or fmShareExclusive);
  SetLength(Buf, F.Size);
  F.Read({$IFDEF DELPHI_NET}Buf, 0{$ELSE}Buf[0]{$ENDIF}, F.Size);
  F.Free;

  Res := 0;
  Cert := TElX509Certificate.Create(nil);
  if OpenDlg.FilterIndex = 3 then
    Res := Cert.LoadFromBufferPFX({$IFDEF DELPHI_NET}Buf{$ELSE}@Buf[0], Length(Buf){$ENDIF}, InputBox('Please enter passphrase:', '',''))
  else
  if OpenDlg.FilterIndex = 1 then
    Res := Cert.LoadFromBufferPEM({$IFDEF DELPHI_NET}Buf{$ELSE}@Buf[0], Length(Buf){$ENDIF}, '')
  else
  if OpenDlg.FilterIndex = 2 then
    Cert.LoadFromBuffer({$IFDEF DELPHI_NET}Buf{$ELSE}@Buf[0], Length(Buf){$ENDIF})
  else
    Res := -1;

  if (Res <> 0) or (Cert.CertificateSize = 0) then
  begin
    Cert.Free;
    ShowMessage('Error loading the certificate');
    Exit;
  end;

  if (Action = ACTION_SMIME_DECRYPT) or (Action = ACTION_SMIME_SIGN) then
  begin
    Sz := 0;
{$IFDEF DELPHI_NET}
    SetLength(Buf, 0);
    Cert.SaveKeyToBuffer(Buf, Sz);
{$ELSE}
    Cert.SaveKeyToBuffer(nil, Sz);
{$ENDIF}

    if (Sz = 0) then
    begin
      OpenDlg.Title := 'Select the corresponding private key file';
      OpenDlg.Filter := 'PEM-encoded key (*.pem)|*.PEM|DER-encoded key (*.key)|*.key';
      if OpenDlg.Execute then
      begin
        F := TFileStream.Create(OpenDlg.Filename, fmOpenRead or fmShareExclusive);
        SetLength(Buf, F.Size);
        F.Read({$IFDEF DELPHI_NET}Buf, 0{$ELSE}Buf[0]{$ENDIF}, F.Size);
        F.Free;

        if OpenDlg.FilterIndex = 1 then
          Cert.LoadKeyFromBufferPEM({$IFDEF DELPHI_NET}Buf{$ELSE}@Buf[0], Length(Buf){$ENDIF}, InputBox('Please enter passphrase:', '',''))
        else
          Cert.LoadKeyFromBuffer({$IFDEF DELPHI_NET}Buf{$ELSE}@Buf[0], Length(Buf){$ENDIF});

        KeyLoaded := True;
      end;
    end
    else
      KeyLoaded := True;
  end;

  // certificate e-mail in UTF8
  sFrom := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_EMAIL);
  if sFrom = '' then
  begin
    Index := Cert.Extensions.SubjectAlternativename.Content.FindNameByType(gnRFC822Name);
    if Index >= 0 then
      sFrom := Cert.Extensions.SubjectAlternativeName.Content.Names[Index].RFC822Name
    else
      MessageDlg('Warning: Certificate does not contain e-mail address.', mtWarning, [mbOk], 0);
  end;

  if (Action = ACTION_SMIME_DECRYPT) and (not KeyLoaded) then
    MessageDlg('Private key was not loaded, certificate ignored', mtError, [mbOk], 0)
  else
  begin
    FMemoryCertStorage.Add(Cert);
    UpdateCertificatesList;
  end;

  Cert.Free;
end;

procedure TmailPGP1.btnAddKeyClick(Sender: TObject);
var
  TempKeyring : TElPGPKeyring;
begin
  OpenDlg.Title := 'Select input file';
  OpenDlg.Filter := 'PGP Keyring files (*.asc, *.pkr, *.skr, *.gpg, *.pgp)|*.asc;*.pkr;*.skr;*.gpg;*.pgp';
  OpenDlg.FileName := '';
  if OpenDlg.Execute then
  begin
    TempKeyring := TElPGPKeyring.Create(nil);
    try
      TempKeyring.Load(OpenDlg.Filename, '', True);
      if (Action = ACTION_PGPMIME_VERIFY) and (TempKeyring.PublicCount > 0) then
        TempKeyring.ExportTo(FKeyring);

      if (Action = ACTION_PGPMIME_DECRYPT) and (TempKeyring.SecretCount > 0) then
        TempKeyring.ExportTo(FKeyring);
    finally
      TempKeyring.Free;
    end;
    UpdateKeysList;
  end;
end;

procedure TmailPGP1.btnBackClick(Sender: TObject);
begin
  Back;
end;

procedure TmailPGP1.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TmailPGP1.btnNextClick(Sender: TObject);
begin
  Next;
end;

procedure TmailPGP1.btnRemoveCertificateClick(Sender: TObject);
begin
  if lbxCertificates.ItemIndex >= 0 then
  begin
    FMemoryCertStorage.Remove(lbxCertificates.ItemIndex);
    UpdateCertificatesList;
  end;
end;

procedure TmailPGP1.btnRemoveKeyClick(Sender: TObject);
begin
  if Assigned(tvKeys.Selected) and Assigned(tvKeys.Selected.Data) then
  begin
    if TObject(tvKeys.Selected.Data) is TElPGPPublicKey then
    begin
      if Assigned(TElPGPPublicKey(tvKeys.Selected.Data).SecretKey) then
        FKeyring.RemoveSecretkey(TElPGPPublicKey(tvKeys.Selected.Data).SecretKey)
      else
        FKeyring.RemovePublickey(TElPGPPublicKey(tvKeys.Selected.Data));
    end
    else
    if TObject(tvKeys.Selected.Data) is TElPGPSecretKey then
      FKeyring.RemoveSecretkey(TElPGPSecretKey(tvKeys.Selected.Data));

    UpdateKeysList;
  end;
end;

procedure TmailPGP1.ClearData;
begin
  edInputFile.Text := '';
  edOutputFile.Text := '';

  FMemoryCertStorage.Clear;
  lbxCertificates.Clear;

  rbTripleDES.Checked := True;
  rbSHA1.Checked := True;

  FPublicRing.Clear;
  FSecretRing.Clear;
  FKeyring.Clear;
  edKeyring.Text := '';
  tvKeys.Items.Clear;

  mmInfo.Clear;
  mmResult.Clear;
end;

procedure TmailPGP1.FormCreate(Sender: TObject);
begin
  FMemoryCertStorage := TElMemoryCertStorage.Create(nil);

  FKeyring := TElPGPKeyring.Create(nil);
  FSecretRing := TElPGPKeyring.Create(nil);
  FPublicRing := TElPGPKeyring.Create(nil);

  SetPage(PAGE_DEFAULT);
end;

procedure TmailPGP1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FPublicRing);
  FreeAndNil(FSecretRing);
  FreeAndNil(FKeyring);

  FreeAndNil(FMemoryCertStorage);
end;

function TmailPGP1.GetAlgorithm: Integer;
begin
  if rbDES.Checked then
    Result := SB_ALGORITHM_CNT_DES
  else if rbTripleDES.Checked then
    Result := SB_ALGORITHM_CNT_3DES
  else if rbRC2.Checked then
    Result := SB_ALGORITHM_CNT_RC2
  else if rbRC4_40.Checked or rbRC4_128.Checked then
    Result := SB_ALGORITHM_CNT_RC4
  else if rbAES_128.Checked then
    Result := SB_ALGORITHM_CNT_AES128
  else if rbAES_192.Checked then
    Result := SB_ALGORITHM_CNT_AES192
  else if rbAES_256.Checked then
    Result := SB_ALGORITHM_CNT_AES256
  else
    Result := SB_ALGORITHM_CNT_3DES;
end;

function TmailPGP1.GetAlgorithmBitsInKey: Integer;
begin
// this is only for SB_ALGORITHM_CNT_RC2 or SB_ALGORITHM_CNT_RC4
  if rbRC4_40.Checked then
    Result := 40
  else
    Result := 128;
end;

function TmailPGP1.GetAlgorithmName: string;
begin
  if rbDES.Checked then
    Result := rbDES.Caption
  else if rbTripleDES.Checked then
    Result := rbTripleDES.Caption
  else if rbRC2.Checked then
    Result := rbRC2.Caption
  else if rbRC4_40.Checked then
    Result := rbRC4_40.Caption
  else if rbRC4_128.Checked then
    Result := rbRC4_128.Caption
  else if rbAES_128.Checked then
    Result := rbAES_128.Caption
  else if rbAES_192.Checked then
    Result := rbAES_192.Caption
  else if rbAES_256.Checked then
    Result := rbAES_256.Caption
  else
    Result := rbTripleDES.Caption;
end;

function TmailPGP1.GetSignAlgorithm: string;
begin
  if rbMD5.Checked then
    Result := 'MD5'
  else
    Result := 'SHA1';
end;

procedure TmailPGP1.Next;
begin
  if not Assigned(PageControl.ActivePage) then
  begin
    SetPage(PAGE_DEFAULT);
    Exit;
  end;

  if (CurrentPage = PAGE_SELECT_ACTION) and
     ((rbSMimeEncrypt.Checked and (Action <> ACTION_SMIME_ENCRYPT)) or
      (rbSMimeDecrypt.Checked and (Action <> ACTION_SMIME_DECRYPT)) or
      (rbSMimeSign.Checked and (Action <> ACTION_SMIME_SIGN)) or
      (rbSMimeVerify.Checked and (Action <> ACTION_SMIME_VERIFY)) or
      (rbPGPMimeEncrypt.Checked and (Action <> ACTION_PGPMIME_ENCRYPT)) or
      (rbPGPMimeDecrypt.Checked and (Action <> ACTION_PGPMIME_DECRYPT)) or
      (rbPGPMimeSign.Checked and (Action <> ACTION_PGPMIME_SIGN)) or
      (rbPGPMimeVerify.Checked and (Action <> ACTION_PGPMIME_VERIFY)) ) then
  begin
    if rbSMimeEncrypt.Checked then
      Action := ACTION_SMIME_ENCRYPT
    else if rbSMimeDecrypt.Checked then
      Action := ACTION_SMIME_DECRYPT
    else if rbSMimeSign.Checked then
      Action := ACTION_SMIME_SIGN
    else if rbSMimeVerify.Checked then
      Action := ACTION_SMIME_VERIFY
    else if rbPGPMimeEncrypt.Checked then
      Action := ACTION_PGPMIME_ENCRYPT
    else if rbPGPMimeDecrypt.Checked then
      Action := ACTION_PGPMIME_DECRYPT
    else if rbPGPMimeSign.Checked then
      Action := ACTION_PGPMIME_SIGN
    else if rbPGPMimeVerify.Checked then
      Action := ACTION_PGPMIME_VERIFY
    else
      Action := ACTION_UNKNOWN;

    ClearData;
  end;

  case Action of
    ACTION_SMIME_ENCRYPT: SMimeEncryptNext;
    ACTION_SMIME_DECRYPT: SMimeDecryptNext;
    ACTION_SMIME_SIGN: SMimeSignNext;
    ACTION_SMIME_VERIFY: SMimeVerifyNext;
    ACTION_PGPMIME_ENCRYPT: PGPEncryptNext;
    ACTION_PGPMIME_DECRYPT: PGPDecryptNext;
    ACTION_PGPMIME_SIGN: PGPSignNext;
    ACTION_PGPMIME_VERIFY: PGPVerifyNext;
  else
    SetPage(PAGE_DEFAULT);
  end;
end;

function TmailPGP1.PGPDecrypt(const InputFileName, OutputFileName: string): string;
var
  Msg: TElMessage;
  MainPart: TElMessagePart;
  Stream: TFileStream;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);

  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, False);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
  begin
    if not Assigned(Msg.MainPart) or
       not Assigned(Msg.MainPart.MessagePartHandler) or
       Msg.MainPart.IsActivatedMessagePartHandler then
    begin
      Result := 'Mesage not encoded. No action done.';
      Stream.Free;
      Msg.Free;
      Exit;
    end;

    if Msg.MainPart.MessagePartHandler.IsError then
    begin
      Result := Msg.MainPart.MessagePartHandler.ErrorText;
      Res := EL_ERROR;
    end
    else
    begin
      if Msg.MainPart.MessagePartHandler is TElMessagePartHandlerPGPMime then
      begin
        with TElMessagePartHandlerPGPMime(Msg.MainPart.MessagePartHandler) do
        begin
          DecryptingKeys := FKeyring;
          OnKeyPassphrase := PGPMIMEKeyPassphrase;
        end;

        try
          Res := Msg.MainPart.MessagePartHandler.Decode(True);
        except
          on E: Exception do
          begin
            Result := E.Message;
            Res := EL_ERROR;
          end;
        end;

      end
      else
      begin
        Result := 'Unknown message handler.';
        Res := EL_ERROR;
      end;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  MainPart := Msg.MainPart.MessagePartHandler.DecodedPart;
  Msg.MainPart.MessagePartHandler.DecodedPart := nil;
  Msg.SetMainPart(MainPart, False);

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message decrypted and assembled OK'
  else
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.PGPDecryptNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_KEYS;
    end;

    PAGE_SELECT_KEYS:
    begin
     if FKeyring.SecretCount = 0 then
       MessageDlg('No recipient secret keys selected. Please select one.', mtError, [mbOk], 0)
     else
       NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( PGPDecrypt(edInputFile.Text, edOutputFile.Text) );
  end;
end;

function TmailPGP1.PGPEncrypt(const InputFileName, OutputFileName: string): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  PGPMime: TElMessagePartHandlerPGPMime;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, True);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  PGPMime := TElMessagePartHandlerPGPMime.Create(nil);
  Msg.MainPart.MessagePartHandler := PGPMime;

  PGPMime.EncryptingKeys := FPublicRing;
//  PGPMime.OnKeyPassphrase := PGPMIMEKeyPassphrase;
  PGPMime.Encrypt := True;

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message encrypted and assembled OK'
  else
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if Res = EL_HANDLERR_ERROR then
        Result := 'Message: "' + PGPMime.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.PGPEncryptNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_KEYS;
    end;

    PAGE_SELECT_KEYS:
    begin
     if FPublicRing.PublicCount = 0 then
       MessageDlg('No public key selected. Please select one.', mtError, [mbOk], 0)
     else
       NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( PGPEncrypt(edInputFile.Text, edOutputFile.Text) );
  end;
end;

procedure TmailPGP1.PGPMIMEKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: string; var Cancel: boolean);
{$ifdef BUILDER_USED}
var
  KeyID : TSBKeyID;
{$endif}
begin
  Passphrase := '';
  {$ifndef BUILDER_USED}
  Cancel := not InputQuery('Password request',
         'Please enter password for key ' + KeyID2Str(Key.KeyID), Passphrase);
  {$else}
  Key.GetKeyID(KeyID);
  Cancel := not InputQuery('Password request',
         'Please enter password for key ' + KeyID2Str(KeyID), Passphrase);
  {$endif}
end;

function TmailPGP1.PGPSign(const InputFileName, OutputFileName: string): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  PGPMime: TElMessagePartHandlerPGPMime;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, True);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  PGPMime := TElMessagePartHandlerPGPMime.Create(nil);
  Msg.MainPart.MessagePartHandler := PGPMime;

  PGPMime.SigningKeys := FSecretRing;
  PGPMime.OnKeyPassphrase := PGPMIMEKeyPassphrase;
  PGPMime.Sign := True;

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message signed and assembled OK'
  else
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if Res = EL_HANDLERR_ERROR then
        Result := 'Message: "' + PGPMime.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.PGPSignNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_KEYS;
    end;

    PAGE_SELECT_KEYS:
    begin
     if FSecretRing.SecretCount = 0 then
       MessageDlg('No secret key selected. Please select one.', mtError, [mbOk], 0)
     else
       NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( PGPSign(edInputFile.Text, edOutputFile.Text) );
  end;
end;

function TmailPGP1.PGPVerify(const InputFileName: string): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, False);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
  begin
    if not Assigned(Msg.MainPart) or
       not Assigned(Msg.MainPart.MessagePartHandler) or
       Msg.MainPart.IsActivatedMessagePartHandler then
    begin
      Result := 'Mesage not encoded. No action done.';
      Stream.Free;
      Msg.Free;
      Exit;
    end;

    if Msg.MainPart.MessagePartHandler.IsError then
    begin
      Result := Msg.MainPart.MessagePartHandler.ErrorText;
      Res := EL_ERROR;
    end
    else
    begin
      if Msg.MainPart.MessagePartHandler is TElMessagePartHandlerPGPMime then
      begin
        with TElMessagePartHandlerPGPMime(Msg.MainPart.MessagePartHandler) do
        begin
          VerifyingKeys := FKeyring;
//          OnKeyPassphrase := PGPMIMEKeyPassphrase;
        end;

        try
          Res := Msg.MainPart.MessagePartHandler.Decode(True);
        except
          on E: Exception do
          begin
            Result := E.Message;
            Res := EL_ERROR;
          end;
        end;
      end
      else
      begin
        Result := 'Unknown message handler.';
        Res := EL_ERROR;
      end;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
  end
  else
  begin
    if (Res = EL_WARNING) and Assigned(Msg.MainPart.MessagePartHandler) and
       (Msg.MainPart.MessagePartHandler.ErrorText <> '') then
      Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"'
    else
      Result := 'Message verified OK';
      
    if Assigned(Msg.MainPart.MessagePartHandler) and
       (Msg.MainPart.MessagePartHandler is TElMessagePartHandlerPGPMime) then
    begin
      Result := Result + #13#10#13#10'Signature verified with:'#13#10;
      Result := Result + WriteKeyringInfo(TElMessagePartHandlerPGPMime(Msg.MainPart.MessagePartHandler).VerifyingKeys);
    end;
  end;

  Msg.Free;
end;

procedure TmailPGP1.PGPVerifyNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if edInputFile.Text = '' then
        MessageDlg(sSelectInputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_KEYS;
    end;

    PAGE_SELECT_KEYS:
    begin
      NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( PGPVerify(edInputFile.Text) );
  end;
end;

procedure TmailPGP1.sbInputFileClick(Sender: TObject);
begin
  OpenDlg.Title := 'Select input file';
  OpenDlg.Filter := 'Message files (*.eml)|*.eml|All files (*.*)|*.*';
  OpenDlg.FileName := edInputFile.Text;
  if OpenDlg.Execute then
    edInputFile.Text := OpenDlg.FileName;
end;

procedure TmailPGP1.sbKeyringClick(Sender: TObject);
var
  F: TFileStream;
begin
  OpenDlg.Title := 'Select input file';
  OpenDlg.Filter := 'PGP Keyring files (*.asc, *.pkr, *.skr, *.gpg, *.pgp)|*.asc;*.pkr;*.skr;*.gpg;*.pgp';
  OpenDlg.FileName := edKeyring.Text;
  if OpenDlg.Execute then
  begin
    F := TFileStream.Create(OpenDlg.Filename, fmOpenRead);
    try
      try
        if Action = ACTION_PGPMIME_ENCRYPT then
          FPublicRing.Load(F, nil, True)
        else if Action = ACTION_PGPMIME_SIGN then
          FSecretRing.Load(F, nil, True);
      finally
        F.Free;
      end;
    except
      edKeyring.Text := '';
      Exit;
    end;

    edKeyring.Text := OpenDlg.Filename;
  end;
end;

procedure TmailPGP1.sbOutputFileClick(Sender: TObject);
begin
  SaveDlg.Title := 'Select output file';
  SaveDlg.Filter := 'Message files (*.eml)|*.eml|All files (*.*)|*.*';
  SaveDlg.FileName := edOutputFile.Text;
  if SaveDlg.Execute then
    edOutputFile.Text := SaveDlg.FileName;
end;

procedure TmailPGP1.SetPage(Page: Integer);
begin
  case Page of
    PAGE_SELECT_ACTION:
      PageControl.ActivePageIndex := tsSelectAction.PageIndex;

    PAGE_SELECT_FILES:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT, ACTION_PGPMIME_ENCRYPT:
          lbSelectFiles.Caption := sSelectFilesForEncryption;

        ACTION_SMIME_DECRYPT, ACTION_PGPMIME_DECRYPT:
          lbSelectFiles.Caption := sSelectFilesForDecryption;

        ACTION_SMIME_SIGN, ACTION_PGPMIME_SIGN:
          lbSelectFiles.Caption := sSelectFilesForSigning;

        ACTION_SMIME_VERIFY, ACTION_PGPMIME_VERIFY:
          lbSelectFiles.Caption := sSelectFilesForVerifying;
      end;

      edOutputFile.Visible := (Action <> ACTION_SMIME_VERIFY) and (Action <> ACTION_PGPMIME_VERIFY);
      lbOutputFile.Visible := edOutputFile.Visible;
      sbOutputFile.Visible := edOutputFile.Visible;
      PageControl.ActivePageIndex := tsSelectFiles.PageIndex;
    end;

    PAGE_SELECT_CERTIFICATES:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT:
          lbSelectCertificates.Caption := sSelectCertificatesForEncryption;

        ACTION_SMIME_DECRYPT:
          lbSelectCertificates.Caption := sSelectCertificatesForDecryption;

        ACTION_SMIME_SIGN:
          lbSelectCertificates.Caption := sSelectCertificatesForSigning;

        ACTION_SMIME_VERIFY:
          lbSelectCertificates.Caption := sSelectCertificatesForVerifying;
      end;

      PageControl.ActivePageIndex := tsSelectCertificates.PageIndex;
    end;

    PAGE_SELECT_ALGORITHM:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT:
          PageControl.ActivePageIndex := tsAlgorithm.PageIndex;

        ACTION_SMIME_SIGN:
          PageControl.ActivePageIndex := tsSignAlgorithm.PageIndex;
      end;
    end;

    PAGE_SELECT_KEYS:
    begin
      case Action of
        ACTION_PGPMIME_ENCRYPT:
        begin
          lbSelectKey.Caption := sSelectKeysForEncryption;
          lbKeyring.Caption := 'Public keyring:';
        end;

        ACTION_PGPMIME_DECRYPT:
          lbSelectKeys.Caption := sSelectKeysForDecryption;

        ACTION_PGPMIME_SIGN:
        begin
          lbSelectKey.Caption := sSelectKeysForSigning;
          lbKeyring.Caption := 'Secret keyring:';
        end;

        ACTION_PGPMIME_VERIFY:
          lbSelectKeys.Caption := sSelectKeysForVerifying;
      end;

      if (Action = ACTION_PGPMIME_ENCRYPT) or
         (Action = ACTION_PGPMIME_SIGN) then
        PageControl.ActivePageIndex := tsSelectKey.PageIndex
      else
        PageControl.ActivePageIndex := tsSelectKeys.PageIndex;
    end;

    PAGE_CHECK_DATA:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT, ACTION_PGPMIME_ENCRYPT:
        begin
          lbInfo.Caption := sInfoEncryption;
          btnDoIt.Caption := 'Encrypt';

          mmInfo.Clear;
          mmInfo.Lines.Add('File to encrypt: ' + edInputFile.Text);
          mmInfo.Lines.Add('');
          mmInfo.Lines.Add('File to write encrypted data: ' + edOutputFile.Text);
          mmInfo.Lines.Add('');
          if Action = ACTION_SMIME_ENCRYPT then
          begin
            mmInfo.Lines.Add('Certificates: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteCertificateInfo(FMemoryCertStorage);
            mmInfo.Lines.Add('Algorithm: ' + GetAlgorithmName());
          end
          else
          begin
            mmInfo.Lines.Add('Keys: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteKeyringInfo(FPublicRing);
          end;
        end;

        ACTION_SMIME_SIGN, ACTION_PGPMIME_SIGN:
        begin
          lbInfo.Caption := sInfoSigning;
          btnDoIt.Caption := 'Sign';

          mmInfo.Clear;
          mmInfo.Lines.Add('File to sign: ' + edInputFile.Text);
          mmInfo.Lines.Add('');
          mmInfo.Lines.Add('File to write signed data: ' + edOutputFile.Text);
          mmInfo.Lines.Add('');
          if Action = ACTION_SMIME_SIGN then
          begin
            mmInfo.Lines.Add('Certificates: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteCertificateInfo(FMemoryCertStorage);
            mmInfo.Lines.Add('Algorithm: ' + GetSignAlgorithm());
          end
          else
          begin
            mmInfo.Lines.Add('Keys: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteKeyringInfo(FSecretRing);
          end;
        end;

        ACTION_SMIME_DECRYPT, ACTION_PGPMIME_DECRYPT:
        begin
          lbInfo.Caption := sInfoDecryption;
          btnDoIt.Caption := 'Decrypt';

          mmInfo.Clear;
          mmInfo.Lines.Add('File to decrypt: ' + edInputFile.Text);
          mmInfo.Lines.Add('');
          mmInfo.Lines.Add('File to write decrypted data: ' + edOutputFile.Text);
          mmInfo.Lines.Add('');
          if Action = ACTION_SMIME_DECRYPT then
          begin
            mmInfo.Lines.Add('Certificates: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteCertificateInfo(FMemoryCertStorage);
          end
          else
          begin
            mmInfo.Lines.Add('Keys: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteKeyringInfo(FKeyring);
          end;
        end;

        ACTION_SMIME_VERIFY, ACTION_PGPMIME_VERIFY:
        begin
          lbInfo.Caption := sInfoVerifying;
          btnDoIt.Caption := 'Verify';

          mmInfo.Clear;
          mmInfo.Lines.Add('File to verify: ' + edInputFile.Text);
          mmInfo.Lines.Add('');
          if Action = ACTION_SMIME_VERIFY then
          begin
            mmInfo.Lines.Add('Certificates: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteCertificateInfo(FMemoryCertStorage);
          end
          else
          begin
            mmInfo.Lines.Add('Keys: ');
            mmInfo.Lines.Text := mmInfo.Lines.Text + WriteKeyringInfo(FKeyring);
          end;
        end;
      end;

      PageControl.ActivePageIndex := tsCheckData.PageIndex;
    end;

    PAGE_PROCESS:
    begin
      case Action of
        ACTION_SMIME_ENCRYPT, ACTION_PGPMIME_ENCRYPT:
          lbResult.Caption := 'Encryption results:';

        ACTION_SMIME_SIGN, ACTION_PGPMIME_SIGN:
          lbResult.Caption := 'Signing results:';

        ACTION_SMIME_DECRYPT, ACTION_PGPMIME_DECRYPT:
          lbResult.Caption := 'Decryption results:';

        ACTION_SMIME_VERIFY, ACTION_PGPMIME_VERIFY:
          lbResult.Caption := 'Verifying results:';
      else
        lbResult.Caption := 'Results:';
      end;

      mmResult.Text := 'Processing...';

      PageControl.ActivePageIndex := tsResult.PageIndex;
      Cursor := crHourGlass;
    end;
  else
    PageControl.ActivePageIndex := tsSelectAction.PageIndex;
    Page := PAGE_SELECT_ACTION;
  end;

  btnBack.Enabled := (Page <> PAGE_SELECT_ACTION) and (Page <> PAGE_PROCESS);
  btnNext.Enabled := (Page <> PAGE_CHECK_DATA);
  if Page = PAGE_PROCESS then
  begin
    btnNext.Caption := 'New Task';
    btnCancel.Caption := 'Finish';
  end
  else
  begin
    btnNext.Caption := 'Next >';
    btnCancel.Caption := 'Cancel';
  end;

  CurrentPage := Page;
end;

procedure TmailPGP1.SetResults(const Res: string);
begin
  Cursor := crDefault;
  if Res <> '' then
    mmResult.Text := Res
  else
    mmResult.Text := 'Finished. Unknown status.';
end;

function TmailPGP1.SMimeDecrypt(const InputFileName,
  OutputFileName: string): string;
var
  Msg: TElMessage;
  MainPart: TElMessagePart;
  Stream: TFileStream;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);

  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, False);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
  begin
    if not Assigned(Msg.MainPart) or
       not Assigned(Msg.MainPart.MessagePartHandler) or
       Msg.MainPart.IsActivatedMessagePartHandler then
    begin
      Result := 'Mesage not encoded. No action done.';
      Stream.Free;
      Msg.Free;
      Exit;
    end;

    if Msg.MainPart.MessagePartHandler.IsError then
    begin
      Result := Msg.MainPart.MessagePartHandler.ErrorText;
      Res := EL_ERROR;
    end
    else
    begin
      if Msg.MainPart.MessagePartHandler is TElMessagePartHandlerSMime then
      begin
        TElMessagePartHandlerSMime(Msg.MainPart.MessagePartHandler).CertificatesStorage := FMemoryCertStorage;

        try
          Res := Msg.MainPart.MessagePartHandler.Decode(True);
        except
          on E: Exception do
          begin
            Result := E.Message;
            Res := EL_ERROR;
          end;
        end;

      end
      else
      begin
        Result := 'Unknown message handler.';
        Res := EL_ERROR;
      end;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  MainPart := Msg.MainPart.MessagePartHandler.DecodedPart;
  Msg.MainPart.MessagePartHandler.DecodedPart := nil;
  Msg.SetMainPart(MainPart, False);

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message decrypted and assembled OK'
  else
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.SMimeDecryptNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_CERTIFICATES;
    end;

    PAGE_SELECT_CERTIFICATES:
    begin
     if FMemoryCertStorage.Count = 0 then
       MessageDlg('No recipient certificate selected. Please select one.', mtError, [mbOk], 0)
     else
       NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( SMimeDecrypt(edInputFile.Text, edOutputFile.Text) );
  end;
end;

function TmailPGP1.SMimeEncrypt(const InputFileName, OutputFileName: string;
     const CryptAlgorithm, CryptAlgorithmBitsInKey: Integer): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  SMime: TElMessagePartHandlerSMime;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, True);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  SMime := TElMessagePartHandlerSMime.Create(nil);
  SMime.EncoderCryptCertStorage := FMemoryCertStorage;
  Msg.MainPart.MessagePartHandler := SMime;

  SMime.EncoderCrypted := True;
  SMime.EncoderCryptBitsInKey := CryptAlgorithmBitsInKey;
  SMime.EncoderCryptAlgorithm := CryptAlgorithm;

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message encrypted and assembled OK'
  else
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if Res = EL_HANDLERR_ERROR then
        Result := 'Message: "' + SMime.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.SMimeEncryptNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_CERTIFICATES;
    end;

    PAGE_SELECT_CERTIFICATES:
    begin
     if FMemoryCertStorage.Count = 0 then
       MessageDlg('No recipient certificate selected. Please select one.', mtError, [mbOk], 0)
     else
       NextPage := PAGE_SELECT_ALGORITHM;
    end;

    PAGE_SELECT_ALGORITHM:
    begin
      NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( SMimeEncrypt(edInputFile.Text, edOutputFile.Text, GetAlgorithm(), GetAlgorithmBitsInKey()) );
  end;
end;

function TmailPGP1.SMimeSign(const InputFileName, OutputFileName: string;
  const SignAlgorithm: string): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  SMime: TElMessagePartHandlerSMime;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, True);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
    Msg.Free;
    Exit;
  end;

  SMime := TElMessagePartHandlerSMime.Create(nil);
  SMime.EncoderSignCertStorage := FMemoryCertStorage;
  Msg.MainPart.MessagePartHandler := SMime;

  SMime.EncoderSigned := True;
  SMime.EncoderSignOnlyClearFormat := True;
  SMime.EncoderMicalg := SignAlgorithm;

  Stream := TFileStream.Create(OutputFileName, fmCreate or fmShareExclusive);
  Stream.Size := 0;
  try
    Res := Msg.AssembleMessage(Stream,
      // Charset of message:
        'utf-8',
      // HeaderEncoding
        heBase64, //  variants:  he8bit  | heQuotedPrintable  | heBase64
      // BodyEncoding
        'base64', //  variants:   '8bit' | 'quoted-printable' |  'base64'
      // AttachEncoding
        'base64'  //  variants:   '8bit' | 'quoted-printable' |  'base64'
      );
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
    Result := 'Message signed and assembled OK'
  else
  begin
    if Result <> '' then
    begin
      Result := 'Message: "' + Result + '"';
      if Pos(IntToStr(SB_MESSAGE_ERROR_NO_CERTIFICATE), Result) > 0 then
        Result := Result + ' (at least one certificate should be loaded with corresponding sender (from email for message should be equal to certificate email field or to SubjectAlternativeName))';
    end
    else
      if Res = EL_HANDLERR_ERROR then
        Result := 'Message: "' + SMime.ErrorText + '"';

    Result := Format('Failed to assemble a message.'#13#10'ElMime error code: %d'#13#10'%s', [Res, Result]);
  end;

  Stream.Free;
  Msg.Free;
end;

procedure TmailPGP1.SMimeSignNext;
var
  i, NextPage: Integer;
  Found: Boolean;
{$IFDEF DELPHI_NET}
  Buf: array of Byte;
  Sz: Integer;
{$ELSE}
  Sz: Word;
{$ENDIF}
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if (edInputFile.Text = '') or (edOutputFile.Text = '') then
        MessageDlg(sSelectInputOutputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_CERTIFICATES;
    end;

    PAGE_SELECT_CERTIFICATES:
    begin
      Found := False;
      for i := 0 to FMemoryCertStorage.Count - 1 do
      begin
        Sz := 0;
{$IFDEF DELPHI_NET}
        SetLength(Buf, 0);
        FMemoryCertStorage.Certificates[i].SaveKeyToBuffer(Buf, Sz);
{$ELSE}
        FMemoryCertStorage.Certificates[i].SaveKeyToBuffer(nil, Sz);
{$ENDIF}
        if (Sz > 0) then
        begin
          Found := True;
          Break;
        end;
      end;

      if not Found then
        MessageDlg('At least one certificate should be loaded with corresponding private key',
            mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_ALGORITHM;
    end;

    PAGE_SELECT_ALGORITHM:
    begin
      NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( SMimeSign(edInputFile.Text, edOutputFile.Text, GetSignAlgorithm()) );
  end;
end;

function TmailPGP1.SMimeVerify(const InputFileName: string): string;
var
  Msg: TElMessage;
  Stream: TFileStream;
  Res: Integer;
begin
  Result := '';
  Msg := TElMessage.Create(cXMailerDemoFieldValue);
  Stream := TFileStream.Create(InputFileName, fmOpenRead or fmShareExclusive);
  try
    Res := Msg.ParseMessage(Stream, '', '',
{$IFDEF DELPHI_NET}
                   mpoStoreStream + mpoLoadData + mpoCalcDataSize,
{$ELSE}
                   [mpoStoreStream, mpoLoadData, mpoCalcDataSize],
{$ENDIF}
                   False, False, False);
  except
    on E: Exception do
    begin
      Result := E.Message;
      Res := EL_ERROR;
    end;
  end;

  if (Res = EL_OK) or (Res = EL_WARNING) then
  begin
    if not Assigned(Msg.MainPart) or
       not Assigned(Msg.MainPart.MessagePartHandler) or
       Msg.MainPart.IsActivatedMessagePartHandler then
    begin
      Result := 'Mesage not encoded. No action done.';
      Stream.Free;
      Msg.Free;
      Exit;
    end;

    if Msg.MainPart.MessagePartHandler.IsError then
    begin
      Result := Msg.MainPart.MessagePartHandler.ErrorText;
      Res := EL_ERROR;
    end
    else
    begin
      if Msg.MainPart.MessagePartHandler is TElMessagePartHandlerSMime then
      begin
        TElMessagePartHandlerSMime(Msg.MainPart.MessagePartHandler).CertificatesStorage := FMemoryCertStorage;

        try
          Res := Msg.MainPart.MessagePartHandler.Decode(True);
        except
          on E: Exception do
          begin
            Result := E.Message;
            Res := EL_ERROR;
          end;
        end;

        with TElMessagePartHandlerSMime(Msg.MainPart.MessagePartHandler) do
{$IFDEF DELPHI_NET}
          if Errors <> 0 then
{$ELSE}
          if Errors <> [] then
{$ENDIF}
          begin
            if Result <> '' then
              Result := Result + #13#10;

            Result := Result + 'Errors: ';
{$IFDEF DELPHI_NET}
            if (smeUnknown and Errors) <> 0 then
{$ELSE}
            if smeUnknown in Errors then
{$ENDIF}
              Result := Result + 'smeUnknown, ';

{$IFDEF DELPHI_NET}
            if (smeSignaturePartNotFound and Errors) <> 0 then
{$ELSE}
            if smeSignaturePartNotFound in Errors then
{$ENDIF}
              Result := Result + 'smeSignaturePartNotFound, ';

{$IFDEF DELPHI_NET}
            if (smeBodyPartNotFound and Errors) <> 0 then
{$ELSE}
            if smeBodyPartNotFound in Errors then
{$ENDIF}
              Result := Result + 'smeBodyPartNotFound, ';

{$IFDEF DELPHI_NET}
            if (smeInvalidSignature and Errors) <> 0 then
{$ELSE}
            if smeInvalidSignature in Errors then
{$ENDIF}
              Result := Result + 'smeInvalidSignature, ';

{$IFDEF DELPHI_NET}
            if (smeSigningCertificateMismatch and Errors) <> 0 then
{$ELSE}
            if smeSigningCertificateMismatch in Errors then
{$ENDIF}
              Result := Result + 'smeSigningCertificateMismatch, ';

{$IFDEF DELPHI_NET}
            if (smeEncryptingCertificateMismatch and Errors) <> 0 then
{$ELSE}
            if smeEncryptingCertificateMismatch in Errors then
{$ENDIF}
              Result := Result + 'smeEncryptingCertificateMismatch, ';

{$IFDEF DELPHI_NET}
            if (smeNoData and Errors) <> 0 then
{$ELSE}
            if smeNoData in Errors then
{$ENDIF}
              Result := Result + 'smeNoData, ';

            SetLength(Result, Length(Result) - 2);
          end;
      end
      else
      begin
        Result := 'Unknown message handler.';
        Res := EL_ERROR;
      end;
    end;
  end;

  Stream.Free;

  if (Res <> EL_OK) and (Res <> EL_WARNING) then
  begin
    if Result <> '' then
      Result := 'Message: "' + Result + '"'
    else
      if (Res = EL_HANDLERR_ERROR) and Assigned(Msg.MainPart.MessagePartHandler) then
        Result := 'Message: "' + Msg.MainPart.MessagePartHandler.ErrorText + '"';

    Result := Format('Error parsing mime message "%s".'#13#10'ElMime error code: %d'#13#10'%s',
                     [InputFileName, Res, Result]);
  end
  else
  begin
    Result := 'Message verified OK';
    if Assigned(Msg.MainPart.MessagePartHandler) and
       (Msg.MainPart.MessagePartHandler is TElMessagePartHandlerSMime) then
    begin
      Result := Result + #13#10#13#10'Signed with:'#13#10;
      Result := Result + WriteCertificateInfo(TElMessagePartHandlerSMime(Msg.MainPart.MessagePartHandler).DecoderSignCertStorage);
    end;
  end;

  Msg.Free;
end;

procedure TmailPGP1.SMimeVerifyNext;
var
  NextPage: Integer;
begin
  NextPage := -1;
  case CurrentPage of
    PAGE_SELECT_ACTION:
    begin
      NextPage := PAGE_SELECT_FILES;
    end;

    PAGE_SELECT_FILES:
    begin
      if edInputFile.Text = '' then
        MessageDlg(sSelectInputFiles, mtError, [mbOk], 0)
      else
        NextPage := PAGE_SELECT_CERTIFICATES;
    end;

    PAGE_SELECT_CERTIFICATES:
    begin
      NextPage := PAGE_CHECK_DATA;
    end;

    PAGE_CHECK_DATA:
    begin
      NextPage := PAGE_PROCESS;
    end;
  else
    NextPage := PAGE_DEFAULT;
  end;

  if NextPage >= 0 then
    SetPage(NextPage);

  if NextPage = PAGE_PROCESS then
  begin
    Application.ProcessMessages;
    SetResults( SMimeVerify(edInputFile.Text{, edOutputFile.Text}) );
  end;
end;

procedure TmailPGP1.UpdateCertificatesList;
var
  i: Integer;
  s: string;
begin
  lbxCertificates.Items.BeginUpdate;
  lbxCertificates.Clear;
  for i := 0 to FMemoryCertStorage.Count - 1 do
  begin
    s := GetOIDValue(FMemoryCertStorage.Certificates[i].SubjectRDN, SB_CERT_OID_COMMON_NAME);
    if s = '' then
      s := GetOIDValue(FMemoryCertStorage.Certificates[i].SubjectRDN, SB_CERT_OID_ORGANIZATION);

    if s = '' then
      s := '<unknown>';

    lbxCertificates.Items.Add(s);
  end;

  lbxCertificates.Items.EndUpdate;
end;

procedure TmailPGP1.UpdateKeysList;
var
  i: Integer;
  s: string;
  Node: TTreeNode;
  KeyID : TSBKeyID;
begin
  tvKeys.Items.BeginUpdate;
  tvKeys.Items.Clear;
  if Action = ACTION_PGPMIME_DECRYPT then
  begin
    for i := 0 to FKeyring.SecretCount - 1 do
    begin
      s := GetPublicKeyNames(FKeyring.SecretKeys[i].PublicKey);
      {$ifndef BUILDER_USED}
      KeyID := FKeyring.SecretKeys[i].KeyID;
      {$else}
      FKeyring.SecretKeys[i].GetKeyID(KeyID);
      {$endif}
      if s <> '' then
        s := s + ' (' + KeyID2Str(KeyID) + ')'
      else
        s := KeyID2Str(KeyID);

      if s = '' then
        s := '<unknown>';

      Node := tvKeys.Items.Add(nil, s);
      Node.Data := FKeyring.SecretKeys[i];
    end;
  end;

  if Action = ACTION_PGPMIME_VERIFY then
  begin
    for i := 0 to FKeyring.PublicCount - 1 do
    begin
      s := GetPublicKeyNames(FKeyring.PublicKeys[i]);
      {$ifndef BUILDER_USED}
      KeyID := FKeyring.PublicKeys[i].KeyID;
      {$else}
      FKeyring.PublicKeys[i].GetKeyID(KeyID);
      {$endif}
      if s <> '' then
        s := s + ' (' + KeyID2Str(KeyID) + ')'
      else
        s := KeyID2Str(KeyID);

      if s = '' then
        s := '<unknown>';

      Node := tvKeys.Items.Add(nil, s);
      Node.Data := FKeyring.PublicKeys[i];
    end;
  end;

  tvKeys.Items.EndUpdate;
end;

function TmailPGP1.WriteCertificateInfo(Storage: TElCustomCertStorage): string;
var
  Cert: TElX509Certificate;
  i, j: Integer;
{$IFDEF DELPHI_NET}
  Buf: array of Byte;
  Sz: Integer;
{$ELSE}
  Sz: Word;
{$ENDIF}
begin
  Result := '';
  for i := 0 to Storage.Count - 1 do
  begin
    Cert := Storage.Certificates[i];
    Result := Result + 'Certificate #' + IntToStr(i + 1) + ':'#13#10;

    Result := Result + 'Issuer:'#13#10;
    for j := 0 to Cert.IssuerRDN.Count - 1 do
      Result := Format('%s %s=%s'#13#10,
        [Result, GetStringByOID(Cert.IssuerRDN.OIDs[j]), AnsiString(Cert.IssuerRDN.Values[j])]);

    Result := Result + 'Subject:'#13#10;
    for j := 0 to Cert.SubjectRDN.Count - 1 do
      Result := Format('%s %s=%s'#13#10,
        [Result, GetStringByOID(Cert.SubjectRDN.OIDs[j]), AnsiString(Cert.SubjectRDN.Values[j])]);

    Sz := 0;
{$IFDEF DELPHI_NET}
    SetLength(Buf, 0);
    Cert.SaveKeyToBuffer(Buf, Sz);
{$ELSE}
    Cert.SaveKeyToBuffer(nil, Sz);
{$ENDIF}
    if Sz > 0 then
      Result := Result + 'Private key available'
    else
      Result := Result + 'Private key is not available';

    Result := Result + #13#10#13#10;
  end;
end;

function TmailPGP1.WriteKeyringInfo(Keyring: TElPGPKeyring): string;
var
  i, j: Integer;
  KeyID : TSBKeyID;
begin
  Result := 'Secret Keys:'#13#10;
  for i := 0 to Keyring.SecretCount - 1 do
  begin
    Result := Result + 'Key #' + IntToStr(i + 1) + ':'#13#10;
    Result := Result + ' Names: ' + GetPublicKeyNames(Keyring.SecretKeys[i].PublicKey) + #13#10;
    {$ifndef BUILDER_USED}
    KeyID := Keyring.SecretKeys[i].KeyID;
    {$else}
    Keyring.SecretKeys[i].GetKeyID(KeyID);
    {$endif}
    Result := Result + ' KeyID: ' + KeyID2Str(KeyID) + #13#10;
    Result := Result + ' KeyFP: ' + KeyFP2Str(Keyring.SecretKeys[i].KeyFP) + #13#10;

    if Keyring.SecretKeys[i].SubkeyCount > 0 then
    begin
      for j := 0 to Keyring.SecretKeys[i].SubkeyCount - 1 do
        with Keyring.SecretKeys[i].Subkeys[j] do
        begin
          Result := Result + ' KeyID: ' + KeyID2Str(KeyID) + #13#10;
          Result := Result + ' KeyFP: ' + KeyFP2Str(KeyFP) + #13#10;
        end;
    end;
  end;

  Result := Result + #13#10'Public Keys:'#13#10;
  for i := 0 to Keyring.PublicCount - 1 do
  begin
    Result := Result + 'Key #' + IntToStr(i + 1) + ':'#13#10;
    Result := Result + ' Names: ' + GetPublicKeyNames(Keyring.PublicKeys[i]) + #13#10;
    {$ifndef BUILDER_USED}
    KeyID := Keyring.PublicKeys[i].KeyID;
    {$else}
    Keyring.PublicKeys[i].GetKeyID(KeyID);
    {$endif}
    Result := Result + ' KeyID: ' + KeyID2Str(KeyID) + #13#10;
    Result := Result + ' KeyFP: ' + KeyFP2Str(Keyring.PublicKeys[i].KeyFP) + #13#10;

    if Keyring.PublicKeys[i].SubkeyCount > 0 then
    begin
      for j := 0 to Keyring.PublicKeys[i].SubkeyCount - 1 do
        with Keyring.PublicKeys[i].Subkeys[j] do
        begin
          Result := Result + ' KeyID: ' + KeyID2Str(KeyID) + #13#10;
          Result := Result + ' KeyFP: ' + KeyFP2Str(KeyFP) + #13#10;
        end;
    end;
  end;
end;


initialization
SetLicenseKey('1C05179E26E1DC76816A54C29EBE9F1A0663E6551D1F2F71DD6733FF8C768929' + 
  'F39AE53D2D4EB24898DBF0A485977CBB9CB138088738616E9A93C60C94138EF1' + 
  '98B9AC2168A0C5CF909196A921CEB11782E7EE3302BCED9047DC184A5D07E8EC' + 
  '088ED2481707BA713F921501A774CE73BD008AF926060CBF4AC88682C5608449' + 
  'B112EB6BCFB60F096E542EBB3B8254FE4680BA57B78CB18366B75841735CA947' + 
  '9FE56D68EBE65C7CA15CBF93C4B33A372C8EA9346BEF619A90A4B49BDD6988CE' + 
  '470D8D2EB6EAA600AF13346D68E4F87CABF5D7903F5BFE54601E32A0882AA7E6' + 
  'FBFA6FDBB1A6E687DA763C096F16F1E92BE46C60572830CF49267186903F484A'); 

end.
