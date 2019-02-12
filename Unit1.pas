unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btn10: TButton;
    btn11: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn4Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure btn7Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btn8Click(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure btn10Click(Sender: TObject);
    procedure btn11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses frmMain, MainForm, keysgen, encfPGP, SignEnc, decfPGP, PGPEncFiles, main, PGPMail, SSHForm, DNSK,
  uGetPassword;

procedure CreateFormInRightBottomCorner;
var
 r : TRect;
begin
 SystemParametersInfo(SPI_GETWORKAREA, 0, Addr(r), 0);
 Form1.Left := r.Right-Form1.Width;
 Form1.Top := r.Bottom-Form1.Height;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  Application.CreateForm(tSertX509, SertX509);
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  Application.CreateForm(TEncSert, EncSert);
  EncSert.ShowModal;
end;

procedure TForm1.btn3Click(Sender: TObject);
begin
  Application.CreateForm(TfrmKeys, frmKeys);
  frmKeys.ShowModal;
end;

procedure TForm1.btn4Click(Sender: TObject);
begin
  EncF.ShowModal;
end;

procedure TForm1.btn5Click(Sender: TObject);
begin
  frmMainForm.ShowModal;
end;

procedure TForm1.btn6Click(Sender: TObject);
begin
  EncPGPFiles.ShowModal;
end;

procedure TForm1.btn7Click(Sender: TObject);
begin
  SignEnc1.ShowModal;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //CreateFormInRightBottomCorner;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  //CreateFormInRightBottomCorner;
end;

procedure TForm1.btn8Click(Sender: TObject);
begin
  GenSertificate1.ShowModal;
end;

procedure TForm1.btn9Click(Sender: TObject);
begin
  mailPGP1.ShowModal;
end;

procedure TForm1.btn10Click(Sender: TObject);
begin
  GenSSH1.ShowModal;
end;

procedure TForm1.btn11Click(Sender: TObject);
begin
  DNSKeys1.ShowModal;
end;

end.
