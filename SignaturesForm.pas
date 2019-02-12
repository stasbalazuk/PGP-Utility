unit SignaturesForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, SBPGP, SBPGPKeys, SBPGPStreams;

type
  TfrmSignatures = class(TForm)
    lvSignatures: TListView;
  private
    { Private declarations }
  public
    procedure Init(const Signatures: array of TElPGPSignature; const Validities: array of TSBPGPSignatureValidity; pgpKeyring: TElPGPKeyring); 
  end;

var
  frmSignatures: TfrmSignatures;

implementation

{$R *.DFM}

{ TfrmSignatures }

procedure TfrmSignatures.Init(const Signatures: array of TElPGPSignature;
  const Validities: array of TSBPGPSignatureValidity;
  pgpKeyring: TElPGPKeyring);
var
  i, Index: Integer;
  Item: TListItem;
  key: TElPGPCustomPublicKey;
  mainKey: TElPGPPublicKey;
  userID, sigVal: string;
begin
  Key := nil;

  lvSignatures.Items.Clear();
  for i := 0 to Length(Signatures) - 1 do
  begin
    item := lvSignatures.Items.Add();
    index := pgpKeyring.FindPublicKeyByID(Signatures[i].SignerKeyID(), key, 0);
    if (key <> nil) then
    begin
      if (key is SBPGPKeys.TElPGPPublicKey) then
        mainKey := SBPGPKeys.TElPGPPublicKey(key)
      else
        // retrieving supkey...
        mainKey := nil;

      if (mainKey <> nil) then
      begin
        if (mainKey.UserIDCount > 0) then
          userID := mainKey.UserIDs[0].Name
        else
          userID := 'No name';
      end
      else
        userID := 'Unknown Key';
    end
    else
      userID := 'Unknown Key';

    item.Caption := userID;
    case Validities[i] of
      svCorrupted:
        sigVal := 'Corrupted'; //Поврежденный

      svNoKey:
        sigVal := 'Signing key not found, unable to verify';

      svUnknownAlgorithm:
        sigVal := 'Unknown signing algorithm';

      svValid:
        sigVal := 'Valid';

    else
      sigVal := 'Unknown reason';
    end;

    item.SubItems.Add(sigVal);
  end;
end;

end.
