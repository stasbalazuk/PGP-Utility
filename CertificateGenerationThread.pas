unit CertificateGenerationThread;

interface

uses
  Classes, SBX509;

type
  TCertificateGenerationThread = class(TThread)
  private
    FCert : TElX509Certificate;
    FCACert : TElX509Certificate;    
    FAlg : integer;
    FDwords : integer;
  public
    constructor Create(CreateSuspended: Boolean); overload;
    constructor Create(CACert,Cert : TElX509Certificate; SignatureAlgorithm : integer;
      Dwords : integer); overload;
    destructor Destroy; override;
    procedure Execute; override;
    property Cert : TElX509Certificate read FCert;
  end;

implementation

constructor TCertificateGenerationThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
end;

destructor TCertificateGenerationThread.Destroy;
begin
  inherited;
end;

procedure TCertificateGenerationThread.Execute;
begin
  if not Assigned(FCACert) then
   FCert.Generate(FAlg, FDwords)
  else FCert.Generate(FCACert,FAlg,FDwords); 
end;

constructor TCertificateGenerationThread.Create(CACert,Cert : TElX509Certificate; SignatureAlgorithm : integer;
      Dwords : integer);
begin
  inherited Create(true);
  Self.FreeOnTerminate := true;
  FCert := Cert;
  FCACert := CACert;
  FAlg := SignatureAlgorithm;
  FDwords := Dwords;
end;

end.
