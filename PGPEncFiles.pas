unit PGPEncFiles;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, SBPGP, SBPGPKeys, SBUtils, SBPGPUtils,
  SBPGPStreams, SBPGPConstants,
  PassphraseRequestForm, SignaturesForm, ImgList;

type
  TEncPGPFiles = class(TForm)
    pgpReader: TElPGPReader;
    pgpWriter: TElPGPWriter;
    pgpPubKeyring: TElPGPKeyring;
    pgpSecKeyring: TElPGPKeyring;
    pHints: TPanel;
    lbStage: TLabel;
    lbStageComment: TLabel;
    PageControl: TPageControl;
    tsFileSelect: TTabSheet;
    tsProgress: TTabSheet;
    lbPrompt: TLabel;
    edFile: TEdit;
    btnBrowseFile: TButton;
    lbFileSelectComment: TLabel;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    lbProcessingFile: TLabel;
    pbProgress: TProgressBar;
    tsEncOps: TTabSheet;
    lbEncryptionAlg: TLabel;
    lbProtLevel: TLabel;
    cbEncryptionAlg: TComboBox;
    cbProtLevel: TComboBox;
    cbUseConvEnc: TCheckBox;
    cbCompress: TCheckBox;
    cbSign: TCheckBox;
    cbTextInput: TCheckBox;
    cbUseNewFeatures: TCheckBox;
    tsFinish: TTabSheet;
    cbEncrypt: TCheckBox;
    lbFinished: TLabel;
    lbErrorComment: TLabel;
    btnSignatures: TButton;
    tsKeyringSelect: TTabSheet;
    lbPubKeyring: TLabel;
    edPubKeyring: TEdit;
    btnBrowsePub: TButton;
    lbSecKeyring: TLabel;
    edSecKeyring: TEdit;
    btnBrowseSec: TButton;
    tsUserSelect: TTabSheet;
    lbPassphrase: TLabel;
    edPassphrase: TEdit;
    lbPassphraseConfirmation: TLabel;
    edPassphraseConf: TEdit;
    tsOperationSelect: TTabSheet;
    lbIWantTo: TLabel;
    rbProtect: TRadioButton;
    rbUnprotect: TRadioButton;
    pgpKeyring: TElPGPKeyring;
    DlgOpen: TOpenDialog;
    DlgSave: TSaveDialog;
    imgKeys: TImageList;
    cbHashAlgorithm: TComboBox;
    lbHashAlgorithm: TLabel;
    tvKeys: TTreeView;
    lSelectKeys: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure cbEncryptClick(Sender: TObject);
    procedure cbSignClick(Sender: TObject);
    procedure btnBrowseFileClick(Sender: TObject);
    procedure pgpWriterKeyPassphrase(Sender: TObject;
      Key: TElPGPCustomSecretKey; var Passphrase: String;
      var Cancel: Boolean);
    procedure pgpWriterProgress(Sender: TObject; Processed, Total: Int64;
      var Cancel: Boolean);
    procedure btnBrowsePubClick(Sender: TObject);
    procedure btnBrowseSecClick(Sender: TObject);
    procedure pgpReaderKeyPassphrase(Sender: TObject;
      Key: TElPGPCustomSecretKey; var Passphrase: String;
      var Cancel: Boolean);
    procedure pgpReaderPassphrase(Sender: TObject; var Passphrase: String;
      var Cancel: Boolean);
    procedure pgpReaderProgress(Sender: TObject; Processed, Total: Int64;
      var Cancel: Boolean);
    procedure pgpReaderCreateOutputStream(Sender: TObject;
      const Filename: String; TimeStamp: TDateTime; var Stream: TStream;
      var FreeOnExit: Boolean);
    procedure pgpReaderSignatures(Sender: TObject;
      Signatures: array of TElPGPSignature;
      Validities: array of TSBPGPSignatureValidity);
    procedure btnSignaturesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    State: Integer;
    Source: string;

    sigs: array of TElPGPSignature;
    vals: array of TSBPGPSignatureValidity;

    procedure Back();
    procedure Next();

    function GetPrevState(State: Integer): Integer;
    procedure ChangeState(nextState: Integer);

    procedure EnableButtons(Back, Next: Boolean);
    procedure SetCaption(const Stage, Comment: string);

    procedure KeysToList(PublicKeys: Boolean);
    function RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;

    procedure ProtectFile(const SourceFile, DestFile: string);
    procedure DecryptFile(const SourceFile: string);
  public
    { Public declarations }
  end;

var
  EncPGPFiles: TEncPGPFiles;

const
  STATE_SELECT_OPERATION		= 0;
  STATE_PROTECT_SELECT_KEYRING		= 1;
  STATE_PROTECT_SELECT_SOURCE		= 2;
  STATE_PROTECT_SELECT_OPERATION	= 3;
  STATE_PROTECT_SELECT_RECIPIENTS	= 4;
  STATE_PROTECT_SELECT_SIGNERS		= 5;
  STATE_PROTECT_SELECT_DESTINATION	= 6;
  STATE_PROTECT_PROGRESS		= 7;
  STATE_PROTECT_FINISH			= 8;
  STATE_DECRYPT_SELECT_KEYRING		= 11;
  STATE_DECRYPT_SELECT_SOURCE		= 12;
  STATE_DECRYPT_PROGRESS		= 13;
  STATE_DECRYPT_FINISH			= 14;
  STATE_FINISH				= 255;
  STATE_INVALID				= -1;

implementation

{$R *.dfm}

procedure TEncPGPFiles.btnCancelClick(Sender: TObject);
begin
  Close();
end;

procedure TEncPGPFiles.btnNextClick(Sender: TObject);
begin
  Next();
end;

procedure TEncPGPFiles.btnBackClick(Sender: TObject);
begin
  Back();
end;

procedure TEncPGPFiles.Back();
begin
  ChangeState(GetPrevState(state));
end;

procedure TEncPGPFiles.Next();
var
  i, k: Integer;
begin
  case state of
    STATE_SELECT_OPERATION:
      if (rbProtect.Checked) then
        ChangeState(STATE_PROTECT_SELECT_KEYRING)
      else
        ChangeState(STATE_DECRYPT_SELECT_KEYRING);

    STATE_PROTECT_SELECT_KEYRING,
    STATE_DECRYPT_SELECT_KEYRING:
      if (not FileExists(edPubKeyring.Text)) then
        MessageDlg('Keyring file "' + edPubKeyring.Text + '" not found', mtError, [mbOK], 0)
      else if (not FileExists(edSecKeyring.Text)) then
        MessageDlg('Keyring file "' + edSecKeyring.Text + '" not found', mtError, [mbOK], 0)
      else
      begin
        try
          pgpKeyring.Load(edPubKeyring.Text, edSecKeyring.Text, true);
        except
	  on E: Exception do
          begin
            MessageDlg('Failed to load keyring: ' + E.Message, mtError, [mbOK], 0);
            Exit;
          end;
        end;

        if (state = STATE_PROTECT_SELECT_KEYRING) then
          ChangeState(STATE_PROTECT_SELECT_SOURCE)
        else
          ChangeState(STATE_DECRYPT_SELECT_SOURCE);
      end;

    STATE_PROTECT_SELECT_SOURCE:
      if (not FileExists(edFile.Text)) then
        MessageDlg('Source file "' + edFile.Text + '" not found', mtError, [mbOK], 0)
      else
      begin
        Source := edFile.Text;
        ChangeState(STATE_PROTECT_SELECT_OPERATION);
      end;

    STATE_PROTECT_SELECT_OPERATION:
      if (not (cbEncrypt.Checked or cbSign.Checked)) then
        MessageDlg('Please select protection operation', mtError, [mbOK], 0)
      else
      begin
        if (cbEncrypt.Checked) then
          ChangeState(STATE_PROTECT_SELECT_RECIPIENTS)
        else
          ChangeState(STATE_PROTECT_SELECT_SIGNERS);
      end;

    STATE_PROTECT_SELECT_RECIPIENTS:
    begin
      k := 0;
      for i := 0 to tvKeys.Items.Count - 1 do
      begin
        SBPGPKeys.TElPGPCustomPublicKey(tvKeys.Items[i].Data).Enabled := tvKeys.Items[i].Selected;
        if tvKeys.Items[i].Selected then Inc(k);
      end;

      if ((k = 0) and (not cbUseConvEnc.Checked)) then
        MessageDlg('At least one recipient key must be selected', mtError, [mbOK], 0)
      else
      begin
        if (cbSign.Checked) then
          ChangeState(STATE_PROTECT_SELECT_SIGNERS)
        else
          ChangeState(STATE_PROTECT_SELECT_DESTINATION);
      end;
    end;

    STATE_PROTECT_SELECT_SIGNERS:
    begin
      k := 0;
      for i := 0 to tvKeys.Items.Count - 1 do
      begin
        SBPGPKeys.TElPGPCustomSecretKey(tvKeys.Items[i].Data).Enabled := tvKeys.Items[i].Selected;
        if tvKeys.Items[i].Selected then Inc(k);
      end; 

      if (k = 0) then
        MessageDlg('At least one signer''s key must be selected', mtError, [mbOK], 0)
      else
        ChangeState(STATE_PROTECT_SELECT_DESTINATION);
    end;

    STATE_PROTECT_SELECT_DESTINATION:
      ChangeState(STATE_PROTECT_PROGRESS);

    STATE_DECRYPT_SELECT_SOURCE:
      if (not FileExists(edFile.Text)) then
        MessageDlg('Source file "' + edFile.Text + '" not found', mtError, [mbOK], 0)
      else
      begin
        Source := edFile.Text;
        ChangeState(STATE_DECRYPT_PROGRESS);
      end;
  end;
end;

function TEncPGPFiles.RequestKeyPassphrase(Key: TElPGPCustomSecretKey; var Cancel: Boolean): string;
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

        lbPrompt.Caption := 'Passphrase is needed for secret key:';
        lbKeyID.Caption := UserName + ' (ID=0x' + KeyID2Str(key.KeyID(), true) + ')';
      end
      else
      begin
        lbPrompt.Caption := 'Passphrase is needed to decrypt the message';
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

procedure TEncPGPFiles.EnableButtons(Back, Next: Boolean);
begin
  btnBack.Enabled := Back;
  btnNext.Enabled := Next;
end;

procedure TEncPGPFiles.SetCaption(const Stage, Comment: string);
begin
  lbStage.Caption := Stage;
  lbStageComment.Caption := Comment;
end;

function TEncPGPFiles.GetPrevState(State: Integer): Integer;
begin
  case state of
    STATE_SELECT_OPERATION:
      Result := STATE_INVALID;

    STATE_PROTECT_SELECT_KEYRING:
      Result := STATE_SELECT_OPERATION;

    STATE_PROTECT_SELECT_SOURCE:
      Result := STATE_PROTECT_SELECT_KEYRING;

    STATE_PROTECT_SELECT_OPERATION:
      Result := STATE_PROTECT_SELECT_SOURCE;

    STATE_PROTECT_SELECT_DESTINATION:
      if (cbSign.Checked) then
        Result := STATE_PROTECT_SELECT_SIGNERS
      else
        Result := STATE_PROTECT_SELECT_RECIPIENTS;

    STATE_PROTECT_SELECT_RECIPIENTS:
      Result := STATE_PROTECT_SELECT_OPERATION;

    STATE_PROTECT_SELECT_SIGNERS:
      if (cbEncrypt.Checked) then
        Result := STATE_PROTECT_SELECT_RECIPIENTS
      else
        Result := STATE_PROTECT_SELECT_OPERATION;

    STATE_DECRYPT_SELECT_KEYRING:
      Result := STATE_SELECT_OPERATION;

    STATE_DECRYPT_SELECT_SOURCE:
      Result := STATE_DECRYPT_SELECT_KEYRING;

  else
    Result := STATE_INVALID;
  end;
end;

procedure TEncPGPFiles.ChangeState(nextState: Integer);
begin
  case nextState of
   STATE_SELECT_OPERATION:
   begin
     SetCaption('Preparatory stage', 'Choose desired operation');
     EnableButtons(false, true);
     PageControl.ActivePage := tsOperationSelect;
   end;

   STATE_PROTECT_SELECT_KEYRING:
   begin
     SetCaption('Step 1 of 6', 'Select keyring files');
     EnableButtons(true, true);
     PageControl.ActivePage := tsKeyringSelect;
   end;

   STATE_PROTECT_SELECT_SOURCE:
   begin
     SetCaption('Step 2 of 6', 'Select file to protect');
     lbFileSelectComment.Caption := '';
     EnableButtons(true, true);
     PageControl.ActivePage := tsFileSelect;
   end;

   STATE_PROTECT_SELECT_OPERATION:
   begin
     SetCaption('Step 3 of 6', 'Select protection options');
     EnableButtons(true, true);
     cbEncryptionAlg.Text := 'CAST5';
     cbProtLevel.Text := 'Low';

     if (pgpKeyring.SecretCount = 0) then
     begin
       cbSign.Checked := false;
       cbSign.Enabled := false;
     end
     else
       cbSign.Enabled := true;

     if (pgpKeyring.PublicCount = 0) then
     begin
       cbEncrypt.Checked := false;
       cbEncrypt.Enabled := false;
     end
     else
       cbEncrypt.Enabled := true;

     PageControl.ActivePage := tsEncOps;
    end;

    STATE_PROTECT_SELECT_RECIPIENTS:
    begin
      SetCaption('Step 4 of 6', 'Select recipients');
      EnableButtons(true, true);
      KeysToList(true);
      edPassphrase.Visible := cbUseConvEnc.Checked;
      edPassphraseConf.Visible := cbUseConvEnc.Checked;
      lbPassphrase.Visible := cbUseConvEnc.Checked;
      lbPassphraseConfirmation.Visible := cbUseConvEnc.Checked;
      PageControl.ActivePage := tsUserSelect;
    end;

    STATE_PROTECT_SELECT_SIGNERS:
    begin
      SetCaption('Step 4 of 6', 'Select signers');
      EnableButtons(true, true);
      KeysToList(false);
      edPassphrase.Visible := false;
      edPassphraseConf.Visible := false;
      lbPassphrase.Visible := false;
      lbPassphraseConfirmation.Visible := false;
      PageControl.ActivePage := tsUserSelect;
    end;

    STATE_PROTECT_SELECT_DESTINATION:
    begin
      SetCaption('Step 5 of 6', 'Select destination file');
      lbFileSelectComment.Caption := '';
      edFile.Text := Source + '.pgp';
      EnableButtons(true, true);
      PageControl.ActivePage := tsFileSelect;
    end;

    STATE_PROTECT_PROGRESS:
    begin
      SetCaption('Step 6 of 6', 'Protecting file');
      EnableButtons(false, false);
      pbProgress.Position := 0;
      lbProcessingFile.Visible := true;
      pbProgress.Visible := true;
      lbErrorComment.Caption := '';
      lbFinished.Caption := 'Operation successfully finished';
      PageControl.ActivePage := tsProgress;
      try
        ProtectFile(source, edFile.Text);
      except
        on E: Exception do
        begin
          lbErrorComment.Caption := E.Message;
          lbFinished.Caption := 'ERROR';
        end;
      end;

      pbProgress.Visible := false;
      lbProcessingFile.Visible := false;
      ChangeState(STATE_PROTECT_FINISH);
    end;

    STATE_PROTECT_FINISH:
    begin
      SetCaption('End of Work', 'Protection finished');
      EnableButtons(false, false);
      PageControl.ActivePage := tsFinish;
      btnSignatures.Visible := false;
      btnCancel.Caption := 'Finish';
    end;

    STATE_DECRYPT_SELECT_KEYRING:
    begin
      SetCaption('Step 1 of 3', 'Select keyring files');
      EnableButtons(true, true);
      PageControl.ActivePage := tsKeyringSelect;
    end;

    STATE_DECRYPT_SELECT_SOURCE:
    begin
      SetCaption('Step 2 of 3', 'Select PGP-protected file');
      if (pgpKeyring.SecretCount = 0) then
        lbFileSelectComment.Caption := 'Your keyring does not contain private keys. You will not be able to decrypt encrypted files.'
      else
        lbFileSelectComment.Caption := '';

      EnableButtons(true, true);
      PageControl.ActivePage := tsFileSelect;
    end;

    STATE_DECRYPT_PROGRESS:
    begin
      SetCaption('Step 3 of 3', 'Extracting protected data');
      EnableButtons(false, false);
      pbProgress.Position := 0;
      lbProcessingFile.Visible := true;
      pbProgress.Visible := true;
      lbErrorComment.Caption := '';
      lbFinished.Caption := 'Operation successfully finished';
      PageControl.ActivePage := tsProgress;
      try
        DecryptFile(source);
      except
        on E: Exception do
        begin
          lbErrorComment.Caption := E.Message;
          lbFinished.Caption := 'ERROR';
        end;
      end;

      pbProgress.Visible := false;
      lbProcessingFile.Visible := false;
      ChangeState(STATE_DECRYPT_FINISH);
    end;

    STATE_DECRYPT_FINISH:
    begin
      SetCaption('End of Work', 'Decryption finished');
      EnableButtons(false, false);
      PageControl.ActivePage := tsFinish;
      btnSignatures.Visible := true;
      btnSignatures.Enabled := ((sigs <> nil) and (Length(sigs) > 0));
      btnCancel.Caption := 'Finish';
    end;
  end;

  State := nextState;
end;

procedure TEncPGPFiles.KeysToList(PublicKeys: Boolean);
var
  i, j: Integer;
  Name, Alg, KeyStr: string;
  Item: TListItem;
  trItem, trSubItem: TTreeNode;
begin
  tvKeys.Items.Clear;
  if (PublicKeys) then
  begin
    for i := 0 to pgpKeyring.PublicCount - 1 do
    begin
      if not pgpKeyring.PublicKeys[i].IsEncryptingKey(true) then
        Continue;

      if (pgpKeyring.PublicKeys[i].UserIDCount > 0) then
        name := pgpKeyring.PublicKeys[i].UserIDs[0].Name
      else
        name := '<no name>';       
      alg := PKAlg2Str(pgpKeyring.PublicKeys[i].PublicKeyAlgorithm);
      KeyStr := name + ' (' + alg + ' ' + IntToStr(pgpKeyring.PublicKeys[i].BitsInKey) + 'bit)';

      trItem := tvKeys.Items.AddFirst(nil, KeyStr);

      if pgpKeyring.PublicKeys[i].IsEncryptingKey(false) then
      begin
        trItem.ImageIndex := 0;
        trItem.SelectedIndex := 0;
      end
      else
      begin
        trItem.ImageIndex := 1;
        trItem.SelectedIndex := 1;
      end;

      trItem.Data := pgpKeyring.PublicKeys[i];

      for j := 0 to pgpKeyring.PublicKeys[i].SubkeyCount - 1 do
      begin
        if not pgpKeyring.PublicKeys[i].Subkeys[j].IsEncryptingKey then
          Continue;

        name := 'Subkey';
        alg := PKAlg2Str(pgpKeyring.PublicKeys[i].Subkeys[j].PublicKeyAlgorithm);
        KeyStr := name + ' (' + alg + ' ' + IntToStr(pgpKeyring.PublicKeys[i].Subkeys[j].BitsInKey) + 'bit)';

        trSubItem := tvKeys.Items.AddChild(trItem, KeyStr);

        trSubItem.ImageIndex := 0;
        trSubItem.SelectedIndex := 0;
        trSubItem.Data := pgpKeyring.PublicKeys[i].Subkeys[j];
      end;
    end;
  end
  else
  begin
    for i := 0 to pgpKeyring.SecretCount - 1 do
    begin
      if not pgpKeyring.SecretKeys[i].IsSigningKey(true) then
        Continue;

      if (pgpKeyring.SecretKeys[i].PublicKey.UserIDCount > 0) then
        name := pgpKeyring.SecretKeys[i].PublicKey.UserIDs[0].Name
      else
        name := '<no name>';
      alg := PKAlg2Str(pgpKeyring.SecretKeys[i].PublicKeyAlgorithm);
      KeyStr := name + ' (' + alg + ' ' + IntToStr(pgpKeyring.SecretKeys[i].BitsInKey) + 'bit)';

      trItem := tvKeys.Items.AddFirst(nil, KeyStr);

      if pgpKeyring.SecretKeys[i].IsSigningKey(false) then
      begin
        trItem.ImageIndex := 0;
        trItem.SelectedIndex := 0;
      end
      else
      begin
        trItem.ImageIndex := 1;
        trItem.SelectedIndex := 1;
      end;

      trItem.Data := pgpKeyring.SecretKeys[i];

      for j := 0 to pgpKeyring.SecretKeys[i].SubkeyCount - 1 do
      begin
        if not pgpKeyring.SecretKeys[i].Subkeys[j].IsSigningKey then
          Continue;

        name := 'Subkey';
        alg := PKAlg2Str(pgpKeyring.SecretKeys[i].Subkeys[j].PublicKeyAlgorithm);
        KeyStr := name + ' (' + alg + ' ' + IntToStr(pgpKeyring.SecretKeys[i].Subkeys[j].BitsInKey) + 'bit)';

        trSubItem := tvKeys.Items.AddChild(trItem, KeyStr);

        trSubItem.ImageIndex := 0;
        trSubItem.SelectedIndex := 0;
        trSubItem.Data := pgpKeyring.SecretKeys[i].Subkeys[j];
      end;
    end;
  end;
end;

procedure TEncPGPFiles.ProtectFile(const SourceFile, DestFile: string);
var
  inF, outF: TFileStream;
begin
  pgpWriter.Armor := true;
  pgpWriter.ArmorHeaders.Clear();
  pgpWriter.ArmorHeaders.Add('Version: EldoS OpenPGPBlackbox');
  pgpWriter.ArmorBoundary := 'PGP MESSAGE';
  pgpWriter.Compress := cbCompress.Checked;
  pgpWriter.EncryptingKeys := pgpKeyring;
  pgpWriter.SigningKeys := pgpKeyring;
  pgpWriter.CompressionLevel := 9;
  pgpWriter.CompressionAlgorithm := SB_PGP_ALGORITHM_CM_ZLIB;

  if ((cbUseConvEnc.Checked) and (pgpPubKeyring.PublicCount > 0)) then
    pgpWriter.EncryptionType := etBoth
  else if ((cbUseConvEnc.Checked) and (pgpPubKeyring.PublicCount = 0)) then
    pgpWriter.EncryptionType := etPassphrase
  else
    pgpWriter.EncryptionType := etPublicKey;

  pgpWriter.Filename := ExtractFileName(SourceFile);
  pgpWriter.InputIsText := cbTextInput.Checked;
  pgpWriter.Passphrases.Clear();
  pgpWriter.Passphrases.Add(edPassphrase.Text);
  if cbProtLevel.Text = 'Low' then
    pgpWriter.Protection := ptLow
  else if cbProtLevel.Text = 'Normal' then
    pgpWriter.Protection := ptNormal
  else
    pgpWriter.Protection :=ptHigh;

  if cbSign.Checked then
    if cbHashAlgorithm.Text = 'MD5' then
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_MD5
    else if cbHashAlgorithm.Text = 'SHA1' then
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_SHA1
    else if cbHashAlgorithm.Text = 'RIPEMD160' then
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_RIPEMD160
    else if cbHashAlgorithm.Text = 'SHA256' then
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_SHA256
    else if cbHashAlgorithm.Text = 'SHA384' then
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_SHA384
    else
      pgpWriter.HashAlgorithm := SB_PGP_ALGORITHM_MD_SHA512;

  pgpWriter.SignBufferingMethod := sbmRewind;

  if cbEncryptionAlg.Text = 'CAST5' then
    pgpWriter.SymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_CAST5
  else if cbEncryptionAlg.Text = '3DES' then
    pgpWriter.SymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_3DES
  else if cbEncryptionAlg.Text = 'AES128' then
    pgpWriter.SymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_AES128
  else
    pgpWriter.SymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_AES256;

  pgpWriter.Timestamp := Now;
  pgpWriter.UseNewFeatures := cbUseNewFeatures.Checked;
  pgpWriter.UseOldPackets := false;

  inF := TFileStream.Create(Source, fmOpenRead);
  try
    outF := TFileStream.Create(edFile.Text, fmCreate);
    try
      if ((not cbEncrypt.Checked) and (cbSign.Checked) and (cbTextInput.Checked)) then
        pgpWriter.ClearTextSign(inF, outF, 0)
      else if ((cbEncrypt.Checked) and (cbSign.Checked)) then
        pgpWriter.EncryptAndSign(inF, outF, 0)
      else if ((cbEncrypt.Checked) and (not cbSign.Checked)) then
        pgpWriter.Encrypt(inF, outF, 0)
      else
        pgpWriter.Sign(inF, outF, false, 0);
    finally
      outF.Free;
    end;
  finally
    inF.Free;
  end;
end;

procedure TEncPGPFiles.DecryptFile(const SourceFile: string);
var
  inF: TFileStream;
begin
  pgpReader.DecryptingKeys := pgpKeyring;
  pgpReader.VerifyingKeys := pgpKeyring;

  inF := TFileStream.Create(SourceFile, fmOpenRead);
  try
    pgpReader.DecryptAndVerify(inF, 0);
  finally
    inF.Free;
  end;
end;

procedure TEncPGPFiles.cbEncryptClick(Sender: TObject);
begin
  cbCompress.Enabled := cbEncrypt.Checked;
  cbEncryptionAlg.Enabled := cbEncrypt.Checked;
  cbProtLevel.Enabled := cbEncrypt.Checked;
  cbUseConvEnc.Enabled := cbEncrypt.Checked;
  lbProtLevel.Enabled := cbEncrypt.Checked;
  lbEncryptionAlg.Enabled := cbEncrypt.Checked;
end;

procedure TEncPGPFiles.cbSignClick(Sender: TObject);
begin
  cbTextInput.Enabled := cbSign.Checked;
  cbHashAlgorithm.Enabled := cbSign.Checked;
  lbHashAlgorithm.Enabled := cbSign.Checked;
end;

procedure TEncPGPFiles.btnBrowseFileClick(Sender: TObject);
begin
  if ((state = STATE_PROTECT_SELECT_SOURCE) or
      (state = STATE_DECRYPT_SELECT_SOURCE)) then
  begin
    DlgOpen.Filter := '';
    DlgOpen.Title := 'Select file';
    if DlgOpen.Execute then
      edFile.Text := DlgOpen.FileName;
  end
  else if (state = STATE_PROTECT_SELECT_DESTINATION) then
  begin
    if DlgSave.Execute then
      edFile.Text := DlgSave.FileName;
  end;
end;

procedure TEncPGPFiles.pgpWriterKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(Key, Cancel);
end;

procedure TEncPGPFiles.pgpWriterProgress(Sender: TObject; Processed,
  Total: Int64; var Cancel: Boolean);
begin
  pbProgress.Max := Total;
  pbProgress.Position := Processed;

  Application.ProcessMessages;
end;

procedure TEncPGPFiles.btnBrowsePubClick(Sender: TObject);
begin
  DlgOpen.Filter := 'PGP Keyring Files (*.pkr, *.skr, *.pgp, *.gpg, *.asc)|*.PKR;*.SKR;*.PGP;*.GPG;*.ASC';
  DlgOpen.FilterIndex := 1;
  DlgOpen.Title := 'Select public keyring file';
  if DlgOpen.Execute then
    edPubKeyring.Text := DlgOpen.FileName;
end;

procedure TEncPGPFiles.btnBrowseSecClick(Sender: TObject);
begin
  DlgOpen.Filter := 'PGP Keyring Files (*.pkr, *.skr, *.pgp, *.gpg, *.asc)|*.PKR;*.SKR;*.PGP;*.GPG;*.ASC';
  DlgOpen.FilterIndex := 1;
  DlgOpen.Title := 'Select secret keyring file';
  if DlgOpen.Execute then
    edSecKeyring.Text := DlgOpen.FileName;
end;

procedure TEncPGPFiles.pgpReaderKeyPassphrase(Sender: TObject;
  Key: TElPGPCustomSecretKey; var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(Key, Cancel);
end;

procedure TEncPGPFiles.pgpReaderPassphrase(Sender: TObject;
  var Passphrase: String; var Cancel: Boolean);
begin
  Passphrase := RequestKeyPassphrase(nil, Cancel);
end;

procedure TEncPGPFiles.pgpReaderProgress(Sender: TObject; Processed,
  Total: Int64; var Cancel: Boolean);
begin
  pbProgress.Max := Total;
  pbProgress.Position := Processed;

  Application.ProcessMessages;
end;

procedure TEncPGPFiles.pgpReaderCreateOutputStream(Sender: TObject;
  const Filename: String; TimeStamp: TDateTime; var Stream: TStream;
  var FreeOnExit: Boolean);
begin
  dlgSave.FileName := FileName;
  if dlgSave.Execute then
    Stream := TFileStream.Create(dlgSave.FileName, fmCreate)
  else
    Stream := TMemoryStream.Create;

  FreeOnExit := True;
end;

procedure TEncPGPFiles.pgpReaderSignatures(Sender: TObject;
  Signatures: array of TElPGPSignature;
  Validities: array of TSBPGPSignatureValidity);
var
  i: Integer;
  sig: TElPGPSignature;
begin
  SetLength(sigs, Length(Signatures));
  SetLength(vals, Length(Signatures));
  for i := 0 to Length(Signatures) - 1 do
  begin
    sig := TElPGPSignature.Create();
    sig.Assign(Signatures[i]);
    sigs[i] := sig;
    vals[i] := Validities[i];
  end;
end;

procedure TEncPGPFiles.btnSignaturesClick(Sender: TObject);
begin
  with TfrmSignatures.Create(Self) do
    try
      Init(sigs, vals, pgpKeyring);
      ShowModal;
    finally
      Free;
    end;
end;

procedure TEncPGPFiles.FormCreate(Sender: TObject);
begin
  ChangeState(STATE_SELECT_OPERATION);
  cbEncryptClick(nil);
  cbSignClick(nil);
end;


procedure TEncPGPFiles.FormDestroy(Sender: TObject);
var
  I : integer;
begin
  for I := 0 to Length(Sigs) - 1 do
    Sigs[I].Free;
end;

procedure TEncPGPFiles.FormActivate(Sender: TObject);
begin
  PageControl.ActivePage := tsOperationSelect;
  ChangeState(STATE_SELECT_OPERATION);
  cbEncryptClick(nil);
  cbSignClick(nil);  
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

