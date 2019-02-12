(******************************************************)
(*                                                    *)
(*            EldoS SecureBlackbox Library            *)
(*                                                    *)
(*      Copyright (c) 2002-2007 EldoS Corporation     *)
(*           http://www.secureblackbox.com            *)
(*                                                    *)
(******************************************************)

unit SBPGPMIME;

{$I SecBbox.inc}

interface

uses
  SysUtils,
  Classes,
  SBUtils,
  SBMIME,
  SBMIMETypes,
  SBMIMEStream,
  SBMIMEUtils,
  SBSimpleMIME,
  SBPGPConstants,
  SBPGPKeys,
  SBPGP,
  SBPGPUtils,
  SBPGPStreams;



type
  TSBPGPMIMEType = (pmtUnknown, pmtSigned, pmtEncrypted, pmtSignedEncrypted);
  TSBPGPMIMEError = (pmeUnknown, pmePGPPartNotFound, pmeInvalidSignature,
    pmeUnverifiableSignature, pmeRecipientKeyNotFound, pmeSenderKeyNotFound,
    pmeNoRecipients, pmeNoSigners, pmeActionNotSelected);
  TSBPGPMIMEErrors = set of TSBPGPMIMEError;

  TSBPGPKeysError = (pkeUnknown, pkeKeysPartNotFound, pkeNoPublicKeys);
  TSBPGPKeysErrors = set of TSBPGPKeysError;
  TSBPGPKeyNotFoundEvent = procedure(Sender: TObject; Address: TElMailAddress;
    var ExcludeFromList: boolean) of object;

  TElMessagePartHandlerPGPMime = class;
  ElMessagePartHandlerPGPMime = TElMessagePartHandlerPGPMime;

  TElMessagePartHandlerPGPMime = class(TElMessagePartHandler)
  private
    FDecryptingKeys : TElPGPKeyring;
    FVerifyingKeys : TElPGPKeyring;
    FEncryptingKeys : TElPGPKeyring;
    FSigningKeys : TElPGPKeyring;
    FEncrypt : boolean;
    FSign : boolean;
    FCompress: boolean;
    FSigned : boolean;
    FEncrypted : boolean;
    FErrors : TSBPGPMIMEErrors;
    FType : TSBPGPMIMEType;
    FBoundary : AnsiString;
    FDecryptedPart: TElMessagePart;
    FReaderOutputStream: TMemoryStream;
    FOnEncrypted : TSBPGPEncryptedEvent;
    FOnSigned : TSBPGPSignedEvent;
    FOnKeyPassphrase: TSBPGPKeyPassphraseEvent;
    FOnPassphrase : TSBPGPPassphraseEvent;
    FOnSignatures : TSBPGPSignaturesEvent;
    FOnEncryptingKeyNotFound : TSBPGPKeyNotFoundEvent;
    FOnSigningKeyNotFound : TSBPGPKeyNotFoundEvent;
    FAssemblingOuterHeaders: boolean;
    FInternalKeyrings : array[0..1] of TElPGPKeyring;
    FIgnoreHeaderRecipients : boolean;
    FIgnoreHeaderSigners : boolean;
    FCompressionAlgorithm: integer;
    FCompressionLevel: integer;
    FHashAlgorithm: integer;
    FSymmetricKeyAlgorithm: TSBPGPSymmetricKeyAlgorithm;
    FUseNewFeatures: boolean;
    FUseOldPackets: boolean;
    FProtection : TSBPGPProtectionType;
    FEncryptionType : TSBPGPEncryptionType;
    FPassphrases : TElStringList;

    procedure SetPassphrases(Value : TStringList);

    procedure SetDecryptingKeys(Value: TElPGPKeyring);
    procedure SetVerifyingKeys(Value: TElPGPKeyring);
    procedure SetEncryptingKeys(Value: TElPGPKeyring);
    procedure SetSigningKeys(Value: TElPGPKeyring);
    procedure HandleReaderEncrypted(Sender: TObject; const KeyIDs : TSBKeyIDs;
      IntegrityProtected: boolean; PassphraseUsed: boolean);
    procedure HandleReaderCreateOutputStream(Sender: TObject; const Filename : string;
      TimeStamp: TDateTime; var Stream: TStream; var FreeOnExit: boolean);
    procedure HandleReaderKeyPassphrase(Sender: TObject;
      Key : TElPGPCustomSecretKey; var Passphrase: string; var Cancel: boolean);
    procedure HandleReaderPassphrase(Sender: TObject;
      var Passphrase: string; var Cancel : boolean);
    procedure HandleReaderSigned(Sender: TObject;
      const KeyIDs : TSBKeyIDs; SignatureType : TSBPGPSignatureType);
    {$ifndef BUILDER_USED}
    procedure HandleReaderSignatures(Sender: TObject;
      Signatures: array of TElPGPSignature; Validities : array of TSBPGPSignatureValidity);
    {$else}
    procedure HandleReaderSignatures(Sender: TObject;
      Signatures: TList; Validities : array of TSBPGPSignatureValidity);
    {$endif}
    procedure HandleWriterKeyPassphrase(Sender: TObject;
      Key : TElPGPCustomSecretKey; var Passphrase: string; var Cancel: boolean);
  protected
    class function IsText(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsTextPlain(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsMultipart(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsSupportedThisContentType(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    procedure Clear; override;
    function Clone: TElMessagePartHandler; override;
    function OnAssemble(Destination: TAnsiStringStream;
      const Charset: AnsiString; HeaderEncoding: TElHeaderEncoding;
      const BodyEncoding, AttachEncoding: AnsiString;
      State: TElOnAssembleState; Item: Integer; const sBoundary: AnsiString;
      var bIsHandled, bStopAssemble: Boolean
    ): ELMIMERESULT; override;
    function OnParse(Source: TElNativeStream;
      const Boundary, HeaderCharset, BodyCharset: AnsiString;
      AOptions: TElMessageParsingOptions; IgnoreHeaderNativeCharset,
      IgnoreBodyNativeCharset, bActivatePartHandlers: Boolean;
      State: TElOnParseState; Item: Integer;
      var bIsHandled, bStopParse: Boolean
    ): ELMIMERESULT; override;
    procedure SetError; override;
    function DecodePGPMime( const HeaderCharset,
      BodyCharset: AnsiString; AOptions: TElMessageParsingOptions;
      IgnoreHeaderNativeCharset, IgnoreBodyNativeCharset: Boolean;
      bActivatePartHandlers: Boolean {$ifdef HAS_DEF_PARAMS}= False{$endif};
      RootHandler: TElMessagePartHandlerPGPMime {$ifdef HAS_DEF_PARAMS}= nil {$endif}): Boolean;


  public
    class function GetDescription: TWideString; override;
    constructor Create(aParams: TObject); override;
    destructor Destroy; override;

    function IsSigned : boolean;
    function IsEncrypted : boolean;
    property Encrypt : boolean read FEncrypt write FEncrypt default true;
    property Sign : boolean read FSign write FSign default false;
    property Compress: boolean read FCompress write FCompress default false;
    property IgnoreHeaderRecipients: boolean read FIgnoreHeaderRecipients
      write FIgnoreHeaderRecipients default false;
    property IgnoreHeaderSigners: boolean read FIgnoreHeaderSigners
      write FIgnoreHeaderSigners default false;
    property DecryptingKeys : TElPGPKeyring read FDecryptingKeys write SetDecryptingKeys;
    property VerifyingKeys : TElPGPKeyring read FVerifyingKeys write SetVerifyingKeys;
    property EncryptingKeys : TElPGPKeyring read FEncryptingKeys write SetEncryptingKeys;
    property SigningKeys : TElPGPKeyring read FSigningKeys write SetSigningKeys;

    property EncryptionType : TSBPGPEncryptionType read FEncryptionType write FEncryptionType;
    property Passphrases : TStringList read FPassphrases write SetPassphrases;
    property Protection : TSBPGPProtectionType read FProtection write FProtection default ptNormal;

    property CompressionAlgorithm: integer read FCompressionAlgorithm write
      FCompressionAlgorithm;
    property CompressionLevel : integer read FCompressionLevel write FCompressionLevel;
    property HashAlgorithm: integer read FHashAlgorithm write FHashAlgorithm;
    property SymmetricKeyAlgorithm: TSBPGPSymmetricKeyAlgorithm read
        FSymmetricKeyAlgorithm write FSymmetricKeyAlgorithm;
    property UseNewFeatures: boolean read FUseNewFeatures write FUseNewFeatures;
    property UseOldPackets: boolean read FUseOldPackets write FUseOldPackets;

    property OnEncrypted : TSBPGPEncryptedEvent read FOnEncrypted write FOnEncrypted;
    property OnSigned : TSBPGPSignedEvent read FOnSigned write FOnSigned;
    property OnKeyPassphrase : TSBPGPKeyPassphraseEvent read FOnKeyPassphrase
      write FOnKeyPassphrase;
    property OnPassphrase: TSBPGPPassphraseEvent read FOnPassphrase
      write FOnPassphrase;
    property OnSignatures : TSBPGPSignaturesEvent read FOnSignatures
      write FOnSignatures;
    property OnEncryptingKeyNotFound : TSBPGPKeyNotFoundEvent read
      FOnEncryptingKeyNotFound write FOnEncryptingKeyNotFound;
    property OnSigningKeyNotFound : TSBPGPKeyNotFoundEvent read
      FOnSigningKeyNotFound write FOnSigningKeyNotFound;
  end;

  TElMessagePartHandlerPGPKeys = class;
  ElMessagePartHandlerPGPKeys = TElMessagePartHandlerPGPKeys;

  TElMessagePartHandlerPGPKeys = class(TElMessagePartHandler)
  private
    FKeys : TElPGPKeyring;
    FErrors : TSBPGPKeysErrors;
  protected
    class function IsText(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsTextPlain(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsMultipart(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    class function IsSupportedThisContentType(const wsContentType: TWideString;
      ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean; override;
    procedure Clear; override;
    function Clone: TElMessagePartHandler; override;
    function OnAssemble(Destination: TAnsiStringStream;
      const Charset: AnsiString; HeaderEncoding: TElHeaderEncoding;
      const BodyEncoding, AttachEncoding: AnsiString;
      State: TElOnAssembleState; Item: Integer; const sBoundary: AnsiString;
      var bIsHandled, bStopAssemble: Boolean
    ): ELMIMERESULT; override;
    function OnParse(Source: TElNativeStream;
      const Boundary, HeaderCharset, BodyCharset: AnsiString;
      AOptions: TElMessageParsingOptions; IgnoreHeaderNativeCharset,
      IgnoreBodyNativeCharset, bActivatePartHandlers: Boolean;
      State: TElOnParseState; Item: Integer;
      var bIsHandled, bStopParse: Boolean
    ): ELMIMERESULT; override;
    function DecodeKeys : boolean;
    procedure SetError; override;


  public
    class function GetDescription: TWideString; override;
    constructor Create(aParams: TObject); override;
    destructor Destroy; override;

    property Keys : TElPGPKeyring read FKeys;
  end;

  TElSimplePGPMIMEOptions = class;
  ElSimplePGPMIMEOptions = TElSimplePGPMIMEOptions;

  TElSimplePGPMIMEOptions = class(TPersistent)
  protected
    FCompressMessage : boolean;
    FEncryptMessage : boolean;
    FIgnoreHeaderRecipients: boolean;
    FIgnoreHeaderSigners: boolean;
    FSignMessage : boolean;
    FHashAlgorithm : integer;
    FCompressionAlgorithm : integer;
    FCompressionLevel : integer;
    FSymmetricKeyAlgorithm: TSBPGPSymmetricKeyAlgorithm;
    FUseOldPackets : boolean;
    FUseNewFeatures : boolean;
    FProtection : TSBPGPProtectionType;
    FEncryptionType : TSBPGPEncryptionType;
    FPassphrases : TStringList;

    procedure SetPassphrases(Value : TStringList);
    
  public
    procedure Assign(Source : TPersistent); override;
    constructor Create;
    destructor Destroy; override;
  published
    property EncryptionType : TSBPGPEncryptionType read FEncryptionType write FEncryptionType;
    property Passphrases : TStringList read FPassphrases write SetPassphrases;
    property Protection : TSBPGPProtectionType read FProtection write FProtection default ptNormal;

    property HashAlgorithm : integer read FHashAlgorithm write FHashAlgorithm;
    property CompressionAlgorithm : integer read FCompressionAlgorithm write FCompressionAlgorithm;
    property CompressionLevel : integer read FCompressionLevel write FCompressionLevel;
    property SymmetricKeyAlgorithm: TSBPGPSymmetricKeyAlgorithm read FSymmetricKeyAlgorithm
      write FSymmetricKeyAlgorithm default SB_PGP_ALGORITHM_SK_CAST5;
    property UseOldPackets : boolean read FUseOldPackets write FUseOldPackets default false;
    property UseNewFeatures : boolean read FUseNewFeatures write FUseNewFeatures default true;
    property CompressMessage: boolean read FCompressMessage write FCompressMessage;
    property EncryptMessage : boolean read FEncryptMessage write FEncryptMessage;
    property IgnoreHeaderRecipients: boolean read FIgnoreHeaderRecipients write
      FIgnoreHeaderRecipients;
    property IgnoreHeaderSigners: boolean read FIgnoreHeaderSigners write
      FIgnoreHeaderSigners;
    property SignMessage : boolean read FSignMessage write FSignMessage;
  end;


  TElSimplePGPMIMEMessage = class;
  ElSimplePGPMIMEMessage = TElSimplePGPMIMEMessage;

  TElSimplePGPMIMEMessage = class(TElSimpleMIMEMessage)
  protected
    FEncryptingKeys: TElPGPKeyring;
    FSigningKeys: TElPGPKeyring;
    FOnEncryptingKeyNotFound: TSBPGPKeyNotFoundEvent;
    FOnKeyPassphrase: TSBPGPKeyPassphraseEvent;
    FOnSigningKeyNotFound: TSBPGPKeyNotFoundEvent;
    FPGPMIMEOptions: TElSimplePGPMIMEOptions;
    procedure SetEncryptingKeys(Value: TElPGPKeyring);
    procedure SetSigningKeys(Value: TElPGPKeyring);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function DoAssemble(Stream: TStream): Integer; override;

    procedure SetPGPMIMEOptions(const Value: TElSimplePGPMIMEOptions);
  public
    constructor Create(AOwner: TSBComponentBase); override;
    destructor Destroy; override;
  published
    property EncryptingKeys: TElPGPKeyring read FEncryptingKeys write
        SetEncryptingKeys;
  property PGPMIMEOptions: TElSimplePGPMIMEOptions read FPGPMIMEOptions write
      SetPGPMIMEOptions;
    property SigningKeys: TElPGPKeyring read FSigningKeys write SetSigningKeys;
    property OnEncryptingKeyNotFound: TSBPGPKeyNotFoundEvent read
        FOnEncryptingKeyNotFound write FOnEncryptingKeyNotFound;
    property OnKeyPassphrase: TSBPGPKeyPassphraseEvent read FOnKeyPassphrase write
        FOnKeyPassphrase;
    property OnSigningKeyNotFound: TSBPGPKeyNotFoundEvent read
        FOnSigningKeyNotFound write FOnSigningKeyNotFound;
  end;

  EElPGPMIMEException =  class(ElMimePartHandlerException);

procedure Initialize; 

implementation

////////////////////////////////////////////////////////////////////////////////
// TElMessagePartHandlerPGPMime class

constructor TElMessagePartHandlerPGPMime.Create(aParams: TObject);
begin
  inherited Create(aParams);
  FReaderOutputStream := TMemoryStream.Create;
  FInternalKeyrings[0] := TElPGPKeyring.Create(nil);
  FInternalKeyrings[1] := TElPGPKeyring.Create(nil);
  FPassphrases := TElStringList.Create;
  FEncryptionType := etPublicKey;
  FProtection := ptNormal;
  FSymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_CAST5;
  Clear;
end;

destructor TElMessagePartHandlerPGPMime.Destroy;
begin
  FReaderOutputStream.Free;
  FInternalKeyrings[0].Free;
  FInternalKeyrings[1].Free;
  FPassphrases.Free;
  inherited;
end;

procedure TElMessagePartHandlerPGPMime.Clear;
begin
  inherited;
  FEncrypt := true;
  FSign := false;
  FType := pmtUnknown;
  FErrors := [];
  FSigned := false;
  FEncrypted := false;
  FSign := false;
  FEncrypt := false;
  FCompress := false;
  FReaderOutputStream.Clear;
  FInternalKeyrings[0].Clear;
  FInternalKeyrings[1].Clear;
  FIgnoreHeaderRecipients := false;
  FIgnoreHeaderSigners := false;
end;

function TElMessagePartHandlerPGPMime.Clone: TElMessagePartHandler;
var
  ph : TElMessagePartHandlerPGPMIME;
begin
  ph := TElMessagePartHandlerPGPMime.Create(nil);
  Result := ph;
  ph.FDecryptingKeys := FDecryptingKeys;
  ph.FVerifyingKeys := FVerifyingKeys;
  ph.FEncryptingKeys := FEncryptingKeys;
  ph.FSigningKeys := FSigningKeys;
  ph.FEncrypt := FEncrypt;
  ph.FSign := FSign;
  ph.FCompress := FCompress;
  ph.FSigned := FSigned;
  ph.FEncrypted := FEncrypted;
  ph.FType := FType;
  ph.FBoundary := FBoundary;
  ph.FErrors := FErrors;
  ph.FIgnoreHeaderRecipients := FIgnoreHeaderRecipients;
  ph.FIgnoreHeaderSigners := FIgnoreHeaderSigners;
  if Assigned(FDecryptedPart) then
    ph.FDecryptedPart := FDecryptedPart.Clone;
end;

function TElMessagePartHandlerPGPMime.OnAssemble(Destination: TAnsiStringStream;
  const Charset: AnsiString; HeaderEncoding: TElHeaderEncoding;
  const BodyEncoding, AttachEncoding: AnsiString;
  State: TElOnAssembleState; Item: Integer; const sBoundary: AnsiString;
  var bIsHandled, bStopAssemble: Boolean
): ELMIMERESULT;
var
  h: TElMessageHeaderField;

  function FindEncryptingKeyByAddress(const Address: string): TElPGPPublicKey;
  var
    Index: integer;
  begin
    Result := nil;
    Index := -1;
    repeat
      Index := FEncryptingKeys.FindPublicKeyByEmailAddress(Address, Index + 1);
      if (Index >= 0) then
      begin
        if FEncryptingKeys.PublicKeys[Index].IsEncryptingKey(true) then
        begin
          Result := FEncryptingKeys.PublicKeys[Index];
          Break;
        end;
      end;
    until Index = -1;
  end;

  function FindSigningKeyByAddress(const Address: string): TElPGPSecretKey;
  var
    Index: integer;
  begin
    Result := nil;
    Index := -1;
    repeat
      Index := FSigningKeys.FindSecretKeyByEmailAddress(Address, Index + 1);
      if Index >= 0 then
      begin
        if FSigningKeys.SecretKeys[Index].IsSigningKey(true) then
        begin
          Result := FSigningKeys.SecretKeys[Index];
          Break;
        end;
      end;
    until Index = -1;
  end;

  function CheckRecipientKeysForAvailability(List : TElMailAddressList; Storage:
    TElPGPKeyring) : boolean;
  var
    PublicKey : TElPGPPublicKey;
    I : integer;
    Exclude : boolean;
  begin
    Result := true;
    for I := 0 to List.Count - 1 do
    begin
      PublicKey := FindEncryptingKeyByAddress(List.GetAddress(I).Address);
      if PublicKey = nil then
      begin
        Exclude := false;
        if Assigned(FOnEncryptingKeyNotFound) then
          FOnEncryptingKeyNotFound(Self, List.GetAddress(I),
            Exclude);
        if not Exclude then
        begin
          Result := false;
          Break;
        end;
      end
      else
        Storage.AddPublicKey(PublicKey);
    end;
  end;

  function CheckSenderKeysForAvailability(List : TElMailAddressList; Storage:
    TElPGPKeyring) : boolean;
  var
    SecretKey : TElPGPSecretKey;
    I : integer;
    Exclude : boolean;
  begin
    Result := true;
    for I := 0 to List.Count - 1 do
    begin
      SecretKey := FindSigningKeyByAddress(List.GetAddress(I).Address);
      if SecretKey = nil then
      begin
        Exclude := false;
        if Assigned(FOnSigningKeyNotFound) then
          FOnSigningKeyNotFound(Self, List.GetAddress(I),
            Exclude);
        if not Exclude then
        begin
          Result := false;
          Break;
        end;
      end
      else
        Storage.AddSecretKey(SecretKey);
    end;
  end;

  procedure Encrypt;
  var
    Writer : TElPGPWriter;
    Dest : TAnsiStringStream;
    Hdr : AnsiString;
    EncKeyring : TElPGPKeyring;
  const
    Boundary = 'PGP MESSAGE';
    BodyStub = 'This is an OpenPGP/MIME encrypted message (RFC 2440 and 3156)'#13#10;
    VersionPart = 'Content-Type: application/pgp-encrypted'#13#10'Content-Description: PGP/MIME version identification'#13#10#13#10'Version: 1'#13#10#13#10;
    EncPartHeaders = 'Content-Type: application/octet-stream; name="encrypted.asc"'#13#10'Content-Description: OpenPGP encrypted message'#13#10'Content-Disposition: inline; filename="encrypted.asc"'#13#10#13#10;
  begin
    if not FIgnoreHeaderRecipients then
    begin
      if FElMessagePart.ParentMessage = nil then
      begin
        FErrors := FErrors + [pmeNoRecipients];
        Exit;
      end;
      FInternalKeyrings[0].Clear;
      if (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.To_,
        FInternalKeyrings[0])) or
        (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.CC,
        FInternalKeyrings[0])) or
        (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.BCC,
        FInternalKeyrings[0])) then
      begin
        FErrors := FErrors + [pmeRecipientKeyNotFound];
        Exit;
      end;
      EncKeyring := FInternalKeyrings[0];
    end
    else
      EncKeyring := FEncryptingKeys;

    Writer := TElPGPWriter.Create(nil);
    try
      Writer.EncryptingKeys := EncKeyring;
      Writer.Timestamp := Now;
      Writer.Armor := true;

      Writer.EncryptionType := EncryptionType;
      Writer.Protection := Protection;
      Writer.Passphrases.Assign(Passphrases);

      Writer.ArmorBoundary := Boundary;
      Writer.ArmorHeaders.Add('Version: StalkerSTS');
      Writer.Filename := '';
      Writer.Compress := FCompress;
      Writer.OnKeyPassphrase := HandleWriterKeyPassphrase;
      Destination.Position := 0;
      Dest := TAnsiStringStream.Create;
      try
        Writer.Encrypt(Destination, Dest {$ifndef HAS_DEF_PARAMS}, 0{$endif});
        FAssemblingOuterHeaders := true;
        try
          FElMessagePart.Header.Assemble(Hdr, Charset, HeaderEncoding, Self);
        finally
          FAssemblingOuterHeaders := false;
        end;
        Hdr := Hdr + #13#10;
        Destination.Clear {$ifndef HAS_DEF_PARAMS}(0){$endif};
        WriteStringToStream(Hdr, Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((BodyStub), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream(('--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((VersionPart), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream(('--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((EncPartHeaders), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        Dest.Position := 0;
        WriteStreamToStream(Dest, Destination {$ifndef HAS_DEF_PARAMS}, -1, nil{$endif});
        WriteStringToStream((#13#10#13#10'--' + fBoundary + '--'#13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
      finally
        Dest.Free;
      end;
    finally
      Writer.Free;
    end;
  end;

  procedure Sign;
  var
    Writer : TElPGPWriter;
    Dest, Temp : TAnsiStringStream;
    Hdr : AnsiString;
    SgnKeyring : TElPGPKeyring;
  const
    Boundary = 'PGP SIGNATURE';
    BodyStub = 'This is an OpenPGP/MIME signed message (RFC 2440 and 3156)'#13#10;
    SigPartHeaders = 'Content-Type: application/pgp-signature; name="signature.asc"'#13#10'Content-Description: OpenPGP digital signature'#13#10'Content-Disposition: attachment; filename="signature.asc"'#13#10#13#10;
  begin
    if not FIgnoreHeaderSigners then
    begin
      if FElMessagePart.ParentMessage = nil then
      begin
        FErrors := FErrors + [pmeNoSigners];
        Exit;
      end;
      FInternalKeyrings[0].Clear;
      if (not CheckSenderKeysForAvailability(FElMessagePart.ParentMessage.From,
        FInternalKeyrings[0])) then
      begin
        FErrors := FErrors + [pmeSenderKeyNotFound];
        Exit;
      end;
      SgnKeyring := FInternalKeyrings[0];
    end
    else
      SgnKeyring := FSigningKeys;

    Writer := TElPGPWriter.Create(nil);
    try
      Writer.SigningKeys := SgnKeyring;
      Writer.Timestamp := Now;
      Writer.Armor := true;
      Writer.ArmorBoundary := Boundary;
      Writer.ArmorHeaders.Add('Version: StalkerSTS');
      Writer.Filename := '';
      Writer.InputIsText := true;
      Writer.OnKeyPassphrase := HandleWriterKeyPassphrase;
      Destination.Position := 0;
      Dest := TAnsiStringStream.Create;
      try
        Writer.Sign(Destination, Dest, true {$ifndef HAS_DEF_PARAMS}, 0{$endif});
        FAssemblingOuterHeaders := true;
        try
          FElMessagePart.Header.Assemble(Hdr, Charset, HeaderEncoding, Self);
        finally
          FAssemblingOuterHeaders := false;
        end;
        Hdr := Hdr + #13#10;
        Temp := TAnsiStringStream.Create;
        try
          Destination.Position := 0;
          WriteStreamToStream(Destination, Temp {$ifndef HAS_DEF_PARAMS}, -1, nil{$endif});
          Temp.Position := 0;
          Destination.Clear {$ifndef HAS_DEF_PARAMS}(0){$endif};
          WriteStringToStream(Hdr, Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
          WriteStringToStream((BodyStub), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
          WriteStringToStream(('--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
          WriteStreamToStream(Temp, Destination {$ifndef HAS_DEF_PARAMS}, -1, nil{$endif});
          WriteStringToStream((#13#10'--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
          WriteStringToStream((SigPartHeaders), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
          Dest.Position := 0;
          WriteStreamToStream(Dest, Destination {$ifndef HAS_DEF_PARAMS}, -1, nil{$endif});
          WriteStringToStream((#13#10#13#10'--' + fBoundary + '--'#13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        finally
          Temp.Free;
        end;
      finally
        Dest.Free;
      end;
    finally
      Writer.Free;
    end;
  end;

  procedure EncryptAndSign;
  var
    Writer : TElPGPWriter;
    Dest : TAnsiStringStream;
    Hdr : AnsiString;
    EncKeyring, SgnKeyring : TElPGPKeyring;
  const
    Boundary = 'PGP MESSAGE';
    BodyStub = 'This is an OpenPGP/MIME encrypted message (RFC 2440 and 3156)'#13#10;
    VersionPart = 'Content-Type: application/pgp-encrypted'#13#10'Content-Description: PGP/MIME version identification'#13#10#13#10'Version: 1'#13#10#13#10;
    EncPartHeaders = 'Content-Type: application/octet-stream; name="encrypted.asc"'#13#10'Content-Description: OpenPGP encrypted message'#13#10'Content-Disposition: inline; filename="encrypted.asc"'#13#10#13#10;
  begin
    if not FIgnoreHeaderRecipients then
    begin
      if FElMessagePart.ParentMessage = nil then
      begin
        FErrors := FErrors + [pmeNoRecipients];
        Exit;
      end;
      FInternalKeyrings[0].Clear;
      if (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.To_,
        FInternalKeyrings[0])) or
        (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.CC,
        FInternalKeyrings[0])) or
        (not CheckRecipientKeysForAvailability(FElMessagePart.ParentMessage.BCC,
        FInternalKeyrings[0])) then
      begin
        FErrors := FErrors + [pmeRecipientKeyNotFound];
        Exit;
      end;
      EncKeyring := FInternalKeyrings[0];
    end
    else
      EncKeyring := FEncryptingKeys;

    if not FIgnoreHeaderSigners then
    begin
      if FElMessagePart.ParentMessage = nil then
      begin
        FErrors := FErrors + [pmeNoSigners];
        Exit;
      end;
      FInternalKeyrings[1].Clear;
      if (not CheckSenderKeysForAvailability(FElMessagePart.ParentMessage.From,
        FInternalKeyrings[1])) then
      begin
        FErrors := FErrors + [pmeSenderKeyNotFound];
        Exit;
      end;
      SgnKeyring := FInternalKeyrings[1];
    end
    else
      SgnKeyring := FSigningKeys;

    Writer := TElPGPWriter.Create(nil);
    try
      Writer.EncryptingKeys := EncKeyring;
      Writer.SigningKeys := SgnKeyring;
      Writer.Timestamp := Now;
      Writer.Armor := true;
      Writer.Compress := FCompress;
      Writer.EncryptionType := etPublicKey;
      Writer.ArmorBoundary := Boundary;
      Writer.ArmorHeaders.Add('Version: StalkerSTS');
      Writer.Filename := '';
      Writer.OnKeyPassphrase := HandleWriterKeyPassphrase;
      Writer.CompressionAlgorithm := CompressionAlgorithm;
      Writer.HashAlgorithm := HashAlgorithm;
      Writer.SymmetricKeyAlgorithm := SymmetricKeyAlgorithm;
      Writer.UseNewFeatures := UseNewFeatures;
      Writer.UseOldPackets := UseOldPackets;

      Destination.Position := 0;
      Dest := TAnsiStringStream.Create;
      try
        Writer.EncryptAndSign(Destination, Dest {$ifndef HAS_DEF_PARAMS}, 0{$endif});
        FAssemblingOuterHeaders := true;
        try
          FElMessagePart.Header.Assemble(Hdr, Charset, HeaderEncoding, Self);
        finally
          FAssemblingOuterHeaders := false;
        end;
        Hdr := Hdr + #13#10;
        Destination.Clear {$ifndef HAS_DEF_PARAMS}(0){$endif};
        WriteStringToStream(Hdr, Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((BodyStub), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream(('--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((VersionPart), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream(('--' + fBoundary + #13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        WriteStringToStream((EncPartHeaders), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        Dest.Position := 0;
        WriteStreamToStream(Dest, Destination {$ifndef HAS_DEF_PARAMS}, -1, nil{$endif});
        WriteStringToStream((#13#10#13#10'--' + fBoundary + '--'#13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
      finally
        Dest.Free;
      end;
    finally
      Writer.Free;
    end;
  end;

const
  EncryptedContentType = 'Content-Type: multipart/encrypted;'#13#10#9'protocol="application/pgp-encrypted";'#13#10#9;
  SignedContentType = 'Content-Type: multipart/signed; micalg=pgp-sha1;'#13#10#9'protocol="application/pgp-signature";'#13#10#9;
begin
  Result := EL_OK;
  bIsHandled := false;
  if bStopAssemble then
  begin
    if State = astAfter then
    begin
      Exit;
    end;
  end;

  if (State <> astBefore) and 
     (FType = pmtUnknown) then
    Exit;

  case State of
    astBefore:
    begin
      FAssemblingOuterHeaders := false;
      if (not (FSign or FEncrypt)) or (FElMessagePart.ParentMessage = nil) then
        Exit; 
      if FSign and FEncrypt then
        FType := pmtSignedEncrypted
      else if FSign then
        FType := pmtSigned
      else if FEncrypt then
        FType := pmtEncrypted
      else
      begin
        FErrors := FErrors + [pmeActionNotSelected];
        Result := EL_HANDLERR_ERROR;
        Exit;
      end;
      FBoundary := TElMultiPartList.GenerateBoundary;
    end;
    astAfter:
    begin
      if not (bIsHandled or bStopAssemble) then
      begin
        if FType = pmtEncrypted then
          Encrypt
        else if FType = pmtSigned then
          Sign
        else if FType = pmtSignedEncrypted then
          EncryptAndSign
        else
          FErrors := FErrors + [pmeActionNotSelected];

        if FErrors <> [] then
        begin
          Result := EL_HANDLERR_ERROR;
          Exit;
        end;
      end;
    end;
    astAddressFieldBefore:
    begin
      { skipping all address fields, as they should not appear in encrypted message part }
      if not FAssemblingOuterHeaders then
        bIsHandled := true;
    end;
    astHeaderFieldItem:
    begin
      if FAssemblingOuterHeaders then
      begin
        h := fElMessagePart.Header.GetField(Item);
        if Assigned(h) then
        begin
          if WideSameText(h.Name, 'Content-Type') then
          begin
            bIsHandled := true;
            case FType of
              pmtEncrypted,
              pmtSignedEncrypted :
              begin
                WriteStringToStream((EncryptedContentType), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
                if HeaderEncoding = he8bit then
                  WriteStringToStream(('charset="' + (Charset) + '";'#13#10#09), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
                WriteStringToStream(('boundary="' + fBoundary + '"'#13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
              end;
              pmtSigned:
              begin
                WriteStringToStream((SignedContentType), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
                if HeaderEncoding = he8bit then
                  WriteStringToStream(('charset="' + (Charset) + '";'#13#10#09), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
                WriteStringToStream(('boundary="' + fBoundary + '"'#13#10), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
              end;
            end;
          end
          else if WideSameText(h.Name, 'Content-Transfer-Encoding') or
            WideSameText(h.Name, 'Content-Disposition') then
            bIsHandled := true;
        end;
      end
      else
      begin
        h := fElMessagePart.Header.GetField(Item);
        if Assigned(h) then
          bIsHandled := not (WideSameText(h.Name, 'Content-Type')
            or WideSameText(h.Name, 'Content-Transfer-Encoding')
            or WideSameText(h.Name, 'Content-Disposition')
            or WideSameText(h.Name, 'Content-Description')
            or WideSameText(h.Name, 'Content-ID')
            or WideSameText(h.Name, 'Content-Location'));
      end;
    end;
  end;
end;

function TElMessagePartHandlerPGPMime.OnParse(Source: TElNativeStream;
  const Boundary, HeaderCharset, BodyCharset: AnsiString;
  AOptions: TElMessageParsingOptions; IgnoreHeaderNativeCharset,
  IgnoreBodyNativeCharset, bActivatePartHandlers: Boolean;
  State: TElOnParseState; Item: Integer;
  var bIsHandled, bStopParse: Boolean
): ELMIMERESULT;
begin
  Result := El_OK;
  if (State = pstDecode) and 
     not (bIsHandled  and bStopParse) then
  begin
    if DecodePGPMime(HeaderCharset, BodyCharset, AOptions,
      IgnoreHeaderNativeCharset, IgnoreBodyNativeCharset, bActivatePartHandlers {$ifndef HAS_DEF_PARAMS}, nil{$endif})
    then
    begin
      if fErrors = [pmeUnverifiableSignature] then
        Result := EL_WARNING
      else
      if pmeInvalidSignature in fErrors then
        Result := EL_HANDLERR_ERROR
      else
        Result := EL_OK;
    end
    else
    begin
      Result := EL_HANDLERR_ERROR;
    end
  end;
end;

procedure TElMessagePartHandlerPGPMime.SetError;
var
  i : TSBPGPMIMEError;
begin
  fErrorText := '';
  for i := High(TSBPGPMIMEError) downto Low(TSBPGPMIMEError) do
  begin
    if i in fErrors then
    case i of
      pmeUnknown :
        FErrorText := FErrorText + ' Unknown error.';
      pmePGPPartNotFound :
        FErrorText := FErrorText + ' PGP part not found.';
      pmeInvalidSignature :
        FErrorText := FErrorText + ' Invalid signature.';
      pmeRecipientKeyNotFound :
        FErrorText := FErrorText + ' Recipient''s key not found.';
      pmeSenderKeyNotFound :
        FErrorText := FErrorText + ' Sender''s key not found.';
      pmeNoRecipients :
        FErrorText := FErrorText + ' No recipients.';
      pmeNoSigners :
        FErrorText := FErrorText + ' No signers.';
      pmeActionNotSelected :
        FErrorText := FErrorText + ' Action (encryption/signing) not selected.';
      pmeUnverifiableSignature:
        FErrorText := FErrorText + ' Some signatures can not be verified. ';
    end;
  end;
end;

procedure TElMessagePartHandlerPGPMime.SetPassphrases(Value : TStringList);
begin
  FPassphrases.Assign(Value);
end;

procedure TElMessagePartHandlerPGPMime.SetDecryptingKeys(Value: TElPGPKeyring);
begin
  FDecryptingKeys := Value;
end;

procedure TElMessagePartHandlerPGPMime.SetVerifyingKeys(Value: TElPGPKeyring);
begin
  FVerifyingKeys := Value;
end;

procedure TElMessagePartHandlerPGPMime.SetEncryptingKeys(Value: TElPGPKeyring);
begin
  FEncryptingKeys := Value;
end;

procedure TElMessagePartHandlerPGPMime.SetSigningKeys(Value: TElPGPKeyring);
begin
  FSigningKeys := Value;
end;

function TElMessagePartHandlerPGPMime.DecodePGPMime( const HeaderCharset,
  BodyCharset: AnsiString; AOptions: TElMessageParsingOptions;
  IgnoreHeaderNativeCharset, IgnoreBodyNativeCharset: Boolean;
  bActivatePartHandlers: Boolean {$ifdef HAS_DEF_PARAMS}= False{$endif};
  RootHandler: TElMessagePartHandlerPGPMime {$ifdef HAS_DEF_PARAMS}= nil {$endif}): Boolean;

  function IsSigned(mp: TElMessagePart) : boolean;
  var
    h : TElMessageHeaderField;
    wsParam: TWideString;
  begin
    Result := false;
    if mp = nil then
      Exit;
    if (mp.IsMultipart) and (mp.PartsCount = 2) then
    begin
      h := mp.Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if h = nil then
        Exit;
      if not WideSameText(h.Value, 'multipart/signed') then
        Exit;
      wsParam := h.GetParamValue('micalg');
      if Length(wsParam) = 0 then
        Exit;
      wsParam := h.GetParamValue('protocol');
      if not WideSameText(wsParam, 'application/pgp-signature') then
        Exit;
      h := mp.GetPart(1).Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if h = nil then
        Exit;
      if not WideSameText(h.Value, 'application/pgp-signature') then
        Exit;
      Result := True;
    end;
  end;

  function IsEncrypted(mp: TElMessagePart) : boolean;
  var
    h : TElMessageHeaderField;
    wsParam: TWideString;
  begin
    Result := false;
    if mp = nil then
      Exit;
    if (mp.IsMultipart) and (mp.PartsCount = 2) then
    begin
      h := mp.Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if h = nil then
        Exit;
      if not WideSameText(h.Value, 'multipart/encrypted') then
        Exit;
      wsParam := h.GetParamValue('protocol');
      if WideSameText(wsParam, 'application/pgp-encrypted') then
        Result := True;
      h := mp.GetPart(0).Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if h = nil then
        Exit;
      if not WideSameText(h.Value, 'application/pgp-encrypted') then
        Exit;
      h := mp.GetPart(1).Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if h = nil then
        Exit;
      if not WideSameText(h.Value, 'application/octet-stream') then
        Exit;
    end;
  end;

  procedure SetupReader(Reader : TElPGPReader);
  begin
    Reader.OnEncrypted := HandleReaderEncrypted;
    Reader.OnCreateOutputStream := HandleReaderCreateOutputStream;
    Reader.OnKeyPassphrase := HandleReaderKeyPassphrase;
    Reader.OnPassphrase := HandleReaderPassphrase;
    Reader.OnSigned := HandleReaderSigned;
    Reader.OnSignatures := HandleReaderSignatures;
    Reader.DecryptingKeys := FDecryptingKeys;
    Reader.VerifyingKeys := FVerifyingKeys;
  end;

  function DecryptPart(SrcPart: TElMessagePart; var DestPart: TElMessagePart) : boolean;
  var
    Reader: TElPGPReader;
    Strm : TAnsiStringStream;
    Str : TWideString;
    h : TElMessageHeader;
    iPos : integer;
    ACharset : AnsiString;
  begin
    Strm := TAnsiStringStream.Create;
    try
      Strm.Write(SrcPart.Data[0], SrcPart.DataSize);
      Strm.Position := 0;
      Reader := TElPGPReader.Create(nil);
      try
        SetupReader(Reader);
        Reader.DecryptAndVerify(Strm {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      finally
        Reader.Free;
      end;
    finally
      Strm.Free;
    end;

    FReaderOutputStream.Position := 0;
    str := (GetHeaderFromStream(FReaderOutputStream));
    h := TElMessageHeader.Create;
    h.ProcessController := FElMessagePart.ProcessController;
    iPos := 1;
    ACharset := HeaderCharset;
    h.Parse((Str), iPos, ACharset, IgnoreHeaderNativeCharset);
    Str := '';
    if mpoStoreStream in AOptions then
    begin
      h.StreamPosBegin := 0;
      h.BodyLen := FReaderOutputStream.Position;
    end;
    DestPart := TElMessagePart.CreatePartForHeader(h, fElMessagePart.ParentMessage,
      fElMessagePart.Parent);

    Result := DestPart.Parse(
      h,
      FReaderOutputStream,
      (str),
      HeaderCharset,
      BodyCharset,
      AOptions + [mpoLoadData],
      IgnoreHeaderNativeCharset,
      IgnoreBodyNativeCharset,
      bActivatePartHandlers
    ) = El_OK;
  end;

  function VerifyPart(SrcPart, SigPart: TElMessagePart) : boolean;
  var
    Reader: TElPGPReader;
    SrcStrm, SigStrm: TAnsiStringStream;
  begin
    Result := true;
    SrcStrm := TAnsiStringStream.Create;
    try
      SrcPart.Stream.Position := SrcPart.Header.StreamPosBegin;
      WriteStreamToStream(SrcPart.Stream, SrcStrm, SrcPart.BodyLen +
        SrcPart.Header.BodyLen {$ifndef HAS_DEF_PARAMS}, nil{$endif});
      SrcStrm.Position := 0;
      SigStrm := TAnsiStringStream.Create;
      try
        SigStrm.Write(SigPart.Data[0], SigPart.DataSize);
        SigStrm.Position := 0;
        Reader := TElPGPReader.Create(nil);
        try
          SetupReader(Reader);
          Reader.VerifyDetached(SrcStrm, SigStrm {$ifndef HAS_DEF_PARAMS}, 0, 0{$endif});
        finally
          Reader.Free;
        end;
      finally
        SigStrm.Free;
      end;
    finally
      SrcStrm.Free;
    end;
  end;
  
begin
  if IsSigned(FElMessagePart) then
  begin
    FSigned := true;
    FEncrypted := false;
    Result := VerifyPart(FElMessagePart.GetPart(0), FElMessagePart.GetPart(1));
    FDecodedPart := FElMessagePart.GetPart(0).Clone;
  end
  else if IsEncrypted(FElMessagePart) then
  begin
    FSigned := false;
    FEncrypted := true;
    Result := DecryptPart(FElMessagePart.GetPart(1), FDecodedPart);
  end
  else
  begin
    FErrors := FErrors + [pmePGPPartNotFound];
    Result := false;
  end;
end;

procedure TElMessagePartHandlerPGPMime.HandleReaderEncrypted(Sender: TObject;
  const KeyIDs : TSBKeyIDs; IntegrityProtected: boolean; PassphraseUsed: boolean);
begin
  if Assigned(FOnEncrypted) then
    FOnEncrypted(Self, KeyIDs, IntegrityProtected, PassphraseUsed);
end;

procedure TElMessagePartHandlerPGPMime.HandleReaderCreateOutputStream(Sender: TObject;
  const Filename : string; TimeStamp: TDateTime; var Stream: TStream;
  var FreeOnExit: boolean);
begin
  FReaderOutputStream.Clear;
  Stream := FReaderOutputStream;
  FreeOnExit := false;
end;

procedure TElMessagePartHandlerPGPMime.HandleReaderKeyPassphrase(Sender: TObject;
  Key : TElPGPCustomSecretKey; var Passphrase: string; var Cancel: boolean);
begin
  if Assigned(FOnKeyPassphrase) then
    FOnKeyPassphrase(Self, Key, Passphrase, Cancel)
  else
    Cancel := true;
end;

procedure TElMessagePartHandlerPGPMime.HandleReaderPassphrase(Sender: TObject;
  var Passphrase: string; var Cancel : boolean);
begin
  if Assigned(FOnPassphrase) then
    FOnPassphrase(Self, Passphrase, Cancel)
  else
    Cancel := true;
end;

procedure TElMessagePartHandlerPGPMime.HandleReaderSigned(Sender: TObject;
  const KeyIDs : TSBKeyIDs; SignatureType : TSBPGPSignatureType);
begin
  if Assigned(FOnSigned) then
    FOnSigned(Self, KeyIDs, SignatureType);
end;

{$ifndef BUILDER_USED}
procedure TElMessagePartHandlerPGPMime.HandleReaderSignatures(Sender: TObject;
  Signatures: array of TElPGPSignature; Validities : array of TSBPGPSignatureValidity);
{$else}
procedure TElMessagePartHandlerPGPMime.HandleReaderSignatures(Sender: TObject;
  Signatures: TList; Validities : array of TSBPGPSignatureValidity);
{$endif}
var
  I : integer;
begin
  FSigned := true;
  if Assigned(FOnSignatures) then
    FOnSignatures(Self, Signatures, Validities);
  for I := Low(Validities) to High(Validities) do
  begin
    if Validities[I] = svCorrupted then
      FErrors := FErrors + [pmeInvalidSignature]
    else
    if Validities[I] in [svNoKey, 
                         svUnknownAlgorithm] then
      FErrors := FErrors + [pmeUnverifiableSignature];
  end;
end;

procedure TElMessagePartHandlerPGPMime.HandleWriterKeyPassphrase(Sender: TObject;
  Key : TElPGPCustomSecretKey; var Passphrase: string; var Cancel: boolean);
begin
  if Assigned(FOnKeyPassphrase) then
    FOnKeyPassphrase(Self, Key, Passphrase, Cancel)
  else
    Cancel := true;
end;

////////////////////////////////////////////////////////////////////////////////
// Public methods

function TElMessagePartHandlerPGPMime.IsSigned : boolean;
begin
  Result := FSigned;
end;

function TElMessagePartHandlerPGPMime.IsEncrypted : boolean;
begin
  Result := FEncrypted;
end;

////////////////////////////////////////////////////////////////////////////////
// Class functions

class function TElMessagePartHandlerPGPMime.IsText(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := false;
end;

class function TElMessagePartHandlerPGPMime.IsTextPlain(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := false;
end;

class function TElMessagePartHandlerPGPMime.IsMultipart(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := WideSameText(wsContentType, 'multipart/encrypted') or
    WideSameText(wsContentType, 'multipart/signed');
end;

class function TElMessagePartHandlerPGPMime.IsSupportedThisContentType(
  const wsContentType: TWideString; ContentTypeField: TElMessageHeaderField;
  Header: TElMessageHeader): Boolean;
begin
  Result := 
  (WideSameText(wsContentType, 'multipart/encrypted') and
    WideSameText(ContentTypeField.GetParamValue('protocol'), 'application/pgp-encrypted'))
    or
  (WideSameText(wsContentType, 'multipart/signed') and
    WideSameText(ContentTypeField.GetParamValue('protocol'), 'application/pgp-signature'));
end;

class function TElMessagePartHandlerPGPMime.GetDescription: TWideString;
begin
  Result := 'PGP/MIME';
end;

////////////////////////////////////////////////////////////////////////////////
// TElMessagePartHandlerPGPKeys class

constructor TElMessagePartHandlerPGPKeys.Create(aParams: TObject);
begin
  inherited Create(aParams);
  FKeys := TElPGPKeyring.Create(nil);
end;

destructor TElMessagePartHandlerPGPKeys.Destroy;
begin
  FKeys.Free;
  inherited;
end;
 
class function TElMessagePartHandlerPGPKeys.IsText(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := false;
end;
 
class function TElMessagePartHandlerPGPKeys.IsTextPlain(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := false;
end;
 
class function TElMessagePartHandlerPGPKeys.IsMultipart(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := false;
end;
 
class function TElMessagePartHandlerPGPKeys.IsSupportedThisContentType(const wsContentType: TWideString;
  ContentTypeField: TElMessageHeaderField; Header: TElMessageHeader): Boolean;
begin
  Result := WideSameText(wsContentType, 'application/pgp-keys');
end;
 
procedure TElMessagePartHandlerPGPKeys.Clear;
begin
  inherited;
  FErrors := [];
  FKeys.Clear;
end;
 
function TElMessagePartHandlerPGPKeys.Clone: TElMessagePartHandler;
var
  ph : TElMessagePartHandlerPGPKeys;
begin
  ph := TElMessagePartHandlerPGPKeys.Create(nil);
  Result := ph;
  ph.FErrors := FErrors;
  FKeys.ExportTo(ph.FKeys);
end;

function TElMessagePartHandlerPGPKeys.OnAssemble(Destination: TAnsiStringStream;
  const Charset: AnsiString; HeaderEncoding: TElHeaderEncoding;
  const BodyEncoding, AttachEncoding: AnsiString;
  State: TElOnAssembleState; Item: Integer; const sBoundary: AnsiString;
  var bIsHandled, bStopAssemble: Boolean
): ELMIMERESULT;
var
  h: TElMessageHeaderField;
const
  KeysContentType = 'Content-Type: application/pgp-keys'#13#10;
begin

  if FKeys.PublicCount = 0 then
  begin
    Result := EL_HANDLERR_ERROR;
    FErrors := FErrors + [pkeNoPublicKeys];
    Exit;
  end;

  Result := EL_OK;
  bIsHandled := false;
  if bStopAssemble then
  begin
    if State = astAfter then
    begin
      Exit;
    end;
  end;

  if (State <> astBefore) and 
     (FKeys.PublicCount = 0) then
    Exit;

  case State of
    astBefore:
    begin
      h := fElMessagePart.Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
      if not Assigned(h) then
        fElMessagePart.Header.SetField('Content-Type', 'dummy' {$ifndef HAS_DEF_PARAMS}, 0, False{$endif});
    end;
    astAfter:
    begin
      if not (bIsHandled or bStopAssemble) then
        FKeys.Save(Destination, nil, true);
      WriteStringToStream(CRLFByteArray, Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
    end;
    astAddressFieldBefore:
    begin
    end;
    astHeaderFieldItem:
    begin
      h := fElMessagePart.Header.GetField(Item);
      if Assigned(h) then
      begin
        if WideSameText(h.Name, 'Content-Type') then
        begin
          bIsHandled := true;
          WriteStringToStream((KeysContentType), Destination {$ifndef HAS_DEF_PARAMS}, 1, -1{$endif});
        end;
      end;
    end;
  end;
end;
 
function TElMessagePartHandlerPGPKeys.OnParse(Source: TElNativeStream;
  const Boundary, HeaderCharset, BodyCharset: AnsiString;
  AOptions: TElMessageParsingOptions; IgnoreHeaderNativeCharset,
  IgnoreBodyNativeCharset, bActivatePartHandlers: Boolean;
  State: TElOnParseState; Item: Integer;
  var bIsHandled, bStopParse: Boolean
): ELMIMERESULT;
begin
  Result := El_OK;
  if (State = pstDecode) and 
     not (bIsHandled and bStopParse) then
  begin
    if DecodeKeys then
    begin
      if fErrors <> [] then
        Result := EL_WARNING;
    end
    else
    begin
      Result := EL_HANDLERR_ERROR;
      FErrors := FErrors + [pkeKeysPartNotFound];
    end
  end;
end;

function TElMessagePartHandlerPGPKeys.DecodeKeys : boolean;
var
  h : TElMessageHeaderField;
  Strm: TAnsiStringStream;
begin
  h := FElMessagePart.Header.GetField('Content-Type' {$ifndef HAS_DEF_PARAMS}, 0{$endif});
  if (not FElMessagePart.IsMultipart) and (h <> nil) and
    (WideSameText(h.Value, 'application/pgp-keys')) then
  begin
    Strm := TAnsiStringStream.Create;
    try
      FElMessagePart.Stream.Position := FElMessagePart.StreamPosBegin;
      WriteStreamToStream(FElMessagePart.Stream, Strm, FElMessagePart.BodyLen {$ifndef HAS_DEF_PARAMS}, nil{$endif});
      Strm.Position := 0;
      FKeys.Load(Strm, nil, true);
    finally
      Strm.Free;
    end;
    FDecodedPart := FElMessagePart;
    Result := true;
  end
  else
    Result := false;
end;

procedure TElMessagePartHandlerPGPKeys.SetError;
var
  i : TSBPGPKeysError;
begin
  fErrorText := '';
  for i := High(TSBPGPKeysError) downto Low(TSBPGPKeysError) do
  begin
    if i in fErrors then
    case i of
      pkeUnknown :
        FErrorText := FErrorText + ' Unknown error.';
      pkeKeysPartNotFound :
        FErrorText := FErrorText + ' Keys not found.';
      pkeNoPublicKeys :
        FErrorText := FErrorText + ' No public keys.';
    end;
  end;
end;

class function TElMessagePartHandlerPGPKeys.GetDescription: TWideString;
begin
  Result := 'PGP/Keys';
end;


procedure TElSimplePGPMIMEMessage.SetEncryptingKeys(Value: TElPGPKeyring);
begin
  FEncryptingKeys := Value;
end;

procedure TElSimplePGPMIMEMessage.SetPGPMIMEOptions(const Value:
    TElSimplePGPMIMEOptions);
begin
  FPGPMIMEOptions.Assign(Value);
end;

procedure TElSimplePGPMIMEMessage.SetSigningKeys(Value: TElPGPKeyring);
begin
  FSigningKeys := Value;
end;

constructor TElSimplePGPMIMEOptions.Create;
begin
  inherited;
  FPassphrases := TElStringList.Create;
  FEncryptionType := etPublicKey;
  FProtection := ptNormal;

  FSymmetricKeyAlgorithm := SB_PGP_ALGORITHM_SK_CAST5;
end;

destructor TElSimplePGPMIMEOptions.Destroy;
begin
  FreeAndNil(FPassphrases);
  inherited;
end;

procedure TElSimplePGPMIMEOptions.Assign(Source : TPersistent);
begin
  Self.FSignMessage := TElSimplePGPMIMEOptions(Source).FSignMessage;
  Self.FEncryptMessage := TElSimplePGPMIMEOptions(Source).FEncryptMessage;
  Self.FCompressMessage := TElSimplePGPMIMEOptions(Source).FCompressMessage;
  Self.FHashAlgorithm := TElSimplePGPMIMEOptions(Source).FHashAlgorithm;
  Self.FCompressionAlgorithm := TElSimplePGPMIMEOptions(Source).FCompressionAlgorithm;
  Self.FSymmetricKeyAlgorithm := TElSimplePGPMIMEOptions(Source).FSymmetricKeyAlgorithm;
  Self.FUseOldPackets := TElSimplePGPMIMEOptions(Source).FUseOldPackets;
  Self.FUseNewFeatures := TElSimplePGPMIMEOptions(Source).FUseNewFeatures;
  Self.FEncryptionType := TElSimplePGPMIMEOptions(Source).EncryptionType;
  Self.Protection := TElSimplePGPMIMEOptions(Source).Protection;
  Self.Passphrases.Assign(TElSimplePGPMIMEOptions(Source).Passphrases);
end;

procedure TElSimplePGPMIMEOptions.SetPassphrases(Value : TStringList);
begin
  FPassphrases.Assign(Value);
end;

constructor TElSimplePGPMIMEMessage.Create(AOwner: TSBComponentBase);
begin
  inherited Create(AOwner);
  FPGPMIMEOptions := TElSimplePGPMIMEOptions.Create;
end;


destructor TElSimplePGPMIMEMessage.Destroy;
begin
  FreeAndNil(FPGPMIMEOptions);
  inherited Destroy;
end;

procedure TElSimplePGPMIMEMessage.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited;
  if (AComponent = FEncryptingKeys) and (Operation = opRemove) then
    EncryptingKeys := nil;
  if (AComponent = FSigningKeys) and (Operation = opRemove) then
    SigningKeys := nil;
end;

function TElSimplePGPMIMEMessage.DoAssemble(Stream: TStream): Integer;
var Message : TElMessage;
    pgpmime: TElMessagePartHandlerPGPMime;
begin
  Message := FMessage;

  pgpmime := TElMessagePartHandlerPGPMime.Create(nil);
  pgpmime.EncryptingKeys := EncryptingKeys;
  pgpmime.SigningKeys := FSigningKeys;
  Message.MainPart.MessagePartHandler := pgpmime;
  pgpmime.IgnoreHeaderRecipients := FPGPMIMEOptions.IgnoreHeaderRecipients;
  pgpmime.IgnoreHeaderSigners := FPGPMIMEOptions.IgnoreHeaderSigners;
  pgpmime.CompressionAlgorithm := FPGPMIMEOptions.CompressionAlgorithm;
  pgpmime.HashAlgorithm := FPGPMIMEOptions.HashAlgorithm;
  pgpmime.SymmetricKeyAlgorithm := FPGPMIMEOptions.SymmetricKeyAlgorithm;
  pgpmime.UseNewFeatures := FPGPMIMEOptions.UseNewFeatures;
  pgpmime.UseOldPackets := FPGPMIMEOptions.UseOldPackets;
  pgpmime.EncryptionType := FPGPMIMEOptions.EncryptionType;
  pgpmime.Passphrases := FPGPMIMEOptions.Passphrases;
  pgpmime.Protection := FPGPMIMEOptions.Protection;

  pgpmime.OnKeyPassphrase := OnKeyPassphrase;
  pgpmime.OnEncryptingKeyNotFound := Self.OnEncryptingKeyNotFound;
  pgpmime.OnSigningKeyNotFound := Self.OnSigningKeyNotFound;

  pgpmime.Sign := FPGPMIMEOptions.FSignMessage;
  pgpmime.Encrypt := FPGPMIMEOptions.FEncryptMessage;
  pgpmime.Compress := FPGPMIMEOptions.FCompressMessage;
  Result := inherited DoAssemble(Stream);
end;


////////////////////////////////////////////////////////////////////////////////
// Initialization/finalization

procedure Initialize;
begin
  RegisteredMessagePartHandlers.AddHandler(TElMessagePartHandlerPGPMime);
  RegisteredMessagePartHandlers.AddHandler(TElMessagePartHandlerPGPKeys);
end;

initialization
  Initialize;

finalization
  RegisteredMessagePartHandlers.RemoveHandler(TElMessagePartHandlerPGPMime);
  RegisteredMessagePartHandlers.RemoveHandler(TElMessagePartHandlerPGPKeys);


end.
