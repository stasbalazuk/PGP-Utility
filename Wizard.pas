unit Wizard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Math, SBPGPKeys, SBPGPUtils, SBPGPConstants;

type
  TfrmWizard = class(TForm)
    pnlButtons: TPanel;
    bvlButtonsTop: TBevel;
    btnBack: TButton;
    btnNext: TButton;
    btnCancel: TButton;
    pnlStep1: TPanel;
    pnlStep1Top: TPanel;
    lblStep1Caption: TLabel;
    lblStep1Description: TLabel;
    bvlStep1Top: TBevel;

    pnlStep2: TPanel;
    pnlStep2Top: TPanel;
    lblStep2Caption: TLabel;
    lblStep2Description: TLabel;
    bvlStep2Top: TBevel;

    pnlStep3: TPanel;
    pnlStep3Top: TPanel;
    lblStep3Caption: TLabel;
    lblStep3Description: TLabel;
    bvlStep3Top: TBevel;

    pnlStep4: TPanel;
    pnlStep4Top: TPanel;
    lblStep4Caption: TLabel;
    lblStep4Description: TLabel;
    bvlStep4Top: TBevel;

    pnlStep5: TPanel;
    pnlStep5Top: TPanel;
    lblStep5Caption: TLabel;
    lblStep5Description: TLabel;
    bvlStep5Top: TBevel;

    pnlStep6: TPanel;
    pnlStep6Top: TPanel;
    lblStep6Caption: TLabel;
    lblStep6Description: TLabel;
    bvlStep6Top: TBevel;
    lblStep1Prompt: TLabel;
    btnFinish: TButton;
    lblStep2Prompt: TLabel;
    edtPassword: TEdit;
    lblPassword: TLabel;
    lblConfirmation: TLabel;
    edtConfirmation: TEdit;
    lblName: TLabel;
    edtName: TEdit;
    edtEMail: TEdit;
    lblEMail: TLabel;
    cmbKeyType: TComboBox;
    lblKeyType: TLabel;
    lblKeyExpiration: TLabel;
    rbtNever: TRadioButton;
    dtpExpirationDate: TDateTimePicker;
    rbtDate: TRadioButton;
    lblKeySize: TLabel;
    cmbKeySize: TComboBox;
    pbrProgress: TProgressBar;
    lblStep3Prompt: TLabel;
    tmrProgress: TTimer;
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlStep2Exit(Sender: TObject);
    procedure pnlStep2Enter(Sender: TObject);
    procedure pnlStep1Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure pnlStep3Enter(Sender: TObject);
    procedure rbtDateClick(Sender: TObject);
    procedure edtNameChange(Sender: TObject);
    procedure tmrProgressTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FStep: Integer;
    FCount: Integer;
    FSteps: array [1..6] of TPanel;
  public
    FCompleted: Boolean;
    FSecKey: TElPGPSecretKey;
  end;

  TKeyGenerationThread = class(TThread)
  private
    //FForm: TKeyWizardForm;
    FException: Exception;
    frmWizard: TfrmWizard;
    procedure RaiseException;
  protected
    procedure DoTerminate; override;
    constructor Create(AWizard: TfrmWizard);
    procedure Execute; override;
  end;

implementation

{$R *.DFM}

procedure TfrmWizard.FormCreate(Sender: TObject);
begin
  FStep := 1;
  FCount := 3;
  FSteps[1] := pnlStep1;
  FSteps[2] := pnlStep2;
  FSteps[3] := pnlStep3;
  FSteps[4] := pnlStep4;
  FSteps[5] := pnlStep5;
  FSteps[6] := pnlStep6;
  pnlStep1.Show;
end;

procedure TfrmWizard.FormShow(Sender: TObject);
begin
  cmbKeyType.ItemIndex := 1;
  cmbKeySize.ItemIndex := 1;
  dtpExpirationDate.Date := Date + 365;
  edtName.SetFocus;
end;

procedure TfrmWizard.btnBackClick(Sender: TObject);
begin
  if FStep = FCount then
    begin
      btnFinish.Hide;
      btnNext.Show;
    end;
  FSteps[FStep].Hide;
  Dec(FStep);
  FSteps[FStep].Show;
  if @FSteps[FStep].OnEnter <> nil then
    FSteps[FStep].OnEnter(nil);
  btnBack.Enabled := FStep > 1;
end;

procedure TfrmWizard.btnNextClick(Sender: TObject);
begin
  if @FSteps[FStep].OnExit <> nil then
    FSteps[FStep].OnExit(nil);
  FSteps[FStep].Hide;
  Inc(FStep);
  FSteps[FStep].Show;
  if FStep = FCount then
    begin
      btnFinish.Show;
      btnNext.Hide;
    end;
  btnBack.Enabled := FStep > 1;
  if @FSteps[FStep].OnEnter <> nil then
    FSteps[FStep].OnEnter(nil);
end;

procedure TfrmWizard.pnlStep1Enter(Sender: TObject);
begin
  edtName.SetFocus;
end;

procedure TfrmWizard.pnlStep2Enter(Sender: TObject);
begin
  edtPassword.SetFocus;
end;

procedure TfrmWizard.pnlStep2Exit(Sender: TObject);
begin
  if Sender = nil then
    begin
      if edtPassword.Text <> edtConfirmation.Text then
        raise Exception.Create('Password and confirmation not equal');
    end;
end;

procedure TfrmWizard.pnlStep3Enter(Sender: TObject);
begin
  tmrProgress.Enabled := True;
  btnBack.Enabled := False;
  btnFinish.Enabled := False;
  btnCancel.Enabled := False;
  TKeyGenerationThread.Create(Self);
end;

procedure TfrmWizard.rbtDateClick(Sender: TObject);
begin
  dtpExpirationDate.Enabled := rbtDate.Checked;
  if Sender = rbtDate then
    dtpExpirationDate.SetFocus;
end;

procedure TfrmWizard.edtNameChange(Sender: TObject);
begin
  btnNext.Enabled := edtName.Text <> '';
end;

procedure TfrmWizard.tmrProgressTimer(Sender: TObject);
begin
  if FCompleted then
    begin
      pbrProgress.Position := 100;
      tmrProgress.Enabled := False;
      btnBack.Enabled := True;
      btnFinish.Enabled := True;
      btnCancel.Enabled := True;
    end
  else
    pbrProgress.Position := (pbrProgress.Position + 5) mod 105;
end;

{ TKeyGenerationThread }

constructor TKeyGenerationThread.Create(AWizard: TfrmWizard);
begin
  inherited Create(True);
  frmWizard := AWizard;
  FreeOnTerminate := True;
  Resume;
end;

procedure TKeyGenerationThread.DoTerminate;
begin
  frmWizard.FCompleted := True;
  inherited;
end;

procedure TKeyGenerationThread.Execute;
var
  SecKey: TElPGPSecretKey;
  UserName: String;
  Bits, Expires: Integer;
begin
  try
    SecKey := TElPGPSecretKey.Create;
    UserName := frmWizard.edtName.Text;
    if frmWizard.edtEMail.Text <> '' then
      UserName := UserName + '<' + frmWizard.edtEMail.Text + '>';
      
    Bits := 1024 * Round(IntPower(2, frmWizard.cmbKeySize.ItemIndex));

    if frmWizard.rbtNever.Checked then
      Expires := 0
    else
      Expires := Round(frmWizard.dtpExpirationDate.Date - Date);
      
    if frmWizard.cmbKeyType.ItemIndex = 0 then
      begin
        SecKey.Generate(frmWizard.edtPassword.Text,
          Bits, SB_PGP_ALGORITHM_PK_RSA, UserName, False, Expires);
      end
    else
      begin
        SecKey.Generate(frmWizard.edtPassword.Text,
          1024, SB_PGP_ALGORITHM_PK_DSA,
          Bits, SB_PGP_ALGORITHM_PK_ELGAMAL_ENCRYPT, UserName, Expires);
      end;
      
    SecKey.Passphrase := frmWizard.edtPassword.Text;
    frmWizard.FSecKey := SecKey;
  except
    on E: Exception do
      begin
        FException := E;
        Synchronize(RaiseException);
      end;
  end;
end;

procedure TKeyGenerationThread.RaiseException;
begin
  Application.ShowException(FException);
end;

procedure TfrmWizard.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (FStep = 3) and not FCompleted then
    Action := caNone; 
end;

end.

