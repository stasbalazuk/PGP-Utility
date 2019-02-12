unit Keyring;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSelectKeyring = class(TForm)
    lblPub: TLabel;
    lblSec: TLabel;
    edtPub: TEdit;
    btnPub: TButton;
    edtSec: TEdit;
    btnSec: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    OpenDlg: TOpenDialog;
    SaveDlg: TSaveDialog;
    procedure btnPubClick(Sender: TObject);
    procedure edtPubChange(Sender: TObject);
    procedure btnSecClick(Sender: TObject);
    procedure edtSecChange(Sender: TObject);
  private
  public
    OpenKeyring: Boolean;
    FChanging: Boolean;
    FNew: Boolean;
  end;

implementation

{$R *.dfm}


function TryFileName(BaseFileName, NewFileName: String; OpenKeyring: Boolean;
  var FoundFileName: String; ValidBaseName: String): Boolean;
var
  BaseValid: Boolean;
begin
  BaseValid := ExtractFileName(BaseFileName) = ValidBaseName;
  BaseFileName := ExtractFilePath(BaseFileName) + NewFileName;
  if OpenKeyring then
    begin
      Result := FileExists(BaseFileName);
      if Result then
        FoundFileName := BaseFileName;
    end
  else
    begin
      Result := BaseValid;
      FoundFileName := BaseFileName;
    end;
end;

function TryExtension(BaseFileName, NewExtension: String; OpenKeyring: Boolean;
  var FoundFileName: String): Boolean;
begin
  BaseFileName := ChangeFileExt(BaseFileName, NewExtension);
  if OpenKeyring then
    begin
      Result := FileExists(BaseFileName);
      if Result then
        FoundFileName := BaseFileName;
    end
  else
    begin
      Result := True;
      FoundFileName := BaseFileName;
    end;
end;

function FindKeyRingPair(FileName: string; IsPublic: Boolean; OpenKeyring: Boolean;
  var PubFileName, SecFileName: string): Boolean;
begin
  Result := True;
  if not OpenKeyring and (ExtractFileExt(FileName) = '') then
    if IsPublic then
      FileName := ChangeFileExt(FileName, '.pkr')
    else
      FileName := ChangeFileExt(FileName, '.skr');
      
  PubFileName := '';
  SecFileName := '';
  if IsPublic then
    PubFileName := FileName
  else
    SecFileName := FileName;
    
  if Result then
    begin
      if PubFileName <> '' then
        begin
          if TryFileName(PubFileName, 'secring.skr', OpenKeyring, FileName, 'pubring.pkr') or
            TryFileName(PubFileName, 'secring.seckr', OpenKeyring, FileName, 'pubring.pubkr') or
            TryFileName(PubFileName, 'secring.pgp', OpenKeyring, FileName, 'pubring.pgp') or
            TryExtension(PubFileName, '.skr', OpenKeyring, FileName) or
            TryExtension(PubFileName, '.seckr', OpenKeyring, FileName) then
            SecFileName := FileName;
        end
      else
        begin
          if TryFileName(PubFileName, 'pubring.pkr', OpenKeyring, FileName, 'secring.skr') or
            TryFileName(PubFileName, 'pubring.pubkr', OpenKeyring, FileName, 'secring.seckr') or
            TryFileName(PubFileName, 'pubring.pgp', OpenKeyring, FileName, 'secring.pgp') or
            TryExtension(PubFileName, '.pkr', OpenKeyring, FileName) or
            TryExtension(PubFileName, '.pubkr', OpenKeyring, FileName) then
            PubFileName := FileName;
        end;
        
      Result := PubFileName <> '';
    end;
end;

procedure TfrmSelectKeyring.btnPubClick(Sender: TObject);
begin
  if OpenKeyring then
  begin
    OpenDlg.Filter := 'Public keyring files (*.pkr;*.pubkr;*.pgp)|*.pkr;*.pubkr;*.pgp|All files(*.*)|*.*';
    OpenDlg.FilterIndex := 1;
    OpenDlg.DefaultExt := '.pkr';
    OpenDlg.Title := 'Select public keyring file';
    OpenDlg.FileName := edtPub.Text;
    if OpenDlg.Execute then
      edtPub.Text := OpenDlg.FileName;
  end
  else
  begin
    SaveDlg.Filter := 'Public keyring files (*.pkr;*.pubkr;*.pgp)|*.pkr;*.pubkr;*.pgp|All files(*.*)|*.*';
    SaveDlg.FilterIndex := 1;
    SaveDlg.DefaultExt := '.pkr';
    SaveDlg.Title := 'Select public keyring file';
    SaveDlg.FileName := edtPub.Text;
    if SaveDlg.Execute then
      edtPub.Text := SaveDlg.FileName;
  end;
end;

procedure TfrmSelectKeyring.btnSecClick(Sender: TObject);
begin
  if OpenKeyring then
  begin
    OpenDlg.Filter := 'Private keyring files (*.skr;*.prvkr;*.pgp)|*.skr;*.prvkr;*.pgp|All files(*.*)|*.*';
    OpenDlg.FilterIndex := 1;
    OpenDlg.DefaultExt := '.skr';
    OpenDlg.Title := 'Select private keyring file';
    OpenDlg.FileName := edtSec.Text;
    if OpenDlg.Execute then
      edtSec.Text := OpenDlg.FileName;
  end
  else
  begin
    SaveDlg.Filter := 'Private keyring files (*.skr;*.prvkr;*.pgp)|*.skr;*.prvkr;*.pgp|All files(*.*)|*.*';
    SaveDlg.FilterIndex := 1;
    SaveDlg.DefaultExt := '.skr';
    SaveDlg.Title := 'Select private keyring file';
    SaveDlg.FileName := edtSec.Text;
    if SaveDlg.Execute then
      edtSec.Text := SaveDlg.FileName;
  end;
end;

procedure TfrmSelectKeyring.edtPubChange(Sender: TObject);
{var
  PubFileName, SecFileName: String;}
begin
{  if not FChanging and FindKeyRingPair(edtPub.Text, True, OpenKeyring, PubFileName,
    SecFileName) then
    begin
      FChanging := True;
      try
        edtSec.Text := SecFileName;
      finally
        FChanging := False;
      end;
    end;}

  btnOK.Enabled := edtPub.Text <> '';
end;

procedure TfrmSelectKeyring.edtSecChange(Sender: TObject);
{var
  PubFileName, SecFileName: String;}
begin
{  if not FChanging and FindKeyRingPair(edtSec.Text, False, OpenKeyring, PubFileName,
    SecFileName) then
    begin
      FChanging := True;
      try
        edtPub.Text := PubFileName;
      finally
        FChanging := False;
      end;
    end;}

  btnOK.Enabled := edtPub.Text <> '';
end;

end.
