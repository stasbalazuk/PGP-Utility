unit uGetPassword;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmGetPassword = class(TForm)
    imgKeys: TImage;
    edPassword: TEdit;
    lblPassword: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    class function GetPassword(var Pwd : string) : boolean;
  end;

var
  frmGetPassword: TfrmGetPassword;


implementation

{$R *.DFM}
class function TfrmGetPassword.GetPassword(var Pwd : string) : boolean;
begin
  Result:=False; Pwd:='';
  If not Assigned(frmGetPassword) then
   Application.CreateForm(TfrmGetPassword,frmGetPassword);
  If not Assigned(frmGetPassword) then exit;
  If frmGetPassword.ShowModal=mrOk then
  begin
    Result:=True;
    Pwd:=frmGetPassword.edPassword.Text;
  end else Result:=False;
  frmGetPassword.Free;
  frmGetPassword:=nil;
end;

procedure TfrmGetPassword.FormActivate(Sender: TObject);
begin
  edPassword.Text:='';
  FocusControl(edPassword);
end;

procedure TfrmGetPassword.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If Key=VK_RETURN then btnOk.Click;
  If Key=VK_ESCAPE then btnCancel.Click;
end;

end.
