unit encfPGP;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SBPGP, SBPGPKeys, SBUtils, SBPGPUtils,
  SBPGPStreams, SBPGPConstants;

type
  TEncF = class(TForm)
    lbInputFileName: TLabel;
    editInputFile: TEdit;
    editOutputFile: TEdit;
    lbOutputFileName: TLabel;
    btnBrowseInputFile: TButton;
    btnBrowseOutputFile: TButton;
    btnBrowseKeyringFile: TButton;
    btnEncrypt: TButton;
    btnClose: TButton;
    Bevel1: TBevel;
    dlgOpenDialog: TOpenDialog;
    pgpPubKeyring: TElPGPKeyring;
    pgpWriter: TElPGPWriter;
    lbSelectKey: TLabel;
    cbKeySelect: TComboBox;
    dlgSaveDialog: TSaveDialog;
    cbAutoKeySelect: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure btnEncryptClick(Sender: TObject);
    procedure btnBrowseKeyringFileClick(Sender: TObject);
    procedure btnBrowseInputFileClick(Sender: TObject);
    procedure btnBrowseOutputFileClick(Sender: TObject);
  private
    { Private declarations }
    procedure PopulateKeyList;
    procedure LoadKeyring;
  public
    { Public declarations }
    procedure Encrypt(const strInputFilename : string;
      const strOutputFilename : string; Key : TElPGPPublicKey);
  end;

var
  EncF: TEncF;

implementation

uses KeyringLoadForm;

{$R *.dfm}

procedure TEncF.Encrypt(const strInputFilename : string;
  const strOutputFilename : string; Key : TElPGPPublicKey);
var
  streamInput, streamOutput: TFileStream;
  EncKeyring : TElPGPKeyring;
begin
  EncKeyring := TElPGPKeyring.Create(nil);
  try
    EncKeyring.AddPublicKey(Key);
    // configuring ElPGPWriter properties
    pgpWriter.Armor := true;
    pgpWriter.ArmorHeaders.Clear();
    pgpWriter.ArmorHeaders.Add('Version: EldoS OpenPGPBlackbox');
    pgpWriter.ArmorBoundary := 'PGP MESSAGE';
    pgpWriter.EncryptingKeys := EncKeyring;
    // encrypt with public key
    pgpWriter.EncryptionType := etPublicKey;
    pgpWriter.Filename := ExtractFileName(strInputFilename);
    pgpWriter.Timestamp := Now;
    // creating filestream for reading from input file
    streamInput := TFileStream.Create(strInputFilename, fmOpenRead);
    try
      // create filestream for writing encrypted file
      streamOutput := TFileStream.Create(strOutputFilename, fmCreate);
      try
        // do encryption
        pgpWriter.Encrypt(streamInput, streamOutput, 0)
      finally
        streamOutput.Free;
      end;
    finally
      streamInput.Free;
    end;
    MessageDlg('The file was encrypted successfully', mtInformation, [mbOk], 0);
  finally
    // in any case - we have to free keyring
    EncKeyring.Free;
  end;
  Close;
end;

// put key information to the combobox
procedure TEncF.PopulateKeyList;
var
  I : integer;
  function GetUserFriendlyKeyName(Key : TElPGPPublicKey): string;
  begin
    if Key.UserIDCount > 0 then
      Result := Key.UserIDs[0].Name + ' ';
    Result := Result + '[0x' + KeyID2Str(Key.KeyID, true) + ']';
  end;
begin
  cbKeySelect.Clear;
  for I := 0 to pgpPubKeyring.PublicCount - 1 do
    cbKeySelect.Items.AddObject(GetUserFriendlyKeyName(pgpPubKeyring.PublicKeys[I]),
      pgpPubKeyring.PublicKeys[I]);
end;

procedure TEncF.LoadKeyring;
begin
  if frmKeyringLoad.ShowModal = mrOK then
  begin
    try
      pgpPubKeyring.Load(frmKeyringLoad.editPubKeyring.Text,
        frmKeyringLoad.editSecKeyring.Text, true);
      PopulateKeyList;
    except
      on E : Exception do
        MessageDlg('Failed to load keyring: ' + E.Message, mtError, [mbOk], 0);
    end;
  end;
end;

procedure TEncF.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TEncF.btnEncryptClick(Sender: TObject);
begin
  if not cbAutoKeySelect.Checked then
  begin
  if not FileExists(editInputFile.Text) then
    MessageDlg('Source file not found', mtError, [mbOk], 0)
    else if cbKeySelect.ItemIndex = -1 then
      MessageDlg('Please select a key for encryption', mtError, [mbOk], 0)
  else
    Encrypt(editInputFile.Text, editOutputFile.Text,
      TElPGPPublicKey(cbKeySelect.Items.Objects[cbKeySelect.ItemIndex]));
  end else begin
  if cbKeySelect.Items.Count > 0 then
     cbKeySelect.ItemIndex:=0;
  if not FileExists(editInputFile.Text) then
    MessageDlg('Source file not found', mtError, [mbOk], 0)
    else if cbKeySelect.ItemIndex = -1 then
      MessageDlg('Please select a key for encryption', mtError, [mbOk], 0)
  else begin
     Encrypt(editInputFile.Text, editOutputFile.Text,
     TElPGPPublicKey(cbKeySelect.Items.Objects[cbKeySelect.ItemIndex]));
  end;
  end;
end;

procedure TEncF.btnBrowseKeyringFileClick(Sender: TObject);
begin
  LoadKeyring;
end;

procedure TEncF.btnBrowseInputFileClick(Sender: TObject);
begin
  dlgOpenDialog.Filter := '';
  dlgOpenDialog.Title := 'Select file';
  if dlgOpenDialog.Execute then
  begin
    editInputFile.Text := dlgOpenDialog.FileName;
    editOutputFile.Text := editInputFile.Text + '.pgp';
  end;
end;

procedure TEncF.btnBrowseOutputFileClick(Sender: TObject);
begin
  dlgSaveDialog.Filter := '';
  dlgSaveDialog.Title := 'Select file';
  if dlgSaveDialog.Execute then
    editOutputFile.Text := dlgSaveDialog.FileName;
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
