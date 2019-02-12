unit SignEnc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SBPGP, SBPGPKeys, SBUtils, SBPGPUtils,
  SBPGPStreams, SBPGPConstants;

type
  TSignEnc1 = class(TForm)
    lbInputFileName: TLabel;
    editInputFile: TEdit;
    btnBrowseInputFile: TButton;
    btnBrowseKeyringFile: TButton;
    btnEncrypt: TButton;
    btnClose: TButton;
    Bevel1: TBevel;
    dlgOpenDialog: TOpenDialog;
    dlgSaveDialog: TSaveDialog;
    pgpKeyring: TElPGPKeyring;
    Label1: TLabel;
    editOutputFile: TEdit;
    btnBrowseOutFile: TButton;
    cbSecretKeySelect: TComboBox;
    pgpTempKeyring: TElPGPKeyring;
    lbSecretKeyList: TLabel;
    cbPublicKeySelect: TComboBox;
    lbPublicKeyList: TLabel;
    pgpWriter: TElPGPWriter;
    procedure btnCloseClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnBrowseKeyringFileClick(Sender: TObject);
    procedure btnBrowseOutputFileClick(Sender: TObject);
    procedure btnBrowseInputFileClick(Sender: TObject);
    procedure pgpReaderKeyPassphrase(Sender: TObject;
      Key: TElPGPCustomSecretKey; var Passphrase: String;
      var Cancel: Boolean);
    procedure pgpWriterKeyPassphrase(Sender: TObject;
      Key: TElPGPCustomSecretKey; var Passphrase: String;
      var Cancel: Boolean);
  private
    { Private declarations }
    procedure LoadKeyring;
    procedure PopulateSecretKeyList;
    procedure PopulatePublicKeyList;
    function RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;
  public
    { Public declarations }
    procedure EncryptAndSign(const strInputFilename : string; const strOutputFilename : string;
      Keyring : TElPGPKeyring);
  end;


var
  SignEnc1: TSignEnc1;

implementation

uses KeyringLoadForm, PassphraseRequestForm;

{$R *.dfm}

procedure TSignEnc1.EncryptAndSign(const strInputFilename : string; const strOutputFilename : string;
  Keyring : TElPGPKeyring);
var
  inFileStream: TFileStream;
  outFileStream: TFileStream;
begin
  // configuring ElPGPWriter properties
  pgpWriter.Armor := true;
  pgpWriter.ArmorHeaders.Clear();
  pgpWriter.ArmorHeaders.Add('Version: EldoS OpenPGPBlackbox');
  pgpWriter.ArmorBoundary := 'PGP MESSAGE';
  pgpWriter.EncryptingKeys := Keyring;
  pgpWriter.SigningKeys := Keyring;

  // encrypt with public key
  pgpWriter.EncryptionType := etPublicKey;
  pgpWriter.Filename := ExtractFileName(strInputFilename);
  pgpWriter.Timestamp := Now;
  // creating filestream for reading from input file
  inFileStream := TFileStream.Create(strInputFilename, fmOpenRead);
  try
    // create filestream for writing encrypted file
    outFileStream := TFileStream.Create(strOutputFilename, fmCreate);
    try
      // do encryption
      pgpWriter.EncryptAndSign(inFileStream, outFileStream, 0)
    finally
      outFileStream.Free;
    end;
  finally
    inFileStream.Free;
  end;
  MessageDlg('The file was encrypted and signed successfully', mtInformation, [mbOk], 0);
  Close;
end;

// allow use to select public and secret keyrings
procedure TSignEnc1.LoadKeyring;
begin
  if frmKeyringLoad.ShowModal = mrOK then
  begin
    try
      pgpKeyring.Load(frmKeyringLoad.editPubKeyring.Text,
        frmKeyringLoad.editSecKeyring.Text, true);
      PopulateSecretKeyList;
      PopulatePublicKeyList;
    except
      on E : Exception do
        MessageDlg('Failed to load keyring: ' + E.Message, mtError, [mbOk], 0);
    end;
  end;
end;


// function returns passphrase for secret key
function TSignEnc1.RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;
var
  UserName: string;
begin
  Cancel := False;
  Result := '';
  with TfrmPassphraseRequest.Create(Self) do
    try
      if (key <> nil) then
      begin
        if (key is SBPGPKeys.TElPGPSecretKey) then
        begin
          if (SBPGPKeys.TElPGPSecretKey(key).PublicKey.UserIDCount > 0) then
            UserName := SBPGPKeys.TElPGPSecretKey(key).PublicKey.UserIDs[0].Name
          else
            UserName := '<no name>';
        end
        else
          UserName := 'Subkey';

        lblPrompt.Caption := 'Passphrase is needed for secret key:';
        lbKeyID.Caption := UserName + ' (ID=0x' + KeyID2Str(key.KeyID(), true) + ')';
      end
      else
      begin
        lblPrompt.Caption := 'Passphrase is needed to decrypt the message';
        lbKeyID.Caption := '';
      end;

      if ShowModal = mrOK then
        Result := edPassphrase.Text
      else
        Cancel := True;
    finally
      Free;
    end;
end;



procedure TSignEnc1.btnCloseClick(Sender: TObject);
begin
  Close;
end;


procedure TSignEnc1.btnEncryptClick(Sender: TObject);
var
  I, J : integer;
begin
  if not FileExists(editInputFile.Text) then
    MessageDlg('Source file not found', mtError, [mbOk], 0)
    else if editOutputFile.Text = '' then
      MessageDlg('Please select output file', mtError, [mbOk], 0)
      else if pgpKeyring.SecretCount = 0 then
        MessageDlg('Your keyring does not contain private keys.' +
          'You will not be able to encrypt file.'#13#10 +
          'Please, select another keyring file.', mtError, [mbOk], 0)
        else if pgpKeyring.PublicCount = 0 then
          MessageDlg('Your keyring does not contain public keys.' +
            'You will not be able to sign file.'#13#10 +
            'Please, select another keyring file.', mtError, [mbOk], 0)
          else
          if cbPublicKeySelect.Items.Count > 0 then cbPublicKeySelect.ItemIndex:=0;
          if cbSecretKeySelect.Items.Count > 0 then cbSecretKeySelect.ItemIndex:=0;
          if cbSecretKeySelect.ItemIndex = -1 then MessageDlg('Please, select secret key',
            mtError, [mbOk], 0)
            else if cbPublicKeySelect.ItemIndex = -1 then MessageDlg('Please, select public key',
              mtError, [mbOk], 0)
  else
  begin
    pgpTempKeyring.Clear;
    I := pgpTempKeyring.AddSecretKey(TElPGPSecretKey(cbSecretKeySelect.Items.Objects[cbSecretKeySelect.ItemIndex]));
    pgpTempKeyring.SecretKeys[I].Enabled := true;

    { forcing not to use the signing key for encryption }
    pgpTempKeyring.SecretKeys[I].PublicKey.Enabled := false;
    for J := 0 to pgpTempKeyring.SecretKeys[I].PublicKey.SubkeyCount - 1 do
      pgpTempKeyring.SecretKeys[I].PublicKey.Subkeys[J].Enabled := false;
      
    I := pgpTempKeyring.AddPublicKey(TElPGPPublicKey(cbPublicKeySelect.Items.Objects[cbPublicKeySelect.ItemIndex]));
    pgpTempKeyring.PublicKeys[I].Enabled := true;
    EncryptAndSign(editInputFile.Text,editOutputFile.Text,pgpTempKeyring);
  end;
end;

procedure TSignEnc1.btnBrowseKeyringFileClick(Sender: TObject);
begin
  LoadKeyring;
end;

procedure TSignEnc1.btnBrowseInputFileClick(Sender: TObject);
begin
  dlgOpenDialog.Filter := '';
  dlgOpenDialog.Title := 'Please, select file';
  if dlgOpenDialog.Execute then
  begin
    editInputFile.Text := dlgOpenDialog.FileName;
    editOutputFile.Text := editInputFile.Text + '.pgp';
  end;
end;


procedure TSignEnc1.btnBrowseOutputFileClick(Sender: TObject);
begin
  dlgSaveDialog.Filter := '';
  dlgSaveDialog.Title := 'Please, select file';
  if dlgSaveDialog.Execute then
    editOutputFile.Text := dlgSaveDialog.FileName;
end;


procedure TSignEnc1.pgpReaderKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(Key, Cancel);
end;



// fill combobox with secret (for decryption) keys
procedure TSignEnc1.PopulateSecretKeyList;
var
  I : integer;
  function GetUserFriendlyKeyName(Key : TElPGPSecretKey): string;
  begin
    if Key.PublicKey.UserIDCount > 0 then
      Result := Key.PublicKey.UserIDs[0].Name + ' ';
    Result := Result + '[0x' + KeyID2Str(Key.KeyID, true) + ']';
  end;
begin
  cbSecretKeySelect.Clear;
  for I := 0 to pgpKeyring.SecretCount - 1 do
    cbSecretKeySelect.Items.AddObject(GetUserFriendlyKeyName(pgpKeyring.SecretKeys[I]),
      pgpKeyring.SecretKeys[I]);
end;


// fill combobox with public (fro verifying) keys
procedure TSignEnc1.PopulatePublicKeyList;
var
  I : integer;
  function GetUserFriendlyKeyName(Key : TElPGPPublicKey): string;
  begin
    if Key.UserIDCount > 0 then
      Result := Key.UserIDs[0].Name + ' ';
    Result := Result + '[0x' + KeyID2Str(Key.KeyID, true) + ']';
  end;
begin
  cbPublicKeySelect.Clear;
  for I := 0 to pgpKeyring.PublicCount - 1 do
    cbPublicKeySelect.Items.AddObject(GetUserFriendlyKeyName(pgpKeyring.PublicKeys[I]),
      pgpKeyring.PublicKeys[I]);
end;


procedure TSignEnc1.pgpWriterKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(Key,Cancel);
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
