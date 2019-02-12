unit frmMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SBConstants, SBX509, SBX509Ext, SBPKCS12, SBCustomCertStorage, SBWinCertStorage,
  Grids,  Menus, GenerateCert, ToolWin, ExtCtrls, Buttons, SelectStorage, ComCtrls,
  ActnList, ImgList, SBRDN, SBMessages;

type
  TSertX509 = class(TForm)
    OpenDlgCert: TOpenDialog;
    saveDlgCert: TSaveDialog;
    sbStatus: TStatusBar;
    OpenDlgStorage: TOpenDialog;
    SaveDlgStorage: TSaveDialog;
    mmMain: TMainMenu;
    mmiStorage: TMenuItem;
    mmiNewMemStorage: TMenuItem;
    mmiMountStorage: TMenuItem;
    mmiSaveStorage: TMenuItem;
    mmiSaveStorageAs: TMenuItem;
    mmiImportFromWinStorage: TMenuItem;
    mmiCertificate: TMenuItem;
    mmiRemoveCertificate: TMenuItem;
    mmiNewCertificate: TMenuItem;
    mmiSaveCertificate: TMenuItem;
    mmiLoadCertificate: TMenuItem;
    mmiValidate: TMenuItem;
    mmiLoadPrivateKey: TMenuItem;
    OpenDlgPvtKey: TOpenDialog;
    mmiUnmountStorage: TMenuItem;
    pmiMain: TPopupMenu;
    pmiNewMemoryStorage: TMenuItem;
    pmiMountStorage: TMenuItem;
    pmiSaveStorage: TMenuItem;
    pmiSaveStorageAs: TMenuItem;
    pmiImportFromWinStorage: TMenuItem;
    pmiUnmountStorage: TMenuItem;
    pmiNewCertificate: TMenuItem;
    pmiRemoveCertificate: TMenuItem;
    pmioLoadCertificate: TMenuItem;
    pmiSaveCertificate: TMenuItem;
    pmiValidate: TMenuItem;
    pmiLoadPrivateKey: TMenuItem;
    mmiMoveToStorage: TMenuItem;
    mmiCopyToStorage: TMenuItem;
    pmiMoveToStorage: TMenuItem;
    pmiCopyToStorage: TMenuItem;
    mmiExportToMemoryStorage: TMenuItem;
    pmiExportToMemoryStorage: TMenuItem;
    mmiNewFileStorage: TMenuItem;
    pmiNewFileStorage: TMenuItem;
    mmiSeparator1: TMenuItem;
    mmiSeparator2: TMenuItem;
    mmiSeparator5: TMenuItem;
    mmiSeparator6: TMenuItem;
    pmiSeparator1: TMenuItem;
    pmiSeparator2: TMenuItem;
    pmiSeparator3: TMenuItem;
    pmiSeparator5: TMenuItem;
    pmiSeparator6: TMenuItem;
    mmiSeparator3: TMenuItem;
    mmiExit: TMenuItem;
    mmiSeparator4: TMenuItem;
    mmiCreateCSR: TMenuItem;
    pmiSeparator4: TMenuItem;
    pmiCreateCSR: TMenuItem;
    alMain: TActionList;
    acNewMemStorage: TAction;
    acNewFileStorage: TAction;
    acSaveStorage: TAction;
    acSaveStorageAs: TAction;
    acMountStorage: TAction;
    acUnmountStorage: TAction;
    acImportFromWinStorage: TAction;
    acExportToMemoryStorage: TAction;
    acNewCertificate: TAction;
    acLoadCertificate: TAction;
    acSaveCertificate: TAction;
    acRemoveCertificate: TAction;
    acCreateCSR: TAction;
    acValidate: TAction;
    acLoadPrivateKey: TAction;
    acMoveToStorage: TAction;
    acCopyToStorage: TAction;
    treeCert: TTreeView;
    ilTree: TImageList;
    pcInfo: TPageControl;
    tsNoInfo: TTabSheet;
    tsCertificate: TTabSheet;
    imgCertificate: TImage;
    lblIssuedByLabel: TLabel;
    lnlIssuedToLabel: TLabel;
    lblIssuedBy: TLabel;
    lblIssuedTo: TLabel;
    memAdditional: TMemo;
    lblValidFromLabel: TLabel;
    lblValidFrom: TLabel;
    lblValidToLabel: TLabel;
    lblValidTo: TLabel;
    lvCertProperties: TListView;
    bvlCertInfoSeparator: TBevel;
    splTree: TSplitter;
    acTrusted: TAction;
    pmiTrusted: TMenuItem;
    mmiTrusted: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure mmiExitClick(Sender: TObject);
    procedure treeCertChange(Sender: TObject; Node: TTreeNode);
    procedure treeCertDeletion(Sender: TObject; Node: TTreeNode);
    procedure acNewMemStorageExecute(Sender: TObject);
    procedure acNewFileStorageExecute(Sender: TObject);
    procedure acSaveStorageExecute(Sender: TObject);
    procedure acSaveStorageAsExecute(Sender: TObject);
    procedure acMountStorageExecute(Sender: TObject);
    procedure acUnmountStorageExecute(Sender: TObject);
    procedure acImportFromWinStorageExecute(Sender: TObject);
    procedure acExportToMemoryStorageExecute(Sender: TObject);
    procedure acNewCertificateExecute(Sender: TObject);
    procedure acLoadCertificateExecute(Sender: TObject);
    procedure acSaveCertificateExecute(Sender: TObject);
    procedure acRemoveCertificateExecute(Sender: TObject);
    procedure acCreateCSRExecute(Sender: TObject);
    procedure acValidateExecute(Sender: TObject);
    procedure acLoadPrivateKeyExecute(Sender: TObject);
    procedure acMoveToStorageExecute(Sender: TObject);
    procedure acCopyToStorageExecute(Sender: TObject);
    procedure mmiAboutClick(Sender: TObject);
    procedure lvCertPropertiesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure acTrustedExecute(Sender: TObject);
  private
  protected
    function DoCopyToStorage: Boolean;
    procedure LoadStorage(ParentNode: TTreeNode; StorageName: string;
      Storage: TElCustomCertStorage);
  public
    procedure DisplayCertificateInfo(Cert : TElX509Certificate);
  end;

var
  SertX509 : TSertX509;
  Storage : TElCustomCertStorage;
  WinStorage1, WinStorage2, WinStorage3, WinStorage4 : TElWinCertStorage;
  GlobalCert : TElX509Certificate;
  GlobalPrivateKey : array[0..4095] of byte;
  PrivateKeySize : Word;
  StorageList : TList;
  CurrStorageName : TStringList;
  SelectedIndex : integer;

{$J+}

const StorageNumber : integer = 0;

implementation

uses
  SBPEM, SBUtils, AboutForm, ExtensionEncoder, uValidate;

{$R *.DFM}
//--------------- Helper function ------------------
// Get algorithm string
function GetEncryptionAlghorithm(Algorithm : integer) : string;
begin
  case (Algorithm) of
    SB_CERT_ALGORITHM_ID_RSA_ENCRYPTION     : Result := 'RSA';
    SB_CERT_ALGORITHM_MD2_RSA_ENCRYPTION    : Result := 'MD2 with RSA';
    SB_CERT_ALGORITHM_MD5_RSA_ENCRYPTION    : Result := 'MD5 with RSA';
    SB_CERT_ALGORITHM_SHA1_RSA_ENCRYPTION   : Result := 'SHA1 with RSA';
    SB_CERT_ALGORITHM_ID_DSA                : Result := 'DSA';
    SB_CERT_ALGORITHM_ID_DSA_SHA1           : Result := 'DSA with SHA1';
    SB_CERT_ALGORITHM_DH_PUBLIC             : Result := 'DH';
    SB_CERT_ALGORITHM_SHA224_RSA_ENCRYPTION : Result := 'SHA224 with RSA';
    SB_CERT_ALGORITHM_SHA256_RSA_ENCRYPTION : Result := 'SHA256 with RSA';
    SB_CERT_ALGORITHM_SHA384_RSA_ENCRYPTION : Result := 'SHA384 with RSA';
    SB_CERT_ALGORITHM_SHA512_RSA_ENCRYPTION : Result := 'SHA512 with RSA';
    SB_CERT_ALGORITHM_ID_RSAPSS             : Result := 'RSA-PSS';
    SB_CERT_ALGORITHM_ID_RSAOAEP            : Result := 'RSA-OAEP';
    SB_CERT_ALGORITHM_UNKNOWN               : Result := 'Unknown';
  end;
end;

//Get display name for certificate
function GetCertDisplayName(Cert : TelX509Certificate) : string;
begin
  try
    Result := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_COMMON_NAME);
    if Result = '' then
      Result := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_ORGANIZATION);
  except Result:=''; end;
end;
//-----------------------------

procedure TSertX509.LoadStorage(ParentNode : TTreeNode;StorageName : string;
  Storage : TElCustomCertStorage);
var C : integer;
    S : String;
    Cert : TElX509Certificate;
    StorageNode,TI : TTreeNode;
begin
  treeCert.Items.BeginUpdate;
  treeCert.Enabled := False;
  try
    // Add Storage node
    StorageNode:=treeCert.Items.AddChildObject(ParentNode, StorageName, Storage);
    StorageNode.ImageIndex:=2;
    StorageNode.SelectedIndex:=2;
    // Windows storages assumed as trusted
    if Storage is TElWinCertStorage then
    begin
      StorageNode.ImageIndex:=6;
      StorageNode.SelectedIndex:=6;
    end;
    StorageNode.Selected:=True;
    StorageList.Add(Storage);
    CurrStorageName.Add(StorageName);
    // Add certificates
    C := 0;
    while C < Storage.Count do
    begin
      try
        Cert := TElX509Certificate.Create(nil);
        Cert.Assign(Storage.Certificates[C]);
        S := GetCertDisplayName(Cert);

        TI:=treeCert.Items.AddChildObject(StorageNode, S, Cert);
        TI.ImageIndex:=3; TI.SelectedIndex:=3;

        Inc(C);
        sbStatus.Panels[0].Text := 'Loading Certificates ' + StorageName + '...'
          + IntToStr(C * 100 div Storage.Count) + '%';
        Application.ProcessMessages;
      except
        on E : Exception do  Application.ShowException(E);
      end;
    end;
  finally
    treeCert.Enabled := True;
    treeCert.Items.EndUpdate;
  end;
end;

procedure TSertX509.FormDestroy(Sender: TObject);
begin
  treeCert.Items.Clear;
  treeCert.Free;
  WinStorage1.Free;
  WinStorage2.Free;
  WinStorage3.Free;
  WinStorage4.Free;
  StorageList.Free;
  CurrStorageName.Free;
end;

procedure TSertX509.DisplayCertificateInfo(Cert : TElX509Certificate);
// Add new line to detail listview
procedure AddListValue(FieldName,Value : string;
  Additional : string = '';ImageIndex : integer= 4);
var LI : TListItem;
begin
  If (Trim(Value) = '') and (Trim(Additional)='') then exit;
  LI:=lvCertProperties.Items.Add;
  LI.Caption:=FieldName;
  LI.ImageIndex:=ImageIndex;
  LI.SubItems.Add(StringReplace(Value,#13#10,' ',[rfReplaceAll]));
  If Additional<> '' then LI.SubItems.Add(Additional)
    else LI.SubItems.Add(Value);
end;

function ConcateString(SrcSt,AddSt,SeparatorSt : string; AddToStart : boolean) : string;
begin
  Result:='';
  if SrcSt<>'' then begin
    if AddToStart then Result:=AddSt + SeparatorSt + SrcSt
     else Result:=SrcSt + SeparatorSt + AddSt;
  end else Result:=AddSt;
end;

// Add RDN to list
procedure AddRDN(FieldName : string;Data : TElRelativeDistinguishedName);
var i : integer;
    Value,Add,OIDString : string;
    AddToStart,CommonAdded : boolean;
begin
  Value:=''; Add:=''; CommonAdded:=False;
  for i:=0 to Data.Count - 1 do
  begin
    OIDString := GetStringByOID(Data.OIDs[i]);
    // Put common name as first. If no this - add Organization
    AddToStart := AnsiUpperCase(OIDString) = 'COMMONNAME';
    if AddToStart then CommonAdded:=True;
    if not CommonAdded then
      AddToStart := AnsiUpperCase(OIDString) = 'ORGANIZATION';
    Add:=ConcateString(Add,OIDString + ' = ' + Data.Values[i],#13#10,AddToStart);
    Value:=ConcateString(Value,Data.Values[i],',',AddToStart);
  end;
  AddListValue(FieldName,Value,Add);
end;

procedure DisplayExtensions(Cert : TelX509Certificate);
var i : integer;
// Add extension in a case that  Value <>''
procedure AddExtension(Name : string; Ext : TElCustomExtension;
  CheckValue : TSBCertificateExtension; ValueSt : string='');
begin
  If not (CheckValue in Cert.Extensions.Included) then exit;
  if ValueSt='' then
    AddListValue(Name,BuildHexString(Ext.Value),'',5)
  else AddListValue(Name,ValueSt,ValueSt,5); 
end;

begin
  // Extensions
  AddExtension('AuthorityInformationAccess',Cert.Extensions.AuthorityInformationAccess,
    ceAuthorityInformationAccess,GetAuthorityInformationAccess(Cert.Extensions.AuthorityInformationAccess));
  AddExtension('Authority Key Identifier',Cert.Extensions.AuthorityKeyIdentifier,
    ceAuthorityKeyIdentifier,GetAuthorityKeyIdentifierValue(Cert.Extensions.AuthorityKeyIdentifier));
  AddExtension('Basic constraints',Cert.Extensions.BasicConstraints,
    ceBasicConstraints,GetBasicConstraintValue(Cert.Extensions.BasicConstraints));
  AddExtension('CertificatePolicies',Cert.Extensions.CertificatePolicies,
    ceCertificatePolicies,GetCertificatePoliciesValue(Cert.Extensions.CertificatePolicies));
  AddExtension('CommonName',Cert.Extensions.CommonName,
    ceCommonName,Cert.Extensions.CommonName.Content);
  AddExtension('CRLDistributionPoints',Cert.Extensions.CRLDistributionPoints,
    ceCRLDistributionPoints,GetDistributionPointValue(Cert.Extensions.CRLDistributionPoints));
  // Extended key usage
  AddExtension('Extended key usage',Cert.Extensions.ExtendedKeyUsage,
    ceExtendedKeyUsage,GetExtendedKeyUsageValue(Cert.Extensions.ExtendedKeyUsage));
  AddExtension('IssuerAlternativeName',Cert.Extensions.IssuerAlternativeName,
    ceIssuerAlternativeName,GetIssuerAlternativeNameValue(Cert.Extensions.IssuerAlternativeName));
  // Key usage
  AddExtension('Key usage',Cert.Extensions.KeyUsage,
    ceKeyUsage, GetKeyUsageValue(Cert.Extensions.KeyUsage));
  AddExtension('NameConstraints', Cert.Extensions.NameConstraints,
    ceNameConstraints,GetNameConstraints(Cert.Extensions.NameConstraints));
  AddExtension('NetscapeBaseURL', Cert.Extensions.NetscapeBaseURL,
    ceNetscapeBaseURL,Cert.Extensions.NetscapeBaseURL.Content);
  AddExtension('NetscapeCAPolicy', Cert.Extensions.NetscapeCAPolicy,
    ceNetscapeCAPolicyURL, Cert.Extensions.NetscapeCAPolicy.Content);
  AddExtension('NetscapeCARevokeURL',Cert.Extensions.NetscapeCARevokeURL,
    ceNetscapeCARevokeURL,Cert.Extensions.NetscapeCARevokeURL.Content);
  AddExtension('NetscapeCertType',Cert.Extensions.NetscapeCertType,
    ceNetscapeCertType, GetNetscapeCertType(Cert.Extensions.NetscapeCertType));
  AddExtension('NetscapeComment',Cert.Extensions.NetscapeComment,
    ceNetscapeComment,Cert.Extensions.NetscapeComment.Content);
  AddExtension('NetscapeRenewalURL',Cert.Extensions.NetscapeRenewalURL,
    ceNetscapeRenewalURL,Cert.Extensions.NetscapeRenewalURL.Content);
  AddExtension('NetscapeRevokeURL',Cert.Extensions.NetscapeRevokeURL,
    ceNetscapeRevokeURL,Cert.Extensions.NetscapeRevokeURL.Content);
  AddExtension('NetscapeServerName',Cert.Extensions.NetscapeServerName,
    ceNetscapeServerName,Cert.Extensions.NetscapeServerName.Content);
  AddExtension('PolicyConstraints',Cert.Extensions.PolicyConstraints,
    cePolicyConstraints,GetPolicyConstraintsValue(Cert.Extensions.PolicyConstraints));
  AddExtension('PolicyMappings',Cert.Extensions.PolicyMappings,
    cePolicyMappings,GetPoliciesMappingValue(Cert.Extensions.PolicyMappings));
  AddExtension('PrivateKeyUsagePeriod',Cert.Extensions.PrivateKeyUsagePeriod,
    cePrivateKeyUsagePeriod,GetUsagePeriodValue(Cert.Extensions.PrivateKeyUsagePeriod));
  AddExtension('SubjectAlternativeName',Cert.Extensions.SubjectAlternativeName,
    ceSubjectAlternativeName,GetSubjectAltNameValue(Cert.Extensions.SubjectAlternativeName));
  AddExtension('SubjectKeyIdentifier',Cert.Extensions.SubjectKeyIdentifier,
    ceSubjectKeyIdentifier,BuildHexString(Cert.Extensions.SubjectKeyIdentifier.KeyIdentifier));
  // Custom extensions
  For i:=0 to Cert.Extensions.OtherCount -1 do
    AddListValue(OIDToStr(Cert.Extensions.OtherExtensions[i].OID),
     BuildHexString(Cert.Extensions.OtherExtensions[i].Value),'',5);
end;

var Par1, Par2, Par3, Par4 : string;
    Sz1, Sz2, Sz3, Sz4 : integer;

begin
  lvCertProperties.Items.Clear;
  lvCertProperties.Items.BeginUpdate;
  // printing ALL certificate properties
  // Version
  AddListValue('Version',IntToStr(Cert.Version));
  // SerialNumber
  AddListValue('Serial number',BuildHexString(Cert.SerialNumber));
  // SignatureAlgorithm
  AddListValue('Signature algorithm',GetEncryptionAlghorithm(Cert.SignatureAlgorithm));
  // Issuer
  AddRDN('Issuer',Cert.IssuerRDN);
  // Use CommonName or Organization
  lblIssuedBy.Caption:=Trim(Cert.IssuerName.CommonName);
  if (lblIssuedBy.Caption = '') then lblIssuedBy.Caption:=Cert.IssuerName.Organization;
  // IssuerUniqueID
  AddListValue('IssuerUniqueID',BuildHexString(Cert.IssuerUniqueID));
  // ValidFrom
  lblValidFrom.Caption := DateToStr(Cert.ValidFrom);
  AddListValue('Valid from',lblValidFrom.Caption,DateTimeToStr(Cert.ValidFrom));
  // ValidTo
  lblValidTo.Caption := DateToStr(Cert.ValidTo);
  AddListValue('Valid to',lblValidTo.Caption,DateTimeToStr(Cert.ValidTo));
  // Subject
  AddRDN('Subject',Cert.SubjectRDN);
  // Use CommonName or Organization
  lblIssuedTo.Caption:=Trim(Cert.SubjectName.CommonName);
  if (lblIssuedTo.Caption = '') then lblIssuedTo.Caption:=Cert.SubjectName.Organization;
  // SubjectUniqueID
  AddListValue('SubjectUniqueID',BuildHexString(Cert.SubjectUniqueID));
  // CertificateSize
  AddListValue('Size',IntToStr(Cert.CertificateSize));
  // Signature
  AddListValue('Signature',BuildHexString(Cert.Signature));
  // SelfSigned
  if (Cert.SelfSigned) then AddListValue('Self-signed','True')
   else AddListValue('Self-signed','False');
  if Cert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_ID_RSA_ENCRYPTION then
  begin
    Sz1 := 0;  Sz2:=0;
    Cert.GetRSAParams(nil, Sz1, nil, Sz2);
    SetLength(Par1, Sz1);  SetLength(Par2, Sz2);
    Cert.GetRSAParams(@Par1[1], Sz1, @Par2[1], Sz2);
    Sz3 := Cert.GetPublicKeySize;
    AddListValue('Public key','RSA (' + IntToStr(Sz3) + ')',
      'RSAModulus = ' + BuildHexString(Par1) + #13#10 +
      'RSAPublicKey = ' + BuildHexString(Par2));
  end
  else if Cert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_ID_DSA then
  begin
    Sz1 := 0; Sz2:=0; Sz3:=0; Sz4:=0;
    Cert.GetDSSParams(nil, Sz1, nil, Sz2, nil, Sz3, nil, Sz4);
    SetLength(Par1, Sz1); SetLength(Par2, Sz2);  SetLength(Par3, Sz3);  SetLength(Par4, Sz4);
    Cert.GetDSSParams(@Par1[1], Sz1, @Par2[1], Sz2, @Par3[1], Sz3, @Par4[1], Sz4);
    AddListValue('Public key','DSA (' + IntToStr(Sz4*8) + ')',
      'DSSP = ' + BuildHexString(Par1) + #13#10 + 'DSSQ = ' + BuildHexString(Par2) + #13#10 +
      'DSSG = ' + BuildHexString(Par3) + #13#10 + 'DSSY = ' + BuildHexString(Par4));
  end
  else if Cert.PublicKeyAlgorithm = SB_CERT_ALGORITHM_DH_PUBLIC then
  begin
    Sz1 := 0; Sz2:=0; Sz3:=0;
    Cert.GetDHParams(nil, Sz1, nil, Sz2, nil, Sz3);
    SetLength(Par1, Sz1); SetLength(Par2, Sz2);  SetLength(Par3, Sz3);
    Cert.GetDHParams(@Par1[1], Sz1, @Par2[1], Sz2, @Par3[1], Sz3);
    AddListValue('Public key','DH (' + IntToStr(Sz3*8) + ')',
      'DHP = ' + BuildHexString(Par1) + #13#10 + 'DHG = ' + BuildHexString(Par2) + #13#10 +
      'DHY = ' + BuildHexString(Par3));
  end
  else
  begin
    Sz1 := 0;
    Cert.GetPublicKeyBlob(nil, Sz1);
    SetLength(Par1, Sz1);
    Cert.GetPublicKeyBlob(@Par1[1], Sz1);
    AddListValue('Public key', 'Unknown', 'Key blob = ' + BuildHexString(Par1));
  end;
  // Private key
  if not Cert.PrivateKeyExists then AddListValue('Private Key','Not Available') else
  begin
    if Cert.PrivateKeyExtractable then AddListValue('Private Key','Available, Exportable')
      else AddListValue('Private Key','Available, Not Exportable');
  end;
  // Extensions
  DisplayExtensions(Cert);
  try
    if Cert.Validate then
     sbStatus.SimpleText := 'Certificate is self signed'
    else
     sbStatus.SimpleText := 'Certificate is not self signed';
  except end;
  if Cert.PrivateKeyExists then
    sbStatus.SimpleText := sbStatus.SimpleText + ', Private Key exists'
  else
    sbStatus.SimpleText := sbStatus.SimpleText + ', Private Key does not exist';

  // The code below can be used to show private keys
  (*
  PrivateKeySize:=0;
  Cert.SaveKeyToBuffer(nil, PrivateKeySize);
  Cert.SaveKeyToBuffer(@GlobalPrivateKey[0], PrivateKeySize);
  if PrivateKeySize <> 0 then
  begin
    sbStatus.SimpleText := StatusBar1.SimpleText + ', Private Key exists';
    S := 'PrivateKey = ' + BuildHexString(GlobalPrivateKey);
  end
  else begin
    sbStatus.SimpleText := StatusBar1.SimpleText + ', Private Key does not exist';
    S := '';
  end;
  memContent.Lines.Add(S);
  *)
  lvCertProperties.Items.EndUpdate;
end;

procedure TSertX509.FormActivate(Sender: TObject);
var i : integer;
begin
  // Hide tabs
  For i:=0 to pcInfo.PageCount - 1 do pcInfo.Pages[i].TabVisible:=False;
  GlobalCert := TElX509Certificate.Create(nil);
  WinStorage1 := TElWinCertStorage.Create(nil);
  WinStorage2 := TElWinCertStorage.Create(nil);
  WinStorage3 := TElWinCertStorage.Create(nil);
  WinStorage4 := TElWinCertStorage.Create(nil);
  StorageList := TList.Create;
  CurrStorageName := TStringList.Create;
  if treeCert.Items[0].GetLastChild.AbsoluteIndex < 4 then
  begin
    sbStatus.Panels[0].Text := 'Loading Windows Certificates...';
    Screen.Cursor := crHourGlass;
    WinStorage1.SystemStores.Clear;
    // ROOT
    WinStorage1.SystemStores.Add('ROOT');
    LoadStorage(treeCert.Items[1],'ROOT',WinStorage1);
    // CA
    WinStorage2.SystemStores.Clear;
    WinStorage2.SystemStores.Add('CA');
    LoadStorage(treeCert.Items[1],'CA',WinStorage2);
    // MY
    WinStorage3.SystemStores.Clear;
    WinStorage3.SystemStores.Add('MY');
    LoadStorage(treeCert.Items[1],'MY',WinStorage3);
    // SPC
    WinStorage4.SystemStores.Clear;
    WinStorage4.SystemStores.Add('SPC');
    //LoadStorage(treeCert.Items[1],'SPC',WinStorage4);

    Screen.Cursor := crDefault;
    sbStatus.Panels[0].Text := '';

    TreeCertChange(nil, TreeCert.Selected);
  end;
end;

function TSertX509.DoCopyToStorage: Boolean;
var J : integer;
    DestStorage : TElCustomCertStorage;
    SourceCert  : TElX509Certificate;
begin
  result := false;
  if (treeCert.Selected.Data <> nil) and
    (TObject(treeCert.Selected.Data) is TElX509Certificate) then
  begin
    SourceCert := TElX509Certificate(treeCert.Selected.Data);

    StorageSelectForm := TStorageSelectForm.Create(nil);
    try
      if StorageSelectForm.ShowModal = mrCancel then exit;
      DestStorage := TElCustomCertStorage(StorageSelectForm.treeStorage.Selected.Data);
    finally
      FreeAndNil(StorageSelectForm);
    end;

    J := 0;
    while J < treeCert.Items.Count do
    begin
      if (treeCert.Items[J].Data = DestStorage) then
        break;
      inc(j);
    end;

    if (j < treeCert.Items.Count) and (treeCert.Items[J].Data = DestStorage) then
    begin
      DestStorage.Add(SourceCert);
      treeCert.Items.AddChildObject(treeCert.Items[J], treeCert.Selected.Text, SourceCert);
      result := true;
    end;
  end;
end;

procedure TSertX509.mmiExitClick(Sender: TObject);
begin
  Close;
end;

procedure TSertX509.treeCertChange(Sender: TObject; Node: TTreeNode);
begin
  // Disable all storages
  acNewMemStorage.Enabled := False;
  acNewFileStorage.Enabled := False;
  acMountStorage.Enabled := False;
  acUnmountStorage.Enabled := False;
  acImportFromWinStorage.Enabled := False;
  acSaveStorage.Enabled := False;
  acSaveStorageAs.Enabled := False;
  acExportToMemoryStorage.Enabled := False;
  acTrusted.Checked := False;
  acTrusted.Enabled := False;
  // Disable all certificates
  acNewCertificate.Enabled := False;
  acLoadCertificate.Enabled := False;
  acSaveCertificate.Enabled := False;
  acRemoveCertificate.Enabled := False;
  acValidate.Enabled := False;
  acLoadPrivateKey.Enabled := False;
  acMoveToStorage.Enabled := False;
  acCopyToStorage.Enabled := False;
  // Conditions check
  if (Node = nil) or (Node.Data = nil) then
  begin
    acNewMemStorage.Enabled := True;
    acNewFileStorage.Enabled := True;
    acMountStorage.Enabled := True;
    acImportFromWinStorage.Enabled := True;
    Storage := nil;
    GlobalCert := nil;
  end
  else
  begin
    if (TObject(Node.Data) is TElX509Certificate) then
    begin
      DisplayCertificateInfo(TElX509Certificate(Node.Data));
      acSaveStorageAs.Enabled := True;
      acExportToMemoryStorage.Enabled := True;
      acNewCertificate.Enabled := True;
      acLoadCertificate.Enabled := True;
      acSaveCertificate.Enabled := True;
      acRemoveCertificate.Enabled := True;
      acValidate.Enabled := True;
      acLoadPrivateKey.Enabled := True;
      acMoveToStorage.Enabled := True;
      acCopyToStorage.Enabled := True;
      Storage := treeCert.Selected.Parent.Data;
      GlobalCert := treeCert.Selected.Data;
      if not (TObject(Node.Parent.Data) is TElWinCertStorage) then
        acMoveToStorage.Enabled := True;
    end;
    if (TObject(Node.Data) is TElWinCertStorage) or (TObject(Node.Data) is TElFileCertStorage)
      or  (TObject(Node.Data) is TElMemoryCertStorage)then
    begin
      acSaveStorage.Enabled := True;
      acSaveStorageAs.Enabled := True;
      acExportToMemoryStorage.Enabled := True;
      acNewCertificate.Enabled := True;
      acLoadCertificate.Enabled := True;
      acTrusted.Enabled := True;
      acTrusted.Checked := Node.ImageIndex = 6; // Check for trusted storage
      Storage := treeCert.Selected.Data;
      GlobalCert := nil;
    end;
    if (TObject(Node.Data) is TElFileCertStorage)
      or  (TObject(Node.Data) is TElMemoryCertStorage) then  acUnmountStorage.Enabled := True;
  end;
  if ((Node <> nil) and (Node.Data <> nil) and
   (TObject(Node.Data) is TElX509Certificate)) then pcInfo.ActivePage:=tsCertificate
    else pcInfo.ActivePage:=tsNoInfo;
end;

procedure TSertX509.treeCertDeletion(Sender: TObject; Node: TTreeNode);
begin
  if (Node <> nil) and
     (TObject(Node.data) is TElX509Certificate) then
  begin
    if GlobalCert = Node.data then
      GlobalCert := nil;

    TObject(Node.Data).Free;
    Node.Data := nil;
  end;
end;

procedure TSertX509.acNewMemStorageExecute(Sender: TObject);
var MemoryStorage : TElMemoryCertStorage;
    S : String;
begin
  MemoryStorage := TElMemoryCertStorage.Create(self);
  Storage := MemoryStorage;
  S := 'Storage' + IntToStr(StorageNumber);
  Inc(StorageNumber);
  LoadStorage(treeCert.Items[0].Item[2], S, Storage);
end;

procedure TSertX509.acNewFileStorageExecute(Sender: TObject);
var FileStorage : TElFileCertStorage;
begin
  if (treeCert.Selected.Data = nil) and (SaveDlgStorage.Execute) then
  begin
    if Pos('.p7b',SaveDlgStorage.FileName) = 0 then
      SaveDlgStorage.FileName:=SaveDlgStorage.FileName + '.p7b';
    FileStorage := TElFileCertStorage.Create(nil);
    FileStorage.FileName := SaveDlgStorage.FileName;
    LoadStorage(treeCert.Items[0].Item[1],FileStorage.FileName, FileStorage);
  end;
end;

procedure TSertX509.acSaveStorageExecute(Sender: TObject);
begin
  if not Assigned(Storage) then exit;
  if Storage.Count = 0 then
  begin
    ShowMessage('This Storage is empty. Cannot save.');
    Exit;
  end;
  if Storage is TElFileCertStorage then
    TElFileCertStorage(Storage).SaveToFile(TElFileCertStorage(Storage).FileName)
  else
    acSaveStorageAsExecute(Self);
end;

procedure TSertX509.acSaveStorageAsExecute(Sender: TObject);
var TmpFileSt : TElFileCertStorage;
    Pwd : string;
    FileName : string;
    Stream : TFileStream;
begin
  if Storage.Count = 0 then
  begin
    ShowMessage('This Storage is empty. Cannot save.');
    Exit;
  end;
  if (treeCert.Selected.Data = nil) or (not Assigned(Storage)) then exit;
  if not SaveDlgStorage.Execute then exit;
  FileName := SaveDlgStorage.FileName;
  if SaveDlgStorage.FilterIndex = 1 then
  begin
    if lowercase(ExtractFileExt(FileName)) <> '.p7b' then
      FileName := FileName + '.p7b';

    if Storage is TElFileCertStorage then
         TElFileCertStorage(Storage).SaveToFile(FileName)
    else  begin
      TmpFileSt := TElFileCertStorage.Create(Self);
      Storage.ExportTo(TmpFileSt);
      TElFileCertStorage(TmpFileSt).SaveToFile(FileName);
      TmpFileSt.Free;
    end;
  end
  else begin
    if lowercase(ExtractFileExt(FileName)) <> '.pfx' then
      FileName := FileName + '.pfx';
    Pwd:='';
    if not (Storage is TElWinCertStorage) then
      if MessageDlg('Do you want to save private keys?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        if not InputQuery('Enter password', 'Enter password for private keys', Pwd) then exit;
     Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
     try
       Storage.SaveToStreamPFX(Stream, Pwd, SB_ALGORITHM_PBE_SHA1_3DES, SB_ALGORITHM_PBE_SHA1_RC2_40)
     finally
       Stream.Free;
     end;
  end;
end;

procedure TSertX509.acMountStorageExecute(Sender: TObject);
var FileStorage : TElFileCertStorage;
begin
  if (treeCert.Selected.Data = nil) and (OpenDlgStorage.Execute) then
  begin
    FileStorage := TElFileCertStorage.Create(nil);
    FileStorage.FileName := OpenDlgStorage.FileName;
    LoadStorage(treeCert.Items[0].Item[1], OpenDlgStorage.FileName, FileStorage);
  end;
end;

procedure TSertX509.acUnmountStorageExecute(Sender: TObject);
var I : integer;
begin
  if Assigned(Storage) then
    if (Storage is TElFileCertStorage) or
      (Storage is TElMemoryCertStorage) then
    begin
      treeCert.Selected.Delete;
      I := 0;
      while I < StorageList.Count do
      begin
        if StorageList.Items[I] = Storage then
        begin
          StorageList.Delete(I);
          Break;
        end;
        Inc(I);
      end;
    end;
end;

procedure TSertX509.acImportFromWinStorageExecute(Sender: TObject);
var S : string;
    TmpMemStorage : TElMemoryCertStorage;
    ClickedOk : Boolean;
begin
  S := 'ROOT';
  ClickedOk := InputQuery('Store name','Enter Windows store name', S);
  if not ClickedOk then exit;
  TmpMemStorage := TElMemoryCertStorage.Create(self);
  WinStorage1.SystemStores.Clear;
  sbStatus.Panels[0].Text := 'Loading Windows Certificates...';
  WinStorage1.SystemStores.Add(S);
  WinStorage1.ExportTo(TmpMemStorage);
  Storage := TmpMemStorage;
  S := 'Storage' + IntToStr(StorageNumber);
  Inc(StorageNumber);
  LoadStorage(treeCert.Items[0].Item[2], S, Storage);
end;

procedure TSertX509.acExportToMemoryStorageExecute(Sender: TObject);
var TmpMemStorage : TElMemoryCertStorage;
    I : integer;
    S : String;
begin
  if (treeCert.Selected.Data <> nil) then
  begin
    TmpMemStorage := TElMemoryCertStorage.Create(self);
    for I := 0 to StorageList.Count - 1 do
      if Storage = StorageList.Items[I] then
      begin
        if Storage is TElWinCertStorage then
        begin
          TElWinCertStorage(Storage).SystemStores.Clear;
          TElWinCertStorage(Storage).SystemStores.Add(CurrStorageName[I]);
        end;
        Storage.ExportTo(TmpMemStorage);
        Break;
      end;

    Storage := TmpMemStorage;
    S := 'Storage' + IntToStr(StorageNumber);
    Inc(StorageNumber);
    LoadStorage(treeCert.Items[0].Item[2], S, Storage);
  end;
end;

procedure TSertX509.acNewCertificateExecute(Sender: TObject);
begin
  TfrmGenerateCert.DoCreateCertificate;
end;

procedure TSertX509.acLoadCertificateExecute(Sender: TObject);
var S : string;
    Cert : TElX509Certificate;
    Pwd : string;
    Stream : TFileStream;
    FileName,
    KeyFileName : string;
    ti,Parent :  TTreeNode;
    R : integer;
begin
  if (treeCert.Selected = nil) or (treeCert.Selected.Data = nil) then exit;
  if  not (OpenDlgCert.Execute) then exit;
  FileName := OpenDlgCert.FileName;
  Pwd:='';
  Cert := TElX509Certificate.Create(nil);
  case OpenDlgCert.FilterIndex of
   1: begin
        Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          Cert.LoadFromStream(Stream);
        finally
          Stream.Free;
        end;
        KeyFileName := ChangeFileExt(FileName, '.der');
        if not FileExists(KeyFileName) then
          KeyFileName := ChangeFileExt(FileName, '.key');
        if FileExists(KeyFileName) then
        begin
          if (MessageDlg('Do you want to load private key?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          begin
            // Pwd := '';
            // if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;
            Stream := TFileStream.Create(KeyFileName, fmOpenRead or fmShareDenyWrite);
            try
              Cert.LoadKeyFromStream(Stream);
            finally
              Stream.Free;
            end;
          end;
        end;
      end;
   2: begin
        if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;
        Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          R := Cert.LoadFromStreamPEM(Stream, Pwd);
        finally
          Stream.Free;
        end;
        if R <> 0 then
        begin
          MessageDlg('Failed to load PEM certificate: error ' + IntToHex(R, 4),
            mtError, [mbOk], 0);
          Exit;
        end;
      end;
   3: begin
        if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;
        Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
        try
          R := Cert.LoadFromStreamPFX(Stream, Pwd);
        finally
          Stream.Free;
        end;
        if R <> 0 then
        begin
          MessageDlg('Failed to load PFX certificate: error ' + IntToHex(R, 4),
            mtError, [mbOk], 0);
          Exit;
        end;
      end;
    end; { case }

    Storage.Add(Cert);

    S := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_COMMON_NAME);
    if s = '' then
      s := GetOIDValue(Cert.SubjectRDN, SB_CERT_OID_ORGANIZATION);

    if TObject(treeCert.Selected.Data) is TElCustomCertStorage then
      Parent := treeCert.Selected
    else
      Parent := treeCert.Selected.Parent;

    ti:=treeCert.Items.AddChildObject(Parent, S, Cert);
    ti.ImageIndex:=3;
    ti.SelectedIndex:=3;

    GlobalCert := Cert;
end;

procedure TSertX509.acSaveCertificateExecute(Sender: TObject);
var S : string;
    FileName,
    KeyFileName : string;
    SavePvtKey : boolean;
    Pwd : string;
    Stream : TFileStream;
begin
  if (TObject(treeCert.Selected.Data) is TElX509Certificate) and
    (SaveDlgCert.Execute) then
  begin
    FileName := SaveDlgCert.FileName;
    S := ''; Pwd := '';
    if GlobalCert.PrivateKeyExists then
    begin
      SavePvtKey := true;
      if SaveDlgCert.FilterIndex = 1 then
        SavePvtKey := MessageDlg('Do you want to save private key?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes;
    end else SavePvtKey := False;

    if SavePvtKey then
      if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;

    if SaveDlgCert.FilterIndex = 1 then
    begin
      if lowercase(ExtractFileExt(FileName)) <> '.cer' then
        FileName := FileName + '.cer';
      Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
      try
        GlobalCert.SaveToStream(Stream);
      finally
        Stream.Free;
      end;

      if SavePvtKey and GlobalCert.PrivateKeyExists then
      begin
        KeyFileName := ChangeFileExt(FileName, '.key');
        Stream := TFileStream.Create(KeyFileName, fmCreate or fmShareDenyWrite);
        try
          GlobalCert.SaveKeyToStream(Stream);
        finally
          Stream.Free;
        end;
      end;
    end;
    // PEM format
    if SaveDlgCert.FilterIndex = 2 then
    begin
      if lowercase(ExtractFileExt(FileName)) <> '.pem' then
        FileName := FileName + '.pem';
      Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
      try
        GlobalCert.SaveToStreamPEM(Stream, '');
        if SavePvtKey then
          GlobalCert.SaveKeyToStreamPEM(Stream, Pwd);
      finally
        Stream.Free;
      end;
    end;
    // PFX format
    if SaveDlgCert.FilterIndex = 3 then
    begin
      if lowercase(ExtractFileExt(FileName)) <> '.pfx' then
        FileName := FileName + '.pfx';

      Stream := TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
      try
        GlobalCert.SaveToStreamPFX(Stream, Pwd, SB_ALGORITHM_PBE_SHA1_3DES, SB_ALGORITHM_PBE_SHA1_RC2_40);
      finally
        Stream.Free;
      end;
    end;
  end;
end;

procedure TSertX509.acRemoveCertificateExecute(Sender: TObject);
var I : integer;
begin
  if not Assigned(Storage) then exit;

  if (treeCert.Selected.Data <> nil) and
   (treeCert.Selected.Data = GlobalCert)
    and (treeCert.Selected.Parent.Data = Storage) then
  begin
    I := Storage.FindByHash(TElX509Certificate(treeCert.Selected.Data).GetHashSHA1);
    if i <> - 1 then
    begin
      treeCert.Selected.Delete;
      Storage.Remove(I);
    end;
  end;
end;

procedure TSertX509.acCreateCSRExecute(Sender: TObject);
begin
  TfrmGenerateCert.DoCreateCSR;
end;

procedure TSertX509.acValidateExecute(Sender: TObject);
var
  i : integer;
  TrustedList, NonTrustedList : TStringList;
  Item : TObject;
  Cert : TElX509Certificate;
begin
  if not (TObject(treeCert.Selected.Data) is TElX509Certificate) then exit;
  TrustedList := TStringList.Create();
  NonTrustedList := TStringList.Create();
  try
    Cert:=TElX509Certificate(treeCert.Selected.Data);
    for i:=0 to treeCert.Items.Count - 1 do
    try
      Item := TObject(treeCert.Items[i].Data);
      if (Item is TElWinCertStorage) or (Item is TElFileCertStorage)
       or  (Item is TElMemoryCertStorage) then
      begin
        if treeCert.Items[i].ImageIndex = 6 then
          TrustedList.AddObject(treeCert.Items[i].Text,Item)
        else
          NonTrustedList.AddObject(treeCert.Items[i].Text,Item);
      end;
    except end;
    TfrmValidate.ValidateCertificate(TrustedList, NonTrustedList, Cert);
  finally
    TrustedList.Free;
    NonTrustedList.Free;
  end;
end;

procedure TSertX509.acLoadPrivateKeyExecute(Sender: TObject);
var Stream : TFileStream;
    Cert : TElX509Certificate;
    Pwd  : string;
begin
  if (TObject(treeCert.Selected.Data) is TElX509Certificate) and
    (OpenDlgPvtKey.Execute) then
  begin
    Cert := TElX509Certificate(TObject(treeCert.Selected.Data));
    Pwd := '';
    if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;

    Stream := TFileStream.Create(OpenDlgPvtKey.Filename, fmOpenRead or fmShareDenyWrite);
    try
      if OpenDlgPvtKey.FilterIndex = 1 then
        Cert.LoadKeyFromStream(Stream)
      else  begin
        Pwd := '';
        if not InputQuery('Enter password', 'Enter password for private key', Pwd) then exit;
        Cert.LoadKeyFromStreamPEM(Stream, Pwd);
      end;
    finally
      Stream.Free;
    end;
    TreeCertChange(nil, TreeCert.Selected);
  end;
end;

procedure TSertX509.acMoveToStorageExecute(Sender: TObject);
var Item : TTreeNode;
begin
  Item := treeCert.Selected;
  if DoCopyToStorage then
    Item.Delete;
end;

procedure TSertX509.acCopyToStorageExecute(Sender: TObject);
begin
  DoCopyToStorage;
end;

procedure TSertX509.mmiAboutClick(Sender: TObject);
begin
  //TfrmAbout.ShowAboutBox
end;

procedure TSertX509.lvCertPropertiesChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var i : integer;
begin
  If not Assigned(Item) then exit;
  memAdditional.Lines.Clear;
  for i:=1 to Item.SubItems.Count - 1 do
    memAdditional.Lines.Add(Item.SubItems[i]);
end;

procedure TSertX509.acTrustedExecute(Sender: TObject);
begin
  try
    case treeCert.Selected.ImageIndex of
     2 : treeCert.Selected.ImageIndex := 6;
     6 : treeCert.Selected.ImageIndex := 2;
    end;
    treeCert.Selected.SelectedIndex := treeCert.Selected.ImageIndex;
  except end;
end;

initialization

  SBUtils.SetLicenseKey(
  '39D1A4C4B5EA1E1B45CCE5736EDCE79DBD2357577527F1F212B3ACF62BA283F4' +
  'E7AE4FF6D5684B782ABBBE3D25AFEC69E9E175B3EE14640B15F9907D2F6A31C6' + 
  'F24EE1241DE4F4C1E58632BAF362B73B8F8970B9B51A3669F7A9269A8CB75272' + 
  '346D5BA20745B7570C3DB7A3FD31A0B6C0609304ABEC4601B659B1E7388CA217' + 
  'AAD7B17286A4E6B706B6D4F52A547296353628C007244710D6A3EB3EB9A4392B' + 
  '1BB09A851C1CC94250730F2A1F5391D37870A1739120DD4D059C68F33DD011DF' + 
  'D9D7B99D7490E4C9BACAE17E0AF11E88D8062EE5648F630AF7DDD5EB2B725EF7' + 
  'E59519B1ACC410DCBD8130084546C3906DFE0DC82E8E66044EFFA80056251C24'

  );

end.
