unit keysgen;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, ToolWin, Menus, SBPGPKeys, SBPGPUtils,
  SBUtils, SBPGPConstants, ImgList, ExtCtrls, StdCtrls,
  PassphraseRequestForm, AboutForm, ImportKeyForm;

type
  TfrmKeys = class(TForm)
    mnuMain: TMainMenu;
    mniFile: TMenuItem;
    sbrMain: TStatusBar;
    tvKeyring: TTreeView;
    aclMain: TActionList;
    actOpenKeyring: TAction;
    pgpKeyring: TElPGPKeyring;
    mniOpenKeyring: TMenuItem;
    actSaveKeyring: TAction;
    actNewKeyring: TAction;
    mniNewKeyring: TMenuItem;
    mniSaveKeyring: TMenuItem;
    N1: TMenuItem;
    mniExit: TMenuItem;
    actExit: TAction;
    actRemoveKey: TAction;
    actSign: TAction;
    mnuKeys: TPopupMenu;
    NewKey2: TMenuItem;
    N3: TMenuItem;
    Sign2: TMenuItem;
    DeleteKey2: TMenuItem;
    imgToolbar: TImageList;
    pInfo: TPanel;
    imgTreeView: TImageList;
    pKeyInfo: TPanel;
    lbKeyAlgorithm: TLabel;
    lbKeyID: TLabel;
    lbKeyFP: TLabel;
    lbTimeStamp: TLabel;
    lbExpires: TLabel;
    lbTrust: TLabel;
    pSigInfo: TPanel;
    lbSigType: TLabel;
    lbSigner: TLabel;
    lbSigCreated: TLabel;
    lbValidity: TLabel;
    pUserInfo: TPanel;
    lbUserName: TLabel;
    picUser: TImage;
    actGenerateKey: TAction;
    actAddKey: TAction;
    OpenDlg: TOpenDialog;
    actExportKey: TAction;
    SaveDlg: TSaveDialog;
    actRevoke: TAction;
    actAbout: TAction;
    Revoke1: TMenuItem;
    Generatekey1: TMenuItem;
    Importkey1: TMenuItem;
    RemoveKey1: TMenuItem;
    ExportKey1: TMenuItem;
    Sign1: TMenuItem;
    Revoke2: TMenuItem;
    procedure actOpenKeyringExecute(Sender: TObject);
    procedure actSaveKeyringExecute(Sender: TObject);
    procedure actNewKeyringExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure actRemoveKeyExecute(Sender: TObject);
    procedure actRemoveKeyUpdate(Sender: TObject);
    procedure actSignUpdate(Sender: TObject);
    procedure actSignExecute(Sender: TObject);
    procedure tvKeyringChange(Sender: TObject; Node: TTreeNode);
    procedure actGenerateKeyExecute(Sender: TObject);
    procedure actAddKeyExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actExportKeyExecute(Sender: TObject);
    procedure actRevokeExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure Generatekey1Click(Sender: TObject);
    procedure Importkey1Click(Sender: TObject);
    procedure RemoveKey1Click(Sender: TObject);
    procedure ExportKey1Click(Sender: TObject);
    procedure Sign1Click(Sender: TObject);
    procedure Revoke2Click(Sender: TObject);
  private
    FPubKeyringFileName: string;
    FSecKeyringFileName: string;

    function SignUser(user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey; signingKey: TElPGPSecretKey): TElPGPSignature;
    function RevokeUser(user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey; signingKey: TElPGPSecretKey): TElPGPSignature;

    function RequestPassphrase(Key: TElPGPPublicKey): string;

    procedure SetStatus(s: string);

    procedure DrawPublicKeyProps(key: TElPGPCustomPublicKey);
    procedure DrawUserIDProps(user: TElPGPUserID);
    procedure DrawUserAttrProps(user: TElPGPUserAttr);
    procedure DrawSignatureProps(sig: TElPGPSignature; user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey); overload;
    procedure DrawSignatureProps(sig: TElPGPSignature; subkey: TElPGPPublicSubkey; userKey: TElPGPCustomPublicKey); overload;

    procedure HideAllInfoPanels();
    procedure EnableView(p: TPanel);
  public
    property PubKeyringFileName: string read FPubKeyringFileName write FPubKeyringFileName;
    property SecKeyringFileName: string read FSecKeyringFileName write FSecKeyringFileName;
  end;

var
  frmKeys: TfrmKeys;

implementation

uses
  Keyring, Wizard, Keys;

{$R *.dfm}

function KeyIDToString(const KeyID: TSBKeyID): String;
begin
  Result := Format('0x%.2X%.2X%.2X%.2X', [KeyID[4], KeyID[5],
    KeyID[6], KeyID[7]]);
end;

function PubKeyAlgToString(Alg: Integer): String;
begin
  case Alg of
    SB_PGP_ALGORITHM_PK_RSA: Result := 'RSA';
    SB_PGP_ALGORITHM_PK_RSA_ENCRYPT: Result := 'RSA';
    SB_PGP_ALGORITHM_PK_RSA_SIGN: Result := 'RSA';
    SB_PGP_ALGORITHM_PK_ELGAMAL_ENCRYPT: Result := 'ElGamal';
    SB_PGP_ALGORITHM_PK_DSA: Result := 'DSS';
    SB_PGP_ALGORITHM_PK_ELGAMAL: Result := 'ElGamal';
  else
    Result := 'Unknown';
  end;
end;

function GetDefaultUserID(Key: TElPGPPublicKey): string;
begin
  if (Key.UserIDCount > 0) then
    Result := Key.UserIDs[0].Name
  else
    Result := 'No name';
end;

procedure RedrawKeyring(tv: TTreeView; Keyring: TElPGPKeyring);
var
  i, j, k: Integer;
  KeyNode, UserNode, SubKeyNode, SigNode: TTreeNode;
begin
  tv.Items.BeginUpdate();

  try
  tv.Items.Clear();
  for i := 0 to Keyring.PublicCount - 1 do
  begin
    // Creating key node
    KeyNode := tv.Items.Add(nil, GetDefaultUserID(keyring.PublicKeys[i]));
    KeyNode.Data := Keyring.PublicKeys[i];
    if ((Keyring.PublicKeys[i].PublicKeyAlgorithm = SB_PGP_ALGORITHM_PK_RSA) or
        (Keyring.PublicKeys[i].PublicKeyAlgorithm = SB_PGP_ALGORITHM_PK_RSA_ENCRYPT) or
        (Keyring.PublicKeys[i].PublicKeyAlgorithm = SB_PGP_ALGORITHM_PK_RSA_SIGN)) then
      KeyNode.ImageIndex := 1
    else
      KeyNode.ImageIndex := 0;

    KeyNode.SelectedIndex := KeyNode.ImageIndex;
    if (Keyring.PublicKeys[i].SecretKey <> nil) then
    begin
      // KeyNode.NodeFont = new Font(this.Font, FontStyle.Bold);
    end;

    if (Keyring.PublicKeys[i].Revoked) then
    begin
      // KeyNode.NodeFont = new Font(tv.Font, FontStyle.Italic);
    end;

    // Creating user nodes
    for j := 0 to Keyring.PublicKeys[i].UserIDCount - 1 do
    begin
      UserNode := tv.Items.AddChild(KeyNode, Keyring.PublicKeys[i].UserIDs[j].Name);
      UserNode.Data := Keyring.PublicKeys[i].UserIDs[j];
      UserNode.ImageIndex := 2;
      UserNode.SelectedIndex := 2;

      // Creating signature nodes
      for k := 0 to Keyring.PublicKeys[i].UserIDs[j].SignatureCount - 1 do
      begin
        if (Keyring.PublicKeys[i].UserIDs[j].Signatures[k].IsUserRevocation()) then
        begin
          SigNode := tv.Items.AddChild(UserNode, 'Revocation');
//          UserNode.NodeFont = new Font(tv.Font, FontStyle.Italic);
        end
        else
        begin
          SigNode := tv.Items.AddChild(UserNode, 'Signature');
          SigNode.ImageIndex := 3;
          SigNode.SelectedIndex := 3;
	end;

        SigNode.Data := Keyring.PublicKeys[i].UserIDs[j].Signatures[k];
      end;
    end;

    for j := 0 to Keyring.PublicKeys[i].UserAttrCount - 1 do
    begin
      UserNode := tv.Items.AddChild(KeyNode, 'Photo');
      UserNode.Data := Keyring.PublicKeys[i].UserAttrs[j];

      // Creating signature nodes
      for k := 0 to Keyring.PublicKeys[i].UserAttrs[j].SignatureCount - 1 do
      begin
        if (Keyring.PublicKeys[i].UserAttrs[j].Signatures[k].IsUserRevocation()) then
	begin
          SigNode := tv.Items.AddChild(UserNode, 'Revocation');
//          UserNode.NodeFont = new Font(tv.Font, FontStyle.Italic);
        end
        else
        begin
          SigNode := tv.Items.AddChild(UserNode, 'Signature');
          SigNode.ImageIndex := 3;
          SigNode.SelectedIndex := 3;
        end;

        SigNode.Data := Keyring.PublicKeys[i].UserAttrs[j].Signatures[k];
      end;
    end;

    // Subkeys
    for j := 0 to Keyring.PublicKeys[i].SubkeyCount - 1 do
    begin
      SubKeyNode := tv.Items.AddChild(KeyNode, PKAlg2Str(Keyring.PublicKeys[i].Subkeys[j].PublicKeyAlgorithm) + ' subkey');
      SubKeyNode.Data := Keyring.PublicKeys[i].Subkeys[j];

      // Creating signature nodes
      for k := 0 to Keyring.PublicKeys[i].Subkeys[j].SignatureCount - 1 do
      begin
        if (keyring.PublicKeys[i].Subkeys[j].Signatures[k].IsSubkeyRevocation()) then
        begin
          SigNode := tv.Items.AddChild(SubKeyNode, 'Revocation');
//          SubKeyNode.NodeFont = new Font(tv.Font, FontStyle.Italic);
        end
        else
        begin
          SigNode := tv.Items.AddChild(SubKeyNode, 'Signature');
          SigNode.ImageIndex := 3;
          SigNode.SelectedIndex := 3;
        end;

        SigNode.Data := Keyring.PublicKeys[i].Subkeys[j].Signatures[k];
      end;
    end;
  end

  finally
    tv.Items.EndUpdate();
  end;
end;

procedure TfrmKeys.actNewKeyringExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to create a new keyring?'#13#10'All unsaved information will be LOST!',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    PubKeyringFileName := '';
    SecKeyringFileName := '';
    tvKeyring.Items.Clear();
    pgpKeyring.Clear();
    HideAllInfoPanels();
    RedrawKeyring(tvKeyring, pgpKeyring);
    SetStatus('New keyring created');
    Application.ProcessMessages;
  end;
end;

procedure TfrmKeys.actOpenKeyringExecute(Sender: TObject);
var
  tempKeyring: TElPGPKeyring;
begin
  tempKeyring := TElPGPKeyring.Create(nil);

  with TfrmSelectKeyring.Create(Self) do
    try
      OpenKeyring := True;
      Caption := 'Load keyring';
      if ShowModal = mrOK then
      begin
        try
          tempKeyring.Load(edtPub.Text, edtSec.Text, True);
        except
          on E: Exception do
          begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
            SetStatus('Failed to load keyring');
            Exit;
          end;
        end;

	HideAllInfoPanels();
        FPubKeyringFileName := edtPub.Text;
        FSecKeyringFileName := edtSec.Text;
        pgpKeyring.Clear();
        tempKeyring.ExportTo(pgpKeyring);
        RedrawKeyring(tvKeyring, pgpKeyring);
        SetStatus('Keyring loaded');
      end;

    finally
      tempKeyring.Free;
      Free;
    end;
end;

procedure TfrmKeys.actSaveKeyringExecute(Sender: TObject);
begin
  with TfrmSelectKeyring.Create(Self) do
    try
      OpenKeyring := False;
      Caption := 'Save keyring';
      edtPub.Text := PubKeyringFileName;
      edtSec.Text := SecKeyringFileName;
      if (ShowModal = mrOK) then
        try
          pgpKeyring.Save(edtPub.Text, edtSec.Text, false);
          SetStatus('Keyring saved');
        except
          on E: Exception do
     	  begin
            MessageDlg(E.Message, mtError, [mbOK], 0);
            SetStatus('Failed to save keyring');
	  end;
        end;
    finally
      Free;
    end;
end;

procedure TfrmKeys.actExitExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmKeys.actGenerateKeyExecute(Sender: TObject);
begin
  with TfrmWizard.Create(Self) do
    try
      if ShowModal = mrOK then
      begin
        pgpKeyring.AddSecretKey(FSecKey);
//        pgpKeyring.AddPublicKey(FSecKey.PublicKey);
        RedrawKeyring(tvKeyring, pgpKeyring);
        SetStatus('New key was added to keyring');
      end;
    finally
      Free;
    end;
end;

procedure TfrmKeys.actAddKeyExecute(Sender: TObject);
var
  tempKeyring: TElPGPKeyring;
begin
  tempKeyring := TElPGPKeyring.Create(nil);
  if OpenDlg.Execute then
  begin
    try
      tempKeyring.Load(OpenDlg.Filename, '', True);
    except
      on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        SetStatus('Failed to import key');
        FreeAndNil(tempKeyring);
      end;
    end;

    with TfrmImportKey.Create(Self) do
      try
        tvKeys.Images := imgTreeView;
        RedrawKeyring(tvKeys, tempKeyring);
        if (ShowModal = mrOK) then
        begin
          tempKeyring.ExportTo(pgpKeyring);
          RedrawKeyring(tvKeyring, pgpKeyring);
        end;
      finally
        Free;
      end;
  end;

  SetStatus(IntToStr(tempKeyring.PublicCount) + ' key(s) successfully imported');
  tempKeyring.Free;
end;

procedure TfrmKeys.actRemoveKeyUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tvKeyring.Selected <> nil) and
    (tvKeyring.Selected.Level = 0);
end;

procedure TfrmKeys.actRemoveKeyExecute(Sender: TObject);
var
  Key: TElPGPPublicKey;
begin
  if ((tvKeyring.Selected <> nil) and (TObject(tvKeyring.Selected.Data) is TElPGPPublicKey)) then
  begin
    Key := TElPGPPublicKey(tvKeyring.Selected.Data);
    if (MessageDlg('Are you sure you want to remove the key (' + GetDefaultUserID(key) + ')?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      if (key.SecretKey <> nil) then
      begin
        if (MessageDlg('The key you want to remove is SECRET! Are you still sure?',
                  mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
          Exit;
      end;

      pgpKeyring.RemovePublicKey(Key, True);
      RedrawKeyring(tvKeyring, pgpKeyring);
      SetStatus('Key was successfully removed');
    end;
  end;
end;

procedure TfrmKeys.actExportKeyExecute(Sender: TObject);
var
  Key: TElPGPPublicKey;
begin
  if ((tvKeyring.Selected <> nil) and (TObject(tvKeyring.Selected.Data) is TElPGPPublicKey)) then
  begin
    Key := TElPGPPublicKey(tvKeyring.Selected.Data);
    if SaveDlg.Execute then
    begin
      Key.SaveToFile(SaveDlg.FileName, True);
      SetStatus('Key saved');
    end;
  end;
end;

procedure TfrmKeys.actSignUpdate(Sender: TObject);
begin
  (Sender as TAction).Enabled := (tvKeyring.Selected <> nil) and
    (tvKeyring.Selected.Level < 2);
end;

function TfrmKeys.SignUser(user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey; signingKey: TElPGPSecretKey): TElPGPSignature;
var
  Sig: TElPGPSignature;
begin
  Sig := TElPGPSignature.Create();
  Sig.CreationTime := Now;
  try
    signingKey.Sign(TElPGPPublicKey(userKey), user, sig, ctGeneric);
  except
    // Exception. Possibly, passphrase is needed.
    signingKey.Passphrase := RequestPassphrase(signingKey.PublicKey);
    try
      signingKey.Sign(TElPGPPublicKey(userKey), user, sig, ctGeneric);
    except
      on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        FreeAndNil(Sig);
      end;
    end;
  end;

  Result := Sig;
end;

procedure TfrmKeys.actSignExecute(Sender: TObject);
var
  i: Integer;
  Sig: TElPGPSignature;
begin
  if pgpKeyring.SecretCount = 0 then
  begin
    MessageDlg('There is no secret keys', mtError, [mbOK], 0);
    Exit;
  end;

  if ((tvKeyring.Selected <> nil) and (tvKeyring.Selected.Data <> nil)) then
  begin
    if (TObject(tvKeyring.Selected.Data) is TElPGPCustomUser) and
       (tvKeyring.Selected.Parent <> nil) and
       (TObject(tvKeyring.Selected.Parent.Data) is TElPGPPublicKey) then
    begin
      with TfrmPrivateKeys.Create(Self) do
        try
          lstKeys.Items.Clear();
          for i := 0 to pgpKeyring.SecretCount - 1 do
            lstKeys.Items.Add(GetDefaultUserID(pgpKeyring.SecretKeys[i].PublicKey));

          if (ShowModal = mrOK) then
          begin
            i := 0;
            while (i < lstKeys.Items.Count) and (not lstKeys.Selected[i]) do
              Inc(i);

            sig := SignUser(TElPGPCustomUser(tvKeyring.Selected.Data),
                      TElPGPPublicKey(tvKeyring.Selected.Parent.Data),
                      pgpKeyring.SecretKeys[i]);

            if (sig <> nil) then
            begin
              (TElPGPCustomUser(tvKeyring.Selected.Data)).AddSignature(sig);
              RedrawKeyring(tvKeyring, pgpKeyring);
              SetStatus('Signed successfully');
            end;
          end;
        finally
          Free;
        end;
    end
    else
      MessageDlg('Only User information may be signed', mtError, [mbOK], 0);
  end;
end;

function TfrmKeys.RevokeUser(user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey; signingKey: TElPGPSecretKey): TElPGPSignature;
var
  Sig: TElPGPSignature;
begin
  sig := TElPGPSignature.Create();
  sig.CreationTime := Now;
  try
    signingKey.Revoke(TElPGPPublicKey(userKey), user, sig, nil);
  except
    // Exception. Possibly, passphrase is needed.
    signingKey.Passphrase := RequestPassphrase(signingKey.PublicKey);
    try
      signingKey.Revoke(TElPGPPublicKey(userKey), user, sig, nil);
    except
      on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        FreeAndNil(Sig);
      end;
    end;
  end;

  Result := Sig;
end;

procedure TfrmKeys.actRevokeExecute(Sender: TObject);
var
  i: Integer;
  Sig: TElPGPSignature;
begin
  if pgpKeyring.SecretCount = 0 then
  begin
    MessageDlg('There is no secret keys', mtError, [mbOK], 0);
    Exit;
  end;

  if ((tvKeyring.Selected <> nil) and (tvKeyring.Selected.Data <> nil)) then
  begin
    if (TObject(tvKeyring.Selected.Data) is TElPGPCustomUser) and
       (tvKeyring.Selected.Parent <> nil) and
       (TObject(tvKeyring.Selected.Parent.Data) is TElPGPPublicKey) then
    begin
      with TfrmPrivateKeys.Create(Self) do
        try
          lstKeys.Items.Clear();
          for i := 0 to pgpKeyring.SecretCount - 1 do
            lstKeys.Items.Add(GetDefaultUserID(pgpKeyring.SecretKeys[i].PublicKey));

          if (ShowModal = mrOK) then
          begin
            i := 0;
            while (i < lstKeys.Items.Count) and (not lstKeys.Selected[i]) do
              Inc(i);

            sig := RevokeUser(TElPGPCustomUser(tvKeyring.Selected.Data),
                      TElPGPPublicKey(tvKeyring.Selected.Parent.Data),
                      pgpKeyring.SecretKeys[i]);

            if (sig <> nil) then
            begin
              (TElPGPCustomUser(tvKeyring.Selected.Data)).AddSignature(sig);
              RedrawKeyring(tvKeyring, pgpKeyring);
              SetStatus('Revoked successfully');
            end;
          end;
        finally
          Free;
        end;
    end
    else
      MessageDlg('Only User information may be revoked', mtError, [mbOK], 0);
  end;
end;

function TfrmKeys.RequestPassphrase(Key: TElPGPPublicKey): string;
begin
  Result := '';
  with TfrmPassphraseRequest.Create(Self) do
    try
      lbKeyID.Caption := GetDefaultUserID(key) + ' (' + KeyID2Str(key.KeyID(), true) + ')';
      if ShowModal = mrOK then
        Result := edPassphrase.Text;
    finally
      Free;
    end;
end;

procedure TfrmKeys.SetStatus(s: string);
begin
  sbrMain.SimpleText := s;
end;

procedure TfrmKeys.HideAllInfoPanels();
begin
  pKeyInfo.Visible := False;
  pUserInfo.Visible := False;
  pSigInfo.Visible := False;
end;

procedure TfrmKeys.EnableView(p: TPanel);
begin
  p.Align := alClient;
  p.Visible := True;
end;

procedure TfrmKeys.DrawPublicKeyProps(key: TElPGPCustomPublicKey);
begin
  HideAllInfoPanels();
  lbKeyAlgorithm.Caption := 'Algorithm: ' + PKAlg2Str(Key.PublicKeyAlgorithm) + ' (' + IntToStr(Key.BitsInKey) + ' bits)';
  lbKeyID.Caption := 'KeyID: ' + KeyID2Str(key.KeyID(), False);
  lbKeyFP.Caption := 'KeyFP: ' + KeyFP2Str(key.KeyFP());
  lbTimestamp.Caption := 'Created: ' + FormatDateTime('yyyy/mm/dd hh:nn:ss', Key.Timestamp);
  if Key.Expires = 0 then
    lbExpires.Caption := 'Expires: NEVER'
  else
    lbExpires.Caption := 'Expires: ' + FormatDateTime('yyyy/mm/dd hh:nn:ss', key.Timestamp + key.Expires);

  EnableView(pKeyInfo);
end;

procedure TfrmKeys.DrawUserIDProps(user: TElPGPUserID);
begin
  HideAllInfoPanels();
  picUser.Visible := False;
  lbUserName.Visible := True;
  lbUserName.Caption := 'User name: ' + user.Name;
  EnableView(pUserInfo);
end;

procedure TfrmKeys.DrawUserAttrProps(user: TElPGPUserAttr);
{var
  strm: TMemoryStream;}
begin
// Load picture (Jpeg format)
  HideAllInfoPanels();
{  strm := TMemoryStream.Create();
  picUser.Visible := True;
  lbUserName.Visible := False;
  strm.Write(user.Images[0].JpegData[0], 0, Length(user.get_Images(0).JpegData));
  strm.Position := 0;
  picUser.Image := System.Drawing.Image.FromStream(strm);
  EnableView(pUserInfo);}
end;

procedure TfrmKeys.DrawSignatureProps(sig: TElPGPSignature; user: TElPGPCustomUser; userKey: TElPGPCustomPublicKey);
var
  Validity: string;
  Key: TElPGPCustomPublicKey;
begin
  Validity := 'Unable to verify';
  Key := nil;
  HideAllInfoPanels();
  pgpKeyring.FindPublicKeyByID(sig.SignerKeyID(), Key, 0);

  if Key <> nil then
  begin
    if Key is TElPGPPublicKey then
    begin
      lbSigner.Caption := 'Signer: ' + GetDefaultUserID(TElPGPPublicKey(key));
      if user <> nil then
      begin
        try
          if (sig.IsUserRevocation()) then
          begin
            if (key.RevocationVerify(userKey, user, sig)) then
              validity := 'Valid'
            else
              validity := 'INVALID';
          end
	  else
          begin
            if (key.Verify(userKey, user, sig)) then
              validity := 'Valid'
            else
              validity := 'INVALID';
          end;

        except
          on E: Exception do
            validity := E.Message;
        end;
      end
      else
 	validity := 'UserID not found';
    end
    else
      lbSigner.Caption := 'Signer: Unknown signer';
  end
  else
    lbSigner.Caption := 'Signer: Unknown signer';

  lbSigCreated.Caption := FormatDateTime('yyyy/mm/dd hh:nn:ss', sig.CreationTime);
  lbValidity.Caption := 'Validity: ' + validity;
  if (sig.IsUserRevocation()) then
    lbSigType.Caption := 'Type: User revocation'
  else
    lbSigType.Caption := 'Type: Certification signature';

  EnableView(pSigInfo);
end;

procedure TfrmKeys.DrawSignatureProps(sig: TElPGPSignature; subkey: TElPGPPublicSubkey; userKey: TElPGPCustomPublicKey);
var
  Validity: string;
begin
  Validity := 'Unable to verify';
  HideAllInfoPanels();

  lbSigner.Caption := 'Signer: ' + GetDefaultUserID(TElPGPPublicKey(userKey));
  if (subkey <> nil) then
  begin
    try
      if (sig.IsSubkeyRevocation()) then
      begin
        if (userKey.RevocationVerify(subkey, sig)) then
          validity := 'Valid'
        else
          validity := 'INVALID';
      end
      else
      begin
        if (userKey.Verify(subkey, sig)) then
          validity := 'Valid'
        else
          validity := 'INVALID';
      end;

     except
       on E: Exception do
         validity := E.Message;
     end;
  end
  else
    validity := 'Subkey not found';

  lbSigCreated.Caption := FormatDateTime('yyyy/mm/dd hh:nn:ss', sig.CreationTime);
  lbValidity.Caption := 'Validity: ' + validity;
  if (sig.IsSubkeyRevocation()) then
    lbSigType.Caption := 'Type: Subkey revocation'
  else
    lbSigType.Caption := 'Type: Subkey binding signature';

  EnableView(pSigInfo);
end;

procedure TfrmKeys.tvKeyringChange(Sender: TObject; Node: TTreeNode);
begin
  if TObject(Node.Data) is TElPGPCustomPublicKey then
    DrawPublicKeyProps(TElPGPCustomPublicKey(Node.Data))
  else if TObject(Node.Data) is TElPGPUserID then
    DrawUserIDProps(TElPGPUserID(Node.Data))
  else if TObject(Node.Data) is TElPGPUserAttr then
    DrawUserAttrProps(TElPGPUserAttr(Node.Data))
  else if TObject(Node.Data) is TElPGPSignature then
  begin
    if ((Node.Parent <> nil) and (TObject(Node.Parent.Data) is TElPGPCustomUser) and
        (Node.Parent.Parent <> nil) and (TObject(Node.Parent.Parent.Data) is TElPGPCustomPublicKey)) then
    begin
      DrawSignatureProps(TElPGPSignature(Node.Data), TElPGPCustomUser(Node.Parent.Data),
                         TElPGPCustomPublicKey(Node.Parent.Parent.Data));
    end
    else if ((Node.Parent <> nil) and (TObject(Node.Parent.Data) is TElPGPPublicSubkey) and
             (Node.Parent.Parent <> nil) and (TObject(Node.Parent.Parent.Data) is TElPGPCustomPublicKey)) then
    begin
      DrawSignatureProps(TElPGPSignature(Node.Data), TElPGPPublicSubkey(Node.Parent.Data),
                         TElPGPCustomPublicKey(Node.Parent.Parent.Data));
    end
    else
    begin
      DrawSignatureProps(TElPGPSignature(Node.Data), TElPGPCustomUser(nil), nil);
    end;
  end;
end;

procedure TfrmKeys.FormCreate(Sender: TObject);
begin
  HideAllInfoPanels();
end;

procedure TfrmKeys.actAboutExecute(Sender: TObject);
begin
  {with TfrmAbout.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;}
end;


procedure TfrmKeys.Generatekey1Click(Sender: TObject);
begin
  with TfrmWizard.Create(Self) do
    try
      if ShowModal = mrOK then
      begin
        pgpKeyring.AddSecretKey(FSecKey);
//        pgpKeyring.AddPublicKey(FSecKey.PublicKey);
        RedrawKeyring(tvKeyring, pgpKeyring);
        SetStatus('New key was added to keyring');
      end;
    finally
      Free;
    end;
end;

procedure TfrmKeys.Importkey1Click(Sender: TObject);
var
  tempKeyring: TElPGPKeyring;
begin
  tempKeyring := TElPGPKeyring.Create(nil);
  if OpenDlg.Execute then
  begin
    try
      tempKeyring.Load(OpenDlg.Filename, '', True);
    except
      on E: Exception do
      begin
        MessageDlg(E.Message, mtError, [mbOK], 0);
        SetStatus('Failed to import key');
        FreeAndNil(tempKeyring);
      end;
    end;

    with TfrmImportKey.Create(Self) do
      try
        tvKeys.Images := imgTreeView;
        RedrawKeyring(tvKeys, tempKeyring);
        if (ShowModal = mrOK) then
        begin
          tempKeyring.ExportTo(pgpKeyring);
          RedrawKeyring(tvKeyring, pgpKeyring);
        end;
      finally
        Free;
      end;
  end;

  SetStatus(IntToStr(tempKeyring.PublicCount) + ' key(s) successfully imported');
  tempKeyring.Free;
end;

procedure TfrmKeys.RemoveKey1Click(Sender: TObject);
var
  Key: TElPGPPublicKey;
begin
  if ((tvKeyring.Selected <> nil) and (TObject(tvKeyring.Selected.Data) is TElPGPPublicKey)) then
  begin
    Key := TElPGPPublicKey(tvKeyring.Selected.Data);
    if (MessageDlg('Are you sure you want to remove the key (' + GetDefaultUserID(key) + ')?',
                  mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
    begin
      if (key.SecretKey <> nil) then
      begin
        if (MessageDlg('The key you want to remove is SECRET! Are you still sure?',
                  mtConfirmation, [mbYes, mbNo], 0) <> mrYes) then
          Exit;
      end;

      pgpKeyring.RemovePublicKey(Key, True);
      RedrawKeyring(tvKeyring, pgpKeyring);
      SetStatus('Key was successfully removed');
    end;
  end;
end;

procedure TfrmKeys.ExportKey1Click(Sender: TObject);
var
  Key: TElPGPPublicKey;
begin
  if ((tvKeyring.Selected <> nil) and (TObject(tvKeyring.Selected.Data) is TElPGPPublicKey)) then
  begin
    Key := TElPGPPublicKey(tvKeyring.Selected.Data);
    if SaveDlg.Execute then
    begin
      Key.SaveToFile(SaveDlg.FileName, True);
      SetStatus('Key saved');
    end;
  end;
end;

procedure TfrmKeys.Sign1Click(Sender: TObject);
var
  i: Integer;
  Sig: TElPGPSignature;
begin
  if pgpKeyring.SecretCount = 0 then
  begin
    MessageDlg('There is no secret keys', mtError, [mbOK], 0);
    Exit;
  end;

  if ((tvKeyring.Selected <> nil) and (tvKeyring.Selected.Data <> nil)) then
  begin
    if (TObject(tvKeyring.Selected.Data) is TElPGPCustomUser) and
       (tvKeyring.Selected.Parent <> nil) and
       (TObject(tvKeyring.Selected.Parent.Data) is TElPGPPublicKey) then
    begin
      with TfrmPrivateKeys.Create(Self) do
        try
          lstKeys.Items.Clear();
          for i := 0 to pgpKeyring.SecretCount - 1 do
            lstKeys.Items.Add(GetDefaultUserID(pgpKeyring.SecretKeys[i].PublicKey));

          if (ShowModal = mrOK) then
          begin
            i := 0;
            while (i < lstKeys.Items.Count) and (not lstKeys.Selected[i]) do
              Inc(i);

            sig := SignUser(TElPGPCustomUser(tvKeyring.Selected.Data),
                      TElPGPPublicKey(tvKeyring.Selected.Parent.Data),
                      pgpKeyring.SecretKeys[i]);

            if (sig <> nil) then
            begin
              (TElPGPCustomUser(tvKeyring.Selected.Data)).AddSignature(sig);
              RedrawKeyring(tvKeyring, pgpKeyring);
              SetStatus('Signed successfully');
            end;
          end;
        finally
          Free;
        end;
    end
    else
      MessageDlg('Only User information may be signed', mtError, [mbOK], 0);
  end;
end;

procedure TfrmKeys.Revoke2Click(Sender: TObject);
var
  i: Integer;
  Sig: TElPGPSignature;
begin
  if pgpKeyring.SecretCount = 0 then
  begin
    MessageDlg('There is no secret keys', mtError, [mbOK], 0);
    Exit;
  end;

  if ((tvKeyring.Selected <> nil) and (tvKeyring.Selected.Data <> nil)) then
  begin
    if (TObject(tvKeyring.Selected.Data) is TElPGPCustomUser) and
       (tvKeyring.Selected.Parent <> nil) and
       (TObject(tvKeyring.Selected.Parent.Data) is TElPGPPublicKey) then
    begin
      with TfrmPrivateKeys.Create(Self) do
        try
          lstKeys.Items.Clear();
          for i := 0 to pgpKeyring.SecretCount - 1 do
            lstKeys.Items.Add(GetDefaultUserID(pgpKeyring.SecretKeys[i].PublicKey));

          if (ShowModal = mrOK) then
          begin
            i := 0;
            while (i < lstKeys.Items.Count) and (not lstKeys.Selected[i]) do
              Inc(i);
            sig := RevokeUser(TElPGPCustomUser(tvKeyring.Selected.Data),
                      TElPGPPublicKey(tvKeyring.Selected.Parent.Data),
                      pgpKeyring.SecretKeys[i]);
            if (sig <> nil) then
            begin
              (TElPGPCustomUser(tvKeyring.Selected.Data)).AddSignature(sig);
              RedrawKeyring(tvKeyring, pgpKeyring);
              SetStatus('Revoked successfully');
            end;
          end;
        finally
          Free;
        end;
    end
    else
      MessageDlg('Only User information may be revoked', mtError, [mbOK], 0);
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
