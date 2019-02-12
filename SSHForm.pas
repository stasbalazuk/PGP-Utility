
(******************************************************)
(*                                                    *)
(*            EldoS SecureBlackbox Library            *)
(*              SSH keys generation demo              *)
(*      Copyright (c) 2002-2009 EldoS Corporation     *)
(*           http://www.secureblackbox.com            *)
(*                                                    *)
(******************************************************)

unit SSHForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ImgList, ToolWin, StdCtrls, ExtCtrls, SBSSHKeyStorage, SBUtils;

type
  TGenSSH1 = class(TForm)
    rgAlgorithm: TRadioGroup;
    rgKeyFormat: TRadioGroup;
    tbTop: TToolBar;
    ilButtons: TImageList;
    tbGenerate: TToolButton;
    tbSavePrivate: TToolButton;
    tbSavePublic: TToolButton;
    tbExit: TToolButton;
    memPrivateKey: TMemo;
    lblPrivateKey: TLabel;
    lblPublicKey: TLabel;
    memPublicKey: TMemo;
    sdKeys: TSaveDialog;
    sbStatus: TStatusBar;
    Splitter1: TSplitter;
    pnlTop: TPanel;
    cbKeyLen: TComboBox;
    lblKeyLen: TLabel;
    lblSubject: TLabel;
    edtSubject: TEdit;
    lblComment: TLabel;
    edtComment: TEdit;
    tbLoadPrivate: TToolButton;
    tbLoadPublic: TToolButton;
    odKeys: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbSavePrivateClick(Sender: TObject);
    procedure tbSavePublicClick(Sender: TObject);
    procedure tbGenerateClick(Sender: TObject);
    procedure tbExitClick(Sender: TObject);
    procedure rgKeyFormatClick(Sender: TObject);
    procedure tbLoadPrivateClick(Sender: TObject);
    procedure tbLoadPublicClick(Sender: TObject);
  private
    FKey : TElSSHKey;  // Current key storage
    FKeyGenerated : boolean; // Check if current key generated
    function GetSaveFileName(DialogTitle : string) : boolean;
    function GetOpenFileName(DialogTitle : string) : boolean;
    procedure SetStatus(AStatus : string);
    procedure ShowStatus(Status : integer);
    procedure AllowKeySaving;
    procedure ShowKeys; // Show keys in memo
  public
    { Public declarations }
  end;

var
  GenSSH1: TGenSSH1;

implementation

uses uGetPassword;

{$R *.DFM}

procedure TGenSSH1.FormCreate(Sender: TObject);
begin
  FKey:=TElSSHKey.Create;
  FKeyGenerated:=False;
  cbKeyLen.ItemIndex:=2;
end;

procedure TGenSSH1.FormDestroy(Sender: TObject);
begin
  FKey.Free;
end;

function TGenSSH1.GetSaveFileName(DialogTitle: string): boolean;
begin
  Result:=False;
  sdKeys.Title:=DialogTitle;
  if not sdKeys.Execute then exit;
  Result:=True;
end;

procedure TGenSSH1.tbSavePrivateClick(Sender: TObject);
var Password : string;
begin
  If not FKeyGenerated then exit;
  If not GetSaveFileName('Select file name for private key') then exit;
  TfrmGetPassword.GetPassword(Password);
  FKey.SavePrivateKey(sdKeys.FileName,Password);
end;

procedure TGenSSH1.tbSavePublicClick(Sender: TObject);
begin
  If not FKeyGenerated then exit;
  If not GetSaveFileName('Select file name for public key') then exit;
  FKey.SavePublicKey(sdKeys.FileName);
end;

procedure TGenSSH1.tbGenerateClick(Sender: TObject);
var Bits, Status : integer;
begin
  // Algorithm
  case rgAlgorithm.ItemIndex of
  0 : FKey.Algorithm:=ALGORITHM_RSA;
  1 : FKey.Algorithm:=ALGORITHM_DSS;
  end; //case
  // KeyFormat
  case rgKeyFormat.ItemIndex of
  0 : FKey.KeyFormat:=kfOpenSSH;
  1 : FKey.KeyFormat:=kfIETF;
  2 : FKey.KeyFormat:=kfPuTTY;
  3 : FKey.KeyFormat:=kfX509;
  end; //case
  FKey.Comment:=edtComment.Text;
  FKey.Subject:=edtSubject.Text;
  try
    Bits:=StrToInt(cbKeyLen.Text);
  except SetStatus('Invalid key length'); exit; end;  
  // Generating keys
  SetStatus('Please wait...Generating key...');
  Status:=FKey.Generate(FKey.Algorithm,Bits);
  ShowStatus(Status);
  if Status <> 0 then exit;
  SetStatus('Keys generated');
  ShowKeys;
  AllowKeySaving;
end;

procedure TGenSSH1.SetStatus(AStatus: string);
begin
  sbStatus.SimpleText:=AStatus;
  Update;
  Application.ProcessMessages;
end;

procedure TGenSSH1.tbExitClick(Sender: TObject);
begin
  Close;
end;

procedure TGenSSH1.ShowStatus(Status: integer);
begin
  case Status of
   SB_ERROR_SSH_KEYS_INVALID_PUBLIC_KEY : SetStatus('SB_ERROR_SSH_KEYS_INVALID_PUBLIC_KEY');
   SB_ERROR_SSH_KEYS_INVALID_PRIVATE_KEY : SetStatus('SB_ERROR_SSH_KEYS_INVALID_PRIVATE_KEY');
   SB_ERROR_SSH_KEYS_FILE_READ_ERROR : SetStatus('SB_ERROR_SSH_KEYS_FILE_READ_ERROR');
   SB_ERROR_SSH_KEYS_FILE_WRITE_ERROR : SetStatus('SB_ERROR_SSH_KEYS_FILE_WRITE_ERROR');
   SB_ERROR_SSH_KEYS_UNSUPPORTED_ALGORITHM : SetStatus('SB_ERROR_SSH_KEYS_UNSUPPORTED_ALGORITHM');
   SB_ERROR_SSH_KEYS_INTERNAL_ERROR : SetStatus('SB_ERROR_SSH_KEYS_INTERNAL_ERROR');
   SB_ERROR_SSH_KEYS_BUFFER_TOO_SMALL : SetStatus('SB_ERROR_SSH_KEYS_BUFFER_TOO_SMALL');
   SB_ERROR_SSH_KEYS_NO_PRIVATE_KEY : SetStatus('SB_ERROR_SSH_KEYS_NO_PRIVATE_KEY');
   SB_ERROR_SSH_KEYS_INVALID_PASSPHRASE : SetStatus('SB_ERROR_SSH_KEYS_INVALID_PASSPHRASE');
   SB_ERROR_SSH_KEYS_UNSUPPORTED_PEM_ALGORITHM : SetStatus('SB_ERROR_SSH_KEYS_UNSUPPORTED_PEM_ALGORITHM');
  end; //case
end;

procedure TGenSSH1.rgKeyFormatClick(Sender: TObject);
begin
  edtSubject.Enabled:=rgKeyFormat.ItemIndex=1;
  If edtSubject.Enabled then edtSubject.Color:=clWindow
   else edtSubject.Color:=clGrayText;
end;

function TGenSSH1.GetOpenFileName(DialogTitle: string): boolean;
begin
  odKeys.Title:=DialogTitle;
  Result:=odKeys.Execute;
end;

procedure TGenSSH1.tbLoadPrivateClick(Sender: TObject);
var Status : integer;
    Password : string;
begin
  If not GetOpenFileName('Select private key') then exit;
  Status:=FKey.LoadPrivateKey(odKeys.FileName,Password);
  if Status <> 0 then
  begin
    Password:='';
    If not TfrmGetPassword.GetPassword(Password) then Password:='';
    Status:=FKey.LoadPrivateKey(odKeys.FileName,Password);
  end;  
  ShowStatus(Status);
  if Status=0 then
  begin
    ShowKeys;
    AllowKeySaving;
    SetStatus('Private key loaded.');
  end;
end;

procedure TGenSSH1.tbLoadPublicClick(Sender: TObject);
var Status : integer;
begin
  If not GetOpenFileName('Select public key') then exit;
  Status:=FKey.LoadPublicKey(odKeys.FileName);
  ShowStatus(Status);
  if Status=0 then
  begin
    ShowKeys;
    AllowKeySaving;
    SetStatus('Public key loaded.');
  end;
end;

procedure TGenSSH1.ShowKeys;
var KeySize : integer;
    Key : {$ifndef SB_UNICODE_VCL}string{$else}AnsiString{$endif};
begin
  KeySize:=0;
  FKey.SavePrivateKey(nil,KeySize);
  SetLength(Key,KeySize);
  FKey.SavePrivateKey(@Key[1],KeySize);
  SetLength(Key,KeySize);
  memPrivateKey.Lines.Text:=Key;
  KeySize:=0;
  FKey.SavePublicKey(nil,KeySize);
  SetLength(Key,KeySize);
  FKey.SavePublicKey(@Key[1],KeySize);
  SetLength(Key,KeySize);
  memPublicKey.Lines.Text:=Key;
  edtSubject.Text:=FKey.Subject;
  edtComment.Text:=FKey.Comment;
end;

procedure TGenSSH1.AllowKeySaving;
begin
  FKeyGenerated:=True;
  tbSavePublic.Enabled:=True;
  tbSavePrivate.Enabled:=True;
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
