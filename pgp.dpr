program pgp;

uses
  Forms,
  SignEnc in 'SignEnc.pas' {SignEnc1},
  PGPEncFiles in 'PGPEncFiles.pas' {EncPGPFiles},
  MainForm in 'MainForm.pas' {EncSert},
  frmMain in 'frmMain.pas' {SertX509},
  GenerateCert in 'GenerateCert.pas' {frmGenerateCert},
  CertificateGenerationThread in 'CertificateGenerationThread.pas',
  SelectStorage in 'SelectStorage.pas' {StorageSelectForm},
  CountryList in 'CountryList.pas',
  AboutForm in 'AboutForm.pas' {frmAbout},
  ExtensionEncoder in 'ExtensionEncoder.pas',
  uValidate in 'uValidate.pas' {frmValidate},
  //..........................................
  keysgen in 'keysgen.pas' {frmKeys},
  Keyring in 'Keyring.pas' {frmSelectKeyring},
  Wizard in 'Wizard.pas' {frmWizard},
  Keys in 'Keys.pas' {frmPrivateKeys},
  PassphraseRequestForm in 'PassphraseRequestForm.pas' {frmPassphraseRequest},
  ImportKeyForm in 'ImportKeyForm.pas' {frmImportKey},
  //..........................................
  encfPGP in 'encfPGP.pas' {EncF},
  KeyringLoadForm in 'KeyringLoadForm.pas' {frmKeyringLoad},
  //..........................................
  decfPGP in 'decfPGP.pas' {frmMainForm},
  SignaturesForm in 'SignaturesForm.pas' {frmSignatures},
  //..........................................
  main in 'main.pas' {GenSertificate1},
  exportfrm in 'exportfrm.pas' {ExportForm},
  importfrm in 'importfrm.pas' {ImportForm},
  createfrm in 'createfrm.pas' {CreateCertForm},
  //..........................................
  PGPMail in 'PGPMail.pas' {mailPGP1},
  //..........................................
  SSHForm in 'SSHForm.pas' {GenSSH1},
  uGetPassword in 'uGetPassword.pas' {frmGetPassword},
  //..........................................
  DNSK in 'DNSK.pas' {DNSKeys1},
  //..........................................
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TEncF, EncF);
  Application.CreateForm(TfrmKeyringLoad, frmKeyringLoad);
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.CreateForm(TEncPGPFiles, EncPGPFiles);
  Application.CreateForm(TSignEnc1, SignEnc1);
  Application.CreateForm(TfrmSignatures, frmSignatures);
  Application.CreateForm(TGenSertificate1, GenSertificate1);
  Application.CreateForm(TmailPGP1, mailPGP1);
  Application.CreateForm(TGenSSH1, GenSSH1);
  Application.CreateForm(TfrmGetPassword, frmGetPassword);
  Application.CreateForm(TDNSKeys1, DNSKeys1); 
  Application.Run;
end.
