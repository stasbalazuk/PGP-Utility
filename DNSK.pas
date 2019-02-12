unit DNSK;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Clipbrd, SBUtils, SBDomainKeys, SBRSA, SBPEM, XPMan;

type
  TDNSKeys1 = class(TForm)
    lblGranularity: TLabel;
    lblNotes: TLabel;
    lblPublicKeySize: TLabel;
    edtGranularity: TEdit;
    edtNotes: TEdit;
    trkPublicKeySize: TTrackBar;
    btnGenerate: TButton;
    bvlSeparator: TBevel;
    lblDNSRecord: TLabel;
    edtDNSRecord: TEdit;
    cbxTestMode: TCheckBox;
    btnRevoke: TButton;
    lblPrivateKey: TLabel;
    memPrivateKey: TMemo;
    btnCopyDNSRecord: TButton;
    btnSavePrivateKey: TButton;
    btnCopyPrivateKey: TButton;
    dlgSavePrivateKey: TSaveDialog;
    procedure btnRevokeClick(Sender: TObject);
    procedure btnCopyDNSRecordClick(Sender: TObject);
    procedure btnCopyPrivateKeyClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure btnSavePrivateKeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DNSKeys1: TDNSKeys1;

implementation

{$R *.dfm}

procedure TDNSKeys1.btnGenerateClick(Sender: TObject);
var
  DNS: TElDKDNSRecord;
  Result, KeySize: Integer;
  S: string;
  PrivateKey: Pointer;
  PrivateKeySize: Integer;
begin
  DNS := TElDKDNSRecord.Create;
  Screen.Cursor := crHourGlass;
  Enabled := False;
  try
    DNS.KeyGranularity := edtGranularity.Text;
    DNS.Notes := edtNotes.Text;
    DNS.TestMode := cbxTestMode.Checked;  // set Test Mode flag in DNS
    DNS.CreatePublicKey(dkRSA);           // RSA key type is the only type is supported by now
    // generate public and private keys
    KeySize := (trkPublicKeySize.Position + 1) * 256;
    // estimate the size of buffer needed to store private key
    PrivateKeySize := 0;
    TElDKRSAPublicKey(DNS.PublicKey).Generate(KeySize, nil, PrivateKeySize);
    GetMem(PrivateKey, PrivateKeySize);
    try
      if not TElDKRSAPublicKey(DNS.PublicKey).Generate(KeySize, PrivateKey, PrivateKeySize) then
      begin
        MessageDlg('Failed to generate public and private keys', mtError, [mbOk], 0);
        Exit;
      end;
      // clear controls
      edtDNSRecord.Text := '';
      memPrivateKey.Lines.Clear;
      // generate DNS record
      Result := DNS.Save(S);
      if Result = SB_DK_DNS_ERROR_SUCCESS then
        edtDNSRecord.Text := S
      else
        MessageDlg('Failed to generate a DNS record', mtError, [mbOk], 0);
      // convert the private key to PEM format
      KeySize := 0;
      SBPEM.Encode(PrivateKey, PrivateKeySize, nil, KeySize, 'RSA PRIVATE KEY', False, '');
      if KeySize = 0 then
        MessageDlg('Failed to convert the private key', mtError, [mbOk], 0);
      SetLength(S, KeySize);
      if not SBPEM.Encode(PrivateKey, PrivateKeySize, @S[1], KeySize, 'RSA PRIVATE KEY', False, '') then
        MessageDlg('Failed to convert the private key', mtError, [mbOk], 0);
      SetLength(S, KeySize);
      memPrivateKey.Lines.Text := S;
    finally
      FreeMem(PrivateKey);
    end;
  finally
    Enabled := True;
    Screen.Cursor := crDefault;
    DNS.Free;
  end;
end;

procedure TDNSKeys1.btnRevokeClick(Sender: TObject);
var
  DNS: TElDKDNSRecord;
  Result: Integer;
  S: string;
begin
  DNS := TElDKDNSRecord.Create;
  try
    DNS.KeyGranularity := edtGranularity.Text;
    DNS.Notes := edtNotes.Text;
    DNS.TestMode := cbxTestMode.Checked;  // set Test Mode flag in DNS
    DNS.CreatePublicKey(dkRSA);           // RSA key type is the only type is supported by now
    DNS.PublicKey.Revoke;                 // set Revoked flag in DNS
    // clear controls
    edtDNSRecord.Text := '';
    memPrivateKey.Lines.Clear;
    // generate DNS record
    Result := DNS.Save(S);
    if Result = SB_DK_DNS_ERROR_SUCCESS then
      edtDNSRecord.Text := S
    else
      MessageDlg('Failed to generate a DNS record', mtError, [mbOk], 0);
  finally
    DNS.Free;
  end;
end;

procedure TDNSKeys1.btnCopyDNSRecordClick(Sender: TObject);
begin
  if edtDNSRecord.Text <> '' then
    Clipboard.AsText := edtDNSRecord.Text;
end;

procedure TDNSKeys1.btnCopyPrivateKeyClick(Sender: TObject);
begin
  if memPrivateKey.Lines.Count > 0 then
    Clipboard.AsText := memPrivateKey.Lines.Text;
end;

procedure TDNSKeys1.btnSavePrivateKeyClick(Sender: TObject);
begin
  if dlgSavePrivateKey.Execute then
    memPrivateKey.Lines.SaveToFile(dlgSavePrivateKey.FileName);
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
