unit decfPGP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SBPGP, SBPGPKeys, SBUtils, SBPGPUtils,
  SBPGPStreams, SBPGPConstants;

type
  TfrmMainForm = class(TForm)
    lbInputFileName: TLabel;
    editInputFile: TEdit;
    btnBrowseInputFile: TButton;
    btnBrowseKeyringFile: TButton;
    btnDecrypt: TButton;
    btnClose: TButton;
    Bevel1: TBevel;
    dlgOpenDialog: TOpenDialog;
    dlgSaveDialog: TSaveDialog;
    pgpReader: TElPGPReader;
    pgpKeyring: TElPGPKeyring;
    Label1: TLabel;
    editOutputFile: TEdit;
    btnBrowseOutFile: TButton;
    cbSecretKeySelect: TComboBox;
    pgpTempKeyring: TElPGPKeyring;
    lbSecretKeyList: TLabel;
    cbPublicKeySelect: TComboBox;
    lbPublicKeyList: TLabel;
    cbAutoKeySelect: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnDecryptClick(Sender: TObject);
    procedure btnBrowseKeyringFileClick(Sender: TObject);
    procedure btnBrowseOutputFileClick(Sender: TObject);
    procedure btnBrowseInputFileClick(Sender: TObject);
    procedure pgpReaderKeyPassphrase(Sender: TObject;
      Key: TElPGPCustomSecretKey; var Passphrase: String;
      var Cancel: Boolean);
    procedure pgpReaderSignatures(Sender: TObject;
      Signatures: array of TElPGPSignature;
      Validities: array of TSBPGPSignatureValidity);
    procedure cbAutoKeySelectClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadKeyring;
    procedure PopulateSecretKeyList;
    procedure PopulatePublicKeyList;
    function RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;
  public
    { Public declarations }
    procedure DecryptAndVerify(const strInputFilename : string; const strOutputFilename : string;
      Keyring : TElPGPKeyring);
  end;

var
  frmMainForm: TfrmMainForm;

implementation

uses KeyringLoadForm, PassphraseRequestForm, SignaturesForm;

{$R *.dfm}

function ExtractFileNameEx(FileName: string; ShowExtension: Boolean): string;
//Функция возвращает имя файла, без или с его расширением.
//ВХОДНЫЕ ПАРАМЕТРЫ
//FileName - имя файла, которое надо обработать
//ShowExtension - если TRUE, то функция возвратит короткое имя файла
// (без полного пути доступа к нему), с расширением этого файла, иначе, возвратит
// короткое имя файла, без расширения этого файла.
var
  I: Integer;
  S, S1: string;
begin
  //Определяем длину полного имени файла
  I := Length(FileName);
  //Если длина FileName <> 0, то
  if I <> 0 then
  begin
    //С конца имени параметра FileName ищем символ "\"
    while (FileName[i] <> '\') and (i > 0) do
      i := i - 1;
    // Копируем в переменную S параметр FileName начиная после последнего
    // "\", таким образом переменная S содержит имя файла с расширением, но без
    // полного пути доступа к нему
    S := Copy(FileName, i + 1, Length(FileName) - i);
    i := Length(S);
    //Если полученная S = '' то фукция возвращает ''
    if i = 0 then
    begin
      Result := '';
      Exit;
    end;
    //Иначе, получаем имя файла без расширения
    while (S[i] <> '.') and (i > 0) do
      i := i - 1;
    //... и сохраням это имя файла в переменную s1
    S1 := Copy(S, 1, i - 1);
    //если s1='' то , возвращаем s1=s
    if s1 = '' then
      s1 := s;
    //Если было передано указание функции возвращать имя файла с его
    // расширением, то Result = s,
    //если без расширения, то Result = s1
    if ShowExtension = TRUE then
      Result := s
    else
      Result := s1;
  end
    //Иначе функция возвращает ''
  else
    Result := '';
end;

procedure TfrmMainForm.DecryptAndVerify(const strInputFilename : string; const strOutputFilename : string;
  Keyring : TElPGPKeyring);
var
  inFileStream: TFileStream;
  outFileStream: TFileStream;
begin
  pgpReader.DecryptingKeys := Keyring;
  pgpReader.VerifyingKeys := Keyring;
  // create filestream for input file
  inFileStream := TFileStream.Create(strInputFilename, fmOpenRead);
  try
    // create filestream for output file
    outFileStream := TFileStream.Create(strOutputFilename, fmCreate);
    try
      pgpReader.OutputStream := outFileStream;
      // do decryption
      pgpReader.DecryptAndVerify(inFileStream, 0);
      MessageDlg('File was successfully decrypted', mtInformation, [mbOk], 0)
    finally
      outFileStream.Free;
    end;
  finally
    inFileStream.Free;
  end;
  Close;
end;

procedure TfrmMainForm.LoadKeyring;
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
function TfrmMainForm.RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;
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

procedure TfrmMainForm.btnCloseClick(Sender: TObject);
begin
  Close;
end; 

procedure TfrmMainForm.btnDecryptClick(Sender: TObject);
begin
  if cbAutoKeySelect.Checked then
  begin
    if not FileExists(editInputFile.Text) then
      MessageDlg('Source file not found', mtError, [mbOk], 0)
    else if editOutputFile.Text = '' then
      MessageDlg('Please select output file', mtError, [mbOk], 0)
    else if pgpKeyring.SecretCount = 0 then
      MessageDlg('Your keyring does not contain private keys.' +
        'You will not be able to decrypt encrypted files.'#13#10 +
        'Please, select another keyring file.', mtError, [mbOk], 0)
    else if pgpKeyring.PublicCount = 0 then
      MessageDlg('Your keyring does not contain public keys.' +
         'You will not be able to verify files.'#13#10 +
         'Please, select another keyring file.', mtError, [mbOk], 0)
    else
      DecryptAndVerify(editInputFile.Text,editOutputFile.Text,pgpKeyring);
  end
  else
  begin
    if not FileExists(editInputFile.Text) then
      MessageDlg('Source file not found', mtError, [mbOk], 0)
    else if editOutputFile.Text = '' then
      MessageDlg('Please select output file', mtError, [mbOk], 0)
    else if pgpKeyring.SecretCount = 0 then
      MessageDlg('Your keyring does not contain private keys.' +
        'You will not be able to decrypt encrypted files.'#13#10 +
        'Please, select another keyring file.', mtError, [mbOk], 0)
    else if pgpKeyring.PublicCount = 0 then
      MessageDlg('Your keyring does not contain public keys.' +
        'You will not be able to verify files.'#13#10 +
        'Please, select another keyring file.', mtError, [mbOk], 0)
    else if cbSecretKeySelect.ItemIndex = -1 then
      MessageDlg('Please select secret key', mtError, [mbOk], 0)
    else if cbPublicKeySelect.ItemIndex = -1 then
      MessageDlg('Please select public key', mtError, [mbOk], 0)
    else
    begin
      pgpTempKeyring.Clear;
      pgpTempKeyring.AddSecretKey(TElPGPSecretKey(cbSecretKeySelect.Items.Objects[cbSecretKeySelect.ItemIndex]));
      pgpTempKeyring.AddPublicKey(TElPGPPublicKey(cbPublicKeySelect.Items.Objects[cbPublicKeySelect.ItemIndex]));
      DecryptAndVerify(editInputFile.Text,editOutputFile.Text,pgpTempKeyring);
    end;
  end;
end;

procedure TfrmMainForm.btnBrowseKeyringFileClick(Sender: TObject);
begin
  LoadKeyring;
end;

procedure TfrmMainForm.btnBrowseInputFileClick(Sender: TObject);
begin
  dlgOpenDialog.Filter := '';
  dlgOpenDialog.Title := 'Please, select file';
  if dlgOpenDialog.Execute then
     editInputFile.Text := dlgOpenDialog.FileName;
     editOutputFile.Text := ExtractFilePath(dlgOpenDialog.FileName)+'\'+ExtractFileNameEx(dlgOpenDialog.FileName,False);
end;

procedure TfrmMainForm.btnBrowseOutputFileClick(Sender: TObject);
begin
  dlgSaveDialog.Filter := '';
  dlgSaveDialog.Title := 'Please, select file';
  if dlgSaveDialog.Execute then
    editOutputFile.Text := dlgSaveDialog.FileName;
end;

procedure TfrmMainForm.pgpReaderKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(Key, Cancel);
end;           

procedure TfrmMainForm.PopulateSecretKeyList;
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

procedure TfrmMainForm.PopulatePublicKeyList;
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

procedure TfrmMainForm.pgpReaderSignatures(Sender: TObject;
  Signatures: array of TElPGPSignature;
  Validities: array of TSBPGPSignatureValidity);
begin
  with TfrmSignatures.Create(Self) do
    try
      if not cbAutoKeySelect.Checked then
        Init(Signatures, Validities, pgpTempKeyring)
      else
        Init(Signatures, Validities, pgpKeyring);
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmMainForm.cbAutoKeySelectClick(Sender: TObject);
begin
  if not cbAutoKeySelect.Checked then
  begin
    lbSecretKeyList.Enabled := True;
    lbPublicKeyList.Enabled := True;
    cbSecretKeySelect.Enabled := True;
    cbPublicKeySelect.Enabled := True;
  end
  else
  begin
    lbSecretKeyList.Enabled := False;
    lbPublicKeyList.Enabled := False;
    cbSecretKeySelect.Enabled := False;
    cbPublicKeySelect.Enabled := False;
  end;
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
